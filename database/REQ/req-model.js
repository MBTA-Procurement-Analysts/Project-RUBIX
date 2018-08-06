var mongoose = require("mongoose");
var reqSchema = require("./req-schema");
var reqModel = mongoose.model('REQModel',reqSchema);
reqModel.findReq = findReq;

module.exports = reqModel;

function findReq(reqNumber){
    console.log("NO: " + reqNumber);
    return reqModel.find({"REQ_No": reqNumber});
}