/**
 * Created by home on 9/10/15.
 */

var app = angular.module('packoutApp', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.bootstrap', 'ui.grid.pagination', 'ui.grid.expandable', 'ui.grid.resizeColumns', 'ui.grid.autoResize', 'inventory-autocomplete', 'ngLocale']);

app.controller('packoutCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

    var importItems = null;

    var myEl = angular.element(document.querySelector('#liShipping'));
    myEl.addClass('active');
    var subMenu = angular.element(document.querySelector('#ulShipping'));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'Items';

    var fakeI18n = function (title) {
        var deferred = $q.defer();
        $interval(function () {
            deferred.resolve('col: ' + title);
        }, 1000, 1);
        return deferred.promise;
    };


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

    $scope.toggleMin = function () {
        $scope.inlineOptions.minDate = $scope.inlineOptions.minDate ? null : new Date();
        $scope.dateOptions.minDate = $scope.inlineOptions.minDate;
    };

    $scope.toggleMin();

    $scope.openEarlyShipDate = function () {
        $scope.popupEarlyShipDate.opened = true;
    };

    $scope.openEarlyShipDateFrom = function () {
        $scope.popupEarlyShipDateFrom.opened = true;
    };

    $scope.openEarlyShipDateTo = function () {
        $scope.popupEarlyShipDateTo.opened = true;
    };

    $scope.openLateShipDate = function () {
        $scope.popupLateShipDate.opened = true;
    };

    $scope.openLateShipDateFrom = function () {
        $scope.popupLateShipDateFrom.opened = true;
    };

    $scope.openLateShipDateTo = function () {
        $scope.popupLateShipDateTo.opened = true;
    };

    $scope.format = $locale.DATETIME_FORMATS.shortDate;
    $scope.altInputFormats = ['M!/d!/yyyy'];

    $scope.popupEarlyShipDate = {
        opened: false
    };

    $scope.popupEarlyShipDateFrom = {
        opened: false
    };

    $scope.popupEarlyShipDateTo = {
        opened: false
    };

    $scope.popupLateShipDate = {
        opened: false
    };

    $scope.popupLateShipDateFrom = {
        opened: false
    };

    $scope.popupLateShipDateTo = {
        opened: false
    };

    function getDayClass(data) {
        var date = data.date,
            mode = data.mode;
        if (mode === 'day') {
            var dayToCheck = new Date(date).setHours(0, 0, 0, 0);

            for (var i = 0; i < $scope.events.length; i++) {
                var currentDay = new Date($scope.events[i].date).setHours(0, 0, 0, 0);

                if (dayToCheck === currentDay) {
                    return $scope.events[i].status;
                }
            }
        }

        return '';
    }

    //Date Control    

    var ctrl = this;

    $scope.loadCustomerAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/order/getAllcustomerIdByCompany',
            params: {keyPress: value.keyword}
        });
    };

    $scope.loadLocationAutoComplete = function (value) {
        return $http({
            method: 'GET',
            url: '/stagingLaneShipment/getLocationsByArea',
            params: {keyword: value.keyword}
        });
    }

    ctrl.getCustomerContactName = function (customer) {
        if (customer) {
            ctrl.customerId = customer.customerId;
        }

    }

    var getAllListValueShipSpeed = function () {
        $http({
            method: 'GET',
            url: '/order/getAllValuesByCompanyIdAndGroup',
            params: {group: 'RSHSP'}
        })
            .success(function (data, status, headers, config) {
                var noneOption = [{description: ''}];
                ctrl.listValueShipSpeed = noneOption.concat(data);
            })
    };

    getAllListValueShipSpeed();

    ctrl.isEasyPostEnabled = false;
    var check3plEnabled = function () {
        $http({
            method: 'GET',
            url: '/company/getCurrentUserCompany',
        })

            .success(function (data) {

                if (data) {
                    ctrl.isEasyPostEnabled = data.isEasyPostEnabled;
                }
            });
    }
    check3plEnabled();


    var getAllDefaultPrintersData = function () {

        $http({
            method: 'GET',
            url: '/printer/getAllDefaultPrinters'
        })
            .success(function (data, status, headers, config) {
                var noneOption = [{id: '', displayName: ''}];
                ctrl.defaultPrinterOptions = noneOption.concat(data);
                ctrl.defaultPrinter = {id: '', displayName: ''};
            })
    };

    var getAllLabelPrintersData = function () {

        $http({
            method: 'GET',
            url: '/printer/getAllLabelPrinters'
        })
            .success(function (data, status, headers, config) {
                var noneOption = [{id: '', displayName: ''}];
                ctrl.defaultLabelOptions = noneOption.concat(data);
                ctrl.labelPrinter = {id: '', displayName: ''};
            })
    };
    getAllDefaultPrintersData();
    getAllLabelPrintersData();

    ctrl.labelPrinterDisable = true;
    ctrl.labelPrinterOnChange = function () {
        if (ctrl.labelPrinter.id == '' || ctrl.labelPrinter.id == null) {
            ctrl.labelPrinterOptVal = null;
            ctrl.labelPrinterDisable = true;
        } else {
            ctrl.labelPrinterOptVal = ctrl.labelPrinter.id;
            ctrl.labelPrinterDisable = false;
        }
    }

    ctrl.defaultPrinterOnChange = function () {
        if (ctrl.defaultPrinter.id == '' || ctrl.defaultPrinter.id == null) {
            ctrl.defaultPrinterOptVal = null;
        } else {
            ctrl.defaultPrinterOptVal = ctrl.defaultPrinter.id;
        }
    }

    $scope.viewPackingSlip = function () {

        var format = 'PDF';
        var file = 'packingSlip';
        var action = 'getBillOfLadingReport';
        var accessType = 'inline';
        var paramsShipmentId = ctrl.packOutSearchResult.shipmentId;

        ctrl.srcStrgForPackSlip = "/report?format=PDF&file=" + file + "&_controller=ShipmentController&_action=" + action + "&fileFormat=" + format + "&accessType=" + accessType + "&shipmentId=" + paramsShipmentId;
        $('#viewPackingSlipModel').appendTo("body").modal('show');

    };

    var showEarlyShipDateRange = function () {
        ctrl.displayEarlyShipDateRange = ctrl.earlyShipDateRange
    };

    var showLateShipDateRange = function () {
        ctrl.displayLateShipDateRange = ctrl.LateShipDateRange
    };

    var getAllListValueCarrierCode = function () {
        $http({
            method: 'GET',
            url: '/order/getAllValuesByCompanyIdAndGroup',
            params: {group: 'CARRCODE'}
        })
            .success(function (data, status, headers, config) {
                var noneOption = [{description: ''}];
                ctrl.carrierCodeOptions = noneOption.concat(data);
            })
    };
    getAllListValueCarrierCode();
    ctrl.serviceLevelOptions = ["NEXT DAY", "SECOND DAY", "GROUND"];

    $scope.ShowWaveModal = function () {
        //clearForm();
        ctrl.selectedOrderLines = [];
        $http({
            method: 'POST',
            url: '/wave/searchOrderForWave'
        })
            .success(function (data) {
                $('#PlanWaving').appendTo("body").modal('show');
                $scope.gridWaveOrders.data = data;
            })
    };

    ctrl.showHideSearch = function () {
        ctrl.isOrderSearchVisible = ctrl.isOrderSearchVisible ? false : true;
    };

    ctrl.showEarlyShipDateRange = showEarlyShipDateRange;
    ctrl.showLateShipDateRange = showLateShipDateRange;

    ctrl.orderSearchForWaving = function () {

        $http({
            method: 'POST',
            url: '/wave/searchOrderForWave',
            params: {
                customerName: ctrl.customerId,
                orderNumber: ctrl.orderNumber,
                fromEarlyShipDate: ctrl.fromEarlyShipDate,
                toEarlyShipDate: ctrl.toEarlyShipDate,
                fromLateShipDate: ctrl.fromLateShipDate,
                toLateShipDate: ctrl.toLateShipDate,
                requestedShipSpeed: ctrl.requestedShipSpeed,
                maxOrderNum: ctrl.maxNoOfOrders
            },

            //params: {orderNumber:ctrl.orderNumber},
            dataType: 'json',
            headers: {'Content-Type': 'application/json; charset=utf-8'}
        })
            .success(function (data) {

                //ctrl.isOrderSearchVisible = false;
                $scope.gridWaveOrders.data = data;

            })

    };

    ctrl.waveplanMessage = null;
    ctrl.showPlanWaveSuccessPrompt = false;
    ctrl.showPlanWaveErrorPrompt = false;
    ctrl.getSelectedRows = function () {
        //$('#planWavingModal').appendTo("body").modal('show');
        $http({
            method: 'POST',
            url: '/wave/planWave',
            data: $scope.ctrl.selectedOrderLines,
            dataType: 'json',
            headers: {'Content-Type': 'application/json; charset=utf-8'}
        })
            .success(function (data) {
                if (data.wavePlanResult == true) {
                    ctrl.showPlanWaveSuccessPrompt = true;
                    ctrl.showPlanWaveErrorPrompt = false;
                    ctrl.waveplanMessage = data.message;
                    ctrl.waveNumberForSearch = data.waveNumber;
                    //ctrl.searchPackout();
                    $('#PlanWaving').modal('hide');
                    $timeout(function () {
                        ctrl.showPlanWaveSuccessPrompt = false;
                    }, 5000);
                }
                else {
                    ctrl.showPlanWaveErrorPrompt = true;
                    ctrl.showPlanWaveSuccessPrompt = false;
                    ctrl.waveplanMessage = data.message;
                    $timeout(function () {
                        ctrl.showPlanWaveErrorPrompt = false;
                    }, 5000);
                }
            })
    };


    var getInventoryLevelIcon = function (orderLineStatus, itemId, status, orderedQty, orderedUOM, index, row) {

        if (orderLineStatus == "PLANNED") {
            row.entity.subGridOptions.data[index].inventoryLevelColor = 'GREEN';
            row.entity.subGridOptions.data[index].inventoryLevelIcon = 'fa-check';
        }
        else {

            $http({
                method: 'GET',
                url: '/order/getInventorySummaryForQty',
                params: {itemId: itemId, status: status}
            })
                .success(function (data) {
                    if (data.length > 0) {
                        var availableQtyTotal = data[0].totalQuantity - data[0].committedQuantity;
                        if (parseInt(availableQtyTotal) < 0) {
                            row.entity.subGridOptions.data[index].availableQty = 0;
                        } else {
                            row.entity.subGridOptions.data[index].availableQty = availableQtyTotal;
                        }
                        row.entity.subGridOptions.data[index].lowestUom = data[0].uom;

                        $http({
                            method: 'GET',
                            url: '/order/getTotalOrderedQty',
                            params: {itemId: itemId, status: status}
                        })
                            .success(function (data) {
                                var totalOrderedQty = data.totalOrderedQty;

                                if (availableQtyTotal >= totalOrderedQty) {
                                    row.entity.subGridOptions.data[index].inventoryLevelColor = 'GREEN';
                                    row.entity.subGridOptions.data[index].inventoryLevelIcon = 'invIconGreen';
                                }
                                else {
                                    var calcOrderedQty = orderedQty;
                                    if (data.itemLowestUom.toUpperCase() == 'EACH' && orderedUOM.toUpperCase() == 'CASE') {
                                        calcOrderedQty = orderedQty * parseInt(data.itemEachesPerCase);
                                    }
                                    if (calcOrderedQty <= availableQtyTotal) {
                                        row.entity.subGridOptions.data[index].inventoryLevelColor = 'YELLOW';
                                        row.entity.subGridOptions.data[index].inventoryLevelIcon = 'invIconYellow';
                                    }
                                    else {
                                        row.entity.subGridOptions.data[index].inventoryLevelColor = 'RED';
                                        row.entity.subGridOptions.data[index].inventoryLevelIcon = 'invIconRed';
                                    }
                                }
                            });
                    }
                    else {
                        row.entity.subGridOptions.data[index].inventoryLevelColor = 'RED';
                        row.entity.subGridOptions.data[index].inventoryLevelIcon = 'invIconRed';
                        row.entity.subGridOptions.data[index].availableQty = 0;


                        $http({
                            method: 'GET',
                            url: '/item/findItem',
                            params: {itemId: itemId}
                        })
                            .success(function (data) {

                                if (data.length > 0) {
                                    row.entity.subGridOptions.data[index].lowestUom = data[0].lowestUom;
                                }

                            });
                    }


                });

        }
    };


    $scope.gridWaveOrders = {
        //rowHeight:100,
        expandableRowTemplate: "<div id='receiptLineGrid' ui-grid='row.entity.subGridOptions' style='height:250px;'></div>",
        expandableRowHeight: 250,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
        exporterPdfHeader: {text: headerTitle, style: 'headerStyle'},
        exporterPdfFooter: function (currentPage, pageCount) {
            return {text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle'};
        },
        exporterPdfCustomFormatter: function (docDefinition) {
            docDefinition.styles.headerStyle = {fontSize: 15, bold: true, margin: 20};
            //docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
            return docDefinition;
        },
        exporterPdfOrientation: 'portrait',
        exporterPdfPageSize: 'LETTER',
        exporterPdfMaxGridWidth: 500,

        columnDefs: [
            {name: 'Order Number', field: 'order_number'},
            {name: 'Number of Lines', field: 'total_order_lines'},
            {name: 'Number of Units', field: 'total_no_Of_uom'},
            {name: 'Inventory Available', field: 'available_inventory_status'}
            // {name: 'Actions', enableSorting: false, cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.Delete(row)">Delete</a></li></ul></div>'}
        ],

        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;

            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {

                row.entity.subGridOptions = {
                    appScopeProvider: $scope.subGridScope,

                    columnDefs: [
                        {name: 'Order Line No', field: 'displayOrderLineNumber'},
                        {name: 'Item', field: 'itemId'},
                        {name: 'Quantity', field: 'orderedQuantity', width: 120},
                        {name: 'UOM', field: 'orderedUOM', width: 100},
                        {name: 'Inventory Status', field: 'requestedInventoryStatus'},
                        {name: 'Line Status', field: 'orderLineStatus'},
                        {
                            name: 'Available Qty',
                            field: 'inventoryLevel',
                            width: 150,
                            cellTemplate: '<span ng-if="row.entity.inventoryLevelIcon==\'fa-check\'" style="color: {{row.entity.inventoryLevelColor}}; padding: 10px; " class="fa {{row.entity.inventoryLevelIcon}}"></span><span ng-if="row.entity.inventoryLevelIcon!=\'fa-check\'" style="padding: 10px 2px;line-height: 2.5><em class="fa  fa-fw mr-sm" ><img width="28px" src="/foysonis2016/app/img/{{row.entity.inventoryLevelIcon}}.svg"></em></span><span style="padding: 10px 2px;line-height: 2.5;">{{row.entity.availableQty}}</span><span style="padding: 10px 2px;line-height: 2.5;">{{row.entity.lowestUom}}</span>'
                        },
                        //{name: 'Actions', enableSorting: false, enableFiltering: false,  cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.EditOrderLine(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.DeleteOrderLine(row)">Delete</a></li><li ng-if = "grid.appScope.checkOrderLineStatus(row)"><a href="javascript:void(0);" ng-click="grid.appScope.PlanShipment(row)">Plan To Shipment</a></li></ul></div>'}

                    ],
                };

                $http({
                    method: 'GET',
                    url: '/order/getAllOrderLinesByOrders',
                    params: {orderNum: row.entity.order_number}
                })
                    .success(function (data) {
                        row.entity.subGridOptions.data = data;
                        for (var i = 0; i < data.length; i++) {
                            getInventoryLevelIcon(data[i].orderLineStatus, data[i].itemId, data[i].inventoryStatusOptionValue, data[i].orderedQuantity, data[i].orderedUOM, i, row);
                        }
                        ;
                    });


            });

            // interval of zero just to allow the directive to have initialized
            $interval(function () {
                gridApi.core.addToGridMenu(gridApi.grid, [{title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged($scope, function (changedColumn) {
                $scope.columnChanged = {name: changedColumn.colDef.name, visible: changedColumn.colDef.visible};
            });

            gridApi.selection.on.rowSelectionChanged($scope, function (row) {
                ctrl.selectedOrderLines = gridApi.selection.getSelectedRows();
                console.log(ctrl.selectedOrderLines);
            });

            gridApi.selection.on.rowSelectionChangedBatch($scope, function (rows) {
                ctrl.selectedOrderLines = [];
                ctrl.selectedOrderLines = gridApi.selection.getSelectedRows();
                console.log(ctrl.selectedOrderLines);
            });

        }
    };


    ctrl.searchPackout = function () {
        ctrl.packOutSearchResult = null;
        ctrl.packoutResultMsg = null;
        ctrl.showPackoutSearchError = false;
        ctrl.trackingNumberValidation = false;
        ctrl.viewUncompletedShipmentModal = false;
        ctrl.viewCompletedShipmentModal = false;
        //clearForm();
        $http({
            method: 'GET',
            params: {packoutId: ctrl.packOutIdForSearch},
            url: '/wave/getPackOutShipment'
        })
            .success(function (data) {
                if (data.shipment) {
                    ctrl.packOutSearchResult = data.shipment;
                    ctrl.carrierCode = data.shipment.carrierCode;
                    ctrl.serviceLevel = data.shipment.serviceLevel;
                    ctrl.trackingNumber = data.shipment.trackingNo;

                    if (data.shipment.shipmentStatus == 'COMPLETED') {
                        ctrl.packoutResultMsg = data.resultMessage;
                        //$('#viewCompletedShipmentModal').appendTo('body').modal('show');
                        ctrl.viewCompletedShipmentModal = true;
                    }
                    else {

                        // document.getElementById("shipContainerId").focus();

                        $http({
                            method: 'GET',
                            url: '/shipment/getPackoutShipmentContent',
                            params: {shipmentId: ctrl.packOutSearchResult.shipmentId}
                        })
                            .success(function (data) {
                                ctrl.packOutSearchResult.orderNumber = data[0].order_number;
                                ctrl.packOutSearchResult.noOfShipLines = data.length;
                                $scope.gridPackoutShipmentLine.data = data;
                                for (var i = 0; i < data.length; i++) {
                                    ctrl.showCloseout = true;
                                    ctrl.showConfirmAll = false;
                                    getActionsValidationData(data[i].shipment_line_id, i);
                                }


                                if (!ctrl.packOutSearchResult.shipmentNotes) {
                                    ctrl.packOutSearchResult.shipmentNotes = data[0].order_notes;
                                }

                                //$('#viewUncompletedShipmentModal').appendTo('body').modal('show');
                                ctrl.viewUncompletedShipmentModal = true;
                            });


                    }
                }
                else {
                    ctrl.showPackoutSearchError = true;
                    ctrl.packoutErrorMsg = data.resultMessage;
                    $timeout(function () {
                        ctrl.showPackoutSearchError = false;
                    }, 5200);
                }
                autoLoadContainerId();
            })
    };

    ctrl.printShippingLabel = function () {


        $http({
            method: 'GET',
            params: {
                printerName: ctrl.labelPrinterOptVal,
                shipmentId: ctrl.packOutSearchResult.shipmentId
            },
            url: '/wave/printShippingLabel'
        })
            .success(function (data) {

                for (i = 0; i < data.zplCodes.length; i++) {
                    w = window.open();
                    w.document.write(data.zplCodes[i]);
                    w.print();
                    w.close();
                }
            });


        $http({
            method: 'POST',
            url: '/easyPost/performEasyPostCall',
            params: {
                shippingAddressId: ctrl.packOutSearchResult.shippingAddressId,
                carrierCode: ctrl.carrierCode,
                serviceLevel: ctrl.serviceLevel,
                easyPostWeight: ctrl.packOutSearchResult.actualWeight,
                shipmentId: ctrl.packOutSearchResult.shipmentId
            },
            dataType: 'json',
            headers: {'Content-Type': 'application/json; charset=utf-8'}

        })
            .success(function (data) {
                if (data.isSuccess) {
                    $http({
                        method: 'POST',
                        url: '/shipping/updateShipmentWithEasyPostData',
                        params: {
                            shipmentId: ctrl.packOutSearchResult.shipmentId, easyPostLabel: data.easypost_label,
                            easyPostShipmentId: data.easyPostShipmentId, easyPostManifested: data.easyPostManifested,
                            trackingCode: data.trackingCode
                        },
                        dataType: 'json',
                        headers: {'Content-Type': 'application/json; charset=utf-8'}

                    })
                        .success(function (data) {

                            clearPackouField();
                            ctrl.viewUncompletedShipmentModal = false;

                            ctrl.showEasyPostManifestedPrompt = true;
                            $timeout(function () {
                                ctrl.showEasyPostManifestedPrompt = false;
                            }, 5000);


                        })

                }
                else {
                    ctrl.easyPostError = true;
                    ctrl.easyPostErrorMsg = data.message;
                    $('#packageWeightModel').modal('hide');
                    $('#easyPostErrorModal').appendTo("body").modal('show');
                }
            })
            .finally(function () {
                // ctrl.disablemanifestBtn = false;
                // ctrl.ePManifestText = 'Confirm';
            });


    }

    var autoLoadContainerId = function () {
        $http({
            method: 'GET',
            url: '/company/getCurrentUserCompany',
        })

            .success(function (data) {

                if (data.isAutoLoadPackoutContainer == true) {
                    var containerIdValue = alphanumericGenerator().toUpperCase();
                    $http({
                        method: 'GET',
                        url: '/wave/checkValidContainerId',
                        params: {shipmentContainerId: containerIdValue, shipmentId: ctrl.packOutSearchResult.shipmentId}
                    })
                        .success(function (data) {
                            if (data.results == true) {
                                ctrl.shipContainerId = containerIdValue;
                            }
                            else {
                                autoLoadContainerId()
                            }
                        });
                }
                else {
                    ctrl.receiveInventoryPalletId = null;
                }

            });
    }

    var alphanumericGenerator = function () {
        return Math.random().toString(36).split('').filter(function (value, index, self) {
            return self.indexOf(value) === index;
        }).join('').substr(2, 10);
    }


    $scope.confirmShipmentLine = function (row) {
        ctrl.confirmPackoutShipForm.$setSubmitted();
        ctrl.confirmPackoutShipForm.shipContainerId.$setValidity('containerIdValid', true);
        if (ctrl.confirmPackoutShipForm.$valid) {


            $http({
                method: 'GET',
                url: '/wave/checkValidContainerId',
                params: {shipmentContainerId: ctrl.shipContainerId, shipmentId: ctrl.packOutSearchResult.shipmentId}
            })
                .success(function (data) {
                    if (data.results == true) {
                        ctrl.confirmPackoutShipForm.shipContainerId.$setValidity('containerIdValid', true);
                        $http({
                            method: 'POST',
                            url: '/wave/confirmShipmentLine',
                            params: {
                                shipmentLineId: row.entity.shipment_line_id,
                                shipmentContainerId: ctrl.shipContainerId
                            },
                            dataType: 'json',
                            headers: {'Content-Type': 'application/json; charset=utf-8'}
                        })
                            .success(function (data) {

                                //alert("Confirmed!");
                                ctrl.showShipConfirmSuccessPrompt = true;
                                $timeout(function () {
                                    ctrl.showShipConfirmSuccessPrompt = false;
                                }, 10000);
                                ctrl.searchPackout();

                            })
                    } else {
                        ctrl.confirmPackoutShipForm.shipContainerId.$setValidity('containerIdValid', false);
                    }

                });
        }


    };


    $scope.unConfirmShipmentLine = function (row) {

        $http({
            method: 'POST',
            url: '/wave/unConfirmShipmentLine',
            params: {
                shipmentLineId: row.entity.shipment_line_id
            },
            dataType: 'json',
            headers: {'Content-Type': 'application/json; charset=utf-8'}
        })
            .success(function (data) {

                //alert("Unconfirmed");
                ctrl.showShipUnConfirmSuccessPrompt = true;
                $timeout(function () {
                    ctrl.showShipUnConfirmSuccessPrompt = false;
                }, 10000);
                ctrl.searchPackout();
                ctrl.searchPackout();

            })


    };

    var clearPackouField = function () {
        ctrl.packOutSearchResult = {};
        ctrl.shipContainerId = '';
        ctrl.carrierCode = '';
        ctrl.serviceLevel = '';
        ctrl.trackingNumber = '';
    }

    ctrl.closeOutShipment = function () {
        if (ctrl.trackingNumber) {
            $http({
                method: 'POST',
                url: '/wave/closeoutShipment',
                params: {
                    shipmentId: ctrl.packOutSearchResult.shipmentId,
                    orderNumber: ctrl.packOutSearchResult.orderNumber,
                    carrierCode: ctrl.carrierCode,
                    serviceLevel: ctrl.serviceLevel,
                    trackingNumber: ctrl.trackingNumber
                },
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}
            })
                .success(function (data) {

                    //alert("Closeout");
                    clearPackouField();
                    ctrl.viewUncompletedShipmentModal = false;
                    ctrl.showShipCloseSuccessPrompt = true;
                    $timeout(function () {
                        ctrl.showShipCloseSuccessPrompt = false;
                    }, 10000);
                    //$('#viewUncompletedShipmentModal').appendTo('body').modal('hide');

                })

        }
        else {
            ctrl.trackingNumberValidation = true;
        }

    }

    ctrl.confirmAllShipmentLines = function () {
        ctrl.confirmPackoutShipForm.$setSubmitted();
        ctrl.confirmPackoutShipForm.shipContainerId.$setValidity('containerIdValid', true);
        if (ctrl.confirmPackoutShipForm.$valid) {

            $http({
                method: 'GET',
                url: '/wave/checkValidContainerId',
                params: {shipmentContainerId: ctrl.shipContainerId, shipmentId: ctrl.packOutSearchResult.shipmentId}
            })
                .success(function (data) {
                    if (data.results == true) {
                        ctrl.confirmPackoutShipForm.shipContainerId.$setValidity('containerIdValid', true);

                        $http({
                            method: 'POST',
                            url: '/wave/confirmAllShipmentLines',
                            params: {
                                shipmentId: ctrl.packOutSearchResult.shipmentId,
                                shipmentContainerId: ctrl.shipContainerId
                            },
                            dataType: 'json',
                            headers: {'Content-Type': 'application/json; charset=utf-8'}
                        })
                            .success(function (data) {

                                // alert("ConfirmedAll");
                                ctrl.showShipConfirmSuccessPrompt = true;
                                ctrl.shipContainerId = "";
                                $timeout(function () {
                                    ctrl.showShipConfirmSuccessPrompt = false;
                                }, 10000);
                                ctrl.searchPackout();

                            })

                    }
                    else {
                        ctrl.confirmPackoutShipForm.shipContainerId.$setValidity('containerIdValid', false);
                    }
                });
        }

    }


    var getActionsValidationData = function (shipmentLineId, index) {

        var hide

        $http({
            method: 'GET',
            url: '/wave/displayPackoutConfirm',
            params: {shipmentLineId: shipmentLineId}
        })
            .success(function (data) {
                $scope.gridPackoutShipmentLine.data[index].isPackoutConfirm = data.results;

                if (data.results == true) {
                    ctrl.showConfirmAll = true
                }

            });

        $http({
            method: 'GET',
            url: '/wave/displayPackoutUnconfirm',
            params: {shipmentLineId: shipmentLineId}
        })
            .success(function (result) {
                $scope.gridPackoutShipmentLine.data[index].isPackoutUnConfirm = result.results;

                if (result.results == false) {
                    ctrl.showCloseout = false;
                }
            });
    };


    $scope.gridPackoutShipmentLine = {
        //rowHeight:100,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
        exporterPdfHeader: {text: headerTitle, style: 'headerStyle'},
        exporterPdfFooter: function (currentPage, pageCount) {
            return {text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle'};
        },
        exporterPdfCustomFormatter: function (docDefinition) {
            docDefinition.styles.headerStyle = {fontSize: 15, bold: true, margin: 20};
            //docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
            return docDefinition;
        },
        exporterPdfOrientation: 'portrait',
        exporterPdfPageSize: 'LETTER',
        exporterPdfMaxGridWidth: 500,

        columnDefs: [
            {name: 'Order Line Number', field: 'display_order_line_number'},
            {name: 'Item Id', field: 'item_id'},
            {name: 'Description', field: 'item_description'},
            {name: 'Quantity', field: 'shipped_quantity'},
            {name: 'UOM', field: 'shippeduom'},
            {name: 'Pick Status', field: 'pick_status'},
            {
                name: 'Actions',
                enableSorting: false,
                cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button type = "button" class="btn btn-xs btn-primary startPickBtn" style="padding: 0px 10px !important; margin: 2px 10px 0px 10px;" ng-if="row.entity.isPackoutConfirm" ng-click = "grid.appScope.confirmShipmentLine(row)">CONFIRM</button><button type = "button" class="btn btn-xs btn-primary startPickBtn" style="padding: 0px 10px !important; margin: 2px 10px 0px 10px;" ng-if="row.entity.isPackoutUnConfirm" ng-click = "grid.appScope.unConfirmShipmentLine(row)">UNCONFIRM</button></div>'
            }
        ],

        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;

            // interval of zero just to allow the directive to have initialized
            $interval(function () {
                gridApi.core.addToGridMenu(gridApi.grid, [{title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged($scope, function (changedColumn) {
                $scope.columnChanged = {name: changedColumn.colDef.name, visible: changedColumn.colDef.visible};
            });
        }
    };


    // var loadGridData = function (){
    //     $http({
    //         method: 'GET',
    //         url: '/printer/getPrinterDataByCompanyId'
    //     })
    //         .success(function (data) {
    //             $scope.gridPrinters.data = data.splice(0,10000);

    //         })
    // };
    //loadGridData();

//end of the grid

    //end multi combo box list items

    //end search

    ctrl.itemIdUniqueValidation = function (viewValue) {
        $http({
            method: 'GET',
            url: '/item/checkItemIdExist',
            params: {itemId: viewValue}
        })
            .success(function (data, status, headers, config) {

                if (data.length == 0) {
                    ctrl.createItemForm.itemId.$setValidity('itemIdExists', true);
                }
                else {
                    ctrl.createItemForm.itemId.$setValidity('itemIdExists', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.createItemForm.itemId.$setValidity('itemIdExists', false);
            });
    };

    ctrl.casesPerPalletZeroValidation = function (viewValue, field) {
        if (parseInt(viewValue) == 0) {
            ctrl.createItemForm['casesPerPallet'].$setValidity('isZeroCasesPerPallet', false);
        }
        else {
            ctrl.createItemForm['casesPerPallet'].$setValidity('isZeroCasesPerPallet', true);
        }
    };

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
                        method: 'GET',
                        url: '/item/checkItemIdExist',
                        params: {itemId: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if (data.length == 0) {
                                ctrl.$setValidity('itemIdExists', true);
                            }
                            else {
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
                        method: 'GET',
                        url: '/location/checkLocationBarcodeExist',
                        params: {locationBarcode: viewValue, locationId: locationBarcodecheck}
                    })
                        .success(function (data, status, headers, config) {

                            if (data.length == 0) {
                                ctrl.$setValidity('locationBarcodeExists', true);
                            }
                            else {
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
    .directive('capitalize', function () {
        return {
            require: 'ngModel',
            link: function (scope, element, attrs, modelCtrl) {
                var capitalize = function (inputValue) {
                    if (inputValue == undefined) inputValue = '';
                    var capitalized = inputValue.toUpperCase();
                    if (capitalized !== inputValue) {
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


    // start multi combo box

    .directive('ngDropdownMultiselect', ['$filter', '$document', '$compile', '$parse',

        function ($filter, $document, $compile, $parse) {

            return {
                restrict: 'AE',
                scope: {
                    selectedModel: '=',
                    options: '=',
                    extraSettings: '=',
                    events: '=',
                    searchFilter: '=?',
                    translationTexts: '=',
                    groupBy: '@'
                },
                template: function (element, attrs) {
                    var checkboxes = attrs.checkboxes ? true : false;
                    var groups = attrs.groupBy ? true : false;

                    var template = '<div class="multiselect-parent btn-group dropdown-multiselect" style="margin-bottom: 0px; margin-top: 0px;">';
                    template += '<button type="button" class="dropdown-toggle" ng-class="settings.buttonClasses" ng-click="toggleDropdown()" style="width: 485.41px; height: 37px; margin-bottom: 0px;font-size: 14px;">{{getButtonText()}}&nbsp;<span class="caret" ></span></button>';
                    template += '<ul class="dropdown-menu dropdown-menu-form" ng-style="{display: open ? \'block\' : \'none\', height : settings.scrollable ? settings.scrollableHeight : \'auto\' }" style="overflow: scroll; width:300px;" >';
                    template += '<li ng-hide="!settings.showCheckAll || settings.selectionLimit > 0"><a data-ng-click="selectAll()"><span class="glyphicon glyphicon-ok"></span>  {{texts.checkAll}}</a>';
                    template += '<li ng-show="settings.showUncheckAll"><a data-ng-click="deselectAll();"><span class="glyphicon glyphicon-remove"></span>   {{texts.uncheckAll}}</a></li>';
                    template += '<li ng-hide="(!settings.showCheckAll || settings.selectionLimit > 0) && !settings.showUncheckAll" class="divider"></li>';
                    template += '<li ng-show="settings.enableSearch"><div class="dropdown-header"><input type="text" class="form-control" style="width: 100%; margin-bottom: 0px; margin-top: 0px;" ng-model="searchFilter" placeholder="{{texts.searchPlaceholder}}" /></li>';
                    template += '<li ng-show="settings.enableSearch" class="divider"></li>';

                    if (groups) {
                        template += '<li ng-repeat-start="option in orderedItems | filter: searchFilter" ng-show="getPropertyForObject(option, settings.groupBy) !== getPropertyForObject(orderedItems[$index - 1], settings.groupBy)" role="presentation" class="dropdown-header">{{ getGroupTitle(getPropertyForObject(option, settings.groupBy)) }}</li>';
                        template += '<li ng-repeat-end role="presentation">';
                    } else {
                        template += '<li role="presentation" ng-repeat="option in options | filter: searchFilter">';
                    }

                    template += '<a role="menuitem" tabindex="-1" ng-click="setSelectedItem(getPropertyForObject(option,settings.idProp))">';

                    if (checkboxes) {
                        template += '<div class="checkbox" style="margin-bottom: 0px; margin-top: 0px;"><label><input class="checkboxInput" type="checkbox" ng-click="checkboxClick($event, getPropertyForObject(option,settings.idProp))" ng-checked="isChecked(getPropertyForObject(option,settings.idProp))" /> {{getPropertyForObject(option, settings.displayProp)}}</label></div></a>';
                    } else {
                        template += '<span data-ng-class="{\'glyphicon glyphicon-ok\': isChecked(getPropertyForObject(option,settings.idProp))}"></span> {{getPropertyForObject(option, settings.displayProp)}}</a>';
                    }

                    template += '</li>';

                    template += '<li class="divider" ng-show="settings.selectionLimit > 1"></li>';
                    template += '<li role="presentation" ng-show="settings.selectionLimit > 1"><a role="menuitem">{{selectedModel.length}} {{texts.selectionOf}} {{settings.selectionLimit}} {{texts.selectionCount}}</a></li>';

                    template += '</ul>';
                    template += '</div>';

                    element.html(template);
                },
                link: function ($scope, $element, $attrs) {
                    var $dropdownTrigger = $element.children()[0];

                    $scope.toggleDropdown = function () {
                        $scope.open = !$scope.open;
                    };

                    $scope.checkboxClick = function ($event, configValue) {
                        $scope.setSelectedItem(configValue);
                        $event.stopImmediatePropagation();
                    };

                    $scope.externalEvents = {
                        onItemSelect: angular.noop,
                        onItemDeselect: angular.noop,
                        onSelectAll: angular.noop,
                        onDeselectAll: angular.noop,
                        onInitDone: angular.noop,
                        onMaxSelectionReached: angular.noop
                    };

                    $scope.settings = {
                        dynamicTitle: true,
                        scrollable: false,
                        scrollableHeight: '300px',
                        closeOnBlur: true,
                        displayProp: 'optionValue',
                        idProp: 'optionValue',
                        externalIdProp: 'configValue',
                        enableSearch: false,
                        selectionLimit: 0,
                        showCheckAll: true,
                        showUncheckAll: true,
                        closeOnSelect: false,
                        buttonClasses: 'btn btn-default',
                        closeOnDeselect: false,
                        groupBy: $attrs.groupBy || undefined,
                        groupByTextProvider: null,
                        smartButtonMaxItems: 0,
                        smartButtonTextConverter: angular.noop
                    };

                    $scope.texts = {
                        checkAll: 'Check All',
                        uncheckAll: 'Uncheck All',
                        selectionCount: 'checked',
                        selectionOf: '/',
                        searchPlaceholder: 'Search...',
                        buttonDefaultText: 'Select Storage Attributes',
                        dynamicButtonTextSuffix: 'checked'
                    };

                    $scope.searchFilter = $scope.searchFilter || '';

                    if (angular.isDefined($scope.settings.groupBy)) {
                        $scope.$watch('options', function (newValue) {
                            if (angular.isDefined(newValue)) {
                                $scope.orderedItems = $filter('orderBy')(newValue, $scope.settings.groupBy);
                            }
                        });
                    }

                    angular.extend($scope.settings, $scope.extraSettings || []);
                    angular.extend($scope.externalEvents, $scope.events || []);
                    angular.extend($scope.texts, $scope.translationTexts);

                    $scope.singleSelection = $scope.settings.selectionLimit === 1;

                    function getFindObj(configValue) {
                        var findObj = {};

                        if ($scope.settings.externalIdProp === '') {
                            findObj[$scope.settings.idProp] = configValue;
                        } else {
                            findObj[$scope.settings.externalIdProp] = configValue;
                        }

                        return findObj;
                    }

                    function clearObject(object) {
                        for (var prop in object) {
                            delete object[prop];
                        }
                    }

                    if ($scope.singleSelection) {
                        if (angular.isArray($scope.selectedModel) && $scope.selectedModel.length === 0) {
                            clearObject($scope.selectedModel);
                        }
                    }

                    if ($scope.settings.closeOnBlur) {
                        $document.on('click', function (e) {
                            var target = e.target.parentElement;
                            var parentFound = false;

                            while (angular.isDefined(target) && target !== null && !parentFound) {
                                if (_.contains(target.className.split(' '), 'multiselect-parent') && !parentFound) {
                                    if (target === $dropdownTrigger) {
                                        parentFound = true;
                                    }
                                }
                                target = target.parentElement;
                            }

                            if (!parentFound) {
                                $scope.$apply(function () {
                                    $scope.open = false;
                                });
                            }
                        });
                    }

                    $scope.getGroupTitle = function (groupValue) {
                        if ($scope.settings.groupByTextProvider !== null) {
                            return $scope.settings.groupByTextProvider(groupValue);
                        }

                        return groupValue;
                    };

                    $scope.getButtonText = function () {
                        if ($scope.settings.dynamicTitle && ($scope.selectedModel.length > 0 || (angular.isObject($scope.selectedModel) && _.keys($scope.selectedModel).length > 0))) {
                            if ($scope.settings.smartButtonMaxItems > 0) {
                                var itemsText = [];

                                angular.forEach($scope.options, function (optionItem) {
                                    if ($scope.isChecked($scope.getPropertyForObject(optionItem, $scope.settings.idProp))) {
                                        var displayText = $scope.getPropertyForObject(optionItem, $scope.settings.displayProp);
                                        var converterResponse = $scope.settings.smartButtonTextConverter(displayText, optionItem);

                                        itemsText.push(converterResponse ? converterResponse : displayText);
                                    }
                                });

                                if ($scope.selectedModel.length > $scope.settings.smartButtonMaxItems) {
                                    itemsText = itemsText.slice(0, $scope.settings.smartButtonMaxItems);
                                    itemsText.push('...');
                                }

                                return itemsText.join(', ');
                            } else {
                                var totalSelected;

                                if ($scope.singleSelection) {
                                    totalSelected = ($scope.selectedModel !== null && angular.isDefined($scope.selectedModel[$scope.settings.idProp])) ? 1 : 0;
                                } else {
                                    totalSelected = angular.isDefined($scope.selectedModel) ? $scope.selectedModel.length : 0;
                                }

                                if (totalSelected === 0) {
                                    return $scope.texts.buttonDefaultText;
                                } else {
                                    return totalSelected + ' ' + $scope.texts.dynamicButtonTextSuffix;
                                }
                            }
                        } else {
                            return $scope.texts.buttonDefaultText;
                        }
                    };

                    $scope.getPropertyForObject = function (object, property) {
                        if (angular.isDefined(object) && object.hasOwnProperty(property)) {
                            return object[property];
                        }

                        return '';
                    };

                    $scope.selectAll = function () {
                        $scope.deselectAll(false);
                        $scope.externalEvents.onSelectAll();

                        angular.forEach($scope.options, function (value) {
                            $scope.setSelectedItem(value[$scope.settings.idProp], true);
                        });
                    };

                    $scope.deselectAll = function (sendEvent) {
                        sendEvent = sendEvent || true;

                        if (sendEvent) {
                            $scope.externalEvents.onDeselectAll();
                        }

                        if ($scope.singleSelection) {
                            clearObject($scope.selectedModel);
                        } else {
                            $scope.selectedModel.splice(0, $scope.selectedModel.length);
                        }
                    };

                    $scope.setSelectedItem = function (configValue, dontRemove) {
                        var findObj = getFindObj(configValue);
                        var finalObj = null;

                        if ($scope.settings.externalIdProp === '') {
                            finalObj = _.find($scope.options, findObj);
                        } else {
                            finalObj = findObj;
                        }

                        if ($scope.singleSelection) {
                            clearObject($scope.selectedModel);
                            angular.extend($scope.selectedModel, finalObj);
                            $scope.externalEvents.onItemSelect(finalObj);
                            if ($scope.settings.closeOnSelect) $scope.open = false;

                            return;
                        }

                        dontRemove = dontRemove || false;

                        var exists = _.findIndex($scope.selectedModel, findObj) !== -1;

                        if (!dontRemove && exists) {
                            $scope.selectedModel.splice(_.findIndex($scope.selectedModel, findObj), 1);
                            $scope.externalEvents.onItemDeselect(findObj);
                        } else if (!exists && ($scope.settings.selectionLimit === 0 || $scope.selectedModel.length < $scope.settings.selectionLimit)) {
                            $scope.selectedModel.push(finalObj);
                            $scope.externalEvents.onItemSelect(finalObj);
                        }
                        if ($scope.settings.closeOnSelect) $scope.open = false;
                    };

                    $scope.isChecked = function (configValue) {
                        if ($scope.singleSelection) {
                            return $scope.selectedModel !== null && angular.isDefined($scope.selectedModel[$scope.settings.idProp]) && $scope.selectedModel[$scope.settings.idProp] === getFindObj(configValue)[$scope.settings.idProp];
                        }

                        return _.findIndex($scope.selectedModel, getFindObj(configValue)) !== -1;
                    };

                    $scope.externalEvents.onInitDone();
                }
            };
        }])


    // end multi combo box


    //
    .filter('phoneListFilter', function () {
        return function (viewValue) {

            $http({
                method: 'GET',
                url: '/item/getItemEntityAttributeForSearchRow',
                params: {selectedRowItem: viewValue}
            })
                .success(function (data) {

                    //var info = [];
                    //if(data.length > 0){
                    //
                    //    for (i = 0; i < data.length; i++) {
                    //        info.push(data[i].config_value);
                    //
                    //    }
                    //}
                    ////ctrl.configValue = info;
                    //return info;


                    var telePhoneArray = [];

                    for (var i in config_value) {
                        telePhoneArray.push(data[i].config_value);
                    }
                    return telePhoneArray.join(',');
                    return viewValue

                });

        };
    })
//


;




