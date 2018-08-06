var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var mongoose = require("mongoose");
var mongoClient = require("mongodb").MongoClient;

/**
 * Connect to the Mongo Database
 */
var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({extended: false}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
mongoose.connect('mongodb://localhost/rubix');
mongoose.Promise = require('q').Promise;
//
//var collectionNames = mongoose.connection.collection();
//console.log(collectionNames);
// var names = [];
// Object.keys(collectionNames).forEach(function (k) {
//     console.log(k);
//     names.push(k);
// });
// console.log(names);

module.exports = app;
//module.exports.collections = names;

