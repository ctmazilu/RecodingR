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

# i is the row number for the CSVS
for (i in 1:nrow(CSVS)) {
  response <- (CSVS$Q13r2oe[i])
  # rn is the row number for the all country ref
  rn <- (which(response == all_country_ref$Count.Var1, arr.ind = TRUE))
  country_no <- all_country_ref$Code[rn]
  # deals with NA responses 
  if (length(rn) > 0) {
    # attributes the country code to the case number
    CSVS[i, "Q13X"] <- country_no[1]
  }
}

# check to make sure that worked
table(CSVS$Q13X)

