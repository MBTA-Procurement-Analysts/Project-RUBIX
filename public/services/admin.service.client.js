(function () {
    angular
        .module('RUBIX')
        .service('adminService', adminService);

    function adminService($http) {

        var api = {
            findPO: findPO,

        };
        return api;

        function findPO(poNumber) {
            var url = "/api/po";
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