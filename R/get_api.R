#' Fetch national carbon intensity data for specified time period
#'
#' @param start {character} A start date of the intesity data
#' @param end {character} An end date of the intesity data
#' @param regional {logical} Whether the carbon intensity data should contain regional break down. Set to FALSE by default.
#'
#' @return a data.frame with 1/2-hourly carbon intensity data for specified time period
#' @export
#'
#' @examples \dontrun{
#' start <- "2019-04-01"
#' end <- "2019-04-07"
#' get_intensity(start, end)
#' get_intensity(start, end, regional = TRUE)
#' }
get_intensity <- function(start, end, regional = FALSE) {
  if (regional) {
    url <-
      url <- 'https://api.carbonintensity.org.uk/regional/intensity/'
  } else {
    url <- "https://api.carbonintensity.org.uk/intensity/"
  }

  from_date <- paste0(as.Date(start), "T00:00Z/")
  to_date <- paste0(as.Date(end), "T23:59Z")

  call <- paste0(url, from_date, to_date)

  get_data <- httr::GET(call)


  if (get_data$status_code != 200) {
    stop(paste0("ERROR: The status call is ", get_data$status_code))
  } else {
    get_data_content <-
      httr::content(get_data, as = "text", encoding = "UTF-8")

    data <-
      jsonlite::fromJSON(get_data_content, flatten = TRUE)[[1]]

    if (regional) {
      data <- data %>%
        tidyr::unnest(!!rlang::sym("regions")) %>%
        tidyr::unnest(!!rlang::sym("generationmix"))
    }

    clean_names <- gsub('intensity.', '', colnames(data))
    colnames(data) <- clean_names
  }
  data
}


#' Get generation mix for current half hour
#'
#' @return tibble
#' @export
#'
#' @examples \dontrun{
#' get_current_mix()}
get_current_mix <- function() {
  url <- 'https://api.carbonintensity.org.uk/generation'
  get_data <- httr::GET(url)

  if (get_data$status_code != 200) {
    stop(paste0("ERROR: The status call is ", get_data$status_code))
  } else {
    get_data_content <-
      httr::content(get_data, as = "text", encoding = "UTF-8")

    data <-
      jsonlite::fromJSON(get_data_content, flatten = TRUE)[[1]]

    result <- data$generationmix %>%
      dplyr::mutate(from = lubridate::ymd_hm(data$from),
                    to = lubridate::ymd_hm(data$to))
  }

  result

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

  get_data <- httr::GET(call)

  if (get_data$status_code != 200) {
    stop(paste0("ERROR: The status call is ", get_data$status_code))
  } else {
    get_data_content <- httr::content(get_data, as = "text", encoding = "UTF-8")
    data <- jsonlite::fromJSON(get_data_content, flatten = TRUE)[[1]]

    result <- data %>%
      dplyr::mutate(from = lubridate::ymd_hm(!!rlang::sym("from")),
                    to = lubridate::ymd_hm(!!rlang::sym("to"))
      )

    clean_names <- gsub('intensity.', '', colnames(result))
    colnames(result) <- clean_names
  }
  result
}
