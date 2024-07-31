# Create the country_list with character codes 
# Written by CM 
# Date created: 18/07/2024
# Last edited: 18/07/2024

# Install Packages 
if (!requireNamespace("readxl", quietly = TRUE)) {
  install.packages("readxl")
}
if (!requireNamespace("tmap", quietly = TRUE)) {
  install.packages("tmap")
}
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
if (!requireNamespace("tmaptools", quietly = TRUE)) {
  install.packages("tmaptools")
}

#### tmap 3.x is retiring. ####
# install_github("r-tmap/tmap@v4")

# Load the necessary libraries
library("remotes")
library("tmap")
library("tmaptools")
# Load the necessary libraries
library("readxl")

# Define the path to the CSV file
file_path_cf <-"country_list.xlsx"
country_ref <- read_excel(file_path_cf)

write.csv(country_ref, "country_list.csv", row.names = FALSE)

country_ref <- data.frame(
  Country = country_ref$Country,
  Code = country_ref$Code,
  CharacterCode = "",
  tmapCountry = "",
  stringsAsFactors = FALSE
)

# Originally the file path was country_list.csv but after a few iterations 
# we fed back the updated version 
file_path_cf <-"country_list3.csv"
country_ref <- read.csv(file_path_cf)

## country_ref is the same for Q13r2oe, Q16, Q16a and only needs ran once
## Using the Open Street Map packages, run a loop through each country in country_ref
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
    write.csv(country_ref, "country_list3.csv", row.names = FALSE )
    # Delays the output by 2 seconds to not overburden the server.
    Sys.sleep(2)
  }
}
