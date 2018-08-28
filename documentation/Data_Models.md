# Project RUBIX

## Data Model Documentation

### About:

Project RUBIX is designed to be a source of data that can be easily pulled and manipulated. It is built on Node.js, Angular, MongoDB, and some R and Python scripts to insert FMIS data into Mongo.

MongoDB is a non-SQL database that is almost analagous to mySQL in terms of the ideas (you have records that are stored in ‘tables’), but the data model is much softer- MongoDB is schema-less, and relies on the programmer to ensure that the data that is being put into the database is what they want to be in there. The documents that make up MongoDB collections (i.e. tables) are in BSON format, which for all outward-facing intents and purposes, is just JSON encoded differently in the backend to make it faster for MongoDB to work with.

Because of its schema-less nature, much of the data model is enforced through the web server.

### Project RUBIX Data Model:

Overview of Collections

  ----------------- ------------------------------------------------
  Collection Name   Description
  PO\_DATA          Contains data associated with Purchase Orders.
  REQ\_DATA         Contains data associated with Requisitions.
  ITEM\_DATA        Contains data associated with Item
  ----------------- ------------------------------------------------
