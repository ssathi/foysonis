/**
 * Created by home on 9/10/15.
 */

var app = angular.module('waveApp', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.bootstrap', 'ui.grid.pagination', 'ui.grid.expandable', 'ui.grid.resizeColumns', 'ui.grid.autoResize', 'inventory-autocomplete', 'ngLocale']);

app.controller('WaveCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

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

    var showEarlyShipDateRange = function () {
        ctrl.displayEarlyShipDateRange = ctrl.earlyShipDateRange
    };

    var showLateShipDateRange = function () {
        ctrl.displayLateShipDateRange = ctrl.LateShipDateRange
    };

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

    ctrl.clearCustomerSearchText = function () {
        ctrl.customer = '';
        ctrl.customerId = '';
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
                    ctrl.searchWaveNumbers();
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


    $scope.removeOrderFromWave = function (row) {
        ctrl.orderRowData = row;
        ctrl.orderNumForWaveRemove = row.entity.order_number;
        $('#removeOrderFromWave').appendTo('body').modal('show');
    };

    $("#removeOrderBtn").click(function () { 
        $http({
            method: 'POST',
            url: '/wave/removeOrderFromWave',
            params: {
                orderNumber: ctrl.orderRowData.entity.order_number
            },
            dataType: 'json',
            headers: {'Content-Type': 'application/json; charset=utf-8'}
        })
            .success(function (data) {

                if (data.waveCanceled == true) {
                    $('#viewWaveDetailsModal').appendTo('body').modal('hide');
                    ctrl.showWaveCancelledPrompt = true;
                    var index = $scope.gridWaveNumbers.data.indexOf(ctrl.waveDataForCancel);
                    $scope.gridWaveNumbers.data.splice(index, 1);
                    $timeout(function () {
                        ctrl.showWaveCancelledPrompt = false;
                    }, 5200);
                }

                else if (data.orderRemoved == true) {
                    ctrl.showEditPrompt = true;
                    ctrl.waveEditStatusMsg = "Order, " + ctrl.orderRowData.entity.order_number + " has been successfully removed from the wave."
                    var index = $scope.gridWaveOrdersForEdit.data.indexOf(ctrl.orderRowData.entity);
                    $scope.gridWaveOrdersForEdit.data.splice(index, 1);
                    $timeout(function () {
                        ctrl.showEditPrompt = false;
                    }, 5200);
                }
                $('#removeOrderFromWave').modal('hide');
                ctrl.searchWaveNumbers();

            })
    });

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
                        }

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


    $scope.gridWaveOrdersForEdit = {
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
            {
                name: 'Actions',
                enableSorting: false,
                cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button type = "button" class="btn btn-xs btn-primary startPickBtn" style="padding: 0px 10px !important; margin: 2px 10px 0px 10px;"  ng-click = "grid.appScope.removeOrderFromWave(row)">Remove from Wave</button></div>'
            }
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
                        }

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


    ctrl.searchWaveNumbers = function () {
        //clearForm();
        $http({
            method: 'POST',
            params: {waveNumber: ctrl.waveNumberForSearch, waveStatus: ctrl.waveStatusForSearch},
            url: '/wave/getAllWaveNumbers'
        })
            .success(function (data) {
                $scope.gridWaveNumbers.data = data;
            })
    };
    ctrl.searchWaveNumbers();

    ctrl.allocateWaveObj = {};
    $scope.allocateWave = function (row) {
        ctrl.allocateWaveObj.waveNumber = row.entity.wave_number;
        $http({
            method: 'GET',
            params: {waveNumber: row.entity.wave_number},
            url: '/wave/getAllShipmentAndLinesCountData'
        })
            .success(function (data) {
                ctrl.allocateWaveObj.totalShipmentCount = data.total_shipment_count;
                ctrl.allocateWaveObj.totalLineCount = data.total_shipment_line_count;
            })

        $http({
            method: 'GET',
            url: '/printer/getAllLabelPrinters'
        })
            .success(function (data) {
                ctrl.labelPrinterList = data;
            })

        $http({
            method: 'GET',
            url: '/printer/getAllRegularPrinters'
        })
            .success(function (data) {
                ctrl.regularPrinterList = data;
            })
        $('#allocateWave').appendTo('body').modal('show');

    };

    ctrl.saveWaveAllocation = function () {

        if (ctrl.allocateWaveForm.$valid) {
            $http({
                method: 'POST',
                url: '/wave/prepareWaveAllocation',
                data: $scope.ctrl.allocateWaveObj,
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}  // set the headers so angular passing //info as form data (not request payload)
            })
                .success(function (data, status, headers, config) {
                    $('#allocateWave').modal('hide');
                    ctrl.waveNumberForMessageAllocated = ctrl.allocateWaveObj.waveNumber;
                    ctrl.allocationStatusMsg = data.confirmationMessage;

                    if(data.status == true){
                        ctrl.showFailedWaveAllocatedPrompt = false;
                        ctrl.showWaveAllocatedPrompt = true;
                        $timeout(function () {
                            ctrl.showWaveAllocatedPrompt = false;
                        }, 5200);


                        // Print Pick Tickets
                        if(ctrl.allocateWaveObj.printPickTickets == true){
                            $http({
                                method: 'GET',
                                url: '/shipment/getWaveShipments',
                                params: {waveNumber: ctrl.allocateWaveObj.waveNumber}
                            })
                                .success(function (data) {

                                    for (var i = 0; i < data.length; i++) {
                                        ctrl.printShippingLabel(ctrl.allocateWaveObj.labelPrinter, data[i].shipmentId, ctrl.allocateWaveObj.pickTicketsPrintedBy)
                                    }


                                });
                        }

                        // Print Pick List
                        if(ctrl.allocateWaveObj.PrintPickLists == true){
                            $http({
                                method: 'GET',
                                url: '/picking/getWavePickWorks',
                                params: {waveNumber: ctrl.allocateWaveObj.waveNumber}
                            })
                                .success(function (data) {

                                    if(data.length > 0){
                                        var pickListId = data[0].pickListId;
                                        $scope.printPickListReport(pickListId);
                                    }


                                });
                        }


                    }
                    else{
                        ctrl.showWaveAllocatedPrompt = false;
                        ctrl.showFailedWaveAllocatedPrompt = true;
                        $timeout(function () {
                            ctrl.showFailedWaveAllocatedPrompt = false;
                        }, 5200);
                    }
                    ctrl.searchWaveNumbers();

                });
        }

    }


    $scope.rePrintWave = function (row) {
        ctrl.allocateWaveObj.waveNumber = row.entity.wave_number;
        $http({
            method: 'GET',
            params: {waveNumber: row.entity.wave_number},
            url: '/wave/getAllShipmentAndLinesCountData'
        })
            .success(function (data) {
                ctrl.allocateWaveObj.totalShipmentCount = data.total_shipment_count;
                ctrl.allocateWaveObj.totalLineCount = data.total_shipment_line_count;
            })

        $http({
            method: 'GET',
            url: '/printer/getAllLabelPrinters'
        })
            .success(function (data) {
                ctrl.labelPrinterList = data;
            })

        $http({
            method: 'GET',
            url: '/printer/getAllRegularPrinters'
        })
            .success(function (data) {
                ctrl.regularPrinterList = data;
            })
        $('#rePrintWaveModal').appendTo('body').modal('show');

    };


    ctrl.printLabelOrList = function () {

        // Print Pick Tickets
        $('#rePrintWaveModal').modal('hide');
        if(ctrl.allocateWaveObj.printPickTickets == true){
            $http({
                method: 'GET',
                url: '/shipment/getWaveShipments',
                params: {waveNumber: ctrl.allocateWaveObj.waveNumber}
            })
                .success(function (data) {

                    for (var i = 0; i < data.length; i++) {
                        ctrl.printShippingLabel(ctrl.allocateWaveObj.labelPrinter, data[i].shipmentId, ctrl.allocateWaveObj.pickTicketsPrintedBy)
                    }


                });
        }

        // Print Pick List
        if(ctrl.allocateWaveObj.PrintPickLists == true){
            $http({
                method: 'GET',
                url: '/picking/getWavePickWorks',
                params: {waveNumber: ctrl.allocateWaveObj.waveNumber}
            })
                .success(function (data) {

                    if(data.length > 0){
                        var pickListId = data[0].pickListId;
                        $scope.printPickListReport(pickListId);
                    }


                });
        }

    }

    ctrl.printShippingLabel = function (labelPrinter, shipmentId, pickTicketPrintOption) {
        // alert(ctrl.labelPrinterOptVal);


        $http({
            method: 'GET',
            params: {
                printerName: labelPrinter,
                shipmentId: shipmentId,
                pickTicketPrintOption: pickTicketPrintOption
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

    }

    $scope.printPickListReport = function (pickListId) {
        var format = 'PDF';
        var file = 'pickListReport';
        var accessType = 'inline';
        ctrl.pickListReportSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType;
        ctrl.pickListReportSrcStrg += "&pickListId="+pickListId;    
        $('#pickListReport').appendTo("body").modal('show');

    };  


    $scope.cancelWave = function (row) {
        ctrl.waveDataForCancel = row.entity;
        ctrl.waveNumberForMessageEdit = row.entity.wave_number;
        $('#cancelWaveWarnModal').appendTo('body').modal('show');
    }

    ctrl.isEditWave = false;
    $scope.editWave = function (row) {

        ctrl.isEditWave = true;
        ctrl.selectedWaveNumber = row.entity.wave_number;

        $http({
            method: 'POST',
            url: '/wave/searchOrderForEditWave',
            params: {waveNumber: row.entity.wave_number}
        })
            .success(function (data) {
                $('#viewWaveDetailsModal').appendTo('body').modal('show');
                $scope.gridWaveOrdersForEdit.data = data;
            })


    }

    ctrl.closeEditWaveModel = function () {
        ctrl.isEditWave = false;
        //ctrl.allocateWaveObj = {}; 
        $('#viewWaveDetailsModal').modal('hide');
    }

    $("#cancelWaveBtn").click(function () { //finction to delete after validation.

        $http({
            method: 'POST',
            url: '/wave/cancelWave',
            params: {waveNumber: ctrl.waveDataForCancel.wave_number},
            dataType: 'json',
            headers: {'Content-Type': 'application/json; charset=utf-8'}  // set the headers so angular passing //info as form data (not request payload)
        })
            .success(function (data, status, headers, config) {
                $('#cancelWaveWarnModal').modal('hide');
                ctrl.waveNumberForMessageEdit = ctrl.waveDataForCancel.wave_number;
                ctrl.showWaveCancelledPrompt = true;
                var index = $scope.gridWaveNumbers.data.indexOf(ctrl.waveDataForCancel);
                $scope.gridWaveNumbers.data.splice(index, 1);
                $timeout(function () {
                    ctrl.showWaveCancelledPrompt = false;
                }, 5200);

            });
    });

    $scope.viewWaveDetails = function (row) {
        $http({
            method: 'GET',
            url: '/wave/getAllOrdersDataForViewDetails',
            params: {waveNumber: row.entity.wave_number}
        })
            .success(function (data) {
                ctrl.selectedWaveNumber = row.entity.wave_number;
                $('#viewWaveDetailsModal').appendTo('body').modal('show');
                $scope.gridWaveOrdersForDetails.data = data;
            })
    };

    $scope.gridWaveNumbers = {
        //rowHeight:100,
        expandableRowTemplate: "<div id='receiptLineGrid' ui-grid='row.entity.subGridOptions' ui-grid-pagination style='height:220px;'></div>",
        expandableRowHeight: 260,
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
            {name: 'Wave Number', field: 'wave_number'},
            {name: 'Status', field: 'wave_status'},
            {
                name: 'Actions',
                enableSorting: false,
                cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a ng-if = "row.entity.wave_status == \'PLANNED\'" href="javascript:void(0);" ng-click="grid.appScope.allocateWave(row)">Allocate Wave</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.editWave(row)" ng-if = "row.entity.wave_status == \'PLANNED\' || row.entity.wave_status == \'ALLOCATED\' || row.entity.wave_status == \'PARTIALLY ALLOCATED\'">Edit Wave</a></li><li><a ng-if = "row.entity.wave_status == \'PLANNED\'"  href="javascript:void(0);" ng-click="grid.appScope.cancelWave(row)">Cancel Wave</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.viewWaveDetails(row)">View Details</a></li><li><a ng-if = "row.entity.wave_status == \'PARTIALLY ALLOCATED\'" href="javascript:void(0);" ng-click="grid.appScope.allocateWave(row)">Allocate Remaining</a></li><li><a ng-if = "row.entity.wave_status == \'ALLOCATED\'" href="javascript:void(0);" ng-click="grid.appScope.allocateWave(row)">Reallocate Wave</a></li><li><a ng-if = "row.entity.wave_status != \'PLANNED\'" href="javascript:void(0);" ng-click="grid.appScope.rePrintWave(row)">Re-Print Wave</a></li></ul></div>'
            }
        ],

        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;

            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {

                row.entity.subGridOptions = {
                    appScopeProvider: $scope.subGridScope,

                    columnDefs: [
                        {name: 'Order Number', field: 'order_number'},
                        {name: 'Number Of Lines', field: 'total_order_lines'},
                        {name: 'Number Of Units', field: 'total_no_Of_uom'},
                        {name: 'Customer Name', field: 'customer_name'}

                    ],
                    paginationPageSizes: [10],
                    paginationPageSize: 10,
                };

                $http({
                    method: 'GET',
                    url: '/wave/getAllOrdersDataByWaveNumbers',
                    params: {waveNum: row.entity.wave_number}
                })
                    .success(function (data) {
                        row.entity.subGridOptions.data = data;
                    });


            });

            // interval of zero just to allow the directive to have initialized
            $interval(function () {
                gridApi.core.addToGridMenu(gridApi.grid, [{title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged($scope, function (changedColumn) {
                $scope.columnChanged = {name: changedColumn.colDef.name, visible: changedColumn.colDef.visible};
            });
        }
    };


    $scope.gridWaveOrdersForDetails = {
         expandableRowTemplate: "<div id='receiptLineGrid' ui-grid='row.entity.subGridOptions' style='height:250px;'></div>",
        expandableRowHeight: 250,
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
            {name: 'Order Number', field: 'order_number'},
            {name: 'Number of Lines', field: 'total_order_lines'},
            {name: 'Number of Units', field: 'total_no_Of_uom'},
            {
                name: 'Allocation Status',
                cellTemplate: '<span ng-if="row.entity.allocation_status==\'YES\'" style="color: GREEN; padding: 10px; " class="fa fa-check"></span><span ng-if="row.entity.allocation_status==\'NO\' && row.entity.allocation_failed_message" style="color: RED; padding: 10px; " class="fa fa-close"></span>'
            },
            {
                name: 'Allocation Failed Message',
                cellTemplate: '<button  class="btn btn-xs btn-primary" style="padding: 2px 2px !important; margin: 2px 10px 0px 10px;" ng-if="row.entity.allocation_status==\'NO\' && row.entity.allocation_failed_message" ng-click="grid.appScope.viewAllocationFailedMsg(row)">View Message</button>'
            }
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
                        }

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
        }
    };


    $scope.viewAllocationFailedMsg = function (row) {
        $http({
            method: 'GET',
            url: '/stagingLaneShipment/getFailedMessageByShipmentForView',
            params: {shipmentId: row.entity.shipment_id}
        })

            .success(function (data) {
                ctrl.allocationFailedMsg = data;
                $('#viewAllocationFailedMsgModal').appendTo("body").modal('show');
                //alert(ctrl.allocationFailedMsg.length);
            });
    }


// function to create new item category

    $("#strgAttributeCancelSave").click(function () {
        ctrl.addNewStrgAttribute = "";
        ctrl.getStorageAttributes = '';
        ctrl.attrSaveOpt = "";
        //$('#AddNewItemCategory').modal('hide');
    });


    $("#itemCategorycancelSave").click(function () {
        ctrl.newItemCategory = '';
        ctrl.addItemCategory = "";
        ctrl.itemCategoryDescription = "";
        //$('#AddNewItemCategory').modal('hide');
    });

    var clearEach = function (uom) {
        if (uom == 'CASE') {
            ctrl.newItem.eachesPerCase = '';
        }
        if (uom == 'PALLET') {
            ctrl.newItem.eachesPerCase = '';
            ctrl.newItem.casesPerPallet = '';
            ctrl.newItem.isCaseTracked = false;
            ctrl.newItem.isCaseTracked = disabled;
        }

    };
    ctrl.clearEach = clearEach;

    //*************start item edit function******************

    $scope.HideEditForm = function () {
        clearFormEdit();
        ctrl.editPrinterState = false;
        ctrl.showUpdatedPrompt = false;
    };


    // var hasErrorClassEdit = function (field) {
    //     return ctrl.editPrinterForm[field].$touched && ctrl.editPrinterForm[field].$invalid;
    // };

    // var showMessagesEdit = function (field) {
    //     return ctrl.editPrinterForm[field].$touched || ctrl.editPrinterForm.$submitted;
    // };

    ctrl.showUpdatedPrompt = false;

    // ctrl.hasErrorClassEdit = hasErrorClassEdit;
    // ctrl.showMessagesEdit = showMessagesEdit;

    //**********end item edit****************************

//start search

    ctrl.callback = function (selectedLoc) {
        ctrl.allocateWaveObj.stagingLocationId = selectedLoc;

    };

    var disableFindButton = function () {
        ctrl.disabledFind = ctrl.itemId || ctrl.itemDescription ? false : true;
        if (ctrl.configValue.length > 0) {
            ctrl.disabledFind = false;
        }
        if (ctrl.isLotTracked) {
            ctrl.disabledFind = false;
        }
        if (ctrl.isExpired) {
            ctrl.disabledFind = false;
        }
        if (ctrl.itemCategory) {
            ctrl.disabledFind = false;
        }
    };

    ctrl.disabledFind = true;
    ctrl.disableFindButton = disableFindButton;


    var fakeI18n = function (title) {
        var deferred = $q.defer();
        $interval(function () {
            deferred.resolve('col: ' + title);
        }, 1000, 1);
        return deferred.promise;
    };

    var search = function () {
        var values = [];
        for (i = 0; i < ctrl.configValue.length; i++) {
            values.push("'" + ctrl.configValue[i].configValue + "'")
        }
        selectedValues = values.join();

        if (ctrl.searchForm.$valid) {
            $http({
                method: 'POST',
                url: '/item/searchResults',
                params: {
                    itemId: ctrl.itemId,
                    itemDescription: ctrl.itemDescription,
                    itemCategory: ctrl.itemCategory,
                    isLotTracked: ctrl.isLotTracked,
                    isExpired: ctrl.isExpired,
                    isCaseTracked: ctrl.isCaseTracked,
                    configValue: selectedValues
                },
                data: $scope.ctrl,
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}
            })
                .success(function (data) {
                    //$scope.gridItem.data = data;
                    ctrl.show = false;
                    $scope.gridItem.data = data.splice(0, 10000);

                })
        }

        $scope.IsVisible = false;
    };

    ctrl.search = search;

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

    //Get all list values for item category
    var getAllListValues1 = function () {
        $http({
            method: 'GET',
            url: '/item/getAllValuesByCompanyIdAndGroup',
            params: {group: 'ITEMCAT'}
        })
            .success(function (data) {
                ctrl.listValue1 = data;
            })
    };
    getAllListValues1();

    $scope.printReport = function(url){
        var w = window.open(url);
        w.print();
    };      

//multi combo box list items

    $http({
        method: 'GET',
        url: '/item/getAllValuesByCompanyIdAndGroup',
        params: {group: 'STRG'}
    })
        .success(function (data) {
            $scope.multiComboData = data;
            //alert(data);
        });


    ctrl.configValue = [];

    $scope.multiComboSettings = {
        scrollableHeight: '165px',
        scrollable: true,
        enableSearch: false
    };

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




