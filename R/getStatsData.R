#' getStatsData API
#'
#' Get some statistical data via e-Stat API.
#'
#' @param appId
#'   Application ID.
#' @param statsDataId
#'   ID of the statistical dataset.
#' @param startPosition
#'   Index of the first record to get.
#' @param limit
#'   Max number of records to get.
#' @param lang
#'   Language of the data. `"J"`(Japanese) or `"E"`(English).
#' @param .fetch_all
#'   Whether to fetch all records when the number of records is larger than
#'   100,000.
#' @param ...
#'   Other parameters.
#' \itemize{
#'  \item `lvTab`:
#'    Level of the meta-information. The format can be `X` or `X-Y`, `-X` and `X-`.
#'  \item `cdTab`:
#'    Code(s) of the meta-infomation items to select. The format can be a character vector (`c("001", "002")`) or
#'    a chraracter of values and commas (`"001,002"`).
#'  \item `cdTabFrom`:
#'    The code of the first meta-information item to select.
#'  \item `cdTabTo`:
#'    The code of the last meta-information item to select.
#'  \item `lvTime`:
#'     Level of the time to select. The format is the same as `lvTab`
#'  \item `cdTime`
#'     Time(s) to select. The format is the same way like `cdTab`
#'  \item `cdTimeFrom`:
#'    The first time to select. The format is the same way like `cdTabFrom`
#'  \item `cdTimeTo`:
#'    The last time to select. The format is the same way like `cdTabTo`
#'  \item `lvArea`:
#'     Level of the area to select. The format is the same as `lvTab`
#'  \item `cdArea`
#'     Code(s) of the Area to select. The format is the same way like `cdTab`
#'  \item `cdAreaFrom`:
#'    The code of the first area to select. The format is the same way like `cdTabFrom`
#'  \item `cdAreaTo`:
#'    The code of the last area to select. The format is the same way like `cdTabTo`
#'  \item `lvCat01`, `cdCat01`, `cdCat01From`, `cdCat01To`, ...:
#'    The same way like above.
#' }
#'
#' @seealso
#' <http://www.e-stat.go.jp/api/e-stat-manual3-0/#api_2_3>
#' <http://www.e-stat.go.jp/api/e-stat-manual3-0/#api_3_4>
#'
#' @examples
#' \dontrun{
#' # fetch all data, which may take time
#' estat_getStatsData(
#'   appId = "XXXX",
#'   statsDataId = "0003065345"
#' )
#'
#' # fetch data up to 10 records
#' estat_getStatsData(
#'   appId = "XXXX",
#'   statsDataId = "0003065345",
#'   limit = 10
#' )
#'
#' # fetch data up to 100,000 records (max number of records available at once)
#' estat_getStatsData(
#'   appId = "XXXX",
#'   statsDataId = "0003065345",
#'   .fetch_all = FALSE
#' )
#'
#' # fetch all data in the specifed category
#' estat_getStatsData(
#'   appId = "XXXX",
#'   statsDataId = "0003065345",
#'   cdCat01 = c("008", "009", "010")
#' )
#' }
#'
#' @export
estat_getStatsData <- function(appId, statsDataId,
                               startPosition = NULL,
                               limit = NULL,
                               lang = c("J", "E"),
                               .fetch_all = TRUE,
                               ...) {
  lang <- match.arg(lang)

  meta_info <- estat_getMetaInfo(appId, statsDataId, lang = lang)
  total_record_count <- estat_getStatsDataCount(appId, statsDataId, lang = lang, ...)
  ranges <- calc_ranges(startPosition, limit, total_record_count, .fetch_all)

  result <- list()

  for (i in seq_len(nrow(ranges))) {
    cur_limit <- ranges$limits[i]
    cur_start <- ranges$starts[i]

    message(sprintf(
      "Fetching record %.0f-%.0f... (total: %.0f records)\n",
      cur_start, cur_start + cur_limit - 1, total_record_count
    ))

    j <- estat_api("rest/2.1/app/json/getStatsData",
      appId = appId,
      statsDataId = statsDataId,
      startPosition = format(cur_start, scientific = FALSE),
      limit = format(cur_limit, scientific = FALSE),
      lang = lang,
      metaGetFlg = "N",
      ...
    )

    value_df <- j$GET_STATS_DATA$STATISTICAL_DATA$DATA_INF$VALUE %>%
      dplyr::bind_rows()

    result[[i]] <- value_df
  }

  result_df <- result %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(`$` = suppressWarnings(readr::parse_number(`$`)))

  colnames(result_df) <- colnames(result_df) %>%
    purrr::map_chr(~ paste0(substring(., 2), "_code")) %>%
    dplyr::recode("_code" = "value", "unit_code" = "unit")

  for (meta in purrr::transpose(meta_info$.names)) {
    meta_df <- meta_info[[meta$id]]
    meta_vec <- purrr::set_names(
      x = meta_df[["@name"]],
      nm = meta_df[["@code"]]
    )
    result_df[, meta$name] <- meta_vec[result_df[[paste0(meta$id, "_code")]]]
  }

  # FIXME: This is a temporal workaround until getSimpleStatsData API is ready.
  # reorder result as the same order as getSimpleStatsData
  colnames_all <- colnames(result_df)
  colnames_meta <- meta_info$.names$name
  colnames_orig <- dplyr::setdiff(colnames_all, colnames_meta)

  suppressWarnings({
    sorted_colnames <- unlist(purrr::transpose(
      list(colnames_orig, colnames_meta)
    ))
  })
  result_df[, sorted_colnames]
}


estat_getStatsDataCount <- function(appId, statsDataId, ...) {
  j <- estat_api("rest/2.1/app/json/getStatsData",
    appId = appId,
    statsDataId = statsDataId,
    metaGetFlg = "N",
    cntGetFlg = "Y",
    ...
  )

  as.numeric(j$GET_STATS_DATA$STATISTICAL_DATA$RESULT_INF$TOTAL_NUMBER)
}


calc_ranges <- function(startPosition,
                        limit,
                        record_count,
                        .fetch_all,
                        .max_records_at_once = 100000) {
  ranges <- list()

  if (is.null(startPosition)) {
    startPosition <- 1
  }

  if (is.null(limit)) {
    endPosition <- record_count
  } else {
    endPosition <- min(startPosition + limit - 1, record_count)
  }

  if (.fetch_all) {
    ranges$starts <- seq(from = startPosition, to = endPosition, by = .max_records_at_once)
    ranges$limits <- rep(.max_records_at_once, length(ranges$starts))
    # treat a fraction
    fraction <- (endPosition - startPosition + 1) %% .max_records_at_once
    if (fraction != 0) {
      ranges$limits[length(ranges$limits)] <- fraction
    }
  } else {
    ranges$starts <- startPosition
    ranges$limits <- min(startPosition + .max_records_at_once - 1, endPosition)
  }

  tibble::tibble(!!!ranges)
}

# cdTab may be (1) NULL, (2) a vector of strings or (3) a string of numbers separated by ","
get_tabs <- function(appId, statsDataId, cdTab) {
  if (is.null(cdTab)) {
    # when (1), try to get all tab from getMetaInfo API
    meta_info <- estat_getMetaInfo(appId = appId, statsDataId = statsDataId)

    # tab does not always exist.
    if (!is.null(meta_info$tab)) {
      meta_info$tab$`@code`
    } else {
      NULL
    }
  } else {
    # when (2) or (3), split it by ","
    unlist(strsplit(cdTab, ",", fixed = TRUE))
  }
}
