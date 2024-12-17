CSVS Recoding Report
================

## Index

- [Introduction](#introduction)
- [Data Description](#data-description)
- [Packages](#packages)
- [Method](#method)
- [Results](#results)
- [Discussion](#discussion)
  - [Dealing with numbers](#dealing-with-numbers)
  - [Dealing with multiple countries](#dealing-with-multiple-countries)
  - [Dealing with continent responses](#dealing-with-continent-responses)
  - [Dealing with countries which no longer
    exist](#dealing-with-countries-which-no-longer-exist)
- [Copyright](#copyright)

## Introduction

This project aims to recode variables in the Cultural and Social Values survey (to be published on [Non-religion in a Complex Future](https://nonreligionproject.ca/). The variables which have been recoded are Q13r2oe, Q16 and Q16a. These variables are each open-ended questions with a select country as a response. For example, *“In what country were you born?”.* 

## Data Description 

The survey was fielded in all 8 project countries (Argentina, Australia, Brazil, Canada, Finland, Norway, the US, and the UK). Collection is complete with 8800 responses. Further details on the Cultural and Social Values
survey and what it is used for can be found [here](https://nonreligionproject.ca/cultural-and-social-values-survey/)
> The survey asks about people’s personal, cultural, and social values, including attitudes and behaviours on ethical questions, and orientations towards politics, science, law, education, and life’s meaning. The survey also examines people’s involvement with religion, spirituality, and their identification with nonreligious labels such as atheism, agnosticism, or humanism. We have collected a sample of approximately 1,000 responses in each of the countries.

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

## Method

1. Find Character Code using One Street Map [character_codes.R](character_codes.R) 
This takes the excel sheet that contains a list of countries [(country_list.xlsx)](country_list.xlsx) with their code and uses One Street Map to find their corresponding two digit character code. 

```
# find the location of the response
gloc <- tmaptools::geocode_OSM(cr, as.sf = TRUE)
# compare location of the response
rloc <- tmaptools::rev_geocode_OSM(gloc)
# turn the located 2 letter character code to upper case
c_code <- (toupper(rloc[[1]]$country_code)
```

2. Data Cleaning [recode_dataframe.R](recode_dataframe.R) 
Data preprocessing the open-ended responses to make the recoding run smoothly:
> - removing punctuation
> - special characters
> - all upper case.

3. Recode Variables [main_recode.R](main_recode.R) 
Then the main code assigns the open-ended response the corresponding country code. Due to imperfections, some (minimal) manual corrections are necessary. 

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

## Results
Table 1.
|ID| Country              | Count.Var1         | Count.Freq | CharacterCode | Code |
|--|----------------------|--------------------|------------|---------------|------|
|01| 1943                 | 1943               | 1          | ZZ            | 201  |
|02| afganistan           | afganistan         | 1          | AF            | 1    |
|03| Afganistan og Finland| Afganistan og Finland | 1       | XX            | 200  |
|04| africa               | africa             | 2          | XX            | 200  |
|05| Africa               | africa             | 2          | XX            | 200  |
|06| Afrika               | africa             | 2          | XX            | 200  |
|07| CZECHOSLOVAK SOCIALIST REPUBLIC	|czechoslovak socialist republic	|1	|CZ |45    |


## Discussion

Due to the open-ended nature of the responses, there were complications to categorisation. This should be reflected on further when conducting future surveys. These complications and their solutions are discussed in further detail below.

## Dealing with numbers 

Numbers were automatically categorised as null response (ID:01, Table 1.)

## Dealing with multiple countries

33 respondents entered two countries for the question *From which
country or countries did your parent(s) immigrate?* For example, Afganistan og Finland (ID:03, Table 1.).

We recommend that in future surveys the question is asked in two parts
*From which country or countries did your parent (1)/(2) immigrate?* to
accommodate for multiple answers. 

We have decided to handle these responses by grouping these 33 resonses
into a new category names **Multiple Countries**, CharacterCode:XX, Code:200

## Dealing with 'continent' responses

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
Republic (ID:03, Table 1.).


## Copyright
[RecodingR](https://github.com/ctmazilu/RecodingR.git) © 2024 by [Christina Mazilu](https://github.com/ctmazilu) is licensed under [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-nc-sa/4.0/) 
