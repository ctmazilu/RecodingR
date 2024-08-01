# Recode for CSVS
# Written by CM and MM
# Date created: 14/07/2024
# Last edited: 18/07/2024

# Load the Cultural and Social Values Survey
# load("CSVS_2024_04_06.RData")
## Backup
# file.copy("CSVS_2024_04_06.RData", "CSVS_2024_01_08.RData")
### recoded data ###
load("CSVS_2024_01_08.RData")
save(list = ls(), file = "CSVS_2024_01_08.RData", compress = "gzip")

original_size <- file.info("CSVS_2024_04_06.RData")$size
save(list = ls(), file = "CSVS_2024_01_08.RData", compress = "gzip")
new_size <- file.info("CSVS_2024_01_08.RData")$size

print(paste("Original Size:", original_size))
print(paste("New Size:", new_size))


# this creates the new variable and fills it with Zeros to start
CSVS$Q16X <- replicate(nrow(CSVS), 0) 
# check to make sure that worked
table(CSVS$Q16X)

# Define the path to the CSV file
# These csv files are from the recode_dataframe.R, created using Open Street Map and manual changes
#file_path_cf <-"country_list3.csv"
#country_ref <- read.csv(file_path_cf)
# Change corresponding question
file_path_cf <-"all_country_dfQ16.csv"
all_country_ref <- read.csv(file_path_cf)

# i is the row number for the CSVS
for (i in 1:nrow(CSVS)) {
  response <- (CSVS$Q16[i])
  # rn is the row number for the all_country_ref, 
  # Compare to Count.Var1 because this data has not been cleaned and is the original
  rn <- (which(response == all_country_ref$Count.Var1, arr.ind = TRUE))
  country_no <- all_country_ref$Code[rn]
  # deals with NA responses 
  if (length(rn) > 0) {
    # attributes the integer code to the case number
    CSVS[i, "Q16X"] <- country_no[1]
  }
}

# check to make sure that worked
table(CSVS$Q16X)

responses <- CSVS$Q16X

if (exists("responses")) {
  # Save the updated dataframe back into the RData file
  save(CSVS, responses, file = "CSVS_2024_01_08.RData", compress = "gzip")
  recoded_size <- file.info("CSVS_2024_01_08.RData")$size
  print(paste("Original Size:", original_size))
  print(paste("New Size:", new_size))
  print(paste("Recoded Size:", recoded_size))
  # Verify the recoding
  load("CSVS_2024_01_08.RData")
  # check that the new variables exist
  head(CSVS)
  # print(responses)
  cat("RECODING SUCCESSFUL. \n ")
} else {
  cat("RECODING UNSUCCESSFUL. \n")
}




