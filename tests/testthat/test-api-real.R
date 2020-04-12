context("API with real request")


# Constants ---------------------------------------------

EXPECTED_NAMES <- c(
  "tab_code", "\u8868\u7ae0\u9805\u76ee",
  "cat01_code", "\u54c1\u76ee\u5206\u985e\uff0827\u5e74\u6539\u5b9a\uff09",
  "cat02_code", "\u4e16\u5e2f\u533a\u5206",
  "area_code", "\u5730\u57df\u533a\u5206",
  "time_code", "\u6642\u9593\u8ef8\uff08\u6708\u6b21\uff09",
  "unit",
  "value",
  "annotation"
)

STATS_DATA_ID <- "0003103532"

CD_CAT01_SMALL <- c("010800130", "010800140")

CD_CAT01_LARGE <- c(
  "000100000", "000200000", "000300000", "000400000", "000500000",
  "000600000", "000700000", "000800000", "000900000", "001000000",
  "001100000", "010000000", "010100000", "010110001", "010120000",
  "010120010", "010120020"
)


# Util Functions ----------------------------------------

wrap_api_func <- function(fun, ...) {
  skip_on_cran()
  skip_on_ci()

  if (!"estatapi" %in% keyring::key_list()$service) {
    skip('appId is not available; Set the key by keyring::key_set("estatapi")')
  }

  appId <- keyring::key_get("estatapi")
  purrr::partial(fun, appId = appId)
}

check_df <- function(d, expected_names = EXPECTED_NAMES, expected_count = NULL) {
  # Confirm there are no duplicated rows
  expect_equal(nrow(d), nrow(dplyr::distinct(d)))

  # Confirm the column names are the same as expected
  expect_equal(names(d), expected_names)

  if (!is.null(expected_count)) {
    # Confirm the number of rows is the same as expected
    expect_equal(nrow(d), expected_count)
  } else {
    expect_true(nrow(d) > 0)
  }
}


# Tests with <1000000 records -----------------------------------------------

test_that("estat_getStatsData with <100000 records works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = STATS_DATA_ID,
    cdCat01 = CD_CAT01_SMALL
  )

  check_df(d)
})

test_that("estat_getStatsData with <100000 records and limit works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = STATS_DATA_ID,
    cdCat01 = CD_CAT01_SMALL,
    limit = 10
  )

  check_df(d, expected_count = 10)
})

test_that("estat_getStatsData with <100000 records and limit works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = STATS_DATA_ID,
    cdCat01 = CD_CAT01_SMALL,
    limit = 10
  )

  check_df(d, expected_count = 10)
})


test_that("estat_getStatsData with <100000 records and startPosition works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = STATS_DATA_ID,
    cdCat01 = CD_CAT01_SMALL,
    startPosition = 10001
  )

  total_number <- wrap_api_func(estat_getStatsDataCount)(statsDataId = STATS_DATA_ID, cdCat01 = CD_CAT01_SMALL)
  check_df(d, expected_count = total_number - 10001 + 1)
})

test_that("estat_getStatsData with <100000 records and startPosition and limit works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = STATS_DATA_ID,
    cdCat01 = CD_CAT01_SMALL,
    startPosition = 10001,
    limit = 10
  )

  check_df(d, expected_count = 10)
})


# Tests with >1000000 records -----------------------------------------------

test_that("estat_getStatsData with >100000 records works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = STATS_DATA_ID,
    cdCat01 = CD_CAT01_LARGE
  )

  check_df(d)
})

test_that("estat_getStatsData with >100000 records and limit >100000 works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = STATS_DATA_ID,
    cdCat01 = CD_CAT01_LARGE,
    limit = 110000
  )

  check_df(d, expected_count = 110000)
})

test_that("estat_getStatsData with >100000 records and limit <100000 works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = STATS_DATA_ID,
    cdCat01 = CD_CAT01_LARGE,
    limit = 90000
  )

  check_df(d, expected_count = 90000)
})

test_that("estat_getStatsData with >100000 records and startPosition works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = STATS_DATA_ID,
    cdCat01 = CD_CAT01_LARGE,
    startPosition = 10001
  )

  total_number <- wrap_api_func(estat_getStatsDataCount)(statsDataId = STATS_DATA_ID, cdCat01 = CD_CAT01_LARGE)
  check_df(d, expected_count = total_number - 10001 + 1)
})

test_that("estat_getStatsData with >100000 records and startPosition and limit >1000000 works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = STATS_DATA_ID,
    cdCat01 = CD_CAT01_LARGE,
    startPosition = 10001,
    limit = 100800
  )

  check_df(d, expected_count = 100800)
})

test_that("estat_getStatsData with >100000 records and startPosition and limit <1000000 works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = STATS_DATA_ID,
    cdCat01 = CD_CAT01_LARGE,
    startPosition = 10001,
    limit = 90000
  )

  check_df(d, expected_count = 90000)
})


# Test English -----------------------------------------------

test_that("estat_getStatsData with <100000 records in English works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = "0003036792",
    cdTab = "2",
    cdArea = "13A01",
    cdCat01 = "7009",
    lang = "E"
  )

  check_df(d,
    expected_names = c(
      "tab_code", "Tabulated variable",
      "cat01_code", "Items",
      "area_code", "AREA",
      "time_code", "Time",
      "unit",
      "value",
      "annotation"
    )
  )
})
