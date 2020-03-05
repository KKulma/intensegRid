
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
#'
#' @return tibble
#' @export
#'
#' @examples \dontrun{
#' start <- "2019-04-01"
#' end <- "2019-04-07"
#' get_stats(start, end)
#' }
#'
get_stats <- function(start, end) {
  url <- "https://api.carbonintensity.org.uk/intensity/stats/"

  from_date <- paste0(as.Date(start), "T00:00Z/")
  to_date <- paste0(as.Date(end), "T23:59Z")

  call <- paste0(url, from_date, to_date)

  data <- get_data(call)

  result <- data %>%
    dplyr::mutate(from = lubridate::ymd_hm(!!rlang::sym("from")),
                  to = lubridate::ymd_hm(!!rlang::sym("to")))

  clean_names <- gsub('intensity.', '', colnames(result))
  colnames(result) <- clean_names

  result
}
