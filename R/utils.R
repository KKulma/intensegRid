#' Retrieve raw data from Carbon Intensity API
#'
#' @param call {character} API URL
#'
#' @return tibble
get_data <- function(call) {

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

  data
}
