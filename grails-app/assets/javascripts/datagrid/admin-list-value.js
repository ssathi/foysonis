/**
 * Created by home on 9/10/15.
 */

var app = angular.module('adminListValue', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.grid.pagination', 'ui.grid.expandable','dndLists', 'ui.grid.resizeColumns']);

app.controller('listValueCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', function ($scope, $http, $interval, $q, $timeout) {

    var myEl = angular.element( document.querySelector( '#liAdmin' ) );
    myEl.addClass('active');

    var headerTitle = 'Configuration';

    var ctrl = this;

    var getAllStorageAreas = function () {
        $http({
            method: 'GET',
            url: '/settings/getAllStorageAreasByCompany',
        })
        .success(function (data, status, headers, config) {
            $scope.areaList = data;

        })
    };

    var getAllPickableAreas = function () {
        $http({
            method: 'GET',
            url: '/settings/getAllPickableAreasByCompany',
        })
        .success(function (data, status, headers, config) {
            $scope.areaPickableList = data;

        })
    };


    getAllStorageAreas();
    getAllPickableAreas();


    var saveOrder = function () {

            $http({
                method  : 'POST',
                url     : '/settings/savePutawayOrder',
                data    :  $scope.areaList,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    getAllStorageAreas();
                    ctrl.showOrderedPrompt = true
                    $timeout(function(){
                        ctrl.showOrderedPrompt = false;
                    }, 2200);                  
                    ctrl.disableSave = true;
            })
    };

    var resetOrder = function () {
         $('#putawayOrderReset').appendTo("body").modal('show');
    };



     $("#orderResetButton").click(function(){
     
            $http({
                method  : 'POST',
                url     : '/settings/resetPutawayOrder',
                data    :  $scope.areaList,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    getAllStorageAreas();
                    ctrl.showResetPrompt = true
                    $timeout(function(){
                        ctrl.showResetPrompt = false;
                    }, 2200);                    
                    $('#putawayOrderReset').modal('hide');
                    ctrl.disableSave = true;
                    ctrl.disableReset = true;
            })
     });

    ctrl.disableSave = true;
    ctrl.disableReset = false;

    var enableButton = function(){
        ctrl.disableSave = false;
        ctrl.disableReset = false;
    }

    ctrl.saveOrder = saveOrder;
    ctrl.resetOrder = resetOrder;
    ctrl.enableButton = enableButton;



    var saveAllocationOrder = function () {

            $http({
                method  : 'POST',
                url     : '/settings/saveAllocationOrder',
                data    :  $scope.areaPickableList,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    getAllPickableAreas();
                    ctrl.showAllocationOrderedPrompt = true
                    $timeout(function(){
                        ctrl.showAllocationOrderedPrompt = false;
                    }, 2200);                  
                    ctrl.disableAllocationSave = true;
            })
    };

    var resetAllocationOrder = function () {
         $('#allocationOrderReset').appendTo("body").modal('show');
    };



     $("#allocationOrderResetButton").click(function(){
     
            $http({
                method  : 'POST',
                url     : '/settings/resetAllocationOrder',
                data    :  $scope.areaPickableList,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    getAllPickableAreas();
                    ctrl.showAllocationResetPrompt = true
                    $timeout(function(){
                        ctrl.showAllocationResetPrompt = false;
                    }, 2200);                    
                    $('#allocationOrderReset').modal('hide');
                    ctrl.disableAllocationSave = true;
                    ctrl.disableAllocationReset = true;
            })
     });

    ctrl.disableAllocationSave = true;
    ctrl.disableAllocationReset = false;

    var enableAllocationSaveButton = function(){
        ctrl.disableAllocationSave = false;
        ctrl.disableAllocationReset = false;
    }

    ctrl.saveAllocationOrder = saveAllocationOrder;
    ctrl.resetAllocationOrder = resetAllocationOrder;
    ctrl.enableAllocationSaveButton = enableAllocationSaveButton;



    //Get all list valuES
    var getAllListValues = function (selectedGroup) {
        $http({
            method: 'GET',
            url: '/settings/getAllValuesByCompanyIdAndGroup',
            params:{group:selectedGroup}
        })
        .success(function (data, status, headers, config) {
            switch(selectedGroup) {
                case 'RSHSP':
                    $scope.gridRshspValue.data = data;
                    break;
                case 'STRG':
                    $scope.gridStrgValue.data = data;
                    break;
                case 'ITEMCAT':
                    $scope.gridItemcatListValue.data = data;
                    break;
                case 'CARRCODE':
                    $scope.gridCarrCodeValue.data = data;
                    break;
                case 'CPR':
                    $scope.gridCprValue.data = data;
                    break;
                case 'INVSTATUS':
                    $scope.gridInvStatusValue.data = data;
                    break;
                case 'ADJREASON':
                    $scope.gridAdjReasonListValue.data = data;
                    break;
                default:
                    $scope.gridAdjReasonListValue.data = data;
            }
            //ctrl.newListValue.optionGroup = selectedGroup;
            //ctrl.selectedOptionGroup = selectedGroup;

        })
    };


    var getAllOptionGroups = function () {
        // $http({
        //     method: 'GET',
        //     url: '/settings/getAllOptionGroupsByCompanyId',
        // })
        //     .success(function (data, status, headers, config) {
        //          ctrl.listValueData = data;
        //     })
        ctrl.listValueData = [{optionGroup:'ADJREASON'},{optionGroup:'ITEMCAT'},{optionGroup:'RSHSP'},{optionGroup:'STRG'},{optionGroup:'CARRCODE'}, {optionGroup:'INVSTATUS'}, {optionGroup:'CPR'}];
    };

//***********start ListValue create****************************

    $scope.IsVisibleAdjReason = false;
    $scope.IsVisibleItemCat = false;
    $scope.IsVisibleRshsp = false;
    $scope.IsVisibleStrg = false;
    $scope.IsVisibleCarrCode = false;
    $scope.IsVisibleInvStatus = false;
    $scope.IsVisibleCpr = false;

    $scope.ShowHide = function (selectedGroup) {
        clearForm();
        clearFormEdit();
        //getAllListValues(ctrl.selectedOptionGroup);
        ctrl.editItemState = false;
        ctrl.showSubmittedPrompt = false;
        ctrl.showUpdatedPrompt = false;

        switch(selectedGroup) {
            case 'RSHSP':
                $scope.IsVisibleRshsp = $scope.IsVisibleRshsp ? false : true;
                break;
            case 'STRG':
                $scope.IsVisibleStrg = $scope.IsVisibleStrg ? false : true;
                break;
            case 'ITEMCAT':
                $scope.IsVisibleItemCat = $scope.IsVisibleItemCat ? false : true;
                break;
            case 'CARRCODE':
                $scope.IsVisibleCarrCode = $scope.IsVisibleCarrCode ? false : true;
                break;
            case 'CPR':
                $scope.IsVisibleCpr = $scope.IsVisibleCpr ? false : true;
                break;
            case 'INVSTATUS':
                $scope.IsVisibleInvStatus = $scope.IsVisibleInvStatus ? false : true;
                break;
            case 'ADJREASON':
                $scope.IsVisibleAdjReason = $scope.IsVisibleAdjReason ? false : true;
                break;
            default:
                $scope.IsVisibleAdjReason = $scope.IsVisibleAdjReason ? false : true;
        }
        ctrl.newListValue.optionGroup = selectedGroup;
    };

    var ctrl = this,
        newListValue = { optionGroup:'', description:'', displayOrder:'', optionValue:'' };
        getAllListValues('ADJREASON');
        getAllOptionGroups();

    var createListValue = function () {

        if( ctrl.createListValueForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/settings/saveListValue',
                data    :  $scope.ctrl.newListValue,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    getAllListValues(ctrl.newListValue.optionGroup);
                    ctrl.showSubmittedPrompt = true;
                    switch(ctrl.newListValue.optionGroup) {
                        case 'RSHSP':
                            $scope.IsVisibleRshsp = false;
                            break;
                        case 'STRG':
                            $scope.IsVisibleStrg  = false;
                            break;
                        case 'ITEMCAT':
                            $scope.IsVisibleItemCat = false;
                            break;
                        case 'CARRCODE':
                            $scope.IsVisibleCarrCode  = false;
                            break;
                        case 'CPR':
                            $scope.IsVisibleCpr  = false;
                            break;
                        case 'INVSTATUS':
                            $scope.IsVisibleInvStatus  = false;
                            break;
                        case 'ADJREASON':
                            $scope.IsVisibleAdjReason  = false;
                            break;
                        default:
                            $scope.IsVisibleAdjReason  = false;
                    }
    
                    clearForm();
                    $timeout(function(){
                        ctrl.showSubmittedPrompt = false;
                    }, 2200);

                })

        }
    };


    var clearForm = function () {
        ctrl.newListValue = { optionGroup:'', description:'', displayOrder:'', optionValue:'' };
        ctrl.createListValueForm.$setUntouched();
        ctrl.createListValueForm.$setPristine(); 
        ctrl.editListValueState = false;           
    };

    var hasErrorClass = function (field) {
        return ctrl.createListValueForm[field].$touched && ctrl.createListValueForm[field].$invalid;
    };

    var showMessages = function (field) {
        return ctrl.createListValueForm[field].$touched || ctrl.createListValueForm.$submitted;
    };

    ctrl.hasErrorClass = hasErrorClass;
    ctrl.showMessages = showMessages;
    ctrl.newListValue = newListValue;
    ctrl.createListValue = createListValue;
    ctrl.clearForm = clearForm;
    ctrl.getAllListValues = getAllListValues;

//***************end ListValue create*************************************

// function to create new item category

ctrl.addNewValue = function(){ // dispalys the model

    if (ctrl.newListValue.itemCategory == 'newItemCategory') {
        $('#AddNewItemCategory').appendTo("body").modal('show');
    };
        
};


// function to save new item category
 $("#itemCategorySave").click(function(){
 
        if (ctrl.addItemCategory) {
            $http({
                method  : 'POST',
                url     : '/item/addItemCategoryValues',
                data    :  {optionGroup:'ITEMCAT', description:ctrl.addItemCategory},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    getAllListValues();
                    ctrl.newListValue.itemCategory = ctrl.addItemCategory ;
                    ctrl.addItemCategory ="";
                    $('#AddNewItemCategory').modal('hide');
                                        
                })
        };
 });


  $("#itemCategorycancelSave").click(function(){
    ctrl.newListValue.itemCategory = '';
    ctrl.addItemCategory ="";
    ctrl.itemCategoryDescription = "";    
    //$('#AddNewItemCategory').modal('hide');
 });

  //*************start item edit function******************

    // $scope.HideEditForm = function () {
    //     clearFormEdit();
    //     ctrl.editItemState = false;
    //     ctrl.showUpdatedPrompt = false;
    // };

    // var ctrl = this,
    //     editItem = { itemId:'', itemDescription:'', lowestUom:'each', isLotTracked:'',isExpired:'', isCaseTracked:'', originCode:'', eachesPerCase:'', casesPerPallet:'', upcCode:'', eanCode:'', itemCategory:'', storageAttributes:[] };
    //     getAllListValues();


    $scope.Edit = function(row) {
        //Check Current User
        $http.get('/user/getCurrentUser')
            .success(function(data) {

                ctrl.editListValueState = true;
                //$scope.IsVisible = true;
                switch(row.entity.optionGroup) {
                    case 'RSHSP':
                        $scope.IsVisibleRshsp = true;
                        break;
                    case 'STRG':
                        $scope.IsVisibleStrg  = true;
                        break;
                    case 'ITEMCAT':
                        $scope.IsVisibleItemCat = true;
                        break;
                    case 'CARRCODE':
                        $scope.IsVisibleCarrCode  = true;
                        break;
                    case 'CPR':
                        $scope.IsVisibleCpr  = true;
                        break;
                    case 'INVSTATUS':
                        $scope.IsVisibleInvStatus  = true;
                        break;
                    case 'ADJREASON':
                        $scope.IsVisibleAdjReason  = true;
                        break;
                    default:
                        $scope.IsVisibleAdjReason  = true;
                }

                ctrl.newListValue.optionGroup = row.entity.optionGroup;
                ctrl.newListValue.description = row.entity.description;
                ctrl.previousDescriptionValue = row.entity.description;
                ctrl.newListValue.displayOrder = row.entity.displayOrder;  
                ctrl.newListValue.optionValue = row.entity.optionValue;   
                //alert(row.entiy.optionValue); 
                
            });
    };


    var editListValue = function () {

        if( ctrl.createListValueForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/settings/updateListValue',
                data    :  $scope.ctrl.newListValue,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }

            })
            .success(function (data, status, headers, config) {
                getAllListValues(ctrl.newListValue.optionGroup);
                ctrl.editItemState = false;
                switch(ctrl.newListValue.optionGroup) {
                    case 'RSHSP':
                        $scope.IsVisibleRshsp = false;
                        break;
                    case 'STRG':
                        $scope.IsVisibleStrg  = false;
                        break;
                    case 'ITEMCAT':
                        $scope.IsVisibleItemCat = false;
                        break;
                    case 'CARRCODE':
                        $scope.IsVisibleCarrCode  = false;
                        break;
                    case 'CPR':
                        $scope.IsVisibleCpr  = false;
                        break;
                    case 'INVSTATUS':
                        $scope.IsVisibleInvStatus  = false;
                        break;
                    case 'ADJREASON':
                        $scope.IsVisibleAdjReason  = false;
                        break;
                    default:
                        $scope.IsVisibleAdjReason  = false;
                }
                clearFormEdit();
                //ctrl.showUpdatedPrompt = true;


            });

        }
    };    

    //ctrl.editItem = editItem;


    var clearFormEdit = function () {
        ctrl.editItem = { itemId:'', itemDescription:'', lowestUom:'each', isLotTracked:'',isExpired:'', originCode:'', eachesPerCase:'', casesPerPallet:'', upcCode:'', eanCode:'', itemCategory:''};
        ctrl.editItem.storageAttributes = [];
        ctrl.previousDescriptionValue = '';       
        // ctrl.editItemForm.$setUntouched();
        // ctrl.editItemForm.$setPristine();           
    };



    var hasErrorClassEdit = function (field) {
        return ctrl.editItemForm[field].$touched && ctrl.editItemForm[field].$invalid;
    };

    var showMessagesEdit = function (field) {
        return ctrl.editItemForm[field].$touched || ctrl.editItemForm.$submitted;
    };

    var toggleEditItemIdPrompt = function (value) {
        ctrl.showEditItemIdPrompt = value;
    };
    var toggleEditItemDescriptionPrompt = function (value) {
        ctrl.showEditItemDescriptionPrompt = value;
    };
    var toggleEditLowestUomPrompt = function (value) {
        ctrl.showEditLowestUomPrompt = value;
    };
    var toggleEditIsLotTrackedPrompt = function (value) {
        ctrl.showEditIsLotTrackedPrompt = value;
    };
    var toggleEditIsExpiredPrompt = function (value) {
        ctrl.showEditIsExpiredPrompt = value;
    };
    var toggleEditOriginCodePrompt = function (value) {
        ctrl.showEditOriginCodePrompt = value;
    };
    var toggleEditEachesPerCasePrompt = function (value) {
        ctrl.showEditEachesPerCasePrompt = value;
    };
    var toggleEditCasesPerPalletPrompt = function (value) {
        ctrl.showEditCasesPerPalletPrompt = value;
    };
    var toggleEditUpcCodePrompt = function (value) {
        ctrl.showEditUpcCodePrompt = value;
    };
    var toggleEditEanCodePrompt = function (value) {
        ctrl.showEditEanCodePrompt = value;
    };
    var toggleEditItemCategoryPrompt = function (value) {
        ctrl.showEditItemCategoryPrompt = value;
    };


    ctrl.showEditItemIdPrompt = false;
    ctrl.showEditItemDescriptionPrompt = false;
    ctrl.showEditLowestUomPrompt = false;
    ctrl.showEditIsLotTrackedPrompt = false;
    ctrl.showEditIsExpiredPrompt = false;
    ctrl.showEditOriginCodePrompt = false;
    ctrl.showEditEachesPerCasePrompt = false;
    ctrl.showEditCasesPerPalletPrompt = false;
    ctrl.showEditUpcCodePrompt = false;
    ctrl.showEditEanCodePrompt = false;
    ctrl.showEditItemCategoryPrompt = false;

    ctrl.showUpdatedPrompt = false;




    ctrl.toggleEditItemIdPrompt = toggleEditItemIdPrompt;
    ctrl.toggleEditItemDescriptionPrompt = toggleEditItemDescriptionPrompt;
    ctrl.toggleEditLowestUomPrompt = toggleEditLowestUomPrompt;
    ctrl.toggleEditIsLotTrackedPrompt = toggleEditIsLotTrackedPrompt;
    ctrl.toggleEditIsExpiredPrompt = toggleEditIsExpiredPrompt;
    ctrl.toggleEditOriginCodePrompt = toggleEditOriginCodePrompt;
    ctrl.toggleEditEachesPerCasePrompt = toggleEditEachesPerCasePrompt;
    ctrl.toggleEditCasesPerPalletPrompt = toggleEditCasesPerPalletPrompt;
    ctrl.toggleEditUpcCodePrompt = toggleEditUpcCodePrompt;
    ctrl.toggleEditEanCodePrompt = toggleEditEanCodePrompt;
    ctrl.toggleEditItemCategoryPrompt = toggleEditItemCategoryPrompt;


    ctrl.hasErrorClassEdit = hasErrorClassEdit;
    ctrl.showMessagesEdit = showMessagesEdit;
    ctrl.editListValue = editListValue;
    ctrl.clearFormEdit = clearFormEdit;





  
    //**********end item edit****************************

    //**********START ITEM DELETE**************


        ctrl.showDeletedPrompt = false;
        var rows;
        $scope.Delete = function(row) { //calling bootstrap confirm box. 

        //$('#itemDelete').appendTo("body").modal('show');
        //checkInventoryExist(row.entity.item_id);

                $http({
                method: 'GET',
                url: '/settings/findListValueExist',
                params : {optionGroup: row.entity.optionGroup, optionValue: row.entity.optionValue}
            })
            .success(function (data, status, headers, config) {
                ctrl.checkListValueExist = data;    

                if (ctrl.checkListValueExist.length > 0) {
                    $('#listValueDeleteWarning').appendTo("body").modal('show');

                }
                else{
                    $('#listValueDelete').appendTo("body").modal('show');
                    
                }


            })



        rows = row;
       
    };


 


    $("#deleteListValueButton").click(function(){ //finction to delete after validation.

        $http({
            method: 'POST',
            url: '/settings/deleteListValue',
            data: {optionGroup: rows.entity.optionGroup, optionValue: rows.entity.optionValue},
            dataType: 'json',
            headers: {'Content-Type': 'application/json; charset=utf-8'}  // set the headers so angular passing //info as form data (not request payload)
            })
            .success(function (data, status, headers, config) {
                $('#listValueDelete').modal('hide');
                getAllListValues(rows.entity.optionGroup);
                ctrl.showDeletedPrompt = true;
                $timeout(function(){
                    ctrl.showDeletedPrompt = false;
                }, 2200);
            });
            
            
     

    });




   //**********END OF ITEM DELETE**************

//start search

    $scope.callback = function(selected) {
        ctrl.disabledFind = ctrl.itemId || ctrl.itemDescription ? false : true;
    };

    var disableFindButton = function () {
        ctrl.disabledFind = ctrl.itemId || ctrl.itemDescription ? false : true;
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

    $scope.gridAdjReasonListValue = {
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
            {name:'Option Value' , field: 'optionValue'},
            {name:'Description', field: 'description'},
            {name:'Created Date', field: 'createdDate', type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Display Order', field: 'displayOrder'},            
            {name: 'Actions', enableSorting: false,  cellTemplate: '<div ng-if="grid.appScope.validateAction(row)" style="color:#ff0000">System Defined</div><div ng-if="!grid.appScope.validateAction(row)" class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.Delete(row)">Delete</a></li></ul></div>'}

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

    $scope.gridItemcatListValue = {
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
            {name:'Option Value' , field: 'optionValue'},
            {name:'Description', field: 'description'},
            {name:'Created Date', field: 'createdDate', type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Display Order', field: 'displayOrder'},            
            {name: 'Actions', enableSorting: false,  cellTemplate: '<div ng-if="grid.appScope.validateAction(row)" style="color:#ff0000">System Defined</div><div ng-if="!grid.appScope.validateAction(row)" class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.Delete(row)">Delete</a></li></ul></div>'}

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

    $scope.gridRshspValue = {
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
            {name:'Option Value' , field: 'optionValue'},
            {name:'Description', field: 'description'},
            {name:'Created Date', field: 'createdDate', type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Display Order', field: 'displayOrder'},            
            {name: 'Actions', enableSorting: false,  cellTemplate: '<div ng-if="grid.appScope.validateAction(row)" style="color:#ff0000">System Defined</div><div ng-if="!grid.appScope.validateAction(row)" class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.Delete(row)">Delete</a></li></ul></div>'}

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

    $scope.gridStrgValue = {
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
            {name:'Option Value' , field: 'optionValue'},
            {name:'Description', field: 'description'},
            {name:'Created Date', field: 'createdDate', type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Display Order', field: 'displayOrder'},            
            {name: 'Actions', enableSorting: false,  cellTemplate: '<div ng-if="grid.appScope.validateAction(row)" style="color:#ff0000">System Defined</div><div ng-if="!grid.appScope.validateAction(row)" class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.Delete(row)">Delete</a></li></ul></div>'}

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

    $scope.gridCarrCodeValue = {
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
            {name:'Option Value' , field: 'optionValue'},
            {name:'Description', field: 'description'},
            {name:'Created Date', field: 'createdDate', type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Display Order', field: 'displayOrder'},            
            {name: 'Actions', enableSorting: false,  cellTemplate: '<div ng-if="grid.appScope.validateAction(row)" style="color:#ff0000">System Defined</div><div ng-if="!grid.appScope.validateAction(row)" class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.Delete(row)">Delete</a></li></ul></div>'}

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


    $scope.gridInvStatusValue = {
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
            {name:'Option Value' , field: 'optionValue'},
            {name:'Description', field: 'description'},
            {name:'Created Date', field: 'createdDate', type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Display Order', field: 'displayOrder'},            
            {name: 'Actions', enableSorting: false,  cellTemplate: '<div ng-if="grid.appScope.validateAction(row)" style="color:#ff0000">System Defined</div><div ng-if="!grid.appScope.validateAction(row)" class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.Delete(row)">Delete</a></li></ul></div>'}

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

    $scope.gridCprValue = {
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
            {name:'Option Value' , field: 'optionValue'},
            {name:'Description', field: 'description'},
            {name:'Created Date', field: 'createdDate', type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Display Order', field: 'displayOrder'},            
            {name: 'Actions', enableSorting: false,  cellTemplate: '<div ng-if="grid.appScope.validateAction(row)" style="color:#ff0000">System Defined</div><div ng-if="!grid.appScope.validateAction(row)" class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.Delete(row)">Delete</a></li></ul></div>'}

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

    $scope.validateAction = function(row){
        if (row.entity.companyId.toUpperCase() == 'ALL') {
            return true;
        }
        else{
            return false;
        }
    };

    var search = function () {
        var values = [];
        for (i=0;i<ctrl.configValue.length;i++) {
            values.push("'"+ctrl.configValue[i].configValue+"'")
        }
        selectedValues = values.join();

        if (ctrl.searchForm.$valid) {
            $http({
                method: 'POST',
                url: '/item/searchResults',
                params: {itemId:ctrl.itemId, itemDescription:ctrl.itemDescription, itemCategory:ctrl.itemCategory,
                    isLotTracked:ctrl.isLotTracked, isExpired:ctrl.isExpired, configValue:selectedValues},
                data    :  $scope.ctrl,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    $scope.gridListValue.data = data;
                    //clearForm();
                })
        }
    };

    ctrl.search = search;


    ctrl.validateOptionValue = function(viewValue){
        $http({
            method : 'GET',
            url : '/listValue/getAllListValueByOptionValues',
            params: {optionGroup:ctrl.newListValue.optionGroup, optionValue: viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    ctrl.createListValueForm.optionValue.$setValidity('optionValueExists', true);
                }
                else
                {
                    ctrl.createListValueForm.optionValue.$setValidity('optionValueExists', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.createListValueForm.optionValue.$setValidity('optionValueExists', false);
            });
    };

    ctrl.validateDescription = function(viewValue){

        if (ctrl.previousDescriptionValue.toUpperCase() == viewValue.toUpperCase()) {
            ctrl.createListValueForm.description.$setValidity('descriptionExists', true);
        }
        else{

            $http({
                method : 'GET',
                url : '/listValue/getAllListValueByDescription',
                params: {optionGroup:ctrl.newListValue.optionGroup, description: viewValue}
            })
                .success(function (data, status, headers, config) {

                    if(data.length == 0){
                        ctrl.createListValueForm.description.$setValidity('descriptionExists', true);
                    }
                    else
                    {
                        ctrl.createListValueForm.description.$setValidity('descriptionExists', false);
                    }

                })
                .error(function (data, status, headers, config) {
                    ctrl.createListValueForm.description.$setValidity('descriptionExists', false);
                });

        }
    };

    var getCurrentCompanyinfo = function () {

        $http({
            method: 'GET',
            url: '/company/getCurrentUserCompany',
        })
        .success(function (data, status, headers, config) {
            ctrl.autoLoadPalletId = data.autoLoadPalletId;
            ctrl.companyBolType = data.bolType;
            ctrl.autoLoadContainerForPackout = data.isAutoLoadPackoutContainer;
        })
    }

    var getCurrentUserinfo = function () {

        $http({
            method: 'GET',
            url: '/user/getCurrentUser',
        })
        .success(function (data, status, headers, config) {
            ctrl.isLogEnabledConf = data.isLogEnabled;
        })
    }

    getCurrentCompanyinfo();
    getCurrentUserinfo();

    ctrl.updateWarehouseConfig = function(){

            $http({
                method  : 'POST',
                url     : '/settings/updateWarehouseConfig',
                data    :  {autoLoadPalletId:ctrl.autoLoadPalletId, bolType:ctrl.companyBolType, autoLoadContainer:ctrl.autoLoadContainerForPackout, isLogEnabled:ctrl.isLogEnabledConf},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.showConfUpdatedPrompt = true;
                    $timeout(function(){
                    ctrl.showConfUpdatedPrompt = false;
                    }, 3200);
                })
    };

    ctrl.updateAutoContainerForPackout = function(){

            $http({
                method  : 'POST',
                url     : '/settings/updateAutoContainerForPackout',
                data    :  {autoLoadContainer:ctrl.autoLoadContainerForPackout},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.showConfUpdatedPrompt = true;
                    $timeout(function(){
                    ctrl.showConfUpdatedPrompt = false;
                    }, 3200);
                })
    };    

    ctrl.updateLogging = function(){

            $http({
                method  : 'POST',
                url     : '/userAccount/updateLogEnabled',
                //data    :  {autoLoadPalletId:ctrl.companyInfoApi.autoLoadPalletId},
                params : {isLogEnabled:ctrl.isLogEnabledConf},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.showConfUpdatedPrompt = true;
                    $timeout(function(){
                    ctrl.showConfUpdatedPrompt = false;
                    }, 3200);
                })
    };

    ctrl.updateBolType = function(){

            $http({
                method  : 'POST',
                url     : '/settings/updateBolType',
                data    :  {bolType:ctrl.companyBolType},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.showConfUpdatedPrompt = true;
                    $timeout(function(){
                    ctrl.showConfUpdatedPrompt = false;
                    }, 3200);
                })
    };    

//end of the grid



//multi combo box list items

    //end multi combo box list items

    //end search

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

angular.element(document).ready(function() {
    var pagHeight = $(window).height()-30;
    $('nav.confNav > ul.nav').css({'height': pagHeight + 'px'});


    $(document).on("scroll", scrollToId);

      $('.listNav > li > a').on('click', function(event) {
          console.log("what's happening");
          event.preventDefault();
          $(document).off("scroll");
          $('.listNav > li > a').removeClass('active');
          $(this).addClass('active');
          var scrollId = $(this)[0].getAttribute("href");
          var offsets = $(scrollId).offset();
          var position = offsets.top;
          window.scrollTo(0, position - 130);

      });


});

function scrollToId (){
    $('.panel-content').each(function() {
        if($(window).scrollTop() >= $(this).offset().top) {
            var id = $(this).attr('id');
            $('.listNav > li > a').removeClass('active');
            $('.listNav > li > a[href=#'+ id +']').addClass('active');
            var idTarget = $('.listNav > li > a[href=#'+ id +']').attr('data-target');
            $(idTarget).collapse('show');
        }
    });
}

