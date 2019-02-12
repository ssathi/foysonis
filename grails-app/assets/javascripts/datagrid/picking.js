/**
 * Created by User on 2016-02-02.
 */

var app = angular.module('picking', ['pickingService','ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ui.grid.expandable' ,'ui.grid.autoResize','ui.bootstrap', 'ngLocale', 'ui.grid.resizeColumns']);

app.controller('pickingCtrl', ['$scope', '$http', '$interval', '$q', '$timeout','pickService', '$locale', '$location', function ($scope, $http, $interval, $q, $timeout, pickService, $locale, $location) {

    var myEl = angular.element( document.querySelector( '#liPicking' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulPicking' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'Pallet Picks';
    var headerTitle1 = 'shipment';
    var headerTitle2 = 'Replenishment';

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

    $scope.openShipmentCreateDateFrom = function() {
        $scope.popupShipmentCreateDateFrom.opened = true;
    };
    $scope.openShipmentCreateDateTo = function() {
        $scope.popupShipmentCreateDateTo.opened = true;
    };

    $scope.format = $locale.DATETIME_FORMATS.shortDate;
    $scope.altInputFormats = ['M!/d!/yyyy'];

    $scope.popupShipmentCreateDateFrom = {
        opened: false
    };
    $scope.popupShipmentCreateDateTo = {
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
 
 //******************Allocation & picking status************************************


    var loadCustomerAutoComplete = function () {
        $http.get('/order/getAllcustomerIdByCompany')
            .success(function(data) {
                $scope.loadCompanyCustomers = data;
                var AddCustomer = [{contactName: '+ New Customer'}];
                $scope.loadCompanyCustomersForOrder = data.concat(AddCustomer);
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

    var ctrl = this;


    var getCreatedDate = function(date){
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

    ctrl.getCreatedDate = getCreatedDate;


    var getClickedShipment = function(clickedId, status){
        ctrl.selectedShipmentId = clickedId;
        ctrl.selectedShipmentStatus = status;
        getPalletPicksByShipment(ctrl.selectedShipmentId);
        getAllPickListByShipment(ctrl.selectedShipmentId); 
        getReplenishmentWorkDataByShipment(ctrl.selectedShipmentId);
        getAllShipmentLinesByShipmentId(ctrl.selectedShipmentId);
        getSelectedShipmentDataByShipmentId(ctrl.selectedShipmentId);

        // if (status == 'PLANNED') {
        //     getAllShipmentLinesByShipmentId(ctrl.selectedShipmentId);
        //     getSelectedShipmentDataByShipmentId(ctrl.selectedShipmentId);
        // }
    };

    ctrl.getClickedShipment = getClickedShipment;




    var getPalletPicksByShipment = function(shipmentId){
        pickService.getPalletPicksByShipment(shipmentId).then(function(response) {
            $scope.gridPalletPicks.data = response;
        });
    };





    var getAllPickListByShipment = function(shipmentId){
        pickService.getAllPickListByShipment(shipmentId).then(function(response) {
            ctrl.pickListByShipment = response;
 

        });
    };


    ctrl.pickWorkData = [];

    var getPickWorkDataByPickList = function(pickListId,index){
        pickService.getPickWorkDataByPickList(pickListId).then(function(response) {
            ctrl.pickWorkData[index] = response;

        });
    };


    var getReplenishmentWorkDataByShipment = function(shipmentId){
        pickService.getReplenishmentWorkDataByShipment(shipmentId).then(function(response) {
            $scope.gridReplenWork.data = response;

        });
    };


    var getAllShipmentLinesByShipmentId = function(shipmentId){
        pickService.getAllShipmentLinesByShipmentId(shipmentId).then(function(response) {
            $scope.gridShipmentLines.data = response;

        });
    };    


    var getSelectedShipmentDataByShipmentId = function(shipmentId){
        pickService.getSelectedShipmentDataByShipmentId(shipmentId).then(function(response) {
            ctrl.selectedShipmentData = response;

            if (status != 'PLANNED') {
                if ($scope.gridReplenWork.data.length > 0) {
                    $('.nav-tabs a[href="#replen"]').tab('show');
                }
                else if (ctrl.pickListByShipment.length > 0) {
                    $('.nav-tabs a[href="#pickList"]').tab('show');
                }
                else if ($scope.gridPalletPicks.data.length > 0) {
                    $('.nav-tabs a[href="#palletPick"]').tab('show');
                }
                else{
                    $('.nav-tabs a[href="#shipment"]').tab('show');
                }
            }

        });
    };       

    var getConvertedDate = function(date){

        if (date !=null) {
            return new Date(date).toDateString();
        }
        return null;
    }

    ctrl.getConvertedDate = getConvertedDate;
    ctrl.getPickWorkDataByPickList = getPickWorkDataByPickList;


//***************start Allocation*************************************

    var allocate = function(){
            $('#allocationProcess').appendTo("body").modal('show');

    };

    ctrl.allocate = allocate;


    //********************** Start Allocation

    var loadLocationAutoComplete = function () {
        $http.get('/order/getLocations')
            .success(function(data) {
                $scope.loadCompanyLocations= data;
            });
    };

    loadLocationAutoComplete();

    var allocate = function(){
            $('#allocationProcess').appendTo("body").modal('show');

    };

    ctrl.allocate = allocate;

    var saveAllocation = function () {

        if( ctrl.allocationCreateFrom.$valid) {

            $http({
                method  : 'POST',
                url     : '/order/saveLocation',
                params: {location:ctrl.location},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    $('#allocationProcess').modal('hide');

                })

        }
    };

//end allocation
    

//***************End of Allocation *************************************


//***************start shipment search************************************* 
ctrl.findShipment = {};


ctrl.isShipmentSearchVisible = true;
ctrl.shipmentData = [];
//ctrl.findShipment.allocationStatus = 'NONE';

var showHideSearch = function () {
    ctrl.isShipmentSearchVisible = ctrl.isShipmentSearchVisible ? false : true;
};



var shipmentCreationDateRange = function () {
    ctrl.displayShipmentCreationDate = ctrl.shipmentCreationRange
};


var shipmentSearch = function(){
    pickService.shipmentSearch(ctrl.findShipment).then(function(response) {
        ctrl.isShipmentSearchVisible = false;
        ctrl.shipmentData = response;

        if (ctrl.shipmentData.length == 0) {
            $scope.gridPalletPicks.data = [];
            $scope.gridShipmentLines.data = [];
            $scope.gridReplenWork.data = []
            ctrl.shipmentLineDataByOrder = [];
            ctrl.pickWorkData = [];
        }

        else{

            ctrl.selectedShipmentId = response[0].shipment_id;
            ctrl.selectedShipmentStatus = response[0].shipment_status;
            getPalletPicksByShipment(ctrl.selectedShipmentId);
            getAllPickListByShipment(ctrl.selectedShipmentId); 
            getReplenishmentWorkDataByShipment(ctrl.selectedShipmentId);
            getAllShipmentLinesByShipmentId(ctrl.selectedShipmentId);
            getSelectedShipmentDataByShipmentId(ctrl.selectedShipmentId);            

            // if (response[0].shipment_status == 'PLANNED') {
            //     getAllShipmentLinesByShipmentId(ctrl.selectedShipmentId);
            //     getSelectedShipmentDataByShipmentId(ctrl.selectedShipmentId);
            // }



        }
    });
};


var loadGridData = function (){
    $http({
        method: 'POST',
        url: '/picking/searchShipment',
        headers : { 'Content-Type': 'application/json; charset=utf-8' }
    })
        .success(function (data) {
            ctrl.shipmentData = data;
            ctrl.selectedShipmentId = data[0].shipment_id;
            ctrl.selectedShipmentStatus = data[0].shipment_status;
            getPalletPicksByShipment(ctrl.selectedShipmentId);
            getAllPickListByShipment(ctrl.selectedShipmentId);
            getReplenishmentWorkDataByShipment(ctrl.selectedShipmentId);
            getAllShipmentLinesByShipmentId(ctrl.selectedShipmentId);
            getSelectedShipmentDataByShipmentId(ctrl.selectedShipmentId);

        })
};

var urlParams = $location.search();
if (urlParams.shipmentId) {
    ctrl.findShipment.shipmentId = urlParams.shipmentId;
    shipmentSearch();
}
else{
    loadGridData();
};



ctrl.shipmentSearch = shipmentSearch;
ctrl.showHideSearch = showHideSearch;
ctrl.shipmentCreationDateRange = shipmentCreationDateRange;

//***************End shipment search*************************************  

    ctrl.navigateToListPicking = function(pickListId){
        document.location = "/picking/index#?pickListId=" + pickListId
    };

    $scope.gridPalletPicks = {
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
            {name:'Destination Area Id' , field: 'destination_area_id'}, 
            {name:'Destination Location Id' , field: 'destination_location_id'},
            {name:'Source Location Id' , field: 'source_location_id'},
            {name:'Order Number' , field: 'order_number'},
            {name:'Order Line Number' , field: 'order_line_number'},
            {name:'Shipment Line Id' , field: 'shipment_line_id'},
            {name:'Item Id' , field: 'item_id'},
            {name:'Qty' , field: 'pick_quantity'},            
            {name:'Pick Quantity Uom' , field: 'pick_quantity_uom'},
            {name:'Pallet Lpn' , field: 'pallet_lpn'},
            {name:'Pick Status' , field: 'pick_status'}
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


    $scope.gridShipmentLines = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
        exporterPdfHeader: { text: headerTitle1, style: 'headerStyle' },
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
            {name:'Shipment Line Id' , field: 'shipmentLineId'},
            {name:'Order Number' , field: 'orderNumber'},
            {name:'Order Line Number' , field: 'orderLineNumber'},
            {name:'Item Id' , field: 'itemId'},
            {name:'Shipped Uom' , field: 'shippedUOM'},
            {name:'Shipped Quantity' , field: 'shippedQuantity'}
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



    $scope.gridReplenWork = {
        expandableRowTemplate: "<div ui-grid='row.entity.subGridOptions' style='height:150px;'></div>",
        expandableRowHeight: 150,

        enableRowSelection: true,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
        exporterPdfHeader: { text: headerTitle2, style: 'headerStyle' },
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
            {name:'Destination Location Id', field: 'destination_location_id'},
            {name:'Source Location Id', field: 'source_location_id'},
            {name:'UOM', field: 'replen_quantity_uom'},
            {name:'workStatus', field: 'replen_work_status'},
            {name:'Replen Qty', field: 'replen_quantity'}
        ],

        onRegisterApi: function( gridApi ){

            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {
                if (row.isExpanded) {
                    row.entity.subGridOptions = {
                        appScopeProvider: $scope.subGridScope,

                        columnDefs: [
                            {name:'work Reference No', field: 'work_reference_number'},
                            {name:'Pick Qty', field: 'pick_quantity'},
                            {name:'Pick Uom', field: 'pick_quantity_uom'},
                            {name:'Shipment Line', field: 'shipment_line_id'},
                            {name:'Order No', field: 'order_number'},
                            {name:'Order Line Number', field: 'order_line_number'}
                        ]
                    };

                    $http({
                        method: 'GET',
                        url: '/picking/getPickWorkDataByReplenWork',
                        params : {replenReference: row.entity.replen_reference}
                    })
                        .success(function(data) {
                            row.entity.subGridOptions.data = data;
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



 


 //******************End Allocation & picking status************************************



}])
;
