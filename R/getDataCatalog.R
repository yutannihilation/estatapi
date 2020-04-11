#' getDataCatalog API
#'
#' Get information about the statistical dataset files and databases via e-Stat API.
#'
#' @param appId
#'   Application ID.
#' @param lang
#'   Language of data. `"J"`(Japanese) or `"E"`(English).
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
#' @param searchWord
#'   Keyword for searching. You can use `OR` and `AND` to combine conditions
#'   (e.g.: `"apple AND orrange"`).
#' @param dataType
#'   Type of data. `XLS`: Excel file, `CSV`: CSV file, `PDF`: PDF file, `DB`: Database.
#' @param catalogId
#'   Catalog ID.
#' @param resourceId
#'   Catalog resource ID.
#' @param startPosition
#'   Integer. The the first record to get.
#' @param limit
#'   Integer. Max number of records to get.
#' @param updatedDate
#'   Last updated date. The format is either `"YYYY"`, `"YYYYMM"`, or
#'   `"YYYYMM-YYYYMM"`.
#' @param ...
#'   Other parameters.
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
  dataset_inf <- as_flattened_character(.use_label = .use_label)
  dataset_inf <- purrr::update_list(
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
    resources_inf <- tibble::as_tibble(resources_inf)
  } else {
    resources_inf <- purrr::map(resources_inf, as_flattened_character, .use_label = .use_label)
    resources_inf <- tibble::as_tibble(resources_inf)
  }

  purrr::invoke(dplyr::mutate, .data = resources_inf, dataset_inf)
}
