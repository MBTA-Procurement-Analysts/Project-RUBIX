setwd("/home/rubix/Desktop/Project-RUBIX/data")
# This script will convert CSV flat files containing
# PO data into a nested JSON format and then input it into mongoDB
library(mongolite)
#library(dplyr)
library(stringr)
# Read in the PO header data
data <- read.csv("itemData2.csv", na.strings = c(""," "))

# Connect to the mongo database, collection PO_HDR and insert the data
 dbConnection <- mongo("rubix",collection = "ITEM_DATA", url="mongodb://127.0.0.1:27017")
 dbConnection$index(add = '{"Item_No": 1}')

# Update the records in mongo
 pb <- txtProgressBar(min = 0, max = nrow(data), style = 3)
 clean <- function(string){
   string <- gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "",string, perl=TRUE)
   string <- gsub("\"", "inch",string, perl=TRUE)
   string <- gsub("\\\\", "_",string, perl=TRUE)
   
   str_replace_all(string, "[[:punct:]]^.", "_")
 }
for(i in 1:nrow(data)){
  # In Rubix, the PO number is the key for each record
  key <- paste0('{"Item_No":"',data[i,]$Item,'"}')
  # Add the necessary PO information to the record.
  values <- paste0('{"$set":{"Status":"',
                  clean(data[i,]$Status.Current),
                  '","Item_Group":{"Group_Number":"',
                  clean(data[i,]$Item.Group),
                  '","Group_Description":"',
                  clean(data[i,]$Descr),
                  '"}',
                  ',"Item_Description":"',
                  clean(data[i,]$Descr.1),
                  '","UOM":"',
                  clean(data[i,]$Std.UOM),
                  '"}}')
  
  dbConnection$update(key,values,upsert = TRUE)
  
  setTxtProgressBar(pb, i)
  lineValues <- ""
  poValues <- ""
}
 close(pb)
