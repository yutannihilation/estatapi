#' getDataCatalog API
#'
#' Get information about the statistical dataset files and databases via e-Stat API.
#'
#' @param appId Application ID
#' @param ... Other parameters.
#' @seealso
#' \url{http://www.e-stat.go.jp/api/e-stat-manual/#api_2_6}
#' \url{http://www.e-stat.go.jp/api/e-stat-manual/#api_3_7}
#' @export
estat_getDataCatalog <- function(appId, ...) {
  j <- estat_api("rest/2.0/app/json/getDataCatalog", appId = appId, ...)

  j$GET_DATA_CATALOG$DATA_CATALOG_LIST_INF$DATA_CATALOG_INF %>%
    map(denormalize_data_catalog_inf) %>%
    dplyr::bind_rows()
}

denormalize_data_catalog_inf <- function(inf) {
  DATASET <- inf$DATASET
  RESOURCE <- inf$RESOURCES$RESOURCE

  dataset_inf <- DATASET %>%
    purrr::discard(names(.) %in% c("STAT_NAME", "ORGANIZATION")) %>%
    as_flattened_character %>%
    purrr::update_list(
      `@id`             = inf$`@id`,
      STAT_NAME         = DATASET$STAT_NAME$`$`,
      STAT_NAME_code    = DATASET$STAT_NAME$`@code`,
      ORGANIZATION      = DATASET$ORGANIZATION$`$`,
      ORGANIZATION_code = DATASET$ORGANIZATION$`@code`
    )
  names(dataset_inf) <- paste0("DATASET_", names(dataset_inf))

  resources_inf <- if(is.character(RESOURCE[[1]])) {
    as_flattened_character(RESOURCE) %>%
      dplyr::as_data_frame()
  } else {
    RESOURCE %>%
      purrr::map(as_flattened_character) %>%
      dplyr::bind_rows()
  }

  purrr::invoke(mutate, .data = resources_inf, dataset_inf)
}
