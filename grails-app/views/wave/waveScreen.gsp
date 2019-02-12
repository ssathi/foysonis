<html>
<head>
    <meta name="layout" content="foysonis2016"/>

    %{--Signup form--}%
    %{--<asset:javascript src="signup/angular.min.js"/>--}%
    <asset:javascript src="signup/angular-aria.min.js"/>
    <asset:javascript src="signup/angular-messages.min.js"/>
    <asset:javascript src="signup/angular-animate.min.js"/>

    %{--<asset:javascript src="datagrid/angular.js"/>--}%
    <asset:javascript src="datagrid/angular-touch.js"/>
    <asset:javascript src="datagrid/angular-animate.js"/>
    <asset:javascript src="datagrid/csv.js"/>
    <asset:javascript src="datagrid/pdfmake.js"/>
    <asset:javascript src="datagrid/vfs_fonts.js"/>
    <asset:javascript src="datagrid/ui-grid.js"/>
    %{--<link rel="stylesheet" href="http://ui-grid.info/release/ui-grid.css" type="text/css">--}%
    %{--<asset:stylesheet src="datagrid/ui-grid.css"/>--}%

    %{--Sign Up Form--}%
    <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>


    <%-- *************************** CSS for Location Grid **************************** --%>
    <style>

    td.selected-class-name {
        color: white;
        font-weight: bold;
        background-color: #006dba;
        text-decoration: none;

    }

    td.selected-class-name a:focus {
        color: white;
        font-weight: bold;
        background-color: #006dba;
        text-decoration: none;
    }

    td.selected-class-name a {
        color: white;
        font-weight: bold;
        background-color: #006dba;
        text-decoration: none;
    }

    .grid {
        height: 420px;
    }

    .csvGrid {
        height: 380px;
        width: 1300px;
    }

    .grid-align {
        text-align: center;
    }

    .grid-action-align {
        padding-left: 70px;
    }

    .dropdown-menu {
        min-width: 90px;
    }

    .noItemMessage {
        position: absolute;
        top: 30%;
        opacity: 0.4;
        font-size: 40px;
        width: 100%;
        text-align: center;
        z-index: auto;
    }

    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    .gridCheckbox {
        position: relative;
        display: block;
        margin-top: 5px;
        margin-bottom: 10px;
    }

    .wave-modal-dialog {
        width: 100%;
        height: 100%;
        margin: 0;
        padding: 0;
    }

    .wave-modal-content {
        height: auto;
        min-height: 100%;
        border-radius: 0;
    }

    .wave-modal-header {
        background: #547CA2;
        height: 70px;
    }

    .wave-panel-title {
        margin-top: -30px;
        color: #ffffff;
    }

    .wave-modal-body {
        position: fixed;
        top: 70px;
        bottom: 70px;
        width: 100%;
        overflow: scroll;
        padding: 15px
    }

    .wave-modal-footer {
        position: fixed;
        right: 0;
        bottom: 0;
        left: 0;
        border-top: 2px solid #547CA2;
        height: 70px;
    }

    .wave-close {
        color: #FFFFFF;
        opacity: 1;
    }

    .ui-grid-header-viewport {
        /*width: 0px;*/
        /*width: 1300px;*/
    }

    .csvImportBtn {
        background-color: #22a49c !important;
        height: 37px;
        line-height: 1;
        border: 0px;
    }

    .noDataMessage {
        position: absolute;
        top: 30%;
        opacity: 0.4;
        font-size: 40px;
        width: 100%;
        text-align: center;
        z-index: auto;
    }

    .ui-grid-pager-panel {
        padding-top: 10px;
    }

    /*.ui-grid-top-panel {*/
    /*/!* overflow: hidden; *!/*/
    /*}*/
    /*}*/

    </style>

    <%-- **************************** End of CSS **************************** --%>

</head>

<body>

<div ng-cloak class="row" id="dvWaveApp" ng-controller="WaveCtrl as ctrl">
    <div class="col-lg-12">
        <!-- START panel-->
        <!-- <div class="panel panel-default">
                <div class="panel-body" style="overflow:hidden;"> -->

        <div style="display: inline;"><!-- <em class="fa  fa-fw mr-sm" ><img style="width: 35px;" src="/foysonis2016/app/img/item-header.svg"></em>&emsp;&nbsp; --><span
                class="headerTitle">Waving</span></div>

        <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation"
           href="javascript:void(0);">

            <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowWaveModal()">
                <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                <g:message code="default.button.createWave.label"/>
            </button>
        </a>
        <br style="clear: both;"/>
        <br style="clear: both;"/>

        <div ng-if="ctrl.showPlanWaveSuccessPrompt">
            <div class="alert alert-success message-animation" role="alert">
                {{ctrl.waveplanMessage}}
            </div>
        </div>
        <!-- START Wave number search panel-->
        <div class="panel panel-default">
            <div class="panel-heading">
                <a href="javascript:void(0);" ng-click="">
                    <legend><!-- <em ng-if = "ctrl.isOrderSearchVisible" class="fa fa-minus-circle fa-fw mr-sm"></em>
                                <em ng-if = "!ctrl.isOrderSearchVisible" class="fa fa-plus-circle fa-fw mr-sm"></em> -->
                    <g:message code="default.search.label"/>
                    </legend></a>
            </div>

            <div class="panel-body">
                <form name="ctrl.waveSearchForm" ng-submit="ctrl.searchWaveNumbers()">
                    <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                        <!-- START Wizard Step inputs -->
                        <div>
                            <fieldset>
                                <!-- START row -->
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label><g:message code="wave.field.waveNumber.label"/></label>

                                            <div class="controls">
                                                <input type="text" name="orderNumber" placeholder="Wave Number"
                                                       class="form-control"
                                                       ng-blur="" ng-model="ctrl.waveNumberForSearch">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label><g:message code="wave.field.waveStatus.label"/></label>
                                            <select id="printerType" name="printerType"
                                                    ng-model="ctrl.waveStatusForSearch" class="form-control">
                                                <option value=""></option>
                                                <option value="${com.foysonis.orders.WaveStatus.PLANNED}">${com.foysonis.orders.WaveStatus.PLANNED}</option>
                                                <option value="${com.foysonis.orders.WaveStatus.PARTIALLY_ALLOCATED}">${com.foysonis.orders.WaveStatus.PARTIALLY_ALLOCATED}</option>
                                                <option value="${com.foysonis.orders.WaveStatus.ALLOCATED}">${com.foysonis.orders.WaveStatus.ALLOCATED}</option>
                                                <option value="${com.foysonis.orders.WaveStatus.PARTIALLY_PICKED}">${com.foysonis.orders.WaveStatus.PARTIALLY_PICKED}</option>
                                                <option value="${com.foysonis.orders.WaveStatus.FULLY_PICKED}">${com.foysonis.orders.WaveStatus.FULLY_PICKED}</option>
                                                <option value="${com.foysonis.orders.WaveStatus.COMPLETED}">${com.foysonis.orders.WaveStatus.COMPLETED}</option>
                                            </select>
                                        </div>
                                    </div>
                                    <br style="clear: both;"/>

                                </div>
                                <!-- END row -->

                            </fieldset>

                            <div class="pull-right">
                                <button class="btn btn-primary findBtn" type="submit">
                                    <g:message code="default.button.search.label"/>
                                </button>
                            </div>

                        </div>
                        <!-- END Wizard Wave number Step inputs -->
                    </div>
                </form>
            </div>
        </div>
        <!-- END search panel -->
        <br style="clear: both;"/>

        <div ng-show="ctrl.showWaveCancelledPrompt" class="alert alert-success message-animation" role="alert">
            <g:message code="wave.cancel.message"/>
        </div>

        <div ng-show="ctrl.showWaveAllocatedPrompt" class="alert alert-success message-animation" role="alert">
            {{ctrl.allocationStatusMsg}}
        </div>
        <div ng-show="ctrl.showFailedWaveAllocatedPrompt" class="alert alert-danger message-animation" role="alert">
            {{ctrl.allocationStatusMsg}}
        </div>

        <div id="grid1" ui-grid="gridWaveNumbers" ui-grid-exporter ui-grid-pagination ui-grid-pinning
             ui-grid-resize-columns ui-grid-auto-resize ui-grid-expandable class="grid">
            <div class="noDataMessage" ng-if="gridWaveNumbers.data.length == 0"><g:message
                    code="wave.grid.noData.message"/></div>
            <br style="clear: both;"/>
            <br style="clear: both;"/>
        </div>

        <%-- ****************************create wave **************************** --%>
        <div id="PlanWaving" class="modal fade" role="dialog">
            <div class="wave-modal-dialog modal-dialog" style="width: 100%;">
                <div class="wave-modal-content modal-content">
                    <div class="wave-modal-header modal-header">
                        <button type="button" class="wave-close close" data-dismiss="modal"
                                aria-hidden="true">&times;</button>
                        <br style="clear: both;"/>

                        <div class="panel-heading">
                            <div class="wave-panel-title panel-title"><h4>Wave Planning Screen</h4></div>
                        </div>
                    </div>

                    <div class="wave-modal-body modal-body">
                        <!-- START search panel-->
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <a href="javascript:void(0);" ng-click="ctrl.showHideSearch()">
                                    <legend><em ng-if="ctrl.isOrderSearchVisible"
                                                class="fa fa-minus-circle fa-fw mr-sm"></em>
                                        <em ng-if="!ctrl.isOrderSearchVisible"
                                            class="fa fa-plus-circle fa-fw mr-sm"></em>
                                        <g:message code="default.search.label"/>
                                    </legend></a>
                            </div>

                            <div class="panel-body" ng-show="ctrl.isOrderSearchVisible">
                                <form name="ctrl.orderSearchForm" ng-submit="ctrl.orderSearchForWaving()">
                                    <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                                        <!-- START Wizard Step inputs -->
                                        <div>
                                            <fieldset>
                                                <!-- START row -->
                                                <div class="row">

                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label><g:message code="form.field.customer.label"/></label>

                                                            <div class="controls">

                                                                <div auto-complete source="loadCustomerAutoComplete"
                                                                     xxxx-list-formatter="customListFormatter"
                                                                     min-chars="3"
                                                                     value-changed="ctrl.getCustomerContactName(value)">
                                                                    <input ng-model="ctrl.customer"
                                                                           placeholder="Customer" class="form-control"
                                                                           ng-blur='ctrl.clearCustomerSearchText()'>
                                                                </div>

                                                            </div>
                                                        </div>
                                                    </div>


                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label><g:message code="form.field.orderNo.label"/></label>

                                                            <div class="controls">
                                                                <input type="text" name="orderNumber" capitalize
                                                                       placeholder="Order Number" class="form-control"
                                                                       ng-blur="" ng-model="ctrl.orderNumber">
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="requestedShipSpeed"><g:message
                                                                    code="form.field.reqShipSpeed.label"/></label>
                                                            <select id="requestedShipSpeed" name="requestedShipSpeed"
                                                                    ng-model="ctrl.requestedShipSpeed"
                                                                    class="form-control">

                                                                <option ng-repeat="shipSpeed in ctrl.listValueShipSpeed"
                                                                        value="{{shipSpeed.optionValue}}">{{shipSpeed.description}}
                                                                </option>
                                                            </select>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label><g:message
                                                                    code="form.field.earlyShipDate.label"/></label>
                                                            <label ng-show="ctrl.displayEarlyShipDateRange">: <g:message
                                                                    code="form.field.from.label"/></label>

                                                            <div class="controls">
                                                                %{--<input type="date" id="fromEarlyShipDate" name="fromEarlyShipDate" class="form-control" ng-model="ctrl.findOrders.fromEarlyShipDate" />--}%
                                                                <p class="input-group">
                                                                    <input type="text" class="form-control"
                                                                           uib-datepicker-popup="{{format}}"
                                                                           ng-model="ctrl.fromEarlyShipDate"
                                                                           is-open="popupEarlyShipDateFrom.opened"
                                                                           datepicker-options="dateOptions"
                                                                           ng-required="false" close-text="Close"
                                                                           alt-input-formats="altInputFormats"/>
                                                                    <span class="input-group-btn">
                                                                        <button type="button" class="btn btn-default"
                                                                                ng-click="openEarlyShipDateFrom()">
                                                                            <i class="glyphicon glyphicon-calendar"></i>
                                                                        </button>
                                                                    </span>
                                                                </p>

                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-4" ng-show="ctrl.displayEarlyShipDateRange">
                                                        <div class="form-group">
                                                            <label><g:message code="form.field.to.label"/></label>

                                                            <div class="controls">
                                                                %{--<input type="date" id="toEarlyShipDate" name="toEarlyShipDate" class="form-control" ng-model="ctrl.findOrders.toEarlyShipDate" />--}%
                                                                <p class="input-group">
                                                                    <input type="text" class="form-control"
                                                                           uib-datepicker-popup="{{format}}"
                                                                           ng-model="ctrl.toEarlyShipDate"
                                                                           is-open="popupEarlyShipDateTo.opened"
                                                                           datepicker-options="dateOptions"
                                                                           ng-required="false" close-text="Close"
                                                                           alt-input-formats="altInputFormats"/>
                                                                    <span class="input-group-btn">
                                                                        <button type="button" class="btn btn-default"
                                                                                ng-click="openEarlyShipDateTo()">
                                                                            <i class="glyphicon glyphicon-calendar"></i>
                                                                        </button>
                                                                    </span>
                                                                </p>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label>&nbsp;</label>

                                                            <div class="controls">
                                                                <div class="checkbox c-checkbox">
                                                                    <label>
                                                                        <input type="checkbox" value=""
                                                                               ng-click="ctrl.showEarlyShipDateRange()"
                                                                               ng-model="ctrl.earlyShipDateRange">
                                                                        <span class="fa fa-check"></span><g:message
                                                                            code="form.field.dateRange.label"/></label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <br style="clear: both;"/>

                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label><g:message
                                                                    code="form.field.lateShipDate.label"/></label>
                                                            <label ng-show="ctrl.displayLateShipDateRange">: <g:message
                                                                    code="form.field.from.label"/></label>

                                                            <div class="controls">
                                                                %{--<input type="date" id="fromLateShipDate" name="fromLateShipDate" class="form-control" ng-model="ctrl.findOrders.fromLateShipDate" />--}%

                                                                <p class="input-group">
                                                                    <input type="text" class="form-control"
                                                                           uib-datepicker-popup="{{format}}"
                                                                           ng-model="ctrl.fromLateShipDate"
                                                                           is-open="popupLateShipDateFrom.opened"
                                                                           datepicker-options="dateOptions"
                                                                           ng-required="false" close-text="Close"
                                                                           alt-input-formats="altInputFormats"/>
                                                                    <span class="input-group-btn">
                                                                        <button type="button" class="btn btn-default"
                                                                                ng-click="openLateShipDateFrom()">
                                                                            <i class="glyphicon glyphicon-calendar"></i>
                                                                        </button>
                                                                    </span>
                                                                </p>

                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-4" ng-show="ctrl.displayLateShipDateRange">
                                                        <div class="form-group">
                                                            <label><g:message code="form.field.to.label"/></label>

                                                            <div class="controls">
                                                                %{--<input type="date" id="toLateShipDate" name="toLateShipDate" class="form-control" ng-model="ctrl.findOrders.toLateShipDate" />--}%

                                                                <p class="input-group">
                                                                    <input type="text" class="form-control"
                                                                           uib-datepicker-popup="{{format}}"
                                                                           ng-model="ctrl.toLateShipDate"
                                                                           is-open="popupLateShipDateTo.opened"
                                                                           datepicker-options="dateOptions"
                                                                           ng-required="false" close-text="Close"
                                                                           alt-input-formats="altInputFormats"/>
                                                                    <span class="input-group-btn">
                                                                        <button type="button" class="btn btn-default"
                                                                                ng-click="openLateShipDateTo()">
                                                                            <i class="glyphicon glyphicon-calendar"></i>
                                                                        </button>
                                                                    </span>
                                                                </p>

                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label>&nbsp;</label>

                                                            <div class="controls">
                                                                <div class="checkbox c-checkbox">
                                                                    <label>
                                                                        <input type="checkbox" value=""
                                                                               ng-click="ctrl.showLateShipDateRange()"
                                                                               ng-model="ctrl.LateShipDateRange">
                                                                        <span class="fa fa-check"></span><g:message
                                                                            code="form.field.dateRange.label"/></label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <br style="clear: both;"/>

                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label>Maximum no of orders</label>

                                                            <div class="controls">
                                                                <input type="number" name="maxNoOfOrders"
                                                                       placeholder="Maximum number of order"
                                                                       class="form-control"
                                                                       ng-blur="" ng-model="ctrl.maxNoOfOrders">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <br style="clear: both;"/>

                                                </div>
                                                <!-- END row -->

                                            </fieldset>

                                            <div class="pull-right">
                                                <button class="btn btn-primary findBtn" type="submit">
                                                    <g:message code="default.button.search.label"/>
                                                </button>
                                            </div>

                                        </div>
                                        <!-- END Wizard Step inputs -->
                                    </div>
                                </form>
                            </div>
                        </div>
                        <!-- END search panel -->
                        <br style="clear: both;"/>

                        <div class="alert alert-success message-animation" role="alert"
                             ng-if="ctrl.showPlanWaveSuccessPrompt">
                            {{ctrl.waveplanMessage}}
                        </div>

                        <div class="alert alert-danger message-animation" role="alert"
                             ng-if="ctrl.showPlanWaveErrorPrompt">
                            {{ctrl.waveplanMessage}}
                        </div>
                        <br style="clear: both;"/>

                        <div style="float: left; margin-top: 20px;">
                            <button class="btn btn-primary btn-xs findBtn" ng-click="ctrl.getSelectedRows()"
                                    ng-disabled="ctrl.selectedOrderLines.length == 0" style="margin-top: -40px;">
                                Plan Wave
                            </button>
                        </div>
                        <br style="clear: both;"/>

                        <div id="grid1" ui-grid="gridWaveOrders" ui-grid-exporter ui-grid-pagination ui-grid-pinning
                             ui-grid-resize-columns ui-grid-auto-resize ui-grid-expandable ui-grid-selection
                             class="grid">
                            <div class="noDataMessage" ng-if="gridWaveOrders.data.length == 0"><g:message
                                    code="customer.grid.noData.message"/></div>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>
                        </div>
                    </div>

                    <div class="wave-modal-footer modal-footer">
                        <div class="col-md-6 pull-right" style="width: initial;">
                            <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%-- **************************** End create wave **************************** --%>

    </div>

    <div id="allocateWave" class="modal fade" role="dialog" data-backdrop="static">
        <div class="modal-dialog" style="width: 80%;">
            <div class="modal-content">
                <div class="wave-modal-header modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"
                            ng-click="ctrl.closeShipmentModel()">&times;</button>
                    <br style="clear: both;"/>

                    <div class="panel-heading">
                        <div class="wave-panel-title panel-title"><h4>Allocate Wave</h4></div>
                    </div>
                </div>

                <form name="ctrl.allocateWaveForm" ng-submit="ctrl.saveWaveAllocation()" novalidate>
                    <div class="modal-body">

                        <div class="col-md-2" style="text-align: right;">
                            Wave Number :
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            {{ctrl.allocateWaveObj.waveNumber}}
                        </div>


                        <div class="col-md-2" style="text-align: right;">
                            Total Shipments to allocate :
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            &emsp;{{ctrl.allocateWaveObj.totalShipmentCount}}
                        </div>

                        <div class="col-md-2" style="text-align: right;">
                            Total Lines to allocate :
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            &emsp;{{ctrl.allocateWaveObj.totalLineCount}}
                        </div>

                        <br style="clear: both;"/>
                        <br style="clear: both;"/>


                        <div class="col-md-2" style="text-align: right;">
                            <label>Maximum picks per list :</label>
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            <input id="maxPicks" name="maxPicks" class="form-control" type="number"
                                   ng-model="ctrl.allocateWaveObj.maxNoOfPicks"
                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="Maximum Picks"
                                   min="1"/>

                            <div class="my-messages" ng-messages="ctrl.allocateWaveForm.maxPicks.$error"
                                 ng-if="ctrl.allocateWaveForm.maxPicks.$error.min">
                                <div class="message-animation">
                                    <strong>Cannot enter value zero(0) or less.</strong>
                                </div>
                            </div>

                        </div>


                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                        <div class="col-md-2" style="text-align: right;">
                            <label>Print Pick Tickets :</label>
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            <input type="checkbox" name="printPickTickets" id="printPickTickets"
                                   ng-model="ctrl.allocateWaveObj.printPickTickets">
                        </div>

                        <div class="col-md-2" style="text-align: right;"
                             ng-show="ctrl.allocateWaveObj.printPickTickets">
                            <div class="form-group">
                                <label for="labelPrinter">Label Printer :</label>

                            </div>
                        </div>

                        <div class="col-md-2" style="text-align: left;" ng-show="ctrl.allocateWaveObj.printPickTickets">
                            <select id="labelPrinter" name="labelPrinter"
                                    data-ng-model="ctrl.allocateWaveObj.labelPrinter" class="form-control">
                                <option ng-repeat="option in ctrl.labelPrinterList"
                                        value="{{option.id}}">{{option.displayName}}</option>
                            </select>
                        </div>

                        <div class="col-md-2" style="text-align: right;"
                             ng-show="ctrl.allocateWaveObj.printPickTickets">
                            <div class="form-group">
                                <label for="pickTicketsPrintedBy">Pick Tickets Printed by :</label>

                            </div>
                        </div>

                        <div class="col-md-2" style="text-align: left;" ng-show="ctrl.allocateWaveObj.printPickTickets">
                            <select id="pickTicketsPrintedBy" name="pickTicketsPrintedBy" class="form-control"
                                    data-ng-model="ctrl.allocateWaveObj.pickTicketsPrintedBy">
                                <option value="UNIT">UNIT</option>
                                <option value="PICK">PICK</option>
                            </select>
                        </div>


                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                        <div class="col-md-2" style="text-align: right;">
                            <label>Print Pick Lists :</label>
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            <input type="checkbox" name="PrintPickLists" id="PrintPickLists"
                                   ng-model="ctrl.allocateWaveObj.PrintPickLists">
                        </div>

                        <div class="col-md-2" style="text-align: right;" ng-show="ctrl.allocateWaveObj.PrintPickLists">
                            <div class="form-group">
                                <label for="regPrinter">Printer :</label>

                            </div>
                        </div>

                        <div class="col-md-2" style="text-align: left;" ng-show="ctrl.allocateWaveObj.PrintPickLists">
                            <select id="regPrinter" name="regPrinter"
                                    data-ng-model="     ctrl.allocateWaveObj.regularPrinter"
                                    class="form-control">
                                <option ng-repeat="option in ctrl.regularPrinterList"
                                        value="{{option.id}}">{{option.displayName}}</option>
                            </select>
                        </div>

                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                        <div class="col-md-2" style="text-align: right;">
                            <label for="locationId">Staging Location :</label>
                        </div>

                        <div class="col-md-4" style="text-align: left;">
                            <div class="form-group"
                                 ng-class="{'has-error':ctrl.allocateWaveForm.stageLocationId.$touched && ctrl.allocateWaveForm.stageLocationId.$invalid}">
                                <div auto-complete source="loadLocationAutoComplete"
                                     xxxx-list-formatter="customListFormatter" min-chars='0'
                                     value-changed="ctrl.callback(value.location_id)" style="z-index: 1000;">
                                    <input id="stageLocationId" name="stageLocationId"
                                           ng-model="ctrl.allocateWaveObj.stagingLocation"
                                           ng-model-options="{ updateOn : 'default blur' }"
                                           placeholder="Location Id" class="form-control" required/>
                                </div>
                            </div>

                            <div class="my-messages" ng-messages="ctrl.allocateWaveForm.stageLocationId.$error"
                                 ng-if="ctrl.allocateWaveForm.stageLocationId.$touched || ctrl.allocateWaveForm.$submitted">
                                <div class="message-animation" ng-message="required">
                                    <strong><g:message code="required.error.message"/></strong>
                                </div>
                            </div>
                        </div>

                    </div>
                    <br style="clear: both;"/>
                    <br style="clear: both;"/>

                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary pull-right">
                            Allocate
                        </button>
                        <button type="button" class="btn btn-default pull-left" ng-click="ctrl.closeShipmentModel()"
                                data-dismiss="modal"><g:message code="default.button.cancel.label"/></button>
                    </div>
                </form>
                <br style="clear: both;"/>

            </div>
        </div>
    </div>

    <div id="rePrintWaveModal" class="modal fade" role="dialog" data-backdrop="static">
        <div class="modal-dialog" style="width: 80%;">
            <div class="modal-content">
                <div class="wave-modal-header modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"
                            ng-click="ctrl.closeShipmentModel()">&times;</button>
                    <br style="clear: both;"/>

                    <div class="panel-heading">
                        <div class="wave-panel-title panel-title"><h4>Re-Print Wave</h4></div>
                    </div>
                </div>

                <form name="ctrl.rePrintWaveForm" ng-submit="ctrl.printLabelOrList()" novalidate>
                    <div class="modal-body">

                        <div class="col-md-2" style="text-align: right;">
                            Wave Number :
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            {{ctrl.allocateWaveObj.waveNumber}}
                        </div>


                        <div class="col-md-2" style="text-align: right;">
                            Total Shipments to allocate :
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            &emsp;{{ctrl.allocateWaveObj.totalShipmentCount}}
                        </div>

                        <div class="col-md-2" style="text-align: right;">
                            Total Lines to allocate :
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            &emsp;{{ctrl.allocateWaveObj.totalLineCount}}
                        </div>

                        <br style="clear: both;"/>
                        <br style="clear: both;"/>


                        <div class="col-md-2" style="text-align: right;">
                            <label>Maximum picks per list :</label>
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            <input id="maxPicks" name="maxPicks" class="form-control" type="number"
                                   ng-model="ctrl.allocateWaveObj.maxNoOfPicks"
                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="Maximum Picks"
                                   min="1"/>

                            <div class="my-messages" ng-messages="ctrl.rePrintWaveForm.maxPicks.$error"
                                 ng-if="ctrl.rePrintWaveForm.maxPicks.$error.min">
                                <div class="message-animation">
                                    <strong>Cannot enter value zero(0) or less.</strong>
                                </div>
                            </div>

                        </div>


                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                        <div class="col-md-2" style="text-align: right;">
                            <label>Print Pick Tickets :</label>
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            <input type="checkbox" name="printPickTickets" id="printPickTickets"
                                   ng-model="ctrl.allocateWaveObj.printPickTickets">
                        </div>

                        <div class="col-md-2" style="text-align: right;"
                             ng-show="ctrl.allocateWaveObj.printPickTickets">
                            <div class="form-group">
                                <label for="labelPrinter">Label Printer :</label>

                            </div>
                        </div>

                        <div class="col-md-2" style="text-align: left;" ng-show="ctrl.allocateWaveObj.printPickTickets">
                            <select id="labelPrinter" name="labelPrinter"
                                    data-ng-model="ctrl.allocateWaveObj.labelPrinter" class="form-control">
                                <option ng-repeat="option in ctrl.labelPrinterList"
                                        value="{{option.id}}">{{option.displayName}}</option>
                            </select>
                        </div>

                        <div class="col-md-2" style="text-align: right;"
                             ng-show="ctrl.allocateWaveObj.printPickTickets">
                            <div class="form-group">
                                <label for="pickTicketsPrintedBy">Pick Tickets Printed by :</label>

                            </div>
                        </div>

                        <div class="col-md-2" style="text-align: left;" ng-show="ctrl.allocateWaveObj.printPickTickets">
                            <select id="pickTicketsPrintedBy" name="pickTicketsPrintedBy" class="form-control"
                                    data-ng-model="ctrl.allocateWaveObj.pickTicketsPrintedBy">
                                <option value="UNIT">UNIT</option>
                                <option value="PICK">PICK</option>
                            </select>
                        </div>


                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                        <div class="col-md-2" style="text-align: right;">
                            <label>Print Pick Lists :</label>
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            <input type="checkbox" name="PrintPickLists" id="PrintPickLists"
                                   ng-model="ctrl.allocateWaveObj.PrintPickLists">
                        </div>

                        <div class="col-md-2" style="text-align: right;" ng-show="ctrl.allocateWaveObj.PrintPickLists">
                            <div class="form-group">
                                <label for="regPrinter">Printer :</label>

                            </div>
                        </div>

                        <div class="col-md-2" style="text-align: left;" ng-show="ctrl.allocateWaveObj.PrintPickLists">
                            <select id="regPrinter" name="regPrinter"
                                    data-ng-model="     ctrl.allocateWaveObj.regularPrinter"
                                    class="form-control">
                                <option ng-repeat="option in ctrl.regularPrinterList"
                                        value="{{option.id}}">{{option.displayName}}</option>
                            </select>
                        </div>

                        <br style="clear: both;"/>
                    </div>
                    <br style="clear: both;"/>
                    <br style="clear: both;"/>

                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary pull-right">
                            Re-Print
                        </button>
                        <button type="button" class="btn btn-default pull-left" ng-click="ctrl.closeShipmentModel()"
                                data-dismiss="modal"><g:message code="default.button.cancel.label"/></button>
                    </div>
                </form>
                <br style="clear: both;"/>

            </div>
        </div>
    </div>

    <div id="planWavingModal" class="modal fade" role="dialog" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"
                            ng-click="">&times;</button>
                    <h4 class="modal-title">Plan Waving</h4>
                </div>

                <div class="modal-body">
                    {{ctrl.selectedOrderLines}}
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" ng-click="" data-dismiss="modal"><g:message
                            code="default.button.cancel.label"/></button>
                </div>
                <br style="clear: both;"/>
            </div>
        </div>
    </div>

    <div id="cancelWaveWarnModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Confirmation</h4>
                </div>

                <div class="modal-body">
                    <p>Do you really want to cancel this wave, {{ctrl.waveNumberForMessageEdit}}?</p>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                    <button type="button" id="cancelWaveBtn" class="btn btn-primary">Yes</button>
                </div>
            </div>
        </div>
    </div>

    <div id="removeOrderFromWave" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Confirmation</h4>
                </div>

                <div class="modal-body">
                    <p>Do you really want to remove this order, {{ctrl.orderNumForWaveRemove}} from Wave?</p>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                    <button type="button" id="removeOrderBtn" class="btn btn-primary">Yes</button>
                </div>
            </div>
        </div>
    </div>

    <div id="viewWaveDetailsModal" class="modal fade" role="dialog">
        <div class="wave-modal-dialog modal-dialog" style="width: 100%;">
            <div class="wave-modal-content modal-content">
                <div class="wave-modal-header modal-header">
                    <button type="button" class="wave-close close" data-dismiss="modal" aria-hidden="true"
                            ng-click="ctrl.closeEditWaveModel()">&times;</button>
                    <br style="clear: both;"/>

                    <div class="panel-heading">
                        <div ng-if="!ctrl.isEditWave" class="wave-panel-title panel-title"><h4>View Details</h4></div>

                        <div ng-if="ctrl.isEditWave" class="wave-panel-title panel-title"><h4>Edit Wave</h4></div>
                    </div>
                </div>

                <div class="wave-modal-body modal-body">

                    <div class="panel-body">

                        <div ng-show="ctrl.showEditPrompt" class="alert alert-success message-animation" role="alert">
                            {{ctrl.waveEditStatusMsg}}
                        </div>

                        <div class="col-md-12">
                            <div class="col-md-2" style="text-align: left;">
                                Wave Number:
                            </div>

                            <div class="col-md-10" style="text-align: left;">
                                 {{ctrl.selectedWaveNumber}}
                            </div>
                        </div>
                    </div>

                    <br style="clear: both;"/>
                    <br style="clear: both;"/>

                    <div id="grid1" ng-if="!ctrl.isEditWave" ui-grid="gridWaveOrdersForDetails" ui-grid-exporter
                         ui-grid-pagination ui-grid-pinning
                         ui-grid-resize-columns ui-grid-auto-resize ui-grid-expandable
                         class="grid">
                        <div class="noDataMessage" ng-if="gridWaveOrdersForDetails.data.length == 0"><g:message
                                code="order.grid.noData.message"/></div>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                    </div>

                    <div id="grid1" ng-if="ctrl.isEditWave" ui-grid="gridWaveOrdersForEdit" ui-grid-exporter
                         ui-grid-pagination ui-grid-pinning
                         ui-grid-resize-columns ui-grid-auto-resize ui-grid-expandable
                         class="grid">
                        <div class="noDataMessage" ng-if="gridWaveOrdersForEdit.data.length == 0"><g:message
                                code="order.grid.noData.message"/></div>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                    </div>
                </div>

                <div class="wave-modal-footer modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                </form>
                </div>
            </div>
        </div>
    </div>

    <div id="viewAllocationFailedMsgModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Allocation Failed Messages</h4>
                </div>

                <div class="modal-body">
                    <div ng-if="ctrl.allocationFailedMsg.length > 0">
                        <h4>Errors from Previous Allocation Attempt:</h4>
                        <ul>
                            <li ng-repeat="allocationmsg in ctrl.allocationFailedMsg"
                                value="{{allocationmsg.message}}">{{allocationmsg.message}}</li>
                        </ul>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="pickListReport" class="modal fade" role="dialog">
        <div class="modal-dialog" style="width:80%">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div class="modal-body">
                    <div>
                     <embed id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.pickListReportSrcStrg}}"/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click='printReport(ctrl.pickListReportSrcStrg)'>Print</button>
                </div>
            </div>
        </div>
    </div>  

</div>

<asset:javascript src="datagrid/wave.js"/>

<script type="text/javascript">
    var dvWaveApp = document.getElementById('dvWaveApp');
    angular.element(document).ready(function () {
        angular.bootstrap(dvWaveApp, ['waveApp']);
    });
</script>

<asset:javascript src="autocomplete/angular-sanitize.js"/>
<asset:javascript src="autocomplete/auto-complete.js"/>
<asset:javascript src="autocomplete/auto-complete-multi.js"/>
<asset:javascript src="inventory/order-auto-complete-div.js"/>
<asset:javascript src="autocomplete/auto-complete-textbox.js"/>

</body>
</html>
