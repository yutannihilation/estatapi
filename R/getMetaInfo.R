#' getMetaInfo API
#'
#' Get meta-information about the statistical dataset via e-Stat API.
#'
#' @param appId
#'   Application ID.
#' @param statsDataId
#'   ID of the statistical dataset.
#' @param lang
#'   Language of data. `"J"`(Japanese) or `"E"`(English).
#' @param ...
#'   Other parameters.
#'
#' @seealso
#' <http://www.e-stat.go.jp/api/e-stat-manual3-0/#api_2_2>
#' <http://www.e-stat.go.jp/api/e-stat-manual3-0/#api_3_3>
#'
#' @examples
#' \dontrun{
#' estat_getMetaInfo(appId = "XXXX", statsDataId = "0003065345")
#' }
#'
#' @export
estat_getMetaInfo <- function(appId, statsDataId, lang = c("J", "E"), ...) {
  lang <- match.arg(lang)
  j <- estat_api("rest/3.0/app/json/getMetaInfo", appId = appId, statsDataId = statsDataId, lang = lang, ...)

  get_class_info(j$GET_META_INFO$METADATA_INF$CLASS_INF$CLASS_OBJ)
}
