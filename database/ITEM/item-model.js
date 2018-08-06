var mongoose = require("mongoose");
var itemSchema = require("./item-schema");
var itemModel = mongoose.model('ITEMModel',itemSchema);
itemModel.findItem = findItem;

module.exports = itemModel;

function findItem(itemNumber){
    console.log("NO: " + itemNumber);
    return itemModel.find({"Item_No": itemNumber});
}