#' getStatsData
#'
#' @export
estat_getStatsData <- function(appId, statsDataId, ...)
{
  j <- estat_api("rest/2.0/app/json/getStatsData", appId = appId, statsDataId = statsDataId, ...)

  # TODO: rerun with startPosition automatically
  next_key <- j$GET_STATS_DATA$STATISTICAL_DATA$RESULT_INF$NEXT_KEY
  if(!is.null(next_key))
    message(sprintf("There are more records; please rerun with startPosition=%s", next_key))

  class_info <- get_class_info(j$GET_STATS_DATA$STATISTICAL_DATA$CLASS_INF$CLASS_OBJ)

  value_df <- j$GET_STATS_DATA$STATISTICAL_DATA$DATA_INF$VALUE %>%
    dplyr::bind_rows()

  suppressWarnings(
    value_df <- value_df %>%
      dplyr::mutate(value = as.numeric(`$`))
  )

  for (info_name in names(class_info)) {
    value_df <- merge_class_info(value_df, class_info, info_name)
  }

  value_df
}
