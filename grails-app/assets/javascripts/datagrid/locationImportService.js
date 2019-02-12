/**
 * Created by home on 8/2/16.
 */

angular.module('locationImportService', [])
    .factory('locationImpService', ['$http', '$timeout','$q', function($http, $timeout, $q) {

        var checkAreaIdExist = function(areaId){
            var defer = $q.defer();

            $http({
                method: 'GET',
                url : '/area/checkAreaIdExist',
                params: {areaId: areaId}
            })
                .success(function (data) {
                    defer.resolve(data);
                });

            return defer.promise;
        };

        var checkLocationIdExist = function(locationId){
            var defer = $q.defer();

            $http({
                method: 'GET',
                url : '/location/checkLocationIdExist',
                params: {locationId: locationId}
            })
                .success(function (data) {
                    defer.resolve(data);
                });

            return defer.promise;
        };

        var checkBarcodeExist = function(locationBarcode, locationId){
            var defer = $q.defer();

            $http({
                method: 'GET',
                url : '/location/checkLocationBarcodeExist',
                params: {locationBarcode: locationBarcode,locationId: locationId}
            })
                .success(function (data) {
                    defer.resolve(data);
                });

            return defer.promise;
        };


            return {
                checkAreaIdExist: checkAreaIdExist,
                checkLocationIdExist: checkLocationIdExist,
                checkBarcodeExist: checkBarcodeExist
        };


    }]);