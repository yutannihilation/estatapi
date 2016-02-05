#' getMetaInfo API
#'
#' Get Meta-information about the statistical dataset vi e-Stat API.
#' @param appId Application ID
#' @param statsDataId ID of the statistical dataset
#' @param ... Other parameters.
#' @seealso
#' \url{http://www.e-stat.go.jp/api/e-stat-manual/#api_2_2}
#' \url{http://www.e-stat.go.jp/api/e-stat-manual/#api_3_3}
#'
#' @section Other parameters:
#' For every detailed information, please visit the URL in See Also.
#' \itemize{
#'  \item \code{callback}:
#'     (This parameter is not supported) callback function for JSONP.
#' }
#'
#' @examples
#' \dontrun{
#' estat_getMetaInfo(appId = "XXXX", statsDataId = "0003065345")
#' }
#'
#' @export
estat_getMetaInfo <- function(appId, statsDataId, ...) {
  j <- estat_api("rest/2.0/app/json/getMetaInfo", appId = appId, statsDataId = statsDataId, ...)

  get_class_info(j$GET_META_INFO$METADATA_INF$CLASS_INF$CLASS_OBJ)
}
