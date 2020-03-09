#' Fetch British carbon intensity data for specified time period
#'
#' @param start {character} A start date of the intesity data
#' @param end {character} An end date of the intesity data
#' @param date {character} A date for the intensity data
#' @param period {numeric} Half hour settlement period between 1-48 e.g. 42
#'
#' @return a data.frame with 1/2-hourly carbon intensity data for specified time period
#' @export
#'
#' @examples \dontrun{
#' get_british_ci()
#' get_british_ci(date = '2019-12-31')
#' get_british_ci(date = '2019-12-31', period = 48)
#' get_british_ci(start = '2019-01-01', end = '2019-12-31')
#' }
get_british_ci <- function(date = NULL, period = NULL, start = NULL, end = NULL) {
  url <- 'https://api.carbonintensity.org.uk/intensity/'

  if (!is.null(period) && !dplyr::between(period, 1, 48)) {
    stop('period argument can only take values between 1 and 48')
  }

  if (all(is.null(c(start, end, date, period)))) {
    call <- url
  } else if (all(!is.null(c(start, end))) && all(is.null(c(date, period)))) {
    from_date <- paste0(as.Date(start), 'T00:00Z/')
    to_date <- paste0(as.Date(end), 'T23:59Z')
    call <- paste0(url, from_date, to_date)
  } else if (!is.null(date) && all(is.null(c(start, end, period)))) {
    url <- paste0(url, 'date/')
    call <- paste0(url, date)
  } else if (all(!is.null(c(date, period))) && all(is.null(c(start, end)))) {
    url <- paste0(url, 'date/')
    call <- paste0(url, date, '/', period)

  } else {
    stop('Both start and end arguments have to be either NULL or in use')
  }

  data <- get_data(call)

  clean_names <- gsub('intensity.', '', colnames(data))
  colnames(data) <- clean_names

  data <- data %>%
    dplyr::mutate(from = lubridate::ymd_hm(from),
           to = lubridate::ymd_hm(to))

  data
}



#' Get Carbon Intensity data for current half hour for a specified GB Region
#'
#' @param region {character} The name of the GB region, one of 'England', 'Scotland' or 'Wales'
#'
#' @return a tibble
#' @export
#'
#' @examples
#' get_national_ci('England')
#' get_national_ci('Scotland')
#' get_national_ci('Wales')
get_national_ci <- function(region = NULL) {

    if (!is.null(region) && !region %in%  c('England', 'Scotland', 'Wales')) {
      stop("Region has to be either NULL or it must equate to one of 'England', 'Scotland', 'Wales'")
    }

    url <- 'https://api.carbonintensity.org.uk/regional/'


    if (is.null(region)) {
      call <- url
    } else {
      call <- paste0(url, tolower(region), '/')
    }

    data <- get_data(call)

    if (is.null(region)) {
      unnest_var <- "regions"
    } else {
      unnest_var <- "data"
    }

    result <- data %>%
      tidyr::unnest(unnest_var) %>%
      tidyr::unnest(generationmix) %>%
      dplyr::mutate(to = lubridate::ymd_hm(to),
             from = lubridate::ymd_hm(from))

    clean_names <- gsub('intensity.', '', colnames(result))
    colnames(result) <- clean_names

    result

  }



#' Get Regional Carbon Intensity data for current half hour for specified postcode.
#'
#' @param postcode {character} Outward postcode i.e. RG41 or SW1 or TF8. Do not include full postcode, outward postcode only
#' @param start {character} A start date of the intesity data
#' @param end {character} An end date of the intesity data
#'
#' @return tibble
#' @export
#'
#' @examples
#' get_postcode_ci(postcode = 'EN2')
#' get_postcode_ci(postcode = 'EN2', start = '2019-01-01', end = '2019-01-02')
get_postcode_ci <- function(postcode, start = NULL, end = NULL) {

  if (is.null(start) && is.null(end)) {
    url <- 'https://api.carbonintensity.org.uk/regional/postcode/'
    call <- paste0(url, postcode)
  } else if (!is.null(start) && !is.null(end)) {

    from_date <- paste0(as.Date(start), 'T00:00Z/')
    to_date <- paste0(as.Date(end), 'T23:59Z/')

    url <- 'https://api.carbonintensity.org.uk/regional/intensity/'
    call <- paste0(url, from_date, to_date, 'postcode/', postcode )
   }

  data <- get_data(call)

  if (is.null(start) && is.null(end)) {
  result <- data %>%
    tidyr::unnest(data) %>%
    tidyr::unnest(generationmix)
  } else {
    result <- data$data %>%
      tidyr::unnest(generationmix) %>%
      dplyr::mutate(region = data$regionid,
                    shortname = data$shortname,
                    postcode = data$postcode,
                    from = lubridate::ymd_hm(from),
                    to = lubridate::ymd_hm(to)) %>%
      dplyr::select(region, shortname, postcode, everything()) %>% glimpse()
  }

  clean_names <- gsub('intensity.', '', colnames(result))
  colnames(result) <- clean_names

  result

}


#' Title
#'
#' @param region_id {numeric} region id as shown in the \code{regions_lookup}
#' @param start {character} A start date of the intesity data
#' @param end {character} An end date of the intesity data
#'
#' @return a tibble
#' @export
#'
#' @examples get_regional_ci(13)
get_regional_ci <- function(region_id = NULL, start = NULL, end = NULL) {

  url <- 'https://api.carbonintensity.org.uk/regional/regionid/'

  if (!is.null(region_id) && all(is.null(c(start, end)))) {
    call <- paste0(url, region_id)
  }

  data <- get_data(call)

  result <- data %>%
    tidyr::unnest(data) %>%
    tidyr::unnest(generationmix) %>%
    dplyr::mutate(to = lubridate::ymd_hm(to),
                  from = lubridate::ymd_hm(from))

  clean_names <- gsub('intensity.', '', colnames(result))
  colnames(result) <- clean_names

  result


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
#' start <- '2019-04-01'
#' end <- '2019-04-07'
#' get_mix(start, end)
#' get_mix()}
get_mix <- function(start = NULL, end = NULL) {
  url <- 'https://api.carbonintensity.org.uk/generation/'

  if (!is.null(start) && !is.null(end)) {
    from_date <- paste0(as.Date(start), 'T00:00Z/')
    to_date <- paste0(as.Date(end), 'T23:59Z')

    call <- paste0(url, from_date, to_date)
  } else {
    call <- url
  }

  data <- get_data(call)

  if (!is.null(start) && !is.null(end)) {
    result <- data %>%
      tidyr::unnest(!!rlang::sym('generationmix')) %>%
      dplyr::mutate(
        from = lubridate::ymd_hm(!!rlang::sym('from')),
        to = lubridate::ymd_hm(!!rlang::sym('to'))
      )
  } else {
    result <- data$generationmix %>%
      dplyr::mutate(from = lubridate::ymd_hm(data$from),
                    to = lubridate::ymd_hm(data$to))
  }

  result

}

