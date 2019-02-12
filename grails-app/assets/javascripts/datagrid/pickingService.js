/**
 * Created by home on 1/11/16.
 */
angular.module('pickingService', [])
    .factory('pickService', ['$http', '$timeout','$q', function($http, $timeout, $q) {


       var getPalletPicksByShipment = function (shipmentId) {
            var defer = $q.defer();

           $http({
                method: 'GET',
                url: '/picking/getAllPalletPicksByShipment',
                params: {shipmentId: shipmentId}
            })
            .success(function(data) {
                defer.resolve(data);
            });

            return defer.promise;
        };


    var getAllPickListByShipment = function(shipmentId){

        var defer = $q.defer();
       $http({
            method: 'GET',
            url: '/picking/getAllPickListDataByShipment',
            params: {shipmentId: shipmentId}
        })
        .success(function(data) {
            defer.resolve(data);          
        });

        return defer.promise;
    };

    var getPickWorkDataByPickList = function(pickListId){
        var defer = $q.defer();
       $http({
            method: 'GET',
            url: '/picking/getPickWorkData',
            params: {pickListId: pickListId}
        })
        .success(function(data) {

            defer.resolve(data);
        });
        return defer.promise;
    };    

    var getReplenishmentWorkDataByShipment = function(shipmentId){
       var defer = $q.defer();
       $http({
            method: 'GET',
            url: '/picking/getReplenishmentWorkDataByShipment',
            params: {shipmentId: shipmentId}
        })
        .success(function(data) {
           defer.resolve(data);          
        });
        return defer.promise;
    };       


    var getAllShipmentLinesByShipmentId = function(shipmentId){
       
        var defer = $q.defer();
       $http({
            method: 'GET',
            url: '/picking/getAllShipmentLinesByShipmentId',
            params: {shipmentId: shipmentId}
        })
        .success(function(data) {
             defer.resolve(data);          
        });
        return defer.promise;
    };

    var getSelectedShipmentDataByShipmentId = function(shipmentId){
       var defer = $q.defer();
       $http({
            method: 'GET',
            url: '/picking/getSelectedShipmentDataByShipmentId',
            params: {shipmentId: shipmentId}
        })
        .success(function(data) {
            defer.resolve(data);         
        });
        return defer.promise;
    };


    var shipmentSearch = function (findShipmentData) {
        var defer = $q.defer();
        $http({
            method: 'POST',
            url: '/picking/searchShipment',
            params: {shipmentId:findShipmentData.shipmentId, orderNumber:findShipmentData.orderNumber, allocationStatus: findShipmentData.allocationStatus,
                    fromShipmentCreation:findShipmentData.fromShipmentCreation,
                    toShipmentCreation:findShipmentData.toShipmentCreation, completedShipment:findShipmentData.completedShipment},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
            .success(function (data) {
                defer.resolve(data);
            })
            return defer.promise;
    };


        return {
            getPalletPicksByShipment: getPalletPicksByShipment,
            getAllPickListByShipment: getAllPickListByShipment,
            getPickWorkDataByPickList:getPickWorkDataByPickList,
            getReplenishmentWorkDataByShipment:getReplenishmentWorkDataByShipment,
            getAllShipmentLinesByShipmentId:getAllShipmentLinesByShipmentId,
            getSelectedShipmentDataByShipmentId:getSelectedShipmentDataByShipmentId,
            shipmentSearch:shipmentSearch
        };
  


    }]);