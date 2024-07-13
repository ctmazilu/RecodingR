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

# Load the necessary libraries
library("tmap")
library("tmaptools")
# Define the path to the Excel file
file_path_cf <- "/Users/christina/NCF_CSVS/country_list.xlsx"
# Read the Excel file into a data frame
country_ref <- read_excel(file_path_cf)

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


# Initialize the data frame which has a new row for the character code
# country_ref <- data.frame(
#   Country = country,
#   IntegerCode = i_code,
#   CharacterCode = c_code
# )


# Using the Open Street Map packages, run a loop through each counrty in country_ref
for (i in 1:4+0*nrow(country_ref)) {
  cr <- country_ref$Country[i]
  # find the location of the response
  gloc <- tmaptools::geocode_OSM(cr, as.sf = TRUE)
  # compare location of the response
  rloc <- tmaptools::rev_geocode_OSM(gloc)
  # turn the response to upper case
  c_code <- (toupper(rloc[[1]]$country_code))
  print (c(cr, c_code))
  country_ref$CharacterCode <- c_code[i]
}

# check to make sure that worked

table(CSVS$Q13X)
