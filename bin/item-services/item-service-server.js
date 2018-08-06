var app = require('../../app');
var itemModel = require("../../database/ITEM/item-model");

app.get('/api/item/:number', findItem);
function findItem(req,res){
    console.log("ITEM NUMBER: " + req.params.number);
    console.log('wow we made it');
    itemModel
        .findItem(req.params.number)
        .then(function(val){
            console.log(val);
            res.json(val);
        })
}