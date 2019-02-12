/**
 * Created by home on 9/10/15.
 */

var app = angular.module('adminKittingOrder', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.bootstrap', 'ui.grid.pagination', 'ui.grid.resizeColumns', 'ui.grid.autoResize', 'inventory-autocomplete']);

app.controller('kittingOrderCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', function ($scope, $http, $interval, $q, $timeout) {


    var myEl = angular.element( document.querySelector( '#liKitting' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulKitting' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };

    var ctrl = this,
        newKittingOrder = {kittingItemId:'', finishedProductInventoryStatus:'', productionQuantity: null,productionUom:'', kittingOrderNumber:''};

    // START BOM Search

    var showHideSearch = function () {
        ctrl.isBOMSearchVisible = ctrl.isBOMSearchVisible ? false : true;
    };

    ctrl.showHideSearch = showHideSearch;

    var getDefaultSelectedKittingOrder = function (){
        if(ctrl.kittingOrderList.length > 0){
            ctrl.selectedKittingOrder = ctrl.kittingOrderList[0];
            ctrl.selectedItemId = ctrl.selectedKittingOrder.kitting_order_number;
            getAllKittingOrderComponents(ctrl.selectedKittingOrder.kitting_order_number);
            getAllKittingOrderInstruction(ctrl.selectedKittingOrder.kitting_order_number);
            getAllKittingOrderInventory(ctrl.selectedKittingOrder.kitting_order_number);
            allocationFailedMessageButton(ctrl.selectedKittingOrder.kitting_order_number,0);
            getAllKittingComponentInventory(ctrl.selectedKittingOrder.kitting_order_number);
        }
        //ctrl.isShowBOMDetails = true;
    }

    //Get all BOM list
    var getAllKittingOrders = function () {

        $http({
            method: 'GET',
            url: '/kittingOrder/searchKittingOrderForCount'
        })
            .success(function (data) {
                ctrl.totalNumOfOrders = data[0].total_Kitting_orders;
                var totalPagesInFloat = parseInt(ctrl.totalNumOfOrders) / 20;
                ctrl.totalNumOfPages = Math.ceil(totalPagesInFloat);
            });

        $http({
            method: 'GET',
            url: '/kittingOrder/getAllKittingOrderWithItemDetailsByCompanyId'
        })
            .success(function (data, status, headers, config) {
                ctrl.kittingOrderList = data;
                getDefaultSelectedKittingOrder();
                ctrl.orderSearchPageNum = 1;

            })
    };
    getAllKittingOrders();


    ctrl.kittingSearchForNextPrev = function(nav){

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
            url: '/kittingOrder/searchKittingOrderForCount',
            params: {itemId: ctrl.searchKittingOrder.itemId,
                     kittingOrderNumber:ctrl.searchKittingOrder.kittingOrderNumber,
                     kittingOrderStatus: ctrl.searchKittingOrder.kittingOrderStatus,
                     orderNumber: ctrl.searchKittingOrder.orderNumber},

            //params: {orderNumber:ctrl.orderNumber},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                ctrl.totalNumOfOrders = data[0].total_Kitting_orders;
                var totalPagesInFloat = parseInt(ctrl.totalNumOfOrders) / 20;
                ctrl.totalNumOfPages = Math.ceil(totalPagesInFloat);
            });

        $http({
            method: 'POST',
            url: '/kittingOrder/searchKittingOrderByCompanyIdAndItemId',
            params: {customerName:ctrl.customer, orderNumber:ctrl.orderNumber, orderStatus: ctrl.orderStatus,
                fromEarlyShipDate:ctrl.fromEarlyShipDate, toEarlyShipDate:ctrl.toEarlyShipDate,
                fromLateShipDate:ctrl.fromLateShipDate, toLateShipDate:ctrl.toLateShipDate,
                requestedShipSpeed:ctrl.requestedShipSpeed, shipmentId:ctrl.shipmentIdSearch, shipmentStatus:ctrl.shipmentStatusSearch, currentPageNum:ctrl.orderSearchPageNum,currentPageNum:ctrl.orderSearchPageNum},

            //params: {orderNumber:ctrl.orderNumber},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                ctrl.kittingOrderList = data;
                getDefaultSelectedKittingOrder();
            })

    };


    ctrl.searchKittingOrder = {};

    var kittingOrderSearch = function () {

        $http({
            method: 'POST',
            url: '/kittingOrder/searchKittingOrderForCount',
            params: {itemId: ctrl.searchKittingOrder.itemId,
                     kittingOrderNumber:ctrl.searchKittingOrder.kittingOrderNumber,
                     kittingOrderStatus: ctrl.searchKittingOrder.kittingOrderStatus,
                     orderNumber: ctrl.searchKittingOrder.orderNumber},

            //params: {orderNumber:ctrl.orderNumber},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                ctrl.totalNumOfOrders = data[0].total_Kitting_orders;
                var totalPagesInFloat = parseInt(ctrl.totalNumOfOrders) / 20;
                ctrl.totalNumOfPages = Math.ceil(totalPagesInFloat);
            });


        $http({
            method: 'GET',
            url: '/kittingOrder/searchKittingOrderByCompanyIdAndItemId',
            params: {itemId: ctrl.searchKittingOrder.itemId,
                     kittingOrderNumber:ctrl.searchKittingOrder.kittingOrderNumber,
                     kittingOrderStatus: ctrl.searchKittingOrder.kittingOrderStatus,
                     orderNumber: ctrl.searchKittingOrder.orderNumber}
        })
            .success(function (data) {
                ctrl.kittingOrderList = data;
                getDefaultSelectedKittingOrder();
                ctrl.orderSearchPageNum = 1;


            })

    };
    ctrl.kittingOrderSearch = kittingOrderSearch;

    // END BOM Search

    // START Create BOM
    ctrl.newKittingOrder = newKittingOrder;
    ctrl.newComponent = {};
    ctrl.newInstruction = {};
    var clearCreateForm = function (){
        ctrl.newKittingOrder.kittingOrderNumber = "";
        ctrl.newKittingOrder.kittingItemId = "";
        ctrl.newKittingOrder.productionQuantity = "";
        ctrl.newKittingOrder.productionUom = "";
        ctrl.createKittingOrderForm.$setUntouched();
        ctrl.createKittingOrderForm.$setPristine();
        ctrl.disableProductionUom = false;
    }

    var showCreateKittingOrderForm = function () {
        //document.getElementById('components').className = "tab-pane fade";
        document.getElementById('components').className = "tab-pane fade in active";
        //document.getElementById('liComponents').className = "";
        //document.getElementById('liBOM').className = "active";
        clearCreateForm();
        $scope.IsVisibleNewKittingOrderWindow = $scope.IsVisibleNewKittingOrderWindow ? false : true;
        //ctrl.isShowBOMDetails = false;

        if (ctrl.inventoryStatusOptions[0]) {
            ctrl.newKittingOrder.finishedProductInventoryStatus = ctrl.inventoryStatusOptions[0].optionValue;
        }
    };

    var showComponentsCreateForm = function () {
        if (ctrl.selectedKittingOrder.kitting_order_status == 'OPEN') {
            ctrl.newComponent.kittingOrderNumber = ctrl.selectedKittingOrder.kitting_order_number;
            $scope.isVisibleNewComponentWindow = true;
            $scope.isVisibleEditComponentWindow = false;
            //ctrl.isShowBOMDetails = false;

            if (ctrl.inventoryStatusOptions[0]) {
                ctrl.newComponent.componentInventoryStatus = ctrl.inventoryStatusOptions[0].optionValue;
            }            
        }
        else{
            $('#dvCreateKOComponentWarning').appendTo('body').modal('show');
        }

    };

    ctrl.showCreateKittingOrderForm = showCreateKittingOrderForm;
    ctrl.showComponentsCreateForm = showComponentsCreateForm;

    var cancelCreateKittingOrder = function () {
        $scope.IsVisibleNewKittingOrderWindow = false;
        //ctrl.isShowBOMDetails = true;
        clearCreateForm();
    };
    ctrl.cancelCreateKittingOrder = cancelCreateKittingOrder;

    var showKOMessages = function (field) {
        return ctrl.createKittingOrderForm[field].$touched || ctrl.createKittingOrderForm.$submitted
    };
    var hasKOErrorClass = function (field) {
        return ctrl.createKittingOrderForm[field].$touched && ctrl.createKittingOrderForm[field].$invalid;
    };
    ctrl.showKOMessages = showKOMessages;
    ctrl.hasKOErrorClass = hasKOErrorClass;

    $scope.sourceItems = function (value) {

        return $http({
            method: 'GET',
            url: '/item/getItems',
            params : {keyword: value.keyword}
        });

    };

    $scope.data = {};
    var validateItemId = function(itemId){
        $http({
            method: 'GET',
            url: '/inventory/findItem',
            params : {itemId: itemId}
        })

        .success(function (data, status, headers, config) {

            if(data.length > 0){
                    if(data[0].lowestUom.toUpperCase() == 'EACH'){
                        ctrl.disableProductionUom = true;
                        $scope.data = {
                            availableOptions: [
                                {id: 'EACH', name: 'EACH'},
                            ]
                        };
                        ctrl.newKittingOrder.productionUom ='EACH';
                    }
                    else if(data[0].lowestUom.toUpperCase() == 'CASE'){
                        ctrl.disableProductionUom = true;
                        $scope.data = {
                            availableOptions: [
                                {id: 'CASE', name: 'CASE'}
                            ]
                        };
                        ctrl.newKittingOrder.productionUom ='CASE';
                    }
                    else{
                            ctrl.disableProductionUom = true;
                            $scope.data = {
                                availableOptions: [
                                    {id: 'PALLET', name: 'PALLET'}
                                ]
                            };
                            ctrl.newKittingOrder.productionUom ='PALLET';
                        }
                    }

        })
    };

    var validateItemIdEdit = function(itemId){
        $http({
            method: 'GET',
            url: '/inventory/findItem',
            params : {itemId: itemId}
        })

        .success(function (data, status, headers, config) {

            if(data.length > 0){
                    if(data[0].lowestUom.toUpperCase() == 'EACH'){
                        ctrl.disableProductionUom = true;
                        $scope.data = {
                            availableOptions: [
                                {id: 'EACH', name: 'EACH'},
                            ]
                        };
                        ctrl.selectedKittingOrder.production_uom ='EACH';
                    }
                    else if(data[0].lowestUom.toUpperCase() == 'CASE'){
                        ctrl.disableProductionUom = true;
                        $scope.data = {
                            availableOptions: [
                                {id: 'CASE', name: 'CASE'}
                            ]
                        };
                        ctrl.selectedKittingOrder.production_uom ='CASE';
                    }
                    else{
                            ctrl.disableProductionUom = true;
                            $scope.data = {
                                availableOptions: [
                                    {id: 'PALLET', name: 'PALLET'}
                                ]
                            };
                            ctrl.selectedKittingOrder.production_uom ='PALLET';
                        }
                    }

        })
    };
    
    ctrl.validateItemId = validateItemId;    
    ctrl.validateItemIdEdit = validateItemIdEdit;

    
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

    var findObjWithValue = function(value){

        $http({
            method: 'GET',
            url: '/kittingOrder/getAllKittingOrderWithItemDetailsByCompanyId'
        })
        .success(function (data, status, headers, config) {
            ctrl.kittingOrderList = data;
            for(var i = 0; i < ctrl.kittingOrderList.length; i += 1) {
                if(ctrl.kittingOrderList[i].kitting_order_number === value) {
                    getAllListValueInventoryStatus();
                    ctrl.getClickedKittingOrder(i);
                    //ctrl.selectedKittingOrder.finished_product_inventory_status = ctrl.kittingOrderList[i].finished_product_inventory_status
                    ctrl.isShowEditKittingOrderForm = true;
                }
            }            

        })
    };

    ctrl.checkAndCopyBOMDataToKitting = function(itemId){
        ctrl.showKONumberToCopyForm = false;
        ctrl.showOrderNumberExistError = false;
        ctrl.showOrderNumberRequiredError = false;
        $http({
            method: 'GET',
            url: '/billMaterial/getBillOfMaterialByCompanyIdAndItemId',
            params: {itemId: itemId}
        })
        .success(function (data) {

            if(data){
                $('#dvCopyBOMWarning').appendTo('body').modal('show');
                ctrl.copyBOMItem = itemId
            }

        })        
    };

    ctrl.copyBOMDataButton = function(){
        ctrl.kittingOrderNumForCopy = ctrl.newKittingOrder.kittingOrderNumber;
        ctrl.showKONumberToCopyForm = true;
    };


    ctrl.copyBOMDataAndCreateKitting = function(){

            if (ctrl.kittingOrderNumForCopy) {
                ctrl.showOrderNumberRequiredError = false;
                $http({
                    method : 'GET',
                    url : '/kittingOrder/getSelectedKittingOrderByKittingOrderNumber',
                    params: {kittingOrderNumber: ctrl.kittingOrderNumForCopy}
                })
                    .success(function (data, status, headers, config) {

                        if(data.length == 0){
                            ctrl.showOrderNumberExistError = false;
                            $http({
                                method  : 'POST',
                                url     : '/kittingOrder/copyBOMDataToKittingOrder',
                                params  : {itemId: ctrl.copyBOMItem, kittingOrderNumber:ctrl.kittingOrderNumForCopy},
                                dataType: 'json',
                                headers : { 'Content-Type': 'application/json; charset=utf-8' }
                            })
                            .success(function(response) {
                                clearCreateForm();
                                $scope.IsVisibleNewKittingOrderWindow = false;
                                findObjWithValue(response.kittingOrderNumber);
                                ctrl.copyBOMItem = '';
                                $('#dvCopyBOMWarning').modal('hide');
                                ctrl.showKONumberToCopyForm = false;
                                ctrl.kittingOrderNumForCopy = '';
                                ctrl.showBOMCopyPrompt = true;
                                $timeout(function(){
                                    ctrl.showBOMCopyPrompt = false;
                                }, 5000);

                            })
                        }
                        else{
                            ctrl.showOrderNumberExistError = true;
                        }

                    })
                    .error(function (data, status, headers, config) {
                        ctrl.showOrderNumberExistError = true;
                    });                
            }
            else{
                ctrl.showOrderNumberRequiredError = true;
                ctrl.showOrderNumberExistError = false;
            }
    };

    var createKittingOrder = function () {


        if( ctrl.createKittingOrderForm.$valid) {

            ctrl.createKOBtnDisable = true;
            $http({
                method: 'GET',
                url: '/billMaterial/getBillOfMaterialByCompanyIdAndItemId',
                params: {itemId: ctrl.newKittingOrder.kittingItemId}
            })
                .success(function (data) {

                    if(data){

                        ctrl.showBOMDuplicatedItemIdPrompt = true;
                        $timeout(function(){
                            ctrl.showBOMDuplicatedItemIdPrompt = false;
                        }, 5000);

                    }

                })
                .error(function (data, status, headers, config) {
                    ctrl.createKOBtnDisable = true;
                    $http({
                        method  : 'POST',
                        url     : '/kittingOrder/saveKittingOrder',
                        data    :  ctrl.newKittingOrder,
                        dataType: 'json',
                        headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                    })
                        .success(function(response) {

                            $scope.IsVisibleNewKittingOrderWindow = false;
                            ctrl.showBOMDuplicatedItemIdPrompt = false;
                            //ctrl.isShowBOMDetails = true;
                            ctrl.showBOMCopyPrompt = false;
                            ctrl.showKOUpdatedPrompt = false;
                            ctrl.showKOSubmittedPrompt = true;
                            $timeout(function(){
                                ctrl.showKOSubmittedPrompt = false;
                            }, 5000);

                            getAllKittingOrders();
                            clearCreateForm();
                            ctrl.orderSearchPageNum = 1;

                        })
                        .finally(function(){
                            ctrl.createKOBtnDisable = false;
                        })

                })
                .finally(function(){
                    ctrl.createKOBtnDisable = false;
                })
        }
    };  
    ctrl.createKittingOrder = createKittingOrder;


    // END Create BOM

    var getClickedKittingOrder = function(clickedIndex){
        ctrl.selectedKittingOrderIndex = clickedIndex;
        ctrl.selectedKittingOrder = ctrl.kittingOrderList[clickedIndex];
        ctrl.selectedItemId = ctrl.selectedKittingOrder.kitting_order_number;

        ctrl.isShowEditKittingOrderForm = false;
        //ctrl.isShowBOMDetails = true;
        $scope.IsVisibleNewKittingOrderWindow = false;
        getAllKittingOrderComponents(ctrl.selectedKittingOrder.kitting_order_number);
        getAllKittingOrderInstruction(ctrl.selectedKittingOrder.kitting_order_number);
        getAllKittingOrderInventory(ctrl.selectedKittingOrder.kitting_order_number);
        getAllKittingComponentInventory(ctrl.selectedKittingOrder.kitting_order_number);

        allocationFailedMessageButton(ctrl.selectedKittingOrder.kitting_order_number,clickedIndex)
    };
    ctrl.getClickedKittingOrder = getClickedKittingOrder;

    //START KITTING Edit
    var showEditKittingOrderForm = function () {
        if (ctrl.selectedKittingOrder.kitting_order_status == 'OPEN') {
            getAllListValueInventoryStatus();
            validateItemIdEdit(ctrl.selectedItemId);
            //ctrl.isShowBOMDetails = false;
            //ctrl.showBOMSubmittedPrompt = false;
            //ctrl.showBOMDuplicatedItemIdPrompt = false;
            //ctrl.showBOMDuplicatedEditItemIdPrompt = false;
            //ctrl.showBOMUpdatedPrompt = false;
            //ctrl.showBOMDeletedPrompt = false;
            $scope.IsVisibleNewKittingOrderWindow = false;
            ctrl.isShowEditKittingOrderForm = true;
            location.href = "#";
            location.href = "#editKittingOrderPanel";            
        }
        else{
            $('#dvEditKittingWarning').appendTo('body').modal('show');
        }



    }
    ctrl.showEditKittingOrderForm = showEditKittingOrderForm;

    var cancelEditKittingOrder = function () {
        ctrl.isShowEditKittingOrderForm = false;
        //ctrl.isShowBOMDetails = true;
        clearCreateForm();
    };
    ctrl.cancelEditKittingOrder = cancelEditKittingOrder;



    var updateKittingOrder = function () {

        if( ctrl.editKittingOrderForm.$valid) {


            if(ctrl.selectedItemId != ctrl.selectedKittingOrder.kitting_order_number){
                $http({
                    method: 'GET',
                    url: '/billMaterial/getBillOfMaterialByCompanyIdAndItemId',
                    params: {itemId: ctrl.selectedKittingOrder.kitting_item_id}
                })
                    .success(function (data) {

                        if(data){

                            ctrl.showBOMDuplicatedEditItemIdPrompt = true;
                            $timeout(function(){
                                ctrl.showBOMDuplicatedEditItemIdPrompt = false;
                            }, 5000);

                        }

                    })
                    .error(function (data, status, headers, config) {
                        $http({
                            method  : 'POST',
                            url     : '/kittingOrder/updateKittingOrder',
                            data    :  ctrl.selectedKittingOrder,
                            dataType: 'json',
                            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                        })
                            .success(function(data) {

                                ctrl.isShowEditKittingOrderForm = false;
                                //ctrl.isShowBOMDetails = true;
                                //ctrl.showBOMDuplicatedEditItemIdPrompt = false;
                                ctrl.showBOMCopyPrompt = false;
                                ctrl.showKOSubmittedPrompt = false;
                                ctrl.showKOUpdatedPrompt = true;
                                $timeout(function(){
                                    ctrl.showKOUpdatedPrompt = false;
                                }, 5000);

                                getAllKittingOrders();
                                clearCreateForm();

                            })

                    })
            }
            else{
                $http({
                    method  : 'POST',
                    url     : '/kittingOrder/updateKittingOrder',
                    data    :  ctrl.selectedKittingOrder,
                    dataType: 'json',
                    headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                })
                    .success(function(data) {

                        ctrl.isShowEditKittingOrderForm = false;
                        //ctrl.isShowBOMDetails = true;
                        //ctrl.showBOMDuplicatedEditItemIdPrompt = false;

                        ctrl.showKOUpdatedPrompt = true;
                        $timeout(function(){
                            ctrl.showKOUpdatedPrompt = false;
                        }, 5000);

                        getAllKittingOrders();
                        clearCreateForm();

                    })

            }

        }
    };
    ctrl.updateKittingOrder = updateKittingOrder;

    //END BOM Edit

    // BOM delete

    ctrl.deleteKittingOrder = function(){
        if (ctrl.selectedKittingOrder.kitting_order_status == 'OPEN') {
            $('#dvDeleteKOWarning').appendTo('body').modal('show');
        }
        else{
            $('#dvDeleteKittingWarning').appendTo('body').modal('show');
        }
        
    };

    $('#koDeleteButton').click(function(){
        $http({
            method  : 'POST',
            url     : '/kittingOrder/deleteKittingOrder',
            data    :  {itemId:ctrl.selectedKittingOrder.kitting_item_id, kittingOrderNumber:ctrl.selectedKittingOrder.kitting_order_number},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
            .success(function(response) {
                $('#dvDeleteKOWarning').modal('hide');
                getAllKittingOrders();
                clearCreateForm();
                ctrl.showKODeletedPrompt = true;
                $timeout(function(){
                    ctrl.showKODeletedPrompt = false;
                }, 5000);

            })
    });    

    // component create

    var createComponent = function () {

        if( ctrl.createComponentForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/kittingOrder/saveKittingOrderComponent',
                data    :  ctrl.newComponent,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(response) {
                    $scope.isVisibleNewComponentWindow = false;
                    //ctrl.isShowBOMDetails = true;
                    clearNewComponentForm();
                    getAllKittingOrderComponents(ctrl.selectedKittingOrder.kitting_order_number);
                    ctrl.showComponentSubmittedPrompt = true;
                    $timeout(function(){
                        ctrl.showComponentSubmittedPrompt = false;
                    }, 5000);
                })
        }
    };    
    
    ctrl.createComponent = createComponent;

    // END Component create

    // get Component
    var getAllKittingOrderComponents = function (kittingOrdNum) {
        $http({
            method: 'GET',
            url: '/kittingOrder/getAllKOComponentDataByCompanyIdAndOrdNum',
            params:{kittingOrdNum:kittingOrdNum}
        })
        .success(function (data, status, headers, config) {
            $scope.gridKittingOrderComponents.data = data;
        })
    };

    $scope.gridKittingOrderComponents = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        columnDefs: [
            {name:'Component Item Id', field: 'component_item_id'},
            {name:'BOM Quantity' , field: 'component_quantity'},
            {name:'Component UOM' , field: 'component_uom'},
            {name:'Component Status' , field: 'componentInventoryStatusDesc'},
            {name: 'Actions', enableSorting: false, enableFiltering: false,  cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.editComponent(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.deleteComponent(row)">Delete</a></li></ul></div>'}

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

    // clear component

    var clearNewComponentForm = function (){
        ctrl.newComponent.componentItemId = '';
        ctrl.newComponent.componentQuantity = '';
        ctrl.newComponent.componentInventoryStatus = '';
        ctrl.newComponent.componentUom = '';
        ctrl.createComponentForm.$setUntouched();
        ctrl.createComponentForm.$setPristine();
        ctrl.disableProductionUom = false;

    }

    // close new component form

    ctrl.closeNewComponent = function(){
        clearNewComponentForm();
        $scope.isVisibleNewComponentWindow = false;
        //ctrl.isShowBOMDetails = true;
    };

    ctrl.closeEditComponent = function(){
        ctrl.editComponent.componentItemId = ''; 
        ctrl.editComponent.componentQuantity = '';
        ctrl.editComponent.componentInventoryStatus = '';
        ctrl.editComponent.componentUom = '';
        $scope.isVisibleEditComponentWindow = false;
        //ctrl.isShowBOMDetails = true;
    };

    var validateItemIdComponent = function(itemId, UOM){
        $http({
            method: 'GET',
            url: '/inventory/findItem',
            params : {itemId: itemId}
        })

        .success(function (data, status, headers, config) {

            if(data.length > 0){
                    if(data[0].lowestUom.toUpperCase() == 'EACH'){
                        ctrl.disableProductionUom = false;
                        $scope.data = {
                            availableOptions: [
                                {id: 'EACH', name: 'EACH'},
                                {id: 'CASE', name: 'CASE'}
                            ]
                        };
                        ctrl.newComponent.componentUom ='EACH';
                        ctrl.disableProductionUom = false;
                    }
                    else if(data[0].lowestUom.toUpperCase() == 'CASE'){
                        ctrl.disableProductionUom = true;
                        $scope.data = {
                            availableOptions: [
                                {id: 'CASE', name: 'CASE'}
                            ]
                        };
                        ctrl.newComponent.componentUom ='CASE';
                        ctrl.disableProductionUom = true;
                    }
                    else{
                            ctrl.disableProductionUom = true;
                            $scope.data = {
                                availableOptions: [
                                    {id: 'PALLET', name: 'PALLET'}
                                ]
                            };
                            ctrl.newComponent.componentUom ='PALLET';
                            ctrl.disableProductionUom = true;
                        }
                    }

        })
    };

    var validateItemIdComponentEdit = function(itemId, UOM){
        $http({
            method: 'GET',
            url: '/inventory/findItem',
            params : {itemId: itemId}
        })

        .success(function (data, status, headers, config) {

            if(data.length > 0){
                    if(data[0].lowestUom.toUpperCase() == 'EACH'){
                        ctrl.disableProductionUom = false;
                        $scope.data = {
                            availableOptions: [
                                {id: 'EACH', name: 'EACH'},
                                {id: 'CASE', name: 'CASE'}
                            ]
                        };
                        ctrl.editComponent.componentUom ='EACH';
                        ctrl.disableProductionUom = false;
                    }
                    else if(data[0].lowestUom.toUpperCase() == 'CASE'){
                        ctrl.disableProductionUom = true;
                        $scope.data = {
                            availableOptions: [
                                {id: 'CASE', name: 'CASE'}
                            ]
                        };
                        ctrl.editComponent.componentUom ='CASE';
                        ctrl.disableProductionUom = true;
                    }
                    else{
                            ctrl.disableProductionUom = true;
                            $scope.data = {
                                availableOptions: [
                                    {id: 'PALLET', name: 'PALLET'}
                                ]
                            };
                            ctrl.editComponent.componentUom ='PALLET';
                            ctrl.disableProductionUom = true;
                        }
                    }

        })
    };
    ctrl.validateItemIdComponent = validateItemIdComponent;
    ctrl.validateItemIdComponentEdit = validateItemIdComponentEdit;

    // edit component
    $scope.isVisibleEditComponentWindow = false;
    $scope.editComponent = function(row) {
        if (ctrl.selectedKittingOrder.kitting_order_status == 'OPEN') {
            ctrl.editComponent = {};
            validateItemIdComponentEdit(row.entity.component_item_id);
            ctrl.editComponent.componentId = row.entity.id;
            ctrl.editComponent.kittingOrderNumber = row.entity.kitting_order_number;
            ctrl.editComponent.componentItemId = row.entity.component_item_id; 
            ctrl.editComponent.componentQuantity = row.entity.component_quantity;
            ctrl.editComponent.componentInventoryStatus = row.entity.component_inventory_status;
            ctrl.editComponent.componentUom = row.entity.component_uom;
            //ctrl.isShowBOMDetails = false;
            $scope.isVisibleEditComponentWindow = true;
            $scope.isVisibleNewComponentWindow = false;
        }
        else{
            $('#dvEditKOComponentWarning').appendTo('body').modal('show');
        }

    };

    //update component

    ctrl.updateComponent = function(){
        if( ctrl.upddateComponentForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/kittingOrder/updateKittingOrderComponent',
                data    :  ctrl.editComponent,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(response) {
                    ctrl.closeEditComponent();
                    getAllKittingOrderComponents(ctrl.selectedKittingOrder.kitting_order_number);
                    ctrl.showComponentUpdatedPrompt = true;
                    $timeout(function(){
                        ctrl.showComponentUpdatedPrompt = false;
                    }, 5000);

                })
        }
    };

    // delete component

    $scope.deleteComponent = function(row){
        if (ctrl.selectedKittingOrder.kitting_order_status == 'OPEN') {
          $('#componentDeleteWarning').appendTo("body").modal('show');
          ctrl.componentRow = row.entity;  
        }
        else{
            $('#dvDeleteKOComponentWarning').appendTo("body").modal('show');
        }
         
    };

    $('#deleteComponentButton').click(function(){
        $http({
            method  : 'POST',
            url     : '/kittingOrder/deleteKittingOrderComponent',
            data    :  {componentId:ctrl.componentRow.id,componentItemId:ctrl.componentRow.component_item_id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
            .success(function(response) {
                $('#componentDeleteWarning').modal('hide');
                getAllKittingOrderComponents(ctrl.selectedKittingOrder.kitting_order_number);
                ctrl.showComponentDeletedPrompt = true;
                $timeout(function(){
                    ctrl.showComponentDeletedPrompt = false;
                }, 5000);

            })
    });



    //Instructions
    var getAllInstructionTypes = function () {
        $http({
            method: 'GET',
            url: '/listValue/getBOMInstructionType'
        })
            .success(function (data, status, headers, config) {
                ctrl.instructionTypeObj = data;
            })
    };

    getAllInstructionTypes();

    // create Instruction

    var showInstructionCreateForm = function () {
        if (ctrl.selectedKittingOrder.kitting_order_status == 'OPEN') {
            ctrl.newInstruction.kittingOrderNumber = ctrl.selectedKittingOrder.kitting_order_number;
            $scope.isVisibleNewInstructionWindow = true;
            $scope.isVisibleEditInstructionWindow = false;
            ctrl.newInstruction.instructionType = "Mandatory";
        }
        else{
            $('#dvCreateKOInstuctionWarning').appendTo("body").modal('show');
        }

    };    

    var createInstruction = function () {

        if( ctrl.createInstructionForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/kittingOrder/saveKittingOrderInstruction',
                data    :  ctrl.newInstruction,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(response) {
                    ctrl.closeNewInstruction();
                    getAllKittingOrderInstruction(ctrl.selectedKittingOrder.kitting_order_number);
                    ctrl.showInstructionSubmittedPrompt = true;
                    $timeout(function(){
                        ctrl.showInstructionSubmittedPrompt = false;
                    }, 5000);                    

                })
        }
    };    

    ctrl.selectInstructionType = function(object){
        if (object.instructionType != "Mandatory") {
            ctrl.disableInstructionInventoryStatus = true;
            object.inventoryStatus = '';
        }
        else{
            ctrl.disableInstructionInventoryStatus = false;
        }
    };
    
    ctrl.createInstruction = createInstruction;
    ctrl.showInstructionCreateForm = showInstructionCreateForm;

    $scope.gridKttingOrderInstructions = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        columnDefs: [
            {name:'Instruction Id' , field: 'instruction_id'},
            {name:'Instruction Type' , field: 'instruction_type'},
            {name:'Inventory Status' , field: 'inventoryStatusDesc'},
            {name:'Instruction', cellTemplate: '<span><a href="javascript:void(0)" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;" popover-trigger="outsideClick" ng-show="row.entity.instruction" uib-popover="{{row.entity.instruction}}" popover-title="" popover-append-to-body="true" >View</a></span>'},
            {name: 'Actions', enableSorting: false, enableFiltering: false,  cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px; float: left;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.editInstruction(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.deleteInstruction(row)">Delete</a></li></ul></div><div style="float: left; width: 70px;">&nbsp;&nbsp;{{row.entity.instruction_id}}</div><div style="float: left; width: 25px;" ><button  class="moveBtnGrid" ng-if="grid.appScope.isDisplayMoveUp(row)" ng-click="grid.appScope.moveUpInstruction(row)" title="Move Up"><img src="/foysonis2016/app/img/grid_move_up.png" width="22px"></button>&nbsp;</div> <div class="btn-group mb-sm" style="float: left; width: 25px;" ><button class="moveBtnGrid" ng-if="grid.appScope.isDisplayMoveDown(row)" ng-click="grid.appScope.moveDownInstruction(row)" title="Move Down"><img src="/foysonis2016/app/img/grid_move_down.png" width="22px"></button>&nbsp;</div>'}

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

    var getAllKittingOrderInstruction = function (kittingOrdNum) {
        $http({
            method: 'GET',
            url: '/kittingOrder/getAllKittingOrderInstructionDataByCompanyIdAndBomId',
            params:{kittingOrdNum:kittingOrdNum}
        })
        .success(function (data, status, headers, config) {
            $scope.gridKttingOrderInstructions.data = data;
        })
    };    

    ctrl.closeNewInstruction = function(){
        ctrl.newInstruction.bomId = '';
        ctrl.newInstruction.instructionId = ''; 
        ctrl.newInstruction.instruction = '';
        ctrl.newInstruction.instructionType = '';
        ctrl.newInstruction.inventoryStatus = '';
        $scope.isVisibleNewInstructionWindow = false;    
        ctrl.createInstructionForm.$setUntouched();
        ctrl.createInstructionForm.$setPristine(); 
    };

    //edit component

    ctrl.closeEditInstruction = function(){
        ctrl.editInstruction.instructionIdPrimary = '';
        ctrl.editInstruction.bomId = '';
        ctrl.editInstruction.instructionId = ''; 
        ctrl.editInstruction.instruction = '';
        ctrl.editInstruction.instructionType = '';
        ctrl.editInstruction.inventoryStatus = '';
        $scope.isVisibleEditInstructionWindow = false;  
    };

    ctrl.updateInstruction = function(){

        if( ctrl.editInstructionForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/kittingOrder/updateKittingOrderInstruction',
                data    :  ctrl.editInstruction,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(response) {
                    ctrl.closeEditInstruction();
                    getAllKittingOrderInstruction(ctrl.selectedKittingOrder.kitting_order_number);
                    ctrl.showInstructionUpdatedPrompt = true;
                    $timeout(function(){
                        ctrl.showInstructionUpdatedPrompt = false;
                    }, 5000);  
                })
        }
    };
    $scope.editInstruction = function(row) {
        if (ctrl.selectedKittingOrder.kitting_order_status == 'OPEN') {
            ctrl.editInstruction = {};
            ctrl.editInstruction.instructionIdPrimary = row.entity.id;
            ctrl.editInstruction.kittingOrderNumber = row.entity.kitting_order_number;
            ctrl.editInstruction.instructionId = row.entity.instruction_id; 
            ctrl.editInstruction.instruction = row.entity.instruction;
            ctrl.editInstruction.instructionType = row.entity.instruction_type;
            ctrl.editInstruction.inventoryStatus = row.entity.inventory_status;
            ctrl.selectInstructionType(ctrl.editInstruction);
            $scope.isVisibleEditInstructionWindow = true;
            $scope.isVisibleNewInstructionWindow = false;

        }
        else{
            $('#dvEditKOInstructionWarning').appendTo('body').modal('show');
        }


    };

    // delete Instruction

    $scope.deleteInstruction = function(row){
        if (ctrl.selectedKittingOrder.kitting_order_status == 'OPEN') {
            $('#instructionDeleteWarning').appendTo("body").modal('show');
            ctrl.instructionRow = row.entity;
        }
        else{
            $('#dvDeleteKOInstructionWarning').appendTo("body").modal('show');
        }

    };

    // Move Instruction

    $scope.isDisplayMoveUp = function(row){

        if($scope.gridKttingOrderInstructions.data.indexOf(row.entity) > 0 && ctrl.selectedKittingOrder.kitting_order_status == 'OPEN'){
            return true;
        }
        else{
            return false;
        }

    };

    $scope.isDisplayMoveDown = function(row){

        if($scope.gridKttingOrderInstructions.data.indexOf(row.entity) <  ($scope.gridKttingOrderInstructions.data.length - 1) && ctrl.selectedKittingOrder.kitting_order_status == 'OPEN'){
            return true;
        }
        else{
            return false;
        }
    };

    $scope.moveUpInstruction = function(row){
        $http({
            method  : 'POST',
            url     : '/kittingOrder/moveUpKittingOrderInstruction',
            params: {kittingOrderNumber: row.entity.kitting_order_number, kittingOrderInstructionId: row.entity.id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
            .success(function(data) {

                getAllKittingOrderInstruction(ctrl.selectedKittingOrder.kitting_order_number);
            });

    };


    $scope.moveDownInstruction = function(row){


        $http({
            method  : 'POST',
            url     : '/kittingOrder/moveDownKittingOrderInstruction',
            params: {kittingOrderNumber: row.entity.kitting_order_number, kittingOrderInstructionId: row.entity.id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
            .success(function(data) {

                getAllKittingOrderInstruction(ctrl.selectedKittingOrder.kitting_order_number);
            });

    };

    $('#deleteInstructionButton').click(function(){
        $http({
            method  : 'POST',
            url     : '/kittingOrder/deleteKittingOrderInstruction',
            data    :  {instructionId:ctrl.instructionRow.id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
            .success(function(response) {
                ctrl.instructionRow = null;
                $('#instructionDeleteWarning').modal('hide');
                getAllKittingOrderInstruction(ctrl.selectedKittingOrder.kitting_order_number);
                ctrl.showInstructionDeletedPrompt = true;
                $timeout(function(){
                    ctrl.showInstructionDeletedPrompt = false;
                }, 5000);

            })
    });

    // allocation process

    var allocate = function(kittingOrderData){
        ctrl.kittigOrderNumForAllocation = kittingOrderData.kitting_order_number;
        // if (ctrl.customerData[0].is_customer_hold == true) {
        //     $('#shipmentPlanWarning').appendTo("body").modal('show');
        // }
        // else{
        //     ctrl.shipmentIdForEdit = shipmentData.shipment_id;
        //     ctrl.shippingContact = shipmentData.contactName ? shipmentData.contactName : ctrl.customerData[0].contact_name;
            $('#allocationProcess').appendTo("body").modal('show');
            allocationFailedMessage();
            ctrl.locationIdForAllocation = '';
            // ctrl.locationId = '';
            // $scope.gridInventory.data = data;
        //}
        

    };

    ctrl.allocationFailedMessageDisplay = [];


    var allocationFailedMessageButton = function(kittingOrderNumber,index){
        $http({
            method: 'GET',
            url: '/stagingLaneShipment/getFailedMessageByShipmentForView',
            params : {shipmentId:kittingOrderNumber}
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

    //***********Start Allocation failed message***********

    var allocationFailedMessage = function(){
        $http({
            method: 'GET',
            url: '/stagingLaneShipment/getFailedMessageByShipment',
            params : {shipmentId: ctrl.kittigOrderNumForAllocation}
        })

            .success(function (data) {

                ctrl.allocationFailedMsg = data;

            });

    };


    var allocationFailedMessageViewPopUp = function(kittingOrderNumber){

        $http({
            method: 'GET',
            url: '/stagingLaneShipment/getFailedMessageByShipmentForView',
            params : {shipmentId: kittingOrderNumber}
        })

            .success(function (data) {
                ctrl.allocationFailedMsg = data;
                $('#allocationMessage').appendTo("body").modal('show');
            });


    };
    ctrl.allocationFailedMessageViewPopUp = allocationFailedMessageViewPopUp;

    //*******End Allocation failed message**********

    var saveAllocation = function () {

        if( ctrl.allocationCreateFrom.$valid) {

            $scope.loadingAnimSaveAllocation = true;
            $http({
                method  : 'POST',
                url     : '/picking/prepareKittingAllocation',
                params: {kittingOrderNumber:ctrl.kittigOrderNumForAllocation, destinationLocation: ctrl.locationIdForAllocation},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {

                    if(data['allocationResult'] == true){
                        $('#allocationProcess').appendTo("body").modal('hide');
                        ctrl.allocationSuccessMessage = data['message'];
                        ctrl.showAllocationSuccessMessage = true;
                        $timeout(function(){
                            ctrl.showAllocationSuccessMessage = false;
                        }, 5000);
                    }
                    else {
                        ctrl.allocationErrorMessage = data['message'];
                        ctrl.showAllocationErrorMessage = true;
                        $timeout(function(){
                            ctrl.showAllocationErrorMessage = false;
                            allocationFailedMessage();
                        }, 10000);
                    }


                    $http({
                        method: 'GET',
                        url: '/kittingOrder/getAllKittingOrderWithItemDetailsByCompanyId'
                    })
                    .success(function (data, status, headers, config) {
                        ctrl.kittingOrderList = data;
                        for(var i = 0; i < ctrl.kittingOrderList.length; i += 1) {
                            if(ctrl.kittingOrderList[i].kitting_order_number === ctrl.kittigOrderNumForAllocation) {
                                ctrl.getClickedKittingOrder(i);
                            }
                        }            

                    })


                })
                .finally(function () {
                    $scope.loadingAnimSaveAllocation = false;
                });




        }
    };

    var viewPicks = function(kittingOrderNumber){

        var redirectUrl = "/picking/palletPick"

        $http({
            method : 'GET',
            url : '/picking/getPickListByKittingOrderNumber',
            params: {orderNumber: kittingOrderNumber}
        })
            .success(function (data, status, headers, config) {

                if(data.length > 0){
                    redirectUrl = "/picking/index#?pickListId=" + data[0].pick_list_id;
                    document.location = redirectUrl;
                }
                else {
                    document.location = redirectUrl;
                }

            })
            .error(function (data, status, headers, config) {
                document.location = redirectUrl;
            });


    };

    ctrl.getPopoverTemplateUrl = "notesPopover";

    var processKitting = function(kittingOrderData){
        ctrl.kittingOrderNumForProcessing = kittingOrderData.kitting_order_number;
        ctrl.kittingItemForProcessing = kittingOrderData.kitting_item_id;
        ctrl.kittingQtyForProcessing = kittingOrderData.production_quantity;
        ctrl.kittingUomForProcessing = kittingOrderData.production_uom;

        $http({
            method : 'GET',
            url : '/item/findItem',
            params: {itemId: ctrl.kittingItemForProcessing}
        })
            .success(function (data, status, headers, config) {

                if(data.length > 0){

                    ctrl.itemDataRow = data[0];
                    ctrl.kittingInventoryExpireDateDisabled = !data[0].isExpired;
                    ctrl.kittingInventoryLotCodeDisabled = !data[0].isLotTracked;
                    ctrl.kittingItemDescriptionForView = data[0].itemDescription;
                    ctrl.kittingItemLowestUom = data[0].lowestUom.toUpperCase();
                    ctrl.kittingItemEachesPerCase = data[0].eachesPerCase;


                    if(data[0].isCaseTracked){
                        ctrl.kittingInventoryQty = "1";
                        ctrl.kittingInventoryQtyDisabled = true;
                        ctrl.kittingInventoryCaseId = "";
                        ctrl.kittingInventoryCaseIdDisabled = false;
                    }else{
                        ctrl.kittingInventoryCaseIdDisabled = true;
                        ctrl.kittingInventoryQtyDisabled = false;
                    }
                    if(data[0].lowestUom.toUpperCase() == 'EACH'){

                        ctrl.kittingInventoryQty = "";
                        ctrl.kittingInventoryQtyDisabled = false;

                        $scope.data = {
                            availableOptions: [
                                {id: 'EACH', name: 'EACH'},
                                {id: 'CASE', name: 'CASE'}
                            ]
                        };
                    }else if(data[0].lowestUom.toUpperCase() == 'CASE'){
                        $scope.data = {
                            availableOptions: [
                                {id: 'CASE', name: 'CASE'}
                            ]
                        };
                        ctrl.kittingInventoryUom =  $scope.data.availableOptions[0].id;
                    }
                    else {
                        $scope.data = {
                            availableOptions: [
                                {id: 'PALLET', name: 'PALLET'}
                            ]
                        };
                        ctrl.kittingInventoryUom =  $scope.data.availableOptions[0].id;
                    }

                }

            });

        $('#kittingProcessing').appendTo("body").modal('show');

    };

    ctrl.kittingInvSaveSaveBtnText = 'Start Process';
    var saveKittingInventory = function () {
        if(ctrl.kittingInventoryCaseId == ctrl.kittingInventoryPalletId){
            ctrl.kittingInventory.$valid = false;
        }

        if(ctrl.kittingInventory.$valid) {
            if (ctrl.kittingInventoryCaseId && ctrl.kittingInventoryPalletId) {
                var lpnForValidation = ctrl.kittingInventoryCaseId
                var lpnTypeForValidation = 'CASE';
            }
            else if (ctrl.kittingInventoryCaseId && (!ctrl.kittingInventoryPalletId || ctrl.kittingInventoryPalletId == '')) {
                var lpnForValidation = ctrl.kittingInventoryCaseId
                var lpnTypeForValidation = 'CASE';
            }
            else{
                var lpnForValidation = ctrl.kittingInventoryPalletId
                var lpnTypeForValidation = 'PALLET';
            }

            $http({
                method : 'GET',
                url : '/kittingOrder/getKittingInventoryDataForValidation',
                params: {lpn: lpnForValidation, lpnType:lpnTypeForValidation, kittingOrderNumber:ctrl.kittingOrderNumForProcessing }
            })
            .success(function (data, status, headers, config) {
                if(data.length > 0){
                    ctrl.kittingInventoryIdForInstruction = data[0].id
                    ctrl.showPendingInstructionsPrompt = true;
                    $http({
                        method : 'GET',
                        url : '/kittingOrder/getUnCompletedInstructionForKittingInventory',
                        params: {kittingOrderNumber:ctrl.kittingOrderNumForProcessing, kittingInventoryId: ctrl.kittingInventoryIdForInstruction}
                    })
                    .success(function (data, status, headers, config) {
                        ctrl.instructionIndx = 0;
                        ctrl.kOInstructionsDataList = data;
                        if (ctrl.kOInstructionsDataList.length > 0) {
                           ctrl.showKOInstructionData = true; 
                        }
                        else{
                           ctrl.showKOInstructionData = true; 
                           ctrl.kOInstructionsDataList = $scope.gridKttingOrderInstructions.data;
                        }
                        
                    })

                    $timeout(function(){
                        ctrl.showPendingInstructionsPrompt = false;
                    }, 5000);

                }
                else{
                    ctrl.showKOInstructionData = false;
                    ctrl.kOInstructionsDataList = [];
                    $http({
                        method : 'GET',
                        url : '/kittingOrder/getReceivedKittingInventoryTotalQuantity',
                        params: {kittingOrderNumber:ctrl.kittingOrderNumForProcessing}
                    })
                        .success(function (data, status, headers, config) {

                            var receivedTotalQuantity = parseInt(data.receivedTotalQuantity);

                            if(ctrl.kittingInventoryUom == "CASE" && ctrl.kittingItemLowestUom == "EACH"){
                                receivedTotalQuantity = receivedTotalQuantity + parseInt(ctrl.kittingInventoryQty * ctrl.kittingItemEachesPerCase);
                            }
                            else{
                                receivedTotalQuantity = receivedTotalQuantity + parseInt(ctrl.kittingInventoryQty);
                            }

                            if(receivedTotalQuantity <= ctrl.kittingQtyForProcessing){
                                ctrl.disableKittingInvSaveBtn = true;
                                ctrl.kittingInvSaveSaveBtnText = 'Processing...';

                                $http({
                                    method  : 'POST',
                                    url     : '/kittingOrder/saveKittingInventory',
                                    params: {kittingOrderNumber:ctrl.kittingOrderNumForProcessing,
                                        palletId:ctrl.kittingInventoryPalletId,
                                        caseId: ctrl.kittingInventoryCaseId,
                                        uom:ctrl.kittingInventoryUom,
                                        quantity:ctrl.kittingInventoryQty,
                                        lotCode:ctrl.kittingInventoryLotCode,
                                        expirationDate:ctrl.kittingInventoryExpireDate,
                                        inventoryStatus:ctrl.kittingInventoryStatus,
                                        itemId:ctrl.kittingItemForProcessing,
                                        itemNote:ctrl.kittingInventoryItemNotes},
                                    dataType: 'json',
                                    headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                                })
                                    .success(function(data) {
                                        ctrl.kittingInventoryPalletId = "";
                                        ctrl.kittingInventoryCaseId = "";
                                        ctrl.kittingInventoryItemNotes = ''

                                        ctrl.kittingInventory.$setUntouched();
                                        ctrl.kittingInventory.$setPristine();

                                        ctrl.kittingInventoryNotify = true;
                                        $timeout(function(){
                                            ctrl.kittingInventoryNotify = false;
                                        }, 5000);

                                        $http({
                                            method: 'GET',
                                            url: '/kittingOrder/getAllKittingOrderWithItemDetailsByCompanyId'
                                        })
                                            .success(function (data, status, headers, config) {
                                                ctrl.kittingOrderList = data;
                                                for(var i = 0; i < ctrl.kittingOrderList.length; i += 1) {
                                                    if(ctrl.kittingOrderList[i].kitting_order_number === ctrl.selectedKittingOrder.kitting_order_number) {
                                                        ctrl.getClickedKittingOrder(i);
                                                    }
                                                }

                                            })

                                        ctrl.instructionIndx = 0;
                                        ctrl.kittingInventoryIdForInstruction = data.id;
                                        ctrl.showKOInstructionData = true;
                                        ctrl.showInstructionsCompletedPrompt = false;
                                        ctrl.kOInstructionsDataList = $scope.gridKttingOrderInstructions.data;

                                        if (ctrl.kOInstructionsDataList.length == 0) {
                                            afterInstructionInventorySave(ctrl.selectedKittingOrder.kitting_order_number, ctrl.kittingInventoryIdForInstruction, ctrl.selectedKittingOrder.finished_product_inventory_status);
                                            ctrl.kOInstructionsDataList = []
                                        }

                                    })
                                    .finally(function () {
                                        ctrl.disableKittingInvSaveBtn = false;
                                        ctrl.kittingInvSaveSaveBtnText = 'Start Process';
                                    });                            


                            }
                            else {
                                $('#dvOverReceivedAlert').appendTo("body").modal('show');
                            }
                        });


                }

            })            

        }
    };

    var afterInstructionInventorySave = function(kittingOrderNumber, kittingInventoryId, kOFinishedProductStatus){
        $http({
            method  : 'POST',
            url     : '/kittingOrder/saveKittingInventoryForFinalInstruction',
            params: {kittingOrderNumber:kittingOrderNumber,
                kittingInventoryId: kittingInventoryId,
                kOFinishedProductStatus:kOFinishedProductStatus},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
        .success(function(data) {
                ctrl.instructionIndx = 0;
                ctrl.kittingInventoryIdForInstruction = ''; 
                ctrl.showKOInstructionData = false; 

                $http({
                    method: 'GET',
                    url: '/kittingOrder/getAllKittingOrderWithItemDetailsByCompanyId'
                })
                    .success(function (data, status, headers, config) {
                        ctrl.kittingOrderList = data;
                        for(var i = 0; i < ctrl.kittingOrderList.length; i += 1) {
                            if(ctrl.kittingOrderList[i].kitting_order_number === ctrl.selectedKittingOrder.kitting_order_number) {
                                ctrl.getClickedKittingOrder(i);
                            }
                        }

                    })

        });         
    }

    ctrl.confirmKOInstruction = function(){
        
        $http({
            method  : 'POST',
            url     : '/kittingOrder/saveKittingInventoryInstruction',
            params: {kittingOrderNumber:ctrl.selectedKittingOrder.kitting_order_number,
                kittingOrderInstructionId:ctrl.kOInstructionsDataList[ctrl.instructionIndx].id,
                kittingInventoryId: ctrl.kittingInventoryIdForInstruction,
                kittingInventoryStatus:ctrl.kOInstructionsDataList[ctrl.instructionIndx].inventory_status,
                status:'COMPLETED'},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
        .success(function(data) {
            if (ctrl.kOInstructionsDataList.length > ctrl.instructionIndx+1) {
                ctrl.instructionIndx ++;

                $http({
                    method: 'GET',
                    url: '/kittingOrder/getAllKittingOrderWithItemDetailsByCompanyId'
                })
                    .success(function (data, status, headers, config) {
                        ctrl.kittingOrderList = data;
                        for(var i = 0; i < ctrl.kittingOrderList.length; i += 1) {
                            if(ctrl.kittingOrderList[i].kitting_order_number === ctrl.selectedKittingOrder.kitting_order_number) {
                                ctrl.getClickedKittingOrder(i);
                            }
                        }

                    })


            }
            else{
                ctrl.instructionIndx = 0;
                afterInstructionInventorySave(ctrl.selectedKittingOrder.kitting_order_number, ctrl.kittingInventoryIdForInstruction, ctrl.selectedKittingOrder.finished_product_inventory_status);
                ctrl.showKOInstructionData = false;
                ctrl.showInstructionsCompletedPrompt = true;  
                $timeout(function(){
                    ctrl.showInstructionsCompletedPrompt = false;
                }, 5000);
            }
        });       

    };

    ctrl.skipKOInstruction = function(){
        
        $http({
            method  : 'POST',
            url     : '/kittingOrder/saveKittingInventoryInstruction',
            params: {kittingOrderNumber:ctrl.selectedKittingOrder.kitting_order_number,
                kittingOrderInstructionId:ctrl.kOInstructionsDataList[ctrl.instructionIndx].id,
                kittingInventoryId: ctrl.kittingInventoryIdForInstruction,
                status:'SKIPPED'},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
        .success(function(data) {
            if (ctrl.kOInstructionsDataList.length > ctrl.instructionIndx+1) {
                ctrl.instructionIndx ++;
            }
            else{
                ctrl.instructionIndx = 0;
                afterInstructionInventorySave(ctrl.selectedKittingOrder.kitting_order_number, ctrl.kittingInventoryIdForInstruction, ctrl.selectedKittingOrder.finished_product_inventory_status);
                ctrl.kittingInventoryIdForInstruction = ''; 
                ctrl.showKOInstructionData = false;
                ctrl.showInstructionsCompletedPrompt = true; 
                $timeout(function(){
                    ctrl.showInstructionsCompletedPrompt = false;
                }, 5000); 
            }
            
        });       

    }; 

    ctrl.cancelInstruction = function(){
        clearProcessKittingModal();
        $('#kittingProcessing').modal('hide');

    }; 

    var clearProcessKittingModal = function(){
        ctrl.instructionIndx = 0;
        ctrl.kittingInventoryIdForInstruction = ''; 
        ctrl.showKOInstructionData = false;
        ctrl.showInstructionsCompletedPrompt = false;
        ctrl.kittingOrderNumForProcessing = ''; 
        ctrl.kittingInventoryPalletId = ''; 
        ctrl.kittingInventoryCaseId = ''; 
        ctrl.kittingInventoryUom = ''; 
        ctrl.kittingInventoryQty = ''; 
        ctrl.kittingInventoryLotCode = ''; 
        ctrl.kittingInventoryExpireDate = ''; 
        ctrl.kittingInventoryStatus = ''; 
        ctrl.kittingItemForProcessing = '';
        ctrl.kittingItemLowestUom = null;
        ctrl.kittingItemEachesPerCase = null;
        ctrl.kittingInventoryItemNotes = ''; 
        ctrl.kOInstructionsDataList = [];
    };


    ctrl.saveAllocation = saveAllocation;
    ctrl.allocate = allocate;
    ctrl.viewPicks = viewPicks;
    ctrl.processKitting = processKitting;    
    ctrl.saveKittingInventory = saveKittingInventory;
    ctrl.clearProcessKittingModal = clearProcessKittingModal;

    $scope.gridKttingOrderInventory = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        columnDefs: [
            {name:'Pallet' , field: 'pallet_id'},
            {name:'Case' , field: 'case_id'},
            {name:'Qty' , field: 'quantity'},
            {name:'UOM' , field: 'uom'},
            {name:'Lot Code' , field: 'lot_code'},
            {name:'Expiration Date' , field: 'expiration_date', type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Inventory Status' , field: 'kittingInventoryStatusDesc'},
            {name:'Notes', cellTemplate: '<span><a href="javascript:void(0)" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;" popover-trigger="outsideClick" ng-show="row.entity.inventoryNotes" uib-popover="{{row.entity.inventoryNotes}}" popover-title="Notes :" popover-append-to-body="true" >Notes</a></span>'},
            {name:'Actions',  cellTemplate: '<span ng-if ="!row.entity.location_id && row.entity.is_all_instruction_completed == true && grid.appScope.getKOType() == \'REGULAR\'"><button  class="btn btn-xs btn-primary" style="padding: 2px 2px !important; margin: 2px 10px 0px 10px;" ng-click="grid.appScope.putawayPopUp(row)">Putaway</button></span><span ng-if ="!row.entity.location_id  && row.entity.is_all_instruction_completed == true && grid.appScope.getKOType() == \'TRIGGERED\'"><button  class="btn btn-xs btn-primary" style="padding: 2px 2px !important; margin: 2px 10px 0px 10px;" ng-click="grid.appScope.stagePopUp(row)">Stage</button></span><span ng-if="row.entity.is_all_instruction_completed != true" style="color: green; line-height:3; font-size: 12px;">&nbsp;</span><span ng-if="row.entity.location_id && grid.appScope.getKOType() == \'REGULAR\'" style="color: green; line-height:3; font-size: 11px;">Putaway Completed</span><span ng-if="row.entity.location_id && grid.appScope.getKOType() == \'TRIGGERED\'" style="color: green; line-height:3; font-size: 11px;">Staged</span>', width:100}

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

    $scope.getKOType = function(){
        return ctrl.selectedKittingOrder.kitting_order_type
    };

    $scope.putawayPopUp = function(row){

        ctrl.putawayUserLocation = "";
        ctrl.kittingInventoryId = row.entity.id;

        if(row.entity.pallet_id){
            ctrl.putawayLpnLevel = "Pallet";
            ctrl.putawayInventoryLpnId = row.entity.pallet_id;
            if (row.entity.case_id) {
               ctrl.putawayInventoryCaseId = row.entity.case_id;
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
            params: {itemId: ctrl.selectedKittingOrder.kitting_item_id,
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
        $('#putawayModal').appendTo('body').modal('show');
        ctrl.disablePutawayUserDefined = false;

    };

    ctrl.saveKittingPutaway = function () {

        if( ctrl.putawayInventory.$valid && ctrl.putawaySystemLocation) {

            ctrl.disableKittingPutaway = true;

            $http({
                method  : 'POST',
                url     : '/kittingOrder/saveKittingPutaway',
                params: {lpn: ctrl.putawayInventoryLpnId,
                    caseId:ctrl.putawayInventoryCaseId,
                    locationId: ctrl.confirmLocationId,
                    kittingInventoryId: ctrl.kittingInventoryId},

                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(data) {
                    $http({
                        method: 'GET',
                        url: '/kittingOrder/getAllKittingOrderWithItemDetailsByCompanyId'
                    })
                    .success(function (data, status, headers, config) {
                        ctrl.disableKittingPutaway = true;
                        ctrl.kittingOrderList = data;
                        for(var i = 0; i < ctrl.kittingOrderList.length; i += 1) {
                            if(ctrl.kittingOrderList[i].kitting_order_number === ctrl.selectedKittingOrder.kitting_order_number) {
                                ctrl.getClickedKittingOrder(i);
                            }
                        }
                        $('#putawayModal').modal('hide');

                    })
                    .finally(function(){
                        ctrl.disableKittingPutaway = false;
                    })                  

                })

        }
    };

    ctrl.saveKittingPutawayUserDefined = function () {
        
        if( ctrl.putawayInventoryUserDefined.$valid) {

            // if (ctrl.overrideLocationIdData.length > 0 && ctrl.overrideLocationIdData[0].is_bin && ctrl.itemDataRow.lowestUom.toUpperCase() == 'CASE') {
            //     ctrl.lowestUomCaseForBin = true;
            // }

            //else{

                ctrl.disablePutawayUserDefined = true;

                $http({
                    method  : 'POST',
                    url     : '/kittingOrder/saveKittingPutaway',
                    params: {lpn: ctrl.putawayInventoryLpnId,
                    caseId:ctrl.putawayInventoryCaseId,
                    locationId: ctrl.putawayUserLocation,
                    kittingInventoryId: ctrl.kittingInventoryId},

                    dataType: 'json',
                    headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                })
                    .success(function(data) {
                        $http({
                            method: 'GET',
                            url: '/kittingOrder/getAllKittingOrderWithItemDetailsByCompanyId'
                        })
                        .success(function (data, status, headers, config) {
                            ctrl.kittingOrderList = data;
                            for(var i = 0; i < ctrl.kittingOrderList.length; i += 1) {
                                if(ctrl.kittingOrderList[i].kitting_order_number === ctrl.selectedKittingOrder.kitting_order_number) {
                                    ctrl.getClickedKittingOrder(i);
                                }
                            }
                            $('#putawayModal').modal('hide');
                            ctrl.disablePutawayUserDefined = false;

                        })                          

                    })
                    .finally(function(){
                        ctrl.disablePutawayUserDefined = true;
                    })

            //}
        }
    };    


    ctrl.sendKittedItemToStage = function(){
        if( ctrl.kittingToStageForm.$valid) {

            ctrl.kittingDestinationLocErrorMsg = null;
            if (ctrl.kittingStageLocDisplay === ctrl.confirmKittingLocation) {
                ctrl.disableMoveToStageBtn = true;

                $http({
                    method  : 'POST',
                    url     : '/kittingOrder/saveKittingStage',
                    params: {lpn: ctrl.putawayInventoryLpnId,
                        caseId:ctrl.putawayInventoryCaseId,
                        kittingInventoryId: ctrl.kittingInventoryId},

                    dataType: 'json',
                    headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                })
                .success(function(data) {

                    $http({
                        method: 'GET',
                        url: '/kittingOrder/getAllKittingOrderWithItemDetailsByCompanyId'
                    })
                        .success(function (data, status, headers, config) {
                            ctrl.kittingOrderList = data;
                            for(var i = 0; i < ctrl.kittingOrderList.length; i += 1) {
                                if(ctrl.kittingOrderList[i].kitting_order_number === ctrl.selectedKittingOrder.kitting_order_number) {
                                    ctrl.getClickedKittingOrder(i);
                                }
                            }
                            $('#stageModal').modal('hide');
                            ctrl.disableMoveToStageBtn = false;

                        })

                })
                .finally(function(){
                    ctrl.disableMoveToStageBtn = true;
                });                
            }
            else{
                $http({
                        method: 'GET',
                        url: '/kittingOrder/validateKittingDestinationLocation',
                        params: {destinationLocation:ctrl.kittingStageLocDisplay, locationToConfirm:ctrl.confirmKittingLocation},
                    })
                .success(function (data, status, headers, config) {
                    if (data.length > 0) {

                        ctrl.disableMoveToStageBtn = true;

                        $http({
                            method  : 'POST',
                            url     : '/kittingOrder/saveKittingStage',
                            params: {lpn: ctrl.putawayInventoryLpnId,
                                caseId:ctrl.putawayInventoryCaseId,
                                kittingInventoryId: ctrl.kittingInventoryId},

                            dataType: 'json',
                            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                        })
                        .success(function(data) {

                            $http({
                                method: 'GET',
                                url: '/kittingOrder/getAllKittingOrderWithItemDetailsByCompanyId'
                            })
                                .success(function (data, status, headers, config) {
                                    ctrl.kittingOrderList = data;
                                    for(var i = 0; i < ctrl.kittingOrderList.length; i += 1) {
                                        if(ctrl.kittingOrderList[i].kitting_order_number === ctrl.selectedKittingOrder.kitting_order_number) {
                                            ctrl.getClickedKittingOrder(i);
                                        }
                                    }
                                    $('#stageModal').modal('hide');
                                    ctrl.disableMoveToStageBtn = false;

                                })

                        })
                        .finally(function(){
                            ctrl.disableMoveToStageBtn = true;
                        }); 

                    }
                    else{
                        ctrl.kittingDestinationLocErrorMsg = 'Staging Location is not valid';
                    }

                });                
            }

        }        
    }

    ctrl.showMessagesForPutaway = function (field) {
        return ctrl.putawayInventoryUserDefined[field].$touched || ctrl.putawayInventoryUserDefined.$submitted;
    };

    ctrl.hasErrorClassForPutaway = function (field) {
        return ctrl.putawayInventoryUserDefined[field].$touched && ctrl.putawayInventoryUserDefined[field].$invalid;
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


    $scope.gridKttingComponentInventory = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        columnDefs: [
            {name:'Pallet Id', field: 'pallet_id'},
            {name:'Case Id', field: 'case_id'},
            {name:'Item Id', field: 'item_id'},
            {name:'Description', field: 'item_description'},
            {name:'Inventory Status', field: 'inventory_status'},
            {name:'Quantity', field: 'quantity', type: 'number', },
            {name:'Unit Of Measure', field: 'handling_uom', cellClass:'qtyNumberGrid'}

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

    ctrl.checkLocationIdExist = function(viewValue){
        if (viewValue) {
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

        }

    };


    $scope.stagePopUp = function(row){

        ctrl.kittingInventoryId = row.entity.id;

        $http({
            method: 'GET',
            url: '/kittingOrder/getKittingStageData',
            params:{kittingInventoryId:ctrl.kittingInventoryId}
        })
        .success(function (data, status, headers, config) {
            ctrl.kittingStageLocDisplay = data.stagingLocationId;
        })        

        if(row.entity.pallet_id){
            ctrl.putawayLpnLevel = "Pallet";
            ctrl.putawayInventoryLpnId = row.entity.pallet_id;
            if (row.entity.case_id) {
                ctrl.putawayInventoryCaseId = row.entity.case_id;
            }

        }else{
            ctrl.putawayLpnLevel = "Case";
            ctrl.putawayInventoryLpnId = row.entity.case_id;
            ctrl.putawayInventoryCaseId = row.entity.case_id;
        }
        ctrl.putawayReceiveInventoryId = row.entity.receive_inventory_id

        ctrl.disableMoveToStageBtn = false;

        ctrl.kittingDestinationLocErrorMsg = null;
        ctrl.confirmKittingLocation = null;
        ctrl.kittingToStageForm.$setUntouched();
        ctrl.kittingToStageForm.$setPristine();


        $('#stageModal').appendTo('body').modal('show');
        
    }

    var getAllKittingOrderInventory = function (kittingOrdNum) {
        $http({
            method: 'GET',
            url: '/kittingOrder/getAllKittingOrderInventoryDataByKittingOrderNumber',
            params:{kittingOrdNum:kittingOrdNum}
        })
        .success(function (data, status, headers, config) {
            $scope.gridKttingOrderInventory.data = data;
        })
    };       

    var getAllKittingComponentInventory = function (kittingOrderNumber) {

        $http({
            method: 'GET',
            url: '/kittingOrder/getKittingOrderComponentInventory',
            params:{kittingOrderNumber:kittingOrderNumber}
        })
        .success(function (data, status, headers, config) {
            $scope.gridKttingComponentInventory.data = data;
        })
    };         


    var showMessagesForKitting = function (field) {
        return ctrl.kittingInventory[field].$touched || ctrl.kittingInventory.$submitted;
    };

    var hasErrorClassForKitting = function (field) {
        return ctrl.kittingInventory[field].$touched && ctrl.kittingInventory[field].$invalid;
    };


    ctrl.showMessagesForKitting = showMessagesForKitting;
    ctrl.hasErrorClassForKitting = hasErrorClassForKitting;


    $scope.loadLocationAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/kittingOrder/getKittingLocationsByArea',
            params : {keyword: value.keyword}
        });
    }

    ctrl.callback = function(value){
        ctrl.locationIdForAllocation = value;
    };



    ctrl.validateKittingOrderNum = function(viewValue){
        $http({
            method : 'GET',
            url : '/kittingOrder/getSelectedKittingOrderByKittingOrderNumber',
            params: {kittingOrderNumber: viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    ctrl.createKittingOrderForm.kittingOrderNumber.$setValidity('kittingOrderNumberExists', true);
                }
                else
                {
                    ctrl.createKittingOrderForm.kittingOrderNumber.$setValidity('kittingOrderNumberExists', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.createOrderForm.orderNumber.$setValidity('areaIdExists', false);
            });
    };

    ctrl.uniquePalletIdValidation = function(viewValue){
        if (viewValue) {

            $http({
                method : 'GET',
                url : '/kittingOrder/getKittingInventoryDataForValidation',
                params: {lpn: viewValue, lpnType:'PALLET', kittingOrderNumber:ctrl.kittingOrderNumForProcessing }
            })
            .success(function (data, status, headers, config) {
                if(data.length > 0){
                    ctrl.kittingInventoryIdForInstruction = data[0].id
                    ctrl.showPendingInstructionsPrompt = true;
                    $http({
                        method : 'GET',
                        url : '/kittingOrder/getUnCompletedInstructionForKittingInventory',
                        params: {kittingOrderNumber:ctrl.kittingOrderNumForProcessing, kittingInventoryId: ctrl.kittingInventoryIdForInstruction}
                    })
                    .success(function (data, status, headers, config) {
                        ctrl.instructionIndx = 0;
                        ctrl.kOInstructionsDataList = data;
                        if (ctrl.kOInstructionsDataList.length > 0) {
                           ctrl.showKOInstructionData = true; 
                        }
                        else{
                           ctrl.showKOInstructionData = true; 
                           ctrl.kOInstructionsDataList = $scope.gridKttingOrderInstructions.data;
                        }
                        
                    })

                    $timeout(function(){
                        ctrl.showPendingInstructionsPrompt = false;
                    }, 5000);

                }
                else{
                    ctrl.showKOInstructionData = false;
                    ctrl.kOInstructionsDataList = [];
                    $http({
                        method : 'GET',
                        url : '/kittingOrder/validatePalletIdForKitting',
                        params: {palletId: viewValue, kittingOrderNumber:ctrl.kittingOrderNumForProcessing}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.allowToReceive){
                                ctrl.kittingInventory.kittingInventoryPalletId.$setValidity('palletIdExists', true);
                            }
                            else
                            {
                                ctrl.kittingInventory.kittingInventoryPalletId.$setValidity('palletIdExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.kittingInventory.kittingInventoryPalletId.$setValidity('palletIdExists', false);
                        });
                }
                

            })
        }
    };
    ctrl.uniqueCaseIdValidation = function(viewValue){
        if (viewValue) {
            $http({
                method : 'GET',
                url : '/kittingOrder/getKittingInventoryDataForValidation',
                params: {lpn: viewValue, lpnType:'CASE', kittingOrderNumber:ctrl.kittingOrderNumForProcessing }
            })
            .success(function (data, status, headers, config) {
                if(data.length > 0){
                    ctrl.kittingInventoryIdForInstruction = data[0].id
                    ctrl.showPendingInstructionsPrompt = true;
                    $http({
                        method : 'GET',
                        url : '/kittingOrder/getUnCompletedInstructionForKittingInventory',
                        params: {kittingOrderNumber:ctrl.kittingOrderNumForProcessing, kittingInventoryId: ctrl.kittingInventoryIdForInstruction}
                    })
                    .success(function (data, status, headers, config) {
                        ctrl.instructionIndx = 0;
                        ctrl.kOInstructionsDataList = data;
                        if (ctrl.kOInstructionsDataList.length > 0) {
                           ctrl.showKOInstructionData = true; 
                        }
                        else{
                           ctrl.showKOInstructionData = true;
                           ctrl.kOInstructionsDataList = $scope.gridKttingOrderInstructions.data; 
                        }
                        
                    })

                    $timeout(function(){
                        ctrl.showPendingInstructionsPrompt = false;
                    }, 5000);
                }
                else{
                    ctrl.showKOInstructionData = false;
                    ctrl.kOInstructionsDataList = [];
                    $http({
                        method : 'GET',
                        url : '/kittingOrder/validateCaseIdForKitting',
                        params: {caseId: viewValue, kittingOrderNumber:ctrl.kittingOrderNumForProcessing}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.allowToReceive){
                                ctrl.kittingInventory.kittingInventoryCaseId.$setValidity('caseIdExists', true);
                            }
                            else
                            {
                                ctrl.kittingInventory.kittingInventoryCaseId.$setValidity('caseIdExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.kittingInventory.kittingInventoryCaseId.$setValidity('caseIdExists', false);
                        });                    
                }
            })            
        }

    };


    ctrl.barcodeScanInput = function(event){
        if (event.keyCode === 13) {
            event.preventDefault();
        }

    };

}])

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
