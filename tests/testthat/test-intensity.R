start <- '2020-01-01'
end <- '2020-01-02'

test_that("get_british_ci() works", {
  gb_no_dates <- get_british_ci()
  gb_with_dates <- get_british_ci(start, end)
  
  expect_gte(ncol(gb_no_dates), 5)
  expect_equal(nrow(gb_no_dates), 1)
  expect_is(gb_no_dates, "data.frame")
  
  expect_gte(ncol(gb_with_dates), 5)
  expect_equal(nrow(gb_with_dates), 96)
  expect_is(gb_with_dates, "data.frame")
  expect_error(get_british_ci(start, '2020-02-01'))
  expect_error(get_british_ci(start))
  expect_error(get_british_ci(end))
})


test_that("get_national_ci() works", {
  
  nat_no_dates <- get_national_ci()
  nat_en <- get_national_ci('England')
  nat_sct <- get_national_ci('Scotland')
  nat_wal <- get_national_ci('Wales')
  nat_with_dates <- get_national_ci(start = start, end = end)
  
  testset <- list(nat_no_dates,
                  nat_en,
                  nat_sct,
                  nat_wal,
                  nat_with_dates)
  
  purrr::map(testset, ~expect_gte(ncol(.x), 9))
  purrr::map(testset, ~expect_is(.x, "data.frame"))
  purrr::map(testset, ~expect_gte(nrow(.x), 9))
  
  expect_error(get_national_ci(start = start, end = '2019-12-31'))
  expect_error(get_national_ci("Wales", start = start, end = '2019-12-31'))
  expect_error(get_national_ci("Wales", start = start))
  
})

test_that("get_regional_ci() works", {
  reg_no_dates <- get_regional_ci(13)
  reg_with_dates <- get_regional_ci(13, start = start, end = end)
  
  expect_gte(ncol(reg_no_dates), 9)
  expect_equal(nrow(reg_no_dates), 9)
  expect_is(reg_no_dates, "data.frame")
  
  expect_gte(ncol(reg_with_dates), 9)
  expect_equal(nrow(reg_with_dates), 864)
  expect_is(reg_with_dates, "data.frame")
  expect_error(reg_with_dates(start, '2020-02-01'))
  expect_error(reg_with_dates(start))
  expect_error(reg_with_dates(end))
  
})


test_that("get_postcode_ci() works", {
  pc_no_dates <- get_postcode_ci(postcode = 'EN2')
  pc_with_dates <- get_postcode_ci(postcode = 'EN2', start = '2019-01-01', end = '2019-01-02')
  
  expect_gte(ncol(pc_no_dates), 10)
  expect_equal(nrow(pc_no_dates), 9)
  expect_is(pc_no_dates, "data.frame")
  
  expect_gte(ncol(pc_with_dates), 9)
  expect_equal(nrow(pc_with_dates), 864)
  expect_is(pc_with_dates, "data.frame")
  expect_error(pc_with_dates(start, '2020-02-01'))
  expect_error(pc_with_dates(start))
  expect_error(pc_with_dates(end))
})




