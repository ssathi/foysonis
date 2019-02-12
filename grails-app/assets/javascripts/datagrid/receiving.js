/**
 * Created by home on 9/10/15.
 */

var app = angular.module('receiving', ['ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.grid.pagination', 'inventory-autocomplete', 'ui.grid.expandable','ui.bootstrap', 'ngLocale', 'ui.grid.autoResize', 'ui.grid.resizeColumns']);

app.controller('ReceivingCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

    var myEl = angular.element( document.querySelector( '#liReceiving' ) );
    myEl.addClass('active');

    var headerTitle = 'Receiving';

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

//***********start receipt create****************************
    $scope.loadCompanyItems = function (value) {

        return $http({
            method: 'GET',
            url: '/order/getItems',
            params : {keyword:value.keyword}
        })        
        // $http.get('/item/getItems')
        //     .success(function(data) {
        //         $scope.loadCompanyItems = data;
        //     });
    };

    $scope.loadCustomerAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/order/getAllcustomerIdByCompany',
            params : {keyPress: value.keyword}
        });
    };

    $scope.addNewCustomerEdit = function(contactName, customerId){
        ctrl.editReceipt.customerId = customerId;
        // if (contactName == "+ New Customer") {
        //     $('#addCustomer').appendTo("body").modal('show');
        // }
    };

    $scope.addNewCustomer = function(contactName, customerId){
        ctrl.newReceipt.customerId = customerId;
        // if (contactName == "+ New Customer") {
        //     $('#addCustomer').appendTo("body").modal('show');
        // }
    };

    $scope.totalGridDataVal = 50;
    $scope.currentPageNum = 1;
    var checkIsItemLotCodeTracked = function(itemId,index){
        $http({
            method: 'GET',
            url: '/inventory/checkIsLotCodeTrackedOfItem',
            params : {itemId:itemId}
        })

            .success(function (data, status, headers, config) {
                ctrl.checkIsLotCodeTracked = data;

                if(ctrl.checkIsLotCodeTracked.length > 0) {
                    ctrl.lotCodeTracked[index] = true;

                }
                else{
                    ctrl.lotCodeTracked[index] = false;

                }

            })
    };

    var checkIsItemExpired = function(itemId,index){

        $http({
            method: 'GET',
            url: '/inventory/checkIsExpiredOfItem',
            params : {itemId: itemId}
        })

            .success(function (data, status, headers, config) {
                ctrl.checkIsExpired = data;

                if (ctrl.checkIsExpired.length > 0) {
                    ctrl.isExpired[index] = true;

                }
                else{
                    ctrl.isExpired[index] = false;

                }


            })

    };


    var checkItemLowestUom = function(itemId,index, isEdit){
        $http({
            method: 'GET',
            url: '/item/getLowestUom',
            params : {itemId: itemId}
        })

            .success(function (data, status, headers, config) {

                ctrl.newReceipt.receiptLine[index].uom = data[0];
                if (isEdit) {
                    ctrl.editReceipt.receiptLine[index].uom = data[0];
                }

            })

    };


    var checkReceiptLineNumExist = function(receiptLine,index){
        $http({
            method: 'GET',
            url: '/receiving/checkReceiptLineNumExist',
            params : {receiptLineNumber: receiptLine, receiptId:ctrl.newReceipt.receiptId}
        })

            .success(function (data, status, headers, config) {
                ctrl.receiptLineIdExist = data;

                if (ctrl.receiptLineIdExist.length > 0) {
                    ctrl.isReceiptLineIdExist[index] = true;

                }
                else{
                    ctrl.isReceiptLineIdExist[index] = false;

                }


            })

    };

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

    $scope.openReceiptDate = function() {
        $scope.popupReceiptDate.opened = true;
    };

    $scope.openReceiptDateEdit = function() {
        $scope.popupReceiptDateEdit.opened = true;
    };

    $scope.openReceiptDateFrom = function() {
        $scope.popupReceiptDateFrom.opened = true;
    };

    $scope.openReceiptDateTo = function() {
        $scope.popupReceiptDateTo.opened = true;
    };

    $scope.format = $locale.DATETIME_FORMATS.shortDate;
    $scope.altInputFormats = ['M!/d!/yyyy'];

    $scope.popupReceiptDate = {
        opened: false
    };
    $scope.popupReceiptDateEdit = {
        opened: false
    };
    $scope.popupReceiptDateFrom = {
        opened: false
    };
    $scope.popupReceiptDateTo = {
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



    $scope.IsVisible = false;
    $scope.ShowHide = function () {
        clearForm();
        if($scope.IsVisible){
            $scope.IsVisible = false;
        }
        else{
            $scope.IsVisible = true;
            // getReceiptTypes();
        }

        ctrl.showSubmittedPrompt = false;
        ctrl.addNewFieldNum = 1;
        ctrl.isExpired = [];
        ctrl.lotCodeTracked = [];
        ctrl.lowestUomEach = [];
        ctrl.isReceiptLineIdExist = [];
        //loadItemAutoComplete();
        ctrl.editReceiptState = false;
        ctrl.editReceipt.receiptType = null;
        ctrl.showUpdatedPrompt = false;
        ctrl.showCompletedPrompt = false;
        ctrl.showDeletedPrompt = false;
        ctrl.newReceipt.receiptType = null;
    };

    $scope.showPendingPutaway = function () {

        $('#pendingPutawayView').appendTo("body").modal('show');
        ctrl.showPutawaySuccess = false;
        ctrl.isPendingPutaway = true;

        loadPendingPutaway();
    };

    var loadPendingPutaway = function(){

        $http({
            method: 'GET',
            url: '/receiving/getPendingPutawayInventory'
        })

            .success(function(data) {
                $scope.pendingPutawayGridOptions.data = data;

            });
    };


    var currentUserStatus = function(){
        $http.get('/user/getCurrentUser')
            .success(function(data) {
                if (data) {
                    $scope.isCurrentUserAdmin = data.adminActiveStatus;  
                }
                else{
                    $scope.isCurrentUserAdmin = false;    
                }
                
            });
    }

    currentUserStatus();


    var ctrl = this,
        newReceipt = { receiptId:'', receiptDate:'', inboundTruckId:'', inboundProNumber:'', receiptType: null, customerId: null, receiptLine:[]};

    ctrl.lowestUomEach = [];
    ctrl.lotCodeTracked = [];
    ctrl.isExpired = [];

    var createReceipt = function () {

        ctrl.receiptIdForMessage = ctrl.newReceipt.receiptId;

        if (ctrl.newReceipt.inboundTruckId == '') {
            ctrl.newReceipt.inboundTruckId = null;
        }

        if (ctrl.newReceipt.inboundProNumber == '') {
            ctrl.newReceipt.inboundProNumber = null;
        }

        if (ctrl.newReceipt.receiptType == '') {
            ctrl.newReceipt.receiptType = null;
        }

        if( ctrl.createReceiptForm.$valid) {

            ctrl.disableSaveReceiptBtn = true;

            $http({
                method  : 'POST',
                url     : '/receiving/saveReceipt',
                data    :  $scope.ctrl.newReceipt,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {

                    $http({
                        method: 'GET',
                        url: '/receiving/searchResults',
                        params : {receiptId:ctrl.newReceipt.receiptId}
                    })
                        .success(function(data) {
                            $scope.gridItem.data = data;
                        });

                    $scope.IsVisible = false;
                    ctrl.showSubmittedPrompt = true;
                    clearForm();
                    clearFormEdit();
                    ctrl.addNewFieldNum = 1;
                    $timeout(function(){
                        ctrl.showSubmittedPrompt = false;
                    }, 10000);                    

                })
                .finally(function () {
                    ctrl.disableSaveReceiptBtn = false;
                });

        }
    };


    var clearForm = function () {
        //ctrl.newReceipt = { receiptId:'', receiptDate:'', receiptLine:[]};
        ctrl.newReceipt.receiptId = '';
        ctrl.newReceipt.receiptDate = new Date();
        ctrl.newReceipt.inboundTruckId = '';
        ctrl.newReceipt.inboundProNumber = '';
        ctrl.createReceiptForm.$setUntouched();
        ctrl.createReceiptForm.$setPristine();
        ctrl.receiptLineNumberList = [];
        ctrl.newReceipt.receiptLine[0].itemId = '';
        ctrl.newReceipt.receiptLine[0].expectedQuantity = '';
        ctrl.newReceipt.receiptLine[0].expectedLotCode = '';
        ctrl.newReceipt.receiptLine[0].expectedExpirationDate = '';
        ctrl.newReceipt.receiptLine[0].receiptLineNumber = "0001";
        var receiptLineCount = ctrl.newReceipt.receiptLine.length;
        for(var i = 1; i< receiptLineCount; i++){
            ctrl.newReceipt.receiptLine.splice(1, 1);
        }
        ctrl.disableCustomerAutoComplete = true;
        ctrl.newReceipt.customerContactName = '';
        ctrl.newReceipt.customerId = '';
    };

    var hasErrorClass = function (field) {
        if (ctrl.createReceiptForm[field]) {
            return ctrl.createReceiptForm[field].$touched && ctrl.createReceiptForm[field].$invalid;
        }
        
    };

    var showMessages = function (field) {
        return ctrl.createReceiptForm[field].$touched || ctrl.createReceiptForm.$submitted;
    };

    var toggleItemIdPrompt = function (value) {
        ctrl.showItemIdPrompt = value;
    };
    var toggleReceiptLineNumberPrompt = function (value) {
        ctrl.showReceiptLineNumberPrompt = value;
    };
    var toggleUomPrompt = function (value) {
        ctrl.showUomPrompt = value;
    };

    var toggleExpectedQuantityPrompt = function (value) {
        ctrl.showExpectedQuantityPrompt = value;
    };
    var toggleExpectedLotCodePrompt = function (value) {
        ctrl.showExpectedLotCodePrompt = value;
    };
    var toggleExpectedExpirationDatePrompt = function (value) {
        ctrl.showExpectedExpirationDatePrompt = value;
    };

    var toggleReceiptIdPrompt = function (value) {
        ctrl.showReceiptIdPrompt = value;
    };

    var toggleReceiptDatePrompt = function (value) {
        ctrl.showReceiptDatePrompt = value;
    };

    var toggleInboundTruckIdPrompt = function (value) {
        ctrl.showInboundTruckIdPrompt = value;
    };

    var toggleInboundProNumberPrompt = function (value) {
        ctrl.showInboundProNumberPrompt = value;
    };


    var getReceiptTypes = function () {
        $http({
            method: 'GET',
            url: '/receiving/getReceiptTypes'
        })
            .success(function (data, status, headers, config) {
                $scope.receiptTypList = data;
            })
    };

    ctrl.receiveSaveBtnText = 'Receive';
    var saveReceivedInventory = function () {
        if(ctrl.receiveInventoryCaseId == ctrl.receiveInventoryPalletId){
            ctrl.receiveInventory.$valid = false;
        }

        if (ctrl.receiptExpectedLotCode && (ctrl.receiptExpectedLotCode != ctrl.receiveInventoryLotCode)) {
            ctrl.receiveInventory.$valid = false;
        }
        
        if(ctrl.receiveInventory.$valid) {
            ctrl.disableReceivedBtn = true;
            ctrl.receiveSaveBtnText = 'Receiving..';

            $http({
                method  : 'POST',
                url     : '/receiving/saveReceiveInventory',
                params: {receiptLineId:ctrl.receiptLineIdForView,
                    palletId:ctrl.receiveInventoryPalletId,
                    caseId: ctrl.receiveInventoryCaseId,
                    uom:ctrl.receiveInventoryUom,
                    quantity:ctrl.receiveInventoryQty,
                    lotCode:ctrl.receiveInventoryLotCode,
                    expirationDate:ctrl.receiveInventoryExpireDate,
                    inventoryStatus:ctrl.receiveInventoryStatus,
                    itemId:ctrl.receiptItemForView,
                    itemNote:ctrl.receiveInventoryItemNotes},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(data) {
                    //ctrl.receiveInventoryPalletId = "";
                    ctrl.receiveInventoryCaseId = "";
                    ctrl.receiveInventoryItemNotes = ''


                    ctrl.receiveInventory.$setUntouched();
                    ctrl.receiveInventory.$setPristine();

                    ctrl.receivedInventoryNotify = true;
                    $timeout(function(){
                        ctrl.receivedInventoryNotify = false;
                    }, 5000);


                    $http({
                        method: 'GET',
                        url: '/receiving/getReceiveInventoryForSearchRow',
                        params: {selectedRowReceiptLine: ctrl.receiptLineIdForView}

                    })

                        .success(function(data) {
                            $scope.gridOptions.data = data;

                        });

                    $http({
                        method: 'GET',
                        url: '/receiving/calculateReceivedInventoryQty',
                        params: {selectedRowReceiptLine: ctrl.receiptLineIdForView, itemId:ctrl.receiptItemForView}
                    })
                        .success(function(data) {
                            ctrl.qtyCalculatedData = data;

                        });

                    $http({
                        method: 'GET',
                        url: '/receiving/getReceiptLineNumberForSearchRow',
                        params : {selectedRowReceipt:ctrl.receiptIdForView}
                    })
                        .success(function(data) {
                            ctrl.getExpandedRow.subGridOptions.data = data;
                        });

            $http({
                method : 'GET',
                url : '/item/findItem',
                params: {itemId: ctrl.receiptItemForView}
            })
                .success(function (data, status, headers, config) {

                    if(data.length > 0){
                        
                        if(data[0].isCaseTracked){
                            ctrl.receiveInventoryQty = "1";
                            ctrl.receiveInventoryQtyDisabled = true;
                            ctrl.receiveInventoryCaseId = "";
                            ctrl.receiveInventoryCaseIdDisabled = false;
                            ctrl.receiveInventoryPalletId = null;

                        }else{
                            ctrl.receiveInventoryCaseIdDisabled = true;
                            ctrl.receiveInventoryQtyDisabled = false;
                            ctrl.receiveInventoryQty = ''

                            $http({
                                method: 'GET',
                                url: '/company/getCurrentUserCompany',
                            })

                            .success(function(data) {

                                if (data.autoLoadPalletId == true) {
                                    ctrl.receiveInventoryPalletId = alphanumericGenerator().toUpperCase();
                                }
                                else{
                                    ctrl.receiveInventoryPalletId = null;
                                }                    

                            });

                        }

                        if(ctrl.receiveInventoryUom.toUpperCase() == 'EACH'){

                            ctrl.receiveInventoryQtyDisabled = false;
                            ctrl.receiveInventoryQty = ''

                        }else if(ctrl.receiveInventoryUom.toUpperCase() == 'PALLET'){
                            ctrl.receiveInventoryQty = "1";
                            ctrl.receiveInventoryQtyDisabled = true;
                        }
                        
                    }

                });                   

                        search();

                })
                .finally(function () {
                    ctrl.disableReceivedBtn = false;
                    ctrl.receiveSaveBtnText = 'Receive';
                });

        }
    };

    ctrl.IsLotCodeInValid = false;
    ctrl.validateExpLotcode = function(){
        if (ctrl.receiveInventoryLotCode) {
            if (ctrl.receiptExpectedLotCode && (ctrl.receiptExpectedLotCode != ctrl.receiveInventoryLotCode)) {
                ctrl.IsLotCodeInValid = true;
            }
            else{
                ctrl.IsLotCodeInValid = false;
            }
        }
        
    }

    ctrl.barcodeScanInput = function(event){
        if (event.keyCode === 13) {
            event.preventDefault();
        }

    };

    var displayNoteInput = function(){
        $('#getItemNotes').appendTo("body").modal('show');
    };

    ctrl.getPopoverTemplateUrl = "notesPopover";

    ctrl.clearOverrideOnFocus = function(){
        ctrl.putawayInventoryUserDefined.$setPristine();
        ctrl.putawayInventoryUserDefined.$setUntouched();
        ctrl.putawayInventoryUserDefined.putawayUserLocation.$setValidity('locationIdExists', true);
        ctrl.disableOverridePutaway = true;
    };

    ctrl.overrideOnFocus = function(){
        ctrl.putawayInventory.$setPristine();
        ctrl.putawayInventory.$setUntouched();
        ctrl.disableOverridePutaway = false;
    };

    var savePutawayInventoryUserDefined = function () {
        
        if( ctrl.putawayInventoryUserDefined.$valid) {

            if (ctrl.overrideLocationIdData.length > 0 && ctrl.overrideLocationIdData[0].is_bin && (ctrl.itemDataRow.lowestUom.toUpperCase() == 'CASE' || ctrl.itemDataRow.isCaseTracked == true)) {
                ctrl.lowestUomCaseForBin = true;
            }

            else{
                ctrl.disableOverridePutaway = true;
                $http({
                    method  : 'POST',
                    url     : '/receiving/savePutaway',
                    params: {lpn: ctrl.putawayInventoryLpnId,
                        caseId:ctrl.putawayInventoryCaseId,
                        locationId: ctrl.putawayUserLocation,
                        receiveInventoryId: ctrl.putawayReceiveInventoryId},
                    //params: {lpn: 'caseB',
                    //        locationId: 'lo2',
                    //        receiveInventoryId: 'foy000002'},

                    dataType: 'json',
                    headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                })
                    .success(function(data) {

                        //ctrl.receivedInventoryNotify = true;
                        //$timeout(function(){
                        //    ctrl.receivedInventoryNotify = false;
                        //}, 1000);


                        $http({
                            method: 'GET',
                            url: '/receiving/getReceiveInventoryForSearchRow',
                            params: {selectedRowReceiptLine: ctrl.receiptLineIdForView}

                        })

                            .success(function(data) {
                                $scope.gridOptions.data = data;

                            });

                        ctrl.lowestUomCaseForBin = false;
                        $('#putAwayModal').appendTo("body").modal('hide');
                        ctrl.putawayInventoryUserDefined.$setPristine();
                        ctrl.putawayInventoryUserDefined.$setUntouched();
                        if(ctrl.isPendingPutaway == true){

                            loadPendingPutaway();
                            ctrl.showPutawaySuccess = true;
                            $timeout(function(){
                               ctrl.showPutawaySuccess = false;
                            }, 5000);
                        }

                    })
                    .finally(function () {
                        ctrl.disableOverridePutaway = false;
                    }); 

            }
        }
    };

    var savePutawayInventory = function () {

        if( ctrl.putawayInventory.$valid && ctrl.putawaySystemLocation) {
            ctrl.disableConfirmPutaway = true;
            $http({
                method  : 'POST',
                url     : '/receiving/savePutaway',
                params: {lpn: ctrl.putawayInventoryLpnId,
                    caseId:ctrl.putawayInventoryCaseId,
                    locationId: ctrl.confirmLocationId,
                    receiveInventoryId: ctrl.putawayReceiveInventoryId},

                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(data) {

                    //ctrl.receivedInventoryNotify = true;
                    //$timeout(function(){
                    //    ctrl.receivedInventoryNotify = false;
                    //}, 1000);


                    $http({
                        method: 'GET',
                        url: '/receiving/getReceiveInventoryForSearchRow',
                        params: {selectedRowReceiptLine: ctrl.receiptLineIdForView}

                    })

                        .success(function(data) {
                            $scope.gridOptions.data = data;

                        });

                    $('#putAwayModal').appendTo("body").modal('hide');
                    ctrl.putawayInventory.$setPristine();
                    ctrl.putawayInventory.$setUntouched();

                    if(ctrl.isPendingPutaway == true){

                        loadPendingPutaway();
                        ctrl.showPutawaySuccess = true;
                        $timeout(function(){
                            ctrl.showPutawaySuccess = false;
                        }, 5000);
                    }


                })
                .finally(function () {
                    ctrl.disableConfirmPutaway = false;
                }); 

        }
    };

    var showMessagesForReceive = function (field) {
        return ctrl.receiveInventory[field].$touched || ctrl.receiveInventory.$submitted;
    };

    var hasErrorClassForReceive = function (field) {
        return ctrl.receiveInventory[field].$touched && ctrl.receiveInventory[field].$invalid;
    };

    var showMessagesForPutaway = function (field) {
        return ctrl.putawayInventoryUserDefined[field].$touched || ctrl.putawayInventoryUserDefined.$submitted;
    };

    var hasErrorClassForPutaway = function (field) {
        return ctrl.putawayInventoryUserDefined[field].$touched && ctrl.putawayInventoryUserDefined[field].$invalid;
    };

    ctrl.showMessagesForReceive = showMessagesForReceive;
    ctrl.hasErrorClassForReceive = hasErrorClassForReceive;
    ctrl.showMessagesForPutaway = showMessagesForPutaway;
    ctrl.hasErrorClassForPutaway = hasErrorClassForPutaway;

    ctrl.showItemIdPrompt = -1;
    ctrl.showReceiptLineNumberPrompt = -1;
    ctrl.showUomPrompt = -1;
    ctrl.showExpectedQuantityPrompt = -1;
    ctrl.showExpectedLotCodePrompt = -1;
    ctrl.showExpectedExpirationDatePrompt = -1;
    ctrl.showReceiptIdPrompt = false;
    ctrl.showReceiptDatePrompt = false;
    ctrl.showInboundTruckIdPrompt = false;
    ctrl.showInboundProNumberPrompt = false;


    ctrl.toggleItemIdPrompt = toggleItemIdPrompt;
    ctrl.toggleReceiptLineNumberPrompt = toggleReceiptLineNumberPrompt;
    ctrl.toggleUomPrompt = toggleUomPrompt;
    ctrl.toggleExpectedQuantityPrompt = toggleExpectedQuantityPrompt;
    ctrl.toggleExpectedLotCodePrompt = toggleExpectedLotCodePrompt;
    ctrl.toggleExpectedExpirationDatePrompt = toggleExpectedExpirationDatePrompt;
    ctrl.toggleReceiptIdPrompt = toggleReceiptIdPrompt;
    ctrl.toggleReceiptDatePrompt = toggleReceiptDatePrompt;
    ctrl.toggleInboundTruckIdPrompt = toggleInboundTruckIdPrompt;
    ctrl.toggleInboundProNumberPrompt = toggleInboundProNumberPrompt;


    ctrl.saveReceivedInventory = saveReceivedInventory;
    ctrl.savePutawayInventoryUserDefined = savePutawayInventoryUserDefined;
    ctrl.savePutawayInventory = savePutawayInventory;


    ctrl.hasErrorClass = hasErrorClass;
    ctrl.showMessages = showMessages;
    ctrl.newReceipt = newReceipt;
    ctrl.createReceipt = createReceipt;
    ctrl.clearForm = clearForm;
    ctrl.displayNoteInput = displayNoteInput;

    ctrl.disableCustomerAutoComplete = true;
    ctrl.disableCustomerAutoCompleteEdit = false;
    ctrl.validateReceiptType = function(){
        if (ctrl.newReceipt.receiptType) {
            ctrl.disableCustomerAutoComplete = false;
        }
        else{
            ctrl.newReceipt.customerContactName = '';
            ctrl.newReceipt.customerId = '';
            ctrl.disableCustomerAutoComplete = true;
        }
    };

    ctrl.validateReceiptTypeEdit = function(){
        if (ctrl.editReceipt.receiptType) {
            ctrl.disableCustomerAutoCompleteEdit = false;
        }
        else{
            ctrl.editReceipt.customerContactName = '';
            ctrl.editReceipt.customerId = '';
            ctrl.disableCustomerAutoCompleteEdit = true;
        }
    };

    ctrl.addNewFieldNum = 1;

    var getNewField = function(number){
        return new Array(number);
    };

    var addNewField = function(index){
        ctrl.addNewFieldNum++;
        document.getElementById("addNewLine").blur();
        //document.getElementById("receiptLineNumber"+index).focus();
        var increIndex = index + 2;
        var strNum = increIndex.toString();
        var zeros = '0000';
        var zeroPad = zeros.slice(strNum.length);
        var receiptLineId = zeroPad+strNum;
        ctrl.receiptLineNumberList[index+1] = receiptLineId;
        ctrl.focusVal = index + 1;
    };


    ctrl.getNewField = getNewField;
    ctrl.addNewField = addNewField;




    var validateItemId = function(itemId,index, isEdit){
        checkIsItemLotCodeTracked(itemId,index);
        checkIsItemExpired(itemId,index);
        checkItemLowestUom(itemId,index,isEdit);
    };

    var checkReceiptLineIdUnique = function(input,index){
        checkReceiptLineNumExist(input,index);
    };

    ctrl.validateItemId = validateItemId;
    ctrl.checkReceiptLineIdUnique = checkReceiptLineIdUnique;

    var deleteReceiptLineRaw = function(index){

        for(var i = index+1; i < ctrl.newReceipt.receiptLine.length; i++){
            if (ctrl.newReceipt.receiptLine[i] != null) {
                validateItemId(ctrl.newReceipt.receiptLine[i].itemId, i-1);
            }
        }

        ctrl.newReceipt.receiptLine.splice(index, 1);
        if(ctrl.newReceipt.receiptLine.length > 0){
            ctrl.addNewFieldNum = ctrl.addNewFieldNum-1;
        }
    };

    var deleteReceiptLineRawEdit = function(index){

        if(ctrl.editReceipt.receiptLine[index].receiptLineId != null){

            $http({
                method: 'GET',
                url: '/receiving/checkIsInventoryExistForReceiptLine',
                params : {selectedReceiptLineId: ctrl.receiptLineData[index].receiptLineId}
            })

                .success(function (data, status, headers, config) {
                    ctrl.isInventoryExistForReceiptLine = data;

                    if(ctrl.isInventoryExistForReceiptLine.length > 0) {
                        $('#receiptLineDeleteWarning').appendTo("body").modal('show');

                    }
                    else{

                        for(var i = index+1; i < ctrl.editReceipt.receiptLine.length; i++){
                            if (ctrl.editReceipt.receiptLine[i] != null) {
                                validateItemId(ctrl.editReceipt.receiptLine[i].itemId, i-1);
                            }
                        }

                        ctrl.editReceipt.removedReceiptLineIds.push(ctrl.editReceipt.receiptLine[index].receiptLineId);
                        ctrl.editReceipt.receiptLine.splice(index, 1);
                        ctrl.receiptLineData.splice(index, 1);
                        if(ctrl.editReceipt.receiptLine.length > 0){
                            ctrl.addNewFieldNum = ctrl.addNewFieldNum-1;
                        }

                    }
                })

        }

        else{
            for(var i = index+1; i < ctrl.editReceipt.receiptLine.length; i++){
                if (ctrl.editReceipt.receiptLine[i] != null) {
                    validateItemId(ctrl.editReceipt.receiptLine[i].itemId, i-1);
                }
            }

            ctrl.editReceipt.removedReceiptLineIds.push(ctrl.editReceipt.receiptLine[index].receiptLineId);
            ctrl.editReceipt.receiptLine.splice(index, 1);
            ctrl.receiptLineData.splice(index, 1);
            if(ctrl.editReceipt.receiptLine.length > 0){
                ctrl.addNewFieldNum = ctrl.addNewFieldNum-1;
            }

        }

    };



    ctrl.deleteReceiptLineRaw = deleteReceiptLineRaw;
    ctrl.deleteReceiptLineRawEdit = deleteReceiptLineRawEdit;

    //*************end receipt create function******************

    //*************start receipt edit function******************
    $scope.HideEditForm = function () {
        clearFormEdit();
        ctrl.editReceiptState = false;
        ctrl.editReceipt.receiptType = null;
        ctrl.addNewFieldNum = 1;
        //ctrl.showUpdatedPrompt = false;
    };

    var getAllReceiptLineData = function(receiptId){

        $http({
            method: 'GET',
            url: '/receiving/getReceiptLineNumbers',
            params : {selectedReceiptId: receiptId}
        })
            .success(function(data, status, headers, config) {
                ctrl.receiptLineData = data;
                ctrl.editReceipt.receiptLine[0] = {};
                ctrl.addNewFieldNum = ctrl.receiptLineData.length;
                ctrl.editReceipt.receiptLine[0].receiptLineId = ctrl.receiptLineData[0].receiptLineId;
                ctrl.editReceipt.receiptLine[0].receiptLineNumber = ctrl.receiptLineData[0].receiptLineNumber;
                ctrl.editReceipt.receiptLine[0].itemId = ctrl.receiptLineData[0].itemId;
                ctrl.editReceipt.receiptLine[0].expectedQuantity = ctrl.receiptLineData[0].expectedQuantity;
                ctrl.editReceipt.receiptLine[0].uom = ctrl.receiptLineData[0].uom;
                ctrl.editReceipt.receiptLine[0].expectedLotCode = ctrl.receiptLineData[0].expectedLotCode;
                if (ctrl.receiptLineData[0].expectedExpirationDate == null){
                    ctrl.editReceipt.receiptLine[0].expectedExpirationDate = null;
                }
                else{
                    ctrl.editReceipt.receiptLine[0].expectedExpirationDate = new Date(ctrl.receiptLineData[0].expectedExpirationDate);
                }
                ctrl.validateItemId(ctrl.editReceipt.receiptLine[0].itemId, 0, true);

                for (var i = 0; i < ctrl.receiptLineData.length; i++) {
                    ctrl.receiptLineNumberListEdit[i] = ctrl.receiptLineData[i].receiptLineNumber;
                }
            });


    };

    var ctrl = this,
        editReceipt = { receiptId:'', receiptDate:'', inboundTruckId:'', inboundProNumber:'', receiptLine:[], removedReceiptLineIds:[]};
    getReceiptTypes();
    var getRowToDelete;

    $scope.EditReceipt = function(row) {
        $scope.IsVisible = false;
        //getReceiptTypes();
        //Check Current User
        $http.get('/user/getCurrentUser')
            .success(function(data) {

                ctrl.showUpdatedPrompt = false;
                ctrl.showCompletedPrompt = false;
                ctrl.showSubmittedPrompt = false;
                ctrl.showDeletedPrompt = false;

                $http({
                    method: 'GET',
                    url: '/receiving/checkIsReceiptCompleted',
                    params : {selectedReceiptId: row.entity.receipt_id}
                })
                    .success(function(data, status, headers, config) {
                        ctrl.isReceiptCompleted = data;

                        if (ctrl.isReceiptCompleted.length > 0) {
                            ctrl.editReceiptState = false;
                            ctrl.editReceipt.receiptType = null;
                            $('#receiptEditWarning').appendTo("body").modal('show');
                        }

                        else{

                            if (row.entity.customer_id) {
                                $http({
                                    method: 'GET',
                                    url: '/customer/getCustomerByIdAndCompany',
                                    params: {customerId: row.entity.customer_id}
                                })
                                .success(function(data) {
                                    if (data.length > 0) {
                                        ctrl.editReceipt.customerId = data[0].customer_id;
                                        ctrl.editReceipt.customerContactName  = data[0].contact_name+' - '+data[0].company_name;
                                    }
                                    else{
                                        ctrl.editReceipt.customerId = '';
                                        ctrl.editReceipt.customerContactName  = '';
                                    }
                                });
                            }
                            else{
                                ctrl.editReceipt.customerContactName  = '';
                            }

                            ctrl.receiptLineNumberListEdit = [];
                            ctrl.isExpired = [];
                            ctrl.lotCodeTracked = [];
                            ctrl.lowestUomEach = [];
                            ctrl.isReceiptLineIdExist = [];
                            //loadItemAutoComplete();
                            getAllReceiptLineData(row.entity.receipt_id);
                            ctrl.editReceiptState = true;
                            //getReceiptTypes();
                            ctrl.editReceipt.receiptId = row.entity.receipt_id;
                            ctrl.editReceipt.receiptDate = new Date(row.entity.receipt_date);
                            ctrl.editReceipt.inboundTruckId = row.entity.inbound_truck_id;
                            ctrl.editReceipt.inboundProNumber = row.entity.inbound_pro_number;
                            ctrl.editReceipt.receiptType = row.entity.receipt_type;
                            if (!row.entity.receipt_type) {
                                ctrl.disableCustomerAutoCompleteEdit = true;
                            }
                            else{
                                ctrl.disableCustomerAutoCompleteEdit = false;
                            }
                            ctrl.editReceipt.removedReceiptLineIds = [];

                            ctrl.receiptIdForMessageEdit = row.entity.receipt_id;
                            getRowToDelete = row.entity;

                        }
                    });

            });
    };



    var updateReceipt = function () {

        ctrl.receiptIdForMessageEdit = ctrl.editReceipt.receiptId;

        if (ctrl.editReceipt.inboundTruckId == '') {
            ctrl.editReceipt.inboundTruckId = null;
        }

        if (ctrl.editReceipt.inboundProNumber == '') {
            ctrl.editReceipt.inboundProNumber = null;
        }

        if (ctrl.editReceipt.receiptType == '') {
            ctrl.editReceipt.receiptType = null;
        }

        if( ctrl.editReceiptForm.$valid) {

            ctrl.disableReceiptUpdateBtn = true;

            $http({
                method  : 'POST',
                url     : '/receiving/updateReceipt',
                data    :  $scope.ctrl.editReceipt,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {

                    ctrl.editReceiptState = false;
                    ctrl.editReceipt.receiptType = null;
                    ctrl.showUpdatedPrompt = true;
                    clearFormEdit();
                    ctrl.addNewFieldNum = 1;
                    search();

                })
                .finally(function(){
                    ctrl.disableReceiptUpdateBtn = false;
                });

        }
    };

    var clearFormEdit = function(){
        ctrl.editReceipt = { receiptId:'', receiptDate:'', inboundTruckId:'', inboundProNumber:'', receiptType: null, customerId: null, receiptLine:[], removedReceiptLineIds:[]};
        ctrl.isExpired = [];
        ctrl.lotCodeTracked = [];
        ctrl.lowestUomEach = [];
        ctrl.receiptLineNumberListEdit = [];
        ctrl.editReceiptForm.$setUntouched();
        ctrl.editReceiptForm.$setPristine();
    };

    var hasErrorClassEdit = function (field) {
        if (ctrl.editReceiptForm[field]) {
            return ctrl.editReceiptForm[field].$touched && ctrl.editReceiptForm[field].$invalid;
        }
        
    };

    var showMessagesEdit = function (field) {
        if (ctrl.editReceiptForm[field]) {
            return ctrl.editReceiptForm[field].$touched || ctrl.editReceiptForm.$submitted;
        }
        
    };




    var toggleReceiptIdPromptEdit = function (value) {
        ctrl.showReceiptIdPromptEdit = value;
    };

    var toggleReceiptDatePromptEdit = function (value) {
        ctrl.showReceiptDatePromptEdit = value;
    };

    var toggleInboundTruckIdPromptEdit = function (value) {
        ctrl.showInboundTruckIdPromptEdit = value;
    };

    var toggleInboundProNumberPromptEdit = function (value) {
        ctrl.showInboundProNumberPromptEdit = value;
    };

    ctrl.showUpdatedPrompt = false;
    ctrl.showReceiptIdPromptEdit = false;
    ctrl.showReceiptDatePromptEdit = false;
    ctrl.showInboundTruckIdPromptEdit = false;
    ctrl.showInboundProNumberPromptEdit = false;

    ctrl.toggleReceiptIdPromptEdit = toggleReceiptIdPromptEdit;
    ctrl.toggleReceiptDatePromptEdit = toggleReceiptDatePromptEdit;
    ctrl.toggleInboundTruckIdPromptEdit = toggleInboundTruckIdPromptEdit;
    ctrl.toggleInboundProNumberPromptEdit = toggleInboundProNumberPromptEdit;


    ctrl.hasErrorClassEdit = hasErrorClassEdit;
    ctrl.showMessagesEdit = showMessagesEdit;
    ctrl.editReceipt = editReceipt;
    ctrl.clearForm = clearForm;
    ctrl.updateReceipt = updateReceipt;

    var convertDate = function(date){
        if (date != null) {
            return new Date(date);
        }
    };

    var addNewFieldEdit = function(index){
        ctrl.addNewFieldNum++;
        document.getElementById("addNewLineEdit").blur();
        var increIndex = index + 2;
        var strNum = increIndex.toString();
        var zeros = '0000';
        var zeroPad = zeros.slice(strNum.length);
        var receiptLineId = zeroPad+strNum;
        ctrl.receiptLineNumberListEdit[index+1] = receiptLineId;
        ctrl.focusVal = index + 1;

    };

    ctrl.addNewFieldEdit = addNewFieldEdit;
    ctrl.convertDate = convertDate;


    var validateReceiptLineExpectedQty = function(receiptLineId, qty){


        if (qty != undefined) {

            $http({
                method: 'GET',
                url: '/receiving/validateQuantityWithReceiptLine',
                params : {receiptLineId:receiptLineId, expectedQuantity: qty }
            })

                .success(function (data, status, headers, config) {
                    ctrl.checkReceiptLineExpectedQty = data;

                    if (ctrl.checkReceiptLineExpectedQty.length > 0) {
                        $('#receiptQuantityChangeWarning').appendTo("body").modal('show');
                    }

                })

        }


    };

    ctrl.validateReceiptLineExpectedQty = validateReceiptLineExpectedQty;


    var getRows;
    $scope.completeReceipt = function(row){
        getRows = row;

        $http({
            method: 'GET',
            url: '/receiving/checkInventoryExistForReceipt',
            params : {receiptId: row.entity.receipt_id}
        })

            .success(function (data, status, headers, config) {
                ctrl.isInventoryExistForReceipt = data;

                if (ctrl.isInventoryExistForReceipt.length > 0) {

                    $http({
                        method: 'GET',
                        url: '/receiving/getInappropriateQuantityReceiptLine',
                        params : {receiptId: row.entity.receipt_id}
                    })

                        .success(function (data, status, headers, config) {
                            ctrl.checkInappropriateQuantity = data;
                            if (ctrl.checkInappropriateQuantity.length > 0) {
                                $('#receiptCompleteQtyWarning').appendTo("body").modal('show');
                            }
                            else{
                                $('#receiptComplete').appendTo("body").modal('show');
                            }

                        })


                }


                else{
                    $('#receiptCompleteWarning').appendTo("body").modal('show');
                }


            })



    };

    $scope.reOpenReceipt = function(row){
        getRows = row;
        $('#receiptReOpenWarning').appendTo("body").modal('show');
    }

    $scope.checkReceiptCompletedState = function(row){
        if (row.entity.grid_status == 'Open') {
            return true
        }
        else{
            return false
        }

    };


    $("#receiptCompleteButton").click(function(){

        ctrl.receiptIdForMessageEdit = getRows.entity.receipt_id;

        $http({
            method  : 'POST',
            url     : '/receiving/completeReceipt',
            data    :  {receiptId: getRows.entity.receipt_id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                ctrl.editReceiptState = false;
                ctrl.editReceipt.receiptType = null;
                ctrl.showCompletedPrompt = true;
                clearFormEdit();
                ctrl.addNewFieldNum = 1;
                search();
                $('#receiptComplete').modal('hide');
            })
    });

    $("#receiptCompleteWarningButton").click(function(){

        ctrl.receiptIdForMessageEdit = getRows.entity.receipt_id;

        $http({
            method  : 'POST',
            url     : '/receiving/completeReceipt',
            data    :  {receiptId: getRows.entity.receipt_id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                ctrl.editReceiptState = false;
                ctrl.editReceipt.receiptType = null;
                ctrl.showCompletedPrompt = true;
                clearFormEdit();
                ctrl.addNewFieldNum = 1;
                search();
                $('#receiptCompleteWarning').modal('hide');
            })
    });

    $("#receiptReOpenWarningButton").click(function(){
        ctrl.receiptIdForMessageEdit = getRows.entity.receipt_id;

        $http({
            method  : 'POST',
            url     : '/receiving/reOpenReceipt',
            data    :  {receiptId: getRows.entity.receipt_id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                ctrl.editReceiptState = false;
                ctrl.editReceipt.receiptType = null;
                ctrl.showReOpenedPrompt = true;
                clearFormEdit();
                ctrl.addNewFieldNum = 1;
                search();
                $('#receiptReOpenWarning').modal('hide');
                $timeout(function(){
                    ctrl.showReOpenedPrompt = false;
                }, 5000);  
            })
    });

    $("#receiptCompleteQtyWarningButton").click(function(){

        ctrl.receiptIdForMessageEdit = getRows.entity.receipt_id;

        $http({
            method  : 'POST',
            url     : '/receiving/completeReceipt',
            data    :  {receiptId: getRows.entity.receipt_id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                ctrl.editReceiptState = false;
                ctrl.editReceipt.receiptType = null;
                ctrl.showCompletedPrompt = true;
                clearFormEdit();
                ctrl.addNewFieldNum = 1;
                search();
                $('#receiptCompleteQtyWarning').modal('hide');
            })
    });

//**********end Receipt edit****************************

//**********start Receipt Delete****************************

    var deleteReceipt = function(){

        $http({
            method: 'GET',
            url: '/receiving/checkInventoryExistForReceipt',
            params : {receiptId: ctrl.editReceipt.receiptId}
        })

            .success(function (data, status, headers, config) {
                ctrl.isInventoryExistForReceiptWhenDelete = data;

                if (ctrl.isInventoryExistForReceiptWhenDelete.length > 0) {
                    $('#receiptDeleteWarning').appendTo("body").modal('show');
                }
                else{
                    $('#receiptDelete').appendTo("body").modal('show');
                }

            })


    };

    ctrl.deleteReceipt = deleteReceipt;

    $("#deleteReceiptButton").click(function(){
        ctrl.receiptIdForMessage = ctrl.newReceipt.receiptId;

        $http({
            method  : 'POST',
            url     : '/receiving/deleteReceipt',
            data    :  {receiptId: ctrl.editReceipt.receiptId},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                ctrl.editReceiptState = false;
                ctrl.editReceipt.receiptType = null;
                ctrl.showDeletedPrompt = true;
                clearFormEdit();
                ctrl.addNewFieldNum = 1;
                $('#receiptDelete').modal('hide');
                var index = $scope.gridItem.data.indexOf(getRowToDelete);
                $scope.gridItem.data.splice(index, 1);
            })

    });

//**********end Receipt Delete******************************



//*******************start search receipt***************************

    var disableFindButton = function () {
        ctrl.disabledFind = ctrl.receiptId || ctrl.receiptDate || ctrl.status ? false : true;
    };

    ctrl.disabledFind = true;
    ctrl.disableFindButton = disableFindButton;



    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };

//start grid

    $scope.gridItem = {
        expandableRowTemplate: "<div id='receiptLineGrid' ui-grid='row.entity.subGridOptions' style='height:250px;'></div>",
        expandableRowHeight: 250,

        enableRowSelection: true,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 100],
        paginationPageSize: $scope.totalGridDataVal,
        useExternalPagination: true,

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
            {name:'Receipt Number', field: 'receipt_id'},
            {name:'Receipt Date' , field: 'receipt_date',type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Receipt Status', cellTemplate:'<div style="color: #9b9b9b; padding-left:10px;"><div style="display: inline-block; padding-top: 10px;">{{row.entity.grid_status}}</div>&emsp;<div ng-if="row.entity.leastReceivedQtyStatus==\'equal\'" class="fullyReceivedDiv"><span style="padding-left:5px;"><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/fully_received.svg"></em>&nbsp;Fully Received</span></div><div ng-if="row.entity.leastReceivedQtyStatus==\'partiallyReceived\'" class="partiallyReceivedDiv"><span style="padding-left:5px;"><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/partially_received.svg"></em>&nbsp;Partially Received</span></div><div ng-if="row.entity.leastReceivedQtyStatus==\'notReceived\'" class="notReceivedDiv"><span style="padding-left:5px;"><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/not_received.svg"></em></span>&nbsp;Not Received</div><div ng-if="row.entity.leastReceivedQtyStatus==\'overReceived\'" class="overReceivedDiv"><span style="padding-left:5px;"><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/over_received.svg"></em>&nbsp;Over Received</span></div></div>'},
            {name:'Receipt Type', field: 'receipt_type'},
            {name: 'Actions', enableSorting: false,  cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.EditReceipt(row)">Edit</a></li><li ng-if="grid.appScope.checkReceiptCompletedState(row)"><a href="javascript:void(0);" ng-click="grid.appScope.completeReceipt(row)">Close</a></li><li ng-if="grid.appScope.isCurrentUserAdmin && !grid.appScope.checkReceiptCompletedState(row)"><a href="javascript:void(0);" ng-click="grid.appScope.reOpenReceipt(row)">Re-Open</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.getReceiptDataReport(row)">Print</a></li></ul></div>'}
        ],

        onRegisterApi: function( gridApi ){

            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {

                if (row.isExpanded) {
                    ctrl.getExpandedRow = row.entity;
                    row.entity.subGridOptions = {
                        appScopeProvider: $scope.subGridScope,

                        columnDefs: [
                            {name:'Receipt Line Number', field: 'receipt_line_number', width: 200},
                            {name:'Item Id', field: 'item_id'},
                            {name:'Description', field: 'item_description'},
                            {name:'Lot Code', field: 'expected_lot_code'},
                            {name:'Expected Qty', field: 'expected_quantity'},
                            {name:'Received Qty', cellTemplate:'<div style="color: #9b9b9b; padding-top: 3px; padding-left: 10px; "><div style="display: inline-block; padding-top: 7px; ">{{row.entity.calculated_received_qty}}</div>&emsp;<div ng-if="grid.appScope.getStatusByRcQty(row)==\'fullyReceived\'" class="receiptStatusDivMin" style="background-color: #33c5c5;"><span><em class="fa  fa-fw" ><img src="/foysonis2016/app/img/fully_received.svg"></em></span></div><div ng-if="grid.appScope.getStatusByRcQty(row)==\'partiallyReceived\'" class="receiptStatusDivMin" style="background-color: #b6df6a;"><span><em class="fa  fa-fw" ><img src="/foysonis2016/app/img/partially_received.svg"></em></span></div><div ng-if="grid.appScope.getStatusByRcQty(row)==\'notReceived\'" class="receiptStatusDivMin" style="background-color: #f1e184;"><span><em class="fa  fa-fw" ><img src="/foysonis2016/app/img/not_received.svg"></em></span></div><div ng-if="grid.appScope.getStatusByRcQty(row)==\'overReceived\'" class="receiptStatusDivMin" style="background-color:#f49325;"><span><em class="fa  fa-fw" ><img src="/foysonis2016/app/img/over_received.svg"></em></span></div></div>'},
                            {name:'Uom', field: 'uom', width: 100},
                            {name:'Expiration Date', field: 'expected_expiration_date',type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
                            {name:'Actions',  cellTemplate: '<button  class="btn btn-xs btn-primary" style="padding: 2px 2px !important; margin: 2px 10px 0px 10px;" ng-click="grid.appScope.clickMeSub(row)">Receive / Putaway</button>'}
                        ]
                    };

                    $http({
                        method: 'GET',
                        url: '/receiving/getReceiptLineNumberForSearchRow',
                        params : {selectedRowReceipt: row.entity.receipt_id}
                    })
                        .success(function(data) {
                            row.entity.subGridOptions.data = data;
                            //ctrl.receiptLinesByRecpt = data;
                            var allReceiptLines = ctrl.allReceiptLinesByRecpts.concat(data);
                            ctrl.allReceiptLinesByRecpts = allReceiptLines;
                        });


                }
                else{
                    var receiptLinesToRemove = row.entity.subGridOptions.data
                    for (var i = 0; i < receiptLinesToRemove.length; i++) {
                        var indexToRemove = ctrl.allReceiptLinesByRecpts.indexOf(receiptLinesToRemove[i]);
                        if (indexToRemove > -1) {
                            ctrl.allReceiptLinesByRecpts.splice(indexToRemove,1);
                        }
                    }
                    //var allReceiptLines = ctrl.allReceiptLinesByRecpts.remove(row.entity.subGridOptions.data);
                    //ctrl.allReceiptLinesByRecpts = receiptLinesToRemove;

                }
            });


            // interval of zero just to allow the directive to have initialized
            $interval( function() {
                gridApi.core.addToGridMenu( gridApi.grid, [{ title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged( $scope, function( changedColumn ){
                $scope.columnChanged = { name: changedColumn.colDef.name, visible: changedColumn.colDef.visible };
            });

            gridApi.pagination.on.paginationChanged($scope, function (newPage, pageSize) {
               $scope.totalGridDataVal = pageSize;
               searchForPagination(newPage, pageSize);

            });
        }
    };



    var search = function () {

        if (ctrl.searchForm.$valid) {
            $http({
                method: 'POST',
                url: '/receiving/searchResults',
                params: {receiptId:ctrl.receiptId, receiptDate:ctrl.receiptDate, toReceiptDate:ctrl.toReceiptDate, status:ctrl.status, receiptType: ctrl.receiptType, currentPageNum:$scope.currentPageNum, totalRetrieveAmt:$scope.totalGridDataVal},
                data    :  $scope.ctrl,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    //$scope.gridItem.data = data;
                    $scope.gridItem.data = data.receiptSet;
                    $scope.gridItem.totalItems = data.totalResultCount;
                    $scope.gridItem.paginationCurrentPage = $scope.currentPageNum;
                    $scope.IsVisible = false;
                    ctrl.allReceiptLinesByRecpts = [];
                })
        }
    };

    ctrl.search = search;

    var searchForPagination = function (currentPageNum, totalRetrieveAmt) {

        if (ctrl.searchForm.$valid) {
            $http({
                method: 'POST',
                url: '/receiving/searchResults',
                params: {receiptId:ctrl.receiptId, receiptDate:ctrl.receiptDate, toReceiptDate:ctrl.toReceiptDate, status:ctrl.status, receiptType: ctrl.receiptType, currentPageNum:currentPageNum, totalRetrieveAmt:totalRetrieveAmt},
                data    :  $scope.ctrl,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    //$scope.gridItem.data = data;
                    $scope.gridItem.data = data.receiptSet;
                    $scope.gridItem.totalItems = data.totalResultCount;
                    $scope.IsVisible = false;
                    ctrl.allReceiptLinesByRecpts = [];
                })
        }
    };    

    var loadGridData = function (){
        $http({
            method: 'POST',
            url: '/receiving/searchResults',
            params: {currentPageNum:$scope.currentPageNum, totalRetrieveAmt:$scope.totalGridDataVal},
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                //$scope.gridItem.data = data.splice(0,10000);
                $scope.gridItem.data = data.receiptSet;
                $scope.gridItem.totalItems = data.totalResultCount;

            })
    };
    loadGridData();

//end of the grid

    var findWithAttribute = function(array, attr, value) {
        for(var i = 0; i < array.length; i += 1) {
            if(array[i][attr] === value) {
                return i;
            }
        }
        return -1;
    };

    var alphanumericGenerator = function() {
        return Math.random().toString(36).split('').filter( function(value, index, self) { 
            return self.indexOf(value) === index;
        }).join('').substr(2,10);
    }


    ctrl.allReceiptLinesByRecpts = [];

    ctrl.switchReceiptLine = function(navigate){
        if ((ctrl.receptLineIndex != null) && (parseInt(ctrl.receptLineIndex) != -1)) {
            if (navigate == 'next') {
                if (parseInt(ctrl.receptLineIndex) < ctrl.receiptLinesByRecpt.length -1) {
                    ctrl.receptLineIndex ++; 
                }
               
            }
            else if (navigate == 'prev') {
                if (parseInt(ctrl.receptLineIndex) > 0) {
                    ctrl.receptLineIndex --;
                }
                
            }

            ctrl.receiptLineNoForView = ctrl.receiptLinesByRecpt[ctrl.receptLineIndex].receipt_line_number;
            ctrl.receiptLineIdForView = ctrl.receiptLinesByRecpt[ctrl.receptLineIndex].receipt_line_id;
            ctrl.receiptIdForView = ctrl.receiptLinesByRecpt[ctrl.receptLineIndex].receipt_id;
            ctrl.receiptItemForView = ctrl.receiptLinesByRecpt[ctrl.receptLineIndex].item_id;
            ctrl.receiptExpectedQty = ctrl.receiptLinesByRecpt[ctrl.receptLineIndex].expected_quantity;
            ctrl.receiptUom = ctrl.receiptLinesByRecpt[ctrl.receptLineIndex].uom;
            ctrl.receiptClosed = ctrl.receiptLinesByRecpt[ctrl.receptLineIndex].complete_date ? true : false;

            //ctrl.receiveInventoryPalletId = null;
            ctrl.receiveInventoryCaseId = null;
            ctrl.receiveInventoryQty = null;
            ctrl.receiveInventoryUom = null;
            ctrl.receiveInventoryLotCode = null;
            ctrl.receiveInventoryExpireDate = null;
            ctrl.receiveInventoryStatus = null;

            ctrl.viewGrid = true;
            //ctrl.receptLineIndex = findWithAttribute(ctrl.receiptLinesByRecpt, 'receipt_line_id', ctrl.receiptLineIdForView);
            //alert(ctrl.receptLineIndex);

            $http({
                method : 'GET',
                url : '/item/findItem',
                params: {itemId: ctrl.receiptLinesByRecpt[ctrl.receptLineIndex].item_id}
            })
                .success(function (data, status, headers, config) {

                    if(data.length > 0){

                        ctrl.itemDataRow = data[0];
                        ctrl.receiveInventoryExpireDateDisabled = !data[0].isExpired;
                        ctrl.receiveInventoryLotCodeDisabled = !data[0].isLotTracked;
                        ctrl.receiptItemDescriptionForView = data[0].itemDescription;

                        
                        if(data[0].isCaseTracked){
                            ctrl.receiveInventoryCaseId = "";
                            ctrl.receiveInventoryCaseIdDisabled = false;
                            ctrl.receiveInventoryPalletId = null;


                            if(data[0].lowestUom.toUpperCase() == 'EACH'){

                                ctrl.receiveInventoryQty = "";
                                ctrl.receiveInventoryQtyDisabled = false;

                                $scope.data = {
                                    availableOptions: [
                                        {id: 'EACH', name: 'EACH'},
                                        {id: 'CASE', name: 'CASE'}
                                    ]
                                };
                            }else if(data[0].lowestUom.toUpperCase() == 'CASE'){

                                ctrl.receiveInventoryQty = "1";
                                ctrl.receiveInventoryQtyDisabled = true;

                                $scope.data = {
                                    availableOptions: [
                                        {id: 'CASE', name: 'CASE'}
                                    ]
                                };

                            }


                        }else{
                            ctrl.receiveInventoryCaseIdDisabled = true;
                            ctrl.receiveInventoryQtyDisabled = false;

                            $http({
                                method: 'GET',
                                url: '/company/getCurrentUserCompany',
                            })

                            .success(function(data) {

                                if (data.autoLoadPalletId == true) {
                                    ctrl.receiveInventoryPalletId = alphanumericGenerator().toUpperCase();
                                }
                                else{
                                    ctrl.receiveInventoryPalletId = null;
                                }                    

                            });


                            if(data[0].lowestUom.toUpperCase() == 'EACH'){

                                ctrl.receiveInventoryQty = "";
                                ctrl.receiveInventoryQtyDisabled = false;

                                $scope.data = {
                                    availableOptions: [
                                        {id: 'EACH', name: 'EACH'},
                                        {id: 'CASE', name: 'CASE'},
                                        {id: 'PALLET', name: 'PALLET'}
                                    ]
                                };
                            }else if(data[0].lowestUom.toUpperCase() == 'CASE'){
                                $scope.data = {
                                    availableOptions: [
                                        {id: 'CASE', name: 'CASE'},
                                        {id: 'PALLET', name: 'PALLET'}
                                    ]
                                };

                            }else{

                                ctrl.receiveInventoryQty = "1";
                                ctrl.receiveInventoryQtyDisabled = true;
                                $scope.data = {
                                    availableOptions: [
                                        {id: 'PALLET', name: 'PALLET'}
                                    ]
                                };
                            }

                        }
                        ctrl.receiveInventoryUom =  $scope.data.availableOptions[0].id;

                    }

                });



            $('#inventoryView').appendTo("body").modal('show');
            $http({
                method: 'GET',
                url: '/receiving/getReceiveInventoryForSearchRow',
                params: {selectedRowReceiptLine: ctrl.receiptLinesByRecpt[ctrl.receptLineIndex].receipt_line_id}

            })

                .success(function(data) {

                    if (ctrl.inventoryStatusOptions[0]) {
                        ctrl.receiveInventoryStatus = ctrl.inventoryStatusOptions[0].optionValue;  
                    }                    
                    $scope.gridOptions.data = data;

                });


            $http({
                method: 'GET',
                url: '/receiving/calculateReceivedInventoryQty',
                params: {selectedRowReceiptLine: ctrl.receiptLinesByRecpt[ctrl.receptLineIndex].receipt_line_id, itemId:ctrl.receiptLinesByRecpt[ctrl.receptLineIndex].item_id}
            })
                .success(function(data) {
                    ctrl.qtyCalculatedData = data;

                });

        }
    };

    //START INVENTORY VIEW
    ctrl.viewGrid = false;

    $scope.subGridScope = {
        clickMeSub: function(row){

            ctrl.receiptLineNoForView = row.entity.receipt_line_number;
            ctrl.receiptLineIdForView = row.entity.receipt_line_id;
            ctrl.receiptIdForView = row.entity.receipt_id;
            ctrl.receiptItemForView = row.entity.item_id;
            ctrl.receiptExpectedQty = row.entity.expected_quantity;
            ctrl.receiptExpectedLotCode = row.entity.expected_lot_code;
            ctrl.receiptUom = row.entity.uom;
            ctrl.receiptClosed = row.entity.complete_date ? true : false;

            ctrl.IsLotCodeInValid = false;

            //ctrl.receiveInventoryPalletId = null;
            ctrl.receiveInventoryCaseId = null;
            ctrl.receiveInventoryQty = null;
            ctrl.receiveInventoryUom = null;
            ctrl.receiveInventoryLotCode = null;
            ctrl.receiveInventoryExpireDate = null;
            ctrl.receiveInventoryStatus = null;

            ctrl.receiptLinesByRecpt = [];
            for(var i = 0; i < ctrl.allReceiptLinesByRecpts.length; i += 1) {
                if(ctrl.allReceiptLinesByRecpts[i]['receipt_id'] === row.entity.receipt_id) {
                    ctrl.receiptLinesByRecpt.push(ctrl.allReceiptLinesByRecpts[i]);
                }
            }

            ctrl.viewGrid = true;
            ctrl.receptLineIndex = findWithAttribute(ctrl.receiptLinesByRecpt, 'receipt_line_id', ctrl.receiptLineIdForView);

            $http({
                method : 'GET',
                url : '/item/findItem',
                params: {itemId: row.entity.item_id}
            })
                .success(function (data, status, headers, config) {

                    if(data.length > 0){

                        ctrl.itemDataRow = data[0];
                        ctrl.receiveInventoryExpireDateDisabled = !data[0].isExpired;
                        ctrl.receiveInventoryLotCodeDisabled = !data[0].isLotTracked;
                        ctrl.receiptItemDescriptionForView = data[0].itemDescription;

                        
                        if(data[0].isCaseTracked){
                            ctrl.receiveInventoryCaseId = "";
                            ctrl.receiveInventoryCaseIdDisabled = false;
                            ctrl.receiveInventoryPalletId = null;

                            if(data[0].lowestUom.toUpperCase() == 'EACH'){

                                ctrl.receiveInventoryQty = "";
                                ctrl.receiveInventoryQtyDisabled = false;

                                $scope.data = {
                                    availableOptions: [
                                        {id: 'EACH', name: 'EACH'},
                                        {id: 'CASE', name: 'CASE'}
                                    ]
                                };
                            }else if(data[0].lowestUom.toUpperCase() == 'CASE'){

                                ctrl.receiveInventoryQty = "1";
                                ctrl.receiveInventoryQtyDisabled = true;

                                $scope.data = {
                                    availableOptions: [
                                        {id: 'CASE', name: 'CASE'}
                                    ]
                                };
                            }


                        }else{
                            ctrl.receiveInventoryCaseIdDisabled = true;
                            ctrl.receiveInventoryQtyDisabled = false;

                            $http({
                                method: 'GET',
                                url: '/company/getCurrentUserCompany',
                            })

                            .success(function(data) {

                                if (data.autoLoadPalletId == true) {
                                    ctrl.receiveInventoryPalletId = alphanumericGenerator().toUpperCase();
                                }
                                else{
                                    ctrl.receiveInventoryPalletId = null;
                                }                    

                            });


                            if(data[0].lowestUom.toUpperCase() == 'EACH'){

                                ctrl.receiveInventoryQty = "";
                                ctrl.receiveInventoryQtyDisabled = false;

                                $scope.data = {
                                    availableOptions: [
                                        {id: 'EACH', name: 'EACH'},
                                        {id: 'CASE', name: 'CASE'},
                                        {id: 'PALLET', name: 'PALLET'}
                                    ]
                                };
                            }else if(data[0].lowestUom.toUpperCase() == 'CASE'){
                                $scope.data = {
                                    availableOptions: [
                                        {id: 'CASE', name: 'CASE'},
                                        {id: 'PALLET', name: 'PALLET'}
                                    ]
                                };
                            }else{

                                ctrl.receiveInventoryQty = "1";
                                ctrl.receiveInventoryQtyDisabled = true;
                                $scope.data = {
                                    availableOptions: [
                                        {id: 'PALLET', name: 'PALLET'}
                                    ]
                                };
                            }

                        }

                        ctrl.receiveInventoryUom =  $scope.data.availableOptions[0].id;

                    }

                });


            $('#inventoryView').appendTo("body").modal('show');
            ctrl.isPendingPutaway = false;

            $http({
                method: 'GET',
                url: '/receiving/getReceiveInventoryForSearchRow',
                params: {selectedRowReceiptLine: row.entity.receipt_line_id}

            })

                .success(function(data) {

                    if (ctrl.inventoryStatusOptions[0]) {
                        ctrl.receiveInventoryStatus = ctrl.inventoryStatusOptions[0].optionValue;  
                    }                    
                    $scope.gridOptions.data = data;

                });


            $http({
                method: 'GET',
                url: '/receiving/calculateReceivedInventoryQty',
                params: {selectedRowReceiptLine: row.entity.receipt_line_id, itemId:row.entity.item_id}
            })
                .success(function(data) {
                    ctrl.qtyCalculatedData = data;

                });

        },

        getStatusByRcQty:function(row){
            var status = 'none';
            if (row.entity.calculated_received_qty !=null) {
                if (parseInt(row.entity.expected_quantity) == parseInt(row.entity.calculated_received_qty)) {
                    status = 'fullyReceived';
                }
                else if (parseInt(row.entity.calculated_received_qty) == 0) {
                    status = 'notReceived';
                }
                else if (parseInt(row.entity.expected_quantity) > parseInt(row.entity.calculated_received_qty)) {
                    status = 'partiallyReceived';
                }
                else if (parseInt(row.entity.expected_quantity) < parseInt(row.entity.calculated_received_qty)) {
                    status = 'overReceived';
                }
            }
            return status;
        }
    };

    ctrl.selectCase = function(){
        if (ctrl.itemDataRow.isCaseTracked) {
            if ((ctrl.receiveInventoryUom).toUpperCase() == 'CASE') {
                ctrl.receiveInventoryQty = 1;
                ctrl.receiveInventoryQtyDisabled = true;
            }
            else{
                ctrl.receiveInventoryQtyDisabled = false;
                ctrl.receiveInventoryQty = null;
            }
        }
        else {
            ctrl.receiveInventoryQtyDisabled = false; 
            ctrl.receiveInventoryQty = null;
        }

        if ((ctrl.receiveInventoryUom).toUpperCase() == 'PALLET') {
            ctrl.receiveInventoryQty = 1;
            ctrl.receiveInventoryQtyDisabled = true;
        }
    };

    $scope.receivedInventoryScope = {
        putaway: function(row){

            ctrl.putawayUserLocation = "";

            if(row.entity.pallet_id){
                ctrl.putawayLpnLevel = "Pallet";
                ctrl.putawayInventoryLpnId = row.entity.pallet_id;
                if (row.entity.case_id) {
                   ctrl.putawayInventoryCaseId = row.entity.case_id;
                }
                else{
                    ctrl.putawayInventoryCaseId = null;
                }

            }else{
                ctrl.putawayLpnLevel = "Case";
                ctrl.putawayInventoryLpnId = row.entity.case_id;
                ctrl.putawayInventoryCaseId = row.entity.case_id;
            }
            ctrl.putawayReceiveInventoryId = row.entity.receive_inventory_id

            //Get System Suggested Location Id

            ctrl.putawaySystemLocation = "";
            ctrl.putawaySystemLocationBarcode = "";
            ctrl.putawaySystemLocationError = "";
            $http({
                method: 'GET',
                url: '/receiving/suggestLocationForPutAway',
                params: {itemId: ctrl.receiptItemForView,
                    expirationDate:  row.entity.expiration_date}

            })
                .success(function(data) {
                    ctrl.putawaySystemLocation = data['location'];
                    ctrl.putawaySystemLocationBarcode = data['locationBarcode'];
                    ctrl.putawaySystemLocationError = data['error'];
                });


            ctrl.putawayInventoryUserDefined.$submitted = false;
            ctrl.putawayInventoryUserDefined['putawayUserLocation'].$touched = false;
            ctrl.disableConfirmForUnmatchedlocation = true;
            ctrl.confirmLocationId = "";
            ctrl.putawayInventoryUserDefined.putawayUserLocation.$setValidity('locationIdExists', true);

            ctrl.lowestUomCaseForBin = false;
            $('#putAwayModal').appendTo("body").modal('show');

        },
        invalidPallet: function(row){

            if(row.entity.is_completed_putaway1 == 'invalid'){
                return true;
            }
            else{
                return false;
            }

        },
        putawayCompleted: function(row){

            if(row.entity.is_completed_putaway1 > 0){
                return true;
            }
            else{
                return false;
            }

        },

        displayItemNotes : function(row){

            $http({
                method: 'GET',
                url: '/receiving/getNotesByCaseId',
                params: {caseId: row.entity.case_id}

            })
            .success(function(data) {
                ctrl.itemNotesData = data.notes;
            });
            $('#showItemNotes').appendTo("body").modal('show');
        },

        displayNoteTemplate : "notesPopoverForDisplay"

    };

    $scope.receivedCaseInventoryScope = {
        putaway: function(row){

            ctrl.putawayLpnLevel = "Case";
            ctrl.putawayInventoryLpnId = row.entity.caseId;
            ctrl.putawayReceiveInventoryId = row.entity.receiveInventoryId
            ctrl.putawayInventoryCaseId = row.entity.caseId;

            //Get System Suggested Location Id

            ctrl.putawaySystemLocation = "";
            ctrl.putawaySystemLocationBarcode = "";
            ctrl.putawaySystemLocationError = "";
            $http({
                method: 'GET',
                url: '/receiving/suggestLocationForPutAway',
                params: {itemId: ctrl.receiptItemForView,
                         expirationDate:  row.entity.expiration_date}

            })
                .success(function(data) {
                    ctrl.putawaySystemLocation = data['location'];
                    ctrl.putawaySystemLocationBarcode = data['locationBarcode'];
                    ctrl.putawaySystemLocationError = data['error'];
                });


            ctrl.putawayInventoryUserDefined.$submitted = false;
            ctrl.putawayInventoryUserDefined['putawayUserLocation'].$touched = false;
            ctrl.disableConfirmForUnmatchedlocation = true;
            ctrl.confirmLocationId = "";
            ctrl.putawayInventoryUserDefined.putawayUserLocation.$setValidity('locationIdExists', true);
            $('#putAwayModal').appendTo("body").modal('show');
            ctrl.lowestUomCaseForBin = false;

        },
        putawayCompleted: function(row){

            if(row.entity.isCompletedPutaway == true){
                return true;
            }
            else{
                return false;
            }

        }
    };

    $scope.receivedPendingPutawayInventoryScope = {
        putaway: function(row){

            ctrl.putawayUserLocation = "";

            if(row.entity.pallet_id){
                ctrl.putawayLpnLevel = "Pallet";
                ctrl.putawayInventoryLpnId = row.entity.pallet_id;
                if (row.entity.case_id) {
                    ctrl.putawayInventoryCaseId = row.entity.case_id;
                }
                else{
                    ctrl.putawayInventoryCaseId = null;
                }

            }else{
                ctrl.putawayLpnLevel = "Case";
                ctrl.putawayInventoryLpnId = row.entity.case_id;
                ctrl.putawayInventoryCaseId = row.entity.case_id;
            }
            ctrl.putawayReceiveInventoryId = row.entity.receive_inventory_id;

            $http({
                method : 'GET',
                url : '/item/findItem',
                params: {itemId: row.entity.item_id}
            })
                .success(function (data, status, headers, config) {

                    if(data.length > 0){

                        ctrl.itemDataRow = data[0];

                        ctrl.receiptItemForView = ctrl.itemDataRow.itemId;
                        ctrl.receiptItemDescriptionForView = ctrl.itemDataRow.itemDescription;
                    }

                });

            //Get System Suggested Location Id

            ctrl.putawaySystemLocation = "";
            ctrl.putawaySystemLocationBarcode = "";
            ctrl.putawaySystemLocationError = "";
            $http({
                method: 'GET',
                url: '/receiving/suggestLocationForPutAway',
                params: {itemId: row.entity.item_id,
                         expirationDate:  row.entity.expiration_date}

            })
                .success(function(data) {
                    ctrl.putawaySystemLocation = data['location'];
                    ctrl.putawaySystemLocationBarcode = data['locationBarcode'];
                    ctrl.putawaySystemLocationError = data['error'];
                });


            ctrl.putawayInventoryUserDefined.$submitted = false;
            ctrl.putawayInventoryUserDefined['putawayUserLocation'].$touched = false;
            ctrl.disableConfirmForUnmatchedlocation = true;
            ctrl.confirmLocationId = "";
            ctrl.putawayInventoryUserDefined.putawayUserLocation.$setValidity('locationIdExists', true);

            ctrl.lowestUomCaseForBin = false;
            $('#putAwayModal').appendTo("body").modal('show');

        },
        invalidPallet: function(row){

            if(row.entity.is_completed_putaway1 == 'invalid'){
                return true;
            }
            else{
                return false;
            }

        },
        putawayCompleted: function(row){

            if(row.entity.is_completed_putaway1 > 0){
                return true;
            }
            else{
                return false;
            }

        },

        displayItemNotes : function(row){

            $http({
                method: 'GET',
                url: '/receiving/getNotesByCaseId',
                params: {caseId: row.entity.case_id}

            })
                .success(function(data) {
                    ctrl.itemNotesData = data.notes;
                });
            $('#showItemNotes').appendTo("body").modal('show');
        },

        displayNoteTemplate : "notesPopoverForDisplay"

    };

    $scope.receivedPendingPutawayCaseInventoryScope = {

        putaway: function(row){

            ctrl.putawayLpnLevel = "Case";
            ctrl.putawayInventoryLpnId = row.entity.caseId;
            ctrl.putawayReceiveInventoryId = row.entity.receiveInventoryId
            ctrl.putawayInventoryCaseId = row.entity.caseId;

            $http({
                method : 'GET',
                url : '/item/findItem',
                params: {itemId: row.entity.item_id}
            })
                .success(function (data, status, headers, config) {

                    if(data.length > 0){

                        ctrl.itemDataRow = data[0];

                        ctrl.receiptItemForView = ctrl.itemDataRow.itemId;
                        ctrl.receiptItemDescriptionForView = ctrl.itemDataRow.itemDescription;
                    }

                });

            //Get System Suggested Location Id

            ctrl.putawaySystemLocation = "";
            ctrl.putawaySystemLocationBarcode = "";
            ctrl.putawaySystemLocationError = "";
            $http({
                method: 'GET',
                url: '/receiving/suggestLocationForPutAway',
                params: {itemId: row.entity.itemId,
                         expirationDate:  row.entity.expiration_date}

            })
                .success(function(data) {
                    ctrl.putawaySystemLocation = data['location'];
                    ctrl.putawaySystemLocationBarcode = data['locationBarcode'];
                    ctrl.putawaySystemLocationError = data['error'];
                });


            ctrl.putawayInventoryUserDefined.$submitted = false;
            ctrl.putawayInventoryUserDefined['putawayUserLocation'].$touched = false;
            ctrl.disableConfirmForUnmatchedlocation = true;
            ctrl.confirmLocationId = "";
            ctrl.putawayInventoryUserDefined.putawayUserLocation.$setValidity('locationIdExists', true);
            $('#putAwayModal').appendTo("body").modal('show');
            ctrl.lowestUomCaseForBin = false;

        },
        putawayCompleted: function(row){

            if(row.entity.isCompletedPutaway == true){
                return true;
            }
            else{
                return false;
            }

        }
    };

    //$scope.clickMe = function(){
    //    $('#putAwayModal').appendTo("body").modal('show');
    //};

    $scope.gridOptions = {
        expandableRowTemplate: "<div ui-grid='row.entity.subGridOptions' style='height:150px;'></div>",
        expandableRowHeight: 150,
        //enableRowSelection: true,
        //exporterMenuCsv: true,
        //enableGridMenu: true,
        //enableFiltering: false,
        //gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,
        appScopeProvider: $scope.receivedInventoryScope,
        columnDefs: [
            {name:'Pallet', field: 'pallet_id'},
            {name:'Case', field: 'case_id'},
            {name:'Qty', field: 'quantity'},
            {name:'UOM', field: 'uom'},
            {name:'Lot Code', field: 'lot_code'},
            {name:'Expiration Date', field: 'expiration_date',type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Status', field: 'inventory_status'},
            {name:'Notes', cellTemplate: '<span><a href="javascript:void(0)" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;" ng-show="row.entity.notes" uib-popover="{{row.entity.notes}}" popover-title="" popover-append-to-body="true" popover-trigger="outsideClick" >View</a></span>'},
            {name:'Actions',  cellTemplate: '<span ng-if="grid.appScope.invalidPallet(row)" style="color: red;">Invalid Pallet</span><button class="btn btn-xs btn-primary" style="padding: 2px 2px !important; margin: 2px 10px 0px 10px;" ng-if="!grid.appScope.invalidPallet(row) && !grid.appScope.putawayCompleted(row)" ng-click="grid.appScope.putaway(row)">Put Away</button><span ng-if="!grid.appScope.invalidPallet(row) && grid.appScope.putawayCompleted(row)" style="color: green;">Putaway Completed</span>'}
        ],

        onRegisterApi: function( gridApi ){

            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {
                if (row.isExpanded) {
                    row.entity.subGridOptions = {
                        appScopeProvider: $scope.receivedCaseInventoryScope,

                        columnDefs: [
                            {name:'Pallet', field: 'palletId'},
                            {name:'Case', field: 'caseId'},
                            {name:'Quantity', field: 'quantity'},
                            {name:'UOM', field: 'uom'},
                            {name:'Lot Code', field: 'lotCode'},
                            {name:'Expiration Date', field: 'expirationDate',type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
                            {name:'Status', field: 'inventoryStatus'}
                        ]
                    };

                    $http({
                        method: 'GET',
                        url: '/receiving/getCaseReceiveInventory',
                        params : {palletId: row.entity.pallet_id, receiptLineId: row.entity.receipt_line_id}
                    })
                        .success(function(data) {
                            row.entity.subGridOptions.data = data;
                        });


                }
            });

            //$scope.gridApi = gridApi;

            $interval( function() {
                gridApi.core.addToGridMenu( gridApi.grid, [{ title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged( $scope, function( changedColumn ){
                $scope.columnChanged = { name: changedColumn.colDef.name, visible: changedColumn.colDef.visible };
            });
        }
    };

    //END OF INVENTORY VIEW

    // START PENDING PUTAWAY GRID

    $scope.pendingPutawayGridOptions = {
        expandableRowTemplate: "<div ui-grid='row.entity.subPendingPutawayGridOptions' style='height:150px;'></div>",
        expandableRowHeight: 150,
        //enableRowSelection: true,
        //exporterMenuCsv: true,
        //enableGridMenu: true,
        //enableFiltering: false,
        //gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,
        appScopeProvider: $scope.receivedPendingPutawayInventoryScope,
        columnDefs: [
            {name:'Receipt No', field: 'receipt_id'},
            {name:'Item', field: 'item_id'},
            {name:'Pallet', field: 'pallet_id'},
            {name:'Case', field: 'case_id'},
            {name:'Qty', field: 'quantity'},
            {name:'UOM', field: 'uom'},
            {name:'Lot Code', field: 'lot_code'},
            {name:'Expiration Date', field: 'expiration_date',type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Status', field: 'inventory_status'},
            {name:'Notes', cellTemplate: '<span><a href="javascript:void(0)" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;" ng-show="row.entity.notes" uib-popover="{{row.entity.notes}}" popover-title="" popover-append-to-body="true" popover-trigger="outsideClick" >View</a></span>'},
            {name:'Actions',  cellTemplate: '<span ng-if="grid.appScope.invalidPallet(row)" style="color: red;">Invalid Pallet</span><button class="btn btn-xs btn-primary" style="padding: 2px 2px !important; margin: 2px 10px 0px 10px;" ng-if="!grid.appScope.invalidPallet(row) && !grid.appScope.putawayCompleted(row)" ng-click="grid.appScope.putaway(row)">Put Away</button><span ng-if="!grid.appScope.invalidPallet(row) && grid.appScope.putawayCompleted(row)" style="color: green;">Putaway Completed</span>'}
        ],

        onRegisterApi: function( gridApi ){

            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {
                if (row.isExpanded) {
                    row.entity.subPendingPutawayGridOptions = {
                        appScopeProvider: $scope.receivedPendingPutawayCaseInventoryScope,

                        columnDefs: [
                            {name:'Pallet', field: 'palletId'},
                            {name:'Case', field: 'caseId'},
                            {name:'Qty', field: 'quantity'},
                            {name:'UOM', field: 'uom'},
                            {name:'Lot Code', field: 'lotCode'},
                            {name:'Expiration Date', field: 'expirationDate',type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
                            {name:'Status', field: 'inventoryStatus'},
                            {name:'Actions',  cellTemplate: '<button class="btn btn-xs btn-primary" style="padding: 2px 2px !important; margin: 2px 10px 0px 10px;"  ng-if="!grid.appScope.putawayCompleted(row)" ng-click="grid.appScope.putaway(row)">Put Away</button><span ng-if="grid.appScope.putawayCompleted(row)" style="color: green;">Putaway Completed</span>'}
                        ]
                    };

                    $http({
                        method: 'GET',
                        url: '/receiving/getCaseReceivePendingPutawayInventory',
                        params : {palletId: row.entity.pallet_id, receiptLineId: row.entity.receipt_line_id}
                    })
                        .success(function(data) {
                            row.entity.subPendingPutawayGridOptions.data = data;
                        });


                }
            });

            //$scope.gridApi = gridApi;

            $interval( function() {
                gridApi.core.addToGridMenu( gridApi.grid, [{ title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged( $scope, function( changedColumn ){
                $scope.columnChanged = { name: changedColumn.colDef.name, visible: changedColumn.colDef.visible };
            });
        }
    };


    // END PENDING PUTAWAY GRID



//***********end search*******************

    $scope.getReceiptDataReport = function (row) {
        var format = 'PDF';
        var file = 'receiptReport';
        var accessType = 'inline';
        var paramsReceiptNumber = row.entity.receipt_id;
        ctrl.receiptItemReportSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType+"&receiptId="+paramsReceiptNumber; 
        $('#viewReceiptReportModel').appendTo("body").modal('show');
        ctrl.mailSubject = "Foysonis Receipt Report - "+row.entity.receipt_id;

    };    

    $scope.printReport = function(url){

        var w = window.open(url);
        w.print();
    };    

    ctrl.openMailAddrModal = function(urlString){
        ctrl.reportPathString = urlString;
        ctrl.isEmailsent = false;
        ctrl.sendingEmailNow = false;
        ctrl.mailToAddress = '';
        ctrl.mailTextBody = '';
        $('#sendMailToModal').appendTo("body").modal('show'); 
        //ctrl.mailToForm.$setUntouched();
        //ctrl.mailToForm.$setPristine();
        
    }


    $scope.sendFileViaMail = function(){
        if( ctrl.mailToForm.$valid) {
            $('#sendMailToModal').modal('hide'); 
            $('#viewOrderReportModel').modal('hide'); 
            $('#sendingMailModal').appendTo("body").modal('show'); 
            $http({
                method  : 'POST',
                url     : ctrl.reportPathString,
                params  : {isForMail:true },
                data    : {recipient:ctrl.mailToAddress, mailSubject:ctrl.mailSubject, mailBody:ctrl.mailTextBody},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
            .success(function(data) {
                $('#sendMailSuccessModel').appendTo("body").modal('show');
                $timeout(function () {
                    $('#sendMailSuccessModel').modal('hide');
                }, 5000);                    
            })
            .finally(function () {
                $('#sendingMailModal').modal('hide'); 
            }); 
        }        
    }

    ctrl.uniqueReceiptIdValidation = function(viewValue){
        $http({
            method : 'GET',
            url : '/receiving/checkReceiptIdExist',
            params: {receiptId: viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    ctrl.createReceiptForm.receiptId.$setValidity('receiptIdExists', true);
                }
                else
                {
                    ctrl.createReceiptForm.receiptId.$setValidity('receiptIdExists', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.createReceiptForm.receiptId.$setValidity('receiptIdExists', false);
            });
    };


    ctrl.uniquePalletIdValidation = function(viewValue){
        if (viewValue) {
            $http({
                method : 'GET',
                url : '/receiving/validatePalletIdForReceiving',
                params: {palletId: viewValue, receiptLineId:ctrl.receiptLineIdForView}
            })
                .success(function (data, status, headers, config) {

                    if(data.allowToReceive){
                        ctrl.receiveInventory.receiveInventoryPalletId.$setValidity('palletIdExists', true);
                    }
                    else
                    {
                        ctrl.receiveInventory.receiveInventoryPalletId.$setValidity('palletIdExists', false);
                    }

                })
                .error(function (data, status, headers, config) {
                    ctrl.receiveInventory.receiveInventoryPalletId.$setValidity('palletIdExists', false);
                });
        }
    };

    ctrl.uniqueCaseIdValidation = function(viewValue){

                $http({
                    method : 'GET',
                    url : '/receiving/checkCaseIdExist',
                    params: {lpn: viewValue}
                })
                    .success(function (data, status, headers, config) {

                        if(data.length == 0){
                            ctrl.receiveInventory.receiveInventoryCaseId.$setValidity('caseIdExists', true);
                        }
                        else
                        {
                            ctrl.receiveInventory.receiveInventoryCaseId.$setValidity('caseIdExists', false);
                        }

                    })
                    .error(function (data, status, headers, config) {
                        ctrl.receiveInventory.receiveInventoryCaseId.$setValidity('caseIdExists', false);
                    });

    };

    ctrl.checkLocationIdExist = function(viewValue){
        $http({
            method : 'GET',
            url : '/receiving/checkLocationIdExist',
            params: {locationId: viewValue}
        })
            .success(function (data, status, headers, config) {
                ctrl.overrideLocationIdData = data;
                if(data.length == 0){
                    ctrl.putawayInventoryUserDefined.putawayUserLocation.$setValidity('locationIdExists', false);
                }
                else
                {
                    ctrl.putawayInventoryUserDefined.putawayUserLocation.$setValidity('locationIdExists', true);
                    //if (data[0].is_bin) {
                    //    $('#binAreaSelectWarning').appendTo('body').modal('show');
                    //}
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.putawayInventoryUserDefined.putawayUserLocation.$setValidity('locationIdExists', false);
            });
    };

    ctrl.confirmLocationForPutaway = function(locationId){

        if (locationId) {
            if(ctrl.putawaySystemLocation == locationId || ctrl.putawaySystemLocationBarcode == locationId){
                ctrl.putawayInventory.confirmLocationId.$setValidity('locationIdMatchForPutaway', true);
                ctrl.disableConfirmForUnmatchedlocation = false;
            }
            else
            {
                // ctrl.putawayInventory.confirmLocationId.$setValidity('locationIdMatchForPutaway', false);
                // ctrl.disableConfirmForUnmatchedlocation = true;

                $http({
                    method : 'GET',
                    url : '/receiving/checkPndLocationByLocationAndCompany',
                    params: {locationId: locationId}
                })
                .success(function (data, status, headers, config) {

                    if(data.length > 0){
                        ctrl.putawayInventory.confirmLocationId.$setValidity('locationIdMatchForPutaway', true);
                        ctrl.disableConfirmForUnmatchedlocation = false;

                    }
                    else
                    {
                        ctrl.putawayInventory.confirmLocationId.$setValidity('locationIdMatchForPutaway', false);
                        ctrl.disableConfirmForUnmatchedlocation = true;

                    }

                })
                .error(function (data, status, headers, config) {
                    ctrl.putawayInventory.confirmLocationId.$setValidity('locationIdMatchForPutaway', false);
                    ctrl.disableConfirmForUnmatchedlocation = true;

                });


            }
        }
        else{
            ctrl.putawayInventory.confirmLocationId.$setValidity('locationIdMatchForPutaway', true);
        }

    };   

}])

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

//receipt id unique check
    .directive('uniqueReceiptIdValidation', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {




                ctrl.$parsers.push(function (viewValue) {
                    $http({
                        method : 'GET',
                        url : '/receiving/checkReceiptIdExist',
                        params: {receiptId: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('receiptIdExists', true);
                            }
                            else
                            {
                                ctrl.$setValidity('receiptIdExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('receiptIdExists', false);
                        });

                    return viewValue;
                });

            }
        };
    })

//pallet id unique check
    .directive('uniquePalletIdValidation', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {

                ctrl.$parsers.push(function (viewValue) {
                    $http({
                        method : 'GET',
                        url : '/receiving/checkPalletIdExist',
                        params: {lpn: viewValue}
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

//case id unique check
    .directive('uniqueCaseIdValidation', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {

                ctrl.$parsers.push(function (viewValue) {
                    $http({
                        method : 'GET',
                        url : '/receiving/checkCaseIdExist',
                        params: {lpn: viewValue}
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


//case id unique check
    .directive('checkLocationIdExist', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {

                ctrl.$parsers.push(function (viewValue) {

                    if(viewValue != ''){

                        $http({
                            method : 'GET',
                            url : '/receiving/checkLocationIdExist',
                            params: {locationId: viewValue}
                        })
                            .success(function (data, status, headers, config) {

                                if(data.length == 0){
                                    ctrl.$setValidity('locationIdExists', false);
                                }
                                else
                                {
                                    ctrl.$setValidity('locationIdExists', true);
                                }

                            })
                            .error(function (data, status, headers, config) {
                                ctrl.$setValidity('locationIdExists', false);
                            });

                        return viewValue;
                    }

                });

            }
        };
    })

    .directive('setAutofocus', function() {
        return{
            restrict: 'A',

            link: function(scope, element, attrs){
                scope.$watch(function(){
                    return scope.$eval(attrs.setAutofocus);
                },function (newValue){
                    if (newValue == true){
                        element[0].focus();
                    }
                });
            }
        };
    })

    .directive('charValidator', function () {
        return {
            require: 'ngModel',
            link: function (scope, element, attr, ngModelCtrl) {
                function fromUser(text) {
                    if (text) {
                        var transformedInput = text.replace(/[^0-9-A-Za-z]/g, '');
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
;




