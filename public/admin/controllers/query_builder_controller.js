(function () {
    angular
        .module('RUBIX')
        .controller('adminController', adminController);

    function adminController(adminService, $routeParams) {//currentUser){
        var model = this;
        adminService.findPO("10209").then(function(response){
            console.log(response);
            }
        )
    }
})();