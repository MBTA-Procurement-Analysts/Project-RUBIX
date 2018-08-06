var mongoose = require("mongoose");
var poSchema = require("./po-schema");
var poModel = mongoose.model('POModel',poSchema);
poModel.findPO = findPO;
module.exports = poModel;

function findPO(poNumber){
    console.log("NO: " + poNumber);
    return poModel.find({"PO_No": poNumber});
}
