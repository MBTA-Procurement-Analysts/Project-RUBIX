setwd("C:/Users/noldakowski/WebStormProjects/Rubix/data")
# This script will convert CSV flat files containing
# PO data into a nested JSON format and then input it into mongoDB
library(mongolite)
library(dplyr)
library(stringr)
# Read in the PO header data
reqData <- read.csv("reqData.csv", na.strings = c(""," "))

# Connect to the mongo database, collection PO_HDR and insert the data
 dbConnection <- mongo("rubix",collection = "REQ_DATA", url="mongodb://127.0.0.1:27017")
 dbConnection$index(add = '{"Req_No": 1}')

# Update the records in mongo
 pb <- txtProgressBar(min = 0, max = nrow(poData), style = 3)
 clean <- function(string){
   string <- gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "",string, perl=TRUE)
   string <- gsub("\"", "inch",string, perl=TRUE)
   string <- gsub("\\\\", "_",string, perl=TRUE)
   
   str_replace_all(string, "[[:punct:]]^.", "_")
 }
for(i in 1:nrow(reqData)){
  # In Rubix, the Req number is the key for each record
  key <- paste0('{"REQ_No":"',reqData[i,]$Req.No,'"}')
  # Add the necessary PO information to the record.
  reqValues <- paste0('{"$set":{"Business_Unit":"',
                  clean(reqData[i,]$Business_Unit),
                  '","Status":"',
                  clean(reqData[i,]$REQ_Status),
                  '","REQ_Date":"',
                  clean(reqData[i,]$Req.Date),
                  '","Buyer":"',
                  clean(reqData[i,]$Buyer),
                  '","Origin":"',
                  clean(reqData[i,]$Origin),
                  '","Approved_On":"',
                  clean(reqData[i,]$Approval_Date),
                  '","Approved_By":"',
                  clean(reqData[i,]$Approved_By),
                  '","Department":{"',
                  'Number":"',
                  clean(reqData[i,]$Dept_Loc),
                  '","Description":"',
                  clean(reqData[i,]$Description),
                  '"},"Requester":"',
                  clean(reqData[i,]$Requester),
                  '"}}')
  
  dbConnection$update(key,reqValues,upsert = TRUE)
  
  # Add the necessary PO line fields to the database record for the appropriate PO.
  lineValues <- paste('{"$addToSet":{"lines":',
                       '{"Line_No":"',
                       clean(reqData[i,]$Req_Line),
                       '","UOM":"',
                       clean(reqData[i,]$UOM),
                      '","Quantity":"',
                      clean(reqData[i,]$Req.Qty.Item),
                      '","More_Info":"',
                      clean(reqData[i,]$More.Info),
                      '","Product":"',
                      clean(reqData[i,]$Product),
                      '","Fund":"',
                      clean(reqData[i,]$FUND),
                       '","PO":{"PO_Number":"',
                       clean(reqData[i,]$PO.No.),
                       '","Line_No":"',
                       clean(reqData[i,]$PO_Line),
                       '"}}',
                       '}}')
  dbConnection$update(key,lineValues,upsert = TRUE)
  setTxtProgressBar(pb, i)
  lineValues <- ""
  poValues <- ""
}
 close(pb)
