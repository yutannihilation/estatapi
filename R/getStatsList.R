#' getStatsList
#'
#' @export
estat_getStatsList <- function(appId, searchWord, ...) {
  j <- estat_api("rest/2.0/app/json/getStatsList", appId = appId, searchWord = searchWord, ...)

  j$GET_STATS_LIST$DATALIST_INF$TABLE_INF %>%
    purrr::map(as_flattened_character) %>%
    dplyr::bind_rows
}
