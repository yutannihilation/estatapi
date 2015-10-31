#' Util

ESTAT_API_URL <- "http://api.e-stat.go.jp/"

#' @export
estat_api <- function(path, appId, ...)
{
  res <- GET(
    ESTAT_API_URL, path = path,
    query = list(
      appId      = appId,
      ...
    ))

  httr::warn_for_status(res)

  content(res)
}

as_flattened_character <- function(x)
{
  purrr::map(purrr::flatten(x), as.character)
}

force_bind_rows <- function(x)
{
  if(is.list(x[[1]])) dplyr::bind_rows(x) else dplyr::as_data_frame(x)
}

get_class_info <- function(class_obj)
{
  class_info <- lapply(class_obj, function(x) force_bind_rows(x$CLASS))
  names(class_info) <- sapply(class_obj, function(x) x$"@id")
  class_info
}

merge_class_info <- function(value_df, class_info, name)
{
  info <- class_info[[name]] %>%
    select(`@code`, `@name`)

  key <- sprintf("@%s", name)
  colnames(info) <- c(key, sprintf("%s_info", name))
  left_join(value_df, info,  by = key)
}
