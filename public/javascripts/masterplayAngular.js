
//masterplay = angular.module('Masterplay',[])
//.config ["$routeProvider", ($routeProvider) ->
//  $routeProvider.when "/users", {templateUrl: 'users/index', controller: UserController}
//  $routeProvider.otherwise {redirectTo: "/"}


//]


var Masterplay = angular.module('Masterplay',['ngRoute']);
Masterplay.config(['$routeProvider', function($routeProvider){
    "use strict";
    $routeProvider.when('/users',{templateUrl: 'users/index.jade',controller: UserController})
        .otherwise({redirectTo: '/'})
}]);
