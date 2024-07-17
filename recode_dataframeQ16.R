# Recode for CSVS
# Written by CM and MM
# Date created: 14/07/2024
# Last edited: 17/07/2024

# Install Packages 
if (!requireNamespace("tmap", quietly = TRUE)) {
  install.packages("tmap")
}
if (!requireNamespace("tmaptools", quietly = TRUE)) {
  install.packages("tmaptools")
}
if (!requireNamespace("readxl", quietly = TRUE)) {
  install.packages("readxl")
}
if (!requireNamespace("writexl", quietly = TRUE)) {
  install.packages("writexl")
}

# Load the necessary libraries
library("tmap")
library("tmaptools")
library("readxl")
library("writexl") 

# Define the path to the CSV file
file_path_cf <-"country_list3.csv"
country_ref <- read.csv(file_path_cf)

# Using the Open Street Map packages, run a loop through each country in country_ref
for (i in 1:nrow(country_ref)) {
  # initialize variable cr for the country in country_ref
  cr <- country_ref$Country[i]
  # converts the object into a string. 
  if (toString(country_ref$CharacterCode[i])=="") {
    # find the location of the response
    gloc <- tmaptools::geocode_OSM(cr, as.sf = TRUE)
    # compare location of the response
    rloc <- tmaptools::rev_geocode_OSM(gloc)
    # turn the located 2 letter character code to upper case
    c_code <- (toupper(rloc[[1]]$country_code))
    # turns the located country to uppercase
    tmap_country <- (toupper(rloc[[1]]$country))
    # prints the line, the Country, country letter code, and the 
    # For Example: "Switzerland",170,"CH","SCHWEIZ/SUISSE/SVIZZERA/SVIZRA"
    print (c(cr, c_code, tmap_country))
    country_ref$CharacterCode[i] <- c_code
    country_ref$tmapCountry[i] <- tmap_country
    # write.csv(country_ref, "country_list3.csv", row.names = FALSE )
    # Delays the output by 2 seconds to not overburden the server. 
    Sys.sleep(2)  
  }
}

# count and sort unique countries
count <- table(CSVS$Q16)
all_country <- sort(unique(CSVS$Q16))

# Create a dataframe of all countries
all_country_ref <- data.frame(
  Country = all_county,
  Count = count,
  stringsAsFactors = FALSE
)

# Using the Open Street Map packages, run a loop through each country in country_ref
for (i in 1:nrow(all_country_ref)) {
  cr <- all_country_ref$Country[i]
  # Only runs if the code has not been run already 
  if (all_country_ref$Code[i]=="0") {
    # find the location of the response
    gloc <- tmaptools::geocode_OSM(cr, as.sf = TRUE)
    # If there is no geographical location which is found to correspond with the country 
    # then it is attributed with no value. 
    if(is.null(gloc)) {
      c_code <- "XX"
    } else {
      # compare location of the response
      rloc <- tmaptools::rev_geocode_OSM(gloc)
      # turn the response to upper case
      c_code <- (toupper(rloc[[1]]$country_code))
    }
    all_country_ref$CharacterCode[i] <- c_code
    cc <- (which(c_code == country_ref$CharacterCode, arr.ind = TRUE))
    # deals with NA responses 
    if (length(cc) > 0) {
      # print (c(response, cn, cc))
      # attributes the country code to the case number
      all_country_ref$Code[i] <- cc[1]
    } else {
      # If there is no string country code (i.e. XX) which is found to correspond 
      # with the country, then it is attributed -1. 
      all_country_ref$Code[i] <- -1
    }
    print (c(i, cr, cc, c_code))
    # creates a csv file with the found codes. 
    # commented out so that it does not override the edited sheet
    # errors need to be recoded manually
    # write.csv(all_country_ref, "all_country_df3.csv", row.names = FALSE )
    # Delays the output by 2 seconds to not overburden the server 
    Sys.sleep(2)  
  }
}


CSVS$Q13X <- replicate(nrow(CSVS), 0) # this creates the new variable and fills it with Zeros to start
