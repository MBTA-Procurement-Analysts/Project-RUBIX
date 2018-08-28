(function () {
    angular
        .module('RUBIX')
        .controller('adminController', adminController);

    function adminController(getterService, $routeParams) {//currentUser){
        var model = this;
        model.collections = ["ITEM_DATA", "PO_DATA", "REQ_DATA"];
        model.operations = ["ADD", "UPDATE"];
        model.showCollections = true;
        model.updateView = function(selectedItem){
            if(selectedItem == "UPDATE"){
                model.showCollections = false;
            }else{
                model.showCollections = true;
            }
        };
        model.uploadFile = function(){
            var uploadFile = document.getElementById('fileUpload');

            console.log(selectedCollection);
            console.log('uploading file');
        }


        // getterService.findPO("10209").then(function(response){
        //     console.log(response);
        //     }
        // )
    }
})();