test_that("get_mix works", {
  start <- "2019-04-01"
  end <- "2019-04-07"
  
  vcr::use_cassette("get_mix", {
    raw <- get_mix()
  })
  
  vcr::use_cassette("raw_with_dates", {
    raw_with_dates <- get_mix(start, end)
  })
  
  expect_type(raw, "list")
  expect_gte(ncol(raw), 4)
  expect_gte(nrow(raw), 8)
  expect_type(raw$to, "double")
  expect_type(raw$from, "double")
  
  
  expect_type(raw_with_dates, "list")
  expect_gte(ncol(raw_with_dates), 4)
  expect_gte(nrow(raw_with_dates), 8)
  expect_type(raw_with_dates$to, "double")
  expect_type(raw_with_dates$from, "double")
})
