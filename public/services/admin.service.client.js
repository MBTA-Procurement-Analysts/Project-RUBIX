(function () {
    angular
        .module('RUBIX')
        .service('adminService', adminService);

    function adminService($http) {

        var api = {
            updatePO: updatePO,
            updateREQ: updateREQ,
            getCollections: getCollections,
            findItem: findItem
        };
        return api;

        function findItem(itemNumber) {
            var url = "/api/item/" + itemNumber;
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
