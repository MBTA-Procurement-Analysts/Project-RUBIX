(function () {
  angular
    .module('RUBIX')
    .controller('reqInfoController', reqInfoController)

  function reqInfoController(getterService, $routeParams) {//currentUser){
    console.log(navigator.userAgent)
    console.log("v0.3.5 as of 08/13/2018/1 12:22")
    var model = this;
    this.inputParams = $routeParams
    console.log(this.inputParams)
    try { 
      this.ifIE = String(navigator.userAgent).includes("Trident")
    } catch (err) {
      this.ifIE = true
    }
    console.log(this.ifIE)
    // incoming REQ, set by textbox
    this.inputReqid = "";
    // Page Title
    this.title = "Buyer Item Viewer";
    // Whether to hide the REQ Details view, true initially and when REQ is null
    this.hideTables = true;
    // Whether the REQ is valid, used to control the alert
    this.foundData = true;
    // Status abbreviation. Can be fixed in DB if wanted
    this.statusDict =
      {
        "A": "Approved",
        "C": "Completed",
        "P": "Pending",
        "X": "Cancelled"
      }
    this.itemStatusDict = 
      {
        1: "Active",
        2: "Hold",
        3: "Discontinue",
        4: "Inactive",
        5: "Pending Approval",
        6: "Denied Approval",
        7: "Under Initialization"
      }
    // Total Sum of the REQ, calculated on the fly
    this.totalSum = 0.0
    // Dictionary to hole the item data, key is item ID
    this.itemData1 = {}

    model.redir = function() {
      window.location = "#!/reqinfo?reqid=" + model.inputReqid;
    }

    // Obtain REQ from andminService, then clean it a bit
    model.filter1 = function() {
      if (model.inputReqid == null) {
        model.hideTables = true;
        model.foundData = false;
      } else {
        getterService.findREQ(this.inputReqid)
          .then(function(response){
            // Set REQ in this function
            model.REQJSON = response[0];
            // Reset Total Sum
            model.totalSum = 0.0
          }).then(function() {
            // Try the following wrangling scripts, if null go to Catch and hide the frame
            try {
              // Address NA processing
              // MFG_ID can also be processed, but not yet
              if (model.REQJSON['Ship_To']['Address_2'] == "NA") {
                model.REQJSON['Ship_To']['Address_2'] = ""}
              // Status Translation
              var abvStatus = model.REQJSON['Status']
              model.REQJSON['Status'] = model.statusDict[abvStatus];
              // Calculates total sum of the REQ
              // `for i in x in JS returns index, not objects`
              // Oh I miss python
              for (item in model.REQJSON['lines']) {
                model.totalSum += model.REQJSON['lines'][item]['Line_Total'];
                if (model.REQJSON['lines'][item]['More_Info'].length > 175) {
                  model.REQJSON['lines'][item]['More_Info'] = model.REQJSON['lines'][item]['More_Info'].substring(0,65) + "...";
                }

              }

              // Construct the list of items by quering the getterService
              model.itemData1 = {};
              model.constructItemList();
              // Display the Details component, remove the alert if displaying
              model.hideTables = false;
              model.foundData = true;
              model.title = "View REQ#" + model.REQJSON['REQ_No']
            }
            // Try Block will fail if no data, hide component and show alert in this case
            catch (e) {
              model.hideTables = true;
              model.foundData = false;
            }})}}

    // Function to construct the item list
    model.constructItemList = function() {
      try {
        for (line in model.REQJSON['lines']) {
          getterService.findItem(model.REQJSON['lines'][line]['Item'])
            .then(function(response) {
              var modifiedResponse = response[0];
              for (wareHouseLine in modifiedResponse['Warehouse_Information']) {
                var wareHouseStatus = modifiedResponse['Warehouse_Information'][wareHouseLine]['Status_Current']
                modifiedResponse['Warehouse_Information'][wareHouseLine]['Status_Current'] = model.itemStatusDict[wareHouseStatus]
              } 
              modifiedResponse['Status'] = model.itemStatusDict[response[0]['Status']];
              model.itemData1[response[0]['Item_No']] = response[0]})

        }
      }
      catch (e) {
      }
    }



    if (this.inputParams['reqid']) {
      this.inputReqid = this.inputParams['reqid'];
      model.filter1();
    }
  }})();
