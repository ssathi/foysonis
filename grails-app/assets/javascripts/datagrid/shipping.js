/**
 * Created by User on 2016-03-31.
 */

var app = angular.module('shipping', ['shippingService', 'ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ui.grid.autoResize', 'ui.grid.expandable','ui.grid.pagination', 'ui.grid.resizeColumns', 'ui.grid.autoResize', 'ui.bootstrap']);

app.controller('shippingCtrl', ['$scope', '$http', '$interval', '$q', '$timeout','shipService', function ($scope, $http, $interval, $q, $timeout, shipService) {

    var myEl = angular.element( document.querySelector( '#liShipping' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulShipping' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var ctrl = this;

    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };

    var headerTitle = 'Active Shipments';
    var headerTitle1 = 'Active Trucks';

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
    getAllListValueCarrierCode();

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
    //***************start active shipment tab*************************************
    ctrl.isOrderSearchVisible = true;

    var showHideSearch = function () {
        //clearForm();
        ctrl.isOrderSearchVisible = ctrl.isOrderSearchVisible ? false : true;
    };


    var showCompletedDateRange = function () {
        ctrl.displayCompletedDateRange = ctrl.completedDateRange;
    };


    //visible  edit action
    $scope.checkEdit = function(row) {
        if (row.entity.shipment_status == 'COMPLETED') {
            return false
        }

        else{
            return true
        }

    };


    //visible  complete action
    $scope.checkComplete = function(row) {
        if (row.entity.is_parcel == true && row.entity.shipment_status == 'STAGED') {
            return true
        }

        else{
            return false
        }

    };

    //visible load action
    $scope.checkLoad = function(row) {
        if (row.entity.is_parcel == false && row.entity.shipment_status == 'STAGED') {
            return true
        }

        else{
            return false
        }

    };

    $scope.checkEasyPost = function(row){
        if (row.entity.carrier_code_option_value) {
            if (row.entity.carrier_code_option_value.includes("-EasyPost") && row.entity.shipment_status == "STAGED" && row.entity.easy_post_manifested != true) {
                return true
            }
            else{
                return false 
            }
        }
        else{
            return false
        }
    }

    $scope.checkEasyPostVoidAction = function(row){
        if (row.entity.easy_post_manifested == true) {
            return true
        }
        else{
            return false 
        }
    }    

    $scope.EasyPostManifest = function(row){
        //ctrl.shippingRow = row;
        ctrl.ePMAnifestData = row.entity;
        ctrl.packageWeightForEasyPost = row.entity.actual_weight;
        $('#packageWeightModel').appendTo("body").modal('show');
    }


    $scope.EasyPostVoid = function(row){
        ctrl.easyPostRefundErrorMsg = '';

        $http({
            method: 'POST',
            url: '/easyPost/easyPostRefund',
            params: {easyPostShipmentId:row.entity.easy_post_shipment_id, systemShipmentId:row.entity.shipment_id},
            
        })
        .success(function (data) {
            if (data.isSuccess == true) {
                search();  
                ctrl.showEasyPostVoidPrompt = true;
                $timeout(function(){
                    ctrl.showEasyPostVoidPrompt = false;
                }, 5000);                 
            }
            else{
                ctrl.easyPostRefundErrorMsg = data.message;
                $('#easyPostVoidFail').appendTo("body").modal('show');
            }         
        })    
    }

    $scope.EasyPostLabelInPdf = function(row){
        //ctrl.easyPostLabelUrl = row.entity.easy_post_label;
        document.getElementById("easyPostPdfReport").setAttribute("src", row.entity.easy_post_label);
        $("#viewEPostLabelModel").appendTo("body").modal("show");

    };

    ctrl.ePManifestText = 'Confirm'; 
    ctrl.disablemanifestBtn = false;   
    ctrl.updateEasyPostWeight = function(){
        ctrl.easyPostErrorMsg = '';
        ctrl.easyPostError = false;
        if (ctrl.updateEasyPostWeightForm.$valid) {
            ctrl.disablemanifestBtn = true;
            ctrl.ePManifestText = 'Manifesting...';            
            $http({
                method: 'POST',
                url: '/easyPost/performEasyPostCall',
                params: {shippingAddressId:ctrl.ePMAnifestData.shipping_address_id,
                    carrierCode:ctrl.ePMAnifestData.carrier_code_option_value,
                    serviceLevel:ctrl.ePMAnifestData.service_level,
                    easyPostWeight:ctrl.packageWeightForEasyPost,shipmentId:ctrl.ePMAnifestData.shipment_id},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
                
            })
            .success(function (data) {
                if (data.isSuccess) {
                    $http({
                        method: 'POST',
                        url: '/shipping/updateShipmentWithEasyPostData',
                        params: {shipmentId:ctrl.ePMAnifestData.shipment_id, easyPostLabel:data.easypost_label,
                            easyPostShipmentId:data.easyPostShipmentId, easyPostManifested:data.easyPostManifested,
                            trackingCode: data.trackingCode },
                        dataType: 'json',
                        headers : { 'Content-Type': 'application/json; charset=utf-8' }
                        
                    })
                    .success(function (data) {
                        search();
                        $('#packageWeightModel').modal('hide');
                        ctrl.showEasyPostManifestedPrompt = true;
                        $timeout(function(){
                            ctrl.showEasyPostManifestedPrompt = false;
                        }, 5000);
                    })                    
                    
                }
                else{
                    ctrl.easyPostError = true;
                    ctrl.easyPostErrorMsg = data.message;
                    $('#packageWeightModel').modal('hide');
                    $('#easyPostErrorModal').appendTo("body").modal('show');
                }
            })
            .finally(function () {
              ctrl.disablemanifestBtn = false;
              ctrl.ePManifestText = 'Confirm';
            }); 

       }
    }

    //pickwork and shipmentqty pop up
    $scope.subGridScope = {
        clickMeSub: function(row){
            ctrl.viewGrid = true;
            shipService.getPickWork(row.entity.shipmentLineId).then(function(response) {
                $('#pickWorkView').appendTo("body").modal('show');
                    $scope.gridPickWork.data = response;
                });

        },

        checkQty: function(row) {
            if(ctrl.displayCompletedDateRange == true){
                return false
            }
            else{
                return true
            }

        },

        shipmentQty: function(row){
            ctrl.shipmentIdForEdit = row.entity.shipmentId;
            ctrl.shipmentLineIdForEdit = row.entity.shipmentLineId;

            ctrl.shippedQtyError = false;

            $('#shipmentLineQty').appendTo("body").modal('show');

        },

        loadInventory: function(row){
            ctrl.showNoOfLabelField = false;
            ctrl.shipmentIdForEdit = row.entity.shipmentId;
            ctrl.shipmentLineIdForEdit = row.entity.shipmentLineId;
            if (row.entity.company_id == 'HDWNINT' || row.entity.company_id == 'HDWNODY') {
                ctrl.showNoOfLabelField = true;
            }

            $('#loadShipmentLine').appendTo("body").modal('show');

        },


        viewInventory: function(row){
            ctrl.viewInventoryGrid = true;

            if(ctrl.displayCompletedDateRange == true){
                shipService.getShippedInventory(row.entity.shipmentLineId).then(function(response) {
                    $('#inventoryView').appendTo("body").modal('show');
                    $scope.gridInventory.data = response;
                });
            }
            else{
                shipService.getInventory(row.entity.shipmentLineId).then(function(response) {
                    $('#inventoryView').appendTo("body").modal('show');
                    $scope.gridInventory.data = response;
                });
            }


        },


    };

    //end pick work pop up


    //Find Shipment
    var search = function () {
        if (ctrl.searchForm.$valid) {

            $http({
                method: 'POST',
                url: '/shipping/shipmentSearch',
                params: {orderNumber:ctrl.orderNumber,
                    shipmentId:ctrl.shipmentId,
                    truckNumber:ctrl.truckNumber,
                    smallPackage:ctrl.smallPackage,
                    completedDateRange:ctrl.completedDateRange,
                    completedDate:ctrl.completedDate,
                    kittingOrderNumber:ctrl.kittingOrderNumber},
                data    :  $scope.ctrl,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    ctrl.isOrderSearchVisible = false;
                    $scope.gridShipment.data = data;
                    //$scope.gridShipment.data = data.splice(0,1000);

                })
       }
    };

    ctrl.search = search;
    ctrl.showHideSearch = showHideSearch;
    ctrl.showCompletedDateRange = showCompletedDateRange;


    var loadGridData = function (){
        $http({
            method: 'POST',
            url: '/shipping/shipmentSearch',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridShipment.data = data.splice(0,10000);

            })
    };
    loadGridData();


    //start Shipment grid
    $scope.gridShipment = {
        expandableRowTemplate: "<div ui-grid='row.entity.subGridOptions' style='height:230px;'></div>",
        expandableRowHeight: 230,
        enableRowSelection: true,
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
            {name:'Order No.' , field: 'order_number'},
            {name:'Shipment ID', field: 'shipment_id'},
            {name:'Truck No.', field: 'truck_number'},
            {name:'Shipment Status' , field: 'shipment_status'},
            //{name:'Small Package', field: 'is_parcel', type: 'boolean',
            //    cellClass: 'grid-align',cellTemplate: '<input type="checkbox" disabled ng-model="row.entity.is_parcel">'},

            {name:'Small Package', field: 'is_parcel', type: 'boolean',
                cellClass: 'grid-align',cellTemplate: '<div class="gridCheckbox c-checkbox"><input type="checkbox"  ng-model="row.entity.is_parcel"><span class="fa fa-check"></span></div class>'},

            {name:'Carrier Code', field: 'carrier_code'},
            {name:'Service Level' , field: 'service_level'},
            {name:'Tracking No' , field: 'tracking_no'},
            {name:'Actions', enableSorting: false,
                 cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu">' +
            '<li ng-if="grid.appScope.checkEdit(row)"><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li>' +
                 '<li ng-if="grid.appScope.checkComplete(row)"><a href="javascript:void(0);" ng-click="grid.appScope.Complete(row)">Complete</a></li>' +
                 '<li ng-if="grid.appScope.checkLoad(row)"><a href="javascript:void(0);" ng-click="grid.appScope.Load(row)">Load</a></li>' +
            '<li ng-if="!grid.appScope.checkEdit(row)"><a href="javascript:void(0);" ng-click="grid.appScope.VoidSelect(row)">Void</a></li>' +
            '<li ng-if="grid.appScope.checkEasyPost(row)"><a href="javascript:void(0);" ng-click="grid.appScope.EasyPostManifest(row)">EasyPost Manifest</a></li>' +
            '<li ng-if="grid.appScope.checkEasyPostVoidAction(row)"><a href="javascript:void(0);" ng-click="grid.appScope.EasyPostVoid(row)">Void EasyPost</a></li>' +
            '<li ng-if="grid.appScope.checkEasyPostVoidAction(row)"><a href="javascript:void(0);" ng-click="grid.appScope.EasyPostLabelInPdf(row)">EasyPost Label</a></li>' +
            '<li><a href="javascript:void(0);" ng-click="grid.appScope.viewPackingSlip(row)">Print PackSlip</a></li></ul></div>'}
        ],

        onRegisterApi: function( gridApi ){

            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {
                if (row.isExpanded) {

                    row.entity.subGridOptions = {
                        appScopeProvider: $scope.subGridScope,
                        //rowHeight: 43,
                        columnDefs: [
                            {name:'Shipment Line', field: 'shipmentLineId'},
                            {name:'Order', field: 'orderNumber'},
                            {name:'Order Line', field: 'orderLineNumber'},
                            {name:'Item', field: 'itemId'},
                            {name:'Shipped Qty', field: 'shippedQuantity'},
                            {name:'Shipped UOM', field: 'shippedUOM'},
                            {name:'Actions', enableSorting: false,
                                 cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu">' +
                            '<li><a href="javascript:void(0);" ng-click="grid.appScope.clickMeSub(row)">View PickWork</a></li>' +
                                 '<li><a href="javascript:void(0);" ng-click="grid.appScope.viewInventory(row)">View Inventory</a></li>' +
                            '<li ng-if="grid.appScope.checkQty(row)"><a href="javascript:void(0);" ng-click="grid.appScope.shipmentQty(row)">Change Shipped Qty</a></li>'
                            }
                        ]};

                    $http({
                        method: 'GET',
                        url: '/shipping/findAllShipmentLinesByShipmentId',
                        params : {selectedShipmentId: row.entity.shipment_id}
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

    //end of Shipment grid


    //start edit shipment
    var clearAssignShipmentForm = function () {
        ctrl.carrierCode = null;
        ctrl.smallPackage = null;
        ctrl.serviceLevel = null;
        ctrl.trackingNo = null;
        ctrl.truckNumber = null;
        ctrl.shipmentIdForEdit = null;
        ctrl.isEditCutomerName = false;

    };


    var closeShipmentModel = function(){
        clearAssignShipmentForm();
    };

    var findWithAttribute = function(array, attr, value) {
        for(var i = 0; i < array.length; i += 1) {
            if(array[i][attr] === value) {
                return i;
            }
        }
        return -1;
    }

    $scope.Edit = function(row) {

        $http({
            method  : 'GET',
            url     : '/customer/getCustomerShippingAddress',
            params    :  {customerId: row.entity.customer_id}
        })
        .success(function (data, status, headers, config) {
            $scope.customerShippingAddressList = data;

                //ctrl.carrierCodeOptions = [ "UPS", "FedEx", "USPS", "CanadaPost", "DHL", "Puralator", "Roadway", "Yellow", "Con-way", "R&L", "Estes", "Wilson"];
                //getAllListValueCarrierCode();
                ctrl.serviceLevelOptions = ["NEXT DAY", "SECOND DAY", "GROUND"];

                ctrl.shipmentIdForEdit = row.entity.shipment_id;
                ctrl.selectedOrderNumber = row.entity.order_number;
                ctrl.assignShipmentOrderLineNumber = row.entity.order_line_number;
                ctrl.carrierCode = row.entity.carrier_code_option_value;
                ctrl.smallPackage = row.entity.is_parcel;
                ctrl.loadServiceForCarrier();
                ctrl.serviceLevel = row.entity.service_level;
                ctrl.truckNumber = row.entity.truck_number;
                ctrl.trackingNo = row.entity.tracking_no;
                ctrl.optAddress = 'existingAddress';
                var elementIndex = findWithAttribute($scope.customerShippingAddressList, 'id', row.entity.shipping_address_id);
                ctrl.shippingAddressFromOpt = $scope.customerShippingAddressList[elementIndex];
                ctrl.customerIdForShipment =  row.entity.customer_id;
                ctrl.cutomerNameFieldEdit = row.entity.contact_name;
                ctrl.billingContact = row.entity.billing_contact_name;
                ctrl.billingCompany = row.entity.billing_company_name;
                ctrl.shipmentNotes = row.entity.shipment_notes;

                $('#editShipment').appendTo("body").modal('show');

        })
    };


    $scope.openEasyPostEdit = function(row) {


        $http({
            method  : 'GET',
            url     : '/customer/getCustomerShippingAddress',
            params    :  {customerId: row.customer_id}
        })
        .success(function (data, status, headers, config) {
            $scope.customerShippingAddressList = data;

                //ctrl.carrierCodeOptions = [ "UPS", "FedEx", "USPS", "CanadaPost", "DHL", "Puralator", "Roadway", "Yellow", "Con-way", "R&L", "Estes", "Wilson"];
                //getAllListValueCarrierCode();
                ctrl.serviceLevelOptions = ["NEXT DAY", "SECOND DAY", "GROUND"];

                ctrl.shipmentIdForEdit = row.shipment_id;
                ctrl.selectedOrderNumber = row.order_number;
                ctrl.assignShipmentOrderLineNumber = row.order_line_number;
                ctrl.carrierCode = row.carrier_code_option_value;
                ctrl.smallPackage = row.is_parcel;
                ctrl.loadServiceForCarrier();
                ctrl.serviceLevel = row.service_level;
                ctrl.truckNumber = row.truck_number;
                ctrl.trackingNo = row.tracking_no;
                ctrl.optAddress = 'existingAddress';
                var elementIndex = findWithAttribute($scope.customerShippingAddressList, 'id', row.shipping_address_id);
                ctrl.shippingAddressFromOpt = $scope.customerShippingAddressList[elementIndex];
                ctrl.customerIdForShipment =  row.customer_id;
                ctrl.cutomerNameFieldEdit = row.contact_name;
                ctrl.billingContact = row.billing_contact_name;
                ctrl.billingCompany = row.billing_company_name;
                ctrl.shipmentNotes = row.shipment_notes;

                $('#editShipment').appendTo("body").modal('show');

        })
    };



    ctrl.editCutomerName = function(){
        ctrl.isEditCutomerName = true;
    };

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


    var updateShipment = function () {

        if(ctrl.editShipmentForm.$valid && !ctrl.truckValidationError) {

            shipService.checkShipmentStatus(ctrl.shipmentIdForEdit).then(function(response) {
                ctrl.newShipmentStatus = response[0].shipmentStatus;

                if (ctrl.newShipmentStatus == 'COMPLETED') {
                    $('#confirmWarningForEdit').appendTo("body").modal('show');
                    search();
                }

                else{
                    if (ctrl.optAddress == 'newAddress') {
                        shipService.editShipmentWithNewShippingAddress(ctrl.shipmentIdForEdit,ctrl.carrierCode,ctrl.smallPackage,ctrl.serviceLevel,ctrl.trackingNo,ctrl.truckNumber, ctrl.cutomerNameFieldEdit, ctrl.customerIdForShipment, ctrl.customerShippingStreetAddress, ctrl.customerShippingCity, ctrl.customerShippingState,
                            ctrl.customerShippingPostCode,ctrl.customerShippingCountry,ctrl.shipmentNotes).then(function(response) {
                            clearAssignShipmentForm();
                            search();
                            $('#editShipment').appendTo("body").modal('hide');
                        })
                    }
                    else{
                        shipService.editShipment(ctrl.shipmentIdForEdit,ctrl.carrierCode,ctrl.smallPackage,ctrl.serviceLevel,ctrl.trackingNo,ctrl.truckNumber, ctrl.cutomerNameFieldEdit, ctrl.shippingAddressFromOpt.id, ctrl.shipmentNotes).then(function(response) {
                            clearAssignShipmentForm();
                            search();
                            $('#editShipment').appendTo("body").modal('hide');
                        })
                    }
                }

            });
        }
    };

    var validateTruckNumber = function (truckNumber) {
        ctrl.truckValidationError = false;
            shipService.validateTruckNumber(truckNumber).then(function(response) {
                if(response.length == 0){
                    // ctrl.addToNewShipment.truckNumber.$setValidity('24hdispachedTruckExist', true);
                    ctrl.truckValidationError = false;
                }
                else
                {
                    // ctrl.addToNewShipment.truckNumber.$setValidity('24hdispachedTruckExist', false);
                    ctrl.truckValidationErrorMsg = response.error
                    ctrl.truckValidationError = true;
                }                
            })
    };

    ctrl.closeShipmentModel = closeShipmentModel;
    ctrl.updateShipment = updateShipment;
    ctrl.validateTruckNumber = validateTruckNumber;

    //end edit shipment


    //start complete shipment
    $scope.Complete = function(row) {
        ctrl.showNoOfLabelField = false;
        ctrl.shipmentIdForEdit = row.entity.shipment_id;
        ctrl.orderNotes = row.entity.notes

        if (row.entity.company_id == 'HDWNINT' || row.entity.company_id == 'HDWNODY') {
            ctrl.showNoOfLabelField = true;
        }

        shipService.getPickWorkByShipment(row.entity.shipment_id).then(function(response) {
            var info = [];
            if(response.length > 0){

                for (i = 0; i < response.length; i++) {
                    info.push(response[i].workReferenceNumber);

                }
            }

            ctrl.pickWorks = info;
        });


        $http({
            method: 'GET',
            url: '/shipping/findOderByShipment',
            params : {selectedShipment: row.entity.shipment_id}
        })
            .success(function (data) {
                ctrl.getOrderNumber = data[0].orderNumber;
            });


        if(row.entity.tracking_no && row.entity.tracking_no != ""){
            $('#shipmentComplete').appendTo("body").modal('show');
        }
        else{
            $('#trackingNoRequired').appendTo("body").modal('show');

            $http({
                method  : 'GET',
                url     : '/customer/getCustomerShippingAddress',
                params    :  {customerId: row.entity.customer_id}
            })
                .success(function (data, status, headers, config) {
                    $scope.customerShippingAddressList = data;

                    //ctrl.carrierCodeOptions = [ "UPS", "FedEx", "USPS", "CanadaPost", "DHL", "Puralator", "Roadway", "Yellow", "Con-way", "R&L", "Estes", "Wilson"];
                    //getAllListValueCarrierCode();
                    ctrl.serviceLevelOptions = ["NEXT DAY", "SECOND DAY", "GROUND"];

                    ctrl.shipmentIdForEdit = row.entity.shipment_id;
                    ctrl.selectedOrderNumber = row.entity.order_number;
                    ctrl.assignShipmentOrderLineNumber = row.entity.order_line_number;
                    ctrl.carrierCode = row.entity.carrier_code_option_value;
                    ctrl.smallPackage = row.entity.is_parcel;
                    ctrl.serviceLevel = row.entity.service_level;
                    ctrl.truckNumber = row.entity.truck_number;
                    ctrl.trackingNo = row.entity.tracking_no;
                    ctrl.optAddress = 'existingAddress';
                    var elementIndex = findWithAttribute($scope.customerShippingAddressList, 'id', row.entity.shipping_address_id);
                    ctrl.shippingAddressFromOpt = $scope.customerShippingAddressList[elementIndex];
                    ctrl.customerIdForShipment =  row.entity.customer_id;
                    ctrl.cutomerNameFieldEdit = row.entity.contact_name;
                    ctrl.billingContact = row.entity.billing_contact_name;
                    ctrl.billingCompany = row.entity.billing_company_name;
                    ctrl.shipmentNotes = row.entity.shipment_notes;
                    
                })
        }

    };


    $("#shipmentCompleteButton").click(function(){
        if (ctrl.noOfLabels && ctrl.noOfLabels >= 0) {
            shipService.completeShipment(ctrl.shipmentIdForEdit,ctrl.pickWorks,ctrl.getOrderNumber,ctrl.noOfLabels).then(function(response) {
                $('#shipmentComplete').modal('hide');
                search();
            });            
        }
        else if (!ctrl.noOfLabels) {
            shipService.completeShipment(ctrl.shipmentIdForEdit,ctrl.pickWorks,ctrl.getOrderNumber,ctrl.noOfLabels).then(function(response) {
                $('#shipmentComplete').modal('hide');
                search();
            });              
        }
    });

    //end complete shipment



    //start load shipment
    $scope.Load = function(row) {
        ctrl.showNoOfLabelField = false;
        ctrl.selectedOrderNumber = row.entity.order_number;
        ctrl.shipmentIdForEdit = row.entity.shipment_id;
        ctrl.viewTruckNumber = row.entity.truck_number;
        ctrl.orderNotes = row.entity.notes;
        if (row.entity.company_id == 'HDWNINT' || row.entity.company_id == 'HDWNODY') {
            ctrl.showNoOfLabelField = true;
        }
        $('#loadShipmentLine').appendTo("body").modal('show');

    };

    var clearLoadForm = function () {
        ctrl.truckNumber = null;
        ctrl.noOfLabels = null;
        //ctrl.showTruckNumberPrompt = false;
        //
        //$timeout(function(){
        //    ctrl.showTruckNumberPrompt = false;
        //}, 2000);
    };


    var closeLoadModel = function(){
        clearLoadForm();
    };


    var updateLoad = function () {
        if(ctrl.loadForm.$valid) {
            shipService.checkShipmentStatus(ctrl.shipmentIdForEdit).then(function(response) {
                ctrl.newShipmentStatus = response[0].shipmentStatus;

                if (ctrl.newShipmentStatus == 'COMPLETED') {
                    $('#confirmWarningForEdit').appendTo("body").modal('show');
                    search();
                }
                    else{

                        if(ctrl.viewTruckNumber != null){
                            if(ctrl.truckNumber == ctrl.viewTruckNumber){

                                shipService.loadShipment(ctrl.shipmentIdForEdit,ctrl.truckNumber,ctrl.truckNumber,ctrl.noOfLabels).then(function(response) {
                                    if (response && response.error) {
                                        ctrl.trailerErrorMsg = response.error;
                                        ctrl.showShipTrailerErrorPrompt = true;
                                        $timeout(function () {
                                            ctrl.showShipTrailerErrorPrompt = false;
                                            ctrl.trailerErrorMsg = null;
                                        }, 10000);
                                    }
                                    else{
                                        clearLoadForm();
                                        search();
                                        $('#loadShipmentLine').appendTo("body").modal('hide');   
                                    }
                                    
                                });

                                ctrl.truckNoError = false;
                                ctrl.truckNoRequiredError = false;

                            }

                            else if(ctrl.truckNumber != ctrl.viewTruckNumber){
                                ctrl.truckNoError = true;
                                $timeout(function(){
                                    ctrl.truckNoError = false;
                                }, 2000);

                                ctrl.truckNoRequiredError = false;
                            }

                            else if(ctrl.truckNumber == null){
                                ctrl.truckNoError = false;
                                ctrl.truckNoRequiredError = true;
                                $timeout(function(){
                                    ctrl.truckNoRequiredError = false;
                                }, 2000);

                            }

                        }

                        if(ctrl.viewTruckNumber == null){
                            if(ctrl.truckNumber != null){

                                shipService.loadShipment(ctrl.shipmentIdForEdit,ctrl.truckNumber,ctrl.truckNumber).then(function(response) {
                                    if (response && response.error) {
                                        ctrl.trailerErrorMsg = response.error;
                                        ctrl.showShipTrailerErrorPrompt = true;
                                        $timeout(function () {
                                            ctrl.showShipTrailerErrorPrompt = false;
                                            ctrl.trailerErrorMsg = null;
                                        }, 10000);
                                    }
                                    else{
                                        clearLoadForm();
                                        search();
                                        $('#loadShipmentLine').appendTo("body").modal('hide');   
                                    }
                                    
                                });

                                ctrl.truckNoError = false;
                                ctrl.truckNoRequiredError = false;

                            }

                            else if(ctrl.truckNumber == null){
                                ctrl.truckNoError = false;
                                ctrl.truckNoRequiredError = true;
                                $timeout(function(){
                                    ctrl.truckNoRequiredError = false;
                                }, 2000);

                            }

                        }

                    }

                });

        }
    };

    ctrl.closeLoadModel = closeLoadModel;
    ctrl.updateLoad = updateLoad;
    //end load shipment



    //start pick work pop up
    $scope.gridPickWork = {
        //exporterMenuCsv: true,
        //enableGridMenu: true,
        enableFiltering: true,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,
        columnDefs: [
            {name:'Pick Work', field: 'workReferenceNumber'},
            {name:'Order', field: 'orderNumber'},
            {name:'Order Line', field: 'orderLineNumber'},
            {name:'Shipment', field: 'shipmentId'},
            {name:'Shipment Line', field: 'shipmentLineId'},
            {name:'Pick Qty', field: 'pickQuantity'},
            {name:'Pick UOM', field: 'pickQuantityUom'}
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



    //start edit shipped qty
    var clearAssignShippedQtyForm = function () {
        ctrl.shippedQuantity = null;
    };


    var closeShippedQtyModel = function(){
        clearAssignShippedQtyForm();
    };

    var editShipmentTrackingNo = function(){
        $('#editShipment').appendTo("body").modal('show');
    };


    var updateShippedQty = function () {
        if(ctrl.editShippedQtyForm.$valid) {

            shipService.getTotalPickQty(ctrl.shipmentLineIdForEdit).then(function(response) {
                ctrl.totalPickQty = response[0].totalPickQty;

                shipService.getOrderLine(ctrl.shipmentLineIdForEdit).then(function(response) {
                    ctrl.orderedQty = response[0].ordered_quantity;

                            if(ctrl.shippedQuantity > ctrl.orderedQty){
                                //ctrl.shippedQtyError = true;
                                ctrl.shippedQtyError = "This Shipped Qty Greater than for Ordered Qty ";
                            }

                            else if(ctrl.shippedQuantity < 0){
                                //ctrl.shippedQtyError = true;
                                ctrl.shippedQtyError = "You Should Enter Greater than 0 Qty";
                            }

                            else if(ctrl.shippedQuantity < ctrl.totalPickQty){
                                //ctrl.shippedQtyError = true;
                                ctrl.shippedQtyError = "This Shipped Qty Less than for Total Pick Qty";
                            }

                            else{

                                shipService.editShippedQty(ctrl.shipmentLineIdForEdit,ctrl.shippedQuantity).then(function(response) {
                                        clearAssignShippedQtyForm();
                                        search();
                                        $('#shipmentLineQty').appendTo("body").modal('hide');
                                    });
                            }

                        });
                });
        }
    };


    ctrl.closeShippedQtyModel = closeShippedQtyModel;
    ctrl.editShipmentTrackingNo = editShipmentTrackingNo;
    ctrl.updateShippedQty = updateShippedQty;

    //end edit shipped qty


    //start void completed shipment

    var clearAssignLocationForm = function () {
        ctrl.locationId = null;
    };


    var closeLocationModel = function(){
        clearAssignLocationForm();
    };


    $scope.VoidSelect = function(row) {
        ctrl.shipmentIdForEdit = row.entity.shipment_id;

        shipService.getPickWorkByShipment(row.entity.shipment_id).then(function(response) {
            var info = [];
            if(response.length > 0){

                for (i = 0; i < response.length; i++) {
                    info.push(response[i].workReferenceNumber);

                }
            }

            ctrl.pickWorks = info;
        });

        $http({
            method: 'GET',
            url: '/shipping/findOderByShipment',
            params : {selectedShipment: row.entity.shipment_id}
        })
            .success(function (data) {
                ctrl.getOrderNumber = data[0].orderNumber;
            });



        $('#voidShipment').appendTo("body").modal('show');
    };


    //var loadLocationAutoComplete = function(){
    //    shipService.loadLocationAutoComplete().then(function(response) {
    //        $scope.loadCompanyLocations= response;
    //    });
    //};

    $scope.loadLocationAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/stagingLaneShipment/getLocationsByArea',
            params : {keyword: value.keyword}
        });

    }


    var saveAllocation = function (value) {
        if( ctrl.allocationCreateFrom.$valid) {

            shipService.voidShipment(ctrl.shipmentIdForEdit,ctrl.locationId,ctrl.pickWorks,ctrl.getOrderNumber).then(function(response) {
                search();
                clearAssignLocationForm();
                $('#voidShipment').appendTo("body").modal('hide');
            });

        }
    };


    var callback = function(value){
        //alert(value);
        ctrl.locationId = value;
    };

    ctrl.callback = callback;

    //loadLocationAutoComplete();
    ctrl.saveAllocation = saveAllocation;
    ctrl.closeLocationModel = closeLocationModel;

    //end void completed shipment


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
            {name:'Location', field: 'destination_location_id'},
            {name:'Pallet Id', field: 'pickedPalletId'},
            {name:'Case Id', field: 'pickedCaseId'},
            {name:'Item Id', field: 'item_id'},
            {name:'Description', field: 'item_description'},
            {name:'Quantity', field: 'pick_quantity'},
            {name:'Unit Of Measure', field: 'pick_quantity_uom'},
            {name:'Pick Level', field: 'pick_level'},
            {name:'Notes', cellTemplate: '<span><a href="javascript:void(0)" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;" popover-trigger="outsideClick" ng-show="row.entity.picked_inventory_notes" uib-popover="{{row.entity.picked_inventory_notes}}" popover-title="" popover-append-to-body="true" >Notes</a></span>'}

        ],

        exporterFieldCallback: function( grid, row, col, input ) {
          if( col.name == 'Notes' ){
            return row.entity.picked_inventory_notes;
          }
          else{
            return input;
          }
        },
                
        onRegisterApi: function( gridApi ){
            $scope.gridApi = gridApi;

            //gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {
            //
            //    if (row.isExpanded) {
            //        row.entity.subGridOptions = {
            //
            //            columnDefs: [
            //                {name:'Case Id', field: 'case_id'},
            //                {name: 'Item Id 1', cellTemplate:'<a href="#" data-toggle="tooltip" title="Item: {{ row.entity.item_id}} \n Description: {{row.entity.item_description}} \n Category: {{row.entity.item_category}} \n Origin Code: {{row.entity.origin_code}} \n UPC Code: {{row.entity.upc_code}}"> {{row.entity.item_id}}</a>'},
            //                {name:'Quantity', field: 'quantity'},
            //                {name:'Unit Of Measure', field: 'handling_uom'}
            //            ]};
            //
            //        $http({
            //            method: 'GET',
            //            url: '/inventory/getInventoryEntityAttributeForSearchRow',
            //            params : {selectedRowPallet: row.entity.grid_pallet_id}
            //        })
            //            .success(function(data) {
            //
            //                if(data.length > 0){
            //                    row.entity.subGridOptions.data = data;
            //                }
            //
            //            });
            //
            //
            //    }
            //});

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



    //start packing slip

    // $scope.PackingSlip = function(row) {
    //     window.print();
    //     //$('#packingSlipView').appendTo("body").modal('show');

    // };

    //end packing slip


//***************end active shipment tab*************************************


    //***************start active trucks tab*************************************

    ctrl.isTruckSearchVisible = true;

    var showHideTruckSearch = function () {
        //clearForm();
        ctrl.isTruckSearchVisible = ctrl.isTruckSearchVisible ? false : true;
    };


    var showDispatchedDateRange = function () {
        ctrl.displayDispatchedDateRange = ctrl.dispatchedDateRange;
    };

    //visible  close action
    $scope.checkOpen = function(row) {
        if (row.entity.status == 'OPEN') {
            return true
        }

        else{
            return false
        }

    };


    //visible  close,dispatched,print action
    $scope.checkClose = function(row) {
        if (row.entity.status == 'CLOSED') {
            return true
        }

        else{
            return false
        }

    };


    //Find Truck
    var searchTrack = function () {
        if (ctrl.searchTrackForm.$valid) {
            $http({
                method: 'POST',
                url: '/shipping/truckSearch',
                params: {truckNumber:ctrl.truckNumber,
                    dispatchedDateRange:ctrl.dispatchedDateRange,
                    dispatchedDate:ctrl.dispatchedDate
                },
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {

                    if(ctrl.displayDispatchedDateRange == true){
                        $scope.gridTruck.columnDefs[6].visible = true;
                        $scope.gridTruck.columnDefs[5].visible = true;
                        $scope.gridTruck.data = data;

                    }
                    else{
                        $scope.gridTruck.columnDefs[5].visible = false;
                        $scope.gridTruck.columnDefs[6].visible = true;
                        $scope.gridTruck.data = data;
                    }

                    ctrl.isTruckSearchVisible = false;
                    //searchTrack();
                    //$scope.gridTruck.data = data;
                })
        }
    };

    ctrl.searchTrack = searchTrack;
    ctrl.showHideTruckSearch = showHideTruckSearch;
    ctrl.showDispatchedDateRange = showDispatchedDateRange;

    var loadGridTruckData = function (){
        $http({
            method: 'POST',
            url: '/shipping/truckSearch',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridTruck.columnDefs[5].visible = false;
                $scope.gridTruck.data = data.splice(0,10000);

            })
    };
    loadGridTruckData();

    //new grid

    $scope.gridTruck = {
        expandableRowTemplate: "<div ui-grid='row.entity.subGridOptions' style='height:230px;'></div>",
        expandableRowHeight: 230,
        enableRowSelection: true,
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
            {name:'Order No.' , field: 'order_number'},
            {name:'Shipment ID', field: 'shipment_id'},
            {name:'Shipment Status' , field: 'shipment_status'},
            //{name:'Truck No.', field: 'truck_number'},
            //{name:'Small Package', field: 'is_parcel', type: 'boolean',
            //    cellClass: 'grid-align',cellTemplate: '<div class="gridCheckbox c-checkbox"><input type="checkbox"  ng-model="row.entity.is_parcel"><span class="fa fa-check"></span></div class>'},
            //{name:'Carrier Code', field: 'carrier_code'},
            //{name:'Service Level' , field: 'service_level'},
            //{name:'Tracking No' , field: 'tracking_no'},

            {name:'Truck No.', field: 'trailer_number'},
            {name:'Truck Status' , field: 'status'},
            {name:'Dispatched Date', field: 'dispatched_date',type: 'date',cellFilter: 'date:"yyyy-MM-dd"'},
            {name:'Actions', enableSorting: false,
                cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu">' +
                '<li ng-if="grid.appScope.checkOpen(row)"><a href="javascript:void(0);" ng-click="grid.appScope.Close(row)">Close</a></li>' +
                '<li ng-if="grid.appScope.checkClose(row)"><a href="javascript:void(0);" ng-click="grid.appScope.ReOpen(row)">ReOpen</a></li>' +
                '<li ng-if="grid.appScope.checkClose(row)"><a href="javascript:void(0);" ng-click="grid.appScope.Dispatch(row)">Dispatch</a></li>' +
                '<li ng-if="grid.appScope.checkClose(row) || row.entity.status == \'DISPATCHED\'"><a href="javascript:void(0);" ng-click="grid.appScope.printBOL(row)">Print Bill of Lading</a></li></ul></div class>'}
        ],

        onRegisterApi: function( gridApi ){

            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {
                if (row.isExpanded) {

                    row.entity.subGridOptions = {
                        appScopeProvider: $scope.subGridScope,
                        //rowHeight: 43,
                        columnDefs: [
                            {name:'Shipment Line', field: 'shipmentLineId'},
                            {name:'Order Line', field: 'orderLineNumber'},
                            {name:'Item', field: 'itemId'},
                            {name:'Shipped Qty', field: 'shippedQuantity'},
                            {name:'Shipped UOM', field: 'shippedUOM'},
                        ]};

                    $http({
                        method: 'GET',
                        url: '/shipping/findAllShipmentLinesByShipmentId',
                        params : {selectedShipmentId: row.entity.shipment_id}
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

    //




    //start close truck
    $scope.Close = function(row) {
        ctrl.idForEdit = row.entity.id;
        $('#truckClose').appendTo("body").modal('show');
    };


    $("#truckCloseButton").click(function(){
        shipService.getTruck(ctrl.idForEdit).then(function(response) {
                ctrl.newStatus = response[0].status;

                if (ctrl.newStatus != 'OPEN') {
                    $('#confirmWarningForClose').appendTo("body").modal('show');
                    searchTrack();
                }

                else{

                    shipService.closeTruck(ctrl.idForEdit).then(function(response) {
                            $('#truckClose').modal('hide');
                            searchTrack();
                        })
                }

            })
    });

    //end close truck

    //start open truck
    $scope.ReOpen = function(row) {
        ctrl.idForEdit = row.entity.id;
        $('#truckReOpen').appendTo("body").modal('show');

    };


    $("#truckReOpenButton").click(function(){
        shipService.getTruck(ctrl.idForEdit).then(function(response) {
            ctrl.newStatus = response[0].status;

                if (ctrl.newStatus != 'CLOSED') {
                    $('#confirmWarningForOpen').appendTo("body").modal('show');
                    searchTrack();
                }

                else{
                    shipService.openTruck(ctrl.idForEdit).then(function(response) {
                            $('#truckReOpen').modal('hide');
                            searchTrack();
                        })
                }
            })
    });

    //end open truck


    //start dispatch truck
    $scope.Dispatch = function(row) {
        ctrl.idForEdit = row.entity.id;
        $('#truckDispatch').appendTo("body").modal('show');

    };


    $("#truckDispatchButton").click(function(){
        shipService.getTruck(ctrl.idForEdit).then(function(response) {
            ctrl.newStatus = response[0].status;

                if (ctrl.newStatus != 'CLOSED') {
                    $('#confirmWarningForOpen').appendTo("body").modal('show');
                    searchTrack();
                }

                else{
                    shipService.dispatchTruck(ctrl.idForEdit).then(function(response) {
                            $('#truckDispatch').modal('hide');
                            searchTrack();
                        })
                }

            })
    });

    //end dispatch truck


    //***************end active trucks tab*************************************

//BOL
//***************BOL*************************************
    ctrl.dataForBol =[];
    ctrl.customerOrderInfo = [];
    ctrl.carrierInformation = [];
    ctrl.carreirDataForBol = [];

    $scope.editBOL = function() {
        
        $http({
            method: 'GET',
            url: '/jasperReport/getShipmentsByTruckforReport',
            params : {truckNumber: ctrl.getRow.entity.trailer_number}
        })
        .success(function(data) {
            ctrl.ShipmentData = data;
            ctrl.selectedShipmentId = data[0].shipmentId;
            getOrderInfoDataforReport(data[0].shipmentId);
            getCarrierInfoDataforReport(data[0].shipmentId);
            getReportInfoByShipment(data[0].shipmentId);
            $('#checkBOL').appendTo("body").modal('show');
        });

    };

    var getOrderInfoDataforReport = function(shipmentId){

        $http({
            method: 'GET',
            url: '/jasperReport/getOrderInfoDataforReport',
            params : {shipmentId: shipmentId}
        })
        .success(function(data) {
            ctrl.dataForBol = data;
            ctrl.addNewFieldNum = ctrl.dataForBol.length;
            
            ctrl.customerOrderInfo[0].orderNumber = ctrl.dataForBol[0].order_number; 
            ctrl.customerOrderInfo[0].pkgs = ctrl.dataForBol[0].pkgs; 
            ctrl.customerOrderInfo[0].weight = ctrl.dataForBol[0].weight; 
            ctrl.customerOrderInfo[0].palletSlip = ctrl.dataForBol[0].pallet_slip; 
            ctrl.customerOrderInfo[0].additionalShipperInfo = ctrl.dataForBol[0].additional_shipper_info;

        });        

    };

    var getCarrierInfoDataforReport = function(shipmentId){

        $http({
            method: 'GET',
            url: '/jasperReport/getCarrierInfoDataforReport',
            params : {shipmentId: shipmentId}
        })
        .success(function(data) {
            ctrl.carreirDataForBol = data;
            ctrl.addNewCarrierFieldNum = ctrl.carreirDataForBol.length;
            
            ctrl.carrierInformation[0].handlingUnitQty = ctrl.carreirDataForBol[0].handling_unit_qty; 
            ctrl.carrierInformation[0].handlingUnitType = ctrl.carreirDataForBol[0].handling_unit_type; 
            ctrl.carrierInformation[0].packageQty = ctrl.carreirDataForBol[0].package_qty; 
            ctrl.carrierInformation[0].packageType = ctrl.carreirDataForBol[0].package_type; 
            ctrl.carrierInformation[0].weight = ctrl.carreirDataForBol[0].weight;
            ctrl.carrierInformation[0].hm = ctrl.carreirDataForBol[0].hm;
            ctrl.carrierInformation[0].commodityDescription = ctrl.carreirDataForBol[0].commodity_description;
            ctrl.carrierInformation[0].ltlNmfc = ctrl.carreirDataForBol[0].ltl_nmfc;
            ctrl.carrierInformation[0].ltlClass = ctrl.carreirDataForBol[0].ltl_class;

        });        

    };

    var getReportInfoByShipment = function(shipmentId){

        $http({
            method: 'GET',
            url: '/jasperReport/getReportHeaderInfoByShipment',
            params : {shipmentId: shipmentId}
        })
        .success(function(data) {
            ctrl.reportInfoByShipment = data;
            if (ctrl.reportInfoByShipment.prepaid == true) {
                ctrl.reportInfoByShipment.chargeTerms = 'prepaid';
            }
            else if (ctrl.reportInfoByShipment.collect == true) {
                ctrl.reportInfoByShipment.chargeTerms = 'collect';
            }
            else if (ctrl.reportInfoByShipment.thirdParty == true) {
                ctrl.reportInfoByShipment.chargeTerms = 'thirdParty';
            }            
        });        

    };


    var getClickedShipment = function(shipmentId){
        ctrl.selectedShipmentId = shipmentId;
        getOrderInfoDataforReport(shipmentId);
        getCarrierInfoDataforReport(shipmentId);
        getReportInfoByShipment(shipmentId);
    };

    var getCompanyBolType = function(){
        $http({
            method: 'GET',
            url: '/company/getCurrentUserCompany',
        })
        .success(function(data) {
            ctrl.CurrentCompanyBolType = data.bolType;                   
        });        
    }

    getCompanyBolType();

    var updateJasperReport = function(){       

        $http({
            method: 'POST',
            url: '/jasperReport/saveJasperInfoData',
            data: {truckNumber:ctrl.getRow.entity.trailer_number, shipmentId:ctrl.selectedShipmentId, reportInfoByShipment:ctrl.reportInfoByShipment, customerOrderInfo: ctrl.customerOrderInfo, carrierInfo: ctrl.carrierInformation, driver:ctrl.reportInfoByShipment.driver, driverLic:ctrl.reportInfoByShipment.driverLic, tempHigh:ctrl.reportInfoByShipment.tempHigh, tempLow:ctrl.reportInfoByShipment.tempLow, loadedAt:ctrl.reportInfoByShipment.loadedAt},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
        .success(function(data) {
            //ctrl.srcStrg = "/report?format=PDF&file="+file+"&_controller=ShipmentController&_action="+action+"&fileFormat="+format+"&accessType="+accessType+"&truckNumber="+paramsTruckNumber+"&bol_number="+paramsBol+"&companyId=foy";
            ctrl.showReportUpdatedPrompt = true;
            $timeout(function(){
                ctrl.showReportUpdatedPrompt = false;
            }, 10000); 
        });       
    };


    ctrl.getClickedShipment = getClickedShipment;
    ctrl.updateJasperReport = updateJasperReport;

    $scope.printBOL = function(row){ 

        if (ctrl.CurrentCompanyBolType == 'tempControlledBol') {
            var file = 'tempControlledBOL';
        }
        else{
            var file = 'billOfLading';
        }

        ctrl.getRow = row;

        var format = 'PDF';
        //var file = 'billOfLading';
        var action = 'getBillOfLadingReport';
        var accessType = 'inline' ;
        var paramsTruckNumber = row.entity.trailer_number;
        var customerOrderInfo = ctrl.customerOrderInfo;        

        $http({
            method: 'POST',
            url: '/shipping/saveSerializedNumberByCompany',
            params : {truckNumber: row.entity.trailer_number}
        })          
        .success(function(data) {
            ctrl.srcStrg = "/report?format=PDF&file="+file+"&_controller=ShipmentController&_action="+action+"&fileFormat="+format+"&accessType="+accessType+"&truckNumber="+paramsTruckNumber; 
            $('#checkBOL').modal('hide');
            $('#viewReport').appendTo("body").modal('show');
        });

        // $http({
        //     method: 'POST',
        //     url: '/jasperReport/saveJasperInfoData',
        //     data: {truckNumber:ctrl.getRow.entity.trailer_number, customerOrderInfo: ctrl.customerOrderInfo, carrierInfo: ctrl.carrierInformation},
        //     dataType: 'json',
        //     headers : { 'Content-Type': 'application/json; charset=utf-8' }
        // })
        // .success(function(data) {
        //     ctrl.srcStrg = "/report?format=PDF&file="+file+"&_controller=ShipmentController&_action="+action+"&fileFormat="+format+"&accessType="+accessType+"&truckNumber="+paramsTruckNumber; 
        //         $('#viewReport').appendTo("body").modal('show');
        // });       

        //$('#checkBOL').modal('hide');
    };

    ctrl.addNewFieldNum = 1;

    var getNewField = function(number){
        return new Array(number);
    };
    ctrl.getNewField = getNewField;

    ctrl.addNewCarrierFieldNum = 1;

    var getNewCarrierField = function(number){
        return new Array(number);
    };

    var addNewCarrierField = function(index){
        ctrl.addNewCarrierFieldNum++;
    };

    var deleteCarrierRaw = function(index){
        ctrl.carrierInformation.splice(index, 1);
        if(ctrl.carrierInformation.length > 0){
            ctrl.addNewCarrierFieldNum = ctrl.addNewCarrierFieldNum-1;
        }
    };

    ctrl.getNewField = getNewField;
    ctrl.getNewCarrierField = getNewCarrierField;
    ctrl.addNewCarrierField = addNewCarrierField;
    ctrl.deleteCarrierRaw = deleteCarrierRaw;




    //BOL

    var reportEdit = function(){
        $('#checkBOL').appendTo("body").modal('show');
        ctrl.isReportEdit = true;
    };

    ctrl.reportEdit = reportEdit;

    $scope.printBolReport = function(){

        var w = window.open(ctrl.srcStrg);
        w.print();
    };

    //****************Packing-Slip***********************



    $scope.viewPackingSlip = function(row){ 

        var format = 'PDF';
        var file = 'packingSlip';
        var action = 'getBillOfLadingReport';
        var accessType = 'inline';
        var paramsShipmentId = row.entity.shipment_id;     
        
        ctrl.srcStrgForPackSlip = "/report?format=PDF&file="+file+"&_controller=ShipmentController&_action="+action+"&fileFormat="+format+"&accessType="+accessType+"&shipmentId="+paramsShipmentId; 
        $('#viewPackingSlipModel').appendTo("body").modal('show');

    };


    $scope.printPack = function(){

        var w = window.open(ctrl.srcStrgForPackSlip);
        w.print();
    };


    //****************Packing-Slip-end***********************


}])


//truckNumber unique(check to database)
    .directive('validateTruckNoUnique', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {

                ctrl.$parsers.push(function (viewValue) {
                    $http({
                        method : 'GET',
                        url : '/shipping/checkTruckNumberExist',
                        params: {truckNumber: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('truckNumberExists', true);
                            }
                            else
                            {
                                ctrl.$setValidity('truckNumberExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('truckNumberExists', false);
                        });

                    return viewValue;
                });

            }
        };
    })

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
