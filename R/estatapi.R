#' R Interface to e-Stat API
#'
#' @docType package
#' @seealso \url{http://www.e-stat.go.jp/SG1/estat/eStatTopPortalE.do}
#' @importFrom dplyr %>%
#' @name estatapi
NULL

.onAttach <- function(...) {
  # Show credit in Japanese
  packageStartupMessage("\u3053\u306e\u30b5\u30fc\u30d3\u30b9\u306f\u3001\u653f\u5e9c\u7d71\u8a08\u7dcf\u5408\u7a93\u53e3(e-Stat)\u306eAPI\u6a5f\u80fd\u3092\u4f7f\u7528\u3057\u3066\u3044\u307e\u3059\u304c\u3001\u30b5\u30fc\u30d3\u30b9\u306e\u5185\u5bb9\u306f\u56fd\u306b\u3088\u3063\u3066\u4fdd\u8a3c\u3055\u308c\u305f\u3082\u306e\u3067\u306f\u3042\u308a\u307e\u305b\u3093\u3002")
}
