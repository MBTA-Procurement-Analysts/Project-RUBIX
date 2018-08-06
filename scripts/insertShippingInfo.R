setwd("/home/rubix/Desktop/Project-RUBIX/data")
# This script will convert CSV flat files containing
# PO data into a nested JSON format and then input it into mongoDB
library(mongolite)
#library(dplyr)
library(stringr)
# Read in the PO header data
reqData <- read.csv("shipTo.csv", na.strings = c(""," "),)

# Connect to the mongo database, collection PO_HDR and insert the data
 dbConnection <- mongo("rubix",collection = "REQ_DATA", url="mongodb://127.0.0.1:27017")
 dbConnection$index(add = '{"Req_No": 1}')

# Update the records in mongo
 pb <- txtProgressBar(min = 0, max = nrow(reqData), style = 3)
 clean <- function(string){
   string <- gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "",string, perl=TRUE)
   string <- gsub("\"", "inch",string, perl=TRUE)
   string <- gsub("\\\\", "_",string, perl=TRUE)
   
   str_replace_all(string, "[[:punct:]]^.", "_")
   str_squish(string)
 }
for(i in 1:nrow(reqData)){
  # In Rubix, the Req number is the key for each record
  key <- paste0('{"REQ_No":"',reqData[i,]$Req.ID,'"}')
  # Add the necessary PO information to the record.
  reqValues <- paste0('{"$set":{"Requester":"',
                  clean(reqData[i,]$Requester),
                  '","Ship_To":{"Descr":"',
                  clean(reqData[i,]$Descr),
                  '","Address_1":"',
                  clean(reqData[i,]$Address.1),
                  '","Address_2":"',
                  clean(reqData[i,]$Address.2),
                  '","City":"',
                  clean(reqData[i,]$City),
                  '","State":"',
                  clean(reqData[i,]$St),
                  '","Zip_Code":"',
                  clean(reqData[i,]$Postal),
                  '","Country":"',
                  clean(reqData[i,]$Cntry),
                  '"}}}')
  
  dbConnection$update(key,reqValues,upsert = TRUE)
  
  setTxtProgressBar(pb, i)
  lineValues <- ""
  poValues <- ""
}
 close(pb)
