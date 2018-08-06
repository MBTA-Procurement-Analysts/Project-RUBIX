(function () {
    angular
        .module('RUBIX')
        .controller('adminController', adminController);

    function adminController(adminService, $routeParams) {//currentUser){
        var model = this;
        adminService.getCollections().then(function(response){
            model.collections = response;
        })
        // adminService.findPO("10209").then(function(response){
        //     console.log(response);
        //     }
        // )
    }
})();