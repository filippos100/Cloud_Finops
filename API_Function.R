# Load required libraries
library(httr)
library(jsonlite)
library(tidyverse)

# Function to retrieve and unnest data from a specific URL
retrieve_and_unnest_data <- function(url) {
  # Function to retrieve data from a specific URL and unnest "Items"
  retrieve_data <- function(url) {
    response <- GET(url)
    if (status_code(response) == 200) {
      data <- content(response, as = "text") %>%
        fromJSON(simplifyVector = FALSE)
      # Unnest "Items"
      unnested_data <- data$Items %>%
        map_df(as.data.frame)
      return(list(unnested_data, data$NextPageLink))
    } else {
      cat("Failed to retrieve data. Status code:", status_code(response), "\n")
      return(NULL)
    }
  }
  
  # Retrieve and unnest initial page of data
  initial_data <- retrieve_data(url)
  if (is.null(initial_data)) {
    stop("Failed to retrieve initial data. Exiting.")
  }
  
  # Extract next page link
  next_page_link <- initial_data[[2]]
  
  # Initialize list to store all data
  all_data <- list(initial_data[[1]])
  
  # Fetch subsequent pages if available
  while (!is.null(next_page_link)) {
    next_page_data <- retrieve_data(next_page_link)
    if (!is.null(next_page_data)) {
      # Append data from next page to the list
      all_data <- c(all_data, list(next_page_data[[1]]))
      next_page_link <- next_page_data[[2]]
    } else {
      break
    }
  }
  
  return(all_data)
}


