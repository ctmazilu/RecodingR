CSVS Recoding Report
================

- [Introduction](#introduction)
- [Dealing with multiple countries](#dealing-with-multiple-countries)
- [Dealing with continent responses](#dealing-with-continent-responses)
- [Dealing with countries which no longer
  exist](#dealing-with-countries-which-no-longer-exist)
- [Packages](#packages)
- [Main Code](#main-code)

## Introduction

This project aims to recode variables in the Cultural and Social Values
survey (to be published on [Non-relihion in a Complex Future](https://nonreligionproject.ca/). The variables which have been recoded are Q13r2oe, Q16 and Q16a.
These variables are each open-ended questions with a select country as a
response. For example, *“In what country were you born?”.*

## Dealing with multiple countries

33 respondents entered two countries for the question *From which
country or countries did your parent(s) immigrate?*

We recommend that in future surveys the question is asked in two parts
*From which country or countries did your parent(1) immigrate?* to
accommodate for multiple answers.

We have decided to handle these responses by grouping these 33 resonses
into a new category names **Multiple Countries**

## Dealing with continent responses

Similarly, 6 responses were Africa, 4 Europe, 1 Carribean Island, 1
Central America, 2 Middle East. These responses are two general to be
coded as countries and means that they can either be coded under Other,
or Multiple Countries.

## Dealing with countries which no longer exist

Some respondents have entered countries which no longer exist. As the
package Open Street Map uses up-to-date geographical locations to
attribute the correct character and integer code, this means that
responses like “Yugoslavia”, “USSR”, and “Czechoslovakia”

We have handled these by attributing the responses to the most populated
present day countries which were previously a part of them. For example,
USSR has been recoded as RU, Russia and Czechoslovakia as CZ, Czech
Republic.

## Packages

This program uses packages from [Open Street
Map](https://www.openstreetmap.org/#map=3/38.22/20.48)

``` recode_dataframe
# Load the necessary libraries
library("remotes")
#### tmap 3.x is retiring. ####
install_github("r-tmap/tmap@v4")
library("tmap")
library("tmaptools")
```

## Main Code

``` main_recode
CSVS$Q13X <- replicate(nrow(CSVS), 0)

file_path_cf <-"country_list3.csv"
country_ref <- read.csv(file_path_cf)

file_path_cf <-"all_country_dfQ13r2oe.csv"
all_country_ref <- read.csv(file_path_cf)

for (i in 1:nrow(CSVS)) {
  response <- (CSVS$Q13r2oe[i])
  rn <- (which(response == all_country_ref$Count.Var1, arr.ind = TRUE))
  country_no <- all_country_ref$Code[rn]
  if (length(rn) > 0) {
    CSVS[i, "Q13X"] <- country_no[1]
  }
}

result <- table(CSVS$Q13X)
print(result)
```
