
<!-- README.md is generated from README.Rmd. Please edit that file -->

# e-Stat API for R

<!-- badges: start -->

[![R build
status](https://github.com/yutannihilation/estatapi/workflows/R-CMD-check/badge.svg)](https://github.com/yutannihilation/estatapi/actions)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/estatapi)](https://CRAN.R-project.org/package=estatapi)
<!-- badges: end -->

## e-Stat API

e-Stat is a service to get Statistics of Japan, which is provided by
Japanese Government. See <http://www.e-stat.go.jp/api/>.

**The contents of e-Stat is not garanteed by Japanese Government**

## Requirement

First, You need to register at e-Stat website to obtain `appId`.

## Installation

``` r
# Stable version
install.packages("estatapi")

# Development version
devtools::install_github("yutannihilation/estatapi")
```

## Usage

Currently, this package supports four methods of API v2. For the details
about the query params, please read the official documentation at
<http://www.e-stat.go.jp/api/e-stat-manual/>

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
#> # A tibble: 3 x 17
#>   `@id` STAT_NAME GOV_ORG STATISTICS_NAME TITLE CYCLE SURVEY_DATE OPEN_DATE
#> * <chr> <chr>     <chr>   <chr>           <chr> <chr> <chr>       <chr>    
#> 1 0002… 消費者物価指数… 総務省  平成17年基準消費者物価指数… 消費者物… -     0           2012-01-…
#> 2 0003… 消費者物価指数… 総務省  平成22年基準消費者物価指数… 消費者物… -     0           2017-01-…
#> 3 0003… 消費者物価指数… 総務省  2015年基準消費者物価指数… 消費者物… -     0           2020-03-…
#> # … with 9 more variables: SMALL_AREA <chr>, COLLECT_AREA <chr>,
#> #   MAIN_CATEGORY <chr>, SUB_CATEGORY <chr>, OVERALL_TOTAL_NUMBER <chr>,
#> #   UPDATED_DATE <chr>, TABULATION_CATEGORY <chr>, DESCRIPTION <chr>,
#> #   TABLE_NAME <chr>
```

You can add `lang = "E"` to search for English datasets. But be careful,
not all datasets are translated into English and the translation may be
wrong sometimes…

``` r
estat_getStatsList(appId = appId, lang = "E", searchWord = "chocolate")
#> # A tibble: 3 x 17
#>   `@id` STAT_NAME GOV_ORG STATISTICS_NAME TITLE CYCLE SURVEY_DATE OPEN_DATE
#> * <chr> <chr>     <chr>   <chr>           <chr> <chr> <chr>       <chr>    
#> 1 0002… Consumer… Minist… 2005-Base Cons… 2005… -     0           2012-01-…
#> 2 0003… Consumer… Minist… 2010-Base Cons… 2010… -     0           2017-01-…
#> 3 0003… Consumer… Minist… 2015-Base Cons… 2015… -     0           2020-03-…
#> # … with 9 more variables: SMALL_AREA <chr>, COLLECT_AREA <chr>,
#> #   MAIN_CATEGORY <chr>, SUB_CATEGORY <chr>, OVERALL_TOTAL_NUMBER <chr>,
#> #   UPDATED_DATE <chr>, TABULATION_CATEGORY <chr>, DESCRIPTION <chr>,
#> #   TABLE_NAME <chr>
```

### estat\_getMetaInfo

Get meta-information about the data.

This function returns a list of `tbl_df`. Each `tbl_df` contains the
meta-info for the correspondent column.

``` r
meta_info <- estat_getMetaInfo(appId = appId, lang = "E", statsDataId = "0003036792")

names(meta_info)
#> [1] "tab"    "cat01"  "area"   "time"   ".names"

meta_info$cat01
#> # A tibble: 798 x 4
#>    `@code` `@name`                                        `@level` `@parentCode`
#>  * <chr>   <chr>                                          <chr>    <chr>        
#>  1 0001    "All items"                                    1        <NA>         
#>  2 0002    "Food"                                         1        <NA>         
#>  3 0003    "Cereals"                                      3        0002         
#>  4 0004    "Rice"                                         5        0003         
#>  5 1000    "Non-glutinous rice"                           6        0004         
#>  6 1001    "Rice-A(domestic), \"Koshihikari\""            7        1000         
#>  7 1002    "Rice-B(domestic), non-blended rice excluding… 7        1000         
#>  8 1011    "Glutinous rice"                               6        0004         
#>  9 0005    "Bread"                                        5        0003         
#> 10 1021    "White bread"                                  6        0005         
#> # … with 788 more rows
```

### estat\_getStatsData

Get statistics.

Though only `appId` and `statsDataId` are required, I recommend you to
use additional condition to save time.

``` r
estat_getStatsData(
  appId = appId,
  lang = "E",
  statsDataId = "0003036792",
  cdCat01 = c("0005","1021")
)
#> Fetching record 1-8228... (total: 8228 records)
#> # A tibble: 8,228 x 11
#>    tab_code `Tabulated vari… cat01_code Items area_code AREA  time_code Time 
#>  * <chr>    <chr>            <chr>      <chr> <chr>     <chr> <chr>     <chr>
#>  1 1        Index            0005       Bread 13A01     Ku-a… 20160012… Dec.…
#>  2 1        Index            0005       Bread 13A01     Ku-a… 20160011… Nov.…
#>  3 1        Index            0005       Bread 13A01     Ku-a… 20160010… Oct.…
#>  4 1        Index            0005       Bread 13A01     Ku-a… 20160009… Sep.…
#>  5 1        Index            0005       Bread 13A01     Ku-a… 20160008… Aug.…
#>  6 1        Index            0005       Bread 13A01     Ku-a… 20160007… Jul.…
#>  7 1        Index            0005       Bread 13A01     Ku-a… 20160006… Jun.…
#>  8 1        Index            0005       Bread 13A01     Ku-a… 20160005… May …
#>  9 1        Index            0005       Bread 13A01     Ku-a… 20160004… Apr.…
#> 10 1        Index            0005       Bread 13A01     Ku-a… 20160003… Mar.…
#> # … with 8,218 more rows, and 3 more variables: unit <chr>, value <dbl>,
#> #   annotation <chr>
```

You may feel convenient with `limit` and `startPosition` to get data
partially.

``` r
d1 <- estat_getStatsData(
        appId = appId, lang = "E", statsDataId = "0003036792", cdCat01 = c("0005","1021"),
        limit = 
      )
#> Fetching record 1-8228... (total: 8228 records)

d2 <- estat_getStatsData(
        appId = appId, lang = "E", statsDataId = "0003036792", cdCat01 = c("0005","1021"),
        startPosition=101,
        limit = 3
      )
#> Fetching record 101-103... (total: 8228 records)
#> There are more records; please rerun with startPosition=201

d <- bind_rows(d1, d2)
```

### getDataCatalog

Find statistical dataset files (Excel, CSV and PDF) and databases.

Note that this API returns only URL of the file or database and the data
itself is not accessible via e-Stat API. You can download the file from
the given URL, but it may be difficult to process the data by R.

``` r
catalog1 <- estat_getDataCatalog(appId = appId, lang = "E", searchWord = "beef", dataType = c("PDF", "XLS"))

catalog1[1, c("@id", "STAT_NAME", "TABLE_NAME", "SURVEY_DATE", "TABLE_SUB_CATEGORY1", "DATASET_NAME", "NAME", "LANDING_PAGE", "URL", "FORMAT")] %>%
  glimpse
#> Rows: 1
#> Columns: 10
#> $ `@id`               <chr> "000000680105"
#> $ STAT_NAME           <chr> "Retail price survey"
#> $ TABLE_NAME          <chr> "Monthly Prices and Annual Average Prices by Ite…
#> $ SURVEY_DATE         <chr> "2001"
#> $ TABLE_SUB_CATEGORY1 <chr> "[1201 Beef] - [1341 Hen eggs]"
#> $ DATASET_NAME        <chr> "Retail Price Survey (Trend Survey)_Yearly_2001"
#> $ NAME                <chr> "Statistical Tables_1_Monthly Prices and Annual …
#> $ LANDING_PAGE        <chr> "https://www.e-stat.go.jp/en/stat-search/files?l…
#> $ URL                 <chr> "https://www.e-stat.go.jp/en/stat-search/file-do…
#> $ FORMAT              <chr> "XLS"
```
