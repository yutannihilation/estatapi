
<!-- README.md is generated from README.Rmd. Please edit that file -->

# estatapi - 政府統計の総合窓口（e-Stat）のAPIを使うためのRパッケージ

<!-- badges: start -->

[![R build
status](https://github.com/yutannihilation/estatapi/workflows/R-CMD-check/badge.svg)](https://github.com/yutannihilation/estatapi/actions)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/estatapi)](https://CRAN.R-project.org/package=estatapi)
<!-- badges: end -->


*English version of README is
[here](https://github.com/yutannihilation/estatapi/blob/master/README.en.md)*

## e-Stat APIとは

e-Statは日本の統計情報が集まっているポータルサイトです。e-StatにはAPIが用意されていて、[ウェブサイト](http://www.e-stat.go.jp/api/)上でアカウントを登録すると使えるようになります。

**このサービスは、政府統計総合窓口(e-Stat)のAPI機能を使用していますが、サービスの内容は国によって保証されたものではありません。**

## 事前準備

[利用ガイド](http://www.e-stat.go.jp/api/api-guide/)に従ってアプリケーションIDを取得してください。APIにアクセスする際は、`appId`というパラメータに取得したアプリケーションIDを指定します。

## インストール

estatapiはCRAN上に公開されているパッケージなので、通常通りインストールできます。

``` r
install.packages("estatapi")
```

開発版をインストールするには`devtools::install_github()`を使ってください。

``` r
devtools::install_github("yutannihilation/estatapi")
```

## 使い方

現在、このパッケージではバージョン2.0のうち4つをサポートしています。各APIの詳しい解説やパラメータの指定の仕方、返ってくる結果の意味は、公式ドキュメントを参照してください。

  - [統計表情報取得](http://www.e-stat.go.jp/api/e-stat-manual/#api_2_1):
    提供されている統計表を検索します。
  - [メタ情報取得](http://www.e-stat.go.jp/api/e-stat-manual/#api_2_2):
    統計データのメタ情報を取得します。
  - [統計データ取得](http://www.e-stat.go.jp/api/e-stat-manual/#api_2_3):
    統計データを取得します。
  - [データカタログ情報取得](http://www.e-stat.go.jp/api/e-stat-manual/#api_2_6):
    統計表ファイル（Excel、CSV、PDF）および統計データベースの情報を取得します。

### 統計表情報取得（`estat_getStatsList()`）

提供されている統計表を検索します。この関数は、結果を`tbl_df`（dplyrの`data.frame`。`data.frame`とほぼ同じように扱える）として返します。

例えば、「チョコレート」というキーワードを含む統計を検索するときは`searchWord`という引数にキーワードを指定して、以下のようにします。

``` r
appId <- "XXXXXXXXX"
```

``` r
library(estatapi)
#> このサービスは、政府統計総合窓口(e-Stat)のAPI機能を使用していますが、サービスの内容は国によって保証されたものではありません。

estat_getStatsList(appId = appId, searchWord = "チョコレート")
#> # A tibble: 241 x 22
#>    `@id` STAT_NAME GOV_ORG STATISTICS_NAME TITLE CYCLE SURVEY_DATE OPEN_DATE
#>  * <chr> <chr>     <chr>   <chr>           <chr> <chr> <chr>       <chr>    
#>  1 0000… 全国物価統計調査… 総務省  平成9年全国物価統計調査 大… 価格分布… -     199711      2007-09-…
#>  2 0000… 全国物価統計調査… 総務省  平成9年全国物価統計調査 小… 価格分布… -     199711      2007-09-…
#>  3 0000… 全国物価統計調査… 総務省  平成9年全国物価統計調査 消… 指数銘柄… -     199711      2007-09-…
#>  4 0000… 全国物価統計調査… 総務省  平成9年全国物価統計調査 消… 指数銘柄… -     199711      2007-09-…
#>  5 0000… 全国物価統計調査… 総務省  平成9年全国物価統計調査 消… 品目・銘… -     199711      2007-09-…
#>  6 0000… 全国物価統計調査… 総務省  平成9年全国物価統計調査 消… 品目・銘… -     199711      2007-09-…
#>  7 0000… 全国物価統計調査… 総務省  平成9年全国物価統計調査 消… 品目・銘… -     199711      2007-09-…
#>  8 0000… 全国物価統計調査… 総務省  平成9年全国物価統計調査 消… 品目・銘… -     199711      2007-09-…
#>  9 0003… 工業統計調査… 経済産業省… 工業統計調査 確報 平成25… 品目編 … 年次  201301-201… 2015-05-…
#> 10 0003… 工業統計調査… 経済産業省… 工業統計調査 確報 平成26… 品目編 … 年次  201401-201… 2016-04-…
#> # … with 231 more rows, and 14 more variables: SMALL_AREA <chr>,
#> #   COLLECT_AREA <chr>, MAIN_CATEGORY <chr>, SUB_CATEGORY <chr>,
#> #   OVERALL_TOTAL_NUMBER <chr>, UPDATED_DATE <chr>, TABULATION_CATEGORY <chr>,
#> #   TABULATION_SUB_CATEGORY1 <chr>, DESCRIPTION <chr>, TABLE_CATEGORY <chr>,
#> #   TABLE_NAME <chr>, TABULATION_SUB_CATEGORY2 <chr>,
#> #   TABLE_SUB_CATEGORY1 <chr>, TABULATION_SUB_CATEGORY3 <chr>
```

ここで、`STAT_NAME`や`GOV_ORG`は人間が読みやすい形式のラベルになっていますが、
プログラム中で扱う場合はコードのままの方が都合がいいこともあります。そのときは`.use_label
= FALSE`を指定してください。

``` r
estat_getStatsList(appId = appId, searchWord = "チョコレート", .use_label = FALSE)
#> # A tibble: 241 x 22
#>    `@id` STAT_NAME GOV_ORG STATISTICS_NAME TITLE CYCLE SURVEY_DATE OPEN_DATE
#>  * <chr> <chr>     <chr>   <chr>           <chr> <chr> <chr>       <chr>    
#>  1 0000… 00200572  00200   平成9年全国物価統計調査 大… 009   -     199711      2007-09-…
#>  2 0000… 00200572  00200   平成9年全国物価統計調査 小… 009   -     199711      2007-09-…
#>  3 0000… 00200572  00200   平成9年全国物価統計調査 消… 007   -     199711      2007-09-…
#>  4 0000… 00200572  00200   平成9年全国物価統計調査 消… 008   -     199711      2007-09-…
#>  5 0000… 00200572  00200   平成9年全国物価統計調査 消… 009   -     199711      2007-09-…
#>  6 0000… 00200572  00200   平成9年全国物価統計調査 消… 010   -     199711      2007-09-…
#>  7 0000… 00200572  00200   平成9年全国物価統計調査 消… 011   -     199711      2007-09-…
#>  8 0000… 00200572  00200   平成9年全国物価統計調査 消… 012   -     199711      2007-09-…
#>  9 0003… 00550010  00550   工業統計調査 確報 平成25… 1-05  年次  201301-201… 2015-05-…
#> 10 0003… 00550010  00550   工業統計調査 確報 平成26… 1-05  年次  201401-201… 2016-04-…
#> # … with 231 more rows, and 14 more variables: SMALL_AREA <chr>,
#> #   COLLECT_AREA <chr>, MAIN_CATEGORY <chr>, SUB_CATEGORY <chr>,
#> #   OVERALL_TOTAL_NUMBER <chr>, UPDATED_DATE <chr>, TABULATION_CATEGORY <chr>,
#> #   TABULATION_SUB_CATEGORY1 <chr>, DESCRIPTION <chr>, TABLE_CATEGORY <chr>,
#> #   TABLE_NAME <chr>, TABULATION_SUB_CATEGORY2 <chr>,
#> #   TABLE_SUB_CATEGORY1 <chr>, TABULATION_SUB_CATEGORY3 <chr>
```

### メタ情報取得（`estat_getMetaInfo()`）

統計データのメタ情報を取得します。この関数は、結果を`list`として返します。`list`の各要素が、それぞれのデータ項目についてのメタ情報を含んだ`tbl_df`になっています。

例えば、`0003103532`というIDの統計に関するメタ情報を取得するには、`statsDataId`という引数にIDを指定して、以下のようにします。

``` r
meta_info <- estat_getMetaInfo(appId = appId, statsDataId = "0003103532")

names(meta_info)
#> [1] "tab"    "cat01"  "cat02"  "area"   "time"   ".names"

meta_info$cat01
#> # A tibble: 703 x 5
#>    `@code`   `@name`                            `@level` `@unit`  `@parentCode`
#>  * <chr>     <chr>                              <chr>    <chr>    <chr>        
#>  1 000100000 世帯数分布（抽出率調整）           1        一万分比 <NA>         
#>  2 000200000 集計世帯数                         1        世帯     <NA>         
#>  3 000300000 世帯人員                           1        人       <NA>         
#>  4 000400000 18歳未満人員                       2        人       000300000    
#>  5 000500000 65歳以上人員                       2        人       000300000    
#>  6 000600000 65歳以上無職者人員                 3        人       000500000    
#>  7 000700000 有業人員                           1        人       <NA>         
#>  8 000800000 世帯主の年齢                       1        歳       <NA>         
#>  9 000900000 持家率                             1        ％       <NA>         
#> 10 001000000 家賃・地代を支払っている世帯の割合 1        ％       <NA>         
#> # … with 693 more rows
```

### 統計データ取得（`estat_getStatsData()`）

統計データを取得します。この関数は、結果をメタ情報と紐づけて`tbl_df`として返します。

必ず指定しなくてはいけないのは`appId`と`statsDataId`だけですが、それだけだとデータがかなり大きくなって取得に時間がかかります。`cdCat01`（分類事項01）などを指定して必要な項目だけに絞ることをおすすめします。他に絞り込みに指定できるパラメータについては公式ドキュメントを参照してください。

``` r
estat_getStatsData(
  appId = appId,
  statsDataId = "0003103532",
  cdCat01 = c("010800130","010800140")
)
#> Fetching record 1-17792... (total: 17792 records)
#> # A tibble: 17,792 x 13
#>    tab_code 表章項目 cat01_code `品目分類（27年改定）`… cat02_code 世帯区分 area_code
#>  * <chr>    <chr>    <chr>      <chr>            <chr>      <chr>    <chr>    
#>  1 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#>  2 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#>  3 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#>  4 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#>  5 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#>  6 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#>  7 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#>  8 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#>  9 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#> 10 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#> # … with 17,782 more rows, and 6 more variables: 地域区分 <chr>,
#> #   time_code <chr>, `時間軸（月次）` <chr>, unit <chr>, value <dbl>,
#> #   annotation <chr>
```

`limit`で取得する最大のレコード数を、`startPosition`で取得を始めるレコードの位置を指定することもできます。とりあえず少しだけ抜き出して見たい場合や、少しずつデータを取ってきたい場合にはこれらのパラメータが便利です。

``` r
estat_getStatsData(
  appId = appId, statsDataId = "0003103532", cdCat01 = c("010800130","010800140"),
  limit = 3
)
#> Fetching record 1-3... (total: 17792 records)
#> # A tibble: 3 x 13
#>   tab_code 表章項目 cat01_code `品目分類（27年改定）`… cat02_code 世帯区分 area_code
#> * <chr>    <chr>    <chr>      <chr>            <chr>      <chr>    <chr>    
#> 1 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#> 2 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#> 3 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#> # … with 6 more variables: 地域区分 <chr>, time_code <chr>,
#> #   `時間軸（月次）` <chr>, unit <chr>, value <dbl>, annotation <chr>

estat_getStatsData(
  appId = appId, statsDataId = "0003103532", cdCat01 = c("010800130","010800140"),
  startPosition = 101,
  limit = 3
)
#> Fetching record 101-103... (total: 17792 records)
#> # A tibble: 3 x 13
#>   tab_code 表章項目 cat01_code `品目分類（27年改定）`… cat02_code 世帯区分 area_code
#> * <chr>    <chr>    <chr>      <chr>            <chr>      <chr>    <chr>    
#> 1 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#> 2 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#> 3 01       金額     010800130  352 チョコレート 03         二人以上の世帯… 00000    
#> # … with 6 more variables: 地域区分 <chr>, time_code <chr>,
#> #   `時間軸（月次）` <chr>, unit <chr>, value <dbl>, annotation <chr>
```

### データカタログ情報取得（`estat_getDataCatalog()`）

統計表ファイル（Excel、CSV、PDF）および統計データベースの情報を取得できます。

このAPIはファイルのURLを返すだけなので、そのままRで処理することは難しいかもしれません。

``` r
catalog1 <- estat_getDataCatalog(appId = appId, searchWord = "チョコレート", dataType = c("PDF", "XLS"))

catalog1[1, c("@id", "STAT_NAME", "TABLE_NAME", "SURVEY_DATE", "TABLE_SUB_CATEGORY1", "DATASET_NAME", "NAME", "LANDING_PAGE", "URL", "FORMAT")] %>%
  glimpse
#> Rows: 1
#> Columns: 10
#> $ `@id`               <chr> "000000701890"
#> $ STAT_NAME           <chr> "全国物価統計調査"
#> $ TABLE_NAME          <chr> "業態別価格分布－全国，都市階級，都道府県"
#> $ SURVEY_DATE         <chr> "1997"
#> $ TABLE_SUB_CATEGORY1 <chr> "0104チョコレート"
#> $ DATASET_NAME        <chr> "平成9年全国物価統計調査_大規模店舗編_1997年"
#> $ NAME                <chr> "価格分布_1_業態別価格分布－全国，都市階級，都道府県_0104チョコレート"
#> $ LANDING_PAGE        <chr> "https://www.e-stat.go.jp/stat-search/files?layo…
#> $ URL                 <chr> "https://www.e-stat.go.jp/stat-search/file-downl…
#> $ FORMAT              <chr> "XLS"
```
