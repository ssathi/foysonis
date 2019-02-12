/**
 * Created by home on 10/14/15.
 */

var app = angular.module('inventory', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ui.grid.expandable', 'ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ngSanitize', 'ui.grid.pagination','ui.bootstrap', 'ngLocale', 'ui.grid.autoResize', 'ui.grid.resizeColumns']);

app.controller('InventoryCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

    var myEl = angular.element( document.querySelector( '#liInventory' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulInventory' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'Inventory';
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

    $scope.openExpirationDateFrom = function() {
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

        var getAllListValueItemCategory = function () {
            $http({
                method: 'GET',
                url: '/order/getAllValuesByCompanyIdAndGroup',
                params : {group: 'ITEMCAT'}
            })
                .success(function (data, status, headers, config) {
                    //ctrl.itemCategoryOptions = data;
                    var noneOption = [{description: ''}];
                    ctrl.itemCategoryOptions = noneOption.concat(data);
                })
        };
        getAllListValueItemCategory();

//Date Control

    // var loadLocationAutoComplete = function () {
    //     $http.get('/location/getCompanyAllLocations')
    //         .success(function(data) {
    //             $scope.source3 = data;
    //         });
    // };

    $scope.loadLocationAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/location/getCompanyAllLocations',
            params : {keyword: value.keyword}
        });
    }

    $scope.loadPalletAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/inventory/getPallets',
            params : {keyword: value.keyword}
        });
    }

    //var loadPalletAutoComplete = function () {
    //    $http.get('/inventory/getPallets')
    //        .success(function(data) {
    //            $scope.sourcePallets = data;
    //        });
    //};

    $scope.loadCaseAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/inventory/getCases',
            params : {keyword: value.keyword}
        });
    }

    //var loadCaseAutoComplete = function () {
    //    $http.get('/inventory/getCases')
    //        .success(function(data) {
    //            $scope.sourceCases = data;
    //        });
    //};

    $scope.callback = function(selected) {
        ctrl.disabledFind = ctrl.findInventory.itemId || ctrl.findInventory.lpn || ctrl.findInventory.location ? false : true;
    };


    var getAllAreas = function(){
        $http({
            method: 'GET',
            url: '/area/getAllAreas'
        })

        .success(function (data, status, headers, config) {
            //ctrl.allAreaData = emptyArea.concat(data);
            var noneOption = [{areaId: ''}];
            ctrl.allAreaData = noneOption.concat(data);            
        })
    };


    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };

    var showAdditionalSearch = function () {
        getOriginCodes();
        ctrl.displayAdditionalSearch = ctrl.displayAdditionalSearch ? false : true;
        //ctrl.findInventory.lotCode = null
        //ctrl.findInventory.originCode = null
        //ctrl.findInventory.toExpirationDate = null
        //ctrl.findInventory.fromExpirationDate = null

        ctrl.inventoryNote = null
        ctrl.lotCode = null
        ctrl.originCode = null
        ctrl.toExpirationDate = null
        ctrl.fromExpirationDate = null
    };

    var showExpirationDateRange = function () {
        ctrl.displayExpirationDateRange = ctrl.expirationDateRange
    };

    var disableFindButton = function () {
        ctrl.disabledFind = ctrl.findInventory.location|| ctrl.findInventory.lpn || ctrl.findInventory.itemId ? false : true;
    };

    var disableFindButtonForAutoComp = function(selected){
        ctrl.disabledFind = selected;
    };

    var clearAutoCompText = function(){
        ctrl.location = ''; 
        ctrl.disabledFind = ctrl.findInventory.location|| ctrl.findInventory.lpn || ctrl.findInventory.itemId ? false : true;
    };

    var getOriginCodes = function () {
        $http({
            method : 'GET',
            url: '/item/getOriginCodeForCountries'
        })
            .success(function (data, status, headers, config) {
                //ctrl.originCodes = data;
                var noneOption = [{name: ''}];
                ctrl.originCodes = noneOption.concat(data);
            })
    };

    var getSubGridRow = function (item_id, pallet_id) {

        $http({
            method : 'GET',
            url: '/inventory/getInventoryEntityAttributeForSearchRow',
            params : {selectedRowItem: item_id, selectedRowPallet: pallet_id}
        })
            .success(function (data, status, headers, config) {
                return data;
            })
    };

    var inventorySearch = function () {

        //if (ctrl.inventorySearchForm.$valid) {

        $http({
            method: 'POST',
            url: '/inventory/search',
            //params: {itemId:ctrl.findInventory.itemId, lpn:ctrl.findInventory.lpn, location: ctrl.findInventory.location,
            //    lotCode:ctrl.findInventory.lotCode, originCode:ctrl.findInventory.originCode},

            params: {itemId:ctrl.itemId, lpn:ctrl.lpn, location: ctrl.location,
                lotCode:ctrl.lotCode, inventoryNote: ctrl.inventoryNote, originCode:ctrl.originCode,
                inventoryStatus:ctrl.findInventoryStatus,
                areaId:ctrl.areaSearch, itemCategory:ctrl.findItemCategory},

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

    //loadLocationAutoComplete();
    //loadPalletAutoComplete();
    //loadCaseAutoComplete();
    getAllAreas(); 
    ctrl.displayAdditionalSearch = false;
    ctrl.disabledFind = true;
    ctrl.showAdditionalSearch = showAdditionalSearch;
    ctrl.showExpirationDateRange = showExpirationDateRange;
    ctrl.disableFindButton = disableFindButton;
    ctrl.disableFindButtonForAutoComp = disableFindButtonForAutoComp;
    ctrl.clearAutoCompText = clearAutoCompText;
    ctrl.newCustomer = findInventory;
    ctrl.inventorySearch = inventorySearch;

    var loadGridData = function (){
        $http({
            method: 'POST',
            url: '/inventory/search',
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
        expandableRowTemplate: "<div ui-grid='row.entity.subGridOptions' style='height:150px;'></div>",
        //This will be the height of the subgrid
        expandableRowHeight: 150,

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
