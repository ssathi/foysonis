/**
 * Created by User on 2016-02-02.
 */

var app = angular.module('listPicking', ['pickingService','ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ui.grid.pagination','ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ui.grid.expandable' ,'ui.grid.autoResize', 'ui.grid.resizeColumns']);

app.controller('listPickingCtrl', ['$scope', '$http', '$interval', '$q', '$timeout','pickService', '$location', function ($scope, $http, $interval, $q, $timeout, pickService, $location) {

    var myEl = angular.element( document.querySelector( '#liPicking' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulPicking' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'List Picking';
      
    $scope.loadCustomerAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/order/getAllcustomerIdByCompany',
            params : {keyPress: value.keyword}
        });
    };

   var getAllPickList = function () {
       $http({
            method: 'GET',
            url: '/picking/getAllPickList',
        })
        .success(function(data) {
            $scope.gridListPicks.data = data;
        });
    };

    //getAllPickList();

    var getAllListValueCancelPick = function () {
        $http({
            method: 'GET',
            url: '/order/getAllValuesByCompanyIdAndGroup',
            params : {group: 'CPR'}
        })
            .success(function (data, status, headers, config) {
                ctrl.listValueCancelPick = data;
            })
    };


    var ctrl = this;    

    ctrl.getCustomerContactName = function(customer){
        if (customer) {
          ctrl.customerSearch = customer.contactName;  
        }
        
    }

    var getConvertedDate = function(date){

        if (date !=null) {
            return new Date(date).toDateString();
        }
        return null;
    }

    ctrl.getConvertedDate = getConvertedDate;



var pickListSearch = function () {
    $scope.loadAnimPickListSearch = true;
    $http({
        method: 'POST',
        url: '/picking/searchPickList',
        params: {pickListId:ctrl.findPickListId, pickListStatus:ctrl.findPickListStatus, customerName:ctrl.customerSearch},
        dataType: 'json',
        headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
        .success(function (data) {
          $scope.gridListPicks.data = data;
        })
        .finally(function () {
          $scope.loadAnimPickListSearch = false;
        });

};

ctrl.pickListSearch = pickListSearch;

    var loadGridData = function (){
        $http({
            method: 'POST',
            url: '/picking/searchPickList',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridListPicks.data = data.splice(0,10000);

            })
    };

var urlParams = $location.search();
if (urlParams.pickListId) {
    ctrl.findPickListId = urlParams.pickListId;
    pickListSearch();
}
else{
    loadGridData();
};   

ctrl.isAdminUser = false;

//***************End pickList search*************************************  

//***************Start pickList forms*************************************  

    ctrl.showPickToForm = true;
    ctrl.isPickToType = null;
    ctrl.visibleDepositPage = false;
    ctrl.pickIndex = 0;
    ctrl.indexForDispaly = 0;

   

    var startPalletListPick = function () {

        if( ctrl.palletListPickingForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/picking/startPalletListPicking',
                data    :  {palletId:ctrl.picking.palletId},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
            .success(function(data) {
                ctrl.showPickToForm = false;
                ctrl.isPickToType = 'PALLET';
                generatePickFromOptions(ctrl.pickIndex);
                ctrl.disablePickToField = true;
            })
        }
    };


    var startCaseListPick = function () {

        if( ctrl.caseListPickingForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/picking/startCaseListPicking',
                data    :  {caseId:ctrl.picking.caseId},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
            .success(function(data) {
                ctrl.showPickToForm = false;
                ctrl.isPickToType = 'CASE';
                generatePickFromOptions(ctrl.pickIndex);
                ctrl.disablePickToField = true;
            })
        }
    };

    var startHandCarryListPick = function () {

        if( ctrl.handCarryPickingForm.$valid) {

                ctrl.showPickToForm = false;
                ctrl.isPickToType = 'HAND CARRY';
                generatePickFromOptions(ctrl.pickIndex);
                ctrl.disablePickToField = true;
        }
    };

    var getTotalAndCompletedPick = function(pickListId){
            ctrl.totalCompletedPicksOfPickList = 0;
           $http({
                method: 'GET',
                url: '/picking/getAllPickListByPickListId',
                params:{pickListId: pickListId}
            })
            .success(function(data) {
                ctrl.totalPickWorksOfPickList = data.length;
                for (var i = 0; i < data.length; i++) {
                   if (data[i].pickStatus == 'PICK COMPLETED') {
                       ctrl.totalCompletedPicksOfPickList ++; 
                   }
                }

            });


    };


    // var getItemAndStatus = function(workReferenceNumber){
    //        $http({
    //             method  : 'GET',
    //             url     : '/picking/getItemAndStatusByOrderLine',
    //             params  :  {workReferenceNumber:workReferenceNumber}
    //         })
    //         .success(function(data) {
    //             ctrl.pickWorkItemAndStatus = data;
    //         });
    // };
    ctrl.ConfirmBtnText = 'Confirm';
    var UpdatePickWork = function(){

        if( ctrl.confirmPickWorkForm.$valid) {
            ctrl.disableConfirmBtn = true;
            ctrl.ConfirmBtnText = 'Confirming..';

            $http({
                method  : 'POST',
                url     : '/picking/confirmPickWork',
                data    :  {workReferenceNumber:ctrl.picking.workReferenceNumber, completedQty:ctrl.picking.completedQty,  pickFromType: ctrl.pickFrom, pickFromPalletId : ctrl.picking.pickFromPalletId, pickFromCaseId : ctrl.picking.pickFromCaseId, pickToType:ctrl.pickTo, pickToPalletId:ctrl.picking.palletId, pickToCaseId: ctrl.picking.caseId},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {

                    if (data.pickStatus == 'PICK COMPLETED') {
                        if (ctrl.pickIndex != ctrl.pickWorkDataForPicking.length - 1) {
                            ctrl.pickIndex ++;
                            ctrl.indexForDispaly ++;
                            //getItemAndStatus(ctrl.pickWorkDataForPicking[ctrl.pickIndex].workReferenceNumber)
                            console.log(ctrl.pickWorkDataForPicking[ctrl.pickIndex].workReferenceNumber);
                        }
                        else{
                            ctrl.showPickToForm = true;
                            ctrl.isPickToType = null;
                            ctrl.pickIndex = 0;
                            ctrl.indexForDispaly = ctrl.totalCompletedPicksOfPickList;
                            pickListSearch();
                            //clearPickingForm();
                            //$('#listPickingProcess').appendTo('body').modal('hide');
                            ctrl.visibleDepositPage = true;
                        }

                    }

                    else{

                        ctrl.pickWorkDataForPicking[ctrl.pickIndex].pickQuantity = data.pickQuantity;
                        ctrl.pickWorkDataForPicking[ctrl.pickIndex].completedQuantity = data.completedQuantity;
                        ctrl.pickWorkDataForPicking[ctrl.pickIndex].pickStatus = data.pickStatus;
                    }

                    getTotalAndCompletedPick(ctrl.rowsOfPickList.pick_list_id);
                    generatePickFromOptions(ctrl.pickIndex);
                    ctrl.picking.pickFromPalletId = '';
                    ctrl.picking.pickFromCaseId = '';
                    ctrl.completedQtyValidationError = false;
                    ctrl.completedQtyValidationErrorForPallet = false;
                    ctrl.completedQtyValidationErrorForLocation = false;
                    ctrl.completedQtyValidationErrorForCase = false;
                    ctrl.picking.completedQty = '';
                    ctrl.confirmPickWorkForm.$setUntouched();
                    ctrl.confirmPickWorkForm.$setPristine();
                    ctrl.showPickedPrompt = true;

                    $timeout(function(){
                        ctrl.showPickedPrompt = false;
                    }, 8200);

                    //if wave number exist
                    if (ctrl.pickWorkDataForPicking[ctrl.pickIndex].wave_number) {
                        $http({
                            method  : 'POST',
                            url     : '/wave/changeWaveStatusForPicking',
                            params  : {waveNumber: ctrl.pickWorkDataForPicking[ctrl.pickIndex].wave_number},
                            dataType: 'json',
                            headers : { 'Content-Type': 'application/json; charset=utf-8' }
                        })
                            .success(function(data) {   
                                // TODO
                             });                    
                    }

                })

                 .finally(function () {
                 ctrl.disableConfirmBtn = false;
                 ctrl.ConfirmBtnText = 'Confirm';
                });                 

        }


    };

    var directToDeposit = function(){
        ctrl.showPickToForm = true;
        ctrl.isPickToType = null;
        ctrl.pickIndex = 0;
        ctrl.indexForDispaly = ctrl.totalCompletedPicksOfPickList;
        ctrl.visibleDepositPage = true;
    };

    var depositePicks = function(destinationLocation, destinLocFromPick){


        if (!destinationLocation) {
            ctrl.disableDeposit = true;
            ctrl.destinationLocationErrorMsg = 'Destination Location is not valid';
        }
        else {
            if (destinationLocation == destinLocFromPick) {

                ctrl.disableDepositPick = true;

                $http({
                    method  : 'POST',
                    url     : '/picking/depositePicks',
                    data    :  {workReferenceNumber:ctrl.picking.workReferenceNumber, pickToType:ctrl.pickTo, pickToPalletId:ctrl.picking.palletId, pickToCaseId: ctrl.picking.caseId, pickListId:ctrl.rowsOfPickList.pick_list_id, destinationLocation:destinationLocation},
                    dataType: 'json',
                    headers : { 'Content-Type': 'application/json; charset=utf-8' }
                })
                .success(function(data) {
                    $('#listPickingProcess').appendTo('body').modal('hide');
                    clearPickingForm();
                    ctrl.completedQtyValidationError = false;
                    ctrl.completedQtyValidationErrorForPallet = false;
                    ctrl.completedQtyValidationErrorForLocation = false;
                    ctrl.completedQtyValidationErrorForCase = false; 

                    ctrl.showPickToForm = true;
                    ctrl.isPickToType = null;
                    ctrl.pickIndex = 0;
                    ctrl.indexForDispaly = ctrl.totalCompletedPicksOfPickList;
                    pickListSearch();
                    ctrl.visibleDepositPage = false;
                    ctrl.disablePickToField = false;

                    ctrl.confirmPickWorkForm.$setUntouched();
                    ctrl.confirmPickWorkForm.$setPristine();
                })
                .finally(function(){
                    ctrl.disableDepositPick = false;
                });

                ctrl.disableDeposit = false;
            }
            else{

               $http({
                    method: 'GET',
                    url: '/picking/validateDestinationLocation',
                    params:{destinationLocation:destinationLocation}
                })
                .success(function(data) {
                    if (data.length > 0) {
                        if (data[0].is_pnd == true) {
                            ctrl.disableDeposit = false;    
                        }
                        else if (data[0].location_id == destinLocFromPick) {

                            $http({
                                method  : 'POST',
                                url     : '/picking/depositePicks',
                                data    :  {workReferenceNumber:ctrl.picking.workReferenceNumber, pickToType:ctrl.pickTo, pickToPalletId:ctrl.picking.palletId, pickToCaseId: ctrl.picking.caseId, pickListId:ctrl.rowsOfPickList.pick_list_id, destinationLocation:destinationLocation},
                                dataType: 'json',
                                headers : { 'Content-Type': 'application/json; charset=utf-8' }
                            })
                            .success(function(data) {
                                $('#listPickingProcess').appendTo('body').modal('hide');
                                clearPickingForm();
                                ctrl.completedQtyValidationError = false;
                                ctrl.completedQtyValidationErrorForPallet = false;
                                ctrl.completedQtyValidationErrorForLocation = false;
                                ctrl.completedQtyValidationErrorForCase = false; 

                                ctrl.showPickToForm = true;
                                ctrl.isPickToType = null;
                                ctrl.pickIndex = 0;
                                ctrl.indexForDispaly = ctrl.totalCompletedPicksOfPickList;
                                pickListSearch();
                                ctrl.visibleDepositPage = false;
                                ctrl.disablePickToField = false;

                                ctrl.confirmPickWorkForm.$setUntouched();
                                ctrl.confirmPickWorkForm.$setPristine();
                            });
                            
                            ctrl.disableDeposit = false;
                        }
                        else{
                            ctrl.disableDeposit = true;
                            ctrl.destinationLocationErrorMsg = 'Destination Location is not valid';
                        }
                        
                    }
                    else{
                       ctrl.disableDeposit = true;
                       ctrl.destinationLocationErrorMsg = 'Destination Location is not valid';
                    }
                    
                });


            }
        }

    };

    var clearPickData = function(){
            clearPickingForm();
            ctrl.completedQtyValidationError = false;
            ctrl.completedQtyValidationErrorForPallet = false;
            ctrl.completedQtyValidationErrorForLocation = false;
            ctrl.completedQtyValidationErrorForCase = false; 

            ctrl.picking.palletId = '';
            ctrl.picking.caseId = '';
            ctrl.showPickToForm = true;
            ctrl.isPickToType = null;
            ctrl.pickIndex = 0;
            ctrl.indexForDispaly = ctrl.totalCompletedPicksOfPickList;
            ctrl.visibleDepositPage = false;
            ctrl.disableDeposit = true;
            ctrl.destinationLocationErrorMsg ='';
            ctrl.picking.destinationLocation = '';
            ctrl.disablePickToField = false;
            ctrl.hideSkipPickBtn = false;
            ctrl.isAdminUser = false;

            ctrl.confirmPickWorkForm.$setUntouched();
            ctrl.confirmPickWorkForm.$setPristine();
    };

    var confirmPickWork = function(){

        var completedQtyForValidation = ctrl.pickWorkDataForPicking[ctrl.pickIndex].completedQuantity;
        var pickQuantityForValidation = ctrl.pickWorkDataForPicking[ctrl.pickIndex].pickQuantity;
        var locationId = ctrl.pickWorkDataForPicking[ctrl.pickIndex].sourceLocationId;
        var pickQtyUom = ctrl.pickWorkDataForPicking[ctrl.pickIndex].pickQuantityUom;
        var pickOrderLineNum = ctrl.pickWorkDataForPicking[ctrl.pickIndex].orderLineNumber;

        ctrl.completedQtyValidationError = false;
        ctrl.completedQtyValidationErrorForPallet = false;
        ctrl.completedQtyValidationErrorForLocation = false;
        ctrl.completedQtyValidationErrorForCase = false;

        if (ctrl.pickFrom == 'PALLET' && ctrl.picking.completedQty) {

            $http({
                method: 'GET',
                url: '/picking/getPalletIdQtyForValidation',
                params:{locationId: locationId, palletId: ctrl.picking.pickFromPalletId}
            })
                .success(function(data) {
                    var palletQty = data[0].quantity;

                    if ((pickQtyUom).toUpperCase() == 'EACH') {

                        if ((ctrl.inventoryDataByPallet.handling_uom).toUpperCase() == 'EACH') {


                            if (palletQty >= ctrl.picking.completedQty) {

                                var totalCountOfCompletedQty = completedQtyForValidation + ctrl.picking.completedQty
                                if (totalCountOfCompletedQty > pickQuantityForValidation) {
                                    ctrl.completedQtyValidationError = true;
                                }
                                else{
                                    ctrl.completedQtyValidationError = false;
                                }

                            }

                            else{
                                ctrl.completedQtyValidationError = true;
                                ctrl.completedQtyValidationErrorForPallet = true;
                            }

                            if (ctrl.completedQtyValidationError == false && ctrl.completedQtyValidationErrorForPallet == false) {
                                UpdatePickWork();
                            }
                        }
                        else{
                                var calculatedQtyOnPallet = parseInt(palletQty)*parseInt(ctrl.itemRowForQtyValidation.eachesPerCase);
                                if (calculatedQtyOnPallet >= ctrl.picking.completedQty) {

                                    var totalCountOfCompletedQty = completedQtyForValidation + ctrl.picking.completedQty
                                    if (totalCountOfCompletedQty > pickQuantityForValidation) {
                                        ctrl.completedQtyValidationError = true;
                                    }
                                    else{
                                        ctrl.completedQtyValidationError = false;
                                    }

                                }

                                else{
                                    ctrl.completedQtyValidationError = true;
                                    ctrl.completedQtyValidationErrorForPallet = true;
                                }                            
                        }
                    }
                    else{

                            if ((ctrl.inventoryDataByPallet.handling_uom).toUpperCase() == 'EACH') {
                                ctrl.completedQtyValidationError = true;
                                ctrl.completedQtyValidationErrorForPallet = true;
                            }

                            else{

                                if (palletQty >= ctrl.picking.completedQty) {

                                    var totalCountOfCompletedQty = completedQtyForValidation + ctrl.picking.completedQty
                                    if (totalCountOfCompletedQty > pickQuantityForValidation) {
                                        ctrl.completedQtyValidationError = true;
                                    }
                                    else{
                                        ctrl.completedQtyValidationError = false;
                                    }

                                }

                                else{
                                    ctrl.completedQtyValidationError = true;
                                    ctrl.completedQtyValidationErrorForPallet = true;
                                }

                            }                        
                    }

                    if (ctrl.completedQtyValidationError == false && ctrl.completedQtyValidationErrorForCase == false) {
                        UpdatePickWork();
                    }

                });



        }

        else if (ctrl.pickFrom == 'LOCATION' && ctrl.picking.completedQty) {

            $http({
                method: 'GET',
                url: '/picking/getLocationForValidation',
                params : {locationId: locationId, itemId:ctrl.pickWorkDataForPicking[ctrl.pickIndex].itemId, invStatus:ctrl.pickWorkDataForPicking[ctrl.pickIndex].reqInvStatusOptionVal}
            })
                .success(function(data) {
                    var qtyOnLocation = 0;
                    if (data.length > 1) {
                        for (var i = 0; i < data.length; i++) {
                            qtyOnLocation += parseInt(data[i].quantity);
                        }
                    }
                    else{
                        qtyOnLocation = data[0].quantity;    
                    }
                    if (qtyOnLocation >= ctrl.picking.completedQty) {

                        var totalCountOfCompletedQty = completedQtyForValidation + ctrl.picking.completedQty
                        if (totalCountOfCompletedQty > pickQuantityForValidation) {
                            ctrl.completedQtyValidationError = true;
                        }
                        else{
                            ctrl.completedQtyValidationError = false;
                        }

                    }

                    else{
                        ctrl.completedQtyValidationError = true;
                        ctrl.completedQtyValidationErrorForLocation = true;
                    }

                    if (ctrl.completedQtyValidationError == false && ctrl.completedQtyValidationErrorForLocation == false) {
                        UpdatePickWork();
                    }

                });


        }

        else if (ctrl.pickFrom == 'CASE' && ctrl.picking.completedQty) {
            $http({
                method: 'GET',
                url: '/item/findItem',
                params:{itemId: ctrl.pickWorkDataForPicking[ctrl.pickIndex].itemId}
            })
                .success(function(data) {
                    ctrl.itemDataRow = data[0];

                    $http({
                        method: 'GET',
                        //url: '/picking/getCaseIdQtyForValidation',
                        url: '/picking/checkCaseIdMatchesPicking',
                        params:{locationId: locationId, caseId: ctrl.picking.pickFromCaseId, orderLineNumber:pickOrderLineNum, pickType:ctrl.pickFrom}
                    })
                        .success(function(data) {
                            var qtyOnCase = data[0].quantity;

                            if ((pickQtyUom).toUpperCase() == 'EACH') {

                                if ((ctrl.inventoryDataByCase.handling_uom).toUpperCase() == 'EACH') {

                                    if (qtyOnCase >= ctrl.picking.completedQty) {

                                        var totalCountOfCompletedQty = completedQtyForValidation + ctrl.picking.completedQty
                                        if (totalCountOfCompletedQty > pickQuantityForValidation) {
                                            ctrl.completedQtyValidationError = true;
                                        }
                                        else{
                                            ctrl.completedQtyValidationError = false;
                                        }

                                    }

                                    else{
                                        ctrl.completedQtyValidationError = true;
                                        ctrl.completedQtyValidationErrorForCase = true;
                                    }

                                }
                                else{

                                    var calculatedQtyOnCase = parseInt(qtyOnCase)*parseInt(ctrl.itemDataRow.eachesPerCase);
                                    if (calculatedQtyOnCase >= ctrl.picking.completedQty) {

                                        var totalCountOfCompletedQty = completedQtyForValidation + ctrl.picking.completedQty
                                        if (totalCountOfCompletedQty > pickQuantityForValidation) {
                                            ctrl.completedQtyValidationError = true;
                                        }
                                        else{
                                            ctrl.completedQtyValidationError = false;
                                        }

                                    }

                                    else{
                                        ctrl.completedQtyValidationError = true;
                                        ctrl.completedQtyValidationErrorForCase = true;
                                    }

                                }

                            }
                            else{

                                if ((ctrl.inventoryDataByCase.handling_uom).toUpperCase() == 'EACH') {
                                    ctrl.completedQtyValidationError = true;
                                    ctrl.completedQtyValidationErrorForCase = true;
                                }

                                else{

                                    if (qtyOnCase >= ctrl.picking.completedQty) {

                                        var totalCountOfCompletedQty = completedQtyForValidation + ctrl.picking.completedQty
                                        if (totalCountOfCompletedQty > pickQuantityForValidation) {
                                            ctrl.completedQtyValidationError = true;
                                        }
                                        else{
                                            ctrl.completedQtyValidationError = false;
                                        }

                                    }

                                    else{
                                        ctrl.completedQtyValidationError = true;
                                        ctrl.completedQtyValidationErrorForCase = true;
                                    }

                                }
                            }

                            if (ctrl.completedQtyValidationError == false && ctrl.completedQtyValidationErrorForCase == false) {
                                UpdatePickWork();
                            }

                        });

                });


        }

    };

    // var pushToTheEnd = function( array, index ) {
    //     array.push( array.splice( index, 1 )[0] );
    // }

    var skipPickWork = function(){

            $http({
                method  : 'POST',
                url     : '/picking/updateSkippedPickWork',
                data    :  {workReferenceNumber:ctrl.picking.workReferenceNumber},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
            .success(function(data) {
                   
                    if (ctrl.pickIndex != (ctrl.pickWorkDataForPicking.length - 1)) {
                        ctrl.pickWorkDataForPicking[ctrl.pickIndex].isSkipped = true;
                        ctrl.pickWorkDataForPicking[ctrl.pickWorkDataForPicking.length] = ctrl.pickWorkDataForPicking[ctrl.pickIndex];
                        ctrl.pickIndex ++;
                        //getItemAndStatus(ctrl.pickWorkDataForPicking[ctrl.pickIndex].workReferenceNumber)
                        if (ctrl.pickIndex == (ctrl.pickWorkDataForPicking.length - 1)) {
                            ctrl.hideSkipPickBtn = true;
                        }
                    }
                    else{
                        ctrl.hideSkipPickBtn = true;
                    }

                    //getTotalAndCompletedPick(ctrl.rowsOfPickList.pick_list_id);
                    generatePickFromOptions(ctrl.pickIndex);
                    ctrl.picking.pickFromPalletId = '';
                    ctrl.picking.pickFromCaseId = '';
                    ctrl.completedQtyValidationError = false;
                    ctrl.completedQtyValidationErrorForPallet = false;
                    ctrl.completedQtyValidationErrorForLocation = false;
                    ctrl.completedQtyValidationErrorForCase = false;
                    ctrl.picking.completedQty = '';
                    ctrl.confirmPickWorkForm.$setUntouched();
                    ctrl.confirmPickWorkForm.$setPristine();
            });
    };

    var validatePalletIdForPick = function(orderLineNumber, locationId, pickType){

        if (ctrl.picking.pickFromPalletId) {

           $http({
                method: 'GET',
                url: '/picking/checkPalletIdMatchesPicking',
                params:{orderLineNumber:orderLineNumber, locationId: locationId, palletId: ctrl.picking.pickFromPalletId, pickType: pickType}
            })
            .success(function(data) {
                if (data.length > 0) {
                   ctrl.inventoryDataByPallet = data[0];
                   ctrl.palletIdValidationError = false;
                }
                else{
                   ctrl.palletIdValidationError = true;
                }
                
            });

        }

        else{
            ctrl.palletIdValidationError = false;
        }

    };

    var validateCaseIdForPick = function(orderLineNumber, locationId, pickType){
        ctrl.caseValidationErrorMsg = "";
        if (ctrl.picking.pickFromCaseId) {

           $http({
                method: 'GET',
                url: '/picking/checkCaseIdMatchesPicking',
                params:{orderLineNumber:orderLineNumber, locationId: locationId, caseId: ctrl.picking.pickFromCaseId, pickType: pickType}
            })
            .success(function(data) {
                   ctrl.inventoryDataByCase = data[0];
                    if (data.length > 0) {
                        if (data[0].status && data[0].status == "allocationRuleFailed") {
                            ctrl.caseIdValidationError = true;
                            ctrl.caseValidationErrorMsg = "This case Id is invalid"
                        }
                        else{
                            ctrl.caseIdValidationError = false;
                            ctrl.caseValidationErrorMsg = "";
                        }
                       
                    }
                    else{
                       ctrl.caseIdValidationError = true;
                       ctrl.caseValidationErrorMsg = "This Case Id does not belong to the location or item or inventory status of the pick.";
                    }
                
            });

        }

        else{
            ctrl.caseIdValidationError = false;
        }

    };

    ctrl.disableDeposit = true;
    var validateDestinationLoc = function(destinationLocInput, destinLocFromPick){

        if (!destinationLocInput) {
            ctrl.disableDeposit = true;
            ctrl.destinationLocationErrorMsg = 'Destination Location is not valid';
        }
        else {
            if (destinationLocInput == destinLocFromPick) {
                ctrl.disableDeposit = false;
            }
            else{

               $http({
                    method: 'GET',
                    url: '/picking/validateDestinationLocation',
                    params:{destinationLocation:destinationLocInput}
                })
                .success(function(data) {
                    if (data.length > 0) {
                        if (data[0].is_pnd == true) {
                            ctrl.disableDeposit = false;    
                        }
                        else if (data[0].location_id == destinLocFromPick) {
                            ctrl.disableDeposit = false;
                        }
                        else{
                            ctrl.disableDeposit = true;
                            ctrl.destinationLocationErrorMsg = 'Destination Location is not valid';
                        }
                        
                    }
                    else{
                       ctrl.disableDeposit = true;
                       ctrl.destinationLocationErrorMsg = 'Destination Location is not valid';
                    }
                    
                });


            }
        }
        
    };

    var clearPickingForm = function(){
        ctrl.pickTo = '';
        ctrl.picking.palletId = '';
        ctrl.picking.case = '';
        ctrl.picking.completedQty = '';
        ctrl.picking.pickFromPalletId = '';
        ctrl.picking.pickFromCaseId = '';
        ctrl.pickFrom = '';
    };

    ctrl.startPalletListPick = startPalletListPick;
    ctrl.startCaseListPick = startCaseListPick; 
    ctrl.startHandCarryListPick = startHandCarryListPick;
    ctrl.confirmPickWork = confirmPickWork;
    ctrl.clearPickingForm = clearPickingForm;
    ctrl.validatePalletIdForPick = validatePalletIdForPick;
    ctrl.validateCaseIdForPick = validateCaseIdForPick;
    ctrl.depositePicks = depositePicks;
    ctrl.directToDeposit = directToDeposit;
    ctrl.validateDestinationLoc = validateDestinationLoc;
    ctrl.clearPickData = clearPickData;    
    ctrl.skipPickWork = skipPickWork;

    var hasErrorClassForPallet = function (field) {
        return ctrl.palletListPickingForm[field].$touched && ctrl.palletListPickingForm[field].$invalid;
    };

    var hasErrorClassForCase = function (field) {
        return ctrl.caseListPickingForm[field].$touched && ctrl.caseListPickingForm[field].$invalid;
    };    

    var showMessagesForPallet = function (field) {
        return ctrl.palletListPickingForm[field].$touched || ctrl.palletListPickingForm.$submitted;
    }; 

    var showMessagesForCase = function (field) {
        return ctrl.caseListPickingForm[field].$touched || ctrl.caseListPickingForm.$submitted;
    };       

    ctrl.hasErrorClassForPallet = hasErrorClassForPallet;
    ctrl.hasErrorClassForCase = hasErrorClassForCase;
    ctrl.showMessagesForPallet = showMessagesForPallet;
    ctrl.showMessagesForCase = showMessagesForCase;


    $scope.checkPickListStatus = function(row){
        if (row.entity.pick_list_status == 'R' || row.entity.pick_list_status == 'P') {
            return true
        }
        else{
            return false
        }
        
    };

    $scope.startPickingList = function(row){

        $http.get('/user/getCurrentUser')
        .success(function (data) {
            if (data) {
                ctrl.isAdminUser = data.adminActiveStatus
            }
            
        });
        
        ctrl.rowsOfPickList = row.entity;
        ctrl.visibleDepositPage = false;
        ctrl.pickIndex = 0;
        ctrl.disablePickFromOptions = false;
        ctrl.pickFromOptions = [];
        //getTotalAndCompletedPick(row.entity.pick_list_id);
        ctrl.totalCompletedPicksOfPickList = 0;
           $http({
                method: 'GET',
                url: '/picking/getAllPickListByPickListId',
                params:{pickListId: row.entity.pick_list_id}
            })
            .success(function(data) {
                ctrl.totalPickWorksOfPickList = data.length;
                for (var i = 0; i < data.length; i++) {
                   if (data[i].pickStatus == 'PICK COMPLETED') {
                       ctrl.totalCompletedPicksOfPickList ++; 
                   }
                }


               $http({
                    method: 'GET',
                    url: '/picking/getTotalDepositedPickCountByPickList',
                    params:{pickListId: row.entity.pick_list_id}
                })
                .success(function(data) {
                    //ctrl.totalSepositedPickWorks = data[0].pickCount;
                    if (data.length > 0 && data[0].pickCount > 0) {
                        ctrl.totalPickWorksToDisplay = ctrl.totalPickWorksOfPickList - data[0].pickCount; 
                        ctrl.totalCompletedPicksToDisplay = ctrl.totalCompletedPicksOfPickList;
                        if ((ctrl.totalCompletedPicksOfPickList - data[0].pickCount)> 0 ) {
                            ctrl.indexForDispaly = ctrl.totalCompletedPicksOfPickList - data[0].pickCount;
                        }
                        else{
                            ctrl.indexForDispaly = 0;
                        }
                        //ctrl.indexForDispaly = ctrl.totalCompletedPicksOfPickList;
                    }
                    else{
                        ctrl.totalPickWorksToDisplay = ctrl.totalPickWorksOfPickList; 
                        ctrl.totalCompletedPicksToDisplay = ctrl.totalCompletedPicksOfPickList;
                        ctrl.indexForDispaly = ctrl.totalCompletedPicksOfPickList;
                    }

                })
                .error(function (error, status){
                    ctrl.totalPickWorksToDisplay = ctrl.totalPickWorksOfPickList; 
                    ctrl.totalCompletedPicksToDisplay = ctrl.totalCompletedPicksOfPickList;
                    ctrl.indexForDispaly = ctrl.totalCompletedPicksOfPickList; 
                }); 

                

            });


        $http({
            method: 'GET',
            url: '/picking/getAllPickWorkByPickList',
            params : {pickListId: row.entity.pick_list_id}
        })
        .success(function (data, status, headers, config) {
            if (data.length>0) {
               ctrl.pickWorkDataForPicking = data;
               //getItemAndStatus(data[0].workReferenceNumber) 
            }
            else{

                $http({
                    method: 'GET',
                    url: '/picking/getPickWorkByPickList',
                    params : {pickListId: row.entity.pick_list_id}
                })
                .success(function (data, status, headers, config) {
                    ctrl.pickWorkDataForPicking = data;
                    ctrl.showPickToForm = true;
                    ctrl.isPickToType = null;
                    ctrl.pickIndex = 0;
                    ctrl.indexForDispaly = ctrl.totalCompletedPicksOfPickList;
                    ctrl.visibleDepositPage = true;
                })
            }
            
        })




        if (row.entity.pick_list_status == 'R') {

            $('#listPickingProcess').appendTo('body').modal('show');

            $http({
                method: 'GET',
                url: '/picking/checkAllPickLevelEach',
                params : {pickListId: row.entity.pick_list_id}
            })
            .success(function (data, status, headers, config) {
                if (data.show == 'allEaches') {
                    ctrl.pickToOptions = ['PALLET' , 'CARTON', 'HAND CARRY'];
                }
                else {
                    ctrl.pickToOptions = ['PALLET' , 'HAND CARRY'];
                }
                
            })


        }

        else if (row.entity.pick_list_status == 'P') {
            $('#partiallyReadyWarning').appendTo('body').modal('show');
        }


        if (ctrl.rowsOfPickList.pick_list_status == 'R') {
            ctrl.pickListStatus = 'Ready for pick';
        }

        else if (ctrl.rowsOfPickList.pick_list_status == 'P') {
            ctrl.pickListStatus = 'Partially Ready';
        }  

        else if (ctrl.rowsOfPickList.pick_list_status == 'C') {
            ctrl.pickListStatus = 'Completed';
        }        

    };



     $("#acceptPartiallyPickingButton").click(function(){
        $('#listPickingProcess').appendTo('body').modal('show');
        $('#partiallyReadyWarning').modal('hide');

    });


    // var findInventoryDirectlyFromLocation = function(index){

    //     $http({
    //         method: 'GET',
    //         url: '/picking/getLocationForValidation',
    //         params : {locationId: ctrl.pickWorkDataForPicking[index].sourceLocationId}
    //     })
    //     .success(function (data, status, headers, config) {
    //         if (data.length > 0 ) {
    //             ctrl.isInventoryExistOnLocation = true;
    //             ctrl.pickFrom = 'LOCATION';
    //         }
    //         else{
    //             ctrl.isInventoryExistOnLocation = false;
    //             ctrl.pickFrom = 'PALLET';
    //         }
    //     })  

    // }; 

    var generatePickFromOptions = function(index){

        var requestedInventoryStatus = ctrl.pickWorkDataForPicking[ctrl.pickIndex].reqInvStatusOptionVal;

        $http({
            method: 'GET',
            url: '/picking/checkItemCaseTracked',
            params : {workReferenceNumber: ctrl.pickWorkDataForPicking[index].workReferenceNumber}
        })
        .success(function (data, status, headers, config) {
            if (data.length > 0 ) {
                ctrl.itemRowForQtyValidation = data[0];
                var pickItemId = data[0].itemId;
                if (data[0].isCaseTracked == true) { // checking is item case tracked
                    ctrl.pickFromOptions = ['CASE'];
                    ctrl.pickFrom = 'CASE';
                    ctrl.disablePickFromOptions = true;
                }
                else{ //item not case tracked
                    $http({
                        method: 'GET',
                        url: '/picking/getPalletDataForValidation',
                        params : {locationId: ctrl.pickWorkDataForPicking[index].sourceLocationId, itemId:pickItemId, invStatus:requestedInventoryStatus}
                    })
                    .success(function (data, status, headers, config) {
                        if (data.length > 0 ) {
                            $http({
                                method: 'GET',
                                url: '/picking/getLocationForValidation',
                                params : {locationId: ctrl.pickWorkDataForPicking[index].sourceLocationId, itemId:pickItemId, invStatus:requestedInventoryStatus}
                            })
                            .success(function (data, status, headers, config) {
                                if (data.length > 0 ) {// inventory in location
                                    ctrl.pickFromOptions = ['PALLET','LOCATION'];
                                    ctrl.pickFrom = 'PALLET';
                                }
                                else{
                                    ctrl.pickFromOptions = ['PALLET'];
                                    ctrl.pickFrom = 'PALLET';
                                    ctrl.disablePickFromOptions = true;
                                }
                            }); 

                        }
                        else{

                            $http({
                                method: 'GET',
                                url: '/picking/getLocationForValidation',
                                params : {locationId: ctrl.pickWorkDataForPicking[index].sourceLocationId, itemId:pickItemId, invStatus:requestedInventoryStatus}
                            })
                            .success(function (data, status, headers, config) {
                                if (data.length > 0 ) {// inventory in location
                                    ctrl.pickFromOptions = ['LOCATION'];
                                    ctrl.pickFrom = 'LOCATION';
                                    ctrl.disablePickFromOptions = true;
                                }
                                else{
                                    ctrl.pickFromOptions = [];
                                    ctrl.pickFrom = '';
                                }
                            }); 

                        }
                    });
                }
            }
        });  

    };    


    var cancelAllocationForPickWork = function(workReferenceNumber,pickedQty){
        getAllListValueCancelPick();
        ctrl.reasonCancelPick = 'noOption';
         $('#CancelPickWarningModel').appendTo('body').modal('show');
         ctrl.workRefNumForCancelPick = workReferenceNumber;
         ctrl.pickedQtyForCancelPick = pickedQty;
    };

    $("#cancelPickButton").click(function(){

        $http({
            method: 'GET',
            url: '/picking/cancelPickWork',
            params : {workReferenceNumber: ctrl.workRefNumForCancelPick, reAllocate:ctrl.picking.tryToReAllocate, cancelPickReason:ctrl.reasonCancelPick}
        })
        .success(function (data, status, headers, config) {

            $('#CancelPickWarningModel').appendTo('body').modal('hide');

            if (ctrl.pickedQtyForCancelPick != 0) {

                if (ctrl.pickIndex != ctrl.pickWorkDataForPicking.length - 1) {
                    ctrl.pickIndex ++; 
                    ctrl.indexForDispaly ++;
                }
                else{
                    ctrl.showPickToForm = true;
                    ctrl.isPickToType = null;
                    ctrl.pickIndex = 0;
                    ctrl.indexForDispaly = ctrl.totalCompletedPicksOfPickList;
                    pickListSearch();
                    ctrl.visibleDepositPage = true;
                }  
                 
                generatePickFromOptions(ctrl.pickIndex);
                ctrl.picking.pickFromPalletId = '';
                ctrl.picking.pickFromCaseId = '';
                ctrl.completedQtyValidationError = false; 
                ctrl.completedQtyValidationErrorForPallet = false;
                ctrl.completedQtyValidationErrorForLocation = false;
                ctrl.completedQtyValidationErrorForCase = false;
                ctrl.picking.completedQty = '';
                ctrl.confirmPickWorkForm.$setUntouched();
                ctrl.confirmPickWorkForm.$setPristine();

            }
            else{

                if (ctrl.pickIndex != ctrl.pickWorkDataForPicking.length - 1) {
                    ctrl.pickIndex ++; 
                    ctrl.indexForDispaly ++;
                }
                else{

                    $('#listPickingProcess').modal('hide');
                    ctrl.showPickToForm = false;
                    ctrl.isPickToType = null;
                    ctrl.pickIndex = 0;
                    ctrl.indexForDispaly = ctrl.totalCompletedPicksOfPickList;
                    pickListSearch();
                    ctrl.visibleDepositPage = false;
                    ctrl.picking.pickFromPalletId = '';
                    ctrl.picking.pickFromCaseId = '';
                    ctrl.completedQtyValidationError = false; 
                    ctrl.completedQtyValidationErrorForPallet = false;
                    ctrl.completedQtyValidationErrorForLocation = false;
                    ctrl.completedQtyValidationErrorForCase = false;
                    ctrl.picking.completedQty = '';
                    ctrl.confirmPickWorkForm.$setUntouched();
                    ctrl.confirmPickWorkForm.$setPristine(); 
                    
                }                  

            }


            
        })
        $('#CancelPickSuccessModel').appendTo('body').modal('show');
    
    });


    ctrl.cancelAllocationForPickWork = cancelAllocationForPickWork;

//***************End pickList forms***************************************  

    $scope.getPickListStatus = function(row){
        if (row.entity.pick_list_status == 'R') {
            return 'Ready for pick';
        }

        if (row.entity.pick_list_status == 'P') {
            return 'Partially Ready';
        }        

        if (row.entity.pick_list_status == 'C') {
            return 'Completed';
        }   

    };


    $scope.gridListPicks = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
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
            {name:'Customer Name' , field: 'contact_name'},       
            {name:'Pick List Id' , field: 'pick_list_id'},
            {name:'Pick List Status' , cellTemplate:'<div style="color:#9b9b9b; line-height:36px;">{{grid.appScope.getPickListStatus(row);}}</div>'},
            {name:'Total No.Of Picks' , field: 'total_pickworks'},
            {name:'Completed Picks' , field: 'completed_picks'},
            {name:'Pending Replen' , field: 'pending_replen'},
            {name:'Created Date' , field: 'created_date', type: "date",cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Completion Date' , field: 'completion_date', type: "date",cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Last Update Date' , field: 'last_update_date', type: "date",cellFilter: 'date:"yyyy-MM-dd"'},
            {name: 'Actions', enableSorting: false, enableFiltering: false,  cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto;" ng-if = "grid.appScope.checkPickListStatus(row)"><button type = "button" class="btn btn-xs btn-primary startPickBtn" style="padding: 0px 10px !important; margin: 2px 10px 0px 10px;" ng-click = "grid.appScope.startPickingList(row)">START</button></div>'}

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
    };//end of the grid

    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };

//grid auto resize
    $scope.getTableHeight = function() {
        // var rowHeight = 55; // your row height
        // var headerHeight = 32; // your header height
        // return {
        //     height: ($scope.gridOrderLines.data.length * rowHeight - headerHeight) + "px"
        //     //height: ($scope.gridOrderLines.data.length * rowHeight + headerHeight) + "px"
        };

    ctrl.palletIdValidationForScan = function(event){
        if(event.keyCode == 13){
            event.preventDefault();
            document.getElementById("pickToPalletId").blur();
            //ctrl.uniquePalletIdValidation(ctrl.picking.palletId);
            //ctrl.startPalletListPick();
            setTimeout(function() { 
                ctrl.startPalletListPick();
            }, 600);

        }
    };

    ctrl.caseIdValidationForScan = function(event){
        if(event.keyCode == 13){
            event.preventDefault();
            document.getElementById("pickToCaseId").blur();
            //ctrl.uniquePalletIdValidation(ctrl.picking.palletId);
            //ctrl.startPalletListPick();
            setTimeout(function() { 
                ctrl.startCaseListPick()
            }, 600);

        }
    };

    ctrl.uniquePalletIdValidation = function(viewValue){
        $http({
            method : 'GET',
            url : '/picking/checkPalletIdExist',
            params: {palletId: viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    ctrl.palletListPickingForm.palletId.$setValidity('palletIdExists', true);
                }
                else
               {
                    ctrl.palletListPickingForm.palletId.$setValidity('palletIdExists', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.palletListPickingForm.palletId.$setValidity('palletIdExists', false);
            });
    };

    ctrl.uniqueCaseIdValidation = function(viewValue){
        $http({
            method : 'GET',
            url : '/picking/checkCaseIdExist',
            params: {caseId: viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    ctrl.caseListPickingForm.caseId.$setValidity('caseIdExists', true);
                }
                else
               {
                    ctrl.caseListPickingForm.caseId.$setValidity('caseIdExists', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.caseListPickingForm.caseId.$setValidity('caseIdExists', false);
            });
    };

    ctrl.destinationLocationValidation = function(viewValue){
        $http({
            method: 'GET',
            url: '/picking/validateDestinationLocation',
            params:{destinationLocation:viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    ctrl.$setValidity('destinLocIdExists', false);
                }
                else
               {
                    ctrl.$setValidity('destinLocIdExists', true);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.$setValidity('destinLocIdExists', true);
            });
    };

}])

    .directive('uniquePalletIdValidation', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {




                ctrl.$parsers.push(function (viewValue) {
                    $http({
                        method : 'GET',
                        url : '/picking/checkPalletIdExist',
                        params: {palletId: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('palletIdExists', true);
                            }
                            else
                           {
                                ctrl.$setValidity('palletIdExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('palletIdExists', false);
                        });

                    return viewValue;
                });

            }
        };
    })


    .directive('uniqueCaseIdValidation', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {




                ctrl.$parsers.push(function (viewValue) {
                    $http({
                        method : 'GET',
                        url : '/picking/checkCaseIdExist',
                        params: {palletId: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('caseIdExists', true);
                            }
                            else
                           {
                                ctrl.$setValidity('caseIdExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('caseIdExists', false);
                        });

                    return viewValue;
                });

            }
        };
    }) 

    .directive('destinationLocationValidation', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {




                ctrl.$parsers.push(function (viewValue) {
                    $http({
                        method: 'GET',
                        url: '/picking/validateDestinationLocation',
                        params:{destinationLocation:viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('destinLocIdExists', false);
                            }
                            else
                           {
                                ctrl.$setValidity('destinLocIdExists', true);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('destinLocIdExists', true);
                        });

                    return viewValue;
                });

            }
        };
    })    

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
