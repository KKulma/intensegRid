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
#' get_national_ci(start, end)
#' get_national_ci(start, end, regional = TRUE)
#' }
get_national_ci <- function(start, end, regional = FALSE) {
  if (regional) {
    url <-
      url <-
      'https://api.carbonintensity.org.uk/regional/intensity/'
  } else {
    url <- "https://api.carbonintensity.org.uk/intensity/"
  }

  from_date <- paste0(as.Date(start), "T00:00Z/")
  to_date <- paste0(as.Date(end), "T23:59Z")

  call <- paste0(url, from_date, to_date)

  data <- get_data(call)

  if (regional) {
    data <- data %>%
      tidyr::unnest(!!rlang::sym("regions")) %>%
      tidyr::unnest(!!rlang::sym("generationmix"))
  }

  clean_names <- gsub('intensity.', '', colnames(data))
  colnames(data) <- clean_names

  data
}


#' Get generation mix for current half hour
#'
#' @param start {character} A start date of the intesity data
#' @param end {character} An end date of the intesity data
#'
#' @return tibble
#' @export
#'
#' @examples \dontrun{
#' start <- "2019-04-01"
#' end <- "2019-04-07"
#' get_mix(start, end)
#' get_mix()}
get_mix <- function(start = NULL, end = NULL) {
  url <- 'https://api.carbonintensity.org.uk/generation/'

  if (!is.null(start) && !is.null(end)) {
    from_date <- paste0(as.Date(start), "T00:00Z/")
    to_date <- paste0(as.Date(end), "T23:59Z")

    call <- paste0(url, from_date, to_date)
  } else {
    call <- url
  }

  data <- get_data(call)

  if (!is.null(start) && !is.null(end)) {
    result <- data %>%
      tidyr::unnest(!!rlang::sym("generationmix")) %>%
      dplyr::mutate(
        from = lubridate::ymd_hm(!!rlang::sym("from")),
        to = lubridate::ymd_hm(!!rlang::sym("to"))
      )
  } else {
    result <- data$generationmix %>%
      dplyr::mutate(from = lubridate::ymd_hm(data$from),
                    to = lubridate::ymd_hm(data$to))
  }

  result

}



#' Get Carbon Intensity data for current half hour for a specified GB Region
#'
#' @param region {character} The name of the GB region, one of "England", "Scotland" or "Wales"
#'
#' @return a tibble
#' @export
#'
#' @examples
#' get_regional_ci("England")
#' get_regional_ci("Scotland")
#' get_regional_ci("Wales")
get_regional_ci <-
  function(region = c("England", "Scotland", "Wales")) {
    url <- "https://api.carbonintensity.org.uk/regional/"
    call <- paste0(url, tolower(region), '/')

    data <- get_data(call)

    result <- tidyr::unnest(data, data) %>%
      tidyr::unnest(generationmix)

    clean_names <- gsub('intensity.', '', colnames(result))
    colnames(result) <- clean_names

    result

  }



#' Get Regional Carbon Intensity data for current half hour for specified postcode.
#'
#' @param postcode {character} Outward postcode i.e. RG41 or SW1 or TF8. Do not include full postcode, outward postcode only
#'
#' @return tibble
#' @export
#'
#' @examples get_ci_by_postcode("SW1")
get_postcode_ci <- function(postcode, regional = FALSE) {

  if (regional) {
    url <- "https://api.carbonintensity.org.uk/regional/postcode/"
  } else {
    url <- "https://api.carbonintensity.org.uk/regional/postcode/"
  }

  call <- paste0(url, postcode)

  data <- get_data(call)

  result <- data %>%
    tidyr::unnest(data) %>%
    tidyr::unnest(generationmix)

  clean_names <- gsub('intensity.', '', colnames(result))
  colnames(result) <- clean_names

  result

}




