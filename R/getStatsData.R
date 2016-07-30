#' getStatsData API
#'
#' Get some statistical data via e-Stat API.
#'
#' @param appId application ID
#' @param statsDataId ID of the statistical dataset
#' @param startPosition Integer. The the first record to get.
#' @param limit Integer. Max number of records to get.
#' @param ... Other parameters like \code{lvCat01} and \code{cdCat01}.
#'    See \code{Other parameters} section for more details.
#'
#' @seealso
#' \url{http://www.e-stat.go.jp/api/e-stat-manual/#api_2_3}
#' \url{http://www.e-stat.go.jp/api/e-stat-manual/#api_3_4}
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
#' estat_getStatsData(
#'   appId = "XXXX",
#'   statsDataId = "0003065345",
#'   cdCat01 = c("008", "009", "010"),
#'   limit = 3
#' )
#' }
#'
#' @export
estat_getStatsData <- function(appId, statsDataId,
                               startPosition = NULL,
                               limit = NULL,
                               .aquire_all = TRUE,
                               ...)
{
  result <- list()
  LIMIT <- 100000

  if (.aquire_all) {
    record_count <- estat_getStatsDataCount(appId, statsDataId, ...)
    if (is.null(limit)) {
      max_count <- limit <- record_count
    } else {
      max_count <- min(limit, record_count)
    }

    starts <- seq(from = 1, to = max_count, by = LIMIT)
    limits <- c(rep(LIMIT, length(starts) - 1), limit %% LIMIT)
  } else {
    starts <- startPosition
    limits <- limit
  }

  for (i in seq_along(starts)) {
    message(sprintf("Aquiring %.0f records from %.0f (Total %.0f records)...\n",
                    limits[i], starts[i], max_count))

    result_text <- estat_api("rest/2.1/app/getSimpleStatsData",
                             appId = appId,
                             statsDataId = statsDataId,
                             startPosition = format(starts[i], scientific = FALSE),
                             limit = format(limits[i], scientific = FALSE),
                             sectionHeaderFlg = 2, # Skip metadata section
                             ...)

    # The result text should be like:
    #
    # "VALUE"
    # "tab_code","XXXX","cat01_code","YYYY",...
    result[[i]] <- readr::read_csv(result_text, skip = 1,
                                                         col_types = readr::cols(
                                                           value    = readr::col_number(),
                                                           .default = readr::col_character()
                                                         ))
  }

  dplyr::bind_rows(result)
}

#' @rdname estat_getStatsData
#' @export
estat_getSimpleStatsData <- estat_getStatsData

