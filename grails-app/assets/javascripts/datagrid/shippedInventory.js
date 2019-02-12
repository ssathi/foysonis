/**
 * Created by home on 10/14/15.
 */

var app = angular.module('shippedInventory', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ui.grid.expandable', 'ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ngSanitize', 'ui.grid.pagination','ui.bootstrap', 'ngLocale', 'ui.grid.autoResize', 'ui.grid.resizeColumns']);

app.controller('ShippedInventoryCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

    var myEl = angular.element( document.querySelector( '#liShipping' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulShipping' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');


    var headerTitle = 'Shipped Inventory';
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

    $scope.openShipmentCompletionDateFrom = function() {
        $scope.popupExpirationDateFrom.opened = true;
    };
    $scope.openExpirationDateTo = function() {
        $scope.popupExpirationDateTo.opened = true;
    };

    $scope.format = $locale.DATETIME_FORMATS.shortDate;
    $scope.altInputFormats = ['M!/d!/yyyy'];

    $scope.popupExpirationDateFrom = {
        opened: false
    };
    $scope.popupExpirationDateTo = {
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

        var getAllListValueInventoryStatus = function () {
            $http({
                method: 'GET',
                url: '/order/getAllValuesByCompanyIdAndGroup',
                params : {group: 'INVSTATUS'}
            })
                .success(function (data, status, headers, config) {
                    //ctrl.inventoryStatusOptions = data;
                    var noneOption = [{description: ''}];
                    ctrl.inventoryStatusOptions = noneOption.concat(data);
                })
        };
        getAllListValueInventoryStatus();



//Date Control

    $scope.callback = function(selected) {
        ctrl.disabledFind = ctrl.findInventory.itemId || ctrl.findInventory.lpn || ctrl.findInventory.location ? false : true;
    };


    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };

    var showAdditionalSearch = function () {
        // getOriginCodes();
        ctrl.displayAdditionalSearch = ctrl.displayAdditionalSearch ? false : true;
        //ctrl.findInventory.lotCode = null
        //ctrl.findInventory.originCode = null
        //ctrl.findInventory.toExpirationDate = null
        //ctrl.findInventory.fromExpirationDate = null

        ctrl.toShipmentCompletionDate = null
        ctrl.fromShipmentCompletionDate = null
    };

    var showShipmentCompletionDateRange = function () {
        ctrl.displayShipmentCompletionDateRange = ctrl.expirationDateRange
    };

    var disableFindButton = function () {
        ctrl.disabledFind = ctrl.findInventory.location|| ctrl.findInventory.lpn || ctrl.findInventory.itemId ? false : true;
    };

    var disableFindButtonForAutoComp = function(selected){
        ctrl.disabledFind = selected;
    };

    var inventorySearch = function () {

        if(ctrl.displayShipmentCompletionDateRange != true){
            ctrl.toShipmentCompletionDate = null;
        }

        $http({
            method: 'GET',
            url: '/inventory/shippedInventorySearch',
            //params: {itemId:ctrl.findInventory.itemId, lpn:ctrl.findInventory.lpn, location: ctrl.findInventory.location,
            //    lotCode:ctrl.findInventory.lotCode, originCode:ctrl.findInventory.originCode},

            params: {itemId:ctrl.itemId, lpn:ctrl.lpn, shipmentId:ctrl.shipmentId, orderNumber:ctrl.orderNumber, customerName:ctrl.customerName, inventoryNote:ctrl.inventoryNote, inventoryStatus:ctrl.inventoryStatus, fromShipmentCompletionDate:ctrl.fromShipmentCompletionDate, toShipmentCompletionDate:ctrl.toShipmentCompletionDate},

            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {

                //$scope.gridItem.data = data;
                $scope.gridItem.data = data.splice(0,10000);
            })
        //}


    };


    var ctrl = this,
        findInventory = { inventoryId:'', itemId:'', lpn:'', location:'' };

    ctrl.displayAdditionalSearch = false;
    ctrl.disabledFind = true;
    ctrl.showAdditionalSearch = showAdditionalSearch;
    ctrl.showShipmentCompletionDateRange = showShipmentCompletionDateRange;
    ctrl.disableFindButton = disableFindButton;
    ctrl.disableFindButtonForAutoComp = disableFindButtonForAutoComp;
    // ctrl.clearAutoCompText = clearAutoCompText;
    ctrl.newCustomer = findInventory;
    ctrl.inventorySearch = inventorySearch;

    var loadGridData = function (){
        $http({
            method: 'POST',
            url: '/inventory/shippedInventorySearch',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridItem.data = data.splice(0,10000);

            })
    };
    loadGridData();
    
    //Start Inventory grid
    $scope.gridItem = {

        //This is the template that will be used to render subgrid.
        // expandableRowTemplate: "<div ui-grid='row.entity.subGridOptions' style='height:150px;'></div>",
        //This will be the height of the subgrid
        // expandableRowHeight: 150,

        enableRowSelection: true,
        enableRowHeaderSelection : false,
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
            {name:'Completed Date', field: 'completed_date', type: "date",cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Customer', field: 'customer_name'},
            {name:'Order', field: 'order_number'},
            {name:'Shipment', field: 'shipment_id'},
            {name:'Shipment Address', field: 'shipment_address'},
            {name:'Pallet Id', field: 'pallet_id'},
            {name:'Case Id', field: 'case_id'},
            {name:'Item Id', field: 'item_id'},
            {name:'Description', field: 'item_description'},
            {name:'Inventory Status', field: 'inventory_status'},
            {name:'Quantity', field: 'quantity', type: 'number', },
            {name:'Unit Of Measure', field: 'handling_uom', cellClass:'qtyNumberGrid'},
            {name:'Order Notes', cellTemplate: '<span><a href="javascript:void(0)" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;" popover-trigger="outsideClick" ng-show="row.entity.order_notes" uib-popover="{{row.entity.order_notes}}" popover-title="" popover-append-to-body="true" >View</a></span>'},
            {name:'Inventory Notes', cellTemplate: '<span><a href="javascript:void(0)" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;" popover-trigger="outsideClick" ng-show="row.entity.picked_inventory_notes" uib-popover="{{row.entity.picked_inventory_notes}}" popover-title="" popover-append-to-body="true" >View</a></span>'}

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
