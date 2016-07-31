context("try_dollar")

test_that("If x is a scalar value, return x as it is", {
  expect_equal(try_dollar(1), 1)
  expect_equal(try_dollar(TRUE), TRUE)
  expect_equal(try_dollar("a"), "a")
  expect_equal(try_dollar(as.Date("2015-01-01")), as.Date("2015-01-01"))
})

test_that("If x is a list with no `$` element, return x as it is", {
  expect_equal(try_dollar(list()), list())
  expect_equal(try_dollar(list(a = 1, b = 2)), list(a = 1, b = 2))
  expect_equal(try_dollar(iris), iris)
})

test_that("If x is a list with a `$` element, return `$` when .use_label = TRUE. Otherwise, return the other one", {
  expect_equal(try_dollar(list("$" = 1, "@id" = 111)), 1)
  expect_equal(try_dollar(list("$" = 1, "@id" = 111), .use_label = FALSE), 111)
})
