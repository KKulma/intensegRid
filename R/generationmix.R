#' Get generation mix for current half hour
#'
#' @param start {character} A start date of the intesity data
#' @param end {character} An end date of the intesity data
#'
#' @return tibble
#' @export
#' @importFrom rlang .data
#' @examples \dontrun{
#' start <- "2019-04-01"
#' end <- "2019-04-07"
#' get_mix(start, end)
#' get_mix()}
get_mix <- function(start = NULL, end = NULL) {
  url <- 'https://api.carbonintensity.org.uk/generation/'
  
  if (all(!is.null(c(start, end)))) {
    from_date <- paste0(as.Date(start), "T00:00Z/")
    to_date <- paste0(as.Date(end), "T23:59Z")
    
    call <- paste0(url, from_date, to_date)
  } else {
    call <- url
  }
  
  data <- get_data(call)
  
  if (all(!is.null(c(start, end)))) {
    result <- data %>%
      tidyr::unnest(.data$generationmix) %>%
      dplyr::mutate(from = lubridate::ymd_hm(.data$from),
                    to = lubridate::ymd_hm(.data$to)) %>%
      tibble::as_tibble()
  } else {
    result <- data$generationmix %>%
      dplyr::mutate(from = lubridate::ymd_hm(data$from),
                    to = lubridate::ymd_hm(data$to)) %>%
      tibble::as_tibble()
  }
  
  result
  
}
