setwd("/home/rubix/Desktop/Project-RUBIX/data")
# This script will convert CSV flat files containing
# PO data into a nested JSON format and then input it into mongoDB
library(mongolite)
#library(dplyr)
library(stringr)
# Read in the PO header data
reqData <- read.csv("reqTable_V2.csv", na.strings = c(""," "))

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
  reqValues <- paste0('{"$set":{"Business_Unit":"',
                  clean(reqData[i,]$Business_Unit),
                  '","Status":"',
                  clean(reqData[i,]$REQ_STATUS),
                  '","REQ_Date":"',
                  clean(reqData[i,]$Req.Date),
                  '","Buyer":"',
                  clean(reqData[i,]$Buyer),
                  '","Currency":"',
                  clean(reqData[i,]$Currency),
                  '","Fund":"',
                  clean(reqData[i,]$Fund),
                  '","Account":"',
                  clean(reqData[i,]$Account),
                  '","Origin":"',
                  clean(reqData[i,]$Origin),
                  '","Approved_On":"',
                  clean(reqData[i,]$Approval_Date),
                  '","Approved_By":"',
                  clean(reqData[i,]$By),
                  '","Department":{"Number":"',
                  clean(reqData[i,]$Dept.Loc),
                  '","Description":"',
                  clean(reqData[i,]$Descr.1),
                  '"},"Requester":"',
                  clean(reqData[i,]$Requester),
                  '","Ship_To":{"Description":"',
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
  
  # Add the necessary PO line fields to the database record for the appropriate PO.
  lineValues <- paste0('{"$addToSet":{"lines":',
                       '{"Line_No":"',
                       clean(reqData[i,]$Req_Line),
                       '","Unit_Price":"',
                       clean(reqData[i,]$Price),
                       '","Line_Total":"',
                       clean(reqData[i,]$Amount),
                       '","Schedule_No":"',
                       clean(reqData[i,]$Sched.Num),
                       '","UOM":"',
                       clean(reqData[i,]$UOM),
                       '","Due_Date":"',
                       clean(reqData[i,]$Due),
                       '","MFG_ID":"',
                       clean(reqData[i,]$Mfg.ID),
                      '","Quantity":"',
                      clean(reqData[i,]$Req.Qty),
                      '","More_Info":"',
                      clean(reqData[i,]$More.Info),
                      '","Item":"',
                      clean(reqData[i,]$Item),
                      '","Product":"',
                      clean(reqData[i,]$Product),
                       '","PO":{"PO_Number":"',
                       clean(reqData[i,]$PO.No.),
                       '","Line_No":"',
                       clean(reqData[i,]$Line),
                       '"}}',
                       '}}')
  dbConnection$update(key,lineValues,upsert = TRUE)
  setTxtProgressBar(pb, i)
  lineValues <- ""
  poValues <- ""
}
 close(pb)
