url <- "https://prices.azure.com/api/retail/prices?$filter=serviceFamily%20eq%20%27Compute%27"

Compute <- retrieve_and_unnest_data(url)
