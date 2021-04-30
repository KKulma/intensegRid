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
    stop(paste0("ERROR: API request failed; status call is ", response$status_code))
  }
  
  response_content <-
    httr::content(response, as = "text", encoding = "UTF-8")
  
  data <-
    jsonlite::fromJSON(response_content, flatten = TRUE)[[1]]
  
  data
}

#' Tidy up intensity results column names
#'
#' @param result a data frame with raw results from Carbon Intensity API 
#'
#' @return data frame
#'
clean_colnames <- function(result) {
  clean_names <- gsub('intensity.', '', colnames(result))
  colnames(result) <- clean_names
  result
}
