# estatapi 0.4.0

## Major Changes

* Use e-Stat API version 3.0.

# estatapi 0.3.0

## Major Changes

* `estat_getStatsData()` and `estat_getStatsList()` has been overhauled. Accordingly, each function
  returns the result with different colnames than before. I'm sorry, but this change was inevitable
  to fix bugs like [#7](https://github.com/yutannihilation/estatapi/issues/7)... For the details,
  please see [this gist](https://gist.github.com/yutannihilation/e89e3cab6212aa9a390c2c831310ddae).
* Treat most of parameters as formal arguments. Please be careful if you use unnamed arguments.
* Use e-Stat API version 2.1, which is released on Jul 14, 2016.
* `estat_getStatsData()` automatically repeats fetching records when the records are more than the
  number that can be fetched at one time (=100,000 records). You can stop this behaviour by specifying
  `limit` or `.fetch_all` argument.
* Add `getDataCatalog()`, which finds statistical dataset files (Excel, CSV and PDF) and databases.

## Minor Changes

* Show license notice on startup.
