#' getMetaInfo API
#'
#' Get meta-information about the statistical dataset via e-Stat API.
#'
#' @param appId Application ID
#' @param statsDataId ID of the statistical dataset
#' @param lang Language of data. \code{"J"}(Japanese) or \code{"E"}(English).
#' @param ... Other parameters.
#'
#' @seealso
#' \url{http://www.e-stat.go.jp/api/e-stat-manual2-1/#api_2_2}
#' \url{http://www.e-stat.go.jp/api/e-stat-manual2-1/#api_3_3}
#'
#' @examples
#' \dontrun{
#' estat_getMetaInfo(appId = "XXXX", statsDataId = "0003065345")
#' }
#'
#' @export
estat_getMetaInfo <- function(appId, statsDataId, lang = c("J", "E"), ...) {
  lang <- match.arg(lang)
  j <- estat_api("rest/2.1/app/json/getMetaInfo", appId = appId, statsDataId = statsDataId, lang = lang, ...)

  meta_info <- get_class_info(j$GET_META_INFO$METADATA_INF$CLASS_INF$CLASS_OBJ)
}
