#' getStatsData API
#'
#' Get some statistical data via e-Stat API.
#'
#' @param appId application ID
#' @param statsDataId ID of the statistical dataset
#' @param startPosition Integer. The the first record to get.
#' @param limit Integer. Max number of records to get.
#' @param lang Language of data. \code{"J"}(Japanese) or \code{"E"}(English).
#' @param .fetch_all Whether to fetch all records when the number of records
#'                    is larger than 100,000.
#' @param ... Other parameters like \code{lvCat01} and \code{cdCat01}.
#'    See \code{Other parameters} section for more details.
#'
#' @seealso
#' \url{http://www.e-stat.go.jp/api/e-stat-manual2-1/#api_2_3}
#' \url{http://www.e-stat.go.jp/api/e-stat-manual2-1/#api_3_4}
#' @section Other parameters:
#' For every detailed information, please visit the URL in See Also.
#' \itemize{
#'  \item \code{lvTab}:
#'    Level of the meta-information. The format can be \code{X} or \code{X-Y}, \code{-X} and \code{X-}.
#'  \item \code{cdTab}:
#'    Code(s) of the meta-infomation items to select. The format can be a character vector (\code{c("001", "002")}) or
#'    a chraracter of values and commas (\code{"001,002"}).
#'  \item \code{cdTabFrom}:
#'    The code of the first meta-information item to select.
#'  \item \code{cdTabTo}:
#'    The code of the last meta-information item to select.
#'  \item \code{lvTime}:
#'     Level of the time to select. The format is the same as \code{lvTab}
#'  \item \code{cdTime}
#'     Time(s) to select. The format is the same way like \code{cdTab}
#'  \item \code{cdTimeFrom}:
#'    The first time to select. The format is the same way like \code{cdTabFrom}
#'  \item \code{cdTimeTo}:
#'    The last time to select. The format is the same way like \code{cdTabTo}
#'  \item \code{lvArea}:
#'     Level of the area to select. The format is the same as \code{lvTab}
#'  \item \code{cdArea}
#'     Code(s) of the Area to select. The format is the same way like \code{cdTab}
#'  \item \code{cdAreaFrom}:
#'    The code of the first area to select. The format is the same way like \code{cdTabFrom}
#'  \item \code{cdAreaTo}:
#'    The code of the last area to select. The format is the same way like \code{cdTabTo}
#'  \item \code{lvCat01}, \code{cdCat01}, \code{cdCat01From}, \code{cdCat01To}, ...:
#'    The same way like above.
#' }
#'
#' @examples
#' \dontrun{
#' # fetch all data, which may take time
#' estat_getStatsData(
#'   appId = "XXXX",
#'   statsDataId = "0003065345"
#' )
#'
#' # fetch data up to 10 records
#' estat_getStatsData(
#'   appId = "XXXX",
#'   statsDataId = "0003065345",
#'   limit = 10
#' )
#'
#' # fetch data up to 100,000 records (max number of records available at once)
#' estat_getStatsData(
#'   appId = "XXXX",
#'   statsDataId = "0003065345",
#'   .fetch_all = FALSE
#' )
#'
#' # fetch all data in the specifed category
#' estat_getStatsData(
#'   appId = "XXXX",
#'   statsDataId = "0003065345",
#'   cdCat01 = c("008", "009", "010")
#' )
#'
#' }
#'
#' @export
estat_getStatsData <- function(appId, statsDataId,
                               startPosition = NULL,
                               limit = NULL,
                               lang = c("J", "E"),
                               .fetch_all = TRUE,
                               ...)
{
  lang <- match.arg(lang)

  tabs <- get_tabs(appId = appId, statsDataId = statsDataId, cdTab = list(...)$cdTab)

  if (is.null(tabs)) {
    total_record_count <- estat_getStatsDataCount(appId, statsDataId, lang = lang, ...)
    ranges <- calc_ranges(startPosition, limit, total_record_count, .fetch_all)
  } else {
    ranges <- list()
    for (tab in tabs) {
      record_count <- estat_getStatsDataCount(appId, statsDataId, lang = lang, cdTab = tab, ...)
      ranges[[tab]] <- calc_ranges(startPosition, limit, record_count, .fetch_all)

      if (!is.null(limit)) {
        limit <- limit - record_count
        if (limit < 1) break
      }
    }
    ranges <- dplyr::bind_rows(ranges, .id = "tab")
    total_record_count <- sum(ranges$limits)
  }

  result <- list()

  for (i in seq_len(nrow(ranges))) {
    cur_tab   <- if(is.null(tabs)) NULL else ranges$tab[i]
    cur_limit <- ranges$limits[i]
    cur_start <- ranges$starts[i]

    message(sprintf("Fetching %.0f records of cdTab=%s... (total: %.0f records)\n",
                    cur_limit, cur_tab, total_record_count))

    result[[i]] <- estat_api("rest/2.1/app/getSimpleStatsData",
                             appId = appId,
                             statsDataId = statsDataId,
                             startPosition = format(cur_start, scientific = FALSE),
                             limit = format(cur_limit, scientific = FALSE),
                             cdTab = cur_tab,
                             lang = lang,
                             sectionHeaderFlg = 2, # Skip metadata section
                             ...)
  }

  dplyr::bind_rows(result)
}


#' @rdname estat_getStatsData
#' @export
estat_getSimpleStatsData <- estat_getStatsData


estat_getStatsDataCount <- function(appId, statsDataId, ...)
{
  j <- estat_api("rest/2.1/app/json/getStatsData",
                 appId = appId,
                 statsDataId = statsDataId,
                 metaGetFlg = "N",
                 cntGetFlg = "Y",
                 ...)

  as.numeric(j$GET_STATS_DATA$STATISTICAL_DATA$RESULT_INF$TOTAL_NUMBER)
}


calc_ranges <- function(startPosition,
                        limit,
                        record_count,
                        .fetch_all,
                        .max_records_at_once = 100000) {
  ranges <- list()

  if (is.null(startPosition)) {
    startPosition <- 1
  }

  if (is.null(limit)) {
    endPosition <- record_count
  } else {
    endPosition <- min(startPosition + limit - 1, record_count)
  }

  if (.fetch_all) {
    ranges$starts <- seq(from = startPosition, to = endPosition, by = .max_records_at_once)
    ranges$limits <- rep(.max_records_at_once, length(ranges$starts))
    # treat a fraction
    fraction <- (endPosition - startPosition + 1) %% .max_records_at_once
    if (fraction != 0) {
      ranges$limits[length(ranges$limits)] <- fraction
    }
  } else {
    ranges$starts <- startPosition
    ranges$limits <- min(startPosition + .max_records_at_once - 1, endPosition)
  }

  dplyr::as_data_frame(ranges)
}

# cdTab may be (1) NULL, (2) a vector of strings or (3) a string of numbers separated by ","
get_tabs <- function(appId, statsDataId, cdTab) {
  if (is.null(cdTab)) {
    # when (1), try to get all tab from getMetaInfo API
    meta_info <- estat_getMetaInfo(appId = appId, statsDataId = statsDataId)

    # tab does not always exist.
    if (!is.null(meta_info$tab)) {
      meta_info$tab$`@code`
    } else {
      NULL
    }
  } else {
    # when (2) or (3), split it by ","
    unlist(strsplit(cdTab, ",", fixed = TRUE))
  }
}
