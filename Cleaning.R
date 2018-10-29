library("dplyr", lib.loc="~/R/win-library/3.4")
library("ggplot2", lib.loc="~/R/win-library/3.4")
library("DT", lib.loc="~/R/win-library/3.4")
library("googleVis", lib.loc="~/R/win-library/3.4")
library("reshape2", lib.loc="~/R/win-library/3.4")
library("ggthemes", lib.loc="~/R/win-library/3.4")
library("shiny", lib.loc="~/R/win-library/3.4")
library("shinydashboard", lib.loc="~/R/win-library/3.4")
library("plotly", lib.loc="~/R/win-library/3.4")
library("leaflet", lib.loc="~/R/win-library/3.4")
library("wordcloud2", lib.loc="~/R/win-library/3.4")
library("shinythemes", lib.loc="~/R/win-library/3.4")

###SALES###
# load sales files
rawp10w1 <- read.csv('Sales_December_Week1.csv',header = TRUE,sep=';')
rawp10w2 <- read.csv('Sales_December_Week2.csv',header = TRUE,sep=';')
rawp10w3 <- read.csv('Sales_December_Week3.csv',header = TRUE,sep=';')
rawp10w4 <- read.csv('Sales_December_Week4.csv',header = TRUE,sep=';')

# subset sales file
raw_subp10w1 <- rawp10w1[, c(1, 3, 7:10)]
raw_subp10w2 <- rawp10w2[, c(1, 3, 7:10)]
raw_subp10w3 <- rawp10w3[, c(1, 3, 7:10)]
raw_subp10w4 <- rawp10w4[, c(1, 3, 7:10)]

# test data type for each column fpr sales file
classp10w1 <- sapply(raw_subp10w1, class)
classp10w2 <- sapply(raw_subp10w2, class)
classp10w3 <- sapply(raw_subp10w3, class)
classp10w4 <- sapply(raw_subp10w4, class)

# validate if all columns variables match between sales files
class_df <- cbind(classp10w1 != classp10w1, 
                  classp10w2 != classp10w1, 
                  classp10w3 != classp10w1,
                  classp10w4 != classp10w1)

# obtain the number of differences in the comparison of the columns fpr sales files
colSums(class_df)

# change colnames for sales file
colnames(raw_subp10w1) <- c('SAQ Code IPC', 'Outlet code', 'Period', 'Week',
                            'Qty of bottles', 'Amount')

colnames(raw_subp10w2) <- c('SAQ Code IPC', 'Outlet code', 'Period', 'Week',
                            'Qty of bottles', 'Amount')
colnames(raw_subp10w3) <- c('SAQ Code IPC', 'Outlet code', 'Period', 'Week',
                            'Qty of bottles', 'Amount')
colnames(raw_subp10w4) <- c('SAQ Code IPC', 'Outlet code', 'Period', 'Week',
                            'Qty of bottles', 'Amount')

# combine all raw data for sales files
full <- rbind(raw_subp10w1, raw_subp10w2, raw_subp10w3,
              raw_subp10w4)

# change the column Outlet code as character
full[,2] <- as.character(full[,2])

###PRODUCTS###
# load products files
rawproducts <- read.csv('Products.csv',header = TRUE,sep=';')

# subset products file
raw_subproducts <- rawproducts[, c(1:2,5,9,14,19,23)]

# test data type for each column fpr products file
classproducts <- sapply(raw_subproducts, class)

# change colnames for products file
colnames(raw_subproducts) <- c('SAQ Code IPC', 'Description', 'Sales unit', 'Product sales price',
                               'Format', 'Unit of measure','Nature of product')

#merge sales tables with product information
full <- left_join(full,raw_subproducts,by='SAQ Code IPC')


###LOCATIONS###
# load locations files
rawlocations <- read.csv('Locations.csv',header = TRUE,sep=';')

# subset locations file
raw_sublocations <- rawlocations[, c(1:4,7,9:10)]

# change the column Outlet code as character
raw_sublocations[,1] <- as.character(raw_sublocations[,1])

# test data type for each column fpr locations file
classlocations <- sapply(raw_sublocations, class)

# change colnames for sales file
colnames(raw_sublocations) <- c('Outlet code', 'Name of outlet', 'Banner', 'Addresses',
                                'City', 'Name of region','Region code')

#merge sales tables with locations information
full <- left_join(full,raw_sublocations,by='Outlet code')

#remove the warehouses sales
full=full[- grep("C", full$'Outlet code'),]

#keep only the brandy (SB), scotch(SWSB), Cream liqueurs(RSCR) and champagne(VMCH) sales
patterns <- c("^SB$", "^SWSB$", "^RSCR$","^VMCH$")
full <- filter(full,grepl(paste(patterns,collapse='|'),`Nature of product`))

#Clean the Description names
full=data.frame(lapply(full,function(x){gsub('Chemineaud ***** brandy','Chemineaud',x,fixed=TRUE)}))
full=data.frame(lapply(full,function(x){gsub('^Chemineaud.*','Chemineaud',x)}))
full=data.frame(lapply(full,function(x){gsub('^Carolan.*','Carolans',x)}))
full=data.frame(lapply(full,function(x){gsub('^Nicolas Feui.*','Nicolas Feuillatte',x)}))
full=data.frame(lapply(full,function(x){gsub('^St-Leger.*','St-Leger',x)}))

`%notin%` <- Negate(`%in%`)
full_test=full$Description %notin% c('Chemineaud','St-Leger','Carolans','Nicolas Feuillatte')
full$new_col = full_test
full$Description[full$new_col==TRUE] = 'Other'
full$Description=as.character(full$Description)
full$Description[is.na(full$Description)]='Other'


#Clean the Nature of product names
full=data.frame(lapply(full,function(x){gsub('SWSB','Scotch',x,fixed=TRUE)}))
full=data.frame(lapply(full,function(x){gsub('SB','Brandy',x,fixed=TRUE)}))
full=data.frame(lapply(full,function(x){gsub('RSCR','Irish cream liqueur',x,fixed=TRUE)}))
full=data.frame(lapply(full,function(x){gsub('VMCH','Champagne',x,fixed=TRUE)}))


#Determine the number of cases sold
full$Amount=as.numeric(as.character(full$Amount))
full$Qty.of.bottles=as.numeric(as.character(full$Qty.of.bottles))
full$Product.sales.price=as.numeric(as.character(full$Product.sales.price))
full$Format=as.numeric(as.character(full$Format))
full=mutate(full,'Qty of 9L cases sold'=(Qty.of.bottles*Format)/9000)

write.csv(full, file = 'tidy.csv' , row.names = FALSE)
