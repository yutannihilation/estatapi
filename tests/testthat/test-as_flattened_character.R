context("as_flattened_character")

dataset_raw <- list(
  STAT_NAME = structure(
    list(
      `@code` = "00200572",
      `$` = "\u5168\u56fd\u7269\u4fa1\u7d71\u8a08\u8abf\u67fb"
    ),
    .Names = c("@code", "$")
  ),
  ORGANIZATION = structure(list(`@code` = "00200", `$` = "\u7dcf\u52d9\u7701"), .Names = c("@code", "$")),
  TITLE = structure(
    list(
      NAME = "\u5e73\u62109\u5e74\u5168\u56fd\u7269\u4fa1\u7d71\u8a08\u8abf\u67fb_\u5927\u898f\u6a21\u5e97\u8217\u7de8_1997\u5e74",
      TABULATION_CATEGORY = "\u5e73\u62109\u5e74\u5168\u56fd\u7269\u4fa1\u7d71\u8a08\u8abf\u67fb",
      TABULATION_SUB_CATEGORY1 = "\u5927\u898f\u6a21\u5e97\u8217\u7de8",
      TABULATION_SUB_CATEGORY2 = "",
      TABULATION_SUB_CATEGORY3 = "",
      TABULATION_SUB_CATEGORY4 = "",
      TABULATION_SUB_CATEGORY5 = "",
      CYCLE = "",
      SURVEY_DATE = 1997L
    ),
    .Names = c(
      "NAME",
      "TABULATION_CATEGORY",
      "TABULATION_SUB_CATEGORY1",
      "TABULATION_SUB_CATEGORY2",
      "TABULATION_SUB_CATEGORY3",
      "TABULATION_SUB_CATEGORY4",
      "TABULATION_SUB_CATEGORY5",
      "CYCLE",
      "SURVEY_DATE"
    )
  ),
  DESCRIPTION = "",
  PUBLISHER = "\u7dcf\u52d9\u7701",
  CONTACT_POINT = "\u7d71\u8a08\u5c40\u7d71\u8a08\u8abf\u67fb\u90e8\u6d88\u8cbb\u7d71\u8a08\u8ab2\u7269\u4fa1\u7d71\u8a08\u5ba4",
  CREATOR = "\u7d71\u8a08\u5c40\u7d71\u8a08\u8abf\u67fb\u90e8\u6d88\u8cbb\u7d71\u8a08\u8ab2\u7269\u4fa1\u7d71\u8a08\u5ba4",
  RELEASE_DATE = "",
  LAST_MODIFIED_DATE = "",
  FREQUENCY_OF_UPDATE = "",
  LANDING_PAGE = "http://www.e-stat.go.jp/SG1/estat/GL08020103.do?_toGL08020103_&tclassID=000000700001&cycleCode=0&requestSender=search"
)

dataset_flattened <-
  list(
    STAT_NAME = "\u5168\u56fd\u7269\u4fa1\u7d71\u8a08\u8abf\u67fb",
    ORGANIZATION = "\u7dcf\u52d9\u7701",
    NAME = "\u5e73\u62109\u5e74\u5168\u56fd\u7269\u4fa1\u7d71\u8a08\u8abf\u67fb_\u5927\u898f\u6a21\u5e97\u8217\u7de8_1997\u5e74",
    TABULATION_CATEGORY = "\u5e73\u62109\u5e74\u5168\u56fd\u7269\u4fa1\u7d71\u8a08\u8abf\u67fb",
    TABULATION_SUB_CATEGORY1 = "\u5927\u898f\u6a21\u5e97\u8217\u7de8",
    TABULATION_SUB_CATEGORY2 = "",
    TABULATION_SUB_CATEGORY3 = "",
    TABULATION_SUB_CATEGORY4 = "",
    TABULATION_SUB_CATEGORY5 = "",
    CYCLE = "",
    SURVEY_DATE = "1997",
    DESCRIPTION = "",
    PUBLISHER = "\u7dcf\u52d9\u7701",
    CONTACT_POINT = "\u7d71\u8a08\u5c40\u7d71\u8a08\u8abf\u67fb\u90e8\u6d88\u8cbb\u7d71\u8a08\u8ab2\u7269\u4fa1\u7d71\u8a08\u5ba4",
    CREATOR = "\u7d71\u8a08\u5c40\u7d71\u8a08\u8abf\u67fb\u90e8\u6d88\u8cbb\u7d71\u8a08\u8ab2\u7269\u4fa1\u7d71\u8a08\u5ba4",
    RELEASE_DATE = "",
    LAST_MODIFIED_DATE = "",
    FREQUENCY_OF_UPDATE = "",
    LANDING_PAGE = "http://www.e-stat.go.jp/SG1/estat/GL08020103.do?_toGL08020103_&tclassID=000000700001&cycleCode=0&requestSender=search"
  )

test_that("multiplication works", {
  expect_equal(as_flattened_character(dataset_raw), dataset_flattened)
})
