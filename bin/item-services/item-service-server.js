var app = require('../../app');
var itemModel = require("../../database/ITEM/item-model");

app.get('/api/item/:number', findItem);

function findItem(req, res) {
    console.log("ITEM NUMBER: " + req.params.number);
    itemModel
        .findItem(req.params.number)
        .then(function (val) {
            res.json(val);
        })
}