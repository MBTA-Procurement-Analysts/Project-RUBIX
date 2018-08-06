(function () {
    angular
        .module('RUBIX')
        .config(configuration);

    function configuration($routeProvider) {
        $routeProvider
            .when('/', {
                templateUrl: './admin/templates/query_builder.html',
                controller: 'adminController',
                controllerAs: 'model',
            }).when('/buyeritems', {
                templateUrl: './view/templates/buyer-items-info.html', 
                controller: 'buyerItemsController', 
                controllerAs: 'model'})
    }
})();
