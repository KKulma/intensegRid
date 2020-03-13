

#' Get Carbon Intensity factors for each fuel type
#'
#' @return a tibble
#' @export
#'
#' @examples get_factors()
get_factors <- function() {
  url <- 'https://api.carbonintensity.org.uk/intensity/factors'
  data <- get_data(url)
  tidyr::gather(data)
}



#' Get Carbon Intensity statistics between from and to dates
#'
#' @param start {character} A start date of the stats data
#' @param end {character} An end date of the stats data
#' @param block {numeric} Block length in hours i.e. a block length of 2 hrs over a 24 hr period returns 12 items with the average, max, min for each 2 hr block
#'
#' @return tibble
#' @export
#'
#' @examples \dontrun{
#' start <- "2019-04-01"
#' end <- "2019-04-07"
#' get_stats(start, end)
#' get_stats(start, end, block = 2)
#' }
#'
get_stats <- function(start, end, block = NULL) {
  url <- "https://api.carbonintensity.org.uk/intensity/stats/"
  
  from_date <- paste0(as.Date(start), "T00:00Z/")
  to_date <- paste0(as.Date(end), "T23:59Z")
  
  if (!is.null(block)) {
    call <- paste0(url, from_date, to_date, "/", block)
  } else {
    call <- paste0(url, from_date, to_date)
  }
  
  data <- get_data(call)
  
  result <- data %>%
    dplyr::mutate(from = lubridate::ymd_hm(from),
                  to = lubridate::ymd_hm(to)) %>%
    tibble::as_tibble()
  
  
  clean_names <- gsub('intensity.', '', colnames(result))
  colnames(result) <- clean_names
  
  result
}
