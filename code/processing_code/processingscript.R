###############################
# processing script
#
#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the processed_data folder

#load needed packages. make sure they are installed.
library(readxl) #for loading Excel files
library(dplyr) #for data processing
library(here) #to set paths

#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","raw_data","united_states_covid19_cases_deaths_and_testing_by_state.csv")


#My question was pretty specific.
#I'm interested in comparing COVID death rates between states who expanded medicaid 
#and those who did not. I'm thinking there might be a higher death rate in states
#that did not expand medicaid.

#First I load in COVID-19 data from the CDC by state
library(readr)
us_covid <- read_csv(data_location)

#take a look at the data
dplyr::glimpse(us_covid)

us_covid

#Now I table the State variable. Looks like we're going to need to do some data managment.
#We don't need all these US territories because they do not apply to our question
table(us_covid$`State/Territory`)

#here I subset the data to exclude all non-states
us_covid <- us_covid[which(us_covid$`State/Territory` != 'American Samoa'
                             &
                            us_covid$`State/Territory` != 'Federated States of Micronesia'
                             &
                            us_covid$`State/Territory` != 'Guam'
                             &
                            us_covid$`State/Territory` != 'Northern Mariana Islands'
                             &
                            us_covid$`State/Territory` != 'Palau'
                             &
                            us_covid$`State/Territory` != 'Puerto Rico'
                             &
                            us_covid$`State/Territory` != 'Republic of Marshall Islands'
                             &
                            us_covid$`State/Territory` != 'United States of America'
                             &
                            us_covid$`State/Territory` != 'Virgin Islands'
                            &
                             us_covid$`State/Territory` != "New York (Level of Community Transmission)*"
                           &
                             us_covid$`State/Territory` != "New York City"
                           ), ]
                             

                    
#Now we need another variable that tells us which states expanded medicaid. I found an article here that
#provides a map/list. Below, I create a new variable called 'medicaid' that tells us if the state expanded or did not
#https://www.kff.org/medicaid/issue-brief/status-of-state-medicaid-expansion-decisions-interactive-map/

us_covid$medicaid <- "States that Expanded Medicaid"
us_covid$medicaid[us_covid$`State/Territory`== 'Georgia'] <- "States that did not Expand Medicaid"
us_covid$medicaid[us_covid$`State/Territory`== 'Tennessee'] <- "States that did not Expand Medicaid"
us_covid$medicaid[us_covid$`State/Territory`== 'Florida'] <- "States that did not Expand Medicaid"
us_covid$medicaid[us_covid$`State/Territory`== 'North Carolina'] <- "States that did not Expand Medicaid"
us_covid$medicaid[us_covid$`State/Territory`== 'South Carolina'] <- "States that did not Expand Medicaid"
us_covid$medicaid[us_covid$`State/Territory`== 'Alabama'] <- "States that did not Expand Medicaid"
us_covid$medicaid[us_covid$`State/Territory`== 'Mississipp'] <- "States that did not Expand Medicaid"
us_covid$medicaid[us_covid$`State/Territory`== 'Texas'] <- "States that did not Expand Medicaid"
us_covid$medicaid[us_covid$`State/Territory`== 'Kansas'] <- "States that did not Expand Medicaid"
us_covid$medicaid[us_covid$`State/Territory`== 'South Dakota'] <- "States that did not Expand Medicaid"
us_covid$medicaid[us_covid$`State/Territory`== 'Wyoming'] <- "States that did not Expand Medicaid"
us_covid$medicaid[us_covid$`State/Territory`== 'Wisconsin'] <- "States that did not Expand Medicaid"



#Now I create 4 new variables that are all numeric versions of total cases, total deaths
#total cases in last 7 days and total deaths in last 7 days. These will be used to make comparisons

#This is a numeric version of total cases
us_covid$cases <- as.numeric(us_covid$`Total Cases`)

#This is a numeric version of total deaths
us_covid$deaths <- as.numeric(us_covid$`Total Deaths`)

#This is a numeric version of cases in the last 7 days
us_covid$cases_7_days <- as.numeric(us_covid$`Cases in Last 7 Days`)

#This is a numeric version of deaths in the last 7 days
us_covid$deaths_7_days <- as.numeric(us_covid$`Deaths in Last 7 Days`)

processeddata <- us_covid

# location to save file
save_data_location <- here::here("data","processed_data","processeddata.rds")

# save data as RDS
saveRDS(processeddata, file = save_data_location)






