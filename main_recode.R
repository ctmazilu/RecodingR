# Recode for CSVS
# Written by CM and MM
# Date created: 14/07/2024
# Last edited: 18/07/2024
CSVS$Q13X <- replicate(nrow(CSVS), 0) # this creates the new variable and fills it with Zeros to start

# Define the path to the CSV file
# These csv files are from the recode_dataframe.R, created using Open Street Map and manual changes
file_path_cf <-"country_list3.csv"
country_ref <- read.csv(file_path_cf)
# Change corresponding question
file_path_cf <-"all_country_dfQ13r2oe.csv"
all_country_ref <- read.csv(file_path_cf)

# i is the row number for the CSVS
for (i in 1:nrow(CSVS)) {
  response <- (CSVS$Q13r2oe[i])
  # rn is the row number for the all_country_ref, 
  # Compare to Count.Var1 because this data has not been cleaned and is the original
  rn <- (which(response == all_country_ref$Count.Var1, arr.ind = TRUE))
  country_no <- all_country_ref$Code[rn]
  # deals with NA responses 
  if (length(rn) > 0) {
    # attributes the integer code to the case number
    CSVS[i, "Q13X"] <- country_no[1]
  }
}

# check to make sure that worked
table(CSVS$Q13X)

