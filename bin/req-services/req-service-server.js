var app = require('../../express');
var poModel = require("../../database/PO/po-model");

app.get('/api/po', findPO);
function findPO(req,res){
    console.log('wow we made it');
    poModel
        .findPO("9000005424")
        .then(function(val){
            console.log(val);
            res.json(val);
        })
}