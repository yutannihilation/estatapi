#' getStatsList API
#'
#' Search for statistical datasets via e-Stat API.
#'
#' @param appId Application ID
#' @param searchWord Keyword for searching. You can use \code{OR} and \code{AND}. (e.g.: \code{apple AND orrange}).
#' @param lang Language of data. \code{"J"}(Japanese) or \code{"E"}(English).
#' @param .use_label Whether to take the human-redable label value or the code value when flattening a field containing both.
#'        (default: \code{TRUE})
#' @param surveyYears Year and month when the survey was conducted. The format is either \code{YYYY}, \code{YYYYMM}, or \code{YYYYMM-YYYYMM}
#' @param openYears Year and month when the survey result was opened. The format is the same as \code{surveyYears}
#' @param statsField Field of statistics. The format is either two digits (large classification) or
#'    four digits (small classification). For the detail of the classification, see
#'    \url{http://www.soumu.go.jp/toukei_toukatsu/index/seido/sangyo/26index.htm}
#' @param statsCode Code assigned for each statistical agency and statistics. The format can be
#'     five digits (agency), and eight digits (statistics). For the detail, see
#'     \url{http://www.stat.go.jp/info/guide/public/code/code.htm}.
#' @param searchKind Type of statistics. \code{1}: summary, \code{2}: regional mesh, \code{3}: Sensus.
#' @param startPosition Integer. The the first record to get.
#' @param limit Integer. Max number of records to get.
#' @param updatedDate Last updated date. The format is either \code{YYYY}, \code{YYYYMM}, \code{YYYYMMDD}, \code{YYYYMMDD-YYYYMMDD}
#' @param ... Other parameters.
#'
#' @seealso
#' \url{http://www.e-stat.go.jp/api/e-stat-manual2-1/#api_2_1}
#' \url{http://www.e-stat.go.jp/api/e-stat-manual2-1/#api_3_2}
#'
#' @examples
#' \dontrun{
#' estat_getStatsList(
#'   appId = "XXXX",
#'   searchWord = "CD",
#'   limit = 3
#' )
#' }
#' @export
estat_getStatsList <- function(appId, searchWord,
                               lang = c("J", "E"),
                               .use_label = TRUE,
                               surveyYears = NULL,
                               openYears = NULL,
                               statsField = NULL,
                               statsCode = NULL,
                               searchKind = NULL,
                               startPosition = NULL,
                               limit = NULL,
                               updatedDate = NULL,
                               ...) {
  lang <- match.arg(lang)

  j <- estat_api("rest/2.0/app/json/getStatsList", appId = appId, searchWord = searchWord,
                 lang = lang,
                 surveyYears = surveyYears,
                 openYears = openYears,
                 statsField = statsField,
                 statsCode = statsCode,
                 searchKind = searchKind,
                 startPosition = startPosition,
                 limit = limit,
                 updatedDate = updatedDate,
                 ...)

  j$GET_STATS_LIST$DATALIST_INF$TABLE_INF %>%
    purrr::map(as_flattened_character, .use_label = .use_label) %>%
    dplyr::bind_rows()
}
