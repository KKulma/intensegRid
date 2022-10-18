test_that("get_factors() works", {
  
  vcr::use_cassette("get_factors", {
    factors <- get_factors()
  })
  
  expect_type(factors, "list")
  expect_equal(ncol(factors), 2)
  expect_gt(ncol(factors), 0)
})


test_that("get_stats() works", {
  start <- "2019-04-01"
  end <- "2019-04-07"
  time_range <- as.numeric(as.Date(end) - as.Date(start))
  block <- 2
  time_blocks <- (time_range + 1) * (24 / block)
  
  vcr::use_cassette("get_stats_dates", {
    stats_dates <- get_stats(start, end)
  })

  vcr::use_cassette("get_stats_block", {
    stats_block <- get_stats(start, end, block)
  })
  
  expect_is(stats_dates, "data.frame")
  expect_equal(nrow(stats_dates), 1)
  expect_equal(ncol(stats_dates), 6)
  expect_equal(nrow(stats_block), time_blocks)
  expect_equal(ncol(stats_block), 6)
  
  expect_error(get_stats(start, "2019-05-02"))
  expect_error(get_stats(start, end, block = 25))
  expect_error(get_stats(start, end, block = 0.5))
})
