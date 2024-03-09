url <- "https://prices.azure.com/api/retail/prices?$filter=serviceFamily%20eq%20%27Storage%27"

Storage <- retrieve_and_unnest_data(url)

Storage <- bind_rows(Storage)

