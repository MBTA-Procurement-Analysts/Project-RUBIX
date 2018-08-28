(function () {
  angular
    .module('RUBIX')
    .config(configuration);

  function configuration($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: './home/home.html',
      })
      .when('/admin/input', {
        templateUrl: './admin/templates/query_builder.html',
        controller: 'adminController',
        controllerAs: 'model'
      })
      .when('/buyeritems/:reqid', {
        templayeUrl: './view/templates/buyer-items-info.html',
        controller: 'buyerItemsController',
        controllerAs: 'model',
      })
      .when('/buyeritems', {
        templateUrl: './view/templates/buyer-items-info.html', 
        controller: 'buyerItemsController', 
        controllerAs: 'model'})
      .when('/buyeritemsdynamic', {
        templateUrl: './view/templates/buyer-items-info-dynamic.html', 
        controller: 'buyerItemsController', 
        controllerAs: 'model'})
      .when('/buyeritemsdynamic/:reqid', {
        templateUrl: './view/templates/buyer-items-info-dynamic.html', 
        controller: 'buyerItemsController', 
        controllerAs: 'model'})
  }
})();
