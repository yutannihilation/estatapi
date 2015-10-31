#' getStatsData
#'
#' @export
estat_getStatsData <- function(appId, statsDataId, ...)
{
  j <- estat_api("rest/2.0/app/json/getStatsData", appId = appId, statsDataId = statsDataId, ...)

  class_info <- get_class_info(j$GET_STATS_DATA$STATISTICAL_DATA$CLASS_INF$CLASS_OBJ)

  value_df <- j$GET_STATS_DATA$STATISTICAL_DATA$DATA_INF$VALUE %>%
    bind_rows

  value_df <- value_df %>%
    mutate(value = as.numeric(`$`))

  for (info_name in names(class_info)) {
    value_df <- merge_class_info(value_df, class_info, info_name)
  }

  value_df
}
