/**
 * Created by User on 2016-02-02.
 */

var app = angular.module('palletPick', ['palletPickReplensService','ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.grid.pagination', 'ui.grid.expandable','dndLists', 'ui.grid.resizeColumns', 'ui.grid.autoResize']);

app.controller('palletPickCtrl', ['$scope', '$http', '$interval', '$q', '$timeout','palletPickService', function ($scope, $http, $interval, $q, $timeout, palletPickService) {

    var myEl = angular.element( document.querySelector( '#liPicking' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulPicking' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'Pallet Picks';
    var headerTitle1 = 'Replenishment';

    var ctrl = this;

    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };

// *****************************START PALLET PICKS************************

    var getAllPalletPick = function(){
        palletPickService.getAllPalletPick().then(function(response) {
            $scope.gridPalletPick.data = response;
        });
    };


    var getCompletedPalletPick = function(){
        if (ctrl.completePallet == true) {
            palletPickService.getCompletedPalletPick().then(function(response) {
                $scope.gridPalletPick.data = response;
            });
        }

        else{
            getAllPalletPick();
        }

    };


    $scope.checkPickWorkStatus = function(row){
        if (row.entity.pickStatus == 'Ready to Pick') {
            return true
        }

        else{
            return false
        }

    };


    $scope.checkCompletedPickWork = function(row){

        if (row.entity.pickStatus == 'Pick Completed') {
            return true
        }

        else{
            return false
        }

    };


    $scope.checkPendingPickWork = function(row){
        if (row.entity.pickStatus == 'Pending Replen') {
            return true
        }

        else{
            return false
        }

    };


    $scope.checkPartiallyPickWork = function(row){
        if (row.entity.pickStatus == 'Partially Picked') {
            return true
        }

        else{
            return false
        }

    };


    $scope.clickPickWork = function(row){
        ctrl.pickWorkReferenceForView = row.entity.workReferenceNumber;
        ctrl.picksourceLocationForView = row.entity.sourceLocationId;
        ctrl.pickdestinationLocationForView = row.entity.destinationLocationId;
        ctrl.pickWorkPickQtyForView = row.entity.pickQuantity;
        ctrl.pickWorkShipmentForView = row.entity.shipmentId;

        ctrl.pickWorkUomForView = row.entity.pickQuantityUom;
        //ctrl.pickWorkPickLevelForView = row.entity.pickLevel;

        if(row.entity.pickLevel = 'P'){
            ctrl.pickWorkPickLevelForView = 'PALLET'
        }
        else if(row.entity.pickLevel = 'C'){
            ctrl.pickWorkPickLevelForView = 'CASE'
        }
        else if(row.entity.pickLevel = 'E'){
            ctrl.pickWorkPickLevelForView = 'EACH'
        }


        //alert(ctrl.pickWorkPickLevelForView);
        //alert(ctrl.pickWorkPalletLpnForView);
        //alert(ctrl.pickWorkUomForView);
        //alert(ctrl.pickWorkPickQtyForView);

        $http({
            method: 'GET',
            url: '/picking/getInventoryByPalletLpn',
            params: {selectedWorkReference: row.entity.workReferenceNumber}

        })
            .success(function(data) {
                ctrl.pickWorkItemForView = data[0].item_id;
                ctrl.pickWorkInventoryStatusForView = data[0].requested_inventory_status;
                //alert(ctrl.pickWorkItemForView);
            });


        ctrl.viewLpn1 = false;
        ctrl.viewConfirmLpn1 = false;
        ctrl.viewDestinationLocation1 = false;
        ctrl.SourceLocationForm1 = true;
        ctrl.lpn = null;
        ctrl.destinationLocationId = null;


        palletPickService.getLpnByLocation(row.entity.sourceLocationId).then(function(response) {
            var info = [];
            if(response.length > 0){

                for (i = 0; i < response.length; i++) {
                    //info += response[i].lPN + ',';
                    info.push(response[i].lPN);

                }
            }
            ctrl.pickWorkPalletLpnForView = info;

        });


        palletPickService.getInventoryByLocation(ctrl.pickdestinationLocationForView).then(function(response) {
            $('#pickWorkView').appendTo("body").modal('show');
            $scope.gridInventory.data = response;
        });


        //pnd location
        $http({
            method: 'GET',
            url: '/picking/getPNDLocationByArea',
            //params: {selectedWorkReference: row.entity.workReferenceNumber}

        })
            .success(function(data) {
                //ctrl.pndLocationForView = data[0].location_id;
                var info = [];
                if(data.length > 0){

                    for (i = 0; i < data.length; i++) {
                        info.push(data[i].location_id);
                    }
                }
                ctrl.pndLocationForView = info;
                //alert(ctrl.pndLocationForView);
            });

    };


    ctrl.SourceLocationForm1 = true;
    ctrl.LpnForm1 = false;
    ctrl.DestinationLocationForm1 = false;

    ctrl.viewSourceLocation1 = true;
    ctrl.viewLpn1 = false;
    ctrl.viewConfirmLpn1 = false;
    ctrl.viewDestinationLocation1 = false;

    ctrl.sourceLocationError1 = false;
    ctrl.palletLpnError1 = false;
    ctrl.destinationLocationError1 = false;

    //start pallet pick grid
    $scope.gridPalletPick = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: true,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,
        rowHeight: 65,

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
            {name:'Destination Area', field: 'destinationAreaId'},
            {name:'Destination Location' , field: 'destinationLocationId'},
            {name:'Source Location', field: 'sourceLocationId'},
            {name:'Order', field: 'orderNumber'},
            {name:'Order Line', field: 'orderLineNumber'},
            {name:'shipment', field: 'shipmentId'},
            {name:'shipment Line', field: 'shipmentLineId'},
            {name:'LPN' , field: 'palletLpn'},
            {name:'Pick Qty' , field: 'pickQuantity'},
            {name:'Actions', width:130,enableFiltering: false, cellClass: 'grid-align',cellTemplate: '<button ng-if="grid.appScope.checkPickWorkStatus(row)" class="btn btn-xs btn-primary confrmaPalPickBtn" style="padding: 0px 10px !important; margin: 10px 10px 0px 10px;"  ng-click="grid.appScope.clickPickWork(row)">Confirm</button>'+
            '<span ng-if="grid.appScope.checkCompletedPickWork(row)" style="color: green;">Completed</span>'+
            '<span ng-if="grid.appScope.checkPendingPickWork(row)" style="color: orange;">Pending</span>'+
            '<span ng-if="grid.appScope.checkPartiallyPickWork(row)" style="color: red;">Partially Picked</span>'}
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

    //end of pallet pick grid


    //check Pick Work status

    var checkPickWorkStatus = function () {
        $http({
            method: 'GET',
            url: '/picking/getInventoryByLpn',
            params: {selectedLpn: ctrl.lpn}

        })
            .success(function(data) {
                ctrl.levelForView = data[0].level;
                ctrl.locationIdForView =data[0].location_id;

            });


        $http({
            method: 'GET',
            url: '/picking/getInventoryByAssociateLpn',
            params: {selectedAssociateLpn: ctrl.lpn}

        })
            .success(function(data) {
                ctrl.itemIdForView = data[0].item_id;
                ctrl.inventoryStatusForView = data[0].inventory_status;
                ctrl.associatedLpnForView = data[0].associated_lpn;
                ctrl.quantityForView = data[0].quantity;
                ctrl.handlingUomForView = data[0].handling_uom;

            });

    };

    ctrl.checkPickWorkStatus = checkPickWorkStatus;


    //start form1
    var confirmSourceLocationButton1 = function () {

        if(ctrl.confirmSourceLocationForm1.$valid) {
  
            if (ctrl.sourceLocationId == ctrl.picksourceLocationForView) {
                ctrl.SourceLocationForm1 = false;
                ctrl.LpnForm1 = true;
            }
            else {
                ctrl.sourceLocationError1 = true;
                $timeout(function(){
                    ctrl.sourceLocationError1 = false;
                }, 2000);
            }

            //ctrl.sourceLocationId = null;

        }

    };

    ctrl.confirmSourceLocationButton1 = confirmSourceLocationButton1;


    //start form2
    var confirmLpnButton1 = function () {
        if( ctrl.confirmLpnForm1.$valid) {

            checkPickWorkStatus();

            palletPickService.checkPickWork(ctrl.pickWorkReferenceForView).then(function (response) {
                ctrl.newPickWorkStatus = response.pickStatus;

                if (ctrl.newPickWorkStatus == 'Ready to Pick') {
                    palletPickService.confirmPalletLpnForPickWork(ctrl.pickWorkReferenceForView, ctrl.lpn,
                        ctrl.pickWorkPickLevelForView, ctrl.picksourceLocationForView, ctrl.pickWorkItemForView,
                        ctrl.pickWorkInventoryStatusForView, ctrl.pickWorkPickQtyForView, ctrl.pickWorkUomForView).then(function (response) {

                            if(response.confirmedResult == true){
                                ctrl.viewDestinationLocation1 = true;
                                ctrl.DestinationLocationForm1 = true;
                                ctrl.LpnForm1 = false;
                                ctrl.viewConfirmLpn1 = true;
                                ctrl.confirmPickWorkLpn = ctrl.lpn;
                            }

                            else{
                                //ctrl.palletLpnError1 = true;
                                ctrl.palletLpnError1 = response.error;
                                $timeout(function(){
                                    ctrl.palletLpnError1 = false;
                                }, 2000);
                            }

                            //palletPickService.checkPickWork(ctrl.pickWorkReferenceForView).then(function (response) {
                            //
                            //});


                        });
                }

                else {
                    $('#ConfirmWarningForPick').appendTo("body").modal('show');
                }

            });

        }
    };

    ctrl.confirmLpnButton1 = confirmLpnButton1;


    //start form3
    var confirmDestinationLocationButton1 = function () {
        if( ctrl.confirmDestinationLocationForm1.$valid) {

            if(ctrl.destinationLocationId == ctrl.pickdestinationLocationForView || ctrl.pndLocationForView.indexOf(ctrl.destinationLocationId) > -1 ){

                palletPickService.confirmDestinationLocationForPickWork(ctrl.pickWorkReferenceForView, ctrl.lpn, ctrl.pickdestinationLocationForView, ctrl.pickWorkShipmentForView).then(function(response) {
                    ctrl.DestinationLocationForm1 = false;

                    ctrl.viewSourceLocation1 = true;
                    ctrl.viewConfirmLpn1 = true;
                    ctrl.viewDestinationLocation1 = true;

                    //$('#pickWorkView').appendTo("body").modal('hide');

                    ctrl.showSubmittedDestinationLocationPrompt = true;

                    $timeout(function(){
                        ctrl.showSubmittedDestinationLocationPrompt = false;
                    }, 5200);


                    getAllPalletPick();
                    ctrl.destinationLocationId = null;
                });

            }
            else {
                ctrl.destinationLocationError1 = true;
                $timeout(function(){
                    ctrl.destinationLocationError1 = false;
                }, 2000);
            }
        }
    };

    ctrl.confirmDestinationLocationButton1 = confirmDestinationLocationButton1;


    //top close button for pick work
    $("#closeButton1").click(function(){
        $('#pickWorkView').appendTo("body").modal('hide');
        getAllPalletPick();
    });

    // ***********************END PALLET PICKS************************ ** ******


    // *****************************START REPLENS WORK************************

    var getAllReplens = function(){
        palletPickService.getAllReplens().then(function(response) {
            $scope.gridReplens.data = response;
        });
    };

    var getCompletedReplens = function(){
        palletPickService.getCompletedReplens().then(function(response) {
            $scope.gridReplens.data = response;
        });
    };

    var getExpiredReplens = function(){
        palletPickService.getExpiredReplens().then(function(response) {
            $scope.gridReplens.data = response;
        });
    };

    var getCompletedAndExpiredReplens = function(){
        palletPickService.getCompletedAndExpiredReplens().then(function(response) {
            $scope.gridReplens.data = response;
        });
    };


    //check box function
    var checkBoxFunction = function () {

        if (ctrl.completeReplens == true && ctrl.expiredReplens == true) {
            getCompletedAndExpiredReplens();
        }
        if (ctrl.completeReplens == false && ctrl.expiredReplens == false) {
            getAllReplens();
        }

        if (ctrl.completeReplens == true && ctrl.expiredReplens == false) {
            getCompletedReplens();
        }

        if (ctrl.completeReplens == false && ctrl.expiredReplens == true) {
            getExpiredReplens();
        }
    };


    ctrl.checkBoxFunction = checkBoxFunction;

    getAllPalletPick();
    ctrl.getCompletedPalletPick = getCompletedPalletPick;
    ctrl.completePallet = false;

    getAllReplens();
    ctrl.getCompletedReplens = getCompletedReplens;
    ctrl.getExpiredReplens = getExpiredReplens;
    ctrl.getCompletedAndExpiredReplens = getCompletedAndExpiredReplens;
    ctrl.completeReplens = false;
    ctrl.expiredReplens = false;


    // start replens grid action columns

    //get current login user
    palletPickService.checkCurrentUser().then(function(response) {
        ctrl.loginUser = response.username;
    });


    $scope.checkReplensCompletedState = function(row){

        if (row.entity.replenWorkStatus == 'S') {
            return true
        }

        else{
            return false
        }

    };

    $scope.checkReplensExpiredState = function(row){

        if (row.entity.replenWorkStatus == 'E') {
            return true
        }

        else{
            return false
        }

    };

    $scope.checkReplensActiveState = function(row){

        if (row.entity.replenWorkStatus == 'A') {
            return true
        }

        else{
            return false
        }

    };

    $scope.checkReplensInProgressState = function(row){

        if (row.entity.replenWorkStatus == 'I' && row.entity.assigningUserId != ctrl.loginUser) {
            return true
        }

        else{
            return false
        }

    };

    $scope.checkConfirmUser = function(row){

        if (row.entity.replenWorkStatus =='I' && row.entity.assigningUserId == ctrl.loginUser) {
            return true
        }

        else {
            return false
        }

    };

// end replens grid action columns


//start replens grid
    $scope.gridReplens = {

        expandableRowTemplate: "<div ui-grid='row.entity.subGridOptions' style='height:150px;'></div>",
        expandableRowHeight: 150,

        rowHeight: 65,
        enableRowSelection: true,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: true,
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
            {name:'Item', field: 'itemId'},
            {name:'Replens From Location' , field: 'destinationLocationId'},
            {name:'Replens To Location', field: 'sourceLocationId'},
            {name:'LPN' , field: 'lpn'},
            {name:'Work Status', field: 'replenWorkStatus'},
            {name:'Replens Qty', field: 'replenQuantity'},
            {name:'UOM', field: 'replenQuantityUom'},
            {name:'Inventory Status', field: 'replenInventoryStatus'},
            {name:'Actions', width:130,enableFiltering: false,cellClass: 'grid-align',cellTemplate: '<button ng-if="grid.appScope.checkReplensActiveState(row)" class="btn btn-xs btn-primary" style="padding: 0px 10px !important; margin: 10px 10px 0px 10px;"  ng-click="grid.appScope.clickMeSub(row)">Confirm</button>' +
            '<span ng-if="grid.appScope.checkReplensInProgressState(row)" style="color: orange;">In Progress By {{row.entity.assigningUserId}} </span>' +
            '<button ng-if="grid.appScope.checkConfirmUser(row)" class="btn btn-xs btn-primary" style="padding: 0px 10px !important; margin: 10px 10px 0px 10px;"  ng-click="grid.appScope.clickMeSub(row)">Continue Work</button>'+
            '<span ng-if="grid.appScope.checkReplensCompletedState(row)" style="color: green;">Completed</span>'+
            '<span ng-if="grid.appScope.checkReplensExpiredState(row)" style="color: red;">Expired</span>'}

        ],

        onRegisterApi: function( gridApi ){

            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {
                if (row.isExpanded) {

                    row.entity.subGridOptions = {
                        columnDefs: [
                            {name:'Associated Pick Work', field: 'work_reference_number'},
                            {name:'Pick Qty', field: 'pick_quantity'},
                            {name:'Pick UOM', field: 'pick_quantity_uom'},
                            {name:'Shipment', field: 'shipment_id'},
                            {name:'Shipment Line', field: 'shipment_line_id'}
                        ]};

                    $http({
                        method: 'GET',
                        url: '/picking/findPickWorks',
                        params : {selectedRowPick: row.entity.replenReference}
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

//end of replens grid

    // *****************************START REPLENS WORK************************

    //*********************************START REPLENS WORK POPUP*********************************

    var disableFindButton = function () {
        ctrl.disabledFind = ctrl.sourceLocationId ? false : true;
    };

    ctrl.disabledFind = true;
    ctrl.disableFindButton = disableFindButton;



    var disableFindButton1 = function () {
        ctrl.disabledFind1 = ctrl.lpn ? false : true;
    };

    ctrl.disabledFind1 = true;
    ctrl.disableFindButton1 = disableFindButton1;



    var disableFindButton2 = function () {
        ctrl.disabledFind2 = ctrl.destinationLocationId ? false : true;
    };

    ctrl.disabledFind2 = true;
    ctrl.disableFindButton2 = disableFindButton2;


    var disableFindButton3 = function () {
        ctrl.disabledFind3 = ctrl.caseLpn ? false : true;
    };

    ctrl.disabledFind3 = true;
    ctrl.disableFindButton3 = disableFindButton3;



    var disableFindButton4 = function () {
        ctrl.disabledFind4 = ctrl.qty ? false : true;
    };

    ctrl.disabledFind4 = true;
    ctrl.disableFindButton4 = disableFindButton4;



    $scope.clickMeSub = function(row){
        ctrl.replenReferenceForView = row.entity.replenReference;
        ctrl.sourceLocationForView = row.entity.sourceLocationId;
        ctrl.destinationLocationForView = row.entity.destinationLocationId;
        ctrl.replenWorkStatusForView = row.entity.replenWorkStatus;
        ctrl.assigningUserIdForView = row.entity.assigningUserId;
        ctrl.palletLpnForView1 = row.entity.lpn;
        ctrl.itemForView = row.entity.itemId;
        ctrl.replensUomForView = row.entity.replenQuantityUom;
        ctrl.replensQtyForView = row.entity.replenQuantity;

        ctrl.viewConfirmCaseLpn = false;
        ctrl.viewConfirmQty = false;


        //pick work
        palletPickService.getPickWork(row.entity.replenReference).then(function(response) {

            //ctrl.pickWorkForView =response[0].work_reference_number;
            var info = [];
            if(response.length > 0){

                for (i = 0; i < response.length; i++) {
                    info.push(response[i].work_reference_number);

                }
            }
            ctrl.pickWorkForView = info;
        });
        //


        if(ctrl.replenWorkStatusForView == 'I'){

            ctrl.palletLpnForView = row.entity.lpn;
            ctrl.confirmReplenLpn = row.entity.lpn;

            palletPickService.getInventoryByLocation(row.entity.destinationLocationId).then(function(response) {

                ctrl.SourceLocationForm = false;
                ctrl.LpnForm = false;
                ctrl.DestinationLocationForm = true;

                ctrl.viewSourceLocation = true;
                ctrl.viewLpn = true;
                ctrl.viewConfirmLpn = true;
                ctrl.viewDestinationLocation = true;

                $('#replensView').appendTo("body").modal('show');
                $scope.gridInventory.data = response;
            });

        }

        else if(ctrl.replenWorkStatusForView == 'A'){
            palletPickService.getInventoryByLocation(row.entity.destinationLocationId).then(function(response) {

                ctrl.SourceLocationForm = true;
                ctrl.LpnForm = false;
                ctrl.DestinationLocationForm = false;

                ctrl.viewSourceLocation = true;
                ctrl.viewLpn = false;
                ctrl.viewConfirmLpn = false;
                ctrl.viewDestinationLocation = false;

                $('#replensView').appendTo("body").modal('show');
                $scope.gridInventory.data = response;
            });


            palletPickService.getLpnByLocation(row.entity.sourceLocationId).then(function(response) {
                var info = "";
                if(response.length > 0){

                    for (i = 0; i < response.length; i++) {
                        info += response[i].lPN + ',';

                    }
                }
                ctrl.palletLpnForView = info;

            });


            palletPickService.getCaseLpnByLocation(row.entity.sourceLocationId).then(function(response) {
                var info = "";
                if(response.length > 0){

                    for (i = 0; i < response.length; i++) {
                        info += response[i].lpn + ',';

                    }
                }
                ctrl.caseLpnForView = info;

            });


        }

    };


//Start Inventory grid
    $scope.gridInventory = {
        expandableRowTemplate: "<div ui-grid='row.entity.subGridOptions' style='height:150px;'></div>",
        expandableRowHeight: 150,

        enableRowSelection: true,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,
        columnDefs: [
            {name:'Location', field: 'grid_location_id'},
            {name:'Pallet Id', field: 'grid_pallet_id'},
            {name:'Case Id', field: 'grid_case_id'},
            {name:'Item Id', field: 'grid_item_id'},
            {name:'Description', field: 'grid_item_description'},
            {name:'Quantity', field: 'grid_quantity'},
            {name:'Unit Of Measure', field: 'grid_handling_uom'}

        ],
        onRegisterApi: function( gridApi ){
            $scope.gridApi = gridApi;

            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {

                if (row.isExpanded) {
                    row.entity.subGridOptions = {

                        columnDefs: [
                            {name:'Case Id', field: 'case_id'},
                            {name: 'Item Id 1', cellTemplate:'<a href="#" data-toggle="tooltip" title="Item: {{ row.entity.item_id}} \n Description: {{row.entity.item_description}} \n Category: {{row.entity.item_category}} \n Origin Code: {{row.entity.origin_code}} \n UPC Code: {{row.entity.upc_code}}"> {{row.entity.item_id}}</a>'},
                            {name:'Quantity', field: 'quantity'},
                            {name:'Unit Of Measure', field: 'handling_uom'}
                        ]};

                    $http({
                        method: 'GET',
                        url: '/inventory/getInventoryEntityAttributeForSearchRow',
                        params : {selectedRowPallet: row.entity.grid_pallet_id}
                    })
                        .success(function(data) {

                            if(data.length > 0){
                                row.entity.subGridOptions.data = data;
                            }

                        });

                }
            });

            $interval( function() {
                gridApi.core.addToGridMenu( gridApi.grid, [{ title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged( $scope, function( changedColumn ){
                $scope.columnChanged = { name: changedColumn.colDef.name, visible: changedColumn.colDef.visible };
            });
        }
    };

    //End Inventory grid

    ctrl.SourceLocationForm = true;
    ctrl.LpnForm = false;
    ctrl.CheckCaseLevelForm = false;
    ctrl.CaseLpnForm = false;
    ctrl.QtyForm = false;
    ctrl.DestinationLocationForm = false;

    ctrl.viewSourceLocation = true;
    ctrl.viewLpn = false;
    ctrl.viewConfirmLpn = false;
    ctrl.viewCaseLpn = false;
    ctrl.viewConfirmCaseLpn = false;
    ctrl.viewConfirmQty = false;
    ctrl.viewDestinationLocation = false;

    ctrl.sourceLocationError = false;
    ctrl.palletLpnError = false;
    ctrl.caseLpnError = false;
    ctrl.qtyError = false;
    ctrl.destinationLocationError = false;


    //check Replens Work status
    var checkStatus = function () {

        palletPickService.checkReplensStatus(ctrl.replenReferenceForView).then(function (response) {
            ctrl.newReplenWorkStatus = response.replenWorkStatus;

            if (ctrl.newReplenWorkStatus == 'A') {
                palletPickService.confirmLpn(ctrl.replenReferenceForView, ctrl.lpn).then(function (response) {

                    palletPickService.checkReplensStatus(ctrl.replenReferenceForView).then(function (response) {

                    });

                    ctrl.CaseLpnForm = false;
                    ctrl.DestinationLocationForm = true;
                    ctrl.viewDestinationLocation = true;

                    ctrl.lpn = null;
                    ctrl.caseLpn = null;
                    ctrl.qty = null;

                });
            }

            else {
                $('#ConfirmWarning').appendTo("body").modal('show');
            }

        });

    };

    ctrl.checkStatus = checkStatus;


    //check Replens Work status
    var checkStatusForCase = function () {

        palletPickService.checkReplensStatus(ctrl.replenReferenceForView).then(function (response) {
            ctrl.newReplenWorkStatus = response.replenWorkStatus;

            if (ctrl.newReplenWorkStatus == 'A') {
                palletPickService.confirmLpn(ctrl.replenReferenceForView, ctrl.caseLpn).then(function (response) {

                    palletPickService.checkReplensStatus(ctrl.replenReferenceForView).then(function (response) {

                    });

                    ctrl.CaseLpnForm = false;
                    ctrl.DestinationLocationForm = true;
                    ctrl.viewDestinationLocation = true;

                    ctrl.caseLpn = null;
                    ctrl.qty = null;
                });
            }

            else {
                $('#ConfirmWarning').appendTo("body").modal('show');
            }

        });

    };

    ctrl.checkStatusForCase = checkStatusForCase;



    //start form1
    var confirmSourceLocationButton = function () {

        if(ctrl.confirmSourceLocationForm.$valid) {

            if (ctrl.sourceLocationId == ctrl.sourceLocationForView) {

                ctrl.SourceLocationForm = false;
                ctrl.LpnForm = true;
                ctrl.CheckCaseLevelForm = true;

                ctrl.viewSourceLocation = true;
                ctrl.viewLpn = true;
                ctrl.viewConfirmLpn = false;
                ctrl.viewDestinationLocation = false;

            }
            else {
                ctrl.sourceLocationError = true;
                $timeout(function(){
                    ctrl.sourceLocationError = false;
                }, 2000);
            }

            ctrl.sourceLocationId = null;

        }

    };

    ctrl.confirmSourceLocationButton = confirmSourceLocationButton;



    //start form2
    var confirmLpnButton = function () {
        if( ctrl.confirmLpnForm.$valid) {

            if( ctrl.palletLpnForView.indexOf(ctrl.lpn) > -1 ){

                palletPickService.checkReplensStatus(ctrl.replenReferenceForView).then(function (response) {
                    ctrl.level = response.replenWorkLevel;

                    if(ctrl.level == 'PALLET'){
                        ctrl.viewDestinationLocation = true;
                        ctrl.DestinationLocationForm = true;
                        ctrl.LpnForm = false;
                        ctrl.CheckCaseLevelForm = false;
                        ctrl.viewConfirmLpn = true;
                        checkStatus();
                        ctrl.confirmReplenLpn = ctrl.lpn;
                    }

                    else if(ctrl.level != 'PALLET'){

                        palletPickService.findSelectedItem(ctrl.itemForView).then(function(response) {
                            ctrl.isCaseTracked = response.isCaseTracked;

                            if(ctrl.isCaseTracked == true){
                                ctrl.CaseLpnForm = true;
                                ctrl.LpnForm = false;
                                ctrl.CheckCaseLevelForm = false;

                                ctrl.viewSourceLocation = true;
                                ctrl.viewConfirmLpn = true;
                                ctrl.viewCaseLpn = true;
                            }
                            else if(ctrl.isCaseTracked == false){
                                ctrl.QtyForm = true;
                                ctrl.LpnForm = false;
                                ctrl.CheckCaseLevelForm = false;

                                ctrl.viewSourceLocation = true;
                                ctrl.viewConfirmLpn = true;
                            }
                        });

                        ctrl.confirmReplenLpn = ctrl.lpn;
                    }

                });

            }

            else{
                ctrl.palletLpnError = true;
                $timeout(function(){
                    ctrl.palletLpnError = false;
                }, 2000);
            }

        }
    };

    ctrl.confirmLpnButton = confirmLpnButton;


    //start check box function
    var CheckCaseLevel = function () {
        if (ctrl.caseLevel == true) {

            palletPickService.findSelectedItem(ctrl.itemForView).then(function(response) {
                ctrl.isCaseTracked = response.isCaseTracked;

                if(ctrl.isCaseTracked == true){

                    palletPickService.getLpnByLocationForCases(ctrl.sourceLocationForView).then(function(response) {

                        var info = "";
                        if(response.length > 0){

                            for (i = 0; i < response.length; i++) {
                                info += response[i].lPN + ',';

                            }
                        }
                        ctrl.caseLpnForView = info;

                        ctrl.CaseLpnForm = true;
                        ctrl.LpnForm = false;
                        ctrl.CheckCaseLevelForm = false;

                        ctrl.viewSourceLocation = true;
                        ctrl.viewConfirmLpn = false;
                        ctrl.viewCaseLpn = true;

                    });

                }
                else if(ctrl.isCaseTracked == false){
                    ctrl.QtyForm = true;
                    ctrl.LpnForm = false;
                    ctrl.CheckCaseLevelForm = false;

                    ctrl.viewSourceLocation = true;
                    ctrl.viewConfirmLpn = false;
                }
            });


        }

        if (ctrl.caseLevel == false) {
            ctrl.CaseLpnForm = false;
            ctrl.QtyForm = false;
            ctrl.LpnForm = true;
        }

    };

    ctrl.CheckCaseLevel = CheckCaseLevel;


    //start form2-1
    var confirmCaseLpnButton = function () {
        if( ctrl.confirmCaseLpnForm.$valid) {

            if( ctrl.caseLpnForView.indexOf(ctrl.caseLpn) > -1 ){

                palletPickService.getInventoryByAssociateLpn(ctrl.caseLpn).then(function (response) {
                    ctrl.pickItem = response.itemId;
                    ctrl.pickUom = response.handlingUom;
                    ctrl.pickQty = response.quantity;

                    if (ctrl.pickItem == ctrl.itemForView && ctrl.pickUom == ctrl.replensUomForView && ctrl.pickQty == ctrl.replensQtyForView ) {

                        if (ctrl.caseLevel == true) {
                            checkStatusForCase();
                            ctrl.viewConfirmCaseLpn = true;
                        }
                        else {
                            palletPickService.checkReplensStatus(ctrl.replenReferenceForView).then(function (response) {
                                ctrl.level = response.replenWorkLevel;

                                if(ctrl.level != 'PALLET'){
                                    checkStatusForCase();
                                    ctrl.viewConfirmCaseLpn = true;
                                }

                                else{
                                    checkStatus();
                                    ctrl.viewConfirmCaseLpn = true;
                                }

                            });

                        }

                        ctrl.confirmCaseLpn = ctrl.caseLpn;


                    }
                    else{
                        $('#ConfirmCaseLpnWarning').appendTo("body").modal('show');
                    }

                });

            }
            else{
                ctrl.caseLpnError = true;
                $timeout(function(){
                    ctrl.caseLpnError = false;
                }, 2000);
            }

        }
    };

    ctrl.confirmCaseLpnButton = confirmCaseLpnButton;



    //start form2-2
    var confirmQtyButton = function () {
        if( ctrl.confirmQtyForm.$valid) {

            palletPickService.getInventoryByAssociateLpn(ctrl.lpn).then(function (response) {
                ctrl.qtyForView = response.quantity;

                if(ctrl.qty == ctrl.qtyForView){
                    checkStatus();
                    ctrl.viewConfirmQty = true;
                    ctrl.confirmQty = ctrl.qty;
                    ctrl.QtyForm = false;
                }
                else{
                    ctrl.qtyError = true;
                    $timeout(function(){
                        ctrl.qtyError = false;
                    }, 2000);
                }

            });

        }
    };

    ctrl.confirmQtyButton = confirmQtyButton;



    //start form3
    var confirmDestinationLocationButton = function () {
        if( ctrl.confirmDestinationLocationForm.$valid) {

            if (ctrl.destinationLocationId == ctrl.destinationLocationForView) {

                palletPickService.checkReplensStatus(ctrl.replenReferenceForView).then(function(response) {
                    ctrl.newReplenLpn = response.lpn;

                    palletPickService.confirmDestinationLocation(ctrl.replenReferenceForView, ctrl.newReplenLpn, ctrl.destinationLocationId, ctrl.pickWorkForView).then(function(response) {

                        ctrl.DestinationLocationForm = false;

                        ctrl.viewSourceLocation = true;
                        ctrl.viewLpn = true;
                        ctrl.viewConfirmLpn = true;
                        ctrl.viewDestinationLocation = true;

                        $('#replensView').appendTo("body").modal('hide');
                        getAllReplens();
                        //getAllPalletPick();
                        //ctrl.destinationLocationId = null;
                    });
                });

            }
            else {
                ctrl.destinationLocationError = true;
                $timeout(function(){
                    ctrl.destinationLocationError = false;
                }, 2000);
            }
        }
    };

    ctrl.confirmDestinationLocationButton = confirmDestinationLocationButton;



    //top close button for Replens
    $("#closeButton").click(function(){ //function to delete.
        $('#replensView').appendTo("body").modal('hide');
        getAllReplens();
    });


//******************************END OF REPLENS WORK POPUP*******************************

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