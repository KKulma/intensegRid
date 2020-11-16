#' Fetch British carbon intensity data for specified time period
#'
#' @param start {character} A start date of the intesity.
#' @param end {character} An end date of the intesity data. The maximum date range is limited to 14 days.
#'
#' @return a data.frame with 1/2-hourly carbon intensity data for specified time period
#' @export
#' @importFrom rlang .data
#'
#' @examples \dontrun{
#' get_british_ci()
#' get_british_ci(start = '2019-01-01', end = '2019-01-02')
#' }
get_british_ci <-
  function(start = NULL,
           end = NULL) {
    url <- 'https://api.carbonintensity.org.uk/intensity/'
    
    if (all(is.null(c(start, end)))) {
      call <- url
    } else if (all(!is.null(c(start, end)))) {
      from_date <- paste0(as.Date(start), 'T00:00Z/')
      to_date <- paste0(as.Date(end), 'T23:59Z')
      
      call <- paste0(url, from_date, to_date)
    } else {
      stop('Both start and end arguments have to be either NULL or in use')
    }
    
    data <- get_data(call)
    
    result <- data %>%
      dplyr::mutate(from = lubridate::ymd_hm(.data$from),
                    to = lubridate::ymd_hm(.data$to)) %>%
      tibble::as_tibble()
    
    clean_names <- gsub('intensity.', '', colnames(result))
    colnames(result) <- clean_names
    
    result
  }



#' Get Carbon Intensity data for current half hour for a specified GB Region
#'
#' @param region {character} The name of the GB region, one of 'England', 'Scotland' or 'Wales'
#' @param start {character} A start date of the intesity
#' @param end {character} An end date of the intesity data
#'
#' @return a tibble
#' @export
#'@importFrom rlang .data
#'
#' @examples \dontrun{
#' get_national_ci()
#' get_national_ci('England')
#' get_national_ci('Scotland')
#' get_national_ci('Wales')
#' get_national_ci(start = '2019-01-01', end = '2019-01-02')
#' }
get_national_ci <-
  function(region = NULL,
           start = NULL,
           end = NULL) {
    if (!is.null(region) &&
        !region %in%  c('England', 'Scotland', 'Wales')) {
      stop("Region has to be either NULL or it must equate to one of 'England', 'Scotland', 'Wales'")
    }
    
    url <- 'https://api.carbonintensity.org.uk/regional/'
    
    
    if (all(is.null(c(region, start, end)))) {
      call <- url
    } else if (all(is.null(c(start, end)))) {
      call <- paste0(url, tolower(region), '/')
    } else if (all(!is.null(c(start, end)))) {
      from_date <- paste0(as.Date(start), 'T00:00Z/')
      to_date <- paste0(as.Date(end), 'T23:59Z')
      call <- paste0(url, 'intensity/', from_date, to_date)
    }
    
    data <- get_data(call)
    
    if (is.null(region)) {
      unnest_var <- "regions"
    } else {
      unnest_var <- "data"
    }
    
    result <- data %>%
      tidyr::unnest(unnest_var) %>%
      tidyr::unnest(.data$generationmix) %>%
      dplyr::mutate(to = lubridate::ymd_hm(.data$to),
                    from = lubridate::ymd_hm(.data$from)) %>%
      tibble::as_tibble()
    
    clean_names <- gsub('intensity.', '', colnames(result))
    colnames(result) <- clean_names
    
    result
    
  }



#' Get Carbon Intensity for specified postcode.
#'
#' @param postcode {character} Outward postcode i.e. RG41 or SW1 or TF8. Do not include full postcode, outward postcode only
#' @param start {character} A start date of the intesity data
#' @param end {character} An end date of the intesity data
#'
#' @return tibble
#' @export
#'
#' @importFrom rlang .data
#' @examples \dontrun{
#' get_postcode_ci(postcode = 'EN2')
#' get_postcode_ci(postcode = 'EN2', start = '2019-01-01', end = '2019-01-02')
#' }
get_postcode_ci <- function(postcode,
                            start = NULL,
                            end = NULL) {
  if (all(is.null(c(start, end)))) {
    url <- 'https://api.carbonintensity.org.uk/regional/postcode/'
    call <- paste0(url, postcode)
  } else if (all(!is.null(c(start, end)))) {
    from_date <- paste0(as.Date(start), 'T00:00Z/')
    to_date <- paste0(as.Date(end), 'T23:59Z/')
    
    url <- 'https://api.carbonintensity.org.uk/regional/intensity/'
    call <- paste0(url, from_date, to_date, 'postcode/', postcode)
  }
  
  data <- get_data(call)
  
  if (all(is.null(c(start, end)))) {
    result <- data %>%
      tidyr::unnest(.data$data) %>%
      tidyr::unnest(.data$generationmix) %>%
      dplyr::mutate(from = lubridate::ymd_hm(.data$from),
                    to = lubridate::ymd_hm(.data$to))
  } else {
    result <- data$data %>%
      tidyr::unnest(.data$generationmix) %>%
      dplyr::mutate(
        region = data$regionid,
        shortname = data$shortname,
        postcode = data$postcode,
        from = lubridate::ymd_hm(.data$from),
        to = lubridate::ymd_hm(.data$to)
      ) %>%
      dplyr::select(.data$region,
                    .data$shortname,
                    .data$postcode,
                    dplyr::everything())
  }
  
  clean_names <- gsub('intensity.', '', colnames(result))
  colnames(result) <- clean_names
  
  result
  
}


#' Get Carbon Intensity data between specified datetimes for specified region
#'
#' @param region_id {numeric} Region ID in the UK region. See list of Region IDs in \code{regions_lookup}
#' @param start {character} A start date of the intesity data
#' @param end {character} An end date of the intesity data
#'
#' @importFrom rlang .data
#' @return a tibble
#' @export
#'
#' @examples \dontrun{
#' get_regional_ci(13)
#' get_regional_ci(13, start = '2019-01-02', end = '2019-01-03')
#' }
get_regional_ci <- function(region_id,
                            start = NULL,
                            end = NULL) {
  url <- 'https://api.carbonintensity.org.uk/regional/regionid/'
  
  if (all(is.null(c(start, end)))) {
    call <- paste0(url, region_id)
  } else if (all(!is.null(c(region_id, start, end)))) {
    url <- 'https://api.carbonintensity.org.uk/regional/intensity/'
    
    from_date <- paste0(as.Date(start), 'T00:00Z/')
    to_date <- paste0(as.Date(end), 'T23:59Z/')
    
    call <- paste0(url, from_date, to_date, 'regionid/', region_id)
  } else {
    stop("Both start and end parameters must be NULL or in use")
  }
  
  data <- get_data(call)
  
  if (all(is.null(c(start, end))))
    result <- data %>%
    tidyr::unnest(data) %>%
    tidyr::unnest(.data$generationmix) %>%
    dplyr::mutate(to = lubridate::ymd_hm(.data$to),
                  from = lubridate::ymd_hm(.data$from))
  else {
    result <- data$data %>%
      tidyr::unnest(.data$generationmix) %>%
      dplyr::mutate(
        dnoregion = data$dnoregion,
        shortname = data$shortname,
        region_id = data$regionid,
        from = lubridate::ymd_hm(.data$from),
        to = lubridate::ymd_hm(.data$to)
      ) %>%
      dplyr::select(.data$dnoregion,
                    .data$shortname,
                    .data$region_id,
                    dplyr::everything())
  }
  
  clean_names <- gsub('intensity.', '', colnames(result))
  colnames(result) <- clean_names
  
  result
  
  
}
