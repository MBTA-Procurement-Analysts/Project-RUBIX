(function () {
    angular
        .module('RUBIX')
        .service('adminService', adminService);

    function adminService($http) {

        var api = {
            findPO: findPO,
            findREQ: findREQ,
            getCollections: getCollections
        };
        return api;

        function findPO(poNumber) {
            var url = "/api/po/" + poNumber;
            console.log(url);
            return $http.get(url)
                .then(function (response) {
                    return response.data;
                }, function (err) {
                    return err;
                });
        }
        function getCollections(){
            var url = "/api/collection-list";
            return $http.get(url)
                .then(function(response){
                    return response.data;
                }, function(err){
                    return err;
                })
        }

        function findREQ(reqNumber) {
            var url = "/api/req/" + reqNumber;
            console.log(url);
            return $http.get(url)
                .then(function (response) {
                    return response.data;
                }, function (err) {
                    return err;
                });
        }

    }
})();
