# Load required libraries
library(httr)
library(jsonlite)

# Initial API endpoint with filter
initial_url <- "https://prices.azure.com/api/retail/prices?$filter=serviceName%20eq%20%27Virtual%20Machines%27"

# Function to retrieve data from a specific URL
retrieve_data <- function(url) {
  response <- GET(url)
  if (status_code(response) == 200) {
    data <- content(response, as = "text") %>%
      fromJSON(simplifyVector = FALSE)
    return(data)
  } else {
    cat("Failed to retrieve data. Status code:", status_code(response), "\n")
    return(NULL)
  }
}

# Retrieve initial page of data
initial_data <- retrieve_data(initial_url)
if (is.null(initial_data)) {
  stop("Failed to retrieve initial data. Exiting.")
}

# Initialize list to store all data
all_data <- list(initial_data)

# Extract next page link
next_page_link <- initial_data$NextPageLink

# Fetch subsequent pages if available
while (!is.null(next_page_link)) {
  next_page_data <- retrieve_data(next_page_link)
  if (!is.null(next_page_data)) {
    # Append data from next page to the list
    all_data <- c(all_data, list(next_page_data))
    next_page_link <- next_page_data$NextPageLink
  } else {
    break
  }
}

# Combine all pages of data into a single list
all_data <- do.call(rbind, all_data)


