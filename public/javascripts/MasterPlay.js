/**
 * Created by imhotep on 21/02/2014.
 */


$(function(){
    "use strict";

    $(".row").mouseover(function(){
        $(this).css({color: "#3c3d3e", border:"1px solid #34cd3e",background:"#bcabc2"});
    });

    $(".row").mouseout(function(){
        $(this).css({border:"none",color:"#2b2bEb",background:"#fff"});
    });

   $('#datepicker').datepicker({
           maxDate: "+1m  +1w",
           //altFormat: "dd-mm-yy",
           dayNames: ["Dimanche","Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi"],
           onSelect: function(dateText, instance){
                console.log(dateText);
           }

       }
   );


   $(".symbol").click(function(evt){
       evt.preventDefault();
       //alert($(this).text());
       var src = $(this).children().first().attr('src');
       $('.currentImage').attr({src: src});
       $('strong.number').text($(this).text());
       $('div#selectedPlayer').css({'visibility':'visible'});
       $('.chessboard').addClass('changechessboardmargintop');
	   
   });


});

var HelloCtrl = function($scope){
    "use strict";
    //$scope.name = 'World';
    $scope.population = 7000;
    $scope.countries = [
        {name: "Côte d'ivoire", population: 25.5},
        {name: "Ghana", population: 20.2},
        {name: "Nigeria", population: 200.5}
    ];

    $scope.worldsPercentage = function(countryPopulation){
        return (countryPopulation / $scope.population) * 100;
    };
};