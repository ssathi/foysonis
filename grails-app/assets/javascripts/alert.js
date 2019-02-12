/**
 * Created by home on 9/15/15.
 */


var alertapp = angular.module('alertapp', []);

alertapp.controller('alertContoller', ['$scope', '$http', function ($scope, $http) {


    $scope.showData = function( ){


        $http({
            method : 'GET',
            url : '/alert/getAlerts'
        })
            .success(function (data, status, headers, config) {
                $scope.datalists = data;
            });



        //show more functionality
        var pagesShown = 1;
        var pageSize = 2;

        $scope.paginationLimit = function(data) {
            return pageSize * pagesShown;
        };
        $scope.hasMoreItemsToShow = function() {
            return pagesShown < ($scope.datalists.length / pageSize);
        };
        $scope.showMoreItems = function() {
            pagesShown = pagesShown + 1;
        };


    }

}]);

