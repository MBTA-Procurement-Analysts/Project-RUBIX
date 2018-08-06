var mongoose = require("mongoose");
var reqSchema = new mongoose.Schema(
    {
        "REQ_No" : String,
        "Account" : Number,
        "Approved_By" : String,
        "Approved_On" : Date,
        "Business_Unit" : String,
        "Buyer" : String,
        "Currency" : String,
        "Department" : {
            "Number" : Number,
            "Description" : String
        },
        "Fund" : Number,
        "Origin" : String,
        "REQ_Date" : Date,
        "Requester" : String,
        "Ship_To" : {
            "Description" : String,
            "Address_1" : String,
            "Address_2" : String,
            "City" : String,
            "State" : String,
            "Zip_Code" : String,
            "Country" : String
        },
        "Status" :String,
        "lines" : [
            {
                "Line_No" :Number,
                "Unit_Price" : Number,
                "Line_Total" : Number,
                "Schedule_No" : Number,
                "UOM" : String,
                "Due_Date" : Date,
                "MFG_ID" : String,
                "Quantity" : Number,
                "More_Info" : String,
                "Item" : String,
                "Product" : String,
                "PO" : {
                    "PO_Number" : String,
                    "Line_No" : Number
                }
            }
        ]
    }
,{"collection":"REQ_DATA"});

module.exports = reqSchema;
