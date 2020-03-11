library(rvest)
library(dplyr)

url <- "https://carbon-intensity.github.io/api-definitions/?python#region-list"

regions_lookup <- url %>%
  read_html() %>%
  html_nodes('table') %>%
  html_table() %>%
  .[[99]]
