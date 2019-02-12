/**
 * Created by User on 10/28/2015.
 */

var app = angular.module('adminInventory', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ui.grid.expandable', 'ui.grid.pagination' , 'ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ngSanitize','720kb.datepicker','ui.bootstrap', 'ngLocale', 'ui.grid.resizeColumns']);

app.controller('InventoryCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

    var myEl = angular.element( document.querySelector( '#liAdmin' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulAdmin' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'Inventory Adjustment';

    //Date Control

    $scope.inlineOptions = {
        customClass: getDayClass,
        minDate: new Date()
    };

    $scope.dateOptions = {
        formatYear: 'yy',
        maxDate: new Date(2020, 5, 22),
        minDate: new Date(),
        startingDay: 1,
        showWeeks: false
    };


    $scope.toggleMin = function() {
        $scope.inlineOptions.minDate = $scope.inlineOptions.minDate ? null : new Date();
        $scope.dateOptions.minDate = $scope.inlineOptions.minDate;
    };

    $scope.toggleMin();

    $scope.openExpirationDate = function() {
        $scope.popupExpirationDate.opened = true;
    };

    $scope.format = $locale.DATETIME_FORMATS.shortDate;
    $scope.altInputFormats = ['M!/d!/yyyy'];

    $scope.popupExpirationDate = {
        opened: false
    };



    function getDayClass(data) {
        var date = data.date,
            mode = data.mode;
        if (mode === 'day') {
            var dayToCheck = new Date(date).setHours(0,0,0,0);

            for (var i = 0; i < $scope.events.length; i++) {
                var currentDay = new Date($scope.events[i].date).setHours(0,0,0,0);

                if (dayToCheck === currentDay) {
                    return $scope.events[i].status;
                }
            }
        }

        return '';
    }

//Date Control

//***********start Inventory create****************************

    //Get all list values
    var getAllListValues = function () {
        $http({
            method: 'GET',
            url: '/item/getAllValuesByCompanyIdAndGroup',
            params : {group: 'ADJREASON'}
        })
            .success(function (data, status, headers, config) {
                //var noneOption = [{optionValue: ''}];
                //ctrl.listValue = noneOption.concat(data);
                ctrl.listValue = data;
            })
    };

    var getAllListValueInventoryStatus = function () {
        $http({
            method: 'GET',
            url: '/order/getAllValuesByCompanyIdAndGroup',
            params : {group: 'INVSTATUS'}
        })
            .success(function (data, status, headers, config) {
                ctrl.inventoryStatusOptions = data;
            })
    };    
    getAllListValueInventoryStatus();

    $scope.IsVisible = false;
    $scope.ShowHide = function () {
        clearForm();
        $scope.IsVisible = $scope.IsVisible ? false : true;
        ctrl.showSubmittedPrompt = false;

        //loadItemAutoComplete();
        ctrl.caseTracked1 = true;
        ctrl.lotCodeTracked1 = true;
        ctrl.isExpired1 = true;
        ctrl.lowestUomEach = true;
        if (ctrl.listValue[0]) {
            ctrl.newInventory.reasonCode = ctrl.listValue[0].description;
        }
        if (ctrl.inventoryStatusOptions[0]) {
            ctrl.newInventory.inventoryStatus = ctrl.inventoryStatusOptions[0].optionValue;  
        }
        ctrl.inventorySaveBtnText = 'Save';
        ctrl.caseInventorySaveBtnText = 'Save & Add';
        ctrl.binLocationSelected = false;
    };

    var ctrl = this,
        newInventory = {itemId:'', palletId:'', locationId:'',quantity:'', handlingUom:'', lotCode:'', expirationDate:'', inventoryStatus:'', reasonCode:'', caseId:'', itemNote:''};
    getAllListValues();


    ctrl.callSelectedLocation = function(locationData){
        if (locationData.is_bin) {
            //$('#binAreaSelectWarning').appendTo('body').modal('show');
            ctrl.binLocationSelected = true;

            if(ctrl.itemDataRow.lowestUom == 'PALLET'){
                ctrl.newInventory.locationId = null;
                $('#lowestUOMPalletToBin').appendTo('body').modal('show');
            }
            else if(ctrl.itemDataRow.isCaseTracked === true){
                ctrl.newInventory.locationId = null;
                $('#caseToBin').appendTo('body').modal('show');
            }
            else{
                $('#binAreaSelectWarning').appendTo('body').modal('show');
                ctrl.newInventory.palletId = '';    
                ctrl.newInventory.caseId = ''; 
            }

        }
        else{
           ctrl.binLocationSelected = false; 
        }
    };


    var createInventory = function () {

        if (ctrl.binLocationSelected) {
            if(ctrl.itemDataRow.isCaseTracked === true){
                $('#caseToBin').appendTo('body').modal('show');
                ctrl.createInventoryForm.$valid = false;
            }
            else if (ctrl.itemDataRow.lowestUom === 'CASE') {
                $('#lowestUOMCaseToBin').appendTo('body').modal('show');
                ctrl.createInventoryForm.$valid = false;
            }
            else if (ctrl.itemDataRow.lowestUom === 'PALLET') {
                $('#lowestUOMPalletToBin').appendTo('body').modal('show');
                ctrl.createInventoryForm.$valid = false;
            }
            else{
                if (ctrl.newInventory.handlingUom.toUpperCase() === 'CASE') {
                    ctrl.newInventory.quantity = parseInt(ctrl.newInventory.quantity) * ctrl.itemDataRow.eachesPerCase;
                    ctrl.newInventory.handlingUom = 'EACH';    
                    ctrl.newInventory.palletId = '';    
                    ctrl.newInventory.caseId = '';            
                }

            }
        }

        if(!ctrl.addInventoryCaseIdDisabled && !ctrl.binLocationSelected){
            createCaseInventory(ctrl.newInventory.caseId);            
        }

        else{

            $scope.location_id = ctrl.newInventory.locationId;
            $scope.pallet_id = ctrl.newInventory.palletId;
            $scope.case_id = ctrl.newInventory.caseId;
            $scope.item_id = ctrl.newInventory.itemId;
            $scope.item_description = ctrl.itemDescription;
            $scope.quantity = ctrl.newInventory.quantity;
            $scope.handling_uom = ctrl.newInventory.handlingUom;

            if( ctrl.createInventoryForm.$valid) {
                ctrl.disableInventorySave = true;
                ctrl.inventorySaveBtnText = 'Saving..';
                ctrl.caseInventorySaveBtnText = 'Saving...';

                $http({
                    method  : 'POST',
                    url     : '/inventory/inventorySave',
                    data    :  $scope.ctrl.newInventory,
                    dataType: 'json',
                    headers : { 'Content-Type': 'application/json; charset=utf-8' }
                })
                    .success(function(data) {
                        $scope.IsVisible = false;
                        ctrl.showSubmittedPrompt = true;

                        if (ctrl.isShowInventorySumGrid) {
                            getSearchResultsForViewSummary();      
                        }
                        else{
                            $http({
                                method: 'GET',
                                url: '/inventory/getInventoryDataByIdAndCompany',
                                params : {inventoryId : data.inventoryId}
                            })

                                .success(function(data) {
                                    //$scope.gridItem.data = data;

                                    $scope.gridItem.data.push(data[0]);


                                });                            
                        }



                        clearForm();
                        ctrl.showOrderCreatedPrompt = true;
                        $timeout(function(){
                            ctrl.showSubmittedPrompt = false;
                        }, 4200);
                    })
                    .finally(function () {
                        ctrl.disableInventorySave = false;
                        ctrl.inventorySaveBtnText = 'Save';
                        ctrl.caseInventorySaveBtnText = 'Save & Add';
                    });

            }
        }


    };

    var createCaseInventory = function (viewValue) {

        ctrl.validateCaseRequired = true;
        $http({
            method : 'GET',
            url : '/inventory/validateCase',
            params: {caseId: viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){

                    ctrl.createInventoryForm.caseId.$setValidity('caseIdExist', true);
                    ctrl.createInventoryForm.caseId.$setValidity('checkSimilarCaseAndPallet', true);
                    if (ctrl.newInventory.palletId && ctrl.newInventory.caseId && (ctrl.newInventory.palletId == ctrl.newInventory.caseId)) {
                        ctrl.createInventoryForm.caseId.$setValidity('checkSimilarCaseAndPallet', false);
                    }
                    else{

                        $scope.location_id = ctrl.newInventory.locationId;
                        $scope.pallet_id = ctrl.newInventory.palletId;
                        $scope.case_id = ctrl.newInventory.caseId;
                        $scope.item_id = ctrl.newInventory.itemId;
                        $scope.item_description = ctrl.itemDescription;
                        $scope.quantity = ctrl.newInventory.quantity;
                        $scope.handling_uom = ctrl.newInventory.handlingUom;

                        if( ctrl.createInventoryForm.$valid) {

                            ctrl.disableInventorySave = true;
                            ctrl.inventorySaveBtnText = 'Saving..';
                            ctrl.caseInventorySaveBtnText = 'Saving...';

                            $http({
                                method  : 'POST',
                                url     : '/inventory/inventorySave',
                                data    :  $scope.ctrl.newInventory,
                                dataType: 'json',
                                headers : { 'Content-Type': 'application/json; charset=utf-8' }
                            })
                                .success(function(data) {
                                    $scope.IsVisible = false;
                                    ctrl.showSubmittedPrompt = true;

                                    if (ctrl.isShowInventorySumGrid) {
                                        getSearchResultsForViewSummary();      
                                    }
                                    else{
                                        $http({
                                            method: 'GET',
                                            url: '/inventory/getInventoryByInventoryId',
                                            params : {palletId: $scope.pallet_id, caseId:$scope.case_id}
                                        })

                                            .success(function(data) {
                                                //$scope.gridItem.data = data;

                                                $scope.gridItem.data.push(data[0]);


                                            });                                        
                                    }



                                    clearForm();
                                    ctrl.showOrderCreatedPrompt = true;
                                    $timeout(function(){
                                        ctrl.showSubmittedPrompt = false;
                                    }, 4200);
                                })
                                .finally(function () {
                                    ctrl.disableInventorySave = false;
                                    ctrl.inventorySaveBtnText = 'Save';
                                    ctrl.caseInventorySaveBtnText = 'Save & Add';
                                });

                        }
                    }

                }
                else
                {
                    ctrl.createInventoryForm.caseId.$setValidity('caseIdExist', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.createInventoryForm.caseId.$setValidity('caseIdExist', false);
            });

    }

    var caseSubmitForm = function(){

        $scope.location_id = ctrl.newInventory.locationId;
        $scope.pallet_id = ctrl.newInventory.palletId;
        $scope.case_id = ctrl.newInventory.caseId;
        $scope.item_id = ctrl.newInventory.itemId;
        $scope.item_description = ctrl.itemDescription;
        $scope.quantity = ctrl.newInventory.quantity;
        $scope.handling_uom = ctrl.newInventory.handlingUom;

        if( ctrl.createInventoryForm.$valid) {
            ctrl.disableInventorySave = true;
            ctrl.caseInventorySaveBtnText = 'Saving...';
            ctrl.inventorySaveBtnText = 'Saving..';

            $http({
                method  : 'POST',
                url     : '/inventory/inventorySave',
                data    :  $scope.ctrl.newInventory,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.showSubmittedPrompt = true;
                    ctrl.newInventory.caseId = '';
                    ctrl.newInventory.itemNote = null;
                    $scope.IsVisible = true;
                    ctrl.validateCaseRequired = false;

                    $http({
                        method: 'GET',
                        url: '/inventory/getInventoryByInventoryId',
                        params : {palletId: $scope.pallet_id, caseId:$scope.case_id}
                    })

                        .success(function(data) {
                            //$scope.gridItem.data = data;

                            $scope.gridItem.data.push(data[0]);


                        });
                    ctrl.showOrderCreatedPrompt = true;
                    $timeout(function(){
                        ctrl.showSubmittedPrompt = false;
                    }, 4200);

                })
                 .finally(function () {
                  ctrl.disableInventorySave = false;
                  ctrl.caseInventorySaveBtnText = 'Save & Add';
                  ctrl.inventorySaveBtnText = 'Save';
                     document.getElementById('caseId').focus()
                });

        }

    };

    ctrl.caseSubmitForm = caseSubmitForm;


    var clearForm = function () {
        ctrl.newInventory = {itemId:'', palletId:'', locationId:'',quantity:'', handlingUom:'', lotCode:'', expirationDate:'', inventoryStatus:'', reasonCode:'', caseId:'', itemNote:''};
        ctrl.createInventoryForm.$setUntouched();
        ctrl.createInventoryForm.$setPristine();
        ctrl.disableHandlingUom = false;
        ctrl.addInventoryQtyDisabled = false;
        $scope.data = {
            availableOptions: [
                {id: 'EACH', name: 'EACH'},
                {id: 'CASE', name: 'CASE'}
            ]
        };        

    };

    var hasErrorClass = function (field) {
        return ctrl.createInventoryForm[field].$touched && ctrl.createInventoryForm[field].$invalid;
    };

    var showMessages = function (field) {
        return ctrl.createInventoryForm[field].$touched || ctrl.createInventoryForm.$submitted;
    };

    var toggleInventoryIdPrompt = function (value) {
        ctrl.showInventoryIdPrompt = value;
    };
    var toggleItemIdPrompt = function (value) {
        ctrl.showItemIdPrompt = value;
    };
    var toggleAssociatedLpnPrompt = function (value) {
        ctrl.showAssociatedLpnPrompt = value;
    };
    var toggleLocationIdPrompt = function (value) {
        ctrl.showLocationIdPrompt = value;
    };
    var toggleQuantityPrompt = function (value) {
        ctrl.showQuantityPrompt = value;
    };
    var toggleHandlingUomPrompt = function (value) {
        ctrl.showHandlingUomPrompt = value;
    };
    var toggleLotCodePrompt = function (value) {
        ctrl.showLotCodePrompt = value;
    };
    var toggleExpirationDatePrompt = function (value) {
        ctrl.showExpirationDatePrompt = value;
    };
    var toggleInventoryStatusPrompt = function (value) {
        ctrl.showInventoryStatusPrompt = value;
    };


    ctrl.showInventoryIdPrompt = false;
    ctrl.showItemIdPrompt = false;
    ctrl.showAssociatedLpnPrompt = false;
    ctrl.showLocationIdPrompt = false;
    ctrl.showQuantityPrompt = false;
    ctrl.showHandlingUomPrompt = false;
    ctrl.showLotCodePrompt = false;
    ctrl.showExpirationDatePrompt = false;
    ctrl.showInventoryStatusPrompt = false;


    ctrl.toggleInventoryIdPrompt = toggleInventoryIdPrompt;
    ctrl.toggleItemIdPrompt = toggleItemIdPrompt;
    ctrl.toggleAssociatedLpnPrompt = toggleAssociatedLpnPrompt;
    ctrl.toggleLocationIdPrompt = toggleLocationIdPrompt;
    ctrl.toggleQuantityPrompt = toggleQuantityPrompt;
    ctrl.toggleHandlingUomPrompt = toggleHandlingUomPrompt;
    ctrl.toggleLotCodePrompt = toggleLotCodePrompt;
    ctrl.toggleExpirationDatePrompt = toggleExpirationDatePrompt;
    ctrl.toggleInventoryStatusPrompt = toggleInventoryStatusPrompt;


    ctrl.hasErrorClass = hasErrorClass;
    ctrl.showMessages = showMessages;
    ctrl.newInventory = newInventory;
    ctrl.createInventory = createInventory;
    ctrl.clearForm = clearForm;



    var validateItemId = function(itemId,index){
                ctrl.newInventory.handlingUom ='';
        checkIsCaseTracked1(itemId,index);

    };
    ctrl.validateItemId = validateItemId;


    var loadLocationAutoComplete1 = function () {
        $http.get('/location/getCompanyAllLocations')
            .success(function(data) {
                $scope.sourceLocation = data;

            });
    };

    $scope.loadLocationAutoComplete = function (value) {
       //return $http.get('/location/getCompanyAllLocations')
        return $http({
            method: 'GET',
            url: '/location/getCompanyAllLocations',
            params : {keyword: value.keyword}
        });       
    };

    $scope.loadUnblockedLocationAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/location/getCompanyAllUnblockedLocations',
            params : {keyword: value.keyword}
        });
    } 

    $scope.sourceItems = function (value) {

        return $http({
            method: 'GET',
            url: '/item/getItems',
            params : {keyword: value.keyword}
        });    

        // $http.get('/item/getItems')
        //     .success(function(data) {
        //         $scope.sourceItems = data;
        //     });
    };


    $scope.sourcePallets = function (value) {

        return $http({
            method: 'GET',
            url: '/inventory/getPallets',
            params : {keyword: value.keyword}
        });    

        // $http.get('/inventory/getPallets')
        //     .success(function(data) {
        //         $scope.sourcePallets = data;
        //     });
    };


    // $scope.$watch('ctrl.newInventory.palletId', function(userSearch) {
    //     if (userSearch) {
    //         $http({
    //             method: 'GET',
    //             url: '/inventory/getPalletsByLocationAndItem',
    //             params : {keyword: userSearch, locationId:ctrl.newInventory.locationId, itemId:ctrl.newInventory.itemId}
    //         })
    //         .success(function(data) {
    //             $scope.loadPallets = data;
    //         });
    //     }
    // });

    $scope.getPalletsByLocationAndItem = function(){
            $http({
                method: 'GET',
                url: '/inventory/getPalletsByLocationAndItem',
                params : {locationId:ctrl.newInventory.locationId, itemId:ctrl.newInventory.itemId}
            })
            .success(function(data) {
                $scope.loadPallets = data;
            });
    };

    $scope.sourceCases = function (value) {

        return $http({
            method: 'GET',
            url: '/inventory/getCases',
            params : {keyword: value.keyword}
        });            
        // $http.get('/inventory/getCases')
        //     .success(function(data) {
        //         $scope.sourceCases = data;
        //     });
    };


    //$scope.callback2 = function(selected) {
    //    ctrl.disabledFind = ctrl.newInventory.locationId || selected ? false : true;
    //
    //};

    ctrl.selectCase = function(){
        if (ctrl.itemDataRow.isCaseTracked) {
            if ((ctrl.newInventory.handlingUom).toUpperCase() == 'CASE') {
                ctrl.newInventory.quantity = 1;
                ctrl.addInventoryQtyDisabled = true;
            }
            else{
                ctrl.newInventory.quantity = '';
                ctrl.addInventoryQtyDisabled = false;
            }
        }
    };

    var checkIsCaseTracked1 = function(itemId){
        $http({
            method: 'GET',
            url: '/inventory/findItem',
            params : {itemId: itemId}
        })

            .success(function (data, status, headers, config) {

                if(data.length > 0){
                    ctrl.itemDataRow = data[0];
                    ctrl.addInventoryExpireDateDisabled = !data[0].isExpired;
                    ctrl.addInventoryLotCodeDisabled = !data[0].isLotTracked;
                    //ctrl.newInventory.itemNote = '';

                    if(data[0].isCaseTracked){
                        if(data[0].lowestUom.toUpperCase() == 'EACH'){
                            ctrl.disableHandlingUom = false;
                            $scope.data = {
                                availableOptions: [
                                    {id: 'EACH', name: 'EACH'},
                                    {id: 'CASE', name: 'CASE'}
                                ]
                            };
                            ctrl.newInventory.quantity = '';
                            ctrl.addInventoryQtyDisabled = false;
                            ctrl.newInventory.caseId = "";
                            ctrl.addInventoryCaseIdDisabled = false;
                            ctrl.addInventoryCaseIdSubmit = true;
                            ctrl.newInventory.handlingUom ='';
                        }
                        else{
                            ctrl.disableHandlingUom = true;
                            $scope.data = {
                                availableOptions: [
                                    {id: 'CASE', name: 'CASE'}
                                ]
                            };
                            ctrl.newInventory.quantity = 1;
                            ctrl.addInventoryQtyDisabled = true;
                            ctrl.newInventory.caseId = "";
                            ctrl.addInventoryCaseIdDisabled = false;
                            ctrl.addInventoryCaseIdSubmit = true;
                            ctrl.newInventory.handlingUom ='CASE';
                        }

                    }else{

                        if(data[0].lowestUom.toUpperCase() == 'EACH'){
                            $scope.data = {
                                availableOptions: [
                                    {id: 'EACH', name: 'EACH'},
                                    {id: 'CASE', name: 'CASE'}
                                ]
                            };


                            ctrl.disableHandlingUom = false;
                            ctrl.newInventory.quantity ='';
                            ctrl.addInventoryCaseIdDisabled = true;
                            ctrl.addInventoryQtyDisabled = false;
                            ctrl.addInventoryCaseIdSubmit = false;
                            //ctrl.showLowestUomEachOpt = true;
                        }else if(data[0].lowestUom.toUpperCase() == 'CASE'){
                            //ctrl.newInventory.handlingUom = "klklklkmlk";
                            ctrl.showLowestUomEachOpt = false;
                            $scope.data = {
                                availableOptions: [
                                    {id: 'CASE', name: 'CASE'}
                                ]
                            };
                            ctrl.newInventory.handlingUom = 'CASE';


                            ctrl.newInventory.quantity ='';
                            ctrl.addInventoryCaseIdDisabled = true;
                            ctrl.addInventoryQtyDisabled = false;
                            ctrl.addInventoryCaseIdSubmit = false;
                        }
                        else{
                            ctrl.disableHandlingUom = true;
                            $scope.data = {
                                availableOptions: [
                                    {id: 'PALLET', name: 'PALLET'}
                                ]
                            };
                            ctrl.newInventory.quantity = 1;
                            ctrl.addInventoryQtyDisabled = true;
                            ctrl.newInventory.caseId = "";
                            ctrl.addInventoryCaseIdDisabled = true;
                            ctrl.addInventoryCaseIdSubmit = false;
                            ctrl.newInventory.handlingUom ='PALLET';
                        }
                    }

                    if(data[0].itemDescription){
                        ctrl.itemDescription = data[0].itemDescription;

                    }
                    else{
                        ctrl.itemDescription = '';
                    }

                }

            })

    };


    var selectItem = function(){
        checkIsCaseTracked1(ctrl.newInventory.itemId);
    };

    

    var getPalletsByLocation = function(locationId){

        $http({
           method: 'GET',
           url: '/inventory/getPalletsByLocation',
           params : {locationId: locationId}
       })
    
        .success(function (data, status, headers, config) {
            $scope.sourcePallets = data;
    
        })

    }

    var getCasesByLocation = function(locationId){

        $http({
           method: 'GET',
           url: '/inventory/getCasesByLocation',
           params : {locationId: locationId}
       })
    
        .success(function (data, status, headers, config) {
            $scope.sourceCases = data;
    
        })

    }


    var selectLocation = function(locationId){
        getPalletsByLocation(locationId);
        getCasesByLocation(locationId);
    };

    var getCasesByPallet = function(palletId){

        $http({
           method: 'GET',
           url: '/inventory/getCasesByPallet',
           params : {palletId: palletId}
       })
    
        .success(function (data, status, headers, config) {
            $scope.sourceCases = data;
    
        })


    };


    ctrl.selectItem = selectItem;
    ctrl.selectLocation = selectLocation;
    ctrl.getCasesByPallet = getCasesByPallet;

    // loadLocationAutoComplete1();
    // loadPalletAutoComplete();
    // loadCaseAutoComplete();


    // function to create new reason

    ctrl.addNewValue = function(){ // display the model

        if (ctrl.newInventory.reasonCode == 'newItemCategory') {
            $('#AddNewItemCategory').appendTo("body").modal('show');
        };

    };



// function to save new reason
    $("#itemCategorySave").click(function(){

        if (ctrl.addItemCategory) {
            $http({
                method  : 'POST',
                url     : '/inventory/addReasonCode',
                data    :  {optionGroup:'ADJREASON', description:ctrl.addItemCategory},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    getAllListValues();
                    ctrl.newInventory.reasonCode = ctrl.addItemCategory;
                    ctrl.addItemCategory ="";
                    $('#AddNewItemCategory').modal('hide');


                })
        };
    });


    $("#itemCategorycancelSave").click(function(){
        ctrl.newInventory.reasonCode = '';
        ctrl.addItemCategory ="";
    });

//***************end Inventory create*************************************


    //*************** Start of Find Inventory ***************

    $scope.loadLocationAutoComplete = function (value) {
       //return $http.get('/location/getCompanyAllLocations')
        return $http({
            method: 'GET',
            url: '/location/getCompanyAllLocations',
            params : {keyword: value.keyword}
        });       
    };

    // $scope.$watch('ctrl.findInventory.location', function(UserSearch) {
    //     if (UserSearch && UserSearch.length > 2) {
    //         $http.get('/location/getCompanyAllLocations').success(function(data) {
    //             $scope.source3 = data;
    //         });
    //     }
    // });

    //
    //var disableFindButton = function () {
    //    ctrl.disabledFind = ctrl.findInventory.lpn || ctrl.findInventory.location ? false : true;
    //};

    //$scope.callback = function(selected) {
    //    ctrl.disabledFind = selected || ctrl.findInventory.lpn ? false : true;
    //};

    //$scope.callback1 = function(selected) {
    //    ctrl.disabledFind = selected || ctrl.findInventory.location ? false : true;
    //
    //};

    var clearAutoCompText = function(){
        ctrl.findInventory.location = '';
        //ctrl.disabledFind = ctrl.findInventory.lpn || ctrl.findInventory.location ? false : true;
    };

    ctrl.findInventory = {};
    var inventorySearch = function () {

        if (ctrl.isShowInventorySumGrid) {
            getSearchResultsForViewSummary();      
        }
        else{
            $http({
                method: 'POST',
                url: '/inventory/adminSearch',
                params: {lpn:ctrl.findInventory.lpn,
                    location: ctrl.findInventory.location,
                    area: ctrl.findInventory.area,
                    item: ctrl.findInventory.item},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    //$scope.gridItem.data = data;
                    $scope.gridItem.data = data.splice(0,10000);

                })
        }
    };

    //loadLocationAutoComplete();
    //ctrl.disabledFind = true;
    //ctrl.disableFindButton = disableFindButton;
    ctrl.inventorySearch = inventorySearch;
    ctrl.clearAutoCompText = clearAutoCompText;

    var loadGridData = function (){
        $http({
            method: 'POST',
            url: '/inventory/adminSearch',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridItem.data = data.splice(0,10000);

            })
    };
    loadGridData();

    //Start Inventory grid
    $scope.gridItem = {
        enableRowSelection: true,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
        exporterPdfHeader: { text: headerTitle, style: 'headerStyle' },
        exporterPdfFooter: function ( currentPage, pageCount ) {
            return { text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle' };
        },
        exporterPdfCustomFormatter: function ( docDefinition ) {
            docDefinition.styles.headerStyle = { fontSize: 15, bold: true, margin: 20};
            //docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
            return docDefinition;
        },
        exporterPdfOrientation: 'portrait',
        exporterPdfPageSize: 'LETTER',
        exporterPdfMaxGridWidth: 500,

        columnDefs: [
            {name:'Area', field: 'grid_area_id'},
            {name:'Location', field: 'location_id'},
            {name:'Pallet Id', field: 'pallet_id'},
            {name:'Case Id', field: 'case_id'},
            {name:'Item Id', field: 'item_id'},
            {name:'Description', field: 'item_description'},
            {name:'Quantity', field: 'quantity'},
            {name:'Handling UOM', field: 'handling_uom'},
            {name:'Inventory Status', field: 'inventory_status'},
            {name:'Notes', cellTemplate: '<span><a href="javascript:void(0)" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;" popover-trigger="outsideClick" ng-show="row.entity.notes" uib-popover="{{row.entity.notes}}" popover-title="Notes :" popover-append-to-body="true" >Notes</a></span>'},
            {name:'Actions', enableSorting: false,  cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.EditInventory(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.DeleteInventory(row)">Delete</a></li></ul></div>'}

        ],
        onRegisterApi: function( gridApi ){

            $scope.gridApi = gridApi;

            // interval of zero just to allow the directive to have initialized
            $interval( function() {
                gridApi.core.addToGridMenu( gridApi.grid, [{ title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged( $scope, function( changedColumn ){
                $scope.columnChanged = { name: changedColumn.colDef.name, visible: changedColumn.colDef.visible };
            });
        }
    };

    //End Inventory grid

    //*************** End of Find Inventory ***************



  //*************start inventory edit function******************

    var getPalletsAutoComplete = function () {
        $http.get('/inventory/getPallets')
            .success(function(data) {
                $scope.palletsAutoComplete = data;
            });
    };

    var getCasesAutoComplete = function () {
        $http.get('/inventory/getCases')
            .success(function(data) {
                $scope.casesAutoComplete = data;
            });
    };

    var checkIsCaseTracked = function(itemId){

        $http({
            method: 'GET',
            url: '/inventory/findItem',
            params : {itemId: itemId}
        })

            .success(function (data, status, headers, config) {

                if(data.length > 0){

                    if(data[0].isCaseTracked){
                        ctrl.caseTracked = true;
                        if(data[0].lowestUom.toUpperCase() == 'EACH'){
                            if (ctrl.editInventory.handlingUom.toUpperCase() == 'EACH') {
                                ctrl.editInventoryQtyDisabled = false;
                            }
                            else{
                                ctrl.editInventoryQtyDisabled = true;
                                ctrl.editInventory.quantity = 1;
                            }
                        }
                        else{
                            ctrl.editInventory.quantity = 1;
                            ctrl.editInventoryQtyDisabled = true;
                        }

                    }else{
                        ctrl.caseTracked = false;
                        ctrl.editInventoryQtyDisabled = false;
                        if(data[0].lowestUom.toUpperCase() == 'CASE'){
                            ctrl.editInventory.handlingUom = 'CASE';
                        }
                        else if(data[0].lowestUom.toUpperCase() == 'PALLET'){

                            ctrl.editInventory.quantity = 1;
                            ctrl.editInventoryQtyDisabled = true;
                        }
                    }


                }

            })

    };


    var checkIsLotCodeTracked = function(itemId){

                $http({
                method: 'GET',
                url: '/inventory/checkIsLotCodeTrackedOfItem',
                params : {itemId: itemId}
                })

                .success(function (data, status, headers, config) {
                    ctrl.checkIsLotCodeTracked = data;    

                    if (ctrl.checkIsLotCodeTracked.length > 0) {
                        ctrl.lotCodeTracked = true;
                        ctrl.editInventory.lotCode = row.entity.lot_code;

                    }
                    else{
                        ctrl.lotCodeTracked = false;
                    
                     }


                })   

    };


    var checkIsExpired = function(itemId){

                $http({
                method: 'GET',
                url: '/inventory/checkIsExpiredOfItem',
                params : {itemId: itemId}
                })

                .success(function (data, status, headers, config) {
                    ctrl.checkIsLotCodeTracked = data;    

                    if (ctrl.checkIsLotCodeTracked.length > 0) {
                        ctrl.isExpired = true;
                        ctrl.editInventory.expirationDate = row.entity.expiration_date;

                    }
                    else{
                        ctrl.isExpired = false;
                    
                     }


                })   

    };    


    $scope.HideEditForm = function () {
        clearFormEdit();
        ctrl.editInventoryState = false;
        //ctrl.showUpdatedPrompt = false;
    };


    getPalletsAutoComplete();
    getCasesAutoComplete();

    var ctrl = this,
        editInventory = {inventoryId:'', itemId:'',locationId:'', palletId:'', caseId:'', quantity:'', handlingUom:'', lotCode:'', inventoryStatus:'', expirationDate:'', reasonCode:'', adjustmentDescription:'', preQuantity:'', preInventoryStatus:'', preLotCode:'', preExpiration_date:'', itemNote:'' };


    $scope.EditInventory = function(row) {

        $http({
            method: 'GET',
            url: '/inventory/checkInventoryLocationForDelete',
            params : {locationId: row.entity.location_id}
        })

        .success(function (data, status, headers, config) {
            if (data[0].is_staging == true) {
                $('#inventoryEditWarningForStaging').appendTo("body").modal('show');
            }
            else if (data[0].is_pnd == true && row.entity.work_reference_number != null) {
                $('#inventoryEditWarningForPnd').appendTo("body").modal('show');
            }
            else{
                //Check Current User
                $http.get('/user/getCurrentUser')
                    .success(function(data) {

                     
                        checkIsCaseTracked(row.entity.item_id);
                        checkIsLotCodeTracked(row.entity.item_id);
                        checkIsExpired(row.entity.item_id);

                        ctrl.editInventoryState = true;
                        ctrl.showAdjustedPrompt = false;
                        ctrl.showInventoryDeletedPrompt = false;
                        //$scope.IsVisible = true;
                        ctrl.editInventory.itemId = row.entity.item_id;
                        ctrl.editInventory.locationId = row.entity.location_id;
                        ctrl.editInventory.palletId = row.entity.pallet_id;
                        ctrl.editInventory.caseId = row.entity.case_id;
                        ctrl.editInventory.quantity = row.entity.quantity;
                        ctrl.editInventory.preQuantity = row.entity.quantity;
                        ctrl.editInventory.handlingUom = row.entity.handling_uom;             
                        ctrl.editInventory.inventoryStatus = row.entity.inventory_status_option_value;
                        ctrl.editInventory.preInventoryStatus = row.entity.inventory_status_option_value;
                        ctrl.editInventory.lotCode = row.entity.lot_code;
                        ctrl.editInventory.preLotCode = row.entity.lot_code;

                        //ctrl.editInventory.expirationDate = new Date(row.entity.expiration_date);
                        ctrl.editInventory.expirationDate = row.entity.expiration_date == null ? null : new Date(row.entity.expiration_date);
                        ctrl.editInventory.preExpirationDate = row.entity.expiration_date;
                        ctrl.editInventory.inventoryId = row.entity.inventory_id;
                        ctrl.editInventory.itemNote = row.entity.notes;
                        alert(row.entity.notes);
                        //ctrl.editInventory.reasonCode = row.entity.reason_code;
                        if (ctrl.listValue[0]) {
                            ctrl.editInventory.reasonCode = ctrl.listValue[0].description;
                        }
                        ctrl.inventoryUpdateBtnText = 'Update';
                                
                        
                });         
            }

        }) 

    };


    var editInventoryFunction = function () {

        if (ctrl.editInventory.lotCode =='') {
            ctrl.editInventory.lotCode = null;
        }

        if (ctrl.editInventory.expirationDate =='') {
            ctrl.editInventory.expirationDate = null;
        }

        if (ctrl.editInventory.adjustmentDescription =='') {
            ctrl.editInventory.adjustmentDescription = null;
        }  


        if (ctrl.editInventory.reasonCode == '') {
           ctrl.editInventoryForm.$valid = false;
        }

        if (ctrl.editInventory.inventoryStatus == '') {
            ctrl.editInventoryForm.$valid = false;
        }


        if( ctrl.editInventoryForm.$valid) {

          ctrl.disableInventoryEdit = true;
          ctrl.inventoryUpdateBtnText = 'Updating..';

        $http({
            method  : 'POST',
            url     : '/inventory/inventoryEditAndAdjustment',
            data    :  $scope.ctrl.editInventory,
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }

        })
            .success(function (data, status, headers, config) {


                $http({
                    method: 'GET',
                    url: '/inventory/getInventoryByInventoryId',
                    params : {palletId: ctrl.editInventory.palletId, caseId:ctrl.editInventory.caseId}
                })

                    .success(function(data) {
                         $scope.gridItem.data = data;
                    });

                ctrl.editInventoryState = false;
                clearFormEdit();
                ctrl.showAdjustedPrompt = true;
                $timeout(function(){
                    ctrl.showAdjustedPrompt = false;
                }, 4200);                   

            })
            .finally(function () {
              ctrl.disableInventoryEdit = false;
              ctrl.inventoryUpdateBtnText = 'Update';
            });            

        }
    };    

    


    var clearFormEdit = function () {
        ctrl.editInventory = {inventoryId:'', itemId:'',locationId:'', palletId:'', caseId:'', quantity:'', handlingUom:'', lotCode:'', inventoryStatus:'', expirationDate:'', reasonCode:'', adjustmentDescription:'', preQuantity:'', preInventoryStatus:'', preLotCode:'', preExpiration_date:''};     
        ctrl.editInventoryForm.$setUntouched();
        ctrl.editInventoryForm.$setPristine();           
    };



    var hasErrorClassEdit = function (field) {
        return ctrl.editInventoryForm[field].$touched && ctrl.editInventoryForm[field].$invalid;
    };

    var showMessagesEdit = function (field) {
        return ctrl.editInventoryForm[field].$touched || ctrl.editInventoryForm.$submitted;
    };



    var toggleEditQuantityPrompt = function (value) {
        ctrl.showEditQuantityPrompt = value;
    };
    var toggleEditInventoryStatusPrompt = function (value) {
        ctrl.showEditInventoryStatusPrompt = value;
    };
    var toggleEditLotCodePrompt = function (value) {
        ctrl.showEditLotCodePrompt = value;
    };
    var toggleEditExpirationDatePrompt = function (value) {
        ctrl.showEditExpirationDatePrompt = value;
    };
    var toggleEditAdjustmentDescriptionPrompt = function (value) {
        ctrl.showEditAdjustmentDescriptionPrompt = value;
    };    


    ctrl.showEditQuantityPrompt = false;
    ctrl.showEditInventoryStatusPrompt = false;
    ctrl.showEditLotCodePrompt = false;
    ctrl.showEditExpirationDatePrompt = false;
    ctrl.showEditAdjustmentDescriptionPrompt = false;
    ctrl.showAdjustedPrompt = false;




    ctrl.toggleEditQuantityPrompt = toggleEditQuantityPrompt;
    ctrl.toggleEditInventoryStatusPrompt = toggleEditInventoryStatusPrompt;
    ctrl.toggleEditLotCodePrompt = toggleEditLotCodePrompt;
    ctrl.toggleEditExpirationDatePrompt = toggleEditExpirationDatePrompt;
    ctrl.toggleEditAdjustmentDescriptionPrompt = toggleEditAdjustmentDescriptionPrompt;



    ctrl.hasErrorClassEdit = hasErrorClassEdit;
    ctrl.showMessagesEdit = showMessagesEdit;
    ctrl.editInventoryFunction = editInventoryFunction;
    ctrl.clearFormEdit = clearFormEdit;
    ctrl.editInventory = editInventory;


    // function to create new reason

    ctrl.addNewValueEdit = function(){ // display the model

        if (ctrl.editInventory.reasonCode == 'newReasonCode') {
            $('#addNewReasonCodeEdit').appendTo("body").modal('show');
        };

    };


// function to save new reason
    $("#reasonCodeSaveEdit").click(function(){

        if (ctrl.addReasonCodeEdit) {
            $http({
                method  : 'POST',
                url     : '/inventory/addReasonCode',
                data    :  {optionGroup:'ADJREASON', description:ctrl.addReasonCodeEdit},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    getAllListValues();
                    ctrl.editInventory.reasonCode = ctrl.addReasonCodeEdit;
                    ctrl.addReasonCodeEdit ="";
                    $('#addNewReasonCodeEdit').modal('hide');


                })
        }
    });


    $("#reasonCodecancelSaveEdit").click(function(){
        getAllListValues();
        ctrl.editInventory.reasonCode = '';
        ctrl.addReasonCodeEdit ="";
    });


  
    //**********end inventory edit****************************


  //*************start inventory Delete function******************

    ctrl.showInventoryDeletedPrompt = false;
    var rows = null;
    $scope.DeleteInventory = function(row) { //calling bootstrap confirm box. 
        ctrl.inventoryDeleteBtnText = 'Delete';
        $http({
            method: 'GET',
            url: '/inventory/checkInventoryLocationForDelete',
            params : {locationId: row.entity.location_id}
        })

        .success(function (data, status, headers, config) {
            if (data[0].is_staging == true) {
                $('#inventoryDeleteWarningForStaging').appendTo("body").modal('show');
            }
            else if (data[0].is_pnd == true && row.entity.work_reference_number != null) {
                $('#inventoryDeleteWarningForPnd').appendTo("body").modal('show');
            }
            else{
                ctrl.reasonDelete = 'noOption';
                $('#DeleteInventoryModal').appendTo("body").modal('show');
                rows = row;                
            }

        })    

    };//end of calling bootstrap confirm box.


     $("#deleteInventoryButton").click(function(){ //function to delete.
        rows.entity.reason_code = ctrl.reasonDelete;
        ctrl.dataForDeletion = rows.entity;
        ctrl.dataForDeletion.inventory_status = rows.entity.inventory_status_option_value;


        if (rows.entity.reason_code != 'noOption') {
            ctrl.disabledDelete = false;

            ctrl.disableInventoryDelete = true;
            ctrl.inventoryDeleteBtnText = 'Deleting..';

                $http({
                    method: 'POST',
                    url: '/inventory/deleteInventory',
                    data: ctrl.dataForDeletion,
                    dataType: 'json',
                    headers: {'Content-Type': 'application/json; charset=utf-8'} 
                })
                .success(function (data, status, headers, config) {
                   $('#DeleteInventoryModal').modal('hide'); 
                   ctrl.showInventoryDeletedPrompt = true;
                   var index = $scope.gridItem.data.indexOf(rows.entity);
                   $scope.gridItem.data.splice(index, 1);  
                   ctrl.reasonDelete = 'noOption';  
                    $timeout(function(){
                        ctrl.showInventoryDeletedPrompt = false;
                    }, 4200);                                                  
                })
                 .finally(function () {
                  ctrl.disableInventoryDelete = false;
                  ctrl.inventoryDeleteBtnText = 'Delete';
                });                 


            }
                    

        });//end of the delete function

     $("#cancelDelete").click(function(){
        ctrl.reasonDelete = 'noOption';
     });


  //*************End inventory Delete function******************

    var getSearchResultsForViewSummary = function(){
            $http({
                method: 'POST',
                url: '/inventory/search',
                params: {itemId:ctrl.findInventory.item,
                    lpn:ctrl.findInventory.lpn,
                    location: ctrl.findInventory.location,
                    areaId: ctrl.findInventory.area},

                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
            .success(function (data) {
                $scope.consolidatedInventory.data = data.splice(0,10000);
            })         
    }


    ctrl.switchToInventorySummary = function(){
        if (ctrl.isShowInventorySumGrid) {
            getSearchResultsForViewSummary();      
        }
        else{
            inventorySearch();
        }
    }


    //Start Inventory grid
    $scope.consolidatedInventory = {

        //This is the template that will be used to render subgrid.
        expandableRowTemplate: "<div ui-grid='row.entity.subGridOptions' style='height:150px;'></div>",
        //This will be the height of the subgrid
        expandableRowHeight: 150,

        enableRowSelection: true,
        enableRowHeaderSelection : false,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
        exporterPdfHeader: { text: headerTitle, style: 'headerStyle' },
        exporterPdfFooter: function ( currentPage, pageCount ) {
            return { text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle' };
        },
        exporterPdfCustomFormatter: function ( docDefinition ) {
            docDefinition.styles.headerStyle = { fontSize: 15, bold: true, margin: 20};
            //docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
            return docDefinition;
        },
        exporterPdfOrientation: 'portrait',
        exporterPdfPageSize: 'LETTER',
        exporterPdfMaxGridWidth: 500,

        columnDefs: [
            {name:'Area', field: 'grid_area_id'},
            {name:'Location', field: 'grid_location_id'},
            {name:'Pallet Id', field: 'grid_pallet_id'},
            {name:'Case Id', field: 'grid_case_id'},
            {name:'Item Id', field: 'grid_item_id'},
            {name:'Description', field: 'grid_item_description'},
            {name:'Status', field: 'grid_inventory_status'},
            {name:'Quantity', field: 'grid_quantity', type: 'number', },
            {name:'Unit Of Measure', field: 'grid_handling_uom', cellClass:'qtyNumberGrid'},
            {name:'Notes', cellTemplate: '<span><a href="javascript:void(0)" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;" popover-trigger="outsideClick" ng-show="row.entity.grid_notes" uib-popover="{{row.entity.grid_notes}}" popover-title="" popover-append-to-body="true" >Notes</a></span>'},

        ],

        exporterFieldCallback: function( grid, row, col, input ) {
          if( col.name == 'Notes' ){
            return row.entity.notes;
          }
          else{
            return input;
          }
        },

        onRegisterApi: function( gridApi ){
            $scope.gridApi = gridApi;

            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {

                if (row.isExpanded) {
                    row.entity.subGridOptions = {

                        columnDefs: [
                            {name:'Case Id', field: 'case_id'},
                            {name: 'Item Id', cellTemplate:'<a href="#" data-toggle="tooltip" title="Item: {{ row.entity.item_id}} \n Description: {{row.entity.item_description}} \n Category: {{row.entity.item_category}} \n Origin Code: {{row.entity.origin_code}} \n UPC Code: {{row.entity.upc_code}}"> {{row.entity.item_id}}</a>'},
                            {name:'Quantity', field: 'quantity'},
                            {name:'Unit Of Measure', field: 'handling_uom'},
                            {name:'Inventory Status', field: 'inventoryStatus'},
                            {name:'Notes', cellTemplate: '<span><a href="javascript:void(0)" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;" popover-trigger="outsideClick" ng-show="row.entity.notes" uib-popover="{{row.entity.notes}}" popover-title="" popover-append-to-body="true" >Notes</a></span>'},
                        ]};

                    $http({
                        method: 'GET',
                        url: '/inventory/getInventoryEntityAttributeForSearchRow',
                        params : {selectedRowPallet: row.entity.grid_pallet_id, selectedRowCase: row.entity.grid_case_id, itemId: row.entity.grid_item_id, inventoryStatus: row.entity.grid_inventory_status, handlingUOM: row.entity.grid_handling_uom}
                    })
                        .success(function(data) {

                            if(data.length > 0){
                                row.entity.subGridOptions.data = data;
                            }

                        });


                }
            });

            // interval of zero just to allow the directive to have initialized
            $interval( function() {
                gridApi.core.addToGridMenu( gridApi.grid, [{ title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged( $scope, function( changedColumn ){
                $scope.columnChanged = { name: changedColumn.colDef.name, visible: changedColumn.colDef.visible };
            });
        }
    };
    //End Inventory grid


    ctrl.validatePalletIdForItemAndLocation = function(viewValue){
        $http({
            method : 'GET',
            url : '/inventory/validatePalletIdByLocationAndItem',
            params: {palletId: viewValue, locationId:ctrl.newInventory.locationId, itemId:ctrl.newInventory.itemId}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    $http({
                        method : 'GET',
                        url : '/inventory/validatePalletIdExistForCase',
                        params: {palletId: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.createInventoryForm.caseTrackedPallet.$setValidity('palletIdExist', true);
                                ctrl.createInventoryForm.caseTrackedPallet.$setValidity('palletIdExistForLocationAndItem', true);
                            }
                            else
                            {
                                ctrl.createInventoryForm.caseTrackedPallet.$setValidity('palletIdExist', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.createInventoryForm.caseTrackedPallet.$setValidity('palletIdExist', false);
                        });
                }
                else
                {
                    ctrl.createInventoryForm.caseTrackedPallet.$setValidity('palletIdExistForLocationAndItem', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.createInventoryForm.caseTrackedPallet.$setValidity('palletIdExistForLocationAndItem', false);
            });
    };

    ctrl.validatePalletIdExist = function(viewValue){
        $http({
            method : 'GET',
            url : '/inventory/validatePallet',
            params: {palletId: viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    ctrl.createInventoryForm.caseUntrackedPallet.$setValidity('palletIdExist', true);
                }
                else
                {
                    ctrl.createInventoryForm.caseUntrackedPallet.$setValidity('palletIdExist', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.createInventoryForm.caseUntrackedPallet.$setValidity('palletIdExist', false);
            });
    };

    ctrl.validateCaseId = function(viewValue){

        ctrl.validateCaseRequired = true;

        $http({
            method : 'GET',
            url : '/inventory/validateCase',
            params: {caseId: viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    ctrl.createInventoryForm.caseId.$setValidity('caseIdExist', true);
                }
                else
                {
                    ctrl.createInventoryForm.caseId.$setValidity('caseIdExist', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.createInventoryForm.caseId.$setValidity('caseIdExist', false);
            });
    };

    ctrl.checkSimilarPalletAndCaseIds = function(){
        ctrl.createInventoryForm.caseId.$setValidity('checkSimilarCaseAndPallet', true);
        if (ctrl.newInventory.palletId && ctrl.newInventory.caseId) {
                if(ctrl.newInventory.palletId == ctrl.newInventory.caseId){
                    ctrl.createInventoryForm.caseId.$setValidity('checkSimilarCaseAndPallet', false);
                }
        }
    };    

// $scope.$watch('ctrl.newInventory.quantity', function(UserSearch) {
//     if (UserSearch) {
//         //alert('ergghjj');
//         console.log('hello');
//     }
// });

    $scope.$watchGroup(['ctrl.newInventory.palletId','ctrl.newInventory.caseId'],function(newVals,oldVals){
       if (ctrl.newInventory.palletId || ctrl.newInventory.caseId) {
            ctrl.newItemNotesVisible = true;
       }
       else{
            ctrl.newItemNotesVisible = false;
            ctrl.newInventory.itemNote = '';
       }

     });

    $scope.$watchGroup(['ctrl.editInventory.palletId','ctrl.editInventory.caseId'],function(newVals,oldVals){
       if (ctrl.editInventory.palletId || ctrl.editInventory.caseId) {
            ctrl.editItemNotesVisible = true;
       }
       else{
            ctrl.editItemNotesVisible = false;
       }

    });

}])

    //*****************start item validation******************************

    .directive('numbersOnly', function () {
        return {
            require: 'ngModel',
            link: function (scope, element, attr, ngModelCtrl) {
                function fromUser(text) {
                    if (text) {
                        var transformedInput = text.replace(/[^0-9]/g, '');

                        if (transformedInput !== text) {
                            ngModelCtrl.$setViewValue(transformedInput);
                            ngModelCtrl.$render();
                        }
                        return transformedInput;
                    }
                    return undefined;
                }
                ngModelCtrl.$parsers.push(fromUser);
            }
        };
    })



//location id unique(check to database)
    .directive('quantityZeroValidation', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {


                ctrl.$parsers.push(function (viewValue) {

                    if (viewValue != '') {

                            if(viewValue == 0){
                                ctrl.$setValidity('zeroValidation', false);
                            }
                            else
                            {
                                ctrl.$setValidity('zeroValidation', true);
                            }
                        }    

                    return viewValue;
                });

            }
        };
    })


    //location id validation(uppercase,numbers)
    .directive('validateItemId', function () {
        return {
            require: 'ngModel',
            link: function ($scope, element, attrs, ngModel) {

                ngModel.$validators.upperCase = function (value) {
                    var pattern = /[A-Z]+/;
                    return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.number = function (value) {
                    var pattern = /\d+/;
                    return (typeof value !== 'undefined') && pattern.test(value);
                };

            }
        }
    })
//location id unique(check to database)
    .directive('uniqueItemIdValidation', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {




                ctrl.$parsers.push(function (viewValue) {
                    $http({
                        method : 'GET',
                        url : '/item/checkItemIdExist',
                        params: {itemId: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('itemIdExists', true);
                            }
                            else
                            {
                                ctrl.$setValidity('itemIdExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('itemIdExists', false);
                        });

                    return viewValue;
                });

            }
        };
    })

//location barcode unique(check to database)
    .directive('validateLocationBarcode', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {

                ctrl.$parsers.push(function (viewValue) {

                    $http({
                        method : 'GET',
                        url : '/location/checkLocationBarcodeExist',
                        params: {locationBarcode: viewValue, locationId:locationBarcodecheck }
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('locationBarcodeExists', true);
                            }
                            else
                            {
                                ctrl.$setValidity('locationBarcodeExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('locationBarcodeExists', false);
                        });

                    return viewValue;
                });

            }
        };
    })



//uppercase from barcode
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
//*****************end item validation*****************************


;



