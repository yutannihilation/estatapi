context("API with real request")

wrap_api_func <- function(fun, ...) {
  if (!file.exists("../../.appId")) {
    skip("appId is not available")
  }
  appId <- readr::read_lines("../../.appId")
  purrr::partial(fun, appId = appId)
}

test_that("estat_getStatsData with <100000 records works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = "0003103532",
    cdCat01 = c("010800130","010800140")
  )

  expect_equal(nrow(d), 13184)
  expect_equal(names(d), c("tab_code", "\u8868\u7ae0\u9805\u76ee", "cat01_code", "\u54c1\u76ee\u5206\u985e\uff0827\u5e74\u6539\u5b9a\uff09",
                           "cat02_code", "\u4e16\u5e2f\u533a\u5206", "area_code", "\u5730\u57df\u533a\u5206",
                           "time_code", "\u6642\u9593\u8ef8\uff08\u6708\u6b21\uff09",
                           "unit", "value"))
})

test_that("estat_getStatsData with <100000 records and limit works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = "0003103532",
    cdCat01 = c("010800130","010800140"),
    limit = 10
  )

  expect_equal(nrow(d), 10)
  expect_equal(names(d), c("tab_code", "\u8868\u7ae0\u9805\u76ee", "cat01_code", "\u54c1\u76ee\u5206\u985e\uff0827\u5e74\u6539\u5b9a\uff09",
                           "cat02_code", "\u4e16\u5e2f\u533a\u5206", "area_code", "\u5730\u57df\u533a\u5206",
                           "time_code", "\u6642\u9593\u8ef8\uff08\u6708\u6b21\uff09",
                           "unit", "value"))
})

test_that("estat_getStatsData with <100000 records and limit works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = "0003103532",
    cdCat01 = c("010800130","010800140"),
    limit = 10
  )

  expect_equal(nrow(d), 10)
  expect_equal(names(d), c("tab_code", "\u8868\u7ae0\u9805\u76ee", "cat01_code", "\u54c1\u76ee\u5206\u985e\uff0827\u5e74\u6539\u5b9a\uff09",
                           "cat02_code", "\u4e16\u5e2f\u533a\u5206", "area_code", "\u5730\u57df\u533a\u5206",
                           "time_code", "\u6642\u9593\u8ef8\uff08\u6708\u6b21\uff09",
                           "unit", "value"))
})


test_that("estat_getStatsData with <100000 records and startPosition works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = "0003103532",
    cdCat01 = c("010800130","010800140"),
    startPosition = 10001
  )

  expect_equal(nrow(d), 3184)
  expect_equal(names(d), c("tab_code", "\u8868\u7ae0\u9805\u76ee", "cat01_code", "\u54c1\u76ee\u5206\u985e\uff0827\u5e74\u6539\u5b9a\uff09",
                           "cat02_code", "\u4e16\u5e2f\u533a\u5206", "area_code", "\u5730\u57df\u533a\u5206",
                           "time_code", "\u6642\u9593\u8ef8\uff08\u6708\u6b21\uff09",
                           "unit", "value"))
})

test_that("estat_getStatsData with <100000 records and startPosition and limit works fine", {
  func_getStatsData <- wrap_api_func(estat_getStatsData)
  d <- func_getStatsData(
    statsDataId = "0003103532",
    cdCat01 = c("010800130","010800140"),
    startPosition = 10001,
    limit = 10
  )

  expect_equal(nrow(d), 10)
  expect_equal(names(d), c("tab_code", "\u8868\u7ae0\u9805\u76ee", "cat01_code", "\u54c1\u76ee\u5206\u985e\uff0827\u5e74\u6539\u5b9a\uff09",
                           "cat02_code", "\u4e16\u5e2f\u533a\u5206", "area_code", "\u5730\u57df\u533a\u5206",
                           "time_code", "\u6642\u9593\u8ef8\uff08\u6708\u6b21\uff09",
                           "unit", "value"))
})
