#' getStatsList API
#'
#' Search for statistical datasets via e-Stat API.
#'
#' @inheritParams estat_getStatsData
#' @param searchWord
#'   Keyword for searching. You can use `OR` and `AND` to combine conditions
#'   (e.g.: `"apple AND orange"`).
#' @param .use_label
#'   Whether to take the human-redable label value or the code value when
#'   flattening a field containing both (default: `TRUE`).
#' @param surveyYears
#'   Year and month when the survey was conducted. The format is either
#'   `"YYYY"`, `"YYYYMM"`, or `"YYYYMM-YYYYMM"`.
#' @param openYears
#'   Year and month when the survey result was opened. The format is the
#'   same as `surveyYears`.
#' @param statsField
#'   Field of statistics. The format is either two digits(large classification)
#'   or four digits (small classification). For the detail of the
#'   classification, see <http://www.soumu.go.jp/toukei_toukatsu/index/seido/sangyo/26index.htm>.
#' @param statsCode
#'   Code assigned for each statistical agency and statistics. The format can
#'   be five digits (agency), and eight digits (statistics). For the detail,
#'   see <http://www.stat.go.jp/info/guide/public/code/code.htm>.
#' @param searchKind
#'   Type of statistics.
#'   \itemize{
#'     \item `1`:
#'       summary
#'     \item `2`:
#'       regional mesh
#'   }
#' @param collectArea
#'   Area of statistics.
#'   \itemize{
#'     \item `1`:
#'       country
#'     \item `2`:
#'       prefecture
#'     \item `3`:
#'       municipality
#'   }
#' @param updatedDate
#'   Last updated date. The format is either `"YYYY"`, `"YYYYMM"`, or
#'   `"YYYYMM-YYYYMM"`.
#' @param ... Other parameters.
#'
#' @seealso
#' <http://www.e-stat.go.jp/api/e-stat-manual3-0/#api_2_1>
#' <http://www.e-stat.go.jp/api/e-stat-manual3-0/#api_3_2>
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
                               collectArea = NULL,
                               startPosition = NULL,
                               limit = NULL,
                               updatedDate = NULL,
                               ...) {
  lang <- match.arg(lang)

  j <- estat_api("rest/3.0/app/json/getStatsList",
    appId = appId, searchWord = searchWord,
    lang = lang,
    surveyYears = surveyYears,
    openYears = openYears,
    statsField = statsField,
    statsCode = statsCode,
    searchKind = searchKind,
    collectArea = collectArea,
    startPosition = startPosition,
    limit = limit,
    updatedDate = updatedDate,
    ...
  )

  table_inf <- j$GET_STATS_LIST$DATALIST_INF$TABLE_INF
  table_inf <- purrr::map(table_inf, as_flattened_character, .use_label = .use_label)

  dplyr::bind_rows(table_inf)
}
