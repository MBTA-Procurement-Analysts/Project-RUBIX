var app = require('../../app');
var poModel = require("../../database/PO/po-model");

app.get('/api/po/:number', findPO);
app.get('/api/collection-list', getCollections);
function findPO(req,res){
    console.log("PO NUMBER: " + req.params.number);
    console.log('wow we made it');
    poModel
        .findPO(req.params.number)
        .then(function(val){
            console.log(val);
            res.json(val);
        })
}
function getCollections(req,res){
    console.log(app.collections);
    return app.collections;
}