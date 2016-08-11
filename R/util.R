#' Util

ESTAT_API_URL <- "http://api.e-stat.go.jp/"

#' @title e-Stat API
#'
#' @description Get Statistical Something From e-Stat API
#'
#' @param path API endpoint
#' @param appId application ID
#' @param ... other parameters
#'
#' @export
estat_api <- function(path, appId, ...) {
  # convert params like cdCat01=c("001","002") to cdCat01="001,002"
  query <- flatten_query(list(appId = appId, ...))

  res <- httr::GET(
    ESTAT_API_URL,
    config = httr::add_headers(`Accept-Encoding` = "gzip"),
    path = path,
    query = query
  )

  httr::warn_for_status(res)

  media <- httr::parse_media(res$headers$`content-type`)

  # A result of gettStatsData, getMetaInfo, getDataCatalog and getStatsList is JSON.
  # That of getSimpleStatsData is CSV (but the media type is "text/plain").
  if (media$type == "application" && media$subtype == "json") {
    parse_result_json(res)
  } else if (media$type == "text" && media$subtype == "plain") {
    parse_result_csv(res)
  } else {
    stop("unknown media type: ", res$headers$`content-type`)
  }
}

flatten_query <- function(x) {
  x <- x %>%
    purrr::compact() %>%
    purrr::map(~ paste0(as.character(.), collapse = ","))

  # Ignore duplicated elements
  x[unique(names(x))]
}

as_flattened_character <- function(x, .use_label = TRUE) {
  x %>%
    purrr::map(try_dollar, .use_label = .use_label) %>%
    purrr::flatten() %>%
    purrr::map(as.character)
}

# 1) scalar value  ->  return x as it is
# 2) list with "$" element
#   2-1) if .use_label is TRUE  ->  return the value of "$"
#   2-2) if .use_label is FALSE ->  return the other value
# 3) list without "$" element  ->  return x as it is (x will be flattened outside of this function)
try_dollar <- function(x, .use_label = TRUE) {
  if(! is.list(x)) return(x)
  if(! "$" %in% names(x)) return(x)

  if(.use_label) {
    x[["$"]]
  } else {
    x[[which(names(x) != "$")]]
  }
}

get_class_info <- function(class_obj) {
  meta_ids <- purrr::map_chr(class_obj, "@id")
  meta_names <- purrr::map_chr(class_obj, "@name")

  class_info <- purrr::map(class_obj, ~ dplyr::bind_rows(.$CLASS))
  names(class_info) <- meta_ids

  purrr::update_list(class_info, .names = dplyr::data_frame(id = meta_ids, name = meta_names))
}

merge_class_info <- function(value_df, class_info, name) {
  info <- class_info[[name]] %>%
    dplyr::select_("`@code`", "`@name`")

  key <- sprintf("@%s", name)
  colnames(info) <- c(key, sprintf("%s_info", name))
  dplyr::left_join(value_df, info, by = key)
}

parse_result_json <- function(res) {
  result_parsed <- httr::content(res)

  if (result_parsed[[1]]$RESULT$STATUS != 0) {
    stop(result_parsed[[1]]$RESULT$ERROR_MSG)
  }

  result_parsed
}

# Example responses of getStatsData:
#
# 1) success
#     "VALUE"
#     "tab_code","XXXX","cat01_code","YYYY",...
#
# 2) fail
#     "RESULT"
#     "STATUS","100"
#     "ERROR_MSG","..."
#     "DATE","2016-XX-XXTXX:XX:XX.XXX+09:00"
parse_result_csv <- function(res) {
  result_text <- httr::content(res, as = "text")

  if (readr::read_lines(result_text, n_max = 1) != "\"VALUE\"") {
    stop(result_text)
  }

  readr::read_csv(result_text,
                  skip = 1,
                  col_types = readr::cols(
                    value    = readr::col_number(),
                    .default = readr::col_character()
                  ))
}
