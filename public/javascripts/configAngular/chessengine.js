 var ChessController = Masterplay.controller('ChessController', function($scope){
     $scope.grid = new Grid()
     $scope.grid.initialize();
     $scope.whiteTurn = true
     $scope.selectedPosition = null
     $scope.partie = "Titre de la partie"

     /*$scope.currentColor = function(){
         "use strict";
         if ($scope.whiteTurn){
            return 'white'
         }
         else{
            return 'black'
         }
     }*/

 });

