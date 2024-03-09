url <- "https://prices.azure.com/api/retail/prices?$filter=serviceFamily%20eq%20%27Databases%27"

Databases <- retrieve_and_unnest_data(url)

Databases <- bind_rows(Databases)

