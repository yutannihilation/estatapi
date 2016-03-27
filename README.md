estatapi - 政府統計の総合窓口（e-Stat）のAPIを使うためのRパッケージ
==========================
[![Travis-CI Build Status](https://travis-ci.org/yutannihilation/estatapi.svg?branch=master)](https://travis-ci.org/yutannihilation/estatapi)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/yutannihilation/estatapi?branch=master&svg=true)](https://ci.appveyor.com/project/yutannihilation/estatapi)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/estatapi)](http://cran.r-project.org/package=estatapi)

_English version of README is [here](README.en.md)_

## e-Stat APIとは

e-Statは日本の統計情報が集まっているポータルサイトです。e-StatにはAPIが用意されていて、[ウェブサイト](http://www.e-stat.go.jp/api/)上でアカウントを登録すると使えるようになります。

## 事前準備

[利用ガイド](http://www.e-stat.go.jp/api/api-guide/)に従ってアプリケーションIDを取得してください。APIにアクセスする際は、`appId`というパラメータに取得したアプリケーションIDを指定します。

## インストール

estatapiはCRAN上に公開されているパッケージなので、通常通りインストールできます。

```r
install.packages("estatapi")
```

開発版をインストールするには`devtools::install_github()`を使ってください。

```r
devtools::install_github("yutannihilation/estatapi")
```

## 使い方

現在、このパッケージではバージョン2.0のうち3つをサポートしています。各APIの詳しい解説やパラメータの指定の仕方、返ってくる結果の意味は、公式ドキュメントを参照してください。

* [統計表情報取得](http://www.e-stat.go.jp/api/e-stat-manual/#api_2_1): 提供されている統計表を検索します。
* [メタ情報取得](http://www.e-stat.go.jp/api/e-stat-manual/#api_2_2): 統計データのメタ情報を取得します。
* [統計データ取得](http://www.e-stat.go.jp/api/e-stat-manual/#api_2_3): 統計データを取得します。 

### 統計表情報取得（`estat_getStatsList()`）

提供されている統計表を検索します。この関数は、結果を`tbl_df`（dplyrの`data.frame`。`data.frame`とほぼ同じように扱える）として返します。

例えば、「チョコレート」というキーワードを含む統計を検索するときは`searchWord`という引数にキーワードを指定して、以下のようにします。

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

### メタ情報取得（`getMetaInfo()`）

統計データのメタ情報を取得します。この関数は、結果を`list`として返します。`list`の各要素が、それぞれのデータ項目についてのメタ情報を含んだ`tbl_df`になっています。

例えば、`0003103532`というIDの統計に関するメタ情報を取得するには、`statsDataId`という引数にIDを指定して、以下のようにします。

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


### 統計データ取得（`getStatsData()`）

統計データを取得します。この関数は、結果をメタ情報と紐づけて`tbl_df`として返します。

ちなみに、必ず指定しなくてはいけないのは`appId`と`statsDataId`だけですが、それだけだとデータがかなり大きくなって取得に時間がかかります。`cdCat01`（分類事項01）などを指定して必要な項目だけに絞ることをおすすめします。他に絞り込みに指定できるパラメータについては公式ドキュメントを参照してください。


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

`limit`で取得する最大のレコード数を、`startPosition`で取得を始めるレコードの位置を指定することもできます。とりあえず少しだけ抜き出して見たい場合や、少しずつデータを取ってきたい場合には便利です。

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
