
<!-- README.md is generated from README.Rmd. Please edit that file -->
e-Stat API for R
================

[![Travis-CI Build Status](https://travis-ci.org/yutannihilation/estatapi.svg?branch=master)](https://travis-ci.org/yutannihilation/estatapi) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/yutannihilation/estatapi?branch=master&svg=true)](https://ci.appveyor.com/project/yutannihilation/estatapi) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/estatapi)](http://cran.r-project.org/package=estatapi)

e-Stat API
----------

e-Stat is a service to get Statistics of Japan, which is provided by Japanese Government. See <http://www.e-stat.go.jp/api/>.

**The contents of e-Stat is not garanteed by Japanese Government**

Requirement
-----------

First, You need to register at e-Stat website to obtain `appId`.

Installation
------------

``` r
# Stable version
install.packages("estatapi")

# Development version
devtools::install_github("yutannihilation/estatapi")
```

Usage
-----

Currently, this package supports four methods of API v2. For the details about the query params, please read the official documentation at <http://www.e-stat.go.jp/api/e-stat-manual/>

### estat\_getStatsList

Get list of statistics matched with the provided query.

This function returns result as a `tbl_df`.

``` r
appId <- "XXXXXXXXX"
```

By default, the language of the datasets is Japanese.

``` r
library(estatapi)
#> このサービスは、政府統計総合窓口(e-Stat)のAPI機能を使用していますが、サービスの内容は国によって保証されたものではありません。

estat_getStatsList(appId = appId, searchWord = "chocolate")
#> # A tibble: 2 x 13
#>          @id      STAT_NAME GOV_ORG            STATISTICS_NAME
#>        <chr>          <chr>   <chr>                      <chr>
#> 1 0002050001 消費者物価指数  総務省 平成17年基準消費者物価指数
#> 2 0003036792 消費者物価指数  総務省 平成22年基準消費者物価指数
#> # ... with 9 more variables: TITLE <chr>, CYCLE <chr>, SURVEY_DATE <chr>,
#> #   OPEN_DATE <chr>, SMALL_AREA <chr>, MAIN_CATEGORY <chr>,
#> #   SUB_CATEGORY <chr>, OVERALL_TOTAL_NUMBER <chr>, UPDATED_DATE <chr>
```

You can add `lang = "E"` to search for English datasets. But be careful, not all datasets are translated into English and the translation may be wrong sometimes...

``` r
estat_getStatsList(appId = appId, lang = "E", searchWord = "chocolate")
#> # A tibble: 2 x 13
#>          @id            STAT_NAME
#>        <chr>                <chr>
#> 1 0002050001 Consumer Price Index
#> 2 0003036792 Consumer Price Index
#> # ... with 11 more variables: GOV_ORG <chr>, STATISTICS_NAME <chr>,
#> #   TITLE <chr>, CYCLE <chr>, SURVEY_DATE <chr>, OPEN_DATE <chr>,
#> #   SMALL_AREA <chr>, MAIN_CATEGORY <chr>, SUB_CATEGORY <chr>,
#> #   OVERALL_TOTAL_NUMBER <chr>, UPDATED_DATE <chr>
```

### estat\_getMetaInfo

Get meta-information about the data.

This function returns a list of `tbl_df`. Each `tbl_df` contains the meta-info for the correspondent column.

``` r
meta_info <- estat_getMetaInfo(appId = appId, lang = "E", statsDataId = "0003036792")

names(meta_info)
#> [1] "tab"    "cat01"  "area"   "time"   ".names"

meta_info$cat01
#> # A tibble: 798 x 4
#>    @code                                                      @name @level
#>    <chr>                                                      <chr>  <chr>
#> 1   0001                                                  All items      1
#> 2   0002                                                       Food      1
#> 3   0003                                                    Cereals      3
#> 4   0004                                                       Rice      5
#> 5   1000                                         Non-glutinous rice      6
#> 6   1001                            Rice-A(domestic), "Koshihikari"      7
#> 7   1002 Rice-B(domestic), non-blended rice excluding "Koshihikari"      7
#> 8   1011                                             Glutinous rice      6
#> 9   0005                                                      Bread      5
#> 10  1021                                                White bread      6
#> # ... with 788 more rows, and 1 more variables: @parentCode <chr>
```

### estat\_getStatsData

Get statistics.

Though only `appId` and `statsDataId` are required, I recommend you to use additional condition to save time.

``` r
estat_getStatsData(
  appId = appId,
  lang = "E",
  statsDataId = "0003036792",
  cdCat01 = c("0005","1021")
)
#> Fetching record 1-8102... (total: 8102 records)
#> # A tibble: 8,102 x 10
#>    tab_code Tabulated variable cat01_code Items area_code    AREA
#>       <chr>              <chr>      <chr> <chr>     <chr>   <chr>
#> 1         1              Index       0005 Bread     13A01 Ku-area
#> 2         1              Index       0005 Bread     13A01 Ku-area
#> 3         1              Index       0005 Bread     13A01 Ku-area
#> 4         1              Index       0005 Bread     13A01 Ku-area
#> 5         1              Index       0005 Bread     13A01 Ku-area
#> 6         1              Index       0005 Bread     13A01 Ku-area
#> 7         1              Index       0005 Bread     13A01 Ku-area
#> 8         1              Index       0005 Bread     13A01 Ku-area
#> 9         1              Index       0005 Bread     13A01 Ku-area
#> 10        1              Index       0005 Bread     13A01 Ku-area
#> # ... with 8,092 more rows, and 4 more variables: time_code <chr>,
#> #   Time <chr>, value <dbl>, unit <chr>
```

You may feel convenient with `limit` and `startPosition` to get data partially.

``` r
d1 <- estat_getStatsData(
        appId = appId, lang = "E", statsDataId = "0003036792", cdCat01 = c("0005","1021"),
        limit = 
      )
#> Fetching record 1-8102... (total: 8102 records)

d2 <- estat_getStatsData(
        appId = appId, lang = "E", statsDataId = "0003036792", cdCat01 = c("0005","1021"),
        startPosition=101,
        limit = 3
      )
#> Fetching record 101-103... (total: 8102 records)
#> There are more records; please rerun with startPosition=201

d <- bind_rows(d1, d2)
```

### getDataCatalog

Find statistical dataset files (Excel, CSV and PDF) and databases.

Note that this API returns only URL of the file or database and the data itself is not accessible via e-Stat API. You can download the file from the given URL, but it may be difficult to process the data by R.

``` r
catalog1 <- estat_getDataCatalog(appId = appId, lang = "E", searchWord = "population", dataType = c("PDF", "XLS"))

catalog1[1, c("@id", "STAT_NAME", "TABLE_NAME", "SURVEY_DATE", "TABLE_SUB_CATEGORY1", "DATASET_NAME", "NAME", "LANDING_PAGE", "URL", "FORMAT")] %>%
  glimpse
#> Observations: 1
#> Variables: 10
#> $ @id                 <chr> "000006727166"
#> $ STAT_NAME           <chr> "System of Social and Demographic Statistics"
#> $ TABLE_NAME          <chr> "Population and Households"
#> $ SURVEY_DATE         <chr> "2014"
#> $ TABLE_SUB_CATEGORY1 <chr> ""
#> $ DATASET_NAME        <chr> "Social Indicators by Prefecture 2014_Soci...
#> $ NAME                <chr> "A_Population and Households"
#> $ LANDING_PAGE        <chr> "http://www.e-stat.go.jp/SG1/estat/GL08020...
#> $ URL                 <chr> "http://www.e-stat.go.jp/SG1/estat/GL08020...
#> $ FORMAT              <chr> "XLS"
```
