# Recode for CSVS
# Written by CM and MM
# Date created: 14/07/2024
# Last edited: 18/07/2024

# Install Packages 

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

# Define the path to the CSV file
file_path_cf <-"country_list3.csv"
country_ref <- read.csv(file_path_cf)

# Only needs run at the start, otherwise will be overwitten
# Change the Question when appropriate
count <- table(CSVS$Q16)
all_country <- sort(unique(CSVS$Q16))

#  Create a dataframe of all countries
all_country_dfQ16 <- data.frame(
  Country = all_country,
  Count = count,
  CharacterCode = "",
  Code = 0,
  stringsAsFactors = FALSE
)

write.csv(all_country_dfQ16, "all_country_dfQ16.csv", row.names = FALSE )

# From now on call the new file with updated locations
file_path_cf <-"all_country_dfQ16.csv"
all_country_dfQ16 <- read.csv(file_path_cf)

# Clean the data from accented characters 
remove.accents <- function(s) {
  
  # 1 character substitutions
  old_values <- c('Š', 'š', 'Ž', 'ž', 'À', 'Á', 'Â', 'Ã', 'Ä', 'Å', 'Æ', 'Ç', 'È', 'É', 'Ê', 'Ë', 
                  'Ì', 'Í', 'Î', 'Ï', 'Ñ', 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', 'Ø', 'Ù', 'Ú', 'Û', 'Ü', 'Ý', 'Þ', 
                  'ß', 'à', 'á', 'â', 'ã', 'ä', 'å', 'æ', 'ç', 'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï', 
                  'ð', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', 'ø', 'ù', 'ú', 'û', 'ý', 'ý', 'þ', 'ÿ', "ß")
  
  new_values <- c('S', 's', 'Z', 'z', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'C', 'E', 'E', 'E', 'E', 
                  'I', 'I', 'I', 'I', 'N', 'O', 'O', 'O', 'O', 'O', 'O', 'U', 'U', 'U', 'U', 'Y', 'B', 
                  'Ss', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'c', 'e', 'e', 'e', 'e', 'i', 'i', 'i', 'i', 
                  'o', 'n', 'o', 'o', 'o', 'o', 'o', 'o', 'u', 'u', 'u', 'y', 'y', 'b', 'y', "ss")
  
  # finalize the function
  for(i in seq_along(old_values)) s <- gsub(old_values[i], new_values[i], s, fixed = TRUE)
  
  s
}

# Run the script
#all_country_dfQ16$Country = remove.accents(all_country_dfQ16$Country)

# Save the CSV file with the new modifications
#write.csv(all_country_dfQ16, "all_country_dfQ16.csv", row.names = FALSE )

# Using the Open Street Map packages, run a loop through each country in all_country_dfQ16
for (i in 1:nrow(all_country_dfQ16)) {
  acr <- all_country_dfQ16$Country[i]
  # Only runs if the code has not been run already 
  if (all_country_dfQ16$Code[i]=="0") {
    # find the location of the response
    gloc <- tmaptools::geocode_OSM(acr, as.sf = TRUE)
    # If there is no geographical location which is found to correspond with the country 
    # then it is attributed with no value. 
    # Checks if there are numbers within the array
    if(is.null(gloc) | !grepl("[A-Za-z]", acr)) {
      c_code <- "XX"
    } else {
      # compare location of the response
      rloc <- tmaptools::rev_geocode_OSM(gloc)
      # turn the response to upper case
      c_code <- (toupper(rloc[[1]]$country_code))
    }
    all_country_dfQ16$CharacterCode[i] <- c_code
    cc <- (which(c_code == country_ref$CharacterCode, arr.ind = TRUE))
    # deals with NA responses 
    if (length(cc) > 0) {
      print (c(response, cn, cc))
      # attributes the country code to the case number
      all_country_dfQ16$Code[i] <- cc[1]
    } else {
      # If there is no string country code (i.e. XX) which is found to correspond 
      # with the country, then it is attributed -1. 
      all_country_dfQ16$Code[i] <- -1
    }
    print (c(i, acr, cc, c_code))
    # creates a csv file with the found codes. 
    # commented out so that it does not override the edited sheet
    # errors need to be recoded manually
    write.csv(all_country_dfQ16, "all_country_dfQ16.csv", row.names = FALSE )
    # Delays the output by 2 seconds to not overburden the server 
    Sys.sleep(2)  
  } 
}


CSVS$Q16 <- replicate(nrow(CSVS), 0) # this creates the new variable and fills it with Zeros to start
table(CSVS$Q16)

