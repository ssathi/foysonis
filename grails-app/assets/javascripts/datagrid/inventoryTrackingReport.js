/**
 * Created by home on 10/14/15.
 */

var app = angular.module('inventoryTrackingReport', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ui.grid.expandable', 'ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ngSanitize', 'ui.grid.pagination','ui.bootstrap', 'ngLocale', 'ui.grid.autoResize', 'ui.grid.resizeColumns']);

app.controller('inventoryTrackingReportCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

    var myEl = angular.element(document.querySelector('#liAdmin'));
    myEl.addClass('active');
    var subMenu = angular.element(document.querySelector('#ulAdmin'));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'Inventory Daily Operational Report';
    //Date Control

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

    $scope.openFromDate = function() {
        $scope.popupFromDate.opened = true;
    };


    $scope.openToDate = function() {
        $scope.popupToDate.opened = true;
    };


    //$scope.formats = ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'MM/dd/yyyy', 'shortDate'];
    //$scope.format = $scope.formats[3];
    $scope.format = $locale.DATETIME_FORMATS.shortDate;
    $scope.altInputFormats = ['M!/d!/yyyy'];

    $scope.popupFromDate = {
        opened: false
    };

    $scope.popupEarlyShipDateFrom = {
        opened: false
    };

    $scope.popupEarlyShipDateTo = {
        opened: false
    };

    $scope.popupToDate = {
        opened: false
    };

    $scope.popupToFrom = {
        opened: false
    };

    $scope.popupToDateTo = {
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
            {name:'Receipt Id', field: 'receipt_id'},
            {name:'Pallet Id', field: 'pallet_id'},
            {name:'Case Id', field: 'case_id'},
            {name:'Item Id', field: 'item_id'},
            {name:'Description', field: 'item_description'},
            {name:'Inventory Status', field: 'inventory_status_desc'},
            {name:'Quantity', field: 'quantity'},
            {name:'UOM', field: 'uom'},
            {name:'Putaway Location', field: 'location_id'},
            {name:'User Id', field:'user_id'},
            {name:'Created Date', field:'created_date', type: 'date',cellFilter: 'date:"yyyy-MM-dd hh:mm:ss"'}
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
    // $scope.gridShippedInventory = {

    //     enableRowSelection: true,
    //     enableRowHeaderSelection : false,
    //     exporterMenuCsv: true,
    //     enableGridMenu: true,
    //     enableFiltering: true,
    //     gridMenuTitleFilter: fakeI18n,
    //     paginationPageSizes: [10, 50, 75],
    //     paginationPageSize: 10,

    //     exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
    //     exporterPdfHeader: { text: headerTitle, style: 'headerStyle' },
    //     exporterPdfFooter: function ( currentPage, pageCount ) {
    //         return { text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle' };
    //     },
    //     exporterPdfCustomFormatter: function ( docDefinition ) {
    //         docDefinition.styles.headerStyle = { fontSize: 15, bold: true, margin: 20};
    //         //docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
    //         return docDefinition;
    //     },
    //     exporterPdfOrientation: 'portrait',
    //     exporterPdfPageSize: 'LETTER',
    //     exporterPdfMaxGridWidth: 500,

    //     columnDefs: [
    //         {name:'Shipment Id', field: 'shipment_id'},
    //         {name:'Item Id', field: 'item_id'},
    //         {name:'Inventory Status', field: 'inventory_status_desc'},
    //         {name:'Shipped Quantity', field: 'shipped_quantity'},
    //         {name:'UOM', field: 'shippeduom'},

    //     ],


    //     onRegisterApi: function( gridApi ){
    //         $scope.gridApi = gridApi;

    //         // interval of zero just to allow the directive to have initialized
    //         $interval( function() {
    //             gridApi.core.addToGridMenu( gridApi.grid, [{ title: 'Dynamic item', order: 100}]);
    //         }, 0, 1);

    //         gridApi.core.on.columnVisibilityChanged( $scope, function( changedColumn ){
    //             $scope.columnChanged = { name: changedColumn.colDef.name, visible: changedColumn.colDef.visible };
    //         });
    //     }
    // };
    //End Shipped Inventory grid

    //Start Picked Inventory grid
    // $scope.gridPickedInventory = {

    //     enableRowSelection: true,
    //     enableRowHeaderSelection : false,
    //     exporterMenuCsv: true,
    //     enableGridMenu: true,
    //     enableFiltering: true,
    //     gridMenuTitleFilter: fakeI18n,
    //     paginationPageSizes: [10, 50, 75],
    //     paginationPageSize: 10,

    //     exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
    //     exporterPdfHeader: { text: headerTitle, style: 'headerStyle' },
    //     exporterPdfFooter: function ( currentPage, pageCount ) {
    //         return { text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle' };
    //     },
    //     exporterPdfCustomFormatter: function ( docDefinition ) {
    //         docDefinition.styles.headerStyle = { fontSize: 15, bold: true, margin: 20};
    //         //docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
    //         return docDefinition;
    //     },
    //     exporterPdfOrientation: 'portrait',
    //     exporterPdfPageSize: 'LETTER',
    //     exporterPdfMaxGridWidth: 500,

    //     columnDefs: [
    //         {name:'Item Id', field: 'item_id'},
    //         {name:'Inventory Status', field: 'inventory_status_desc'},
    //         {name:'Picked Quantity', field: 'pick_quantity'},
    //         {name:'UOM', field: 'pick_quantity_uom'},
    //         {name:'Pick Type', field: 'pick_type'},
    //         {name:'Shipment Id', field: 'shipment_id'},
    //         {name:'Shipment Line Id', field: 'shipment_line_id'}
    //     ],


    //     onRegisterApi: function( gridApi ){
    //         $scope.gridApi = gridApi;

    //         // interval of zero just to allow the directive to have initialized
    //         $interval( function() {
    //             gridApi.core.addToGridMenu( gridApi.grid, [{ title: 'Dynamic item', order: 100}]);
    //         }, 0, 1);

    //         gridApi.core.on.columnVisibilityChanged( $scope, function( changedColumn ){
    //             $scope.columnChanged = { name: changedColumn.colDef.name, visible: changedColumn.colDef.visible };
    //         });
    //     }
    // };
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
            {name:'Item', field: 'item_id'},
            {name:'Description', field: 'item_description'},
            {name:'UOM', field: 'uom'},
            {name:'Inventory Status', field: 'inventory_status_desc'},
            {name:'Prev Inventory Status', field: 'previous_inventory_status_desc'},
            {name:'Quantity', field: 'qty'},
            {name:'Prev Quantity', field: 'prev_qty'},
            {name:'Action', field: 'action'},
            {name:'User', field: 'user_id'},
            {name:'Created Date', field:'created_date', type: 'date',cellFilter: 'date:"yyyy-MM-dd hh:mm:ss"'}
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

    $scope.gridMoveInventory = {

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
            {name:'From Location', field: 'from_location_id'},
            {name:'To Location', field: 'to_location_id'},
            {name:'Inventory Status', field: 'inventory_status_desc'},
            {name:'Item', field: 'item_id'},
            {name:'Description', field: 'item_description'},
            {name:'LPN', field: 'lpn'},
            {name:'Move Type', field: 'move_type'},
            {name:'Quantity', field: 'quantity'},
            {name:'To Pallet', field: 'to_pallet_id'},
            {name:'User Id', field:'user_id'},
            {name:'Created Date', field:'created_date', type: 'date',cellFilter: 'date:"yyyy-MM-dd hh:mm:ss"'}
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

    var toDate =  new Date();
    var fromDate =  new Date();
    fromDate.setDate(fromDate.getDate() - 1);

    ctrl.fromDateReceived = fromDate;
    ctrl.toDateReceived = toDate;
    ctrl.fromDateInvAdj = fromDate;
    ctrl.toDateInvAdj = toDate;
    ctrl.fromDateMove = fromDate;
    ctrl.toDateMove = toDate;

    ctrl.findInventoryReceived = function () {

            // ctrl.fromDateReceived.setDate(ctrl.fromDateReceived.getDate() + 1);
            // ctrl.toDateReceived.setDate(ctrl.toDateReceived.getDate() + 1);
            $http({
                method: 'GET',
                url: '/receiving/inventoryReceivedFromTo',
                params : {fromDate:ctrl.fromDateReceived, toDate: ctrl.toDateReceived}
            })
            .success(function (data) {
                $scope.gridReceivedInventory.data = data;
                // ctrl.fromDateReceived.setDate(ctrl.fromDateReceived.getDate() - 1);
                // ctrl.toDateReceived.setDate(ctrl.toDateReceived.getDate() - 1);

            })
    };  
    ctrl.findInventoryAdjustment = function () {

            // ctrl.fromDateInvAdj.setDate(ctrl.fromDateInvAdj.getDate() + 1);
            // ctrl.toDateInvAdj.setDate(ctrl.toDateInvAdj.getDate() + 1);
            $http({
                method: 'GET',
                url: '/inventory/inventoryAdjustedFromTo',
                params : {fromDate:ctrl.fromDateInvAdj, toDate: ctrl.toDateInvAdj}
            })
            .success(function (data) {
                $scope.gridAdjustedInventory.data = data;
                // ctrl.fromDateInvAdj.setDate(ctrl.fromDateInvAdj.getDate() - 1);
                // ctrl.toDateInvAdj.setDate(ctrl.toDateInvAdj.getDate() - 1);

            })
    };  

    ctrl.findMovedInventory = function () {

            // ctrl.fromDateMove.setDate(ctrl.fromDateMove.getDate() + 1);
            // ctrl.toDateMove.setDate(ctrl.toDateMove.getDate() + 1);
            $http({
                method: 'GET',
                url: '/inventory/inventoryMoveDataFromTo',
                params : {fromDate:ctrl.fromDateMove, toDate: ctrl.toDateMove}
            })
            .success(function (data) {
                $scope.gridMoveInventory.data = data;
                // ctrl.fromDateMove.setDate(ctrl.fromDateMove.getDate() - 1);
                // ctrl.toDateMove.setDate(ctrl.toDateMove.getDate() - 1);

            })
    };  

}])

;
