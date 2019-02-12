/**
 * Created by home on 10/14/15.
 */

var app = angular.module('inventoryDailyOperationalReport', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ui.grid.expandable', 'ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ngSanitize', 'ui.grid.pagination','ui.bootstrap', 'ngLocale', 'ui.grid.autoResize', 'ui.grid.resizeColumns']);

app.controller('InventoryDailyOperationalReportCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

    var myEl = angular.element( document.querySelector( '#liInventory' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulInventory' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'Inventory Daily Operational Report';




    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };



    var ctrl = this,
        findInventory = { inventoryId:'', itemId:'', lpn:'', location:'' };


    ctrl.newCustomer = findInventory;

    var loadGridData = function (){
        $http({
            method: 'GET',
            url: '/inventorySummary/getAllInventorySummary',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridInventory.data = data;

            })
        $http({
            method: 'GET',
            url: '/receiving/priorDayInventoryReceived',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridReceivedInventory.data = data;

            })
        $http({
            method: 'GET',
            url: '/shipment/priorDayInventoryShipped',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridShippedInventory.data = data;

            })
        $http({
            method: 'GET',
            url: '/picking/priorDayInventoryPicked',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridPickedInventory.data = data;

            })
        $http({
            method: 'GET',
            url: '/inventory/priorDayInventoryAdjusted',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridAdjustedInventory.data = data;

            })
    };
    loadGridData();

    //Start Inventory grid
    $scope.gridInventory = {

        enableRowSelection: true,
        enableRowHeaderSelection : false,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: true,
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
            {name:'Item Id', field: 'item_id'},
            {name:'Inventory Status', field: 'inventory_status_desc'},
            {name:'Quantity', field: 'available_qty'},
            {name:'UOM', field: 'uom'}
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

    //Start Received Inventory grid
    $scope.gridReceivedInventory = {

        enableRowSelection: true,
        enableRowHeaderSelection : false,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: true,
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
            {name:'Pallet Id', field: 'pallet_id'},
            {name:'Case Id', field: 'case_id'},
            {name:'Item Id', field: 'item_id'},
            {name:'Inventory Status', field: 'inventory_status_desc'},
            {name:'Quantity', field: 'quantity'},
            {name:'UOM', field: 'uom'},
            {name:'Putaway Location', field: 'location_id'}
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
    //End Received Inventory grid

    //Start Shipped Inventory grid
    $scope.gridShippedInventory = {

        enableRowSelection: true,
        enableRowHeaderSelection : false,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: true,
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
            {name:'Shipment Id', field: 'shipment_id'},
            {name:'Item Id', field: 'item_id'},
            {name:'Inventory Status', field: 'inventory_status_desc'},
            {name:'Shipped Quantity', field: 'shipped_quantity'},
            {name:'UOM', field: 'shippeduom'}
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
    //End Shipped Inventory grid

    //Start Picked Inventory grid
    $scope.gridPickedInventory = {

        enableRowSelection: true,
        enableRowHeaderSelection : false,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: true,
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
            {name:'Item Id', field: 'item_id'},
            {name:'Inventory Status', field: 'inventory_status_desc'},
            {name:'Picked Quantity', field: 'pick_quantity'},
            {name:'UOM', field: 'pick_quantity_uom'},
            {name:'Pick Type', field: 'pick_type'},
            {name:'Shipment Id', field: 'shipment_id'},
            {name:'Shipment Line Id', field: 'shipment_line_id'}
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
    //End Picked Inventory grid

    //Start Adjusted Inventory grid
    $scope.gridAdjustedInventory = {

        enableRowSelection: true,
        enableRowHeaderSelection : false,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: true,
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
            {name:'Adj Id', field: 'adjustment_id'},
            {name:'Location', field: 'location_id'},
            {name:'Pallet', field: 'pallet_id'},
            {name:'Case', field: 'case_id'},
            {name:'Item Id', field: 'item_id'},
            {name:'UOM', field: 'uom'},
            {name:'Inventory Status', field: 'inventory_status_desc'},
            {name:'Prev Inventory Status', field: 'previous_inventory_status_desc'},
            {name:'Quantity', field: 'qty'},
            {name:'Prev Quantity', field: 'prev_qty'},
            {name:'Action', field: 'action'},
            {name:'User', field: 'user_id'}
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
    //End Adjusted Inventory grid

}])

;
