#' getStatsData API
#'
#' Get some statistical data via e-Stat API.
#'
#' @param appId application ID
#' @param statsDataId ID of the statistical dataset
#' @param startPosition Integer. The the first record to get.
#' @param limit Integer. Max number of records to get.
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
                               .fetch_all = TRUE,
                               ...)
{
  result <- list()

  record_count <- estat_getStatsDataCount(appId, statsDataId, ...)
  ranges <- calc_ranges(startPosition, limit, record_count, .fetch_all)

  for (i in seq_along(ranges$starts)) {
    message(sprintf("Fetching %.0f records (%.0f-%.0f / %.0f)\n",
                    ranges$limits[i], ranges$starts[i],
                    ranges$starts[i] - ranges$limits[i], record_count))

    result[[i]] <- estat_api("rest/2.1/app/getSimpleStatsData",
                             appId = appId,
                             statsDataId = statsDataId,
                             startPosition = format(ranges$starts[i], scientific = FALSE),
                             limit = format(ranges$limits[i], scientific = FALSE),
                             sectionHeaderFlg = 2, # Skip metadata section
                             ...)
  }

  dplyr::bind_rows(result)
}


#' @rdname estat_getStatsData
#' @export
estat_getSimpleStatsData <- estat_getStatsData


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

  ranges
}
