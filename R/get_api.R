#' Fetch national carbon intensity data for specified time period
#'
#' @param start {character} A start date of the intesity data
#' @param end {character} An end date of the intesity data
#'
#' @return a data.frame with 1/2-hourly carbon intensity data for specified time period
#' @export
#'
#' @examples \dontrun{
#' start <- "2019-04-01"
#' end <- "2019-04-07"
#' get_intensity(start, end)
#' }
get_intensity <- function(start, end) {
  url <- "https://api.carbonintensity.org.uk/intensity/"
  from_date <- paste0(as.Date(start), "T00:00Z/")
  to_date <- paste0(as.Date(end), "T23:59Z")

  call <- paste0(url, from_date, to_date)

  get_data <- httr::GET(call)
  get_data_content <- httr::content(get_data, as = "text")

  data <- jsonlite::fromJSON(get_data_content, flatten = TRUE)[[1]]
  clean_names <- gsub('intensity.', '', colnames(data))
  colnames(data) <- clean_names

  data
}
