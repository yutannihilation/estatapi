#' getMetaInfo
#'
#' @export
estat_getMetaInfo <- function(appId, statsDataId, ...) {
  j <- estat_api("rest/2.0/app/json/getMetaInfo", appId = appId, statsDataId = statsDataId, ...)

  get_class_info(j$GET_META_INFO$METADATA_INF$CLASS_INF$CLASS_OBJ)
}
