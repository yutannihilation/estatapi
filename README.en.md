e-Stat API for R
==========================
[![Travis-CI Build Status](https://travis-ci.org/yutannihilation/estatapi.svg?branch=master)](https://travis-ci.org/yutannihilation/estatapi)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/yutannihilation/estatapi?branch=master&svg=true)](https://ci.appveyor.com/project/yutannihilation/estatapi)

## e-Stat API

e-Stat is a service to get Statistics of Japan, which is provided by Japanese Government. See http://www.e-stat.go.jp/api/.

## Requirement

First, You need to register at e-Stat website to obtain `appId`.

## Installation

```r
devtools::install_github("yutannihilation/estatapi")
```

## Usage

Currently, this package supports three methods of API v2. For the details about the query params, please read the official documentation at http://www.e-stat.go.jp/api/e-stat-manual/

### estat_getStatsList

Get list of statistics matched with the provided query.

This function returns result as a `tbl_df`.

```r
appId <- "XXXXXXXXX"

estat_getStatsList(appId = appId, searchWord = "チョコレート")
#> Source: local data frame [166 x 19]
#> 
#>           @id STAT_NAME.@code      STAT_NAME.$ GOV_ORG.@code GOV_ORG.$                                STATISTICS_NAME TITLE.@no
#>         (chr)           (chr)            (chr)         (chr)     (chr)                                          (chr)     (chr)
#> 1  0000100087        00200572 全国物価統計調査         00200    総務省           平成9年全国物価統計調査 大規模店舗編       009
#> 2  0000100104        00200572 全国物価統計調査         00200    総務省           平成9年全国物価統計調査 小規模店舗編       009
#> 3  0000100125        00200572 全国物価統計調査         00200    総務省 平成9年全国物価統計調査 消費者物価地域差指数編       007
#> 4  0000100126        00200572 全国物価統計調査         00200    総務省 平成9年全国物価統計調査 消費者物価地域差指数編       008
#> 5  0000100127        00200572 全国物価統計調査         00200    総務省 平成9年全国物価統計調査 消費者物価地域差指数編       009
#> 6  0000100128        00200572 全国物価統計調査         00200    総務省 平成9年全国物価統計調査 消費者物価地域差指数編       010
#> 7  0000100129        00200572 全国物価統計調査         00200    総務省 平成9年全国物価統計調査 消費者物価地域差指数編       011
#> 8  0000100130        00200572 全国物価統計調査         00200    総務省 平成9年全国物価統計調査 消費者物価地域差指数編       012
#> 9  0000100146        00200572 全国物価統計調査         00200    総務省          平成14年全国物価統計調査 大規模店舗編       009
#> 10 0000100162        00200572 全国物価統計調査         00200    総務省          平成14年全国物価統計調査 小規模店舗編       009
#> ..        ...             ...              ...           ...       ...                                            ...       ...
#> Variables not shown: TITLE.$ (chr), CYCLE (chr), SURVEY_DATE (chr), OPEN_DATE (chr), SMALL_AREA (chr), MAIN_CATEGORY.@code (chr),
#>   MAIN_CATEGORY.$ (chr), SUB_CATEGORY.@code (chr), SUB_CATEGORY.$ (chr), OVERALL_TOTAL_NUMBER (chr), UPDATED_DATE (chr), TITLE (chr)
```

### getMetaInfo

Get meta-information about the data.

This function returns a list of `tbl_df`. Each `tbl_df` contains the meta-info for the correspondent column.

```r
meta_info <- estat_getMetaInfo(appId = appId, statsDataId = "0003103532")

names(meta_info)
#> [1] "tab"   "cat01" "cat02" "area"  "time" 

meta_info$cat01
#> Source: local data frame [703 x 5]
#> 
#>        @code                              @name @level    @unit @parentCode
#>        (chr)                              (chr)  (chr)    (chr)       (chr)
#> 1  000100000           世帯数分布（抽出率調整）      1 一万分比          NA
#> 2  000200000                         集計世帯数      1     世帯          NA
#> 3  000300000                           世帯人員      1       人          NA
#> 4  000400000                       18歳未満人員      2       人   000300000
#> 5  000500000                       65歳以上人員      2       人   000300000
#> 6  000600000                 65歳以上無職者人員      3       人   000500000
#> 7  000700000                           有業人員      1       人          NA
#> 8  000800000                       世帯主の年齢      1       歳          NA
#> 9  000900000                             持家率      1       ％          NA
#> 10 001000000 家賃・地代を支払っている世帯の割合      1       ％          NA
#> ..       ...                                ...    ...      ...         ...
```


### getStatsData

Get statistics.

Though only `appId` and `statsDataId` are required, I recommend you to use additional condition to save time.

```r
estat_getStatsData(
  appId = appId,
  statsDataId = "0003103532",
  cdCat01 = c("010800130","010800140")
)
#> Source: local data frame [12,176 x 13]
#> 
#>     @tab    @cat01 @cat02 @area      @time @unit     $ value tab_info       cat01_info                 cat02_info area_info  time_info
#>    (chr)     (chr)  (chr) (chr)      (chr) (chr) (chr) (dbl)    (chr)            (chr)                      (chr)     (chr)      (chr)
#> 1     01 010800130     03 00000 2015000909    円   326   326     金額 352 チョコレート 二人以上の世帯（2000年～）      全国  2015年9月
#> 2     01 010800130     03 00000 2015000808    円   212   212     金額 352 チョコレート 二人以上の世帯（2000年～）      全国  2015年8月
#> 3     01 010800130     03 00000 2015000707    円   213   213     金額 352 チョコレート 二人以上の世帯（2000年～）      全国  2015年7月
#> 4     01 010800130     03 00000 2015000606    円   268   268     金額 352 チョコレート 二人以上の世帯（2000年～）      全国  2015年6月
#> 5     01 010800130     03 00000 2015000505    円   286   286     金額 352 チョコレート 二人以上の世帯（2000年～）      全国  2015年5月
#> 6     01 010800130     03 00000 2015000404    円   334   334     金額 352 チョコレート 二人以上の世帯（2000年～）      全国  2015年4月
#> 7     01 010800130     03 00000 2015000303    円   530   530     金額 352 チョコレート 二人以上の世帯（2000年～）      全国  2015年3月
#> 8     01 010800130     03 00000 2015000202    円  1324  1324     金額 352 チョコレート 二人以上の世帯（2000年～）      全国  2015年2月
#> 9     01 010800130     03 00000 2015000101    円   559   559     金額 352 チョコレート 二人以上の世帯（2000年～）      全国  2015年1月
#> 10    01 010800130     03 00000 2014001212    円   548   548     金額 352 チョコレート 二人以上の世帯（2000年～）      全国 2014年12月
#> ..   ...       ...    ...   ...        ...   ...   ...   ...      ...              ...                        ...       ...        ...
```

You may feel convenient with `limit` and `startPosition` to get data partially.

```r
d1 <- estat_getStatsData(
        appId = appId, statsDataId = "0003103532", cdCat01 = c("010800130","010800140"),
        limit = 100
      )
#> There are more records; please rerun with startPosition=101

d2 <- estat_getStatsData(
        appId = appId, statsDataId = "0003103532", cdCat01 = c("010800130","010800140"),
        limit = 100,
        startPosition=101
      )
#> There are more records; please rerun with startPosition=201

d <- bind_rows(d1, d2)
```
