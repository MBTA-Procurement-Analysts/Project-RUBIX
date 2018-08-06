(function () {
  angular
    .module('RUBIX')
    .controller('buyerItemsController', buyerItemsController);

  function buyerItemsController(adminService, $routeParams) {//currentUser){
    var model = this;
    this.inputReqid = "";
    this.title = "Buyer Item Viewer";
    this.hideTables = true;
    this.statusDict =
      {
        "A": "Approved",
        "C": "Completed",
        "P": "Pending",
        "X": "Cancelled"
      }
    model.filter1 = function() {
      console.log(this.inputReqid);
      adminService.findREQ(this.inputReqid).then(function(response){
        console.log(response);
        model.REQJSON = response[0];
      }).then(function() {
        try {
          if (model.REQJSON['Ship_To']['Address_2'] == "NA") {
            model.REQJSON['Ship_To']['Address_2'] = ""}
          var abvStatus = model.REQJSON['Status']
          model.REQJSON['Status'] = model.statusDict[abvStatus];
          model.hideTables = false;
        }
        catch (e) {
          model.hideTables = true;
        }})}}})();
