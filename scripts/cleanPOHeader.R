setwd("C:/Users/noldakowski/WebStormProjects/Rubix/data")
# This script will convert CSV flat files containing
# PO data into a nested JSON format and then input it into mongoDB
library(mongolite)
 library(dplyr)
library(stringr)
# Read in the PO header data
poData <- read.csv2("poData.csv", na.strings = c(""," "))
poData<- lapply(poData, function(x){
    gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "",x, perl=TRUE)
    str_replace_all(x, "[[:punct:]]^.", "_")
      })

# poData <- gsub("[^[:print:]]", "_", poData)
# Remove the columns that have only one value
#uniqueLength <- sapply(poData,function(x) length(unique(x)))
#poData <- subset(poData, select=uniqueLength>1)
#print(poData)
# poData$lines <- list("")

# Connect to the mongo database, collection PO_HDR and insert the data
 dbConnection <- mongo("rubix",collection = "PO_DATA", url="mongodb://127.0.0.1:27017")
 dbConnection$index(add = '{"PO_No": 1}')
# dbConnection$insert(poData)

# Read in the PO line data
# poLines <- read.csv("poLines.csv", na.strings=c("","NA"))

# Remove the columns that have only one value
# uniqueLength <- sapply(poLines,function(x) length(unique(x)))
# poLines <- subset(poLines, select=uniqueLength>1)

# Update the records in mongo with the lines
# poData %>% #dbConnection$update(,paste0('{"$set":{"lines":',.data,'}'),upsert = TRUE)
# (function(poLine){
#   key <- paste0('{"PO_No":"',poLine$PO.No.,'"}')
#   print(poLine)
#   value <- paste0('{"$set":{"Business_Unit":"',poLine$Business_Unit,'","Status":"',poLine$Status,'"}')
#   print(value)
#   dbConnection$update(key,value,upsert = TRUE)
#   key <- ""
#   value <- ""
# })
 pb <- txtProgressBar(min = 0, max = nrow(poData), style = 3)
for(i in 1:nrow(poData)){
 # poData %>% (function(poData){
  # In Rubix, the PO number is the key for each record
  key <- paste0('{"PO_No":"',poData[i,]$PO.No.,'"}')
  # Add the necessary PO information to the record.
  poValues <- paste0('{"$set":{"Business_Unit":"',
                  poData[i,]$Business_Unit,
                  '","Status":"',
                  poData[i,]$Status,
                  '","PO_Date":"',
                  poData[i,]$PO.Date,
                  '","Buyer":"',
                  poData[i,]$Buyer,
                  '","Origin":"',
                  poData[i,]$Origin,
                  '","Approved_By":"',
                  poData[i,]$Approved_By,
                  '","Vendor_Name":"',
                  poData[i,]$Vendor_Name,
                  '"}}')
  
  dbConnection$update(key,poValues,upsert = TRUE)
  
  # Add the necessary PO line fields to the database record for the appropriate PO.
  lineValues <- paste('{"$addToSet":{"lines":',
                       '{"Line_No":"',
                       poData[i,]$PO_Line,
                       '","Mfg_Id":"',
                       poData[i,]$Mfg.ID,
                       '","Mfg_Itm_Id":"',
                       poData[i,]$Mfg.Itm.ID,
                       '","Quantity":"',
                       poData[i,]$PO.Qty,
                       '","Itm_No":"',
                       poData[i,]$Item,
                       '","Amount":"',
                       poData[i,]$Sum.Amount,
                       '","Taxo_Lvl_1":"',
                       poData[i,]$Level.1,
                       '","Taxo_Lvl_2":"',
                       poData[i,]$Level.2,
                       '","Quote_Link":"',
                       poData[i,]$QuoteLink,
                       '","Description":"',
                       poData[i,]$Descr,
                       '","Requisition":{"Req_ID":"',
                       poData[i,]$Req.ID,
                       '","Line_No":"',
                       poData[i,]$REQ_Line,
                       '"}}',
                       '}}')
  #gsub("\\s+", " ",lineValues)
  dbConnection$update(key,lineValues,upsert = TRUE)
  setTxtProgressBar(pb, i)
  print(lineValues)
  lineValues <- ""
  poValues <- ""
}
 close(pb)
# sapply(nrow(poLines), function(x){
#   print(x)
#   poLines[x,]
# })
# for(line in 1:nrow(poLines)){
#   print(line)
#   poNumQuery <- paste0('{"PO_No_":"',poLines[line,]$PO.No.,'"}')
#   print(poNumQuery)
#   setQuery <- paste0('{"$set":{"lines":{',as.list(poLines),'}}')
#   print(setQuery)
#   # dbConnection$update(poNumQuery,,FALSE,TRUE)
# }
 # ,'","Status":"',poData[i,]$Status,
