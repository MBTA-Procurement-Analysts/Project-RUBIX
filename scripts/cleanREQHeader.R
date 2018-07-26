setwd("C:/Users/noldakowski/WebStormProjects/Rubix/data")
# This script will convert CSV flat files containing
# PO data into a nested JSON format and then input it into mongoDB
library(mongolite)
 library(dplyr)
library(stringr)
# Read in the PO header data
poData <- read.csv("poData.csv", na.strings = c(""," "))

# Connect to the mongo database, collection PO_HDR and insert the data
 dbConnection <- mongo("rubix",collection = "PO_DATA", url="mongodb://127.0.0.1:27017")
 dbConnection$index(add = '{"PO_No": 1}')

# Update the records in mongo
 pb <- txtProgressBar(min = 0, max = nrow(poData), style = 3)
 clean <- function(string){
   string <- gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "",string, perl=TRUE)
   string <- gsub("\"", "inch",string, perl=TRUE)
   string <- gsub("\\\\", "_",string, perl=TRUE)
   
   str_replace_all(string, "[[:punct:]]^.", "_")
 }
for(i in 1:nrow(poData)){
  # In Rubix, the PO number is the key for each record
  key <- paste0('{"PO_No":"',poData[i,]$PO.No.,'"}')
  # Add the necessary PO information to the record.
  poValues <- paste0('{"$set":{"Business_Unit":"',
                  clean(poData[i,]$Business_Unit),
                  '","Status":"',
                  clean(poData[i,]$Status),
                  '","PO_Date":"',
                  clean(poData[i,]$PO.Date),
                  '","Buyer":"',
                  clean(poData[i,]$Buyer),
                  '","Origin":"',
                  clean(poData[i,]$Origin),
                  '","Approved_By":"',
                  clean(poData[i,]$Approved_By),
                  '","Vendor_Name":"',
                  clean(poData[i,]$Vendor_Name),
                  '"}}')
  
  dbConnection$update(key,poValues,upsert = TRUE)
  
  # Add the necessary PO line fields to the database record for the appropriate PO.
  lineValues <- paste('{"$addToSet":{"lines":',
                       '{"Line_No":"',
                       clean(poData[i,]$PO_Line),
                       '","Mfg_Id":"',
                       clean(poData[i,]$Mfg.ID),
                       '","Mfg_Itm_Id":"',
                       clean(poData[i,]$Mfg.Itm.ID),
                       '","Quantity":"',
                       poData[i,]$PO.Qty,
                       '","Itm_No":"',
                       clean(poData[i,]$Item),
                       '","Amount":"',
                       poData[i,]$Sum.Amount,
                       '","Taxo_Lvl_1":"',
                       clean(poData[i,]$Level.1),
                       '","Taxo_Lvl_2":"',
                       clean(poData[i,]$Level.2),
                       '","Quote_Link":"',
                       clean(poData[i,]$QuoteLink),
                       '","Description":"',
                       clean(poData[i,]$Descr),
                       '","Requisition":{"Req_ID":"',
                       clean(poData[i,]$Req.ID),
                       '","Line_No":"',
                       clean(poData[i,]$REQ_Line),
                       '"}}',
                       '}}')
  dbConnection$update(key,lineValues,upsert = TRUE)
  setTxtProgressBar(pb, i)
  lineValues <- ""
  poValues <- ""
}
 close(pb)
