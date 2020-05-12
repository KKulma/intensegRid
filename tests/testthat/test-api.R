start <- "2019-04-01"
end <- "2019-04-07" 
postcode  <- "EN2"


test_that("Junk input throws an error", {
  
  expect_error(get_factors(start))
  expect_error(get_british_ci(start))
  expect_error(get_mix(start))
  
  expect_error(
    check_coverage("junk input"),
    class = "http_error"
  )
  
  expect_error(
    get_travel_time(start_coord = "wrong_input",
                    end_coord = "wrong_input"),
    class = "http_error"
  )
  
})

test_that("Coverage check returns a boolean", {
  
  expect_equal(
    check_coverage("41.889083,12.470514"),TRUE
  )
  
})

test_that("check_coverage returns boolean with single input", {
  expect_true(check_coverage(coords[1]))
})

test_that("check_coverage returns vector containing booleans" , {
  expect_true(all(check_coverage(coords)))
  
  # Test for list inputs
  expect_true(all(check_coverage(as.list(coords))))
  
})
