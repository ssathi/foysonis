<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2015-11-13
  Time: 7:15 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="foysonis2016"/>

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
        height: 1220px;
    }

    .grid-inventory {
        height: 450px;
    }

    .grid-align {
        text-align: center;
    }

    .dropdown-menu {
        min-width: 90px;
    }

    .noItemMessage {
        position: absolute;
        top : 30%;
        opacity: 0.4;
        font-size: 40px;
        width: 100%;
        text-align: center;
        z-index: auto;
    }


    .receipt-modal-dialog {
        width: 100%;
        height: 100%;
        margin: 0;
        padding: 0;
    }

    .receipt-modal-content {
        height: auto;
        min-height: 100%;
        border-radius: 0;
    }


    .receipt-modal-header {
        background: #547CA2;
        height: 70px;
    }

    .receipt-panel-title {
        margin-top: -30px;
        color: #ffffff;
    }

    .receipt-modal-body {
        position: fixed;
        top: 70px;
        bottom: 70px;
        width: 100%;
        overflow: scroll;
        padding: 15px
    }

    .receipt-modal-footer {
        position: fixed;
        right: 0;
        bottom: 0;
        left: 0;
        border-top: 2px solid #547CA2;
        height: 70px;
    }

    .receipt-close {
        color: #FFFFFF;
        opacity: 1;
    }
    .receivedDivBox{
        margin-left: 15px;
        font-size: 14px;
        line-height: 2;
        font-weight: bold;
        color: #ffffff;
        text-align: center;
        border-radius: 100px;
        width: initial;
        height: 25px;
    }
    .gridIcon {
        display: inline;
        padding: .2em .6em .3em;
        font-size: 75%;
        font-weight: bold;
        line-height: 1;
        color: #ffffff;
        text-align: center;
        white-space: nowrap;
        vertical-align: baseline;
        border-radius: 100px;
    }
    .gridLabel-default {
        background-color: #777;
    }

    .partiallyReceivedDiv{
        display: inline-block;
        width: 150px;
        height: 22px;
        border-radius: 4px;
        background-color: #b6df6a;
        color: #403f3f;
        margin-top: 3px;
        vertical-align: top;
    }
    .fullyReceivedDiv{
        display: inline-block;
        width: 150px;
        height: 22px;
        border-radius: 4px;
        background-color: #33c5c5;
        color: #ffffff;
        vertical-align: top;
        margin-top: 3px;
    }
    .notReceivedDiv{
        display: inline-block;
        width: 150px;
        height: 22px;
        border-radius: 4px;
        background-color: #f1e184;
        color: #403f3f;
        margin-top: 3px;
        vertical-align: top;
    }
    .overReceivedDiv{
        display: inline-block;
        width: 150px;
        height: 22px;
        border-radius: 4px;
        background-color:#f49325;
        color: #ffffff;
        margin-top: 3px;
        vertical-align: top;
    }
    .receiptStatusDivMin{
        display: inline-block;
        text-align: center;
        width: 30px;
        height: 22px;
        border-radius: 4px;
        color: #ffffff;
        margin-top: 3px;
        vertical-align: top;
    }

    .pendingPutawayBtn{
        height: 37px;
        width: 130px;
        line-height: 1;
        border-color: #23A39C !important;
        color: #23A39C;
        padding-left: 10px;
        margin-top: -10px;
    }

    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    </style>


    <%-- **************************** End of CSS **************************** --%>
</head>

<body>

<div ng-cloak class="row" id="dvReceiving" ng-controller="ReceivingCtrl as ctrl">

    <div class="col-lg-12">



        <%-- **************************** create Receipt form **************************** --%>
        <!-- <div class="panel panel-default">
            <div class="panel-body" > -->
                <div style="display: inline;"><em class="fa  fa-fw mr-sm" style="padding-right: 30px;" ><img style="height: 30px;" src="/foysonis2016/app/img/receiving_header.svg"></em>&emsp;&nbsp;<span class="headerTitle">Receiving</span></div>

                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation"  href="javascript:void(0);">

                    <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide()">
                        <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                        <g:message code="default.button.createReceipt.label" />
                    </button>
                </a>
                <br style="clear: both;"/>
                <br style="clear: both;"/>

                <div  class="alert alert-success message-animation" role="alert" ng-if="ctrl.showSubmittedPrompt">
                    %{--<g:message code="receipt.start.message" /> "{{ctrl.receiptIdForMessage}}"--}%
                    %{--<g:message code="receipt.create.message" />--}%
                    <g:message code="receipt.create.message" />

                </div>
                <div ng-show="IsVisible" class="row">

                    <form name="ctrl.createReceiptForm" ng-submit="ctrl.createReceipt()" novalidate >

                        <div class="panel panel-default" id="panel-anim-fadeInDown">
                            <div class="panel-heading">
                                <div class="panel-title"><g:message code="default.receipt.add.label" /></div>
                            </div>

                            <div class="panel-body">

                                <div class="col-md-12">
                                    <div class="col-md-6">

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('receiptId')}">

                                            %{--<label for="receiptId">Receipt Id</label>--}%
                                            <label for="receiptId"><g:message code="form.field.receiptNo.label" /></label>
                                            <input id="receiptId" name="receiptId" class="form-control" type="text" maxlength="40" required capitalize char-validator
                                                   ng-model="ctrl.newReceipt.receiptId"
                                                   ng-focus="ctrl.toggleReceiptIdPrompt(true)" ng-blur="ctrl.toggleReceiptIdPrompt(false); ctrl.uniqueReceiptIdValidation(ctrl.newReceipt.receiptId)"  tabindex="1" />


                                            <div class="my-messages"  ng-messages="ctrl.createReceiptForm.receiptId.$error"
                                                 ng-if="ctrl.createReceiptForm.$error.receiptIdExists">
                                                <div class="message-animation" >
                                                    <strong><g:message code="required.receiptIdExists.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages" ng-messages="ctrl.createReceiptForm.receiptId.$error" ng-if="ctrl.showMessages('receiptId')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('inboundTruckId')}">
                                            %{--<label for="inboundTruckId">Inbound Truck Id</label>--}%
                                            <label for="inboundTruckId"><g:message code="form.field.inboundId.label" /></label>
                                            <input id="inboundTruckId" name="inboundTruckId" class="form-control" type="text"
                                                   ng-model="ctrl.newReceipt.inboundTruckId" ng-model-options="{ updateOn : 'blur' }"
                                                   ng-focus="ctrl.toggleInboundTruckIdPrompt(true)" ng-blur="ctrl.toggleInboundTruckIdPrompt(false)" tabindex="3" />


                                        </div>

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('receiptType')}">
                                            <label for="receiptType"><g:message code="form.field.receiptType.label" /></label>
                                            <select  id="receiptType" name="receiptType" ng-model="ctrl.newReceipt.receiptType" class="form-control" ng-change="ctrl.validateReceiptType()">
                                                <option selected value=""></option>
                                                <option ng-repeat="receiptType in receiptTypList" value="{{receiptType}}">{{receiptType}}</option>
                                            </select>

                                        </div>


                                    </div>

                                    <div class="col-md-6">

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('receiptDate')}">
                                            <label for="receiptDate"><g:message code="form.field.receiptDate.label" /></label>
                                            %{--<input id="receiptDate" name="receiptDate" class="form-control" type="date" required--}%
                                                   %{--ng-model="ctrl.newReceipt.receiptDate" ng-model-options="{ updateOn : 'blur' }"--}%
                                                   %{--ng-focus="ctrl.toggleReceiptDatePrompt(true)" ng-blur="ctrl.toggleReceiptDatePrompt(false)" />--}%


                                            <p class="input-group">
                                                <input name="receiptDate" type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                       ng-model="ctrl.newReceipt.receiptDate" is-open="popupReceiptDate.opened"
                                                       datepicker-options="dateOptions"  ng-required="true" close-text="Close"
                                                       alt-input-formats="altInputFormats" tabindex="2" />
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-default" ng-click="openReceiptDate()">
                                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                                </span>
                                            </p>


                                            <div class="my-messages" ng-messages="ctrl.createReceiptForm.receiptDate.$error" ng-if="ctrl.showMessages('receiptDate')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('inboundProNumber')}">
                                            %{--<label for="inboundProNumber">Inbound Pro Number</label>--}%
                                            <label for="inboundProNumber"><g:message code="form.field.inboundNo.label" /></label>
                                            <input id="inboundProNumber" name="inboundProNumber" class="form-control" type="text"
                                                   ng-model="ctrl.newReceipt.inboundProNumber" ng-model-options="{ updateOn : 'blur' }"
                                                   ng-focus="ctrl.toggleInboundProNumberPrompt(true)" ng-blur="ctrl.toggleInboundProNumberPrompt(false)" tabindex="4" />

                                        </div>

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('customerId')}">
                                        <label for="customerId"><g:message code="form.field.customer.label" /></label>
                                            <div auto-complete  source="loadCustomerAutoComplete"  xxxx-list-formatter="customListFormatter" value-changed="addNewCustomer(value.contactName, value.customerId);">

                                                <input id="customerId" name="customerId"  ng-model="ctrl.newReceipt.customerContactName"  ng-model-options="{ updateOn : 'default blur' }" placeholder="Customer Id" class="form-control" ng-required="ctrl.newReceipt.receiptType" tabindex="2" ng-disabled="ctrl.disableCustomerAutoComplete" />

                                                <div class="my-messages" ng-messages="ctrl.createReceiptForm.customerId.$error" ng-if="ctrl.showMessages('customerId')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>


                                    </div>
                                </div>


                                <div class = "col-md-12" ><br/><br/>
                                    <div class="col-md-1" style="width:40px;"><label><g:message code="form.field.no.label" /></label></div>
                                    <div class="col-md-2"><label><g:message code="form.field.receiptLineNo.label" /></label></div>
                                    <div class="col-md-2"><label><g:message code="form.field.itemId.label" /></label></div>
                                    <div class="col-md-1" style="width:120px;"><label><g:message code="form.field.uom.label" /></label></div>
                                    <div class="col-md-1"><label><g:message code="form.field.ExpQty.label" /></label></div>
                                    <div class="col-md-2"><label><g:message code="form.field.ExpLotCode.label" /></label></div>
                                    <div class="col-md-2"><label><g:message code="form.field.ExpExpirationDate.label" /></label></div>
                                </div>
                                <div class = "col-md-12" ng-repeat = "index in ctrl.getNewField(ctrl.addNewFieldNum) track by $index"><hr style="margin: 10px 0;">
                                    <div class = "col-md-1" style="width:40px;"><label>{{$index +1}}.</label></div>
                                    <div class="col-md-2">
                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('receiptLineNumber'+$index)}">
                                            <input id="{{'receiptLineNumber'+$index}}" name="{{'receiptLineNumber'+$index}}" class="form-control" type="text"
                                                   ng-model="ctrl.newReceipt.receiptLine[$index].receiptLineNumber" ng-model-options="{ updateOn : 'default blur' }"
                                                   ng-focus="ctrl.toggleReceiptLineNumberPrompt($index)" ng-blur="ctrl.checkReceiptLineIdUnique(ctrl.newReceipt.receiptLine[$index].receiptLineNumber, $index)" maxlength="40" capitalize required  />


                                            <div class="my-messages" ng-messages="ctrl.createReceiptForm.receiptLineNumber{{$index}}.$error" ng-if="ctrl.showMessages('receiptLineNumber'+$index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>


                                            <div class="my-messages"  ng-messages="ctrl.createReceiptForm.receiptId+$index.$error"
                                                 ng-if="ctrl.isReceiptLineIdExist[$index]">
                                                <div class="message-animation" >
                                                    <strong><g:message code="required.receiptLineNoExists.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div ng-init = "ctrl.newReceipt.receiptLine[$index].receiptLineNumber = ctrl.receiptLineNumberList[$index]"></div>
                                        </div>
                                    </div>



                                    <div class="col-md-2">

                                        <!-- <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('itemId')}">
                                                    <input id="itemId" name="itemId" class="form-control" type="text"
                                                           ng-model="ctrl.newReceipt.receiptLine[$index].itemId" ng-model-options="{ updateOn : 'default blur' }"
                                                           ng-focus="ctrl.toggleItemIdPrompt($index)" ng-blur="ctrl.validateItemId(ctrl.newReceipt.receiptLine[$index].itemId, $index)"/>

                                                </div>  -->

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('itemId'+$index)}">
                                            <div auto-complete  source="loadCompanyItems"  xxxx-list-formatter="customListFormatter"
                                                 value-changed="ctrl.validateItemId(value.contactName, $index)">
                                                <input id="{{'itemId'+$index}}" name="{{'itemId'+$index}}" ng-model="ctrl.newReceipt.receiptLine[$index].itemId"  ng-model-options="{ updateOn : 'default blur' }" placeholder="Item Id" class="form-control" required tabindex="{{4+($index*4)+1}}" set-autofocus="$index == ctrl.focusVal" />
                                            </div>

                                            <div class="my-messages" ng-messages="ctrl.createReceiptForm.itemId{{$index}}.$error" ng-if="ctrl.showMessages('itemId'+$index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>


                                        </div>



                                    </div>


                                    <div class="col-md-1" style="width:120px;">
                                        <div ng-if = "ctrl.lowestUomEach[$index]" class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('uom')}">
                                            <div ng-init ="ctrl.newReceipt.receiptLine[$index].uom = 'EACH'"></div>
                                            <input  id="uom" name="uom" ng-model="ctrl.newReceipt.receiptLine[$index].uom" class="form-control" disabled />
                                        </div>

                                        <div ng-if = "!ctrl.lowestUomEach[$index]" class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('uom')}">
                                            <div ng-init ="ctrl.newReceipt.receiptLine[$index].uom = 'CASE'"></div>
                                            <input  id="uom" name="uom" ng-model="ctrl.newReceipt.receiptLine[$index].uom" class="form-control" disabled  />
                                        </div>

                                    </div>


                                    <div class="col-md-1">
                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('expectedQuantity'+$index)}">
                                            <input id="{{'expectedQuantity' + $index}}" name="{{'expectedQuantity' + $index}}" class="form-control" type="text"
                                                   ng-model="ctrl.newReceipt.receiptLine[$index].expectedQuantity" ng-model-options="{ updateOn : 'default blur' }"
                                                   ng-focus="ctrl.toggleExpectedQuantityPrompt($index)" ng-blur="ctrl.toggleExpectedQuantityPrompt(-1)" numbers-only required tabindex="{{4+($index*4)+2}}" />



                                            <div class="my-messages" ng-messages="ctrl.createReceiptForm.expectedQuantity{{$index}}.$error" ng-if="ctrl.showMessages('expectedQuantity'+$index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>



                                    <div class="col-md-2">
                                        <div ng-if ="ctrl.lotCodeTracked[$index]" class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('expectedLotCode'+ $index)}">
                                            <input id="{{'expectedLotCode' + $index}}" name="{{'expectedLotCode' + $index}}" class="form-control" type="text"
                                                   ng-model="ctrl.newReceipt.receiptLine[$index].expectedLotCode" ng-model-options="{ updateOn : 'default blur' }"
                                                   ng-focus="ctrl.toggleExpectedLotCodePrompt($index)" ng-blur="ctrl.toggleExpectedLotCodePrompt(-1);" maxlength="30" tabindex="{{4+($index*4)+3}}"/>


                                            <!-- <div class="my-messages" ng-messages="ctrl.createReceiptForm.expectedLotCode{{$index}}.$error" ng-if="ctrl.showMessages('expectedLotCode'+ $index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div> -->


                                        </div>

                                        <div ng-if ="!ctrl.lotCodeTracked[$index]" class="form-group">
                                            <input class="form-control" type="text" placeholder="Lot Code" disabled/>
                                        </div>

                                    </div>


                                    <div class="col-md-2">

                                        <div ng-if ="ctrl.isExpired[$index]" class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('expectedExpirationDate'+ $index)}">
                                            <input id="{{'expectedExpirationDate' + $index}}" name="{{'expectedExpirationDate' + $index}}" class="form-control" type="date"
                                                   ng-model="ctrl.newReceipt.receiptLine[$index].expectedExpirationDate" ng-model-options="{ updateOn : 'default blur' }"
                                                   ng-focus="ctrl.toggleExpectedExpirationDatePrompt($index)" ng-blur="ctrl.toggleExpectedExpirationDatePrompt(-1)" maxlength="15" style="width:160px;" tabindex="{{4+($index*4)+4}}"/>

                                            <!-- <div class="my-messages" ng-messages="ctrl.createReceiptForm.expectedExpirationDate{{$index}}.$error" ng-if="ctrl.showMessages('expectedExpirationDate'+ $index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div> -->

                                        </div>


                                        <div ng-if ="!ctrl.isExpired[$index]" class="form-group">
                                            <input class="form-control" type="text" placeholder="Expiration Date" style="width:160px;" disabled/>
                                        </div>

                                    </div>

                                    <div class="col-md-1">
                                        <button type="button"  ng-click = "ctrl.deleteReceiptLineRaw($index)" class="btn btn-default" >X</button>
                                    </div>
                                    <!-- <input type = "hidden" ng-model = "ctrl.lineCountIndex = $index"  /> -->
                                    <div ng-init="ctrl.lineCountIndex = $index"></div>
                                </div>

                                <div class="col-md-12" ng-click = "ctrl.addNewField(ctrl.lineCountIndex)" ng-focus= "ctrl.addNewField(ctrl.lineCountIndex)"style="cursor:text" id="addNewLine" tabindex="{{4+(ctrl.lineCountIndex*4)+4}}">
                                    <hr style="margin: 10px 0;">
                                    <div class = "col-md-1"><label>{{ctrl.lineCountIndex +2}}.</label></div>
                                </div>

                                <div class="col-md-12">
                                    <div class="panel-footer">
                                        <div class="pull-left">
                                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                <button class="btn btn-default" type="button" ng-click="ShowHide()"><g:message code="default.button.cancel.label" /></button>
                                            </a>

                                        </div>
                                        <div class="pull-right">
                                            <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disableSaveReceiptBtn"><g:message code="default.button.save.label" /></button>
                                        </div>
                                        <br style="clear: both;"/>
                                    </div>
                                </div>


                            </div>
                        </div>
                    </form>

                </div>

                <%-- **************************** End of create Receipt form **************************** --%>


                <%-- ****************************Start Edit Receipt form **************************** --%>
                <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showUpdatedPrompt">
                    %{--<g:message code="receipt.start.message" /> "{{ctrl.receiptIdForMessageEdit}}"--}%
                    <g:message code="receipt.edit.message" />

                </div>
                <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showCompletedPrompt">
                    %{--<g:message code="receipt.start.message" /> "{{ctrl.receiptIdForMessageEdit}}"--}%
                    <g:message code="receipt.complete.message" />
                </div>
                <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showDeletedPrompt">
                    %{--<g:message code="receipt.start.message" /> "{{ctrl.receiptIdForMessageEdit}}"--}%
                    <g:message code="receipt.delete.message" />
                </div>
                <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showReOpenedPrompt">
                    %{--<g:message code="receipt.start.message" /> "{{ctrl.receiptIdForMessageEdit}}"--}%
                    <g:message code="receipt.reOpen.message" />
                </div>

                <div ng-show="ctrl.editReceiptState" class="row">

                    <form name="ctrl.editReceiptForm" ng-submit="ctrl.updateReceipt()" novalidate >

                        <div class="panel panel-default" id="panel-anim-fadeInDown">
                            <div class="panel-heading">
                                <div class="panel-title"><g:message code="default.receipt.edit.label" /></div>
                            </div>

                            <div class="panel-body">

                                <div class="col-md-12">
                                    <div class="col-md-6">

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('receiptId')}">

                                            <label for="receiptId"><g:message code="form.field.receiptId.label" /></label>
                                            <input id="receiptId" name="receiptId" class="form-control" type="text" maxlength="40" capitalize
                                                   ng-model="ctrl.editReceipt.receiptId" ng-model-options="{ updateOn : 'blur' }"
                                                   ng-focus="ctrl.toggleReceiptIdPromptEdit(true)" ng-blur="ctrl.toggleReceiptIdPromptEdit(false)" disabled/>

                                        </div>

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('inboundTruckId')}">
                                            <label for="inboundTruckId"><g:message code="form.field.inboundId.label" /></label>
                                            <input id="inboundTruckId" name="inboundTruckId" class="form-control" type="text"
                                                   ng-model="ctrl.editReceipt.inboundTruckId" ng-model-options="{ updateOn : 'blur' }"
                                                   ng-focus="ctrl.toggleInboundTruckIdPromptEdit(true)" ng-blur="ctrl.toggleInboundTruckIdPromptEdit(false)" tabindex="2" />

                                        </div>

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('receiptType')}">
                                            <label for="receiptType"><g:message code="form.field.receiptType.label" /></label>
                                            <select  id="receiptType" name="receiptType" ng-model="ctrl.editReceipt.receiptType" class="form-control" ng-change="ctrl.validateReceiptTypeEdit()">
                                                <option selected value=""></option>
                                                <option ng-repeat="receiptType in receiptTypList" value="{{receiptType}}">{{receiptType}}</option>
                                            </select>

                                        </div>

                                    </div>

                                    <div class="col-md-6">

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('receiptDate')}">
                                            <label><g:message code="form.field.receiptDate.label" /></label>
                                            %{--<input id="receiptDate" name="receiptDate" class="form-control" type="date" required--}%
                                            %{--ng-model="ctrl.editReceipt.receiptDate" ng-model-options="{ updateOn : 'blur' }"--}%
                                            %{--ng-focus="ctrl.toggleReceiptDatePromptEdit(true)" ng-blur="ctrl.toggleReceiptDatePromptEdit(false)" />--}%



                                            <p class="input-group">
                                                <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                       ng-model="ctrl.editReceipt.receiptDate" is-open="popupReceiptDateEdit.opened"
                                                       datepicker-options="dateOptions"  ng-required="true" close-text="Close"
                                                       alt-input-formats="altInputFormats" tabindex="1" />
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-default" ng-click="openReceiptDateEdit()">
                                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                                </span>
                                            </p>

                                            <div class="my-messages" ng-messages="ctrl.editReceiptForm.receiptDate.$error" ng-if="ctrl.showMessagesEdit('receiptDate')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('inboundProNumber')}">
                                            <label for="inboundProNumber"><g:message code="form.field.inboundNo.label" /></label>
                                            <input id="inboundProNumber" name="inboundProNumber" class="form-control" type="text"
                                                   ng-model="ctrl.editReceipt.inboundProNumber" ng-model-options="{ updateOn : 'blur' }"
                                                   ng-focus="ctrl.toggleInboundProNumberPromptEdit(true)" ng-blur="ctrl.toggleInboundProNumberPromptEdit(false)" tabindex="3" />


                                        </div>

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('customerId')}">
                                        <label for="customerId"><g:message code="form.field.customer.label" /></label>
                                            <div auto-complete  source="loadCustomerAutoComplete"  xxxx-list-formatter="customListFormatter" value-changed="addNewCustomerEdit(value.contactName, value.customerId);" >

                                                <input id="customerId" name="customerId"  ng-model="ctrl.editReceipt.customerContactName"  ng-model-options="{ updateOn : 'default blur' }" placeholder="Customer Id" class="form-control" ng-required="ctrl.editReceipt.receiptType" ng-disabled="ctrl.disableCustomerAutoCompleteEdit" />

                                                <div class="my-messages" ng-messages="ctrl.editReceiptForm.customerId.$error" ng-if="ctrl.showMessagesEdit('customerId')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                    </div>
                                </div>


                                <div class = "col-md-12" ><br/><br/>
                                    <div class="col-md-1" style="width:40px;"><label><g:message code="form.field.no.label" /></label></div>
                                    <div class="col-md-2"><label><g:message code="form.field.receiptLineNo.label" /></label></div>
                                    <div class="col-md-2"><label><g:message code="form.field.itemId.label" /></label></div>
                                    <div class="col-md-1" style="width:120px;"><label><g:message code="form.field.uom.label" /></label></div>
                                    <div class="col-md-1"><label><g:message code="form.field.ExpQty.label" /></label></div>
                                    <div class="col-md-2"><label><g:message code="form.field.ExpLotCode.label" /></label></div>
                                    <div class="col-md-2"><label><g:message code="form.field.ExpExpirationDate.label" /></label></div>
                                </div>
                                <div class = "col-md-12" ng-repeat = "index in ctrl.getNewField(ctrl.addNewFieldNum) track by $index"><hr style="margin: 10px 0;">

                                    <div class = "col-md-1" style="width:40px;"><label>{{$index +1}}.</label></div>
                                    <div class="col-md-2">
                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('receiptLineNumber'+$index)}">
                                            <input id="{{'receiptLineNumber'+$index}}" name="{{'receiptLineNumber'+$index}}" class="form-control" type="text"
                                                   ng-model="ctrl.editReceipt.receiptLine[$index].receiptLineNumber" ng-model-options="{ updateOn : 'default blur' }"
                                                   ng-focus="ctrl.toggleReceiptLineNumberPrompt($index)" ng-blur="ctrl.checkReceiptLineIdUnique(ctrl.editReceipt.receiptLine[$index].receiptLineNumber, $index)" maxlength="40" capitalize required/>

                                            <div class="my-messages" ng-messages="ctrl.editReceiptForm.receiptLineNumber{{$index}}.$error" ng-if="ctrl.showMessagesEdit('receiptLineNumber'+$index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages"  ng-messages="ctrl.editReceiptForm.receiptId+$index.$error"
                                                 ng-if="ctrl.isReceiptLineIdExist[$index]">
                                                <div class="message-animation" >
                                                    <strong><g:message code="required.receiptLineNoExists.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>



                                    <div class="col-md-2">

                                        <!-- <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('itemId')}">
                                                    <input id="itemId" name="itemId" class="form-control" type="text"
                                                           ng-model="ctrl.editReceipt.receiptLine[$index].itemId" ng-model-options="{ updateOn : 'default blur' }"
                                                           ng-focus="ctrl.toggleItemIdPrompt($index)" ng-blur="ctrl.validateItemId(ctrl.editReceipt.receiptLine[$index].itemId, $index)"/>

                                                </div>  -->
                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('itemId'+$index)}">
                                            <div auto-complete  source="loadCompanyItems"  xxxx-list-formatter="customListFormatter"
                                                 value-changed="ctrl.validateItemId(value.contactName, $index, true)" >
                                                <input id="{{'itemId'+$index}}" name="{{'itemId'+$index}}" ng-model="ctrl.editReceipt.receiptLine[$index].itemId"  ng-model-options="{ updateOn : 'default blur' }" placeholder="Item Id" class="form-control" unique-receipt-id-validation required set-autofocus="$index == ctrl.focusVal" tabindex="{{3+($index*4)+1}}" />
                                            </div>

                                            <div class="my-messages" ng-messages="ctrl.editReceiptForm.itemId{{$index}}.$error" ng-if="ctrl.showMessagesEdit('itemId'+$index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>

                                            </div>

                                        </div>
                                    </div>


                                    <div class="col-md-1" style="width:120px;">

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('uom')}">
                                            <input  id="uom" name="uom" ng-model="ctrl.editReceipt.receiptLine[$index].uom" class="form-control" disabled />
                                        </div>

                                    </div>


                                    <div class="col-md-1">
                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('expectedQuantity'+$index)}">
                                            <input id="{{'expectedQuantity' + $index}}" name="{{'expectedQuantity' + $index}}" class="form-control" type="text"
                                                   ng-model="ctrl.editReceipt.receiptLine[$index].expectedQuantity" ng-model-options="{ updateOn : 'default blur' }"
                                                   ng-focus="ctrl.toggleExpectedQuantityPrompt($index)" ng-blur="ctrl.validateReceiptLineExpectedQty(ctrl.receiptLineData[$index].receiptLineId,ctrl.editReceipt.receiptLine[$index].expectedQuantity)" numbers-only required tabindex="{{3+($index*4)+2}}"/>



                                            <div class="my-messages" ng-messages="ctrl.editReceiptForm.expectedQuantity{{$index}}.$error" ng-if="ctrl.showMessagesEdit('expectedQuantity'+$index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>



                                    <div class="col-md-2">
                                        <div ng-if ="ctrl.lotCodeTracked[$index]" class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('expectedLotCode'+ $index)}">
                                            <input id="{{'expectedLotCode' + $index}}" name="{{'expectedLotCode' + $index}}" class="form-control" type="text"
                                                   ng-model="ctrl.editReceipt.receiptLine[$index].expectedLotCode" ng-model-options="{ updateOn : 'default blur' }"
                                                   ng-focus="ctrl.toggleExpectedLotCodePrompt($index)" ng-blur="ctrl.toggleExpectedLotCodePrompt(-1)" maxlength="30" tabindex="{{3+($index*4)+3}}"/>


                                            <!-- <div class="my-messages" ng-messages="ctrl.editReceiptForm.expectedLotCode{{$index}}.$error" ng-if="ctrl.showMessagesEdit('expectedLotCode'+ $index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div> -->


                                        </div>

                                        <div ng-if ="!ctrl.lotCodeTracked[$index]" class="form-group">
                                            <input class="form-control" type="text" placeholder="Lot Code" disabled/>
                                        </div>

                                    </div>


                                    <div class="col-md-2">
                                        <div ng-if ="ctrl.isExpired[$index]" class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('expectedExpirationDate'+ $index)}">
                                            <input id="{{'expectedExpirationDate' + $index}}" name="{{'expectedExpirationDate' + $index}}" class="form-control" type="date"
                                                   ng-model="ctrl.editReceipt.receiptLine[$index].expectedExpirationDate" ng-model-options="{ updateOn : 'default blur' }"
                                                   ng-focus="ctrl.toggleExpectedExpirationDatePrompt($index)" ng-blur="ctrl.toggleExpectedExpirationDatePrompt(-1)" maxlength="15" style="width:160px;" tabindex="{{3+($index*4)+4}}"/>

                                            <!-- <div class="my-messages" ng-messages="ctrl.editReceiptForm.expectedExpirationDate{{$index}}.$error" ng-if="ctrl.showMessagesEdit('expectedExpirationDate'+ $index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div> -->

                                        </div>

                                        <div ng-if ="!ctrl.isExpired[$index]" class="form-group">
                                            <input class="form-control" type="text" placeholder="Expiration Date" style="width:160px;" disabled/>
                                        </div>

                                    </div>

                                    <div class="col-md-1">
                                        <button type="button"  ng-click = "ctrl.deleteReceiptLineRawEdit($index)" class="btn btn-default">X</button>
                                    </div>

                                    <!-- <input type = "hidden" ng-model = "ctrl.lineCountIndex = $index" /> -->
                                    <div ng-init="ctrl.lineCountIndex = $index"></div>
                                    <div
                                            ng-init = "ctrl.editReceipt.receiptLine[$index].receiptLineNumber = ctrl.receiptLineNumberListEdit[$index];
                                        ctrl.editReceipt.receiptLine[$index].receiptLineId = ctrl.receiptLineData[$index].receiptLineId;
                                        ctrl.editReceipt.receiptLine[$index].itemId = ctrl.receiptLineData[$index].itemId;
                                        ctrl.editReceipt.receiptLine[$index].uom = ctrl.receiptLineData[$index].uom;
                                        ctrl.editReceipt.receiptLine[$index].expectedQuantity = ctrl.receiptLineData[$index].expectedQuantity;
                                        ctrl.editReceipt.receiptLine[$index].expectedLotCode = ctrl.receiptLineData[$index].expectedLotCode;
                                        ctrl.editReceipt.receiptLine[$index].expectedExpirationDate = ctrl.convertDate(ctrl.receiptLineData[$index].expectedExpirationDate);
                                        ctrl.validateItemId(ctrl.editReceipt.receiptLine[$index].itemId, $index, true);">
                                    </div>

                                </div>

                                <div class="col-md-12" ng-click = "ctrl.addNewFieldEdit(ctrl.lineCountIndex)" ng-focus= "ctrl.addNewFieldEdit(ctrl.lineCountIndex)" style="cursor:text" id="addNewLineEdit"  tabindex="{{3+(ctrl.lineCountIndex*4)+5}}">
                                    <hr style="margin: 10px 0;">
                                    <div class = "col-md-1"><label>{{ctrl.lineCountIndex +2}}.</label></div>
                                </div>

                                <div class="col-md-12">
                                    <div class="panel-footer">
                                        <div class="pull-left">
                                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                <button class="btn btn-default" type="button" ng-click="HideEditForm()"><g:message code="default.button.cancel.label" /></button>
                                            </a>

                                        </div>
                                        <div class="pull-right">
                                            <button class="btn btn-default" type="button" ng-click="ctrl.deleteReceipt()"><g:message code="default.button.deleteReceipt.label" /></button>&nbsp;&nbsp;
                                            <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disableReceiptUpdateBtn"><g:message code="default.button.update.label" /></button>
                                        </div>
                                        <br style="clear: both;"/>
                                    </div>
                                </div>


                            </div>
                        </div>
                    </form>

                </div>

                <%-- **************************** End of Edit Receipt form **************************** --%>
            <!-- </div>
        </div> -->


        <!--************************ start search form ******************************-->
        <div class="panel panel-default">
            <div class="panel-body">
                <form name="ctrl.searchForm"  ng-submit="ctrl.search()">

                    <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                        <!-- START Wizard Step inputs -->
                        <div>
                            <fieldset>


                                <legend>
                                    <g:message code="default.search.label" />
                                    <button type="button" class="btn btn-default pull-right pendingPutawayBtn" ng-click="showPendingPutaway()">
                                        <g:message code="default.button.pendingPutaway.label" />
                                    </button>


                                </legend>

                                <div class="row">

                                    <div class="col-md-4">
                                        <div class="form-group" ng-class="">
                                            <label for="receiptId"><g:message code="form.field.receiptNo.label" /></label>
                                            <input id="receiptId" name="receiptId" class="form-control" type="text" value="${receiptId}"
                                                   ng-model="ctrl.receiptId" ng-blur="ctrl.disableFindButton()"
                                                   placeholder="Receipt No" capitalize char-validator />
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group" ng-class="">
                                            <label for="status"><g:message code="form.field.receiptStatus.label" /></label>
                                            <select  id="status" name="status" ng-model="ctrl.status" class="form-control" value="${status}" ng-blur="ctrl.disableFindButton()" >
                                                <option selected value=""></option>
                                                <option value="Open">Open</option>
                                                <option value="Close">Close</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group" ng-class="">
                                            <label for="status"><g:message code="form.field.receiptType.label" /></label>
                                            <select  id="receiptType" name="receiptType" ng-model="ctrl.receiptType" class="form-control" ng-blur="ctrl.disableFindButton()">
                                                <option selected value=""></option>
                                                <option ng-repeat="receiptType in receiptTypList" value="{{receiptType}}">{{receiptType}}</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-md-4" style="margin-bottom: 15px; margin-top: 15px;">
                                        <div class="form-group" ng-class="">
                                            <label for="receiptDate"><g:message code="form.field.receiptDateFrom.label" /></label>
                                            %{--<input id="fromReceiptDate" name="receiptDate" class="form-control" type="date" value="${receiptDate}"--}%
                                                   %{--ng-model="ctrl.receiptDate" ng-blur="ctrl.disableFindButton()"--}%
                                                   %{--placeholder="Receipt Date" />--}%

                                            <p class="input-group">
                                                <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                       ng-model="ctrl.receiptDate" is-open="popupReceiptDateFrom.opened"
                                                       datepicker-options="dateOptions"  ng-required="false" close-text="Close"
                                                       alt-input-formats="altInputFormats" />
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-default" ng-click="openReceiptDateFrom()">
                                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                                </span>
                                            </p>


                                        </div>
                                    </div>


                                    <div class="col-md-4" style="margin-bottom: 15px; margin-top: 15px;">
                                        <div class="form-group" ng-class="">
                                            <label><g:message code="form.field.receiptDateTo.label" /></label>
                                            %{--<input id="toReceiptDate" name="toReceiptDate" class="form-control" type="date" value="${toReceiptDate}"--}%
                                                   %{--ng-model="ctrl.toReceiptDate" ng-blur="ctrl.disableFindButton()"--}%
                                                   %{--placeholder="Receipt Date" />--}%

                                            <p class="input-group">
                                                <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                       ng-model="ctrl.toReceiptDate" is-open="popupReceiptDateTo.opened"
                                                       datepicker-options="dateOptions"  ng-required="false" close-text="Close"
                                                       alt-input-formats="altInputFormats" />
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-default" ng-click="openReceiptDateTo()">
                                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                                </span>
                                            </p>


                                        </div>
                                    </div>

                                </div>

                            </fieldset>

                            <div class="pull-right">
                                <button type="submit" class="btn btn-primary findBtn">
                                    <g:message code="default.button.searchReceipt.label" />
                                </button>
                            </div>

                        </div>
                        <!-- END Wizard Step inputs -->
                    </div>
                </form>
            </div>
        </div>

        <!--************************** end search form *********************************-->

        <!-- *****************start Receiving Grid ***********************************-->
        <p>
            <div id="grid1" ui-grid="gridItem" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-expandable ui-grid-resize-columns  class="grid" ui-grid-auto-resize>
                <div class="noItemMessage" ng-if="gridItem.data.length == 0"><g:message code="receipt.grid.noData.message" /></div>
            </div>
        </p>
        <!-- ********************** end OF Receiving Grid ********************************-->
    </div>

    <!-- start inventory view popup -->
    <div id="inventoryView" class="modal fade" role="dialog" >
        <div class="receipt-modal-dialog modal-dialog"  style="width: 100%;">
            <div class="receipt-modal-content modal-content">
                <div class="receipt-modal-header modal-header">
                    <button type="button" class="receipt-close close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <br style="clear: both;"/>

                    <div class="panel-heading">
                        <div class="receipt-panel-title panel-title"><h4>Receive / Putaway</h4></div>
                    </div>
                </div>

                <div class="receipt-modal-body modal-body">

                    <div ng-show="ctrl.receivedInventoryNotify" class="alert alert-success message-animation" role="alert" >
                        %{--<g:message code="receipt.inventoryReceivedStart.message" /> {{ctrl.receiptLineNoForView}}--}%
                        <g:message code="receipt.inventoryReceived.message" />
                    </div>

                    <div class = "col-md-12" >
                        <div class = "col-md-4" >
                            <h4><g:message code="form.field.item.label" />: {{ctrl.receiptItemForView}} - {{ctrl.receiptItemDescriptionForView}}</h4>
                        </div>
                        <div class = "col-md-4" >
                            <h4><g:message code="form.field.receiptNo.label" />: {{ctrl.receiptIdForView}}</h4>
                        </div>
                        <div class = "col-md-4" >
                            <h4><g:message code="form.field.receiptLineNo.label" />: {{ctrl.receiptLineNoForView}}</h4>
                        </div>

                    </div>
                    <br style="clear: both;"/>


                    <div class = "col-md-12" >
                        <div class = "col-md-4" >
                            <h5><g:message code="form.field.ExpQty.label" />: {{ctrl.receiptExpectedQty}}&nbsp;{{ctrl.receiptUom}}</h5>
                        </div>
                        <div class = "col-md-4" >
                            <h5><g:message code="form.field.receivedQty.label" />: {{ctrl.qtyCalculatedData.totalReceivedQty}}&nbsp;{{ctrl.receiptUom}}</h5>
                        </div>

                        <div class = "col-md-4 receivedDivBox label-default" ng-if="ctrl.qtyCalculatedData.receivedQtyStatus == 'notReceived'">
                            <span class="glyphicon glyphicon-ban-circle">&emsp;</span>Not Received</h5>
                        </div>
                        <div class = "col-md-4 receivedDivBox label-success" ng-if="ctrl.qtyCalculatedData.receivedQtyStatus == 'partiallyReceived'">
                            <span class="glyphicon glyphicon-arrow-down">&emsp;</span>Partially Received</h5>
                        </div>
                        <div class = "col-md-4 receivedDivBox label-success" ng-if="ctrl.qtyCalculatedData.receivedQtyStatus == 'equal'">
                            <span class="glyphicon glyphicon-ok-sign">&emsp;</span>Fully Received</h5>
                        </div>
                        <div class = "col-md-4 receivedDivBox label-warning" ng-if="ctrl.qtyCalculatedData.receivedQtyStatus == 'overReceived'">
                            <div><span class="glyphicon glyphicon-arrow-up">&emsp;</span>Over Received</div>
                        </div>

                    </div>
                    <br style="clear: both;"/>
                    <br style="clear: both;"/>


                    <div ng-if="!ctrl.receiptClosed" >

                        <div class = "col-md-12" >
                            <div class="col-md-2"><label>Pallet Id</label></div>
                            <div class="col-md-2"><label>Case Id</label></div>
                            <div class="col-md-1"><label>UOM</label></div>
                            <div class="col-md-1"><label>Quantity</label></div>
                            <div class="col-md-1"><label>Lot Code</label></div>
                            <div class="col-md-2"><label>Expiration Date</label></div>
                            <div class="col-md-1"><label>Status</label></div>
                        </div>


                        <div class="col-md-12">
                            <form name="ctrl.receiveInventory" ng-submit="ctrl.saveReceivedInventory()" novalidate >

                                <div class="col-md-2" ng-class="{'has-error':ctrl.hasErrorClassForReceive('receiveInventoryPalletId')}" ng-if = "ctrl.receiveInventoryCaseIdDisabled">
                                    <input id="receiveInventoryPalletId" name="receiveInventoryPalletId" class="form-control" type="text" ng-model="ctrl.receiveInventoryPalletId" ng-blur="ctrl.uniquePalletIdValidation(ctrl.receiveInventoryPalletId)" ng-keypress="ctrl.barcodeScanInput($event)" capitalize required tabindex="1" />

                                    <div class="my-messages" ng-messages="ctrl.receiveInventory.receiveInventoryPalletId.$error" ng-if="ctrl.showMessagesForReceive('receiveInventoryPalletId')">
                                        <div class="message-animation" ng-message="required">
                                            %{--<strong>This field is required.</strong>--}%
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages"  ng-messages="ctrl.receiveInventory.receiveInventoryPalletId.$error"
                                         ng-if="ctrl.receiveInventory.$error.palletIdExists">
                                        <div class="message-animation" >
                                            <strong><g:message code="receipt.palletIdExists.error.message" /></strong>
                                        </div>
                                    </div>


                                </div>



                                <div class="col-md-2" ng-class="{'has-error':ctrl.hasErrorClassForReceive('receiveInventoryPalletId')}" ng-if = "!ctrl.receiveInventoryCaseIdDisabled">
                                    <input id="receiveInventoryPalletId" name="receiveInventoryPalletId" class="form-control" type="text" ng-model="ctrl.receiveInventoryPalletId" ng-blur="ctrl.uniquePalletIdValidation(ctrl.receiveInventoryPalletId)" ng-keypress="ctrl.barcodeScanInput($event)"  capitalize tabindex="1" />

                                    <div class="my-messages"  ng-messages="ctrl.receiveInventory.receiveInventoryPalletId.$error"
                                         ng-if="ctrl.receiveInventory.$error.palletIdExists">
                                        <div class="message-animation" >
                                            <strong><g:message code="receipt.palletIdExists.error.message" /></strong>
                                        </div>
                                    </div>

                                </div>



                                <div class="col-md-2" ng-class="{'has-error':ctrl.hasErrorClassForReceive('receiveInventoryCaseId')}" ng-if = "!ctrl.receiveInventoryCaseIdDisabled">
                                    <input id="receiveInventoryCaseId" name="receiveInventoryCaseId" class="form-control" type="text" ng-model="ctrl.receiveInventoryCaseId" ng-blur="ctrl.uniqueCaseIdValidation(ctrl.receiveInventoryCaseId)" ng-keypress="ctrl.barcodeScanInput($event)" capitalize required tabindex="2" />

                                    <div class="my-messages" ng-messages="ctrl.receiveInventory.receiveInventoryCaseId.$error" ng-if="ctrl.showMessagesForReceive('receiveInventoryCaseId')">
                                        <div class="message-animation" ng-message="required">
                                            %{--<strong>This field is required.</strong>--}%
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages"  ng-messages="ctrl.receiveInventory.receiveInventoryCaseId.$error"
                                         ng-if="ctrl.receiveInventory.$error.caseIdExists">
                                        <div class="message-animation" >
                                            <strong><g:message code="receipt.caseIdExists.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages"  ng-messages="ctrl.receiveInventory.receiveInventoryCaseId.$error"
                                         ng-if="(ctrl.receiveInventoryCaseId == ctrl.receiveInventoryPalletId) && (ctrl.receiveInventoryCaseId && ctrl.receiveInventoryPalletId)">
                                        <div class="message-animation" >
                                            <strong>Pallet Id and Case id cannot be the same</strong>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-2" ng-if = "ctrl.receiveInventoryCaseIdDisabled">
                                    <input id="receiveInventoryCaseId" name="receiveInventoryCaseId" class="form-control" type="text" ng-model="ctrl.receiveInventoryCaseId" ng-disabled="ctrl.receiveInventoryCaseIdDisabled" capitalize tabindex="2" />
                                </div>


                                <div class="col-md-1" ng-class="{'has-error':ctrl.hasErrorClassForReceive('receiveInventoryUom')}">
                                    <select name="receiveInventoryUom" id="receiveInventoryUom" ng-model="ctrl.receiveInventoryUom" class="form-control" ng-change="ctrl.selectCase()" required tabindex="3">
                                        <option ng-repeat="option in data.availableOptions" ng-value="{{option.id}}">{{option.name}}</option>
                                    </select>

                                    <div class="my-messages" ng-messages="ctrl.receiveInventory.receiveInventoryUom.$error" ng-if="ctrl.showMessagesForReceive('receiveInventoryUom')">
                                        <div class="message-animation" ng-message="required">
                                            <strong>Please select an option.</strong>
                                        </div>
                                    </div>

                                </div>

                                <div class="col-md-1" ng-class="{'has-error':ctrl.hasErrorClassForReceive('receiveInventoryQty')}" ng-if = "!ctrl.receiveInventoryQtyDisabled" >

                                    <input id="receiveInventoryQty" name="receiveInventoryQty" class="form-control" type="text"
                                           ng-model="ctrl.receiveInventoryQty" required numbers-only tabindex="4" />

                                    <div class="my-messages" ng-messages="ctrl.receiveInventory.receiveInventoryQty.$error" ng-if="ctrl.showMessagesForReceive('receiveInventoryQty')">
                                        <div class="message-animation" ng-message="required">
                                            %{--<strong>This field is required.</strong>--}%
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                </div>


                                <div class="col-md-1" ng-if = "ctrl.receiveInventoryQtyDisabled">
                                    <input id="receiveInventoryQty" name="receiveInventoryQty" class="form-control" type="text"
                                           ng-model="ctrl.receiveInventoryQty" ng-disabled="ctrl.receiveInventoryQtyDisabled" tabindex="4"  />
                                </div>

                                <div class="col-md-1" ng-if = "!ctrl.receiveInventoryLotCodeDisabled" ng-class="{'has-error':ctrl.hasErrorClassForReceive('receiveInventoryLotCode')}" >
                                    <input id="receiveInventoryLotCode" name="receiveInventoryLotCode" class="form-control" type="text" ng-model="ctrl.receiveInventoryLotCode" ng-blur="ctrl.validateExpLotcode()" required tabindex="5"  />

                                    <div class="my-messages" ng-messages="ctrl.receiveInventory.receiveInventoryLotCode.$error" ng-if="ctrl.showMessagesForReceive('receiveInventoryLotCode')">
                                        <div class="message-animation" ng-message="required">
                                            %{--<strong>This field is required.</strong>--}%
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages" ng-messages="ctrl.receiveInventory.receiveInventoryLotCode.$error" ng-if="ctrl.IsLotCodeInValid">
                                        <div class="message-animation">
                                            <strong>Lot Code is invalid</strong>
                                        </div>
                                    </div>

                                </div>

                                <div class="col-md-1" ng-if = "ctrl.receiveInventoryLotCodeDisabled" >
                                    <input id="receiveInventoryLotCode" name="receiveInventoryLotCode" class="form-control" type="text" ng-model="ctrl.receiveInventoryLotCode" ng-disabled="ctrl.receiveInventoryLotCodeDisabled"  tabindex="5"/>
                                </div>

                                <div class="col-md-2" ng-if = "!ctrl.receiveInventoryExpireDateDisabled" ng-class="{'has-error':ctrl.hasErrorClassForReceive('receiveInventoryExpireDate')}" >
                                    <input id="receiveInventoryExpireDate" name="receiveInventoryExpireDate" class="form-control" type="date" ng-model="ctrl.receiveInventoryExpireDate" required  tabindex="6"/>

                                    <div class="my-messages" ng-messages="ctrl.receiveInventory.receiveInventoryExpireDate.$error" ng-if="ctrl.showMessagesForReceive('receiveInventoryExpireDate')">
                                        <div class="message-animation" ng-message="required">
                                            %{--<strong>This field is required.</strong>--}%
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>


                                </div>


                                <div class="col-md-2" ng-if = "ctrl.receiveInventoryExpireDateDisabled">
                                    <input id="receiveInventoryExpireDate" name="receiveInventoryExpireDate" class="form-control" type="date" ng-model="ctrl.receiveInventoryExpireDate" ng-disabled="ctrl.receiveInventoryExpireDateDisabled"  tabindex="6" />
                                </div>

                                <div class="col-md-1" ng-class="{'has-error':ctrl.hasErrorClassForReceive('receiveInventoryStatus')}">
                                    <select  id="receiveInventoryStatus" name="receiveInventoryStatus" ng-model="ctrl.receiveInventoryStatus" class="form-control" required  tabindex="7">
                                        <option ng-repeat="option in ctrl.inventoryStatusOptions" value="{{option.optionValue}}">{{option.description}}</option>
                                    </select>

                                    <div class="my-messages" ng-messages="ctrl.receiveInventory.receiveInventoryStatus.$error" ng-if="ctrl.showMessagesForReceive('receiveInventoryStatus')">
                                        <div class="message-animation" ng-message="required">
                                            <strong>Please select an option.</strong>
                                        </div>
                                    </div>


                                </div>
                                <div class="col-md-2">

                                    <a href="javascript:void(0)" uib-popover-template="ctrl.getPopoverTemplateUrl" popover-title=""  popover-append-to-body="true" popover-placement="bottom" popover-trigger="outsideClick" ng-show = "!ctrl.receiveInventoryCaseIdDisabled" tabindex="8">Notes</a> &emsp;

                                    <script type="text/ng-template" id="notesPopover">
                                        <div class="form-group">
                                          <label>Notes :</label>
                                          <textarea class='form-control' rows='5' id='notes' ng-model='ctrl.receiveInventoryItemNotes' placeholder='Enter Note Here....' tabindex="8"></textarea>
                                        </div>
                                    </script>

                                    <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disableReceivedBtn" tabindex="9">{{ctrl.receiveSaveBtnText}}</button>
                                </div>
                            </form>
                        </div>

                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                    </div>

                    <div ng-if="ctrl.receiptClosed" style="text-align: center; color: red;">
                        <h4>You can not receive the inventories for closed receipt.</h4>
                    </div>

                    <br style="clear: both;"/>
                    <br style="clear: both;"/>


                    <div ng-if="ctrl.viewGrid" id="grid2" ui-grid="gridOptions" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-expandable ui-grid-resize-columns class="grid">
                        <div class="noItemMessage" ng-if="gridOptions.data.length == 0"><g:message code="inventory.grid.noData.message" /></div>
                    </div>

                </div>
                <div class="receipt-modal-footer modal-footer">
                    <div class="col-md-12">
                        <div class="col-md-6 pull-left" style="width:180px; text-align:left">
                            <button type="button" class="btn btn-default" ng-click="ctrl.switchReceiptLine('prev')" ng-hide="ctrl.receptLineIndex==0">Prev Receipt Line</button>
                        </div>
                        <div class="col-md-6" style="top: 10px; font-style:italic; text-align:center; padding-left: 200px;" ><span ng-hide="ctrl.receiptLinesByRecpt.length==1">{{ctrl.receptLineIndex+1}}&emsp;Of&emsp;{{ctrl.receiptLinesByRecpt.length}}</span></div>
                        <div class="col-md-6 pull-right" style="width: initial;">
                            <button type="button" class="btn btn-default" ng-click="ctrl.switchReceiptLine('next')" ng-hide="ctrl.receptLineIndex==(ctrl.receiptLinesByRecpt.length -1)">Next Receipt Line</button>&emsp;
                            <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                        </div>
                        <!-- <div class="pull-right">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Next Receipt Line</button>
                        </div> -->
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- end inventory view popup -->


    <!-- start Pending Putaway view popup -->
    <div id="pendingPutawayView" class="modal fade" role="dialog" >
        <div class="receipt-modal-dialog modal-dialog"  style="width: 100%;">
            <div class="receipt-modal-content modal-content">
                <div class="receipt-modal-header modal-header">
                    <button type="button" class="receipt-close close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <br style="clear: both;"/>

                    <div class="panel-heading">
                        <div class="receipt-panel-title panel-title"><h4>Pending Putaway</h4></div>
                    </div>
                </div>

                <div class="receipt-modal-body modal-body">
                    <div>
                        <g:message code="pendingPutaway.user.alert.message" />
                    </div>
                    <div  class="alert alert-success message-animation" role="alert" ng-if="ctrl.showPutawaySuccess">
                        You have successfully put away the inventory.
                    </div>

                    <div id="grid3" ui-grid="pendingPutawayGridOptions" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-expandable ui-grid-resize-columns ui-grid-auto-resize class="grid">
                        <div class="noItemMessage" ng-if="pendingPutawayGridOptions.data.length == 0"><g:message code="inventory.grid.noData.message" /></div>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <!-- end Pending Putaway view popup -->

    <div id="getItemNotes" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <!-- <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button> -->
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <textarea class="form-control" rows="5" id="comment" ng-model="ctrl.receiveInventoryItemNotes"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"  ng-click = "ctrl.clearItemNoteInput()"><g:message code="default.button.cancel.label"/></button>
                    <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>

    <div id="showItemNotes" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <textarea class="form-control" rows="5" id="comment" ng-model="ctrl.itemNotesData" disabled></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>

    <!-- start put away modal -->

    <div id="putAwayModal" class="modal fade" role="dialog">
        <div class="modal-dialog" style="width: 750px;">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 style="float: left;">{{ctrl.putawayLpnLevel}} Putaway</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <br style="clear: both;"/>
                </div>

                <div class="modal-body">

                    <div class = "col-md-12" >
                        <div class="col-md-4"><label>{{ctrl.putawayLpnLevel}} Id</label></div>
                        <div class="col-md-4" style="width:220px;" style="width:220px;"><label>System Suggested Location</label></div>
                        <div class="col-md-4" style="width:100px;"><label>Item Id</label></div>
                    </div>


                    <div class="col-md-12">
                        <form name="ctrl.putawayInventory" ng-submit="ctrl.savePutawayInventory()" novalidate >
                            <div class="col-md-4">
                                {{ctrl.putawayInventoryLpnId}}
                            </div>
                            <div class="col-md-4" style="width:220px;">
                                <span style="font-weight: bold; ">{{ctrl.putawaySystemLocation}}</span>
                                <span style="color: red;">{{ctrl.putawaySystemLocationError}} </span>
                                <br style="clear: both;"/>
                                <br style="clear: both;"/>


                            </div>
                            <div class="col-md-4" style="width:200px;" >{{ctrl.receiptItemForView}} - {{ctrl.receiptItemDescriptionForView}}</div>
                            <div class="col-md-12" style="padding-left: 1px;" ng-if="ctrl.putawaySystemLocation">
                                <div class="col-md-4" style="font-weight: bold;">
                                    Putaway Location :
                                </div>
                                <div class="col-md-5">
                                    <input id="confirmLocation" name="confirmLocationId" class="form-control" type="text"
                                       ng-model="ctrl.confirmLocationId" ng-blur="ctrl.confirmLocationForPutaway(ctrl.confirmLocationId)" placeholder="Confirm Location" ng-focus="ctrl.clearOverrideOnFocus()" required capitalize />

                                    <div class="my-messages"  ng-messages="ctrl.putawayInventory.confirmLocationId.$error"
                                         ng-if="ctrl.putawayInventory.$error.locationIdMatchForPutaway">
                                        <div class="message-animation" >
                                            <strong><g:message code="putawayOrder.locationMatching.error" /></strong>
                                        </div>
                                    </div>
                                    <div class="my-messages" ng-messages="ctrl.putawayInventory.confirmLocationId.$error" ng-if="ctrl.putawayInventory.confirmLocationId.$touched || ctrl.putawayInventory.$submitted">
                                        <div class="message-animation" ng-message="required">
                                            %{--<strong>This field is required.</strong>--}%
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-2" style="padding-left: 1px;">
                                    <button class="btn btn-primary" type="submit" ng-disabled="ctrl.putawaySystemLocationError || ctrl.disableConfirmForUnmatchedlocation || !ctrl.confirmLocationId || ctrl.disableConfirmPutaway">Confirm</button>
                                </div>
                            </div>
                            <!-- <div class="col-md-2" style="padding-left: 1px;">
                                <br style="clear: both;"/><br style="clear: both;"/><br style="clear: both;"/>
                                <button class="btn btn-primary" type="submit" ng-disabled="ctrl.putawaySystemLocationError || ctrl.disableConfirmForUnmatchedlocation || !ctrl.confirmLocationId">Confirm</button>
                            </div> -->
                        </form>
                    </div>

                    <br style="clear: both;"/>
                    <br style="clear: both;"/>
                    <div style="width: 100%; height: 20px; border-bottom: 1px solid black; text-align: center">
                          <span style="font-size: 20px;background-color: #FFFFFF; padding: 0 10px;"> OR </span>
                    </div>
                    <br style="clear: both;"/>
                    <div class = "col-md-12" >
                        <div class="col-md-5"><label>User Entered Location</label></div>
                    </div>
                    <div class="col-md-12">
                        <form name="ctrl.putawayInventoryUserDefined" ng-submit="ctrl.savePutawayInventoryUserDefined()" novalidate >
                            <div class="col-md-8" ng-class="{'has-error':ctrl.hasErrorClassForPutaway('putawayUserLocation')}">
                                <input id="putawayUserLocation" name="putawayUserLocation" class="form-control" type="text"
                                       ng-model="ctrl.putawayUserLocation" ng-blur="ctrl.checkLocationIdExist(ctrl.putawayUserLocation)" ng-keydown="ctrl.lowestUomCaseForBin=false;" ng-focus="ctrl.overrideOnFocus()" placeholder="Override" required capitalize tabindex="-1"/>

                                <div class="my-messages" ng-messages="ctrl.putawayInventoryUserDefined.putawayUserLocation.$error" ng-if="ctrl.showMessagesForPutaway('putawayUserLocation')">
                                    <div class="message-animation" ng-message="required">
                                        %{--<strong>This field is required.</strong>--}%
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>

                                <div class="my-messages"  ng-messages="ctrl.putawayInventoryUserDefined.putawayUserLocation.$error"
                                     ng-if="ctrl.putawayInventoryUserDefined.$error.locationIdExists">
                                    <div class="message-animation" >
                                        <strong>This location id doesn't exist.</strong>
                                    </div>
                                </div>
                                <div class="my-messages"  ng-messages="ctrl.putawayInventoryUserDefined.putawayUserLocation.$error"
                                     ng-if="ctrl.lowestUomCaseForBin">
                                    <div class="message-animation" >
                                        <strong>CASE lowest UOM inventory and case tracked items cannot be received to a bin location.</strong>
                                    </div>
                                </div>


                            </div>
                            <div class="col-md-2">
                                <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disableOverridePutaway">Override</button>
                            </div>
                        </form>
                    </div>

                    <br style="clear: both;"/>
                    <br style="clear: both;"/>

                </div>

            </div>
        </div>
    </div>
    <!-- end put away modal -->

    <div id="viewReceiptReportModel" class="modal fade" role="dialog">
        <div class="modal-dialog" style="width:80%">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div class="modal-body">
                    <div>
                        <embed id="pdfReport" style="height:450px; width: 100%;" type="application/pdf" ng-src="{{ctrl.receiptItemReportSrcStrg}}"/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click=printReport(ctrl.receiptItemReportSrcStrg)>Print</button>
                    <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click="ctrl.openMailAddrModal(ctrl.receiptItemReportSrcStrg)">Email</button>
                </div>
            </div>
        </div>
    </div>
    <g:render template="/report/sendReportMailTemp" />
</div><!-- End of ReceivingCtrl -->

<!-- Receipt delete confirmation dialog model -->
<div id="receiptDelete" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure want to delete this receipt ?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "deleteReceiptButton" class="btn btn-primary"><g:message code="default.button.delete.label" /></button>
            </div>
        </div>
    </div>
</div>
<!-- End Receipt delete dialog model -->

<!-- Receipt delete Warning dialog model -->
<div id="receiptEditWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>You can not edit closed receipt.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>
<!-- Receipt delete Warning dialog model -->

<!-- Receipt Line delete Warning dialog model -->
<div id="receiptLineDeleteWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>This receipt line cannot be deleted as it contains inventory.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>
<!-- Receipt Line delete Warning dialog model -->

<div id="receiptDeleteWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>This receipt cannot be deleted as it contains inventory.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>
<!-- Receipt Line delete Warning dialog model -->

<!-- Receipt completion confirmation dialog model -->
<div id="receiptComplete" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p><b>Are you sure want to close this receipt ?</b></p>
                <p>If you click "Close" you cannot edit, delete or add inventory to this receipt.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "receiptCompleteButton" class="btn btn-primary"><g:message code="default.button.close.label" /></button>
            </div>
        </div>
    </div>
</div>
<!-- end Receipt completion confirmation dialog model -->

<!-- Receipt completion Warning dialog model -->
<div id="receiptCompleteWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p><b>No inventory has been received for this receipt.</b></p>
                <p>If you want to continue please click "OK".</p>
                <p>If you click "OK" you cannot edit, delete or add inventory to this receipt.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "receiptCompleteWarningButton" class="btn btn-primary"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<!-- end Receipt completion Warning dialog model -->

<!-- Receipt re-open Warning dialog model -->
<div id="receiptReOpenWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to Re-Open this receipt ?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "receiptReOpenWarningButton" class="btn btn-primary"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<!-- end Receipt re-open Warning dialog model -->

<!-- Receipt completion for inappropriate quantity Warning dialog model -->
<div id="receiptCompleteQtyWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p><b>The Quantity of inventory didn't reach the expected quantity of this receipt.</b></p>
                <p>if you want to continue please click "OK".</p>
                <p>If you click "OK" you cannot edit, delete or add inventory to this receipt.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "receiptCompleteQtyWarningButton" class="btn btn-primary"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<!-- end Receipt completion Warning dialog model -->

<!-- Receipt Line quantiy change Warning dialog model -->

<div id="receiptQuantityChangeWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>The Expected quantity of this receipt line is less than the sum of inventory quantity.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>
<!-- Receipt Line quantiy change Warning dialog model -->


<asset:javascript src="datagrid/receiving.js"/>

<script type="text/javascript">
    var dvReceiving = document.getElementById('dvReceiving');
    angular.element(document).ready(function() {
        angular.bootstrap(dvReceiving, ['receiving']);
    });
</script>

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

<asset:javascript src="autocomplete/angular-sanitize.js"/>
<asset:javascript src="autocomplete/auto-complete.js"/>
<asset:javascript src="autocomplete/auto-complete-multi.js"/>
<asset:javascript src="inventory/order-auto-complete-div.js"/>
<asset:javascript src="autocomplete/auto-complete-textbox.js"/>

</body>
</html>
