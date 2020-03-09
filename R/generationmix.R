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
#' get_current_mix(start, end)
#' get_current_mix()}
get_mix <- function(start = NULL, end = NULL) {
  url <- 'https://api.carbonintensity.org.uk/generation/'

  if (!is.null(start) && !is.null(end)) {
    from_date <- paste0(as.Date(start), "T00:00Z/")
    to_date <- paste0(as.Date(end), "T23:59Z")

    call <- paste0(url, from_date, to_date)
  } else {
    call <- url
  }

  response <- httr::GET(call)

  if (httr::http_type(response) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  if (response$status_code != 200) {
    stop(paste0("ERROR: The status call is ", response$status_code))
  }

  response_content <-
    httr::content(response, as = "text", encoding = "UTF-8")

  data <-
    jsonlite::fromJSON(response_content, flatten = TRUE)[[1]]

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
