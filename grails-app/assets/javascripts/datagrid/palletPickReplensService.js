/**
 * Created by User on 2016-03-14.
 */

angular.module('palletPickReplensService', [])
    .factory('palletPickService', ['$http', '$timeout','$q', function($http, $timeout, $q) {

        // *****************************START PALLET PICKS************************
        //Get all PalletPick
        var getAllPalletPick = function () {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/picking/findPalletPick'
            })
                .success(function (data) {
                    defer.resolve(data);

                });
            return defer.promise;
        };


        //Get completed PalletPick
        var getCompletedPalletPick = function () {
            var defer = $q.defer();
                $http({
                    method: 'GET',
                    url: '/picking/findCompletedPalletPick'
                })
                    .success(function (data) {
                        defer.resolve(data);

                    });
            return defer.promise;
        };


        //Find Pick Work
        var checkPickWork = function (workReferenceNumber) {
            var defer = $q.defer();
            $http({
                method: 'POST',
                url: '/picking/findPickWorkStatus',
                params: {workReferenceNumber: workReferenceNumber}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //confirm Pallet Lpn for pick work
        var confirmPalletLpnForPickWork = function (workReferenceNumber, lpn, level, locationId, itemId, inventoryStatus, quantity, handlingUom) {
            var defer = $q.defer();
            $http({
                method: 'POST',
                url: '/picking/confirmPalletLpnForPalletPick',
                params: {workReferenceNumber: workReferenceNumber,lpn: lpn,
                    level: level,locationId: locationId, itemId: itemId, inventoryStatus: inventoryStatus, quantity: quantity, handlingUom: handlingUom}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //confirm Destination Location for pick work
        var confirmDestinationLocationForPickWork = function (workReferenceNumber, lpn, destinationLocationId, shipmentId) {
            var defer = $q.defer();
            $http({
                method: 'POST',
                url: '/picking/confirmDestinationLocationForPalletPick',
                params: {workReferenceNumber: workReferenceNumber, lpn: lpn, destinationLocationId: destinationLocationId, shipmentId: shipmentId}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        // ***********************END PALLET PICKS************************ ** ******

        // *****************************START REPLENS WORK************************

        //Get active and In Process Replenishment
        var getAllReplens = function () {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/picking/findActiveAndInProcessReplenishment'
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //Get completed Replenishment
        var getCompletedReplens = function () {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/picking/findCompletedReplenishment'
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //Get expired Replenishment
        var getExpiredReplens = function () {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/picking/findExpiredReplenishment'
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //Get completed and expired Replenishment
        var getCompletedAndExpiredReplens = function () {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/picking/findCompletedAndExpiredReplenishment'
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //Get current login user
        var checkCurrentUser = function(){
            var defer = $q.defer();

            $http({
                method: 'GET',
                url: '/user/getCurrentUser'
            })
                .success(function (data) {
                    defer.resolve(data);
                });

            return defer.promise;
        };


        //Find Replens
        var checkReplensStatus = function (replenReference) {
            var defer = $q.defer();
            $http({
                method: 'POST',
                url: '/picking/findReplenishment',
                params: {replenReference: replenReference}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //confirm Lpn
        var confirmLpn = function (replenReference, lpn) {
            var defer = $q.defer();
            $http({
                method: 'POST',
                url: '/picking/confirmPalletLpn',
                params: {replenReference: replenReference, lpn: lpn},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //confirm Destination Location
        var confirmDestinationLocation = function (replenReference, lpn, destinationLocationId, workReferenceNumber) {
            var defer = $q.defer();
            $http({
                method: 'POST',
                url: '/picking/confirmDestinationLocation',
                params: {
                    replenReference: replenReference,
                    lpn: lpn,
                    destinationLocationId: destinationLocationId,
                    workReferenceNumber: workReferenceNumber
                },
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}

            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //Get Inventory By Destination Location
        var getInventoryByLocation = function (selectedLocation) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/picking/getInventoryByLocation',
                params: {selectedLocation: selectedLocation}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //Get Lpn By Source Location
        var getLpnByLocation = function (selectedSourceLocation) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/picking/getLpnByLocation',
                params: {selectedSourceLocation: selectedSourceLocation}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //Find Item
        var findSelectedItem = function (selectedItem) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/picking/findItem',
                params: {selectedItem: selectedItem}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //Get CaseLpn By Source Location
        var getCaseLpnByLocation = function (selectedLocation) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/picking/confirmCaseLpnForCase',
                params: {selectedLocation: selectedLocation}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //Get Lpn By Source Location
        var getLpnByLocationForCases = function (selectedSourceLocation) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/picking/getLpnByLocationForCase',
                params: {selectedSourceLocation: selectedSourceLocation}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //Confirm Qty
        var getInventoryByAssociateLpn = function (selectedLpn) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/picking/confirmCaseLpn',
                params: {selectedLpn: selectedLpn}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };


        //Find Pick Work
        var getPickWork = function (selectedPickWork) {
            var defer = $q.defer();
            $http({
                method: 'GET',
                url: '/picking/findPickWorksByReplensWork',
                params: {selectedPickWork: selectedPickWork}
            })
                .success(function (data) {
                    defer.resolve(data);
                });
            return defer.promise;
        };

        // *****************************END REPLENS WORK************************

        return {
            getAllPalletPick: getAllPalletPick,
            getCompletedPalletPick: getCompletedPalletPick,
            checkPickWork: checkPickWork,
            confirmPalletLpnForPickWork: confirmPalletLpnForPickWork,
            confirmDestinationLocationForPickWork: confirmDestinationLocationForPickWork,

            getAllReplens: getAllReplens,
            getCompletedReplens: getCompletedReplens,
            getExpiredReplens: getExpiredReplens,
            getCompletedAndExpiredReplens: getCompletedAndExpiredReplens,

            checkCurrentUser: checkCurrentUser,
            checkReplensStatus: checkReplensStatus,
            confirmLpn: confirmLpn,
            confirmDestinationLocation: confirmDestinationLocation,
            getInventoryByLocation: getInventoryByLocation,
            getLpnByLocation: getLpnByLocation,

            findSelectedItem: findSelectedItem,
            getCaseLpnByLocation: getCaseLpnByLocation,
            getLpnByLocationForCases: getLpnByLocationForCases,
            getInventoryByAssociateLpn: getInventoryByAssociateLpn,

            getPickWork: getPickWork

        };

    }]);
