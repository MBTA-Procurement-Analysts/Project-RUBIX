var mongoose = require("mongoose");
var reqSchema = require("./req-schema");
var reqModel = mongoose.model('REQModel',reqSchema);
reqModel.findPO = findPO;

module.exports = reqModel;

function findPO(poNumber){
    console.log("NO: " + poNumber);
    return reqModel.find({"PO_No": poNumber});
}