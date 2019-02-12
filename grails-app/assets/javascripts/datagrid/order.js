/**
 * Created by home on 9/10/15.
 */

var app = angular.module('order', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.bootstrap', 'inventory-autocomplete', 'ui.grid.autoResize', 'ngLocale', 'ui.grid.pagination', 'ui.grid.expandable', 'ui.grid.resizeColumns']);

app.controller('orderCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

    var myEl = angular.element( document.querySelector( '#liShipping' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulShipping' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'Orders & Shipments';

    //Date Control

    //alert($locale.DATETIME_FORMATS.mediumDate);


    $scope.inlineOptions = {
        customClass: getDayClass,
        minDate: new Date()
    };

    $scope.dateOptions = {
        //dateDisabled: disabled,
        formatYear: 'yy',
        maxDate: new Date(2020, 5, 22),
        minDate: new Date(),
        startingDay: 1,
        showWeeks: false
    };

    // Disable weekend selection
    function disabled(data) {
        var date = data.date,
            mode = data.mode;
        return mode === 'day' && (date.getDay() === 0 || date.getDay() === 6);
    }

    $scope.toggleMin = function() {
        $scope.inlineOptions.minDate = $scope.inlineOptions.minDate ? null : new Date();
        $scope.dateOptions.minDate = $scope.inlineOptions.minDate;
    };

    $scope.toggleMin();

    $scope.openEarlyShipDate = function() {
        $scope.popupEarlyShipDate.opened = true;
    };

    $scope.openEarlyShipDateFrom = function() {
        $scope.popupEarlyShipDateFrom.opened = true;
    };

    $scope.openEarlyShipDateTo = function() {
        $scope.popupEarlyShipDateTo.opened = true;
    };

    $scope.openLateShipDate = function() {
        $scope.popupLateShipDate.opened = true;
    };

    $scope.openLateShipDateFrom = function() {
        $scope.popupLateShipDateFrom.opened = true;
    };

    $scope.openLateShipDateTo = function() {
        $scope.popupLateShipDateTo.opened = true;
    };


    //$scope.formats = ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'MM/dd/yyyy', 'shortDate'];
    //$scope.format = $scope.formats[3];
    $scope.format = $locale.DATETIME_FORMATS.shortDate;
    $scope.altInputFormats = ['M!/d!/yyyy'];

    $scope.popupEarlyShipDate = {
        opened: false
    };

    $scope.popupEarlyShipDateFrom = {
        opened: false
    };

    $scope.popupEarlyShipDateTo = {
        opened: false
    };

    $scope.popupLateShipDate = {
        opened: false
    };

    $scope.popupLateShipDateFrom = {
        opened: false
    };

    $scope.popupLateShipDateTo = {
        opened: false
    };

    //var tomorrow = new Date();
    //tomorrow.setDate(tomorrow.getDate() + 1);
    //var afterTomorrow = new Date();
    //afterTomorrow.setDate(tomorrow.getDate() + 1);
    //$scope.events = [
    //    {
    //        date: tomorrow,
    //        status: 'full'
    //    },
    //    {
    //        date: afterTomorrow,
    //        status: 'partially'
    //    }
    //];

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



    // $scope.printReport = function(documentId) {
    //     var doc = document.getElementById(documentId);


    //     //Wait until PDF is ready to print
    //     if (typeof doc.print === 'undefined') {
    //         setTimeout(function(){printDocument(documentId);}, 1000);
    //     } else {
    //         doc.print();
    //     }
    // }

    $scope.printReport = function(pdfUrl) {
        var w = window.open(pdfUrl);
        w.print();
    }


    $scope.testreport = function(){
        $('#viewReport').appendTo("body").modal('show');

    }

    $scope.loadCustomerAutoCompleteForNewOrder = function (value) {
        return $http({
            method: 'GET',
            url: '/order/getAllcustomerIdByCompanyForNewOrder',
            params : {keyPress: value.keyword}
        });
    };

    $scope.loadCustomerAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/order/getAllcustomerIdByCompany',
            params : {keyPress: value.keyword}
        });
    };


    //var loadItemAutoComplete = function () {
    //    $http.get('/order/getItems')
    //        .success(function(data) {
    //            $scope.loadCompanyItems = data;
    //        });
    //};

    $scope.loadItemAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/order/getItems',
            params : {keyword: value.keyword}
        });
    };


    var getAllListValueShipSpeed = function () {
        $http({
            method: 'GET',
            url: '/order/getAllValuesByCompanyIdAndGroup',
            params : {group: 'RSHSP'}
        })
            .success(function (data, status, headers, config) {
                var noneOption = [{description: ''}];
                ctrl.listValueShipSpeed = noneOption.concat(data);
            })
    };

    var getAllListValueCarrierCode = function () {
        $http({
            method: 'GET',
            url: '/order/getAllValuesByCompanyIdAndGroup',
            params : {group: 'CARRCODE'}
        })
            .success(function (data, status, headers, config) {
                var noneOption = [{description: ''}];
                ctrl.carrierCodeOptions = noneOption.concat(data);
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
    getAllListValueCarrierCode();
    getAllListValueInventoryStatus();
//***********start order create****************************

    $scope.IsOrderVisible = false;
    $scope.ShowHide = function () {
        clearFormOrder();
        $scope.IsOrderVisible = $scope.IsOrderVisible ? false : true;
        if (ctrl.inventoryStatusOptions[0]) {
            ctrl.newOrder.orderLine[0].requestedInventoryStatus = ctrl.inventoryStatusOptions[0].optionValue;
        }
    };



    $scope.getEbayOrders = function () {
        ctrl.disableEbayImport = true;
        ctrl.eBayImportBtnText = "Importing...";

        $http({
            method  : 'POST',
            url     : '/order/getEbayOrders',
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {

                orderSearch();
                ctrl.eBayImportBtnText = "Import eBay Orders";
                ctrl.disableEbayImport = false;
                ctrl.showOrderEbayImportedPrompt = true;
                $timeout(function(){
                    ctrl.showOrderEbayImportedPrompt = false;
                }, 5000);

            })


    };

    var ctrl = this,
        newOrder = { orderNumber:'', earlyShipDate:'', lateShipDate:'', requestedShipSpeed:'',customerId:'',  orderNote:'',  isCreateKittingOrder:false, orderLine:[]};
    //loadCustomerAutoComplete();
    //loadItemAutoComplete();
    getAllListValueShipSpeed();
    ctrl.eBayImportBtnText = "Import eBay Orders";
    ctrl.disableEbayImport = false;


    var createOrder = function () {

        if(ctrl.newOrder.earlyShipDate && ctrl.newOrder.lateShipDate){
            if( ctrl.newOrder.earlyShipDate.getTime() > ctrl.newOrder.lateShipDate.getTime())  {
                ctrl.createOrderForm.$valid = false;
                ctrl.shipmentDateValidMsg = true;
            }
        }

        if (ctrl.isCustomerHoldSelected == true) {
            ctrl.createOrderForm.$valid = false;
        }        

        if( ctrl.createOrderForm.$valid) {

            ctrl.disableSaveReportBtn = true;

            if (ctrl.newOrder.orderNumber == null || ctrl.newOrder.orderNumber == '') {
                ctrl.newOrder.orderNumber = Math.floor((Math.random() * 100000000) + 1);
            }

            //alert(JSON.stringify($scope.ctrl.newOrder));

            $http({
                method  : 'POST',
                url     : '/order/saveOrder',
                data    :  $scope.ctrl.newOrder,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {

                    $http({
                        method: 'POST',
                        url: '/order/searchOrder',
                        params: {orderNumber:ctrl.newOrder.orderNumber},
                        dataType: 'json',
                        headers : { 'Content-Type': 'application/json; charset=utf-8' }
                    })
                        .success(function (data) {
                            ctrl.isOrderSearchVisible = false;
                            ctrl.orderList = data;
                        })

                    $scope.IsOrderVisible = false;
                    ctrl.selectedOrderNumber = ctrl.newOrder.orderNumber;
                    getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                    getCustomerBySelectedOrderNum(ctrl.selectedOrderNumber);
                    getSelectedOrderDetails(ctrl.selectedOrderNumber);
                    getAllShipmentsByOrder(ctrl.selectedOrderNumber);
                    clearFormOrder();

                    ctrl.showOrderCreatedPrompt = true;
                    $timeout(function(){
                        ctrl.showOrderCreatedPrompt = false;
                    }, 5000);

                    ctrl.totalNumOfPages = 1;

                })
                .finally(function(){
                    ctrl.disableSaveReportBtn = false;
                });
        }
    };

    var automaticOrderSave = function () {

        if((ctrl.newOrder.earlyShipDate !='') && (ctrl.newOrder.lateShipDate!='') ){
            if( ctrl.newOrder.earlyShipDate.getTime() > ctrl.newOrder.lateShipDate.getTime())  {
                ctrl.createOrderForm.$valid = false;
                ctrl.shipmentDateValidMsg = true;
            }
        }

        if (ctrl.isCustomerHoldSelected == true) {
            ctrl.createOrderForm.$valid = false;
        }           

        ctrl.createOrderForm.$setSubmitted();

        if( ctrl.createOrderForm.$valid) {

            ctrl.disableSaveReportBtn = true;

            if (ctrl.newOrder.orderNumber == null || ctrl.newOrder.orderNumber == '') {
                ctrl.newOrder.orderNumber = Math.floor((Math.random() * 1000000000) + 1);
            }


            $http({
                method  : 'POST',
                url     : '/order/saveOrder',
                data    :  $scope.ctrl.newOrder,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.isAutoSaved = true;

                })
                .finally(function(){
                    ctrl.disableSaveReportBtn = false;
                });
        }
    };

    ctrl.automaticOrderSave = automaticOrderSave;

    var clearFormOrder = function () {
        ctrl.isAutoSaved = false;
        ctrl.isCustomerHoldSelected = false;
        //ctrl.newOrder = { orderNumber:'', earlyShipDate:'', lateShipDate:'', requestedShipSpeed:'',customerId:'',orderLine:[]};
        ctrl.newOrder.orderNumber = '';
        ctrl.newOrder.earlyShipDate = new Date();
        ctrl.newOrder.lateShipDate = '';
        ctrl.newOrder.requestedShipSpeed = '';
        ctrl.newOrder.customerId = '';
        ctrl.newOrder.contactName = '';
        ctrl.newOrder.orderNote = '';

        ctrl.addNewFieldNum = 1;
        ctrl.lowestUomEach = [];
        ctrl.kittingOrder = [];
        ctrl.createOrderForm.$setUntouched();
        ctrl.createOrderForm.$setPristine();

        ctrl.orderLineNumberList = [];
        ctrl.newOrder.orderLine[0].itemId = '';
        ctrl.newOrder.orderLine[0].orderedQuantity = '';
        ctrl.newOrder.orderLine[0].orderedUOM = '';
        ctrl.newOrder.orderLine[0].requestedInventoryStatus = '';
        ctrl.newOrder.orderLine[0].orderLineStatus = '';

        ctrl.newOrder.orderLine[0].displayOrderLineNumber = "0001";
        ctrl.newOrder.orderLine[0].allocateByLpn = '';
        for(var i = 1; i<ctrl.newOrder.orderLine.length; i++){
            ctrl.newOrder.orderLine.splice(i, 1);
        }

        //for(var i = 1; i<ctrl.newOrder.orderLine.length; i++){
        //    ctrl.newOrder.orderLine.splice(i, 1);
        //}
        ctrl.shipmentDateValidMsg = false;

    };

    var hasErrorClassOrder = function (field) {
        if (ctrl.createOrderForm[field]) {
            return ctrl.createOrderForm[field].$touched && ctrl.createOrderForm[field].$invalid;
        }
    };

    var showMessagesOrder = function (field) {
        return ctrl.createOrderForm[field].$touched || ctrl.createOrderForm.$submitted
    };

    var showMessagesOrderForMin = function (field) {
        return ctrl.createOrderForm[field].$error.min
    };

    var toggleOrderNumberPrompt = function (value) {
        ctrl.showOrderNumberPrompt = value;
    };
    var toggleEarlyShipDatePrompt = function (value) {
        ctrl.showEarlyShipDatePrompt = value;
    };
    var toggleLateShipDatePrompt = function (value) {
        ctrl.showLateShipDatePrompt = value;
    };
    var toggleTravelSequencePrompt = function (value) {
        ctrl.showRequestedShipSpeedPrompt = value;
    };

    ctrl.showOrderNumberPrompt = false;
    ctrl.showEarlyShipDatePrompt = false;
    ctrl.showLateShipDatePrompt = false;
    ctrl.showRequestedShipSpeedPrompt = false;

    ctrl.toggleOrderNumberPrompt = toggleOrderNumberPrompt;
    ctrl.toggleEarlyShipDatePrompt = toggleEarlyShipDatePrompt;
    ctrl.toggleLateShipDatePrompt = toggleLateShipDatePrompt;
    ctrl.toggleTravelSequencePrompt = toggleTravelSequencePrompt;

    ctrl.showOrderSubmittedPrompt = false;
    ctrl.hasErrorClassOrder = hasErrorClassOrder;
    ctrl.showMessagesOrder = showMessagesOrder;
    ctrl.showMessagesOrderForMin = showMessagesOrderForMin;
    ctrl.newOrder = newOrder;
    ctrl.createOrder = createOrder;
    ctrl.clearFormOrder = clearFormOrder;



    ctrl.addNewFieldNum = 1;

    var getNewField = function(number){
        return new Array(number);
    };

    var addNewField = function(index){

        if( ctrl.createOrderForm.$valid) {
            ctrl.addNewFieldNum++;
        }
        document.getElementById("addNewLine").blur();

        var increIndex = index + 2;
        var strNum = increIndex.toString();
        var zeros = '0000';
        var zeroPad = zeros.slice(strNum.length);
        var receiptLineId = zeroPad+strNum;
        ctrl.orderLineNumberList[index+1] = receiptLineId;
        ctrl.focusVal = index + 1;
        getAllListValueInventoryStatus();

    };

    var validateItemIdOrderLines = function(itemId,index){
        $http({
            method: 'GET',
            url: '/item/getLowestUom',
            params : {itemId: itemId}
        })

            .success(function (data, status, headers, config) {

                ctrl.newOrder.orderLine[index].orderedUOM = data[0];

                // if (ctrl.checkLowestUom.length > 0) {
                //     ctrl.lowestUomEach[index] = true;
                //     ctrl.newOrder.orderLine[index].orderedUOM = 'EACH';
                //
                // }
                // else{
                //     ctrl.lowestUomEach[index] = false;
                //     ctrl.newOrder.orderLine[index].orderedUOM = 'CASE';
                //
                // }


            })


        ctrl.newOrder.orderLine[index].isCreateKittingOrder = false;
        $http({
            method: 'GET',
            url: '/billMaterial/getBillOfMaterialByCompanyIdAndItemId',
            params : {itemId: itemId}
        })

            .success(function (data, status, headers, config) {

                if (data) {
                    ctrl.kittingOrder[index] = true;
                }
                else{
                    ctrl.kittingOrder[index] = false
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.kittingOrder[index] = false;
            })
    };



    var deleteOrderLineRaw = function(index){

        for(var i = index+1; i < ctrl.newOrder.orderLine.length; i++){
            if (ctrl.newOrder.orderLine[i] != null) {
                validateItemIdOrderLines(ctrl.newOrder.orderLine[i].itemId, i-1);
            }
        }

        if(ctrl.newOrder.orderLine.length > 1){
            ctrl.newOrder.orderLine.splice(index, 1);
            ctrl.addNewFieldNum = ctrl.addNewFieldNum-1;
        }
    };

    ctrl.getNewField = getNewField;
    ctrl.addNewField = addNewField;
    ctrl.validateItemIdOrderLines = validateItemIdOrderLines;
    ctrl.deleteOrderLineRaw = deleteOrderLineRaw;

    var getEarlyShipDate = function(date){
        var formatDate = new Date(date);
        var year = formatDate.getFullYear();
        var month = formatDate.getMonth() + 1;
        var day = formatDate.getDate();

        if (month < 10) {
            month = '0' + month;
        }

        if (day < 10) {
            day = '0' + day;
        }

        return year+"-"+month+"-"+day;
    };

    ctrl.getEarlyShipDate = getEarlyShipDate;

//***************end order create*************************************


    var getClickedOrder = function(clickedId){
        closeEditOrder();
        ctrl.selectedOrderNumber = clickedId;
        getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
        getCustomerBySelectedOrderNum(ctrl.selectedOrderNumber);
        getSelectedOrderDetails(ctrl.selectedOrderNumber);
        getAllShipmentsByOrder(ctrl.selectedOrderNumber);
        $scope.IsOrderVisible = false;
        ctrl.selectedOrderLineCount = [];
        ctrl.plannedOrderLineList = [];
    };

    ctrl.getClickedOrder = getClickedOrder;

    var getInventoryLevelIcon = function(orderLineStatus, itemId, status, orderedQty, orderedUOM,index){

        if(orderLineStatus == "PLANNED"){
            $scope.gridOrderLines.data[index].inventoryLevelColor = 'GREEN';
            $scope.gridOrderLines.data[index].inventoryLevelIcon = 'fa-check';
        }
        else{

            $http({
                method: 'GET',
                url: '/order/getInventorySummaryForQty',
                params : {itemId: itemId, status: status}
            })
                .success(function(data) {
                    if (data.length > 0) {
                        var availableQtyTotal = data[0].totalQuantity - data[0].committedQuantity;
                        if (parseInt(availableQtyTotal) < 0) {
                            $scope.gridOrderLines.data[index].availableQty = 0;
                        }else{
                            $scope.gridOrderLines.data[index].availableQty = availableQtyTotal;
                        }
                        $scope.gridOrderLines.data[index].lowestUom = data[0].uom;
                        
                        $http({
                            method: 'GET',
                            url: '/order/getTotalOrderedQty',
                            params : {itemId: itemId, status: status}
                        })
                            .success(function(data) {
                                var totalOrderedQty = data.totalOrderedQty;

                                if (availableQtyTotal >= totalOrderedQty) {
                                    $scope.gridOrderLines.data[index].inventoryLevelColor = 'GREEN';
                                    $scope.gridOrderLines.data[index].inventoryLevelIcon = 'invIconGreen';
                                }
                                else{
                                    var calcOrderedQty = orderedQty;
                                    if (data.itemLowestUom.toUpperCase() == 'EACH' && orderedUOM.toUpperCase() == 'CASE') {
                                        calcOrderedQty = orderedQty * parseInt(data.itemEachesPerCase);
                                    }
                                    if (calcOrderedQty <= availableQtyTotal){
                                        $scope.gridOrderLines.data[index].inventoryLevelColor = 'YELLOW';
                                        $scope.gridOrderLines.data[index].inventoryLevelIcon = 'invIconYellow';
                                    }
                                    else{
                                        $scope.gridOrderLines.data[index].inventoryLevelColor = 'RED';
                                        $scope.gridOrderLines.data[index].inventoryLevelIcon = 'invIconRed';
                                    }
                                }
                            });
                    }
                    else {
                        $scope.gridOrderLines.data[index].inventoryLevelColor = 'RED';
                        $scope.gridOrderLines.data[index].inventoryLevelIcon = 'invIconRed';
                        $scope.gridOrderLines.data[index].availableQty = 0;


                        $http({
                            method: 'GET',
                            url: '/item/findItem',
                            params : {itemId: itemId}
                        })
                            .success(function(data) {

                                if(data.length > 0){
                                    $scope.gridOrderLines.data[index].lowestUom = data[0].lowestUom;
                                }

                            });
                    }


                });

        }
    };

    var getOrderLinesBySelectedOrderNum = function (orderNumber) {
        $scope.IsOrderVisibleArea = false;
//alert("hi");
        $http({
            method: 'GET',
            url: '/order/getAllOrderLinesByOrders',
            params: {orderNum: orderNumber}
        })
            .success(function(data) {
                $scope.gridOrderLines.data = data;
                for (var i = 0; i < data.length; i++) {
                    getInventoryLevelIcon(data[i].orderLineStatus, data[i].itemId, data[i].inventoryStatusOptionValue, data[i].orderedQuantity, data[i].orderedUOM, i );
                };
            });
    };

    var getCustomerBySelectedOrderNum = function(orderNumber) {
        $scope.IsOrderVisibleArea = false;

        $http({
            method: 'GET',
            url: '/order/getCustomerByOrder',
            params: {orderNum: orderNumber}
        })
            .success(function(data) {
                ctrl.customerData = data;
            });
    };

    var getSelectedOrderDetails = function(orderNumber) {
        $scope.IsOrderVisibleArea = false;

        $http({
            method: 'GET',
            url: '/order/getSelectedOrderData',
            params: {orderNum: orderNumber}
        })
            .success(function(data) {
                ctrl.orderData = data;
                ctrl.listValueShipSpeedDesc = null;
                getAllListValueShipSpeedDesc(ctrl.orderData[0].requestedShipSpeed);

                if (data[0].lateShipDate == null) {
                    ctrl.convertedLateShipDate = null;
                }
                else{
                    ctrl.convertedLateShipDate = new Date(data[0].lateShipDate).toDateString();
                }

                if (data[0].earlyShipDate == null) {
                    ctrl.convertedEarlyShipDate = null;
                }
                else{
                    ctrl.convertedEarlyShipDate = new Date(data[0].earlyShipDate).toDateString();
                }

            });
    };

    var getAllListValueShipSpeedDesc = function(OptVal){
        $http({
            method: 'GET',
            url: '/order/findListValueDescription',
            params: {optionValue: OptVal}
        })
            .success(function(data) {
                ctrl.listValueShipSpeedDesc = data[0].description;
            });
    };


//***************start order Edit*************************************

    ctrl.orderFieldsEditabe = false;

    var editOrder = function(){

        if (ctrl.orderData[0].orderStatus == "CLOSED") {
            $('#editOrderWarning').appendTo("body").modal('show');
        }

        else {

            getAllListValueShipSpeed();
            //getCustomerBySelectedOrderNum(ctrl.selectedOrderNumber);

            ctrl.orderFieldsEditabe = true;
            if (ctrl.orderData[0].earlyShipDate == null) {
                ctrl.earlyShipDateEdit = '';
            }
            else{
                ctrl.earlyShipDateEdit = new Date(ctrl.orderData[0].earlyShipDate);
            }

            if (ctrl.orderData[0].lateShipDate == null ) {
                ctrl.lateShipDateEdit = '';
            }
            else{
                ctrl.lateShipDateEdit = new Date(ctrl.orderData[0].lateShipDate);
            }

            ctrl.requestedShipSpeedEdit = ctrl.orderData[0].requestedShipSpeed;
            ctrl.customerIdEditForOrder = ctrl.customerData[0].customer_id;
            ctrl.customerNameEditForOrder = ctrl.customerData[0].contact_name+' - '+ctrl.customerData[0].company_name;
            ctrl.orderNoteEdit = ctrl.orderData[0].notes
        }
    };

    var closeEditOrder = function(){

        ctrl.orderFieldsEditabe = false;
        ctrl.earlyShipDateEdit = '';
        ctrl.lateShipDateEdit = '';
        ctrl.requestedShipSpeedEdit = '';
        ctrl.customerNameEditForOrder ='';
        ctrl.customerIdEditForOrder = '';
        ctrl.shipmentDateValidMsg = false;
        ctrl.orderNoteEdit = '';
    };


    var editOrderHeader = function(){

        if((ctrl.earlyShipDateEdit !=null) && (ctrl.lateShipDateEdit!=null) ){
            if( ctrl.earlyShipDateEdit.getTime() > ctrl.lateShipDateEdit.getTime())  {
                ctrl.editOrderFormfield.$valid = false;
                ctrl.shipmentDateValidMsg = true;
            }
        }

        if (ctrl.isCustomerHoldSelected == true) {
            ctrl.editOrderFormfield.$valid = false;
        }

        if(ctrl.editOrderFormfield.$valid) {

            ctrl.disableEditOrdBtn = true;

            $http({
                method  : 'POST',
                url     : '/order/updateOrder',
                data    :  {orderNumber:ctrl.selectedOrderNumber, customerId:ctrl.customerIdEditForOrder,
                    earlyShipDate:ctrl.earlyShipDateEdit, lateShipDate:ctrl.lateShipDateEdit, requestedShipSpeed:ctrl.requestedShipSpeedEdit, orderNote:ctrl.orderNoteEdit},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    closeEditOrder();
                    getSelectedOrderDetails(ctrl.selectedOrderNumber);
                    getCustomerBySelectedOrderNum(ctrl.selectedOrderNumber);

                    ctrl.showOrderEditedPrompt = true;
                    $timeout(function(){
                        ctrl.showOrderEditedPrompt = false;
                    }, 5000);
                })
                .finally(function(){
                    ctrl.disableEditOrdBtn = false;
                });

        }

    };

    ctrl.closeEditOrder = closeEditOrder;
    ctrl.editOrder = editOrder;
    ctrl.editOrderHeader = editOrderHeader;

    var addNewCustomerEdit = function(contactName, customerId){
        ctrl.customerIdEditForOrder = customerId;
        if (contactName == "+ New Customer") {
            $('#addCustomer').appendTo("body").modal('show');
        }
    };

    ctrl.addNewCustomerEdit = addNewCustomerEdit;    

//***************End order Edit*************************************

//***************Start order Delete*************************************

    var deleteOrder = function(){

        if (ctrl.orderData[0].orderStatus == "UNPLANNED") {

            $http({
                method: 'GET',
                url: '/order/checkPlannedOrderLines',
                params: {orderNumber: ctrl.selectedOrderNumber}
            })
                .success(function(data) {
                    if (data.length > 0) {
                        $('#deleteOrderWarning').appendTo("body").modal('show');
                    }
                    else {
                        $('#deleteOrder').appendTo("body").modal('show');
                    }
                });
        }

        else{
            $('#deleteOrderWarning').appendTo("body").modal('show');
        }
    };


    $("#orderDeleteButton").click(function(){

        $http({
            method  : 'POST',
            url     : '/order/deleteOrder',
            data    :  {orderNumber:ctrl.selectedOrderNumber},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                orderSearch();
                $('#deleteOrder').modal('hide');
            })

    });


    ctrl.deleteOrder = deleteOrder;
//***************End order Delete*************************************

//***************start order line create*************************************
    var addOrderLine = function(){

        if (ctrl.customerData[0].is_customer_hold == true) {
            $('#createNewOrderLineWarning').appendTo("body").modal('show');
        }

        else{
            clearOrderLineForm();
            if (ctrl.inventoryStatusOptions[0]) {
                ctrl.orderLineRequestedInventoryStatus = ctrl.inventoryStatusOptions[0].optionValue;
            }
            $('#createOrderLineModel').appendTo("body").modal('show');
        }

    }

    ctrl.addOrderLine = addOrderLine;

    var saveOrderLine = function () {

        if( ctrl.orderLineForm.$valid) {

            ctrl.disableSaveOrderLineBtn = true;

            $http({
                method  : 'POST',
                url     : '/order/saveOrderLine',
                params: {orderNumber:ctrl.selectedOrderNumber, displayOrderLineNumber:ctrl.orderLineDisplayOrderLineNumber,
                    itemId:ctrl.orderLineItemId, orderedQuantity:ctrl.orderLineOrderedQuantity,
                    orderedUOM:ctrl.orderLineOrderedUOM, requestedInventoryStatus:ctrl.orderLineRequestedInventoryStatus,
                    isCreateKittingOrder:ctrl.orderLineIsCreateKittingOrder, allocateByLpn: ctrl.allocateByLpnNew},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(data) {
                    getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                    clearOrderLineForm();
                    getSelectedOrderDetails(ctrl.selectedOrderNumber);
                    $('#createOrderLineModel').modal('hide');

                })
                .finally(function(){
                    ctrl.disableSaveOrderLineBtn = false;
                });

        }
    };




    var showMessagesForOrderLine = function (field) {
        return ctrl.orderLineForm[field].$touched || ctrl.orderLineForm.$submitted;
    };

    var hasErrorClassForOrderLine = function (field) {
        if (ctrl.orderLineForm[field]) {
            return ctrl.orderLineForm[field].$touched && ctrl.orderLineForm[field].$invalid;
        }
    };

    var clearOrderLineForm = function(){
        ctrl.lowestUomEach = true;
        ctrl.kittingOrder = false;
        ctrl.orderLineIsCreateKittingOrder = false;
        ctrl.orderLineForm.$setUntouched();
        ctrl.orderLineForm.$setPristine();
        ctrl.orderLineDisplayOrderLineNumber = '';
        ctrl.orderLineItemId = '';
        ctrl.orderLineOrderedQuantity = '';
        ctrl.orderLineOrderedUOM = '';
        ctrl.orderLineRequestedInventoryStatus = '';
    }

    ctrl.saveOrderLine = saveOrderLine;
    ctrl.showMessagesForOrderLine = showMessagesForOrderLine;
    ctrl.hasErrorClassForOrderLine = hasErrorClassForOrderLine;
    ctrl.clearOrderLineForm = clearOrderLineForm


    var validateItemId = function(itemId){
        $http({
            method: 'GET',
            url: '/item/getLowestUom',
            params : {itemId: itemId}
        })

            .success(function (data, status, headers, config) {
                ctrl.orderLineOrderedUOM = data[0];
                // ctrl.checkLowestUom = data;
                //
                // if (ctrl.checkLowestUom.length > 0) {
                //     ctrl.lowestUomEach = true;
                //
                // }
                // else{
                //     ctrl.lowestUomEach = false;
                //
                // }


            })


        ctrl.kittingOrder = false;
        ctrl.orderLineIsCreateKittingOrder = false;

        $http({
            method: 'GET',
            url: '/billMaterial/getBillOfMaterialByCompanyIdAndItemId',
            params : {itemId: itemId}
        })

            .success(function (data, status, headers, config) {

                if (data) {
                    ctrl.kittingOrder = true;
                }
                else{
                    ctrl.kittingOrder = false
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.kittingOrder = false;
            })
    };

    ctrl.validateItemId = validateItemId;

//***************end order line create*************************************

    $scope.checkOrderLineStatus = function(row){
        if (row.entity.orderLineStatus == 'UNPLANNED') {
            return true
        }
        else{
            return false
        }

    };

//***************start order line Edit*************************************


    $scope.EditOrderLine = function(row) {
        //Check Current User
        $http.get('/user/getCurrentUser')
            .success(function(data) {

                if (row.entity.orderLineStatus == 'UNPLANNED') {

                    $('#createOrderLineModelEdit').appendTo("body").modal('show');
                    validateItemId(row.entity.itemId);
                    ctrl.orderLineNumber = row.entity.orderLineNumber;
                    ctrl.selectedOrderNumberEdit = row.entity.orderNumber;
                    ctrl.orderLineDisplayOrderLineNumberEdit = row.entity.displayOrderLineNumber;
                    ctrl.orderLineItemIdEdit = row.entity.itemId;
                    ctrl.orderLineOrderedQuantityEdit = row.entity.orderedQuantity;
                    ctrl.orderLineOrderedUOMEdit = row.entity.orderedUOM;
                    ctrl.orderLineRequestedInventoryStatusEdit = row.entity.inventoryStatusOptionValue;
                    ctrl.orderLineIsCreateKittingOrderEdit = row.entity.isCreateKittingOrder;
                    ctrl.allocateByLpnEdit = row.entity.allocationAttrValue;
                }

                else{
                    $('#OrderLineEditWarning').appendTo("body").modal('show');
                }

            });


    };

    var saveOrderLineEdit = function () {

        if( ctrl.orderLineFormEdit.$valid) {

            ctrl.disableEditOrderLineBtn = true;

            $http({
                method  : 'POST',
                url     : '/order/updateOrderLine',
                params: {orderNumber:ctrl.selectedOrderNumber, orderLineNumber:ctrl.orderLineNumber, displayOrderLineNumber:ctrl.orderLineDisplayOrderLineNumberEdit,
                    itemId:ctrl.orderLineItemIdEdit, orderedQuantity:ctrl.orderLineOrderedQuantityEdit,
                    orderedUOM:ctrl.orderLineOrderedUOMEdit, requestedInventoryStatus:ctrl.orderLineRequestedInventoryStatusEdit,
                    isCreateKittingOrder:ctrl.orderLineIsCreateKittingOrderEdit, allocateByLpn:ctrl.allocateByLpnEdit},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(data) {
                    getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                    clearOrderLineFormEdit();
                    $('#createOrderLineModelEdit').modal('hide');

                })
                .finally(function(){
                    ctrl.disableEditOrderLineBtn = false;
                })

        }
    };




    var showMessagesForOrderLineEdit = function (field) {
        return ctrl.orderLineFormEdit[field].$touched || ctrl.orderLineFormEdit.$submitted;
    };

    var hasErrorClassForOrderLineEdit = function (field) {
        return ctrl.orderLineFormEdit[field].$touched && ctrl.orderLineFormEdit[field].$invalid;
    };

    var clearOrderLineFormEdit = function(){
        ctrl.orderLineForm.$setUntouched();
        ctrl.orderLineForm.$setPristine();
        ctrl.orderLineDisplayOrderLineNumber = '';
        ctrl.orderLineItemId = '';
        ctrl.orderLineOrderedQuantity = '';
        ctrl.orderLineOrderedUOM = '';
        ctrl.orderLineRequestedInventoryStatus = '';
    };

    ctrl.saveOrderLineEdit = saveOrderLineEdit;
    ctrl.showMessagesForOrderLineEdit = showMessagesForOrderLineEdit;
    ctrl.hasErrorClassForOrderLineEdit = hasErrorClassForOrderLineEdit;
    ctrl.clearOrderLineFormEdit = clearOrderLineFormEdit;


//***************End order line Edit*************************************

//***************Statr order line Delete*************************************

    var rows;
    $scope.DeleteOrderLine = function(row) {
        rows = row
        if (row.entity.orderLineStatus == 'UNPLANNED') {
            $('#OrderLineDelete').appendTo("body").modal('show');
        }
        else{
            $('#OrderLineDeleteWarning').appendTo("body").modal('show');
        }
    };

    $("#orderLineDeleteButton").click(function(){

        $http({
            method  : 'POST',
            url     : '/order/deleteOrderLine',
            data    :  {orderLineNumber:rows.entity.orderLineNumber, orderNumber:ctrl.selectedOrderNumber},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                var index = $scope.gridOrderLines.data.indexOf(rows.entity);
                $scope.gridOrderLines.data.splice(index, 1);
                getSelectedOrderDetails(ctrl.selectedOrderNumber);
                $('#OrderLineDelete').modal('hide');
            })

    });


//***************End of order line Delete*************************************  

//***************start order search************************************* 

    ctrl.isOrderSearchVisible = true;
    ctrl.orderList = [];

    var showHideSearch = function () {
        clearFormOrder();
        ctrl.isOrderSearchVisible = ctrl.isOrderSearchVisible ? false : true;
    };



    var showEarlyShipDateRange = function () {
        ctrl.displayEarlyShipDateRange = ctrl.earlyShipDateRange
    };

    var showLateShipDateRange = function () {
        ctrl.displayLateShipDateRange = ctrl.LateShipDateRange
    };

    ctrl.getCustomerContactName = function(customer){
        if (customer) {
          ctrl.customer = customer.contactName;  
        }
        
    }

    var orderSearch = function () {

        $http({
            method: 'POST',
            url: '/order/searchOrderForCount',
            params: {customerName:ctrl.customer, orderNumber:ctrl.orderNumber, orderStatus: ctrl.orderStatus,
                fromEarlyShipDate:ctrl.fromEarlyShipDate, toEarlyShipDate:ctrl.toEarlyShipDate,
                fromLateShipDate:ctrl.fromLateShipDate, toLateShipDate:ctrl.toLateShipDate,
                requestedShipSpeed:ctrl.requestedShipSpeed, shipmentId:ctrl.shipmentIdSearch, shipmentStatus:ctrl.shipmentStatusSearch},

            //params: {orderNumber:ctrl.orderNumber},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                ctrl.totalNumOfOrders = data[0].total_orders;
                var totalPagesInFloat = parseInt(ctrl.totalNumOfOrders) / 20;
                ctrl.totalNumOfPages = Math.ceil(totalPagesInFloat);
            });

        $http({
            method: 'POST',
            url: '/order/searchOrder',
            params: {customerName:ctrl.customer, orderNumber:ctrl.orderNumber, orderStatus: ctrl.orderStatus,
                fromEarlyShipDate:ctrl.fromEarlyShipDate, toEarlyShipDate:ctrl.toEarlyShipDate,
                fromLateShipDate:ctrl.fromLateShipDate, toLateShipDate:ctrl.toLateShipDate,
                requestedShipSpeed:ctrl.requestedShipSpeed, shipmentId:ctrl.shipmentIdSearch, shipmentStatus:ctrl.shipmentStatusSearch},

            //params: {orderNumber:ctrl.orderNumber},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {

                ctrl.isOrderSearchVisible = false;
                ctrl.orderList = data;
                ctrl.selectedOrderLineCount = []

                if (ctrl.orderList.length == 0) {
                    $scope.gridOrderLines.data = [];
                    ctrl.shipmentLineDataByOrder = [];
                    ctrl.orderData = null;
                    ctrl.customerData = null;
                }

                else{

                    ctrl.selectedOrderNumber = data[0].order_number
                    getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                    getCustomerBySelectedOrderNum(ctrl.selectedOrderNumber);
                    getSelectedOrderDetails(ctrl.selectedOrderNumber);
                    getAllShipmentsByOrder(ctrl.selectedOrderNumber);
                    ctrl.orderSearchPageNum = 1;

                }

            })

    };

    ctrl.orderSearchForNextPrev = function(nav){

        if (nav == 'next') {
            if (ctrl.orderSearchPageNum <= ctrl.totalNumOfPages) {
                ctrl.orderSearchPageNum ++;
            }            
        }
        else if (nav == 'prev') {
            if (ctrl.orderSearchPageNum >= 1) {
                ctrl.orderSearchPageNum --;
            }             
        }



        $http({
            method: 'POST',
            url: '/order/searchOrderForCount',
            params: {customerName:ctrl.customer, orderNumber:ctrl.orderNumber, orderStatus: ctrl.orderStatus,
                fromEarlyShipDate:ctrl.fromEarlyShipDate, toEarlyShipDate:ctrl.toEarlyShipDate,
                fromLateShipDate:ctrl.fromLateShipDate, toLateShipDate:ctrl.toLateShipDate,
                requestedShipSpeed:ctrl.requestedShipSpeed, shipmentId:ctrl.shipmentIdSearch, shipmentStatus:ctrl.shipmentStatusSearch},

            //params: {orderNumber:ctrl.orderNumber},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                ctrl.totalNumOfOrders = data[0].total_orders;
                var totalPagesInFloat = parseInt(ctrl.totalNumOfOrders) / 20;
                ctrl.totalNumOfPages = Math.ceil(totalPagesInFloat);
            });

        $http({
            method: 'POST',
            url: '/order/searchOrder',
            params: {customerName:ctrl.customer, orderNumber:ctrl.orderNumber, orderStatus: ctrl.orderStatus,
                fromEarlyShipDate:ctrl.fromEarlyShipDate, toEarlyShipDate:ctrl.toEarlyShipDate,
                fromLateShipDate:ctrl.fromLateShipDate, toLateShipDate:ctrl.toLateShipDate,
                requestedShipSpeed:ctrl.requestedShipSpeed, shipmentId:ctrl.shipmentIdSearch, shipmentStatus:ctrl.shipmentStatusSearch, currentPageNum:ctrl.orderSearchPageNum},

            //params: {orderNumber:ctrl.orderNumber},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {

                ctrl.isOrderSearchVisible = false;
                ctrl.orderList = data;
                ctrl.selectedOrderLineCount = []

                if (ctrl.orderList.length == 0) {
                    $scope.gridOrderLines.data = [];
                    ctrl.shipmentLineDataByOrder = [];
                    ctrl.orderData = null;
                    ctrl.customerData = null;
                }

                else{

                    ctrl.selectedOrderNumber = data[0].order_number
                    getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                    getCustomerBySelectedOrderNum(ctrl.selectedOrderNumber);
                    getSelectedOrderDetails(ctrl.selectedOrderNumber);
                    getAllShipmentsByOrder(ctrl.selectedOrderNumber);

                }

            })

    };

    $scope.clearAutoCompText = function(){
        ctrl.customer = '';
    };

    ctrl.orderSearch = orderSearch;
    ctrl.showHideSearch = showHideSearch;
    ctrl.showEarlyShipDateRange = showEarlyShipDateRange;
    ctrl.showLateShipDateRange = showLateShipDateRange;


    var loadGridData = function (){

        $http({
            method: 'POST',
            url: '/order/searchOrderForCount',
            params: {customerName:ctrl.customer, orderNumber:ctrl.orderNumber, orderStatus: ctrl.orderStatus,
                fromEarlyShipDate:ctrl.fromEarlyShipDate, toEarlyShipDate:ctrl.toEarlyShipDate,
                fromLateShipDate:ctrl.fromLateShipDate, toLateShipDate:ctrl.toLateShipDate,
                requestedShipSpeed:ctrl.requestedShipSpeed, shipmentId:ctrl.shipmentIdSearch, shipmentStatus:ctrl.shipmentStatusSearch},

            //params: {orderNumber:ctrl.orderNumber},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                ctrl.totalNumOfOrders = data[0].total_orders;
                var totalPagesInFloat = parseInt(ctrl.totalNumOfOrders) / 20;
                ctrl.totalNumOfPages = Math.ceil(totalPagesInFloat);
            });

        $http({
            method: 'POST',
            url: '/order/searchOrder',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                ctrl.orderList = data;
                ctrl.selectedOrderNumber = data[0].order_number
                getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                getCustomerBySelectedOrderNum(ctrl.selectedOrderNumber);
                getSelectedOrderDetails(ctrl.selectedOrderNumber);
                getAllShipmentsByOrder(ctrl.selectedOrderNumber);
                ctrl.orderSearchPageNum = 1;

            })
    };
    loadGridData();
    //orderSearch();

//***************End order search*************************************  

//***************Shipment display*************************************  
    var getAllShipmentsByOrder = function(orderNumber){
        $http({
            method: 'GET',
            url: '/shipment/getAllShipmentData',
            params: {orderNum: orderNumber}
        })
            .success(function(data) {
                ctrl.shipmentDataByOrder = data;
            });
    };

    ctrl.shipmentLineDataByOrder = [];

    var getShipmentLineData = function(shipmentId,index){
        $http({
            method: 'GET',
            url: '/shipment/getShipmentLineData',
            params: {shipmentId: shipmentId}
        })
            .success(function(data) {
                ctrl.shipmentLineDataByOrder[index] = data;
                //$scope.gridShipmentLines[index].data = data;
            });
        cancelAllocationButton(shipmentId,index);
        allocationFailedMessageButton(shipmentId,index)
    };

    var cancelShipment = function(shipmentId){
        ctrl.shipmentIdForCancel = shipmentId;
        $('#shipmentCancel').appendTo("body").modal('show');
    };

    var getCustomerShippingAddress = function () {
        $http({
            method  : 'GET',
            url     : '/customer/getCustomerShippingAddress',
            params    :  {customerId: ctrl.customerData[0].customer_id}
        })
            .success(function (data, status, headers, config) {
                $scope.customerShippingAddressList = data;
                ctrl.shippingAddressFromOpt = data[0];
            })
    };


    $("#shipmentCancelButton").click(function(){

        $http({
            method  : 'POST',
            url     : '/shipment/cancelShipment',
            data    :  {shipmentId:ctrl.shipmentIdForCancel},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                getAllShipmentsByOrder(ctrl.selectedOrderNumber);
                getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                getSelectedOrderDetails(ctrl.selectedOrderNumber);
                $('#shipmentCancel').modal('hide');
            })

    });



    ctrl.getShipmentLineData = getShipmentLineData;
    ctrl.cancelShipment = cancelShipment;

// start shipment Edit

    var findWithAttribute = function(array, attr, value) {
        for(var i = 0; i < array.length; i += 1) {
            if(array[i][attr] === value) {
                return i;
            }
        }
        return -1;
    }

    var editShipment = function(shipmentData){


        $http({
            method  : 'GET',
            url     : '/customer/getCustomerShippingAddress',
            params    :  {customerId: ctrl.customerData[0].customer_id}
        })
        .success(function (data, status, headers, config) {
            $scope.customerShippingAddressList = data;

            //ctrl.carrierCodeOptions = [ "UPS", "FedEx", "USPS", "CanadaPost", "DHL", "Puralator", "Roadway", "Yellow", "Con-way", "R&L", "Estes", "Wilson"];
            ctrl.serviceLevelOptions = ["NEXT DAY", "SECOND DAY", "GROUND"];
            //getAllListValueCarrierCode();

            ctrl.shipmentIdForEdit = shipmentData.shipment_id;
            //ctrl.shipmentStatus = shipmentData.shipment_status;
            ctrl.assignShipmentOrderLineNumber = shipmentData.order_line_number;
            ctrl.carrierCode = shipmentData.carrier_code_option_value;
            ctrl.smallPackage = shipmentData.is_parcel;
            ctrl.serviceLevel = shipmentData.service_level;
            ctrl.truckNumber = shipmentData.truck_number;
            ctrl.cutomerNameFieldEdit = shipmentData.contactName ? shipmentData.contactName : ctrl.customerData[0].contact_name;
            ctrl.trackingNo = shipmentData.tracking_no;
            ctrl.optAddress = 'existingAddress';
            var elementIndex = findWithAttribute($scope.customerShippingAddressList, 'id', shipmentData.shipping_address_id);
            ctrl.shippingAddressFromOpt = $scope.customerShippingAddressList[elementIndex];
            //ctrl.cutomerNameFieldEdit = ctrl.customerData[0].contact_name;
            ctrl.shipmentNotes = shipmentData.shipment_notes;


        })

        $('#editShipment').appendTo("body").modal('show');
    };


    var updateShipment = function () {

        if(ctrl.editShipmentForm.$valid && !ctrl.truckValidationError) {

            if (ctrl.optAddress == 'newAddress') {

                $http({
                    method  : 'POST',
                    url     : '/shipment/editShipmentWithNewShippingAddress',
                    params: {shipmentId : ctrl.shipmentIdForEdit,
                        carrierCode: ctrl.carrierCode,
                        isParcel: ctrl.smallPackage,
                        serviceLevel: ctrl.serviceLevel,
                        trackingNo: ctrl.trackingNo,
                        truckNumber: ctrl.truckNumber,
                        customerId: ctrl.customerData[0].customer_id,
                        streetAddress: ctrl.customerShippingStreetAddress,
                        city: ctrl.customerShippingCity,
                        state: ctrl.customerShippingState,
                        postCode: ctrl.customerShippingPostCode,
                        country: ctrl.customerShippingCountry,
                        contactName: ctrl.cutomerNameFieldEdit,
                        shipmentNotes:ctrl.shipmentNotes},
                    dataType: 'json',
                    headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                })
                    .success(function(data) {
                        clearAssignShipmentForm();
                        getAllShipmentsByOrder(ctrl.selectedOrderNumber);
                        $('#editShipment').appendTo("body").modal('hide');
                    })
                
            }
            else{
                $http({
                    method  : 'POST',
                    url     : '/shipment/editShipment',
                    params: {shipmentId : ctrl.shipmentIdForEdit,
                        carrierCode: ctrl.carrierCode,
                        isParcel: ctrl.smallPackage,
                        serviceLevel: ctrl.serviceLevel,
                        trackingNo: ctrl.trackingNo,
                        truckNumber: ctrl.truckNumber,
                        shippingAddressId: ctrl.shippingAddressFromOpt.id,
                        contactName: ctrl.cutomerNameFieldEdit,
                        shipmentNotes:ctrl.shipmentNotes},
                    dataType: 'json',
                    headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                })
                    .success(function(data) {
                        clearAssignShipmentForm();
                        getAllShipmentsByOrder(ctrl.selectedOrderNumber);
                        $('#editShipment').appendTo("body").modal('hide');
                    })                
            }

        }
    };


    var closeShipmentModel = function(){
        clearAssignShipmentForm();
    };

    var getCarrierCodeLink = function(carrierCode, trackingNumber){

        var carrierCodeLink = null;

        if(carrierCode){
            carrierCode = carrierCode.toUpperCase();

            if(carrierCode == 'UPS' || carrierCode == 'UNITED PARCEL SERVICE'){
                carrierCodeLink = "http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums=" + trackingNumber ;
            }
            else if(carrierCode == 'USPS' || carrierCode == 'UNITED STATES POSTAL SERVICE'){
                carrierCodeLink =  "http://trkcnfrm1.smi.usps.com/PTSInternetWeb/InterLabelInquiry.do?origTrackNum=" + trackingNumber;
            }
            else if(carrierCode == 'FEDEX' || carrierCode == 'FEDEX EXPRESS'){
                carrierCodeLink =  "http://www.fedex.com/Tracking?language=english&cntry_code=us&tracknumbers=" + trackingNumber;

            }
        }

        return carrierCodeLink
    };


    ctrl.closeShipmentModel = closeShipmentModel;
    ctrl.updateShipment = updateShipment;
    ctrl.editShipment = editShipment;
    ctrl.getCarrierCodeLink = getCarrierCodeLink;

// end shipment Edit

    ctrl.ShipmentLineColumns = [{field: 'shipment_line_id'},
        {field: 'order_number'},
        {name:'Order Line No', field: 'display_order_line_number'},
        {field: 'item_id'},
        {field: 'shippeduom',displayName: 'UOM'},
        {field: 'shipped_quantity',displayName: 'Quantity'},
        {name: 'Actions', enableSorting: false, enableFiltering: false, cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.DeleteShipmentLine(row)">Cancel Shipment Line</a></li></ul></div>'}
    ];

//***************End Shipment display*************************************  

//***************Statr shipment line Delete*************************************

    var rows;
    $scope.DeleteShipmentLine = function(row) {
        rows = row;
        $http({
            method  : 'GET',
            url     : '/shipment/getShipmentByShipmentLine',
            params  : {shipmentLineId:row.entity.shipment_line_id}
        })
            .success(function(data) {
                ctrl.shipmentStatus = data[0].shipment_status;

            if (ctrl.shipmentStatus == 'PLANNED') {
                $('#shipmentLineDelete').appendTo("body").modal('show');
            }
            else{
                $('#shipmentLineDeleteWarning').appendTo("body").modal('show');
            }

            });
    };

    $("#shipmentLineDeleteButton").click(function(){
        $http({
            method  : 'POST',
            url     : '/shipment/cancelShipmentLine',
            //data    :  {shipmentLineId:row.entity.shipment_line_id, shipmentId:row.entity.shipment_id},
            data    :  {shipmentLineId:rows.entity.shipment_line_id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                getAllShipmentsByOrder(ctrl.selectedOrderNumber);
                getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                getSelectedOrderDetails(ctrl.selectedOrderNumber);
                $('#shipmentLineDelete').modal('hide');
            })

    });


//***************End of shipment line Delete*************************************  

//***************start Plan To Shipment*************************************

    $scope.PlanShipment = function(row) {

        if (ctrl.customerData[0].is_customer_hold == true) {
            $('#shipmentPlanWarning').appendTo("body").modal('show');
        }

        else{
            $scope.IsVisibleExistingShipment = true;
            toggleAssignShipmentButtonText();

            getPlannedShipment();

            ctrl.selectedOrderLineList = null;
            $scope.gridApi.selection.clearSelectedRows();


            ctrl.assignShipmentOrderLineNumber = row.entity.orderLineNumber;

            loadControlsForNewShipment();

            $('#planToShipment').appendTo("body").modal('show');
        }
    };

//***************start Plan To Shipment*************************************

//***************start Customer create*************************************

//load billing and shipping country
    var getCountries = function () {
        $http({
            method: 'GET',
            url: '/customer/getCountries'
        })
            .success(function (data, status, headers, config) {
                $scope.countryList = data;
            })
    };
    getCountries();

    //same as shipping address checkbox
    var checkShippingAddress = function () {
        if(ctrl.shippingAddress){
            ctrl.newCustomer.shippingStreetAddress = '';
            ctrl.newCustomer.shippingCity = '';
            ctrl.newCustomer.shippingState = '';
            ctrl.newCustomer.shippingPostCode = '';
            ctrl.newCustomer.shippingCountry = '';
        }

    };

    var checkEditShippingAddress = function () {
        if(ctrl.editShippingAddress){
            ctrl.editCustomer.shippingStreetAddress = '';
            ctrl.editCustomer.shippingCity = '';
            ctrl.editCustomer.shippingState = '';
            ctrl.editCustomer.shippingPostCode = '';
            ctrl.editCustomer.shippingCountry = '';
        }

    };


    var ctrl = this,
        newCustomer = {contactName:'', companyName:'', phonePrimary:'',phoneAlternate:'', email:'', fax:'', isCustomerHold:'', notes:'', billingStreetAddress:'', billingCity:'',billingState:'', billingPostCode:'', billingCountry:'',shippingStreetAddress:'', shippingCity:'', shippingState:'', shippingPostCode:'', shippingCountry:''};


    var createCustomer = function () {

        if( ctrl.createCustomerForm.$valid) {

            if (ctrl.shippingAddress == true) {
                ctrl.newCustomer.sameAsBilling = true;
            }
            else{
                ctrl.newCustomer.sameAsBilling = false;
            }

            $http({
                method  : 'POST',
                url     : '/customer/customerSave',
                data    :  $scope.ctrl.newCustomer,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    //loadCustomerAutoComplete();
                    ctrl.newOrder.customerId = data.customerId;
                    ctrl.newOrder.contactName = data.contactName +' - '+data.companyName;
                    $('#addCustomer').appendTo("body").modal('hide');
                    clearForm();
                })

        }
    };


    var clearForm = function () {
        ctrl.newCustomer = {contactName:'', companyName:'', phonePrimary:'',phoneAlternate:'', email:'', fax:'', isCustomerHold:'', notes:'', billingStreetAddress:'', billingCity:'',billingState:'', billingPostCode:'', billingCountry:'',shippingStreetAddress:'', shippingCity:'', shippingState:'', shippingPostCode:'', shippingCountry:''};
        ctrl.createCustomerForm.$setUntouched();
        ctrl.createCustomerForm.$setPristine();

    };


    var hasErrorClass = function (field) {
        if (ctrl.createCustomerForm[field]) {
            return ctrl.createCustomerForm[field].$touched && ctrl.createCustomerForm[field].$invalid;
        }
    };

    var showMessages = function (field) {
        return ctrl.createCustomerForm[field].$touched || ctrl.createCustomerForm.$submitted;
    };

    ctrl.hasErrorClass = hasErrorClass;
    ctrl.showMessages = showMessages;
    ctrl.newCustomer = newCustomer;
    ctrl.createCustomer = createCustomer;
    ctrl.clearForm = clearForm;
    ctrl.checkShippingAddress = checkShippingAddress;
    ctrl.shippingAddress = true;

    ctrl.checkEditShippingAddress = checkEditShippingAddress;
    ctrl.editShippingAddress = true;

    var addNewCustomer = function(contactName, customerId){
        ctrl.newOrder.customerId = customerId;
        if (contactName == "+ New Customer") {
            $('#addCustomer').appendTo("body").modal('show');
        }
    };

    var checkCustomerHold = function(value){
        if (value.isCustomerHold == true) {
            ctrl.isCustomerHoldSelected = true;
        }
        else{
            ctrl.isCustomerHoldSelected = false;
        }
    };    

    ctrl.checkCustomerHold = checkCustomerHold;
    ctrl.addNewCustomer = addNewCustomer;

    var clearCreateCustomer = function(){
        clearForm();
        ctrl.newOrder.customerId = '';
        ctrl.newOrder.contactName = '';
    };

    ctrl.clearCreateCustomer = clearCreateCustomer;

//***************end Customer create*************************************



//***************Start customer Edit************************************* 

    var customerEdit = function(){

        ctrl.editCustomer.customerId = ctrl.customerData[0].customer_id;
        ctrl.editCustomer.customerName = ctrl.customerData[0].customer_name;
        ctrl.editCustomer.contactName = ctrl.customerData[0].contact_name;
        ctrl.editCustomer.companyName = ctrl.customerData[0].company_name;
        ctrl.editCustomer.phonePrimary = ctrl.customerData[0].phone_primary;
        ctrl.editCustomer.phoneAlternate = ctrl.customerData[0].phone_alternate;
        ctrl.editCustomer.email = ctrl.customerData[0].email;
        ctrl.editCustomer.fax = ctrl.customerData[0].fax;
        ctrl.editCustomer.isCustomerHold = ctrl.customerData[0].is_customer_hold;
        ctrl.editCustomer.notes = ctrl.customerData[0].notes;
        ctrl.editCustomer.billingStreetAddress = ctrl.customerData[0].billing_street_address;
        ctrl.editCustomer.billingCity = ctrl.customerData[0].billing_city;
        ctrl.editCustomer.billingState = ctrl.customerData[0].billing_state;
        ctrl.editCustomer.billingPostCode = ctrl.customerData[0].billing_post_code;
        ctrl.editCustomer.billingCountry = ctrl.customerData[0].billing_country;
        ctrl.editCustomer.shippingStreetAddress = ctrl.customerData[0].street_address;
        ctrl.editCustomer.shippingCity = ctrl.customerData[0].city;
        ctrl.editCustomer.shippingState = ctrl.customerData[0].state;
        ctrl.editCustomer.shippingPostCode = ctrl.customerData[0].post_code;
        ctrl.editCustomer.shippingCountry = ctrl.customerData[0].country;

        if(ctrl.editCustomer.billingStreetAddress == ctrl.editCustomer.shippingStreetAddress &&
            ctrl.editCustomer.billingCity == ctrl.editCustomer.shippingCity &&
            ctrl.editCustomer.billingState == ctrl.editCustomer.shippingState &&
            ctrl.editCustomer.billingPostCode == ctrl.editCustomer.shippingPostCode &&
            ctrl.editCustomer.billingCountry == ctrl.editCustomer.shippingCountry)
        {
            ctrl.editShippingAddress = true;
            ctrl.editCustomer.shippingStreetAddress = '';
            ctrl.editCustomer.shippingCity = '';
            ctrl.editCustomer.shippingState = '';
            ctrl.editCustomer.shippingPostCode = '';
            ctrl.editCustomer.shippingCountry = '';
        }
        else{
            ctrl.editShippingAddress = false
        }

        $('#editCustomer').appendTo("body").modal('show');
    }


    ctrl.customerEdit = customerEdit;




    var ctrl = this,
        editCustomer = {contactName:'', companyName:'', phonePrimary:'',phoneAlternate:'', email:'', fax:'', isCustomerHold:'', notes:'', billingStreetAddress:'', billingCity:'',billingState:'', billingPostCode:'', billingCountry:'',shippingStreetAddress:'', shippingCity:'', shippingState:'', shippingPostCode:'', shippingCountry:''};

    var updateCustomer = function () {

        if (ctrl.editCustomer.isCustomerHold == '') {
            ctrl.editCustomer.isCustomerHold == false;
        }

        if (ctrl.editShippingAddress == true) {
            ctrl.editCustomer.sameAsBilling = true;
        }
        else{
            ctrl.editCustomer.sameAsBilling = false;
        }

        if( ctrl.editCustomerForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/customer/updateCustomer',
                data    :  $scope.ctrl.editCustomer,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }

            })
                .success(function (data, status, headers, config) {

                    getCustomerBySelectedOrderNum(ctrl.selectedOrderNumber);
                    $('#editCustomer').appendTo("body").modal('hide');

                });

        }
    };



    var hasErrorClassEdit = function (field) {
        if (ctrl.editCustomerForm[field]) {
            return ctrl.editCustomerForm[field].$touched && ctrl.editCustomerForm[field].$invalid;
        }
    };

    var showMessagesEdit = function (field) {
        return ctrl.editCustomerForm[field].$touched || ctrl.editCustomerForm.$submitted;
    };


    var toggleEditCustomerIdPrompt = function (value) {
        ctrl.showEditCustomerIdPrompt = value;
    };
    var toggleEditContactNamePrompt = function (value) {
        ctrl.showEditContactNamePrompt = value;
    };
    var toggleEditCompanyNamePrompt = function (value) {
        ctrl.showEditCompanyNamePrompt = value;
    };
    var toggleEditPhonePrimaryPrompt = function (value) {
        ctrl.showEditPhonePrimaryPrompt = value;
    };
    var toggleEditPhoneAlternatePrompt = function (value) {
        ctrl.showEditPhoneAlternatePrompt = value;
    };
    var toggleEditEmailPrompt = function (value) {
        ctrl.showEditEmailPrompt = value;
    };
    var toggleEditFaxPrompt = function (value) {
        ctrl.showEditFaxPrompt = value;
    };
    var toggleEditIsCustomerHoldPrompt = function (value) {
        ctrl.showEditIsCustomerHoldPrompt = value;
    };
    var toggleEditNotesPrompt = function (value) {
        ctrl.showEditNotesPrompt = value;
    };
    var toggleEditBillingStreetAddressPrompt = function (value) {
        ctrl.showEditBillingStreetAddressPrompt = value;
    };
    var toggleEditBillingCityPrompt = function (value) {
        ctrl.showEditBillingCityPrompt = value;
    };
    var toggleEditBillingStatePrompt = function (value) {
        ctrl.showEditBillingStatePrompt = value;
    };
    var toggleEditBillingPostCodePrompt = function (value) {
        ctrl.showEditBillingPostCodePrompt = value;
    };
    var toggleEditBillingCountryPrompt = function (value) {
        ctrl.showEditBillingCountryPrompt = value;
    };
    var toggleEditShippingStreetAddressPrompt = function (value) {
        ctrl.showEditShippingStreetAddressPrompt = value;
    };
    var toggleEditShippingCityPrompt = function (value) {
        ctrl.showEditShippingCityPrompt = value;
    };
    var toggleEditShippingStatePrompt = function (value) {
        ctrl.showEditShippingStatePrompt = value;
    };
    var toggleEditShippingPostCodePrompt = function (value) {
        ctrl.showEditShippingPostCodePrompt = value;
    };
    var toggleEditShippingCountryPrompt = function (value) {
        ctrl.showEditShippingCountryPrompt = value;
    };

    ctrl.showEditCustomerIdPrompt = false;
    ctrl.showEditContactNamePrompt = false;
    ctrl.showEditCompanyNamePrompt = false;
    ctrl.showEditPhonePrimaryPrompt = false;
    ctrl.showEditPhoneAlternatePrompt = false;
    ctrl.showEditEmailPrompt = false;
    ctrl.showEditFaxPrompt = false;
    ctrl.showEditIsCustomerHoldPrompt = false;
    ctrl.showEditNotesPrompt = false;
    ctrl.showEditBillingStreetAddressPrompt = false;
    ctrl.showEditBillingCityPrompt = false;
    ctrl.showEditBillingStatePrompt = false;
    ctrl.showEditBillingPostCodePrompt = false;
    ctrl.showEditBillingCountryPrompt = false;
    ctrl.showEditShippingStreetAddressPrompt = false;
    ctrl.showEditShippingCityPrompt = false;
    ctrl.showEditShippingStatePrompt = false;
    ctrl.showEditShippingPostCodePrompt = false;
    ctrl.showEditShippingCountryPrompt = false;

    ctrl.toggleEditCustomerIdPrompt = toggleEditCustomerIdPrompt;
    ctrl.toggleEditContactNamePrompt = toggleEditContactNamePrompt;
    ctrl.toggleEditCompanyNamePrompt = toggleEditCompanyNamePrompt;
    ctrl.toggleEditPhonePrimaryPrompt = toggleEditPhonePrimaryPrompt;
    ctrl.toggleEditPhoneAlternatePrompt = toggleEditPhoneAlternatePrompt;
    ctrl.toggleEditEmailPrompt = toggleEditEmailPrompt;
    ctrl.toggleEditFaxPrompt = toggleEditFaxPrompt;
    ctrl.toggleEditIsCustomerHoldPrompt = toggleEditIsCustomerHoldPrompt;
    ctrl.toggleEditNotesPrompt = toggleEditNotesPrompt;
    ctrl.toggleEditBillingStreetAddressPrompt = toggleEditBillingStreetAddressPrompt;
    ctrl.toggleEditBillingCityPrompt = toggleEditBillingCityPrompt;
    ctrl.toggleEditBillingStatePrompt = toggleEditBillingStatePrompt;
    ctrl.toggleEditBillingPostCodePrompt = toggleEditBillingPostCodePrompt;
    ctrl.toggleEditBillingCountryPrompt = toggleEditBillingCountryPrompt;
    ctrl.toggleEditShippingStreetAddressPrompt = toggleEditShippingStreetAddressPrompt;
    ctrl.toggleEditShippingCityPrompt = toggleEditShippingCityPrompt;
    ctrl.toggleEditShippingStatePrompt = toggleEditShippingStatePrompt;
    ctrl.toggleEditShippingPostCodePrompt = toggleEditShippingPostCodePrompt;
    ctrl.toggleEditShippingCountryPrompt = toggleEditShippingCountryPrompt;

    ctrl.updateCustomer = updateCustomer;
    ctrl.editCustomer = editCustomer;
    ctrl.hasErrorClassEdit = hasErrorClassEdit;
    ctrl.showMessagesEdit = showMessagesEdit;
//***************Start customer Edit*************************************


    //get all OrderLines to the grid

    ctrl.selectedOrderLineCount = [];

    var getSelectedRows = function() {


            ctrl.selectedOrderLineList = [];
            ctrl.mySelectedRows = $scope.gridApi.selection.getSelectedRows();
            for (var i = 0; i < ctrl.mySelectedRows.length; i++) {
                ctrl.selectedOrderLineList.push(ctrl.mySelectedRows[i].orderLineNumber);

            }
            ctrl.assignShipmentOrderLineNumber=null;
            $scope.IsVisibleExistingShipment = true;
            toggleAssignShipmentButtonText();
            getPlannedShipment();
            loadControlsForNewShipment();
        if (ctrl.customerData[0].is_customer_hold == true) {
            $('#shipmentPlanWarning').appendTo("body").modal('show');
        }

        else {            
            $('#planToShipment').appendTo("body").modal('show');
        }
    };

    ctrl.getSelectedRows = getSelectedRows;

    ctrl.plannedOrderLineList = [];

    $scope.gridOrderLines = {
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
            {name:'Order Line No', field: 'displayOrderLineNumber'},
            {name:'Item' , field: 'itemId'},
            {name:'Quantity' , field: 'orderedQuantity', width: 120},
            {name:'UOM' , field: 'orderedUOM', width: 100 },
            {name:'Inventory Status' , field: 'requestedInventoryStatus'},
            {name:'Line Status' , field: 'orderLineStatus'},
            {name:'Available Qty' , field: 'inventoryLevel', width:150, cellTemplate: '<span ng-if="row.entity.inventoryLevelIcon==\'fa-check\'" style="color: {{row.entity.inventoryLevelColor}}; padding: 10px; " class="fa {{row.entity.inventoryLevelIcon}}"></span><span ng-if="row.entity.inventoryLevelIcon!=\'fa-check\'" style="padding: 10px 2px;line-height: 2.5><em class="fa  fa-fw mr-sm" ><img width="28px" src="/foysonis2016/app/img/{{row.entity.inventoryLevelIcon}}.svg"></em></span><span style="padding: 10px 2px;line-height: 2.5;">{{row.entity.availableQty}}</span><span style="padding: 10px 2px;line-height: 2.5;">{{row.entity.lowestUom}}</span>'},
            {name: 'Actions', enableSorting: false, enableFiltering: false,  cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.EditOrderLine(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.DeleteOrderLine(row)">Delete</a></li><li ng-if = "grid.appScope.checkOrderLineStatus(row)"><a href="javascript:void(0);" ng-click="grid.appScope.PlanShipment(row)">Plan To Shipment</a></li></ul></div>'}

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

            gridApi.selection.on.rowSelectionChanged($scope,function(row){
                var select = row.isSelected;
                //var msg2 = row.entity.itemId;
                if (select) {
                    if (row.entity.orderLineStatus == 'PLANNED') {
                        ctrl.plannedOrderLineList.push(row.entity.orderLineStatus);
                    }
                }
                else if (!select) {
                    if (row.entity.orderLineStatus == 'PLANNED') {
                        var listIndex = ctrl.plannedOrderLineList.indexOf('PLANNED');
                        ctrl.plannedOrderLineList.splice(listIndex, 1);
                    }
                }
                ctrl.selectedOrderLineCount = gridApi.selection.getSelectedRows();
            });

            gridApi.selection.on.rowSelectionChangedBatch($scope,function(rows){

                ctrl.plannedOrderLineList = [];
                ctrl.selectedOrderLineCount = gridApi.selection.getSelectedRows();
                for (i = 0; i < ctrl.selectedOrderLineCount.length; i++) {
                    if (ctrl.selectedOrderLineCount[i].orderLineStatus == 'PLANNED') {
                        ctrl.plannedOrderLineList.push(ctrl.selectedOrderLineCount[i].orderLineStatus);
                    }
                }

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
//    $scope.getTableHeight = function() {
//        var rowHeight = 65; // your row height
//        var headerHeight = 35; // your header height
//        return {
//            height: ($scope.gridOrderLines.data.length * rowHeight - headerHeight) + "px"
//            //height: ($scope.gridOrderLines.data.length * rowHeight + headerHeight) + "px"
//        };
//
//    };



    //***************Start Assign Shipment*************************************


    $scope.showHideShipmentPlan = function () {
        $scope.IsVisibleExistingShipment = $scope.IsVisibleExistingShipment ? false : true;
        toggleAssignShipmentButtonText();
    };

    var toggleAssignShipmentButtonText = function () {
        ctrl.ToggleButtonText = $scope.IsVisibleExistingShipment ? "Add to a new shipment" : "Add to an existing shipment"
    };

    var getPlannedShipment = function () {
        $http({
            method: 'GET',
            url: '/shipment/getPlannedShipment',
            params : {customerId: ctrl.customerData[0].customer_id}
        })
            .success(function(data) {
                ctrl.availablePlannedShipments = data;
                if(data.length > 0){
                    $scope.IsPlannedShipmentAvailable = true;

                }
                else{
                    $scope.IsVisibleExistingShipment = false;
                    $scope.IsPlannedShipmentAvailable = false;
                    toggleAssignShipmentButtonText();
                }
            });
    };

    var loadControlsForNewShipment = function (){
        ctrl.saveToNewShipment = saveToNewShipment;
        ctrl.assignToPlannedShipment = assignToPlannedShipment;
        ctrl.smallPackage = false;
        //ctrl.carrierCodeOptions = [ "UPS", "FedEx", "USPS", "CanadaPost", "DHL", "Puralator", "Roadway", "Yellow", "Con-way", "R&L", "Estes", "Wilson"];
        ctrl.serviceLevelOptions = ["NEXT DAY", "SECOND DAY", "GROUND"];
        getCustomerShippingAddress();
        //getAllListValueCarrierCode();
        ctrl.optAddress = 'existingAddress';
        ctrl.cutomerNameFieldEdit = ctrl.customerData[0].contact_name;
        ctrl.disableTrackingNo = false;
        if (ctrl.orderData[0].carrierCode) {
            ctrl.carrierCode = ctrl.orderData[0].carrierCode;
        }
        if (ctrl.orderData[0].serviceLevel) {
            ctrl.smallPackage = true;
            ctrl.loadServiceForCarrier();
            ctrl.serviceLevel = ctrl.orderData[0].serviceLevel;            
        }        
    }
 
    ctrl.disableTrackingNo = false;
    ctrl.loadServiceForCarrier = function(){
        $http({
            method: 'GET',
            url: '/easyPost/findServiceLevel',
            params : {carrier:ctrl.carrierCode}
        })
            .success(function(data) {
                if(data.length > 0){
                    ctrl.serviceLevelOptions = data;
                    ctrl.trackingNo = "";
                    ctrl.disableTrackingNo = true;

                }
                else{
                    ctrl.serviceLevelOptions = ["NEXT DAY", "SECOND DAY", "GROUND"];
                    ctrl.disableTrackingNo = false;
                }
            });
    };

    ctrl.editCutomerName = function(){
        ctrl.isEditCutomerName = true;
        //ctrl.cutomerNameFieldEdit = ctrl.customerData[0].contact_name;
    };

    var saveToNewShipment = function () {

        if(ctrl.addToNewShipment.$valid && !ctrl.truckValidationError) { 

            if(ctrl.selectedOrderLineList != null && ctrl.selectedOrderLineList.length == 1){
                ctrl.assignShipmentOrderLineNumber = ctrl.selectedOrderLineList;
                ctrl.selectedOrderLineList = null;
            }
            if (ctrl.optAddress == 'newAddress') {
                ctrl.newAddressForm.$setSubmitted();
                if (ctrl.newAddressForm.$valid) {
                    $http({
                        method  : 'POST',
                        url     : '/shipment/saveShipmentWithNewShippingAddress',
                        params: {carrierCode: ctrl.carrierCode,
                            isParcel: ctrl.smallPackage,
                            serviceLevel: ctrl.serviceLevel,
                            trackingNo: ctrl.trackingNo,
                            truckNumber: ctrl.truckNumber,
                            orderNumber: ctrl.selectedOrderNumber,
                            orderLineNumbers: ctrl.selectedOrderLineList,
                            orderLineNumber: ctrl.assignShipmentOrderLineNumber,
                            customerId: ctrl.customerData[0].customer_id,
                            streetAddress: ctrl.customerShippingStreetAddress,
                            city: ctrl.customerShippingCity,
                            state: ctrl.customerShippingState,
                            postCode: ctrl.customerShippingPostCode,
                            country: ctrl.customerShippingCountry,
                            contactName: ctrl.cutomerNameFieldEdit,
                            shipmentNotes:ctrl.shipmentNotes},
                        dataType: 'json',
                        headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                    })
                        .success(function(data) {

                            if(data['committedResult'] == true){
                                clearAssignShipmentForm();
                                //getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                                getAllShipmentsByOrder(ctrl.selectedOrderNumber);
                                $('#planToShipment').appendTo("body").modal('hide');
                                getSelectedOrderDetails(ctrl.selectedOrderNumber);
                                getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                                ctrl.selectedOrderLineCount = [];

                            }
                            else{
                                ctrl.assignShipmentWarning = true;
                                ctrl.assignShipmentWarningMessage = data['error'];
                                $timeout(function(){
                                    ctrl.assignShipmentWarning = false;
                                }, 5000);
                            }

                        }) 

                }             
            }
            else{
                $http({
                    method  : 'POST',
                    url     : '/shipment/saveShipment',
                    params: {carrierCode: ctrl.carrierCode,
                        isParcel: ctrl.smallPackage,
                        serviceLevel: ctrl.serviceLevel,
                        trackingNo: ctrl.trackingNo,
                        truckNumber: ctrl.truckNumber,
                        orderNumber: ctrl.selectedOrderNumber,
                        orderLineNumbers: ctrl.selectedOrderLineList,
                        orderLineNumber: ctrl.assignShipmentOrderLineNumber,
                        shippingAddressId: ctrl.shippingAddressFromOpt.id,
                        contactName: ctrl.cutomerNameFieldEdit,
                        shipmentNotes: ctrl.shipmentNotes},
                    dataType: 'json',
                    headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                })
                    .success(function(data) {

                        if(data['committedResult'] == true){
                            clearAssignShipmentForm();
                            //getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                            getAllShipmentsByOrder(ctrl.selectedOrderNumber);
                            $('#planToShipment').appendTo("body").modal('hide');
                            getSelectedOrderDetails(ctrl.selectedOrderNumber);
                            getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                            ctrl.selectedOrderLineCount = [];

                        }
                        else{
                            ctrl.assignShipmentWarning = true;
                            ctrl.assignShipmentWarningMessage = data['error'];
                            $timeout(function(){
                                ctrl.assignShipmentWarning = false;
                            }, 5000);
                        }

                    })
            }
        }
    };

    var assignToPlannedShipment = function(){

        if(ctrl.addToPlannedShipment.$valid) {

            if(ctrl.selectedOrderLineList != null && ctrl.selectedOrderLineList.length == 1){
                ctrl.assignShipmentOrderLineNumber = ctrl.selectedOrderLineList;
                ctrl.selectedOrderLineList = null;
            }

            $http({
                method  : 'POST',
                url     : '/shipment/assignToPlannedShipment',
                params: {shipmentId: ctrl.existingShipmentId,
                    orderNumber: ctrl.selectedOrderNumber,
                    orderLineNumbers: ctrl.selectedOrderLineList,
                    orderLineNumber: ctrl.assignShipmentOrderLineNumber},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(data) {
                    if(data['committedResult'] == true){
                        clearAssignShipmentForm();
                        //getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                        getAllShipmentsByOrder(ctrl.selectedOrderNumber);
                        getSelectedOrderDetails(ctrl.selectedOrderNumber);
                        ctrl.selectedOrderLineCount = []
                        $('#planToShipment').appendTo("body").modal('hide');
                        getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
                        ctrl.selectedOrderLineCount = [];
                    }
                    else{
                        ctrl.assignShipmentWarning = true;
                        ctrl.assignShipmentWarningMessage = data['error'];
                        $timeout(function(){
                            ctrl.assignShipmentWarning = false;
                        }, 5000);
                    }
                })

        }

    };

    var clearAssignShipmentForm = function () {
        ctrl.carrierCode = null;
        ctrl.smallPackage = null;
        ctrl.serviceLevel = null;
        ctrl.trackingNo = null;
        ctrl.truckNumber = null;
        ctrl.existingShipmentId = null;
        ctrl.customerShippingStreetAddress = null;
        ctrl.customerShippingCity = null;
        ctrl.customerShippingState = null;
        ctrl.customerShippingPostCode = null;
        ctrl.customerShippingCountry = null;
        ctrl.isEditCutomerName = false;
        ctrl.cutomerNameFieldEdit = '';
        ctrl.shipmentNotes = '';
        ctrl.serviceLevelOptions = ["NEXT DAY", "SECOND DAY", "GROUND"];
        ctrl.disableTrackingNo = false;

    };

    //***************End Assign Shipment*************************************

    //********************** Start Allocation******************************

    var allocate = function(shipmentData){
        if (ctrl.customerData[0].is_customer_hold == true) {
            $('#shipmentPlanWarning').appendTo("body").modal('show');
        }
        else{
            ctrl.shipmentIdForEdit = shipmentData.shipment_id;
            ctrl.shippingContact = shipmentData.contactName ? shipmentData.contactName : ctrl.customerData[0].contact_name;
            $('#allocationProcess').appendTo("body").modal('show');
            allocationFailedMessage();
            ctrl.locationId = '';
            $scope.gridInventory.data = data;
        }
        

    };

    var viewPicks = function(shipmentData){
        var sId = shipmentData.shipment_id;
        document.location = "/picking/pickingStatus#?shipmentId=" + sId
    };


    // var loadLocationAutoComplete = function () {
    //     $http.get('/stagingLaneShipment/getLocations')
    //         .success(function(data) {
    //             $scope.loadCompanyLocations= data;
    //         });
    // };

    $scope.loadLocationAutoComplete = function (value) {
                    return $http({
                        method: 'GET',
                        url: '/stagingLaneShipment/getLocationsByArea',
                        params : {keyword: value.keyword}
                    });

    }


    // $scope.$watch('ctrl.locationId', function(UserSearch) {
    //     if (UserSearch && UserSearch.length > 2) {
    //         $http.get('/stagingLaneShipment/getLocations').success(function(data) {
    //             $scope.loadCompanyLocations = data;
    //         });
    //     }
    //     var test = loadCompanyLocations.indexOf(contactName: UserSearch);
    // });

    var callback = function(value){
        ctrl.locationId = value;
        $http({
            method: 'GET',
            url: '/stagingLaneShipment/getShipment',
            params : {locationId: value}
        })

            .success(function (data) {
                //ctrl.selectedLocationLocationId = data[0].location_id;
                //
                //var info = "";
                //if(data.length > 0){
                //
                //    for (i = 0; i < data.length; i++) {
                //        info += data[i].shipment_id + '-' + data[i].shipment_status + '\n';
                //
                //    }
                //}
                //ctrl.selectedLocationShipment = info;

                $scope.gridShipmentAndCustomer.data = data;

            });



        //$http({
        //    method: 'GET',
        //    url: '/stagingLaneShipment/getInventory',
        //    params : {locationId: locationId}
        //})
        //
        //    .success(function (data) {
        //        ctrl.selectedLocationLocationId = data[0].location_id;
        //        var info = "";
        //        if(data.length > 0){
        //
        //            for (i = 0; i < data.length; i++) {
        //                info += data[i].lpn + '\n';
        //            }
        //        }
        //        ctrl.selectedLocationInventory = info;
        //
        //    });



        //$http({
        //    method: 'GET',
        //    url: '/picking/getInventoryByLocation',
        //    params : {selectedLocation: locationId}
        //})
        //
        //    .success(function (data) {
        //        //ctrl.selectedLocationLocationId = data[0].location_id;
        //        $scope.gridInventory.data = data;
        //
        //    });

        //if(ctrl.selectedLocationLocationId != locationId)
        //{
        //    ctrl.selectedLocationMessage = 'This Staging Location is Free';
        //}
    };


    //Start Inventory grid
    //$scope.gridInventory = {
    //    expandableRowTemplate: "<div ui-grid='row.entity.subGridOptions' style='height:150px;'></div>",
    //    expandableRowHeight: 150,
    //
    //    enableRowSelection: true,
    //    exporterMenuCsv: true,
    //    enableGridMenu: true,
    //    enableFiltering: false,
    //    gridMenuTitleFilter: fakeI18n,
    //    paginationPageSizes: [10, 50, 75],
    //    paginationPageSize: 10,
    //    columnDefs: [
    //        {name:'Location', field: 'grid_location_id'},
    //        {name:'Pallet Id', field: 'grid_pallet_id'},
    //        {name:'Case Id', field: 'grid_case_id'},
    //        {name:'Item Id', field: 'grid_item_id'},
    //        {name:'Description', field: 'grid_item_description'},
    //        {name:'Quantity', field: 'grid_quantity'},
    //        {name:'Unit Of Measure', field: 'grid_handling_uom'}
    //
    //    ],
    //    onRegisterApi: function( gridApi ){
    //        $scope.gridApi = gridApi;
    //
    //        gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {
    //
    //            if (row.isExpanded) {
    //                row.entity.subGridOptions = {
    //
    //                    columnDefs: [
    //                        {name:'Case Id', field: 'case_id'},
    //                        {name: 'Item Id 1', cellTemplate:'<a href="#" data-toggle="tooltip" title="Item: {{ row.entity.item_id}} \n Description: {{row.entity.item_description}} \n Category: {{row.entity.item_category}} \n Origin Code: {{row.entity.origin_code}} \n UPC Code: {{row.entity.upc_code}}"> {{row.entity.item_id}}</a>'},
    //                        {name:'Quantity', field: 'quantity'},
    //                        {name:'Unit Of Measure', field: 'handling_uom'}
    //                    ]};
    //
    //                $http({
    //                    method: 'GET',
    //                    url: '/inventory/getInventoryEntityAttributeForSearchRow',
    //                    params : {selectedRowPallet: row.entity.grid_pallet_id}
    //                })
    //                    .success(function(data) {
    //
    //                        if(data.length > 0){
    //                            row.entity.subGridOptions.data = data;
    //                        }
    //
    //                    });
    //
    //            }
    //        });
    //
    //        $interval( function() {
    //            gridApi.core.addToGridMenu( gridApi.grid, [{ title: 'Dynamic item', order: 100}]);
    //        }, 0, 1);
    //
    //        gridApi.core.on.columnVisibilityChanged( $scope, function( changedColumn ){
    //            $scope.columnChanged = { name: changedColumn.colDef.name, visible: changedColumn.colDef.visible };
    //        });
    //    }
    //};

    //End Inventory grid


    // shipment and customer

    $scope.gridShipmentAndCustomer = {
        enableRowSelection: true,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,
        columnDefs: [
            {name:'Shipment', field: 'shipment_id'},
            {name:'Shipment Status', field: 'shipment_status'},
            {name:'Customer', field: 'contact_name'},
            //{name:'Item Id', field: 'grid_item_id'},
            //{name:'Description', field: 'grid_item_description'},
            //{name:'Quantity', field: 'grid_quantity'},
            //{name:'Unit Of Measure', field: 'grid_handling_uom'}

        ],

        onRegisterApi: function( gridApi ){

            $scope.gridApiForGrid2 = gridApi;

            // interval of zero just to allow the directive to have initialized
            $interval( function() {
                gridApi.core.addToGridMenu( gridApi.grid, [{ title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged( $scope, function( changedColumn ){
                $scope.columnChanged = { name: changedColumn.colDef.name, visible: changedColumn.colDef.visible };
            });
        }
    };

    //



    var clearAutoCompText = function(){
        ctrl.locationId = '';
    };

    ctrl.clearAutoCompText = clearAutoCompText;

    var saveAllocation = function () {

        if( ctrl.allocationCreateFrom.$valid) {

            //alert(ctrl.locationId);
            //alert(ctrl.shipmentIdForEdit);
            $scope.loadingAnimSaveAllocation = true;
            $http({
                method  : 'POST',
                url     : '/picking/prepareAllocation',
                params: {shipmentId:ctrl.shipmentIdForEdit, destinationLocation: ctrl.locationId},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    getAllShipmentsByOrder(ctrl.selectedOrderNumber);
                    //$('#allocationProcess').appendTo("body").modal('hide');

                    if(data['allocationResult'] == true){
                        $('#allocationProcess').appendTo("body").modal('hide');
                        ctrl.allocationSuccessMessage = data['message'];
                        ctrl.showAllocationSuccessMessage = true;
                        $timeout(function(){
                            ctrl.showAllocationSuccessMessage = false;
                        }, 5000);
                    }
                    else {
                        //$('#allocationProcess').appendTo("body").modal('hide');
                        ctrl.allocationErrorMessage = data['message'];
                        ctrl.showAllocationErrorMessage = true;
                        $timeout(function(){
                            ctrl.showAllocationErrorMessage = false;
                            allocationFailedMessage();
                            //allocationFailedMessageViewPopUp();
                        }, 10000);
                    }

                })
                .finally(function () {
                  $scope.loadingAnimSaveAllocation = false;
                });                




        }
    };

    ctrl.saveAllocation = saveAllocation;



    ctrl.shipmentIdAllocationCancel = [];
    ctrl.allocationDisabled = [];
    ctrl.allocationFailedMessageDisplay = [];

    var cancelAllocationButton = function(shipmentId,index){
        //alert(index);
        $http({
            method: 'GET',
            url: '/stagingLaneShipment/getShipmentCancelAllocation',
            params : {shipmentId:shipmentId}
        })

            .success(function(data) {

                if(data.length > 0) {
                    ctrl.shipmentIdAllocationCancel[index] = true;
                    ctrl.allocationDisabled[index] = true;

                }
                else {
                    ctrl.shipmentIdAllocationCancel[index] = false;
                    ctrl.allocationDisabled[index] = false;
                }

            })
    };

    var allocationFailedMessageButton = function(shipmentId,index){
        //alert(index);
        $http({
            method: 'GET',
            url: '/stagingLaneShipment/getFailedMessageByShipmentForView',
            params : {shipmentId:shipmentId}
        })

            .success(function(data) {

                if(data.length > 0) {
                    ctrl.allocationFailedMessageDisplay[index] = true;

                }
                else {
                    ctrl.allocationFailedMessageDisplay[index] = false;
                }

            })
    };

    ctrl.allocate = allocate;
    ctrl.viewPicks = viewPicks;
    //loadLocationAutoComplete();
    ctrl.callback = callback;

//*******************End allocation**********************


    //***********Start Allocation failed message***********

    var allocationFailedMessage = function(){
        $http({
            method: 'GET',
            url: '/stagingLaneShipment/getFailedMessageByShipment',
            params : {shipmentId: ctrl.shipmentIdForEdit}
        })

            .success(function (data) {

                ctrl.allocationFailedMsg = data;

            });

    };


    var allocationFailedMessageViewPopUp = function(shipmentData){

        $http({
            method: 'GET',
            url: '/stagingLaneShipment/getFailedMessageByShipmentForView',
            params : {shipmentId: shipmentData.shipment_id}
        })

            .success(function (data) {
                ctrl.allocationFailedMsg = data;
                $('#allocationMessage').appendTo("body").modal('show');
                //alert(ctrl.allocationFailedMsg.length);
            });


    };
    ctrl.allocationFailedMessageViewPopUp = allocationFailedMessageViewPopUp;

    //*******End Allocation failed message**********


    //********************** Start Cancel Allocation**********************

    var cancelAllocation = function (shipmentId) {

        ctrl.getClickedShipmentId = shipmentId;

        $http({
            method: 'GET',
            url: '/picking/checkCompletedPicks',
            params : {shipmentId:shipmentId}
        })

            .success(function(data) {

                if (data.length == 0) {
                    $('#cancelAllocation').appendTo("body").modal('show');
                }

                else{
                    alert("This allocation cannot be cancelled");
                }

            })



    };


    $("#cancelAllocationButton").click(function(){


        $http({
            method  : 'POST',
            url     : '/picking/cancelAllocation',
            params: {shipmentId:ctrl.getClickedShipmentId, orderNum: ctrl.selectedOrderNumber},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                $('#cancelAllocation').modal('hide');
            })

    });

    ctrl.cancelAllocation = cancelAllocation;
//**********************end cancel allocation**********************

    ctrl.printOrderReport = function(){
        var format = 'PDF';
        var file = 'orderReport';
        var accessType = 'inline';
        var paramsOrderNumber = ctrl.selectedOrderNumber;
        ctrl.orderReportSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType+"&orderNumber="+paramsOrderNumber; 
        $('#viewOrderReportModel').appendTo("body").modal('show');  
        ctrl.mailSubject = "Foysonis Order Report - "+ctrl.selectedOrderNumber;
    }

    ctrl.openMailAddrModal = function(){
        ctrl.isEmailsent = false;
        ctrl.sendingEmailNow = false;
        ctrl.mailToAddress = '';
        ctrl.mailTextBody = '';
        $('#sendMailToModal').appendTo("body").modal('show'); 
        ctrl.mailToForm.$setUntouched();
        ctrl.mailToForm.$setPristine();
        
    }


    $scope.sendFileViaMail = function(){
        if( ctrl.mailToForm.$valid) {
            $('#sendMailToModal').modal('hide'); 
            $('#viewOrderReportModel').modal('hide'); 
            $('#sendingMailModal').appendTo("body").modal('show'); 
            $http({
                method  : 'POST',
                url     : '/report',
                params  : {fileFormat:'PDF', file:'orderReport', accessType:'inline', orderNumber:ctrl.selectedOrderNumber, isForMail:true },
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

    ctrl.validateOrderNum = function(viewValue){
        $http({
            method : 'GET',
            url : '/order/getSelectedOrderData',
            params: {orderNum: viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    ctrl.createOrderForm.orderNumber.$setValidity('orderNumberExists', true);
                }
                else
                {
                    ctrl.createOrderForm.orderNumber.$setValidity('orderNumberExists', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.createOrderForm.orderNumber.$setValidity('areaIdExists', false);
            });
    };

    ctrl.validateTruckNumber = function(viewValue){
        ctrl.truckValidationError = false;
        $http({
            method : 'GET',
            url : '/shipping/validateTruckNumber',
            params: {truckNumber: viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    // ctrl.addToNewShipment.truckNumber.$setValidity('24hdispachedTruckExist', true);
                    ctrl.truckValidationError = false;
                }
                else
                {
                    // ctrl.addToNewShipment.truckNumber.$setValidity('24hdispachedTruckExist', false);
                    ctrl.truckValidationErrorMsg = data.error
                    ctrl.truckValidationError = true;
                }

            })

    };


}])


    .directive('validateOrderNum', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {

                ctrl.$parsers.push(function (viewValue) {
                    // set it to true here, otherwise it will not
                    // clear out when previous validators fail.

                    // set it to false here, because if we need to check
                    // the validity of the email, it's invalid until the
                    // AJAX responds.

                    $http({
                        method : 'GET',
                        url : '/order/getSelectedOrderData',
                        params: {orderNum: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('orderNumberExists', true);
                            }
                            else
                            {
                                ctrl.$setValidity('orderNumberExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('areaIdExists', false);
                        });

                    return viewValue;
                });

            }
        };
    })


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
//*****************start location validation******************************

    //location id validation(uppercase,numbers)
    .directive('validateLocationId', function () {
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
    .directive('validateLocationIdUnique', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {




                ctrl.$parsers.push(function (viewValue) {
                    $http({
                        method : 'GET',
                        url : '/location/checkLocationIdExist',
                        params: {locationId: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('locationIdExists', true);
                            }
                            else
                            {
                                ctrl.$setValidity('locationIdExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('locationIdExists', false);
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


;

//*****************end location validation*****************************

