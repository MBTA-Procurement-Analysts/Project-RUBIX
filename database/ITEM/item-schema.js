var mongoose = require("mongoose");
var itemSchema = new mongoose.Schema({
    "Item_No": String,
    "Item_Description": String,
    "Item_Group": {"Group_Number": Number, "Group_Description": String},
    "Status": String,
    "UOM": String,
        "locations": [{"Unit":String, "Area": String,
        "Level 1": String, "Level 2": String, "Level 3": String, "Level 4": String}]

    },

{
    "collection"
:
    "ITEM_DATA"
}
)
;

module.exports = itemSchema;