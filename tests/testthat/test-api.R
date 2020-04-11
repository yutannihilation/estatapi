context("API with mocks")

dummy_res <- structure(
  list(
    url = "",
    status_code = 200L,
    headers = structure(
      list(
        `content-type` = "application/json;charset=utf-8",
        `content-encoding` = "gzip"
      ),
      .Names = c(
        "content-type",
        "content-encoding"
      ),
      class = c("insensitive", "list")
    ),
    content = raw(0)
  ),
  .Names = c(
    "url",
    "status_code",
    "headers",
    "content"
  ),
  class = "response"
)

test_that("estat_getStatsList processes the API response as expected", {
  with_mock(
    `httr::GET` = function(...) {
      purrr::update_list(dummy_res, content = readRDS("content_getStatsList.rds"))
    },
    expect_identical(
      estat_getStatsList(
        appId = "XXXX",
        searchWord = "CD",
        limit = 3
      ),
      readRDS("result_getStatsList.rds")
    )
  )
})

test_that("estat_getStatsList (w/o label) processes the API response as expected", {
  with_mock(
    `httr::GET` = function(...) {
      purrr::update_list(dummy_res, content = readRDS("content_getStatsList.rds"))
    },
    expect_identical(
      estat_getStatsList(
        appId = "XXXX",
        searchWord = "CD",
        limit = 3,
        .use_label = FALSE
      ),
      readRDS("result_getStatsList_wo_label.rds")
    )
  )
})

test_that("estat_getMetaInfo processes the API response as expected", {
  with_mock(
    `httr::GET` = function(...) {
      purrr::update_list(dummy_res, content = readRDS("content_getMetaInfo.rds"))
    },
    expect_identical(
      estat_getMetaInfo(appId = "XXXX", statsDataId = "0003065345"),
      readRDS("result_getMetaInfo.rds")
    )
  )
})

test_that("estat_getStatsData processes the API response as expected", {
  with_mock(
    `estatapi:::estat_getStatsDataCount` = function(...) 40014,
    `estatapi::estat_getMetaInfo` = function(...) readRDS("result_getMetaInfo.rds"),
    `httr::GET` = function(...) {
      res <- purrr::update_list(dummy_res,
        content = readRDS("content_getStatsData.rds")
      )
      res$headers$`content-type` <- "text/plain; charset=utf-8"
      res
    },
    {
      expect_identical(
        estat_getStatsData(
          appId = "XXXX",
          statsDataId = "0003065345",
          cdCat01 = c("008", "009", "010"),
          limit = 3
        ),
        readRDS("result_getStatsData.rds")
      )
    }
  )
})


test_that("estat_getDataCatalog processes the API response as expected", {
  with_mock(
    `httr::GET` = function(...) {
      purrr::update_list(dummy_res, content = readRDS("content_getDataCatalog.rds"))
    },
    expect_identical(
      estat_getDataCatalog(
        appId = "XXXX",
        searchWord = "\u30c1\u30e7\u30b3\u30ec\u30fc\u30c8",
        dataType = c("PDF", "XLS")
      ),
      readRDS("result_getDataCatalog.rds")
    )
  )
})


test_that("estat_getDataCatalog (w/o label) processes the API response as expected", {
  with_mock(
    `httr::GET` = function(...) {
      purrr::update_list(dummy_res, content = readRDS("content_getDataCatalog.rds"))
    },
    expect_identical(
      estat_getDataCatalog(
        appId = "XXXX",
        searchWord = "\u30c1\u30e7\u30b3\u30ec\u30fc\u30c8",
        dataType = c("PDF", "XLS"),
        .use_label = FALSE
      ),
      readRDS("result_getDataCatalog_wo_label.rds")
    )
  )
})
