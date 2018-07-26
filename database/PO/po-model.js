var mongoose = require("mongoose");
var poSchema = require("./po-schema");
var poModel = mongoose.model('POModel',poSchema);

module.exports = poModel;