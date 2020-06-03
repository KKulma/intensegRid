test_that("get_factors() works", {
  expect_type(get_factors(), "list")
  expect_equal(ncol(get_factors()), 2)
  expect_gt(ncol(get_factors()), 0)
})


test_that("get_stats() works", {
  start <- "2019-04-01"
  end <- "2019-04-07"
  time_range <- as.numeric(as.Date(end) - as.Date(start))
  block <- 2
  time_blocks <- (time_range + 1) * (24 / block)
  
  expect_error(get_stats(10, 20))
  expect_error(get_stats(start, "2019-05-02"))
  expect_error(get_stats(start, end, block = 25))
  expect_error(get_stats(start, end, block = 0.5))
  expect_is(get_stats(start, end), "data.frame")
  expect_equal(nrow(get_stats(start, end)), 1)
  expect_equal(ncol(get_stats(start, end)), 6)
  expect_equal(nrow(get_stats(start, end, block)), time_blocks)
  expect_equal(ncol(get_stats(start, end, block)), 6)
})
