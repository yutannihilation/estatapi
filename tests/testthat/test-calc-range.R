context("calc_range")

params <- list(
  list(
    startPosition = NULL, limit = NULL, record_count = 100L, .fetch_all = FALSE, max = 1e+05,
    expect = tibble::tibble(starts = 1, limits = 100)
  ),
  list(
    startPosition = NULL, limit = NULL, record_count = 100L, .fetch_all = TRUE, max = 1e+05,
    expect = tibble::tibble(starts = 1, limits = 100)
  ),
  list(
    startPosition = NULL, limit = NULL, record_count = 100L, .fetch_all = FALSE, max = 10,
    expect = tibble::tibble(starts = 1, limits = 10)
  ),
  list(
    startPosition = NULL, limit = NULL, record_count = 100L, .fetch_all = TRUE, max = 10,
    expect = tibble::tibble(
      starts = c(1, 11, 21, 31, 41, 51, 61, 71, 81, 91),
      limits = c(10, 10, 10, 10, 10, 10, 10, 10, 10, 10)
    )
  ),
  list(
    startPosition = 11, limit = NULL, record_count = 100L, .fetch_all = TRUE, max = 10,
    expect = tibble::tibble(
      starts = c(11, 21, 31, 41, 51, 61, 71, 81, 91),
      limits = c(10, 10, 10, 10, 10, 10, 10, 10, 10)
    )
  ),
  list(
    startPosition = 2, limit = NULL, record_count = 100L, .fetch_all = TRUE, max = 10,
    expect = tibble::tibble(
      starts = c(2, 12, 22, 32, 42, 52, 62, 72, 82, 92),
      limits = c(10, 10, 10, 10, 10, 10, 10, 10, 10, 9)
    )
  )
)

for (param in params) {
  test_that("test calc_range", {
    r <- calc_ranges(
      startPosition = param$startPosition,
      limit = param$limit,
      record_count = param$record_count,
      .fetch_all = param$.fetch_all,
      .max_records_at_once = param$max
    )
    expect_equal(r, param$expect)
  })
}
