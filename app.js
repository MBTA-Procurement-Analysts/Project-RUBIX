var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var mongoose = require("mongoose");

/**
 * Connect to the Mongo Database
 */
var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
mongoose.connect('mongodb://localhost/rubix');
mongoose.Promise = require('q').Promise;
require("./bin/po-services/po-service-server.js");
require("./bin/req-services/req-service-server.js");

module.exports = app;
