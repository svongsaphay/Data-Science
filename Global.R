# setwd("C:\Users\Sounithtra\NYC Data Science Academy\Projects\R Shiny\Final - WJTData app")


# load the data
data <- read.csv("tidy.csv")
city <- c('All',sort(unique(as.character(data$City))))
region <- c('All',sort(unique(as.character(data$Name.of.region))))
select_division <-  c(`City` = city,`Region` = region)
select_tabledivision <-  c(`City` = city,`Region` = region)
