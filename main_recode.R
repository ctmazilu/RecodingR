# Recode for CSVS
# Written by CM and MM
# Date created: 14/07/2024
# Last edited: 14/07/2024
CSVS$Q13X <- replicate(nrow(CSVS), 0) # this creates the new variable and fills it with Zeros to start

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
# These files are from the recode_dataframe.R, created using Open Street Map and manual changes
file_path_cf <-"country_list3.csv"
country_ref <- read.csv(file_path_cf)
file_path_cf <-"all_country_df3.csv"
all_country_ref <- read.csv(file_path_cf)

# runs a loop of each case number in the CSVS Rdata
for (cn in 1:20+0*nrow(CSVS)) {
  # attributes the response of the CSVS Rdata and then turns it into uppercase
  response <- (toupper(CSVS$Q13r2oe[cn]))
  # retrieves the country code from the country_list.xlsx 
  cc <- (which(response == country_ref$Country, arr.ind = TRUE))
  # deals with NA responses 
  if (length(cc) > 0) {
    # print (c(response, cn, cc))
    # attributes the country code to the case number
    CSVS[cn, "Q13X"] <- cc[1]
    
  }
  else {
    # for-loop over rows
    gloc <- tmaptools::geocode_OSM(response, as.sf = TRUE)
    rloc <- tmaptools::rev_geocode_OSM(gloc)
    coded_response <- (toupper(rloc[[1]]$country))
    cc <- (which(coded_response == country_ref$Country, arr.ind = TRUE))
    if (length(cc) > 0) {
      print (c(response, coded_response, cn, cc))
      # attributes the country code to the case number
      CSVS[cn, "Q13X"] <- cc[1]
      
    }
  }
}

# check to make sure that worked

table(CSVS$Q13X)

