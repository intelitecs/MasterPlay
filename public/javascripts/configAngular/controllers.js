Masterplay.controller('ApplicationController', function($scope){
    "use strict";
    $scope.application_title = "MasterPlay Application Powered by NodeJs, AngularJs, Express, Bootstrap3, JQuery";
});



var UserController = Masterplay.controller('UserController',function($scope,$http){
    "use strict";
    //$scope.grid = new Grid()
    //$scope.grid.initialize();
    $scope.name = "Jarode Zago";
    $scope.partie = "Titre de la partie"

    $scope.currentColor = function(){
        return "Black";
    };


    var users = {};

    $http.get('/users').then(function(response){
            console.log("Users length from UserController: "+ response.data.length);
            users = response.data;
            $scope.users = users;
            console.log($scope.users);
        },
        function(error){
            console.error(error)
        });
    $scope.showUsers = function($index){
        $scope.user  = $scope[$index];
    };
});