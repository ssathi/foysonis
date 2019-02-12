/**
 * Created by home on 9/10/15.
 */

var app = angular.module('adminBillOfMaterial', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.bootstrap', 'ui.grid.pagination', 'ui.grid.resizeColumns', 'inventory-autocomplete']);

app.controller('BillOfMaterialCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', function ($scope, $http, $interval, $q, $timeout) {


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
        newBOM = {itemId:'', finishedProductDefaultStatus:'', defaultProductionQuantity: null,productionUom:''};

    // START BOM Search

    var showHideSearch = function () {
        ctrl.isBOMSearchVisible = ctrl.isBOMSearchVisible ? false : true;
    };

    ctrl.showHideSearch = showHideSearch;

    var getDefaultSelectedBOM = function (){
        if(ctrl.bOMList.length > 0){
            ctrl.selectedBOM = ctrl.bOMList[0];
            ctrl.selectedItemId = ctrl.selectedBOM.itemId;
            getAllBOMComponents(ctrl.selectedBOM.bomId);
            getAllBOMInstruction(ctrl.selectedBOM.bomId);
        }
        ctrl.isShowBOMDetails = true;
    }

    //Get all BOM list
    var getAllBOMs = function () {
        $http({
            method: 'GET',
            url: '/billMaterial/getAllBOMWithItemDetailsByCompanyId'
        })
            .success(function (data, status, headers, config) {
                ctrl.bOMList = data;
                getDefaultSelectedBOM();

            })
    };
    getAllBOMs();

    ctrl.searchBOM = {};

    var bOMSearch = function () {
        $http({
            method: 'GET',
            url: '/billMaterial/searchBillOfMaterialByCompanyIdAndItemId',
            params: {itemId: ctrl.searchBOM.itemId}
        })
            .success(function (data) {

                ctrl.bOMList = data;
                getDefaultSelectedBOM();


            })

    };
    ctrl.bOMSearch = bOMSearch;

    // END BOM Search

    // START Create BOM
    ctrl.newBOM = newBOM;
    ctrl.newComponent = {};
    ctrl.newInstruction = {};
    var clearCreateForm = function (){
        ctrl.newBOM.itemId = "";
        ctrl.newBOM.defaultProductionQuantity = "";
        ctrl.newBOM.productionUom = "";
        ctrl.createBOMForm.$setUntouched();
        ctrl.createBOMForm.$setPristine();
        ctrl.disableProductionUom = false;
    }

    var showCreateBOMForm = function () {
        //document.getElementById('components').className = "tab-pane fade";
        document.getElementById('components').className = "tab-pane fade in active";
        //document.getElementById('liComponents').className = "";
        //document.getElementById('liBOM').className = "active";
        $scope.IsVisibleNewBOMWindow = true;
        ctrl.isShowBOMDetails = false;

        if (ctrl.inventoryStatusOptions[0]) {
            ctrl.newBOM.finishedProductDefaultStatus = ctrl.inventoryStatusOptions[0].optionValue;
        }
    };

    var showComponentsCreateForm = function () {
        ctrl.newComponent.bomId = ctrl.selectedBOM.bomId
        $scope.isVisibleNewComponentWindow = true;
        $scope.isVisibleEditComponentWindow = false;
        ctrl.isShowBOMDetails = false;

        if (ctrl.inventoryStatusOptions[0]) {
            ctrl.newComponent.componentInventoryStatus = ctrl.inventoryStatusOptions[0].optionValue;
        }
    };

    ctrl.showCreateBOMForm = showCreateBOMForm;
    ctrl.showComponentsCreateForm = showComponentsCreateForm;

    var cancelCreateBOM = function () {
        $scope.IsVisibleNewBOMWindow = false;
        ctrl.isShowBOMDetails = true;
        clearCreateForm();
    };
    ctrl.cancelCreateBOM = cancelCreateBOM;

    var showBOMMessages = function (field) {
        return ctrl.createBOMForm[field].$touched || ctrl.createBOMForm.$submitted
    };
    var hasBOMErrorClass = function (field) {
        return ctrl.createBOMForm[field].$touched && ctrl.createBOMForm[field].$invalid;
    };
    ctrl.showBOMMessages = showBOMMessages;
    ctrl.hasBOMErrorClass = hasBOMErrorClass;

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
                        ctrl.newBOM.productionUom ='EACH';
                    }
                    else{
                        ctrl.disableProductionUom = true;
                        $scope.data = {
                            availableOptions: [
                                {id: 'CASE', name: 'CASE'}
                            ]
                        };
                        ctrl.newBOM.productionUom ='CASE';
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
                        ctrl.selectedBOM.productionUom ='EACH';
                    }
                    else{
                        ctrl.disableProductionUom = true;
                        $scope.data = {
                            availableOptions: [
                                {id: 'CASE', name: 'CASE'}
                            ]
                        };
                        ctrl.selectedBOM.productionUom ='CASE';
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

    var createBOM = function () {


        if( ctrl.createBOMForm.$valid) {

            $http({
                method: 'GET',
                url: '/billMaterial/getBillOfMaterialByCompanyIdAndItemId',
                params: {itemId: ctrl.newBOM.itemId}
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

                    $http({
                        method  : 'POST',
                        url     : '/billMaterial/saveBillOfMaterial',
                        data    :  ctrl.newBOM,
                        dataType: 'json',
                        headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                    })
                        .success(function(response) {

                            $scope.IsVisibleNewBOMWindow = false;
                            ctrl.showBOMDuplicatedItemIdPrompt = false;
                            ctrl.isShowBOMDetails = true;

                            ctrl.showBOMSubmittedPrompt = true;
                            $timeout(function(){
                                ctrl.showBOMSubmittedPrompt = false;
                            }, 5000);

                            getAllBOMs();
                            clearCreateForm();

                        })
                })
        }
    };  
    ctrl.createBOM = createBOM;


    // END Create BOM

    var getClickedBOM = function(clickedIndex){
        ctrl.selectedBOM = ctrl.bOMList[clickedIndex];
        ctrl.selectedItemId = ctrl.selectedBOM.itemId;

        ctrl.isShowEditBOMForm = false;
        ctrl.isShowBOMDetails = true;
        $scope.IsVisibleNewBOMWindow = false;
        getAllBOMComponents(ctrl.selectedBOM.bomId);
        getAllBOMInstruction(ctrl.selectedBOM.bomId);
    };
    ctrl.getClickedBOM = getClickedBOM;

    //START BOM Edit
    var showEditBOMForm = function () {
        getAllListValueInventoryStatus();
        validateItemIdEdit(ctrl.selectedItemId);
        ctrl.isShowBOMDetails = false;
        ctrl.showBOMSubmittedPrompt = false;
        ctrl.showBOMDuplicatedItemIdPrompt = false;
        ctrl.showBOMDuplicatedEditItemIdPrompt = false;
        ctrl.showBOMUpdatedPrompt = false;
        ctrl.showBOMDeletedPrompt = false;
        $scope.IsVisibleNewBOMWindow = false;
        ctrl.isShowEditBOMForm = true;
        location.href = "#";
        location.href = "#editBOMFormPanel";
        

    }
    ctrl.showEditBOMForm = showEditBOMForm;

    var cancelEditBOM = function () {
        ctrl.isShowEditBOMForm = false;
        ctrl.isShowBOMDetails = true;
        clearCreateForm();
    };
    ctrl.cancelEditBOM = cancelEditBOM;



    var updateBOM = function () {

        if( ctrl.editBOMForm.$valid) {


            if(ctrl.selectedItemId != ctrl.selectedBOM.itemId){
                $http({
                    method: 'GET',
                    url: '/billMaterial/getBillOfMaterialByCompanyIdAndItemId',
                    params: {itemId: ctrl.selectedBOM.itemId}
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
                            url     : '/billMaterial/updateBillOfMaterial',
                            data    :  ctrl.selectedBOM,
                            dataType: 'json',
                            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                        })
                            .success(function(data) {

                                ctrl.isShowEditBOMForm = false;
                                ctrl.isShowBOMDetails = true;
                                ctrl.showBOMDuplicatedEditItemIdPrompt = false;

                                ctrl.showBOMUpdatedPrompt = true;
                                $timeout(function(){
                                    ctrl.showBOMUpdatedPrompt = false;
                                }, 5000);

                                getAllBOMs();
                                clearCreateForm();

                            })

                    })
            }
            else{
                $http({
                    method  : 'POST',
                    url     : '/billMaterial/updateBillOfMaterial',
                    data    :  ctrl.selectedBOM,
                    dataType: 'json',
                    headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                })
                    .success(function(data) {

                        ctrl.isShowEditBOMForm = false;
                        ctrl.isShowBOMDetails = true;
                        ctrl.showBOMDuplicatedEditItemIdPrompt = false;

                        ctrl.showBOMUpdatedPrompt = true;
                        $timeout(function(){
                            ctrl.showBOMUpdatedPrompt = false;
                        }, 5000);

                        getAllBOMs();
                        clearCreateForm();

                    })

            }

        }
    };
    ctrl.updateBOM = updateBOM;

    //END BOM Edit

    // BOM delete

    ctrl.deleteBOM = function(){
        $('#dvDeleteBOMWarning').appendTo('body').modal('show');
    };

    $('#bomDeleteButton').click(function(){
        $http({
            method  : 'POST',
            url     : '/billMaterial/deleteBillOfMaterial',
            data    :  {itemId:ctrl.selectedBOM.itemId, bomId:ctrl.selectedBOM.bomId},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
            .success(function(response) {
                $('#dvDeleteBOMWarning').modal('hide');
                getAllBOMs();
                clearCreateForm();
                ctrl.showBOMDeletedPrompt = true;
                $timeout(function(){
                    ctrl.showBOMDeletedPrompt = false;
                }, 5000);

            })
    });    

    // component create

    var createComponent = function () {

        if( ctrl.createComponentForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/billMaterial/saveBOMComponent',
                data    :  ctrl.newComponent,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(response) {
                    $scope.isVisibleNewComponentWindow = false;
                    ctrl.isShowBOMDetails = true;
                    clearNewComponentForm();
                    getAllBOMComponents(ctrl.selectedBOM.bomId);
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
    var getAllBOMComponents = function (bomId) {
        $http({
            method: 'GET',
            url: '/billMaterial/getAllBOMComponentDataByCompanyIdAndBomId',
            params:{bomId:bomId}
        })
        .success(function (data, status, headers, config) {
            $scope.gridBOMComponents.data = data;
        })
    };

    $scope.gridBOMComponents = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        columnDefs: [
            {name:'Item Id', field: 'component_item_id'},
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
        ctrl.isShowBOMDetails = true;
    };

    ctrl.closeEditComponent = function(){
        ctrl.editComponent.componentItemId = ''; 
        ctrl.editComponent.componentQuantity = '';
        ctrl.editComponent.componentInventoryStatus = '';
        ctrl.editComponent.componentUom = '';
        $scope.isVisibleEditComponentWindow = false;
        ctrl.isShowBOMDetails = true;
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
                    else{
                        ctrl.disableProductionUom = true;
                        $scope.data = {
                            availableOptions: [
                                {id: 'CASE', name: 'CASE'}
                            ]
                        };
                        ctrl.newComponent.componentUom ='CASE';
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
                    else{
                        ctrl.disableProductionUom = true;
                        $scope.data = {
                            availableOptions: [
                                {id: 'CASE', name: 'CASE'}
                            ]
                        };
                        ctrl.editComponent.componentUom ='CASE';
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
        ctrl.editComponent = {};
        validateItemIdComponentEdit(row.entity.component_item_id);
        ctrl.editComponent.componentId = row.entity.id;
        ctrl.editComponent.bomId = row.entity.bom_id;
        ctrl.editComponent.componentItemId = row.entity.component_item_id; 
        ctrl.editComponent.componentQuantity = row.entity.component_quantity;
        ctrl.editComponent.componentInventoryStatus = row.entity.component_inventory_status;
        ctrl.editComponent.componentUom = row.entity.component_uom;
        ctrl.isShowBOMDetails = false;
        $scope.isVisibleEditComponentWindow = true;
        $scope.isVisibleNewComponentWindow = false;

    };

    //update component

    ctrl.updateComponent = function(){
        if( ctrl.upddateComponentForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/billMaterial/updateBOMComponent',
                data    :  ctrl.editComponent,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(response) {
                    ctrl.closeEditComponent();
                    getAllBOMComponents(ctrl.selectedBOM.bomId);
                    ctrl.showComponentUpdatedPrompt = true;
                    $timeout(function(){
                        ctrl.showComponentUpdatedPrompt = false;
                    }, 5000);

                })
        }
    };

    // delete component

    $scope.deleteComponent = function(row){
         $('#componentDeleteWarning').appendTo("body").modal('show');
         ctrl.componentRow = row.entity;
    };

    $('#deleteComponentButton').click(function(){
        $http({
            method  : 'POST',
            url     : '/billMaterial/deleteBOMComponent',
            data    :  {componentId:ctrl.componentRow.id,componentItemId:ctrl.componentRow.component_item_id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
            .success(function(response) {
                $('#componentDeleteWarning').modal('hide');
                getAllBOMComponents(ctrl.selectedBOM.bomId);
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
        ctrl.newInstruction.bomId = ctrl.selectedBOM.bomId
        $scope.isVisibleNewInstructionWindow = true;
        $scope.isVisibleEditInstructionWindow = false;
        ctrl.newInstruction.instructionType = "Mandatory";
    };    

    var createInstruction = function () {

        if( ctrl.createInstructionForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/billMaterial/saveBOMInstruction',
                data    :  ctrl.newInstruction,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(response) {
                    ctrl.closeNewInstruction();
                    getAllBOMInstruction(ctrl.selectedBOM.bomId);
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

    $scope.gridBOMInstructions = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        columnDefs: [
            {name:'Instruction Id' , field: 'instruction_id', width:200 },
            {name:'Instruction Type' , field: 'instruction_type', width:200 },
            {name:'Inventory Status' , field: 'inventoryStatusDesc', width:200},
            {name:'Instruction', cellTemplate: '<span><a href="javascript:void(0)" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;" popover-trigger="outsideClick" ng-show="row.entity.instruction" uib-popover="{{row.entity.instruction}}" popover-title="" popover-append-to-body="true" >View</a></span>', width:100},
            {name: 'Actions', enableSorting: false, enableFiltering: false,  cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px; float: left; width: 70px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.editInstruction(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.deleteInstruction(row)">Delete</a></li></ul></div><div style="float: left; width: 70px;">&nbsp;&nbsp;{{row.entity.instruction_id}}</div><div style="float: left; width: 25px;" ><button  class="moveBtnGrid" ng-if="grid.appScope.isDisplayMoveUp(row)"  ng-click="grid.appScope.moveUpInstruction(row)" title="Move Up"><img src="/foysonis2016/app/img/grid_move_up.png" width="22px" alt="Move Up"></button>&nbsp;</div> <div class="btn-group mb-sm" style="float: left; width: 25px;" ><button class="moveBtnGrid" ng-if="grid.appScope.isDisplayMoveDown(row)" ng-click="grid.appScope.moveDownInstruction(row)" title="Move Down"><img src="/foysonis2016/app/img/grid_move_down.png" width="22px"></button>&nbsp;</div>'}

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

    var getAllBOMInstruction = function (bomId) {
        $http({
            method: 'GET',
            url: '/billMaterial/getAllBOMInstructionDataByCompanyIdAndBomId',
            params:{bomId:bomId}
        })
        .success(function (data, status, headers, config) {
            $scope.gridBOMInstructions.data = data;
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
                url     : '/billMaterial/updateBOMInstruction',
                data    :  ctrl.editInstruction,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(response) {
                    ctrl.closeEditInstruction();
                    getAllBOMInstruction(ctrl.selectedBOM.bomId);
                    ctrl.showInstructionUpdatedPrompt = true;
                    $timeout(function(){
                        ctrl.showInstructionUpdatedPrompt = false;
                    }, 5000);  
                })
        }
    };
    $scope.editInstruction = function(row) {
        ctrl.editInstruction = {};
        ctrl.editInstruction.instructionIdPrimary = row.entity.id;
        ctrl.editInstruction.bomId = row.entity.bom_id;
        ctrl.editInstruction.instructionId = row.entity.instruction_id; 
        ctrl.editInstruction.instruction = row.entity.instruction;
        ctrl.editInstruction.instructionType = row.entity.instruction_type;
        ctrl.editInstruction.inventoryStatus = row.entity.inventory_status;
        ctrl.selectInstructionType(ctrl.editInstruction);
        $scope.isVisibleEditInstructionWindow = true;
        $scope.isVisibleNewInstructionWindow = false;

    };    

    // delete Instruction

    $scope.deleteInstruction = function(row){
         $('#instructionDeleteWarning').appendTo("body").modal('show');
         ctrl.instructionRow = row.entity;
    };


    // Move Instruction

    $scope.isDisplayMoveUp = function(row){

        if($scope.gridBOMInstructions.data.indexOf(row.entity) > 0){
            return true;
        }
        else{
            return false;
        }

    };

    $scope.isDisplayMoveDown = function(row){

        if($scope.gridBOMInstructions.data.indexOf(row.entity) <  ($scope.gridBOMInstructions.data.length - 1)){
            return true;
        }
        else{
            return false;
        }
    };

    $scope.moveUpInstruction = function(row){
        $http({
            method  : 'POST',
            url     : '/billMaterial/moveUpBOMInstruction',
            params: {bomId: row.entity.bom_id, bomInstructionId: row.entity.id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
            .success(function(data) {
                getAllBOMInstruction(ctrl.selectedBOM.bomId);
            });

    };


    $scope.moveDownInstruction = function(row){


        $http({
            method  : 'POST',
            url     : '/billMaterial/moveDownBOMInstruction',
            params: {bomId: row.entity.bom_id, bomInstructionId: row.entity.id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
            .success(function(data) {
                getAllBOMInstruction(ctrl.selectedBOM.bomId);
            });

    };


    $('#deleteInstructionButton').click(function(){
        $http({
            method  : 'POST',
            url     : '/billMaterial/deleteBOMInstruction',
            data    :  {instructionId:ctrl.instructionRow.id},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
            .success(function(response) {
                ctrl.instructionRow = null;
                $('#instructionDeleteWarning').modal('hide');
                getAllBOMInstruction(ctrl.selectedBOM.bomId);
                ctrl.showInstructionDeletedPrompt = true;
                $timeout(function(){
                    ctrl.showInstructionDeletedPrompt = false;
                }, 5000);

            })
    });

}]);
