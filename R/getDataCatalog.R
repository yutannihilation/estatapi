#' getDataCatalog API
#'
#' Get information about the statistical dataset files and databases via e-Stat API.
#'
#' @inheritParams estat_getStatsList
#' @param dataType
#'   Type of data. `XLS`: Excel file, `CSV`: CSV file, `PDF`: PDF file, `DB`: Database.
#' @param catalogId
#'   Catalog ID.
#' @param resourceId
#'   Catalog resource ID.
#'
#' @seealso
#' <http://www.e-stat.go.jp/api/e-stat-manual3-0/#api_2_6>
#' <http://www.e-stat.go.jp/api/e-stat-manual3-0/#api_3_7>
#'
#' @examples
#' \dontrun{
#' estat_getDataCatalog(
#'   appId = "XXXX",
#'   searchWord = "CD",
#'   dataType = "XLS",
#'   limit = 3
#' )
#' }
#' @export
estat_getDataCatalog <- function(appId,
                                 lang = c("J", "E"),
                                 .use_label = TRUE,
                                 surveyYears = NULL,
                                 openYears = NULL,
                                 statsField = NULL,
                                 statsCode = NULL,
                                 searchWord = NULL,
                                 dataType = NULL,
                                 catalogId = NULL,
                                 resourceId = NULL,
                                 startPosition = NULL,
                                 limit = NULL,
                                 updatedDate = NULL,
                                 ...) {
  lang <- match.arg(lang)

  j <- estat_api("rest/3.0/app/json/getDataCatalog",
    appId = appId,
    lang = lang,
    surveyYears = surveyYears,
    openYears = openYears,
    statsField = statsField,
    statsCode = statsCode,
    searchWord = searchWord,
    dataType = dataType,
    catalogId = catalogId,
    resourceId = resourceId,
    startPosition = startPosition,
    limit = limit,
    updatedDate = updatedDate,
    ...
  )

  data_catalog_inf <- j$GET_DATA_CATALOG$DATA_CATALOG_LIST_INF$DATA_CATALOG_INF
  data_catalog_inf <- purrr::map(data_catalog_inf, denormalize_data_catalog_inf, .use_label = .use_label)

  dplyr::bind_rows(data_catalog_inf)
}

denormalize_data_catalog_inf <- function(inf, .use_label = TRUE) {
  # Columns which needs special treatments:
  #   - STAT_NAME and ORGANIZATION have different nested level
  #   - other columns will conflict between DATASET and RESOURCE
  special_columns <- c("DESCRIPTION", "LAST_MODIFIED_DATE", "RELEASE_DATE")

  DATASET <- inf$DATASET
  RESOURCE <- inf$RESOURCES$RESOURCE

  dataset_inf <- purrr::discard(DATASET, names(DATASET) %in% special_columns)
  dataset_inf <- as_flattened_character(dataset_inf, .use_label = .use_label)
  dataset_inf <- purrr::update_list(dataset_inf,
    `DATASET_@id` = inf$`@id`,
    DATASET_DESCRIPTION = DATASET$DESCRIPTION,
    DATASET_LAST_MODIFIED_DATE = DATASET$LAST_MODIFIED_DATE,
    DATASET_RELEASE_DATE = DATASET$RELEASE_DATE
  )

  # inf$DATASET$TITLE$NAME conflicts with inf$RESOURCES$RESOURCE[[x]]$TITLE$NAME
  names(dataset_inf) <- replace(names(dataset_inf), names(dataset_inf) == "NAME", "DATASET_NAME")

  # RESOURCE may be a list or a list of lists
  if (is.character(RESOURCE[[1]])) {
    resources_inf <- as_flattened_character(RESOURCE, .use_label = .use_label)
    resources_inf <- dplyr::bind_rows(resources_inf)
  } else {
    resources_inf <- purrr::map(RESOURCE, as_flattened_character, .use_label = .use_label)
    resources_inf <- dplyr::bind_rows(resources_inf)
  }

  purrr::invoke(dplyr::mutate, .data = resources_inf, dataset_inf)
}
