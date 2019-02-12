/**
 * Created by User on 2016-04-19.
 */

angular.module('shippingService', [])
    .factory('shipService', ['$http', '$timeout','$q', function($http, $timeout, $q) {

        // *****************************START Active Shipments************************
        //Get all Locations
        var loadLocationAutoComplete = function () {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/shipping/getLocations'
            })
                .success(function (data) {
                    defer.resolve(data);

                });
            return defer.promise;
        };


        //Get Pick Work by shipment line
        var getPickWork = function (selectedShipmentLine) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/shipping/findAllPickWorksByShipmentLine',
                params: {selectedShipmentLine: selectedShipmentLine}

            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };



        //Get Pick Work by shipment
        var getPickWorkByShipment = function (selectedShipment) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/shipping/findAllPickWorksByShipment',
                params : {selectedShipment: selectedShipment}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };



        //complete shipment
        var completeShipment = function (shipmentId,workReferenceNumber,orderNumber,noOfLabels) {
            var defer = $q.defer();
            $http({
                method: 'POST',
                url: '/shipping/completeShipment',
                params:  {shipmentId:shipmentId, workReferenceNumber:workReferenceNumber, orderNumber:orderNumber, noOfLabels:noOfLabels}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //void Shipment
        var voidShipment = function (shipmentId, locationId, workReferenceNumber,orderNumber) {
            var defer = $q.defer();
            $http({
                method  : 'POST',
                url     : '/shipping/voidShipment',
                params: {shipmentId:shipmentId, locationId: locationId, workReferenceNumber:workReferenceNumber, orderNumber:orderNumber},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };



        //check shipment status
        var checkShipmentStatus = function (shipmentId) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/shipping/findShipment',
                params: {shipmentId: shipmentId}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };



        //load Shipment
        var loadShipment = function (shipmentId, truckNumber, trailerNumber, noOfLabels) {
            var defer = $q.defer();
            $http({
                method  : 'POST',
                url     : '/shipping/loadShipment',
                params: {shipmentId : shipmentId, truckNumber: truckNumber, trailerNumber: trailerNumber, noOfLabels:noOfLabels},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };



        //edit Shipment
        var editShipment = function (shipmentId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, contactName, shippingAddressId, shipmentNotes) {
            var defer = $q.defer();
            $http({
                method  : 'POST',
                url     : '/shipping/editShipment',
                params: {shipmentId : shipmentId,
                    carrierCode: carrierCode,
                    isParcel: isParcel,
                    serviceLevel: serviceLevel,
                    trackingNo: trackingNo,
                    truckNumber: truckNumber,
                    contactName: contactName,
                    shippingAddressId:shippingAddressId,
                    shipmentNotes:shipmentNotes},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };

        var editShipmentWithNewShippingAddress = function (shipmentId, carrierCode, isParcel, serviceLevel, trackingNo, truckNumber, contactName, customerId, streetAddress,city,state,postCode,country, shipmentNotes) {
            var defer = $q.defer();
            $http({
                method  : 'POST',
                url     : '/shipping/editShipmentWithNewShippingAddress',
                params: {shipmentId : shipmentId,
                    carrierCode: carrierCode,
                    isParcel: isParcel,
                    serviceLevel: serviceLevel,
                    trackingNo: trackingNo,
                    truckNumber: truckNumber,
                    contactName: contactName,
                    customerId:customerId,
                    streetAddress:streetAddress,
                    city:city,
                    state:state,
                    postCode:postCode,
                    country:country ,
                    shipmentNotes:shipmentNotes},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        var validateTruckNumber = function (truckNumber) {
            var defer = $q.defer();
            $http({
                method : 'GET',
                url : '/shipping/validateTruckNumber',
                params: {truckNumber: truckNumber}
            })
            .success(function (data) {
                defer.resolve(data);
            });
            return defer.promise;
        };

        //get total shipped qty
        var getTotalPickQty = function (selectedShipmentLine) {
            var defer = $q.defer();
            $http({
                method  : 'POST',
                url     : '/shipping/getTotalPickQty',
                params: {selectedShipmentLine: selectedShipmentLine},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //get order line
        var getOrderLine= function (shipmentLineId) {
            var defer = $q.defer();
            $http({
                method  : 'POST',
                url     : '/shipping/findOrderLine',
                params: {shipmentLineId : shipmentLineId},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //edit shipped qty
        var editShippedQty= function (shipmentLineId,shippedQuantity) {
            var defer = $q.defer();
            $http({
                method  : 'POST',
                url     : '/shipping/editShippedQty',
                data: {shipmentLineId : shipmentLineId, shippedQuantity: shippedQuantity},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };



        //Get Inventory by shipment line
        var getInventory = function (selectedShipmentLine) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/shipping/findAllInventoryByShipmentLine',
                params: {selectedShipmentLine: selectedShipmentLine}

            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };

        //Get Shipped Inventory by shipment line
        var getShippedInventory = function (selectedShipmentLine) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/shipping/findAllShippedInventoryByShipmentLine',
                params: {selectedShipmentLine: selectedShipmentLine}

            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        // ***********************END Active Shipments************************ ** ******



        //***************START active trucks*************************************

        //find truck
        var getTruck = function (id) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/shipping/findTruck',
                params:  {id:id}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //close truck
        var closeTruck = function (id) {
            var defer = $q.defer();
            $http({
                method: 'POST',
                url: '/shipping/closeTruck',
                params:  {id:id}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //reopen truck
        var openTruck = function (id) {
            var defer = $q.defer();
            $http({
                method: 'POST',
                url: '/shipping/openTruck',
                params:  {id:id}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //dispatch truck
        var dispatchTruck = function (id) {
            var defer = $q.defer();
            $http({
                method: 'POST',
                url: '/shipping/dispatchTruck',
                params:  {id:id}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //***************END active trucks*************************************


        return {
            loadLocationAutoComplete: loadLocationAutoComplete,
            getPickWork: getPickWork,
            getPickWorkByShipment:getPickWorkByShipment,
            completeShipment:completeShipment,
            voidShipment:voidShipment,
            checkShipmentStatus:checkShipmentStatus,
            loadShipment:loadShipment,
            editShipment:editShipment,
            editShipmentWithNewShippingAddress:editShipmentWithNewShippingAddress,
            validateTruckNumber:validateTruckNumber,
            getTotalPickQty:getTotalPickQty,
            getOrderLine:getOrderLine,
            editShippedQty:editShippedQty,
            getTruck:getTruck,
            closeTruck:closeTruck,
            openTruck:openTruck,
            dispatchTruck:dispatchTruck,
            getShippedInventory:getShippedInventory,
            getInventory:getInventory,
        };

    }]);
