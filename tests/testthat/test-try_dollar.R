context("try_dollar")

test_that("If x is a scalar value, return x as it is", {
  expect_equal(try_dollar(1), 1)
  expect_equal(try_dollar(TRUE), TRUE)
  expect_equal(try_dollar("a"), "a")
  expect_equal(try_dollar(as.Date("2015-01-01")), as.Date("2015-01-01"))
})
