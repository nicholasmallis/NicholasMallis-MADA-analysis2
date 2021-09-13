###############################
# analysis script
#
#this script loads the processed, cleaned data, does a simple analysis
#and saves the results to the results folder

#load needed packages. make sure they are installed.
library(ggplot2) #for plotting
library(broom) #for cleaning up output from lm()
library(here) #for data loading/saving

#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","processed_data","processeddata.rds")

#load data. 
mydata <- readRDS(data_location)

######################################
#Data exploration/description
######################################
#I'm using basic R commands here.
#Lots of good packages exist to do more.
#For instance check out the tableone or skimr packages

#summarize data 
mysummary = summary(mydata)

#look at summary
print(mysummary)


#Now I add total cases and total deaths by medicaid expansion status
#and save the results in a table
table <- mydata %>%              
  group_by(medicaid) %>%                        
  summarise_at(vars(cases,deaths),
               list(name = sum))

#using our sums of deaths and cases, we can calculate a death rate for each group
table$rate <- table$deaths_name/table$cases_name * 100


#Now we convert these to a table  
as.data.frame(table)

#Here we plot the results in a bar chart by medicaid expansion status
ggplot(data=table, aes(x=medicaid,y=rate)) + geom_bar(stat='identity') + xlab("States Grouped by Medicaid Expansion Status") +
  ylab("COVID-19 Mortality Rate (%)") + labs(title ="COVID-19 Mortality Rate by Medicaid Expansion Status")




#Since cases have been so high the last week, I thought it would be interesting to look
#at this comparison over the last 7 days 

#First we add total cases in the last 7 days by medicaid expansion status
#and save the results in a table
table2 <- mydata %>%              
  group_by(medicaid) %>%                        
  summarise_at(vars(cases_7_days, deaths_7_days),
               list(name = sum))

#using our sums of deaths and cases, we can calculate a 7 day death rate for each group
table2$rate <- table2$deaths_7_days_name/table2$cases_7_days_name * 100


#Now we convert these to a table  
as.data.frame(table2)

#Here we plot the results in a bar chart by medicaid expansion status
ggplot(data=table2, aes(x=medicaid,y=rate)) + geom_bar(stat='identity') + xlab("States Grouped by Medicaid Expansion Status") +
  ylab("COVID-19 Mortality Rate over Seven days (%)") + labs(title ="COVID-19 Seven Day Mortality Rate by Medicaid Expansion Status")


#do the same, but with a bit of trickery to get things into the 
#shape of a data frame (for easier saving/showing in manuscript)
summary_df = data.frame(do.call(cbind, lapply(mydata, summary)))

#save data frame table to file for later use in manuscript
summarytable_file = here("results", "summarytable.rds")
saveRDS(summary_df, file = summarytable_file)


#make a scatterplot of data
#we also add a linear regression line to it
p1 <- mydata %>% ggplot(aes(x=Height, y=Weight)) + geom_point() + geom_smooth(method='lm')

#look at figure
plot(p1)

#save figure
figure_file = here("results","resultfigure.png")
ggsave(filename = figure_file, plot=p1) 

######################################
#Data fitting/statistical analysis
######################################

# fit linear model
lmfit <- lm(Weight ~ Height, mydata)  

# place results from fit into a data frame with the tidy function
lmtable <- broom::tidy(lmfit)

#look at fit results
print(lmtable)

# save fit results table  
table_file = here("results", "resulttable.rds")
saveRDS(lmtable, file = table_file)

  