/**
 * Created by home on 7/20/16.
 */

var app = angular.module('report', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ui.grid.expandable', 'ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ngSanitize','ui.grid.pagination', 'ui.grid.autoResize']);

app.controller('ReportCtrl', ['$scope', '$http', '$interval', '$q', '$timeout',  function ($scope, $http, $interval, $q, $timeout) {

    var myEl = angular.element( document.querySelector( '#liReport' ) );
    myEl.addClass('active');

    var ctrl = this;

    $scope.$watch('reportType', function () {
        if ($scope.reportType == 'billOfLading') {
            ctrl.displayDiv = "billOfLading";
            getReportParamData($scope.reportType);
        }
        else if ($scope.reportType == 'packingSlip') {
        	ctrl.displayDiv = "packingSlip";
        	getReportParamData($scope.reportType);
        }
        else if ($scope.reportType == 'inventoryReport') {
            ctrl.displayDiv = "inventoryReport";
            getReportParamData($scope.reportType);
            
        }
        else if ($scope.reportType == 'pendingPutawayInventory') {
            ctrl.displayDiv = "pendingPutawayInventory";
            getReportParamData($scope.reportType);
        }   
        else if ($scope.reportType == 'picksReport') {
            ctrl.displayDiv = "picksReport";
            getReportParamData($scope.reportType);
        }   
        else if ($scope.reportType == 'pickListReport') {
            ctrl.displayDiv = "pickListReport";
            getReportParamData($scope.reportType);
        }         
        else if ($scope.reportType == 'inventorySummaryReport') {
            ctrl.displayDiv = "inventorySummaryReport";
            getReportParamData($scope.reportType);
        } 
        else if ($scope.reportType == 'itemReorder') {
            ctrl.displayDiv = "itemReorder";
            getReportParamData($scope.reportType);
        }
        else if ($scope.reportType == 'receiptReport') {
            ctrl.displayDiv = "receiptReport";
            getReportParamData($scope.reportType);
        }  
        else if ($scope.reportType == 'orderReport') {
            ctrl.displayDiv = "orderReport";
            getReportParamData($scope.reportType);
        }                                                            
        else{
        	ctrl.displayDiv = null;
        }
    });

    var getReportParamData = function(reportType){
	    $http({
	        method: 'GET',
	        url: '/report/getParamFromJasperReport',
	        params:{reportType:reportType}
	    })

        .success(function (data, status, headers, config) {
            ctrl.getReportParameter = data;
        })
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

    getAllAreas();

    var getAllListValueInventoryStatus = function () {
        $http({
            method: 'GET',
            url: '/order/getAllValuesByCompanyIdAndGroup',
            params : {group: 'INVSTATUS'}
        })
            .success(function (data, status, headers, config) {
                var noneOption = [{description: ''}];
                ctrl.inventoryStatusOptions = noneOption.concat(data);
            })
    };    
    getAllListValueInventoryStatus();    

    var getAllListValues = function () {
        $http({
            method: 'GET',
            url: '/item/getAllValuesByCompanyIdAndGroup',
            params : {group: 'ITEMCAT'}
        })
            .success(function (data) {
                ctrl.listValue = data;
            })
    };
    getAllListValues();

    $scope.loadLocationAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/location/getCompanyAllLocations',
            params : {keyword: value.keyword}
        });
    }


    $scope.loadCompanyItems = function (value) {

        return $http({
            method: 'GET',
            url: '/item/getItems',
            params : {keyword:value.keyword}
        })        
    };


    $scope.getBolReport = function () {
        //alert(value);
        var truckNumberAsParam = null;
		var format = 'PDF';
	   	var file = 'billOfLading';
	    var accessType = 'inline';
		ctrl.bolSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType;
        ctrl.mailSubject = file;

		for (var i = ctrl.getReportParameter.length - 1; i >= 0; i--) {
			ctrl.bolSrcStrg += "&"+ctrl.getReportParameter[i].name+"="+ctrl.getReportParameter[i].inputValues; 
			if (ctrl.getReportParameter[i].name == 'truckNumber') {
				ctrl.truckNumberAsParam = ctrl.getReportParameter[i].inputValues;
			}
		}

        if (ctrl.truckNumberAsParam) {
            $http({
                method: 'POST',
                url: '/shipping/saveSerializedNumberByCompany',
                params : {truckNumber: ctrl.truckNumberAsParam}
            })          
            .success(function(data) {
                $('#viewBolReport').appendTo("body").modal('show');
            }); 
        }
        else{
            $('#truckIdValidationWarning').appendTo("body").modal('show');
        }

	

		
    };


    ctrl.dataForBol =[];
    ctrl.customerOrderInfo = [];
    ctrl.carrierInformation = [];
    ctrl.carreirDataForBol = [];

    $scope.editBOL = function() {
        
        $http({
            method: 'GET',
            url: '/jasperReport/getShipmentsByTruckforReport',
            params : {truckNumber: ctrl.truckNumberAsParam}
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
            if (ctrl.dataForBol.length > 0) {
                ctrl.customerOrderInfo[0].orderNumber = ctrl.dataForBol[0].order_number; 
                ctrl.customerOrderInfo[0].pkgs = ctrl.dataForBol[0].pkgs; 
                ctrl.customerOrderInfo[0].weight = ctrl.dataForBol[0].weight; 
                ctrl.customerOrderInfo[0].palletSlip = ctrl.dataForBol[0].pallet_slip; 
                ctrl.customerOrderInfo[0].additionalShipperInfo = ctrl.dataForBol[0].additional_shipper_info;
            }

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
            if (ctrl.carreirDataForBol.length > 0) {
                ctrl.carrierInformation[0].handlingUnitQty = ctrl.carreirDataForBol[0].handling_unit_qty; 
                ctrl.carrierInformation[0].handlingUnitType = ctrl.carreirDataForBol[0].handling_unit_type; 
                ctrl.carrierInformation[0].packageQty = ctrl.carreirDataForBol[0].package_qty; 
                ctrl.carrierInformation[0].packageType = ctrl.carreirDataForBol[0].package_type; 
                ctrl.carrierInformation[0].weight = ctrl.carreirDataForBol[0].weight;
                ctrl.carrierInformation[0].hm = ctrl.carreirDataForBol[0].hm;
                ctrl.carrierInformation[0].commodityDescription = ctrl.carreirDataForBol[0].commodity_description;
                ctrl.carrierInformation[0].ltlNmfc = ctrl.carreirDataForBol[0].ltl_nmfc;
                ctrl.carrierInformation[0].ltlClass = ctrl.carreirDataForBol[0].ltl_class;
            }

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


    var updateJasperReport = function(){       

        $http({
            method: 'POST',
            url: '/jasperReport/saveJasperInfoData',
            data: {truckNumber:ctrl.getRow.entity.trailer_number, shipmentId:ctrl.selectedShipmentId, reportInfoByShipment:ctrl.reportInfoByShipment, customerOrderInfo: ctrl.customerOrderInfo, carrierInfo: ctrl.carrierInformation},
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
    ctrl.getClickedShipment = getClickedShipment;
    ctrl.updateJasperReport = updateJasperReport;


    $scope.getPackingSlipReport = function () {
        //alert(value);

		var format = 'PDF';
	   	var file = 'packingSlip';
	    var accessType = 'inline';
		ctrl.packingSlipSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType;
        ctrl.mailSubject = file;

		for (var i = ctrl.getReportParameter.length - 1; i >= 0; i--) {
			ctrl.packingSlipSrcStrg += "&"+ctrl.getReportParameter[i].name+"="+ctrl.getReportParameter[i].inputValues; 
		}

		$('#viewPackingSlipReport').appendTo("body").modal('show');

    };

    $scope.getPendingPutawayInventoryReport = function () {
        var format = 'PDF';
        var file = 'pendingPutawayInventory';
        var accessType = 'inline';
        ctrl.pendingPutawayInvSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType;
        ctrl.mailSubject = file;

        for (var i = ctrl.getReportParameter.length - 1; i >= 0; i--) {
            ctrl.pendingPutawayInvSrcStrg += "&"+ctrl.getReportParameter[i].name+"="+ctrl.getReportParameter[i].inputValues; 
        }

        $('#pendingPutawayInventoryReport').appendTo("body").modal('show');

    };    

    $scope.getPicksReport = function () {
        var format = 'PDF';
        var file = 'picksReport';
        var accessType = 'inline';
        ctrl.picksReportSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType;
        ctrl.mailSubject = file;

        for (var i = ctrl.getReportParameter.length - 1; i >= 0; i--) {
            if (ctrl.getReportParameter[i].inputValues) {
                ctrl.picksReportSrcStrg += "&"+ctrl.getReportParameter[i].name+"="+ctrl.getReportParameter[i].inputValues;
            } 
        }

        $('#picksReport').appendTo("body").modal('show');

    };  

    $scope.getPickListReport = function () {
        var format = 'PDF';
        var file = 'pickListReport';
        var accessType = 'inline';
        ctrl.pickListReportSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType;
        ctrl.mailSubject = file;

        for (var i = ctrl.getReportParameter.length - 1; i >= 0; i--) {
            if (ctrl.getReportParameter[i].inputValues) {
                ctrl.pickListReportSrcStrg += "&"+ctrl.getReportParameter[i].name+"="+ctrl.getReportParameter[i].inputValues;
            } 
        }

        $('#pickListReport').appendTo("body").modal('show');

    }; 

    $scope.getInventorySummaryReport = function () {
        var format = 'PDF';
        var file = 'inventorySummaryReport';
        var accessType = 'inline';
        ctrl.inventorySummaryReportSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType;
        ctrl.mailSubject = file;

        for (var i = ctrl.getReportParameter.length - 1; i >= 0; i--) {
            if (ctrl.getReportParameter[i].inputValues) {
                ctrl.inventorySummaryReportSrcStrg += "&"+ctrl.getReportParameter[i].name+"="+ctrl.getReportParameter[i].inputValues;
            } 
        }

        $('#inventorySummaryReport').appendTo("body").modal('show');

    }; 

    $scope.getInventoryReport = function (fileType) {

        var format = null;
        var accessType = null; 
        var file = null;

        if (fileType == 'PDF') {
            format = 'PDF';
            accessType = 'inline';
            file = 'inventoryReport';
        }
        else{
            format = 'CSV';
            accessType = 'attachment';
            file = 'inventoryReportForCsv'            
        }

        
        ctrl.inventorySrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType;
        ctrl.mailSubject = file;

        // if (ctrl.locationSearchVal) {
        //     ctrl.inventorySrcStrg += "&locationId="+ctrl.locationSearchVal; 
        // }
        // if (ctrl.areaSearchVal) {
        //     ctrl.inventorySrcStrg += "&areaId="+ctrl.areaSearchVal;
        // }
        // if (ctrl.inventoryStatusSearchVal) {
        //     ctrl.inventorySrcStrg += "&inventoryStatus="+ctrl.inventoryStatusSearchVal; 
        // }
        // if (ctrl.itemSearchVal) {
        //     ctrl.inventorySrcStrg += "&itemId="+ctrl.itemSearchVal;
        // }
        // if (ctrl.inventorySrcStrg == true) {
        //     ctrl.inventorySrcStrg += "&includePickedInventory="+ctrl.includePickedInventorySearch; 
        // }

        for (var i = ctrl.getReportParameter.length - 1; i >= 0; i--) {
            if (ctrl.getReportParameter[i].inputValues) {
                ctrl.inventorySrcStrg += "&"+ctrl.getReportParameter[i].name+"="+ctrl.getReportParameter[i].inputValues;
            } 
        }

        if (fileType == 'PDF') {
            $('#viewInventoryReport').appendTo("body").modal('show');
        }else{
            window.open(ctrl.inventorySrcStrg, 'Download');
        }
        

        

    };

    $scope.getReorderLevelItemReport = function () {
        var format = 'PDF';
        var file = 'itemReorder';
        var accessType = 'inline';
        ctrl.reorderLevelItemReportSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType;
        ctrl.mailSubject = file;

        for (var i = ctrl.getReportParameter.length - 1; i >= 0; i--) {
            if (ctrl.getReportParameter[i].inputValues) {
                ctrl.reorderLevelItemReportSrcStrg += "&"+ctrl.getReportParameter[i].name+"="+ctrl.getReportParameter[i].inputValues;
            } 
        }

        $('#reorderLevelItemReport').appendTo("body").modal('show');

    };    

    $scope.getReceiptReport = function () {

        if (ctrl.getReportParameter[0].inputValues) {
            $http({
                method: 'GET',
                url: '/receiving/checkReceiptIdExist',
                params : {receiptId: ctrl.getReportParameter[0].inputValues}
            })
            .success(function(data) {

                if (data.length > 0) {
                    var format = 'PDF';
                    var file = 'receiptReport';
                    var accessType = 'inline';
                    ctrl.receiptReportSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType;
                    ctrl.mailSubject = "Foysonis Receipt Report - "+ctrl.getReportParameter[0].inputValues;

                    for (var i = ctrl.getReportParameter.length - 1; i >= 0; i--) {
                        if (ctrl.getReportParameter[i].inputValues) {
                            ctrl.receiptReportSrcStrg += "&"+ctrl.getReportParameter[i].name+"="+ctrl.getReportParameter[i].inputValues;
                        } 
                    }

                    $('#receiptReportModal').appendTo("body").modal('show');

                }
                else{
                    $('#receiptValidationModal').appendTo("body").modal('show');      
                }

            })            
        }
        else{
            $('#receiptValidationModal').appendTo("body").modal('show');   
        }
    };    

    $scope.getOrderReport = function () {

        if (ctrl.getReportParameter[0].inputValues) {
            $http({
                method: 'GET',
                url: '/order/getSelectedOrderData',
                params : {orderNum: ctrl.getReportParameter[0].inputValues}
            })
            .success(function(data) {

                if (data.length > 0) {
                    var format = 'PDF';
                    var file = 'orderReport';
                    var accessType = 'inline';
                    ctrl.orderReportSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType;
                    ctrl.mailSubject = "Foysonis Order Report - "+ctrl.getReportParameter[0].inputValues;

                    for (var i = ctrl.getReportParameter.length - 1; i >= 0; i--) {
                        if (ctrl.getReportParameter[i].inputValues) {
                            ctrl.orderReportSrcStrg += "&"+ctrl.getReportParameter[i].name+"="+ctrl.getReportParameter[i].inputValues;
                        } 
                    }

                    $('#orderReportModal').appendTo("body").modal('show');                
                }
                else{
                    $('#orderValidationModal').appendTo("body").modal('show');      
                }

            })            
        }
        else{
            $('#orderValidationModal').appendTo("body").modal('show');   
        }

    }; 

    $scope.printReport = function(url){

        var w = window.open(url);
        w.print();
    };    

	$scope.filterLabelText = function (str) {
		  var frags = str.split('_');
		  for (i=0; i<frags.length; i++) {
		    frags[i] = frags[i].charAt(0).toUpperCase() + frags[i].slice(1);
		  }
		  //return frags.join(' ');
		  return frags.join(' ').replace(/([A-Z])/g, ' $1').toUpperCase();
	}; 

    ctrl.openMailAddrModal = function(urlString){
        ctrl.reportPathString = urlString;
        ctrl.isEmailsent = false;
        ctrl.sendingEmailNow = false;
        ctrl.mailToAddress = '';
        ctrl.mailTextBody = '';
        $('#sendMailToModal').appendTo("body").modal('show'); 
        //ctrl.mailToForm.$setUntouched();
        //ctrl.mailToForm.$setPristine();
        
    }


    $scope.sendFileViaMail = function(){
        if( ctrl.mailToForm.$valid) {
            $('#sendMailToModal').modal('hide'); 
            $('#viewOrderReportModel').modal('hide'); 
            $('#sendingMailModal').appendTo("body").modal('show'); 
            $http({
                method  : 'POST',
                url     : ctrl.reportPathString,
                params  : {isForMail:true },
                data    : {recipient:ctrl.mailToAddress, mailSubject:ctrl.mailSubject, mailBody:ctrl.mailTextBody},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
            .success(function(data) {
                $('#sendMailSuccessModel').appendTo("body").modal('show');
                $timeout(function () {
                    $('#sendMailSuccessModel').modal('hide');
                }, 5000);                    
            })
            .finally(function () {
                $('#sendingMailModal').modal('hide'); 
            }); 
        }        
    }

}]);
