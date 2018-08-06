var mongoose = require("mongoose");
var itemSchema = new mongoose.Schema({
    "Item_No": String,
    "Item_Description": String,
    "Item_Group": {"Group_Number": Number, "Group_Description": String},
    "Status": String,
    "UOM": String},

{
    "collection"
:
    "ITEM_DATA"
}
)
;

module.exports = itemSchema;