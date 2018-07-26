(function () {
    angular
        .module('RUBIX')
        .service('adminService', adminService);

    function adminService($http) {

        var api = {
            //getNews: getNews,

        };
        return api;

        function createNews(news) {
            var url = "/api/news";
            console.log(url);
            //console.log(news);
            return $http.post(url, news)
                .then(function (response) {
                    return response.data;
                }, function (err) {
                    return err;
                });
        }

    }
})();