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
            })
    }
})();