# preliminaries                                                                                 # ####
rm(list=ls()); gc();graphics.off()
library(data.table)
library(stringr)
PATH  <- 'D:/Brandeis/data competition/data'
setwd(PATH)
e0 <- list()

# load data                                                                                      # ####
listings_details <- fread("listings_details.csv")

#head(listings_details)
str(listings_details)
colname <- colnames(listings_details)
length(colname)

e0$listings_details <- listings_details
# drop variables                                                                                # ####
# drop columns with no variation                                                                 
col_variation <- sapply(listings_details, function(x)return(length(unique(x))))
col_variation[col_variation == 1]
listings_details[, experiences_offered          := NULL]
listings_details[, thumbnail_url                := NULL]
listings_details[, medium_url                   := NULL]
listings_details[, xl_picture_url               := NULL]
listings_details[, host_acceptance_rate         := NULL]
listings_details[, neighbourhood_group_cleansed := NULL]
listings_details[, country_code                 := NULL]
listings_details[, country                      := NULL]
listings_details[, has_availability             := NULL]
listings_details[, is_business_travel_ready     := NULL]

# drop url
listings_details[, listing_url        := NULL]
listings_details[, picture_url        := NULL]
listings_details[, host_url           := NULL]
listings_details[, host_thumbnail_url := NULL]
listings_details[, host_picture_url   := NULL]

# drop text
listings_details[, name                  := NULL]
listings_details[, summary               := NULL]
listings_details[, space                 := NULL]
listings_details[, description           := NULL]
listings_details[, neighborhood_overview := NULL]
listings_details[, notes                 := NULL]
listings_details[, transit               := NULL]
listings_details[, access                := NULL]
listings_details[, interaction           := NULL]
listings_details[, house_rules           := NULL]
listings_details[, host_name             := NULL]
listings_details[, host_about            := NULL]
listings_details[, host_verifications    := NULL]
listings_details[, amenities             := NULL]

# drop meaningless value for me
listings_details[, host_location         := NULL]
listings_details[, host_neighbourhood    := NULL]
listings_details[, street                := NULL]
listings_details[, neighbourhood_cleansed:= NULL]
listings_details[, state                 := NULL]
listings_details[, smart_location        := NULL]
listings_details[, license               := NULL]
listings_details[, jurisdiction_names    := NULL]
listings_details[, zipcode               := NULL]
e0$listings_details <- listings_details


#drop same column
setdiff(listings_details$host_listings_count, listings_details$host_listings_count)
listings_details[, host_total_listings_count := NULL]
listings_details[, square_feet := NULL]
str(listings_details)
# clean data                                                                                    # ####
# id
listings_details$id <- as.numeric(listings_details$id)

# date
listings_details$last_scraped <- as.Date(listings_details$last_scraped, "%m/%d/%y")
listings_details$host_since <- as.Date(listings_details$host_since, "%m/%d/%y")
listings_details$calendar_last_scraped <- as.Date(listings_details$calendar_last_scraped, "%m/%d/%y")
listings_details$first_review <- as.Date(listings_details$first_review, "%m/%d/%y")
listings_details$last_review <- as.Date(listings_details$last_review, "%m/%d/%y")

# "t"&"f" >> 1 & 0 
vec_tf <- c("host_is_superhost", "host_has_profile_pic", "host_identity_verified","is_location_exact","requires_license","instant_bookable","require_guest_profile_picture","require_guest_phone_verification")
for (i in 1:length(vec_tf)){
  vec_1 <- listings_details[[vec_tf[i]]]
  vec_1[vec_1 == "t"] <- 1
  vec_1[vec_1 == "f"] <- 0
  vec_1[vec_1 == ""]  <- NA
  listings_details[[vec_tf[i]]] <- as.numeric(vec_1)
}

# $price
vec_price <- c("price", "weekly_price","monthly_price","security_deposit","cleaning_fee","extra_people")
for (i in 1:length(vec_price)){
  vec_3 <- listings_details[[vec_price[i]]]
  vec_3 <- str_replace_all(vec_3, fixed("$"), "")
  vec_3 <- str_replace_all(vec_3, fixed(".00"), "")
  vec_3 <- str_replace_all(vec_3, fixed(","), "")
  vec_3[vec_3 == ""]  <- NA
  listings_details[[vec_price[i]]] <- as.numeric(vec_3)
}

e0$listings_details <- listings_details

str(listings_details)
write.csv(listings_details, file = "listings_details_clean.csv")
length(unique(listings_details$id[listings_details$beds == 0]))
length(unique(listings_details$id[listings_details$bedrooms == 0]))
length(unique(listings_details$id[listings_details$bathrooms == 0]))
