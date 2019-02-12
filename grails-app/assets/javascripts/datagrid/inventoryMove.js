/**
 * Created by home on 10/14/15.
 */

var app = angular.module('inventoryMove', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ui.grid.expandable', 'ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ngSanitize', 'ui.grid.pagination','ui.bootstrap', 'ngLocale']);

app.controller('InventoryMoveCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

    var myEl = angular.element( document.querySelector( '#liInventory' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulInventory' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var ctrl = this;

    $scope.loadLocationAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/location/getCompanyAllLocations',
            params : {keyword: value.keyword}
        });
    }

    $scope.loadUnblockedLocationAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/location/getCompanyAllUnblockedLocations',
            params : {keyword: value.keyword}
        });
    }    

    $scope.loadPalletAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/inventory/getPallets',
            params : {keyword: value.keyword}
        });
    }

    //var loadPalletAutoComplete = function () {
    //    $http.get('/inventory/getPallets')
    //        .success(function(data) {
    //            $scope.sourcePallets = data;
    //        });
    //};

    $scope.loadCaseAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/inventory/getCases',
            params : {keyword: value.keyword}
        });
    }

    //var loadCaseAutoComplete = function () {
    //    $http.get('/inventory/getCases')
    //        .success(function(data) {
    //            $scope.sourceCases = data;
    //        });
    //};


    var clearAutoCompText = function(){
        ctrl.location = ''; 
        ctrl.disabledFind = ctrl.findInventory.location|| ctrl.findInventory.lpn || ctrl.findInventory.itemId ? false : true;
    };


    $scope.callbackPalletMovePalletId = function(selected) {

        $http({
            method : 'GET',
            url : '/inventory/getLocationId',
            params: {palletId: selected.locationId}
        })
            .success(function (data, status, headers, config) {
                ctrl.PalletMovePalletInfo = "The pallet " + selected.locationId + " is located at location " + data[0].locationId;
            })

        ctrl.disabledBtnMovePallet = selected && ctrl.movePallet.location ? false : true;
    };

    $scope.callbackPalletMoveLocationId = function(selected) {
        if (selected.is_bin === true) {
            $('#binAreaSelectWarning').appendTo('body').modal('show');
            ctrl.binLocationSelected = true;
        }
        else{
            ctrl.binLocationSelected = false;
        }

        $http({
            method : 'GET',
            url : '/inventory/getLpnByLocation',
            params: {locationId: selected.locationId}
        })
            .success(function (data, status, headers, config) {

                ctrl.PalletMoveLocationInfo = data;
                //var info = "";
                //
                //if(data.length > 0){
                //    info = 'This location contains <br/>';
                //
                //    for (i = 0; i < data.length; i++) {
                //        info += data[i].level + '-' +  data[i].lPN + '<br/>';
                //    }
                //}
                //else{
                //    info = "This location doesn't have any pallet or case";
                //
                //}
                //ctrl.PalletMoveLocationInfo = info;
            })
        ctrl.disabledBtnMovePallet = ctrl.movePallet.pallet && selected ? false : true;
    };

    $scope.callbackCaseMoveCaseId = function(selected) {
        $http({
            method : 'GET',
            url : '/inventory/getCaseParentId',
            params: {caseId: selected.locationId}
        })
            .success(function (data, status, headers, config) {
                ctrl.CaseMoveCaseInfo = "The case " + selected.locationId + " is located at " + data[0].parentType + " " + data[0].parentId;
                if (data[0].parentType == 'Location') {
                    ctrl.locationIdForCaseMove = data[0].parentId;
                }
                else{
                    ctrl.locationIdForCaseMove = '';
                }
                 
            })
                
        ctrl.disabledBtnMoveCase = selected && (ctrl.moveCase.pallet || ctrl.moveCase.location) ? false : true;
    };

    $scope.callbackCaseMovePalletId = function(selected) {

        $http({
            method : 'GET',
            url : '/inventory/getLocationId',
            params: {palletId: selected.locationId}
        })
            .success(function (data, status, headers, config) {
                ctrl.CaseMovePalletInfo = "The pallet " + selected.locationId + " is located at location " + data[0].locationId;
            })
        ctrl.CaseMoveLocationInfo = "";
        ctrl.moveCase.location = null;
        ctrl.disabledBtnMoveCase = ctrl.moveCase.case && selected ? false : true;
    };

    $scope.callbackCaseMoveLocationId = function(selected) {

        if (selected.is_bin === true) {
            $('#binAreaSelectWarning').appendTo('body').modal('show');
            ctrl.binLocationSelectedForCase = true;
        }
        else{
            ctrl.binLocationSelectedForCase = false;
        }


        $http({
            method : 'GET',
            url : '/inventory/getLpnByLocation',
            params: {locationId: selected.locationId}
        })
            .success(function (data, status, headers, config) {
                var info = "";

                if(data.length > 0){
                    info = "This location contains: ";

                    for (i = 0; i < data.length; i++) {
                        if(i !=0){
                            info += ","
                        }
                        info += " '" + data[i].level + '-' +  data[i].lPN + "'";
                    }

                }
                else{
                    info = "This location doesn't have any pallet or case";

                }
                ctrl.CaseMoveLocationInfo = info;
            })
        ctrl.CaseMovePalletInfo = "";
        ctrl.moveCase.pallet = null;
        ctrl.disabledBtnMoveCase = ctrl.moveCase.case && selected ? false : true;
    };

    var movePalletToLocation = function () {
        if (ctrl.binLocationSelected) {

            $http({
                method : 'GET',
                url : '/inventory/checkLowestUomOfItemByLpn',
                params: {lpn: ctrl.movePallet.pallet}
            })
            .success(function (data, status, headers, config) {

                if (data.length > 0) {
                    $('#palletMoveToBinWarn').appendTo('body').modal('show');
                }
                else{

                    $http({
                        method: 'POST',
                        url: '/inventory/movePalletToBinLocation',
                        params: {palletId:ctrl.movePallet.pallet, locationId:ctrl.movePallet.location},
                        dataType: 'json',
                        headers : { 'Content-Type': 'application/json; charset=utf-8' }
                    })
                        .success(function (data) {
                            if (data.isPalletContainsCases == true) {
                                $('#palletMoveToBinWarn').appendTo('body').modal('show');
                            }
                            else{
                                ctrl.movePalletPrompt = true;
                                ctrl.movePalletSuccessMessage = "Pallet " + ctrl.movePallet.pallet + " has been moved to location " + ctrl.movePallet.location ;
                                ctrl.movePallet.pallet = null;
                                ctrl.movePallet.location = null;
                                ctrl.PalletMovePalletInfo = "";
                                ctrl.PalletMoveLocationInfo = "";
                                ctrl.binLocationSelected = false;
                                $timeout(function(){
                                    ctrl.movePalletPrompt = false;
                                }, 4000);                                    
                            }

                        })


                }


            })

        }
        else{
            $http({
                method: 'POST',
                url: '/inventory/movePalletToLocation',
                params: {palletId:ctrl.movePallet.pallet, locationId:ctrl.movePallet.location},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    inventorySearch();
                })
            ctrl.movePalletPrompt = true;
            ctrl.movePalletSuccessMessage = "Pallet " + ctrl.movePallet.pallet + " has been moved to location " + ctrl.movePallet.location ;
            ctrl.movePallet.pallet = null;
            ctrl.movePallet.location = null;
            ctrl.PalletMovePalletInfo = "";
            ctrl.PalletMoveLocationInfo = "";
            ctrl.binLocationSelected = false;
            $timeout(function(){
                ctrl.movePalletPrompt = false;
            }, 4000);
        }
    };

    var moveCaseToPalletOrLocation = function () {

        if (ctrl.locationIdForCaseMove == 'TEMPLOCATION') {
            $('#tempLocationMoveWarn').appendTo('body').modal('show');
        }
        else{
            if (ctrl.binLocationSelectedForCase) {

                $http({
                    method : 'GET',
                    url : '/inventory/checkLowestUomOfItemByLpn',
                    params: {lpn: ctrl.moveCase.case}
                })
                .success(function (data, status, headers, config) {

                    if (data.length > 0) {
                         $('#caseMoveToBinWarn').appendTo('body').modal('show');
                    }
                    else{
                        $('#caseMoveToBinWarn').appendTo('body').modal('show');
                        // $http({
                        //     method: 'POST',
                        //     url: '/inventory/moveCaseToBinLocation',
                        //     params: {caseId:ctrl.moveCase.case, locationId:ctrl.moveCase.location},
                        //     dataType: 'json',
                        //     headers : { 'Content-Type': 'application/json; charset=utf-8' }
                        // })
                        //     .success(function (data) {
                        //         //inventorySearch();
                        //         ctrl.moveCasePrompt = true;
                        //         ctrl.moveCaseSuccessMessage = "Case " + ctrl.moveCase.case + " has been moved";
                        //         ctrl.moveCase.case = null;
                        //         ctrl.moveCase.pallet = null;
                        //         ctrl.moveCase.location = null;
                        //         ctrl.CaseMoveCaseInfo = "";
                        //         ctrl.locationIdForCaseMove = "";
                        //         ctrl.CaseMovePalletInfo = "";
                        //         ctrl.CaseMoveLocationInfo = "";
                        //         ctrl.binLocationSelectedForCase = false;
                        //         $timeout(function(){
                        //             ctrl.moveCasePrompt = false;
                        //         }, 1000);  
                        //     })


                    }


                })

            }
            else{

                $http({
                    method: 'POST',
                    url: '/inventory/moveCaseToPalletOrLocation',
                    params: {caseId:ctrl.moveCase.case, palletId:ctrl.moveCase.pallet, locationId:ctrl.moveCase.location},
                    dataType: 'json',
                    headers : { 'Content-Type': 'application/json; charset=utf-8' }
                })
                    .success(function (data) {
                        //inventorySearch();
                        ctrl.moveCasePrompt = true;
                        ctrl.moveCaseSuccessMessage = "Case " + ctrl.moveCase.case + " has been moved";
                        ctrl.moveCase.case = null;
                        ctrl.moveCase.pallet = null;
                        ctrl.moveCase.location = null;
                        ctrl.CaseMoveCaseInfo = "";
                        ctrl.locationIdForCaseMove = "";
                        ctrl.CaseMovePalletInfo = "";
                        ctrl.CaseMoveLocationInfo = "";
                        ctrl.binLocationSelectedForCase = false;
                        $timeout(function(){
                            ctrl.moveCasePrompt = false;
                        }, 1000);  
                    })
            
            }
        }


    };


    ctrl.moveEntireLocErrorMessage = '';
    ctrl.disableMoveForEntireLoc = false;
    var moveEntireLocation = function () {

        if (ctrl.entireLoc.fromLocation && ctrl.entireLoc.toLocation) {
            if (ctrl.entireLoc.fromLocation == ctrl.entireLoc.toLocation) {
                ctrl.disableMoveForEntireLoc = true;
                ctrl.moveEntireLocErrorMessage = "'From Location' And 'To location' cannot be same"; 
                $timeout(function(){
                    ctrl.disableMoveForEntireLoc = false;
                    ctrl.moveEntireLocErrorMessage = '';
                }, 4000);                 
            }
            else{


                if (ctrl.binLocSelectedForLocMove) {

                    $http({
                        method : 'GET',
                        url : '/inventory/checkLowestUomOfItemByLocation',
                        params: {locationId: ctrl.entireLoc.fromLocation}
                    })
                    .success(function (data, status, headers, config) {
                        if (data.length > 0) {
                            $('#caseTrackToBinWarn').appendTo('body').modal('show');
                        }
                        else{   
                            $http({
                                method: 'POST',
                                url: '/inventory/moveEntireLocationToBinLocation',
                                params: {fromLocation:ctrl.entireLoc.fromLocation, toLocation:ctrl.entireLoc.toLocation},
                                dataType: 'json',
                                headers : { 'Content-Type': 'application/json; charset=utf-8' }
                            })
                            .success(function (data) {
                                //inventorySearch();
                                ctrl.moveEntireLocSuccessMessage = "Inventory has been moved from Location " + ctrl.entireLoc.fromLocation + " to location " + ctrl.entireLoc.toLocation;
                                ctrl.moveEntireLocPrompt = true;
                                ctrl.entireLoc.fromLocation = null;
                                ctrl.entireLoc.toLocation = null;
                                ctrl.moveEntireLocErrorMessage = '';
                                ctrl.disableMoveForEntireLoc = '';
                                ctrl.fromLocationInventoryInfo = []; 
                                ctrl.toLocationInventoryInfo = [];
                                $timeout(function(){
                                    ctrl.moveEntireLocPrompt = false;
                                    ctrl.moveEntireLocSuccessMessage = '';
                                }, 5000);  
                                ctrl.binLocSelectedForLocMove = false;          

                            })                        
                        }                     

                    })                    

                }else{
                    $http({
                        method: 'POST',
                        url: '/inventory/moveEntireLocation',
                        params: {fromLocation:ctrl.entireLoc.fromLocation, toLocation:ctrl.entireLoc.toLocation},
                        dataType: 'json',
                        headers : { 'Content-Type': 'application/json; charset=utf-8' }
                    })
                    .success(function (data) {
                        //inventorySearch();
                        ctrl.moveEntireLocSuccessMessage = "Inventory has been moved from Location " + ctrl.entireLoc.fromLocation + " to location " + ctrl.entireLoc.toLocation;
                        ctrl.moveEntireLocPrompt = true;
                        ctrl.entireLoc.fromLocation = null;
                        ctrl.entireLoc.toLocation = null;
                        ctrl.moveEntireLocErrorMessage = '';
                        ctrl.disableMoveForEntireLoc = '';
                        ctrl.fromLocationInventoryInfo = []; 
                        ctrl.toLocationInventoryInfo = [];
                        $timeout(function(){
                            ctrl.moveEntireLocPrompt = false;
                            ctrl.moveEntireLocSuccessMessage = '';
                        }, 5000);            

                    })                    
                }
            }
        }
    };


    ctrl.getLocationIdInventoryData = function(selected, locType) {
        $http({
            method : 'GET',
            url : '/inventory/getAllInventoryDataByLocation',
            params: {locationId: selected.locationId}
        })
            .success(function (data, status, headers, config) {
                    if (locType == 'fromLocation') {
                       ctrl.fromLocationInventoryInfo = data; 
                    }
                    else if (locType == 'toLocation') {
                       ctrl.toLocationInventoryInfo = data; 

                        if (selected.is_bin === true) {
                            $('#binAreaSelectWarning').appendTo('body').modal('show');
                            ctrl.binLocSelectedForLocMove = true;
                        }
                        else{
                            ctrl.binLocSelectedForLocMove = false;
                        }                       
                    }               
            })
    };

    var showMessagesForLocationMove = function (field) {
        if (ctrl.moveEntireLocForm[field]) {
            return ctrl.moveEntireLocForm[field].$touched || ctrl.moveEntireLocForm.$submitted;
        }
        
    };

    var hasErrorClass = function (field) {
        if (ctrl.moveEachesForm[field]) {
            return ctrl.moveEachesForm[field].$touched && ctrl.moveEachesForm[field].$invalid;
        }
    };

    ctrl.allInventoryItemByLocation = [];
    ctrl.allInventoryStatusData = [];
    ctrl.inventoryTotalQty = [];


    var moveEachesToLocation = function () {

        if (ctrl.eachesMove.fromLocation && ctrl.eachesMove.toLocation) {
            if (ctrl.eachesMove.fromLocation == ctrl.eachesMove.toLocation) {
                ctrl.disableMoveForEaches = true;
                ctrl.eachesMoveLocErrorMessage = "'From Location' And 'To location' cannot be same"; 
                $timeout(function(){
                    ctrl.disableMoveForEaches = false;
                    ctrl.moveEntireLocErrorMessage = '';
                }, 4000);                 
            }
            else{

                if (ctrl.inventoryTotalQty[0].total_inventory_qty >= ctrl.eachesMove.moveQty) {
                        if( ctrl.moveEachesForm.$valid) {
                            $http({
                                method: 'POST',
                                url: '/inventory/moveEachesToLocation',
                                params: {fromLocation:ctrl.eachesMove.fromLocation, toLocation:ctrl.eachesMove.toLocation, itemId:ctrl.eachesMove.itemId, inventoryStatus:ctrl.eachesMove.inventoryStatus, moveQty:ctrl.eachesMove.moveQty, totalQty:ctrl.inventoryTotalQty[0].total_inventory_qty},
                                dataType: 'json',
                                headers : { 'Content-Type': 'application/json; charset=utf-8' }
                            })
                            .success(function (data) {
                                //inventorySearch();
                                ctrl.eachesMoveSuccessMessage = "Eaches has been moved from Location " + ctrl.eachesMove.fromLocation + " to location " + ctrl.eachesMove.toLocation;
                                ctrl.eachesMovePrompt = true;
                                ctrl.eachesMove.fromLocation = null;
                                ctrl.eachesMove.toLocation = null;
                                ctrl.eachesMove.itemId = null;
                                ctrl.eachesMove.inventoryStatus = null;
                                ctrl.eachesMove.moveQty = null;

                                ctrl.eachesMoveErrorMessage = '';
                                //ctrl.disableMoveForEntireLoc = '';
                                ctrl.allInventoryItemByLocation = [];
                                ctrl.allInventoryStatusData = [];
                                ctrl.inventoryTotalQty = [];
                                ctrl.disableAllMoveEach = false;
                                ctrl.disableItemSelection = false;
                                $timeout(function(){
                                    ctrl.eachesMovePrompt = false;
                                    ctrl.eachesMoveSuccessMessage = '';
                                }, 5000);            

                            })
                        }

                }
            }
        }
    };


    var callLocationForinventory = function(selected){

        $http({
            method : 'GET',
            url : '/inventory/getAllInventoryItemByLocation',
            params: {locationId: selected.locationId}
        })
            .success(function (data, status, headers, config) {
                ctrl.allInventoryItemByLocation = data;
            })
        
    };

    var confirmItemIdForEachesMove = function(itemId, invStatusOpt){
        $http({
            method : 'GET',
            url : '/inventory/getAllInventoryStatusByItemAndLocation',
            params: {itemId: itemId, locationId:ctrl.eachesMove.fromLocation, invStatusOpt:invStatusOpt}
        })
            .success(function (data, status, headers, config) {
                if (invStatusOpt) {
                    ctrl.inventoryTotalQty = data;
                    ctrl.disableAllMoveEach = true;
                }
                else{
                    ctrl.disableItemSelection = true;
                    ctrl.allInventoryStatusData = data;
                }
                
            })
        
    };

    ctrl.movePalletPrompt = false;
    //loadLocationAutoComplete();
    //loadPalletAutoComplete();
    //loadCaseAutoComplete();
    ctrl.movePalletToLocation = movePalletToLocation;
    ctrl.moveEntireLocation = moveEntireLocation;
    ctrl.moveCaseToPalletOrLocation = moveCaseToPalletOrLocation;
    ctrl.showMessagesForLocationMove = showMessagesForLocationMove;
    ctrl.callLocationForinventory = callLocationForinventory;
    ctrl.confirmItemIdForEachesMove = confirmItemIdForEachesMove;
    ctrl.moveEachesToLocation = moveEachesToLocation;
    ctrl.hasErrorClass = hasErrorClass;
    ctrl.disabledBtnMovePallet = true;
    ctrl.disabledBtnMoveCase = true;



}])

//uppercase from lpn
    .directive('capitalize', function() {
        return {
            require: 'ngModel',
            link: function(scope, element, attrs, modelCtrl) {
                var capitalize = function(inputValue) {
                    if(inputValue == undefined) inputValue = '';
                    var capitalized = inputValue.toUpperCase();
                    if(capitalized !== inputValue) {
                        modelCtrl.$setViewValue(capitalized);
                        modelCtrl.$render();
                    }
                    return capitalized;
                }
                modelCtrl.$parsers.push(capitalize);
                capitalize(scope[attrs.ngModel]);  // capitalize initial value
            }
        };
    })


;
