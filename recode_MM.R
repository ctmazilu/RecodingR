# Recodes for CSVS
# Written by Christina Theodora Mazilu
# Date created: 13/07/2024
# Last edited: 13/07/2024

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
library(writexl) 

# change working directory to script directory 
setwd(getSrcDirectory(function(){})[1])
   
# Define the path to the Excel file
##file_path_cf <-"country_list.xlsx"
##country_ref <- read_excel(file_path_cf)
##country_ref$CharacterCode <- ""
##country_ref$tmapCountry <- ""

file_path_cf <-"country_list3.csv"
country_ref <- read.csv(file_path_cf)

# Using the Open Street Map packages, run a loop through each counrty in country_ref
for (i in 1:nrow(country_ref)) {
  cr <- country_ref$Country[i]
  if (toString(country_ref$CharacterCode[i])=="") {
    # find the location of the response
    gloc <- tmaptools::geocode_OSM(cr, as.sf = TRUE)
    # compare location of the response
    rloc <- tmaptools::rev_geocode_OSM(gloc)
    # turn the response to upper case
    c_code <- (toupper(rloc[[1]]$country_code))
    tmap_country <- (toupper(rloc[[1]]$country))
    print (c(cr, c_code, tmap_country))
    country_ref$CharacterCode[i] <- c_code
    country_ref$tmapCountry[i] <- tmap_country
    write.csv(country_ref, "country_list3.csv", row.names = FALSE )
    Sys.sleep(2)  
  }
}

##################
# Define the path to the CSV file
file_path_cf <-"all_countries_df.csv"

all_country_ref <- read.csv(file_path_cf)
all_country_ref$CharacterCode <- ""
all_country_ref$Code <- 0

# Using the Open Street Map packages, run a loop through each counrty in country_ref
for (i in 1:nrow(all_country_ref)) {
  cr <- all_country_ref$Country[i]
  if (toString(all_country_ref$CharacterCode[i])=="") {
  # find the location of the response
  gloc <- tmaptools::geocode_OSM(cr, as.sf = TRUE)
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
    all_country_ref$Code[i] <- 0
  }
  print (c(i, cr, cc, c_code))
  write.csv(all_country_ref, "all_country_df3.csv", row.names = FALSE )
  Sys.sleep(2)  
  }
}


CSVS$Q13X <- replicate(nrow(CSVS), 0) # this creates the new variable and fills it with Zeros to start

# Initialize variables
# Character Code
c_code <- character()
# Integer Code
i_code <- integer ()
# Country Code
# cc <- integer()
# # Response in CSVS
# response <- integer()
# # Case number
# cn <- integer()
# # Coded Response
# coded_response <- integer()

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
