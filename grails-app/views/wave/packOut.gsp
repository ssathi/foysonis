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

<div ng-cloak class="row" id="dvPackoutApp" ng-controller="packoutCtrl as ctrl">
    <div class="col-lg-12">

        <!-- START panel-->
        <!-- <div class="panel panel-default">
                <div class="panel-body" style="overflow:hidden;"> -->

        <div style="display: inline;">
            <em class="fa  fa-fw mr-sm"><img style="width: 35px;"
                                             src="/foysonis2016/app/img/packout_station_header_icon.png">
            </em>&emsp;&nbsp;
            <span class="headerTitle">Packout Station</span></div>

        <br style="clear: both;"/>
        <br style="clear: both;"/>

        <div ng-show="ctrl.showPackoutSearchError" class="alert alert-danger message-animation" role="alert">
            {{ctrl.packoutErrorMsg}}
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
                <form name="ctrl.packoutSearchForm" ng-submit="ctrl.searchPackout()">
                    <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                        <!-- START Wizard Step inputs -->
                        <div>
                            <fieldset>
                                <!-- START row -->
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Id</label>

                                            <div class="controls">
                                                <input type="text" name="orderNumber" capitalize
                                                       placeholder="Pick Reference / Order Number / Shipment ID / Pick-To Carton ID or Pallet ID"
                                                       class="form-control" ng-blur=""
                                                       ng-model="ctrl.packOutIdForSearch">
                                            </div>
                                        </div>
                                    </div>
                                    <br style="clear: both;"/>

                                </div>
                                <!-- END row -->

                            </fieldset>

                            <div class="pull-right">
                                <button class="btn btn-primary findBtn" type="submit"
                                        ng-disabled="!ctrl.packOutIdForSearch">
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
        <br style="clear: both;">

        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showShipConfirmSuccessPrompt">
            Shipment has been successfully confirmed.
        </div>

        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showShipUnConfirmSuccessPrompt">
            Shipment has been successfully unconfirmed.
        </div>

        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showShipCloseSuccessPrompt">
            Shipment has been successfully closed out.
        </div>

        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showEasyPostManifestedPrompt">
            This shipment has been manifested through EasyPost
        </div>

        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showEasyPostVoidPrompt">
            This shipment has been removed from EasyPost
        </div>

        <div class="panel panel-default" ng-if="ctrl.viewUncompletedShipmentModal">
            <div class="panel-heading">
                <div class="panel-title"><h4>Packout Station</h4></div>
            </div>

            <div class="panel-body">

                <div class="col-md-12">

                    <form name="ctrl.confirmPackoutShipForm" ng-submit="" novalidate>

                        <div class="col-md-2" style="text-align: right;">
                            Order Number :
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            {{ctrl.packOutSearchResult.orderNumber}}
                        </div>

                        <div class="col-md-2" style="text-align: right;">
                            Shipment Id :
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            {{ctrl.packOutSearchResult.shipmentId}}
                        </div>


                        <div class="col-md-2" style="text-align: right;">
                            No of Shipment Lines :
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            &emsp;{{ctrl.packOutSearchResult.noOfShipLines}}
                        </div>


                        <div class="col-md-2" style="text-align: right;">
                            Shipment Status :
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            {{ctrl.packOutSearchResult.shipmentStatus}}
                        </div>

                        <div class="col-md-2" style="text-align: right;">
                            <label>Shipment Weight :</label>
                        </div>

                        <div class="col-md-2" style="text-align: left;">

                            <input id="shipmentWeight" name="shipmentWeight" class="form-control" type="text"
                                   ng-model="ctrl.packOutSearchResult.actualWeight"
                                   ng-model-options="{ updateOn : 'default blur' }"
                                   placeholder="Shipment Weight"/>

                        </div>

                        <div class="col-md-2" style="text-align: right;">
                            <label>Notes :</label>
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            {{ctrl.packOutSearchResult.shipmentNotes}}
                        </div>

                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                        <div class="col-md-2" style="text-align: right;">
                            <label>Shipment Container Id :</label>
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            <input id="shipContainerId" name="shipContainerId" class="form-control" type="text"
                                   ng-model="ctrl.shipContainerId" ng-model-options="{ updateOn : 'default blur' }"
                                   placeholder="Shipment Container Id " capitalize required autofocus/>

                            <div class="my-messages" ng-messages="ctrl.confirmPackoutShipForm.shipContainerId.$error"
                                 ng-if="ctrl.confirmPackoutShipForm.shipContainerId.$touched || ctrl.confirmPackoutShipForm.$submitted">
                                <div class="message-animation" ng-message="required">
                                    <strong><g:message code="required.error.message"/></strong>
                                </div>
                            </div>

                            <div class="my-messages" ng-messages="ctrl.confirmPackoutShipForm.shipContainerId.$error"
                                 ng-if="ctrl.confirmPackoutShipForm.$error.containerIdValid">
                                <div class="message-animation">
                                    <strong>Shipment Container Id is invalid.</strong>
                                </div>
                            </div>

                        </div>


                        <div class="col-md-2" style="text-align: right;">
                            <div class="form-group">
                                <label for="carrierCode"><g:message code="form.field.carrierCode.label"/>:</label>

                            </div>
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            <select name="carrierCode" id="carrierCode" ng-model="ctrl.carrierCode"
                                    class="form-control" ng-change="ctrl.loadServiceForCarrier()">
                                <option ng-repeat="option in ctrl.carrierCodeOptions"
                                        value="{{option.optionValue}}">{{option.description}}</option>
                            </select>
                        </div>

                        <div class="col-md-2" style="text-align: right;">
                            <div class="form-group">
                                <label for="serviceLevel"><g:message
                                        code="form.field.serviceLevel.label"/>:</label>

                            </div>
                        </div>

                        <div class="col-md-2" style="text-align: left;">
                            <select name="serviceLevel" id="serviceLevel" ng-model="ctrl.serviceLevel"
                                    class="form-control">
                                <option ng-repeat="option in ctrl.serviceLevelOptions">{{option}}</option>
                            </select>
                        </div>

                        <br style="clear: both;"/>

                        <div ng-show="!ctrl.isEasyPostEnabled" class="col-md-2" style="text-align: right;">
                            <label>Tracking No./Pro No. :</label>
                        </div>

                        <div ng-show="!ctrl.isEasyPostEnabled" class="col-md-2" style="text-align: left;">
                            <input id="trackingNumber" name="trackingNumber" class="form-control" type="text"
                                   ng-model="ctrl.trackingNumber" ng-model-options="{ updateOn : 'default blur' }"
                                   placeholder="Tracking No" capitalize/>

                            <div class="my-messages" ng-if="ctrl.trackingNumberValidation && !ctrl.trackingNumber">
                                <strong style="color: red;"><g:message code="required.error.message"/></strong>
                            </div>

                        </div>

                        <div ng-show="ctrl.isEasyPostEnabled && ctrl.showCloseout" class="col-md-2"
                             style="text-align: right;">
                            <label>Label Printer :</label>
                        </div>

                        <div ng-show="ctrl.isEasyPostEnabled && ctrl.showCloseout" class="col-md-2"
                             style="text-align: left;">
                            <select id="storageAttributes" name="storageAttributes" data-ng-model="ctrl.labelPrinter"
                                    ng-options="option.displayName for option in ctrl.defaultLabelOptions track by option.id"
                                    class="form-control" ng-change="ctrl.labelPrinterOnChange()">
                            </select>

                        </div>

                        <div ng-show="ctrl.isEasyPostEnabled && ctrl.showCloseout" class="col-md-2"
                             style="text-align: right;">
                            <button style="height: 37px;" type="button" class="btn btn-xs btn-primary startPickBtn"
                                    ng-click="ctrl.printShippingLabel()"
                                    ng-disabled="!ctrl.isEasyPostEnabled || ctrl.labelPrinterDisable || !ctrl.serviceLevel || !ctrl.carrierCode || !ctrl.packOutSearchResult.actualWeight">Print Shipping Label</button>
                        </div>

                        <br style="clear: both;">

                        <div class="col-md-2" style="text-align: right; padding-top: 5px;">
                            <label>Printer :</label>
                        </div>

                        <div class="col-md-2" style="text-align: left; padding-top: 5px; ">
                            <select id="storageAttributes" name="storageAttributes" data-ng-model="ctrl.defaultPrinter"
                                    ng-options="option.displayName for option in ctrl.defaultPrinterOptions track by option.id"
                                    class="form-control" ng-change="ctrl.defaultPrinterOnChange()">
                            </select>

                        </div>

                        <div class="col-md-2" style="text-align: right; padding-top: 5px;">
                            <button style="height: 37px;" type="button" class="btn btn-xs btn-primary startPickBtn"
                                    ng-click="viewPackingSlip()">Print pack slip</button>
                        </div>

                        <br style="clear: both;"/>

                        <br style="clear: both;"/>

                        <div id="grid1" ui-grid="gridPackoutShipmentLine" ui-grid-exporter ui-grid-pagination
                             ui-grid-pinning ui-grid-resize-columns ui-grid-auto-resize class="grid">
                            <div class="noDataMessage" ng-if="gridPackoutShipmentLine.data.length == 0"><g:message
                                    code="shipment.grid.noData.message"/></div>
                            <br style="clear: both;"/>
                        </div>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                </div>

            </div>

            <div class="modal-footer">
                <div class="pull-right">
                    <button type="button" class="btn btn-xs btn-primary startPickBtn" ng-if="ctrl.showConfirmAll"
                            ng-click="ctrl.confirmAllShipmentLines()">Confirm All</button>
                    <button ng-show="!ctrl.isEasyPostEnabled && ctrl.showCloseout" type="button"
                            class="btn btn-xs btn-primary startPickBtn" ng-if="ctrl.showCloseout"
                            ng-click="ctrl.closeOutShipment()">Closeout Shipment</button>
                </div>
            </form>
            </div>

        </div>

        <div class="panel panel-default" ng-if="ctrl.viewCompletedShipmentModal">
            <div class="panel-heading">
                <div class="panel-title"><h4>Packout</h4></div>
            </div>

            <div class="panel-body">
                <div class="alert alert-success message-animation" role="alert" style="padding: 15px;">
                    {{ctrl.packoutResultMsg}}
                </div>
                <br style="clear: both;"/>

                <div><label>Shipment Id :</label> {{ctrl.packOutSearchResult.shipmentId}}</div>

                <div><label>Shipping Contact :</label> {{ctrl.packOutSearchResult.contactName}}</div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"
                        ng-click="ctrl.viewCompletedShipmentModal = false;">Close</button>
            </div>
        </div>

        <div id="viewPackingSlipModel" class="modal fade" role="dialog">
            <div class="modal-dialog" style="width:80%">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    </div>

                    <div class="modal-body">
                        <div>
                            <embed id="pdfReport" style="height:450px; width: 100%;"
                                   ng-src="{{ctrl.srcStrgForPackSlip}}"/>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message
                                code="default.button.cancel.label"/></button>
                        <button type="button" id="PrintPdf" class="btn btn-primary" ng-click=printPack()>Print</button>
                    </div>
                </div>
            </div>
        </div>

        <div id="easyPostErrorModal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title"><g:message code="default.dialog.warning.label" /></h4>
                    </div>
                    <div class="modal-body">
                        <div class="my-messages" ng-messages="ctrl.updateEasyPostWeightForm.packageWeight.$error" ng-if="ctrl.easyPostError">
                            <div class="message-animation" >
                                <strong>{{ctrl.easyPostErrorMsg}}</strong>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal" ng-click="openEasyPostEdit(ctrl.ePMAnifestData)"><g:message code="default.button.ok.label" /></button>
                    </div>
                </div>
            </div>
        </div>


        <!--     <div id="viewCompletedShipmentModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>

                <div class="modal-body">
                    <div class="alert alert-success message-animation" role="alert" style="padding: 15px;">
                        {{ctrl.packoutResultMsg}}
                    </div>
                    <br style="clear: both;"/>

                    <div><label>Shipment Id :</label> {{ctrl.packOutSearchResult.shipmentId}}</div>

                    <div><label>Shipping Contact :</label> {{ctrl.packOutSearchResult.contactName}}</div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div> -->


        <!--     <div id="viewUncompletedShipmentModal" class="modal fade" role="dialog">
        <div class="wave-modal-dialog modal-dialog" style="width: 100%;">
            <div class="wave-modal-content modal-content">
                <div class="wave-modal-header modal-header">
                    <button type="button" class="wave-close close" data-dismiss="modal" aria-hidden="true"
                            ng-click="ctrl.closeEditWaveModel()">&times;</button>
                    <br style="clear: both;"/>

                    <div class="panel-heading">
                        <div class="wave-panel-title panel-title"><h4>Packout</h4></div>
                    </div>
                </div>

                <div class="wave-modal-body modal-body">

                    <div class="col-md-12">

                        <form name="ctrl.confirmPackoutShipForm" ng-submit="" novalidate>

                            <div class="col-md-2" style="text-align: right;">
                                Order Number :
                            </div>

                            <div class="col-md-2" style="text-align: left;">
                                {{ctrl.packOutSearchResult.orderNumber}}
                            </div>

                            <div class="col-md-2" style="text-align: right;">
                                Shipment Id :
                            </div>

                            <div class="col-md-2" style="text-align: left;">
                                {{ctrl.packOutSearchResult.shipmentId}}
                            </div>


                            <div class="col-md-2" style="text-align: right;">
                                No of Shipment Lines :
                            </div>

                            <div class="col-md-2" style="text-align: left;">
                                &emsp;{{ctrl.packOutSearchResult.noOfShipLines}}
                            </div>


                            <div class="col-md-2" style="text-align: right;">
                                Shipment Status :
                            </div>

                            <div class="col-md-2" style="text-align: left;">
                                {{ctrl.packOutSearchResult.shipmentStatus}}
                            </div>

                            <div class="col-md-2" style="text-align: right;">
                                <label>Shipment Weight :</label>
                            </div>

                            <div class="col-md-2" style="text-align: left;">
                                {{ctrl.packOutSearchResult.actualWeight}}
                            </div>

                            <div class="col-md-2" style="text-align: right;">
                                <label>Notes :</label>
                            </div>

                            <div class="col-md-2" style="text-align: left;">
                                {{ctrl.packOutSearchResult.shipmentNotes}}
                            </div>

                            <br style="clear: both;"/>

                            <div class="col-md-2" style="text-align: right;">
                                <label>Shipment Container Id :</label>
                            </div>

                            <div class="col-md-2" style="text-align: left;">
                                <input id="shipContainerId" name="shipContainerId" class="form-control" type="text"
                                       ng-model="ctrl.shipContainerId" ng-model-options="{ updateOn : 'default blur' }"
                                       placeholder="Shipment Container Id " capitalize required />

                                <div class="my-messages" ng-messages="ctrl.confirmPackoutShipForm.shipContainerId.$error" ng-if="ctrl.confirmPackoutShipForm.shipContainerId.$touched || ctrl.confirmPackoutShipForm.$submitted">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message"/></strong>
                                    </div>
                                </div>
                                <div class="my-messages"  ng-messages="ctrl.confirmPackoutShipForm.shipContainerId.$error"
                                     ng-if="ctrl.confirmPackoutShipForm.$error.containerIdValid">
                                    <div class="message-animation" >
                                        <strong>Shipment Container Id is invalid.</strong>
                                    </div>
                                </div>                                


                            </div>


                            <div class="col-md-2" style="text-align: right;">
                                <div class="form-group">
                                    <label for="carrierCode"><g:message code="form.field.carrierCode.label"/>:</label>

                                </div>
                            </div>

                            <div class="col-md-2" style="text-align: left;">
                                <select name="carrierCode" id="carrierCode" ng-model="ctrl.carrierCode"
                                        class="form-control" ng-change="ctrl.loadServiceForCarrier()">
                                    <option ng-repeat="option in ctrl.carrierCodeOptions"
                                            value="{{option.optionValue}}">{{option.description}}</option>
                                </select>
                            </div>

                            <div class="col-md-2" style="text-align: right;">
                                <div class="form-group">
                                    <label for="serviceLevel"><g:message
                code="form.field.serviceLevel.label"/>:</label>

                                </div>
                            </div>

                            <div class="col-md-2" style="text-align: left;">
                                <select name="serviceLevel" id="serviceLevel" ng-model="ctrl.serviceLevel"
                                        class="form-control">
                                    <option ng-repeat="option in ctrl.serviceLevelOptions">{{option}}</option>
                                </select>
                            </div>

                            <br style="clear: both;"/>

                            <div class="col-md-2" style="text-align: right;">
                                <label>Tracking No./Pro No. :</label>
                            </div>

                            <div class="col-md-2" style="text-align: left;">
                                <input id="trackingNumber" name="trackingNumber" class="form-control" type="text"
                                       ng-model="ctrl.trackingNumber" ng-model-options="{ updateOn : 'default blur' }"
                                       placeholder="Tracking No" capitalize />

                                <div class="my-messages" ng-if="ctrl.trackingNumberValidation && !ctrl.trackingNumber">
                                    <strong style="color: red;"><g:message code="required.error.message"/></strong>
                                </div>                             

                            </div>

                            <br style="clear: both;"/>

                            <br style="clear: both;"/>

                            <div id="grid1" ui-grid="gridPackoutShipmentLine" ui-grid-exporter ui-grid-pagination
                                 ui-grid-pinning ui-grid-resize-columns ui-grid-auto-resize class="grid">
                                <div class="noDataMessage" ng-if="gridPackoutShipmentLine.data.length == 0"><g:message
                code="shipment.grid.noData.message"/></div>
                                <br style="clear: both;"/>
                            </div>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="pull-right">
                                <button type="button" class="btn btn-xs btn-primary startPickBtn" ng-if="ctrl.showConfirmAll" ng-click="ctrl.confirmAllShipmentLines()">Confirm All</button>
                                <button type="button" class="btn btn-xs btn-primary startPickBtn" ng-if="ctrl.showCloseout" ng-click="ctrl.closeOutShipment()">Closeout Shipment</button>
                            </div>

                    </div>

                    <div class="wave-modal-footer modal-footer">
                        <div class="col-md-6 pull-right" style="width: initial;" ng-if='!ctrl.isEditWave'>
                            <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                        </div>


                    </form>
                    </div>
                </div>
            </div>
        </div>

    </div> -->
    </div>

    <asset:javascript src="datagrid/packout.js"/>

    <script type="text/javascript">
        var dvPackoutApp = document.getElementById('dvPackoutApp');
        angular.element(document).ready(function () {
            angular.bootstrap(dvPackoutApp, ['packoutApp']);
        });
    </script>

    <asset:javascript src="autocomplete/angular-sanitize.js"/>
    <asset:javascript src="autocomplete/auto-complete.js"/>
    <asset:javascript src="autocomplete/auto-complete-multi.js"/>
    <asset:javascript src="inventory/order-auto-complete-div.js"/>
    <asset:javascript src="autocomplete/auto-complete-textbox.js"/>

</body>
</html>
