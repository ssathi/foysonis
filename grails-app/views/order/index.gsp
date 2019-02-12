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
        width: 100%;
    }

    .inventoryGrid {
        height:420px;
        width: 950px;
    }

    .shipmentGrid {
        width: 100%;
    }

    .grid-align {
        text-align: center;
    }


    .dropdown-menu {
        left: -120%;
    }

    .noLocationMessage {
        position: absolute;
        top : 30%;
        opacity: 0.4;
        font-size: 30px;
        width: 100%;
        text-align: center;
        z-index: auto;
    }
    .noDataMessage{
        opacity: 0.4;
        font-size: 30px;
        width: 100%;
        text-align: center;
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

    .customer-modal-dialog {
        width: 100%;
        height: 100%;
        margin: 0;
        padding: 0;
    }

    .customer-modal-content {
        height: auto;
        min-height: 100%;
        border-radius: 0;
    }


    .customer-modal-header {
        background: #547CA2;
        height: 70px;
    }

    .customer-panel-title {
        margin-top: -30px;
        color: #ffffff;
    }

    .customer-modal-body {
        position: fixed;
        top: 70px;
        bottom: 70px;
        width: 100%;
        overflow: scroll;
    }

    .customer-modal-footer {
        position: fixed;
        right: 0;
        bottom: 0;
        left: 0;
        border-top: 2px solid #547CA2;
        height: 70px;
    }

    .customer-close {
        color: #FFFFFF;
        opacity: 1;
    }

    #streetAddress{
        resize: none;
    }

    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    .ui-grid-header-cell .ui-grid-cell-contents {
        height: 48px;
        white-space: normal;
        -ms-text-overflow: clip;
        -o-text-overflow: clip;
        text-overflow: clip;
        overflow: visible;
    }

    .popover.top {
        border: 2px solid rgba(51, 122, 183, 0.66);
    }

    .popover.top > .arrow:after {
        border-top-color: rgba(51, 122, 183, 0.66);
    }     

    .nav-tabs > li > a.moveTabs{
        background-color: #878a8d;
        color: #ffffff;
        height: 37px;
        width: 120px;
        border-right: 1px;    
        font-size: 13px;   
        text-align: center;
        line-height: 1;
    }

    .nav-tabs > li > a.moveFirstTab{
        border-top-left-radius: 4.5px;
        border-bottom-left-radius: 4.5px;        
    }

    .nav-tabs > li > a.moveLastTab{
        border-top-right-radius: 4.5px;
        border-bottom-right-radius: 4.5px;        
    }    

    .nav-tabs > li.active > a, .nav-tabs > li.active > a:hover, .nav-tabs > li.active > a:focus{
        color: #ffffff;
        background-color: #40a3fd;       
        border-right: 1px; 
    }

    .nav-tabs{
        padding-bottom: 2px;
    }

    .editOrdBtn{
        background-color: #22a49c !important;
        height: 37px;
        width: 130px;
        line-height: 1;
        border: 0px;
        padding-left: 20px !important;        
    }

    .delOrdBtn{
        height: 37px;
        width: 130px;
        line-height: 1;
        border-color: #f85542 !important;  
        color: #f85542;
        padding-left: 10px;      
    }

    </style>

    <%-- **************************** End of CSS **************************** --%>

</head>

<body>

%{--<g:report id="todoReport" controller="ShipmentController"--}%
%{--action="getShipmentReport" report="report1"--}%
%{--format="PDF">--}%
%{--<input type="hidden" name="password" value="123" />--}%
%{--</g:report>--}%

<div ng-cloak class="row" id="dvOrder" ng-controller="orderCtrl as ctrl">

    <%-- **************************** Start create order form **************************** --%>
            %{--<button type="button" class="btn btn-primary pull-right" ng-disabled="ctrl.disableEbayImport" ng-click="getEbayOrders()" style="margin-left: 10px;">--}%
                %{--<em class="fa fa-fw mr-sm"></em>--}%
                %{--{{ctrl.eBayImportBtnText}}--}%
            %{--</button>--}%
            <div style="display: inline;"><em class="fa  fa-fw mr-sm" style="padding-right: 60px;" ><img style="height: 25px;" src="/foysonis2016/app/img/orders_Shipping_header.svg"></em>&emsp;&nbsp;<span class="headerTitle">Orders & Shipments</span></div>

            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation"  href="javascript:void(0);">

                <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide()">
                    <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                    <g:message code="default.button.createOrder.label" />
                </button>
            </a>
            <br style="clear: both;"/>
            <br style="clear: both;"/>

            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showOrderCreatedPrompt">
                <g:message code="orders.create.message" />
            </div>
            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showOrderEbayImportedPrompt">
                <g:message code="orders.ebayImport.message" />
            </div>
            <div ng-show="IsOrderVisible" class="col-md-12">

                <form name="ctrl.createOrderForm" ng-submit="ctrl.createOrder()" novalidate >

                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                        <div class="panel-heading">
                            <div class="panel-title"><g:message code="default.order.add.label" /></div>
                        </div>

                        <div class="panel-body">

                            <div class="col-md-12">
                                <div class="col-md-6">


                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('orderNumber')}">

                                        <label for="orderNumber"><g:message code="form.field.orderNo.label" /></label>
                                        <input id="orderNumber" name="orderNumber" class="form-control" type="text" maxlength="32" capitalize
                                               ng-model="ctrl.newOrder.orderNumber"
                                               ng-focus="ctrl.toggleOrderNumberPrompt(true)" ng-blur="ctrl.toggleOrderNumberPrompt(false); ctrl.validateOrderNum(ctrl.newOrder.orderNumber)" ng-disabled = "ctrl.isAutoSaved" tabindex="1" />


                                        <div class="my-messages"  ng-messages="ctrl.createOrderForm.orderNumber.$error"
                                             ng-if="ctrl.createOrderForm.$error.orderNumberExists">
                                            <div class="message-animation" >
                                                <strong>Order number exists already.</strong>
                                            </div>
                                        </div>

                                    </div>


                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('earlyShipDate')}">


                                        %{--Date Control--}%

                                        <label for="earlyShipDate"><g:message code="form.field.earlyShipDate.label" /></label>
                                        <p class="input-group">
                                            <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                   ng-model="ctrl.newOrder.earlyShipDate" is-open="popupEarlyShipDate.opened"
                                                   datepicker-options="dateOptions"  ng-required="false" close-text="Close"
                                                   alt-input-formats="altInputFormats" tabindex="3" />
                                            <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="openEarlyShipDate()">
                                                    <i class="glyphicon glyphicon-calendar"></i></button>
                                            </span>
                                        </p>

                                        %{--Date Control--}%


                                    </div>

                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('requestedShipSpeed')}">
                                        <label for="requestedShipSpeed"><g:message code="form.field.reqShipDate.label" /></label>
                                        <select  id="requestedShipSpeed" name="requestedShipSpeed" ng-model="ctrl.newOrder.requestedShipSpeed" class="form-control" ng-change = "ctrl.addNewValue()"  tabindex="5">

                                            <option ng-repeat="listValueShipSpeed in  ctrl.listValueShipSpeed" value="{{listValueShipSpeed.optionValue}}">{{listValueShipSpeed.description}}
                                            </option>
                                        </select>


                                    </div>


                                </div>

                                <div class="col-md-6">


                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('customerId')}">
                                        <label for="customerId"><g:message code="form.field.customer.label" /></label>
                                        <div auto-complete  source="loadCustomerAutoCompleteForNewOrder"  xxxx-list-formatter="customListFormatter" value-changed="ctrl.addNewCustomer(value.contactName, value.customerId); ctrl.checkCustomerHold(value)" style="z-index: 1000;">

                                            <input id="customerId" name="customerId"  ng-model="ctrl.newOrder.contactName"  ng-model-options="{ updateOn : 'default blur' }" placeholder="Customer Id" class="form-control" required tabindex="2" />

                                            <div class="my-messages" ng-messages="ctrl.createOrderForm.customerId.$error" ng-if="ctrl.showMessagesOrder('customerId')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages" ng-messages="ctrl.createOrderForm.customerId.$error" ng-if="ctrl.isCustomerHoldSelected">
                                                <div class="message-animation">
                                                    <strong>This customer cannot be selected as the customer is in hold </strong>
                                                </div>
                                            </div>                                            

                                        </div>
                                    </div>

                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('lateShipDate')}">
                                        %{--<label for="lateShipDate"><g:message code="form.field.lateShipDate.label" /></label>--}%
                                        %{--<input id="lateShipDate" name="lateShipDate" class="form-control" type="Date"--}%
                                        %{--ng-model="ctrl.newOrder.lateShipDate" ng-model-options="{ updateOn : 'blur' }"--}%
                                        %{--ng-focus="ctrl.toggleLateShipDatePrompt(true)" ng-blur="ctrl.toggleLateShipDatePrompt(false)" min="{{ctrl.getEarlyShipDate(ctrl.newOrder.earlyShipDate)}}" />--}%

                                        <label for="lateShipDate"><g:message code="form.field.lateShipDate.label" /></label>
                                        <p class="input-group">
                                            <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                   ng-model="ctrl.newOrder.lateShipDate" is-open="popupLateShipDate.opened"
                                                   datepicker-options="dateOptions"  ng-required="false" close-text="Close"
                                                   alt-input-formats="altInputFormats" tabindex="4" />
                                            <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="openLateShipDate()">
                                                    <i class="glyphicon glyphicon-calendar"></i></button>
                                            </span>
                                        </p>

                                    </div>

                                    <div class="my-messages pull-left"  ng-messages="ctrl.createOrderForm.orderNumber.$error" ng-if="ctrl.shipmentDateValidMsg">
                                        <div class="message-animation" >
                                            <strong>Late Shipment Date and Early Shipment date aren't valid.</strong>
                                        </div>
                                    </div>

                                    <div class="my-messages pull-left"  ng-messages="ctrl.createOrderForm.lateShipDate.$error" ng-if="ctrl.createOrderForm.lateShipDate.$error.min">
                                        <div class="message-animation" >
                                            <strong>Late Shipment Date is not valid.</strong>
                                        </div>
                                    </div>
                                    <div style="clear: both;" class="form-group">
                                        <label><g:message code="form.field.notes.label" /></label>
                                        <textarea rows="4" cols="6" class="form-control" ng-model="ctrl.newOrder.orderNote" placeholder="Enter Notes Here........." maxlength="3000" tabindex="10"></textarea>
                                    </div>
                                </div>


                                <div class = "col-md-12" ><br/><br/>
                                    <div class="col-md-1"><label><g:message code="form.field.lineNo.label" /></label></div>
                                    <div class="col-md-2"><label><g:message code="form.field.itemId.label" /></label></div>
                                    <div class="col-md-1"><label><g:message code="form.field.orderedQty.label" /></label></div>
                                    <div class="col-md-2"><label><g:message code="form.field.reqInventoryStatus.label" /></label></div>
                                    <div class="col-md-2"><label><g:message code="form.field.orderedUom.label" /></label></div>
                                    <div class="col-md-1" style="text-align: center; padding-left: 0px; padding-right: 0px;"><label><g:message code="form.field.createKittingOrder.label" /></label></div>
                                    <div class="col-md-2" style="text-align: center;"><label>Allocate By LPN</label></div>
                                </div>
                                <div class = "col-md-12" ng-repeat = "index in ctrl.getNewField(ctrl.addNewFieldNum) track by $index"><hr style="margin: 10px 0;">


                                    <div class="col-md-1">

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('displayOrderLineNumber'+$index)}">
                                            <input id="{{'displayOrderLineNumber'+$index}}" name="{{'displayOrderLineNumber'+$index}}" class="form-control" type="text"
                                                   ng-model="ctrl.newOrder.orderLine[$index].displayOrderLineNumber" ng-model-options="{ updateOn : 'default blur' }"
                                                   ng-focus="ctrl.toggleDisplayOrderLineNumberPrompt($index)" ng-blur="ctrl.checkReceiptLineIdUnique(ctrl.newOrder.orderLine[$index].displayOrderLineNumber, $index)" maxlength="40" numbers-only  />

                                            <div ng-init = "ctrl.newOrder.orderLine[$index].displayOrderLineNumber = ctrl.orderLineNumberList[$index]"></div>
                                        </div>

                                    </div>

                                    <div class="col-md-2">

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('itemId'+$index)}">

                                            %{--<div auto-complete  source="loadCompanyItems"  xxxx-list-formatter="customListFormatter" value-changed="ctrl.validateItemIdOrderLines(value.contactName,$index)" style="z-index: 1000;">--}%
                                            %{--<input id="{{'itemId'+$index}}" name="{{'itemId'+$index}}" ng-model="ctrl.newOrder.orderLine[$index].itemId"  ng-model-options="{ updateOn : 'default blur' }" placeholder="Item Id" class="form-control" required/>--}%

                                            <div auto-complete  source="loadItemAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars = '0'
                                                 value-changed="ctrl.validateItemIdOrderLines(value.contactName,$index)" >
                                                <input id="{{'itemId'+$index}}" name="{{'itemId'+$index}}" ng-model="ctrl.newOrder.orderLine[$index].itemId" placeholder="Item Id" class="form-control" ng-model-options="{ updateOn : 'default blur' }" required tabindex="{{6+($index*6)+1}}" set-autofocus="$index == ctrl.focusVal"/>


                                                <div class="my-messages" ng-messages="ctrl.createOrderForm.itemId{{$index}}.$error" ng-if="ctrl.showMessagesOrder('itemId'+$index)">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                    </div>

                                    <div class="col-md-1">

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('orderedQuantity'+$index)}">
                                            <input id="{{'orderedQuantity'+$index}}" name="{{'orderedQuantity'+$index}}" class="form-control" type="number" min="1"
                                                   ng-model="ctrl.newOrder.orderLine[$index].orderedQuantity" ng-model-options="{ updateOn : 'default blur' }"
                                                   ng-blur=""  required tabindex="{{6+($index*6)+2}}"/>



                                            <div class="my-messages" ng-messages="ctrl.createOrderForm.orderedQuantity{{$index}}.$error" ng-if="ctrl.showMessagesOrder('orderedQuantity'+$index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages" ng-messages="ctrl.createOrderForm.orderedQuantity{{$index}}.$error" ng-if="ctrl.createOrderForm.orderedQuantity{{$index}}.$error.min">
                                                <div class="message-animation">
                                                    <strong>Cannot enter zero.</strong>
                                                </div>
                                            </div>


                                        </div>
                                    </div>

                                    <div class="col-md-2">

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('requestedInventoryStatus'+$index)}" >
                                            <select  id="{{'requestedInventoryStatus'+$index}}" name="{{'requestedInventoryStatus'+$index}}" ng-model="ctrl.newOrder.orderLine[$index].requestedInventoryStatus" class="form-control" required tabindex="{{6+($index*6)+3}}">
                                                <option ng-repeat="option in ctrl.inventoryStatusOptions" value="{{option.optionValue}}">{{option.description}}</option>
                                            </select>

                                            <div class="my-messages" ng-messages="ctrl.createOrderForm.requestedInventoryStatus{{$index}}.$error" ng-if="ctrl.showMessagesOrder('requestedInventoryStatus'+$index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>
                                        </div>

                                        <div ng-init = "ctrl.newOrder.orderLine[$index].requestedInventoryStatus = ctrl.inventoryStatusOptions[0].optionValue;"></div>
                                    </div>


                                    <div class="col-md-2">

                                        %{--<div ng-if = "ctrl.lowestUomEach[$index]" class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('orderedUOM')}">--}%
                                        %{--<input  id="orderedUOM" name="orderedUOM" ng-model="ctrl.newOrder.orderLine[$index].orderedUOM = 'EACH'" class="form-control" disabled />--}%
                                        %{--</div>--}%

                                        <div ng-if = "ctrl.newOrder.orderLine[$index].orderedUOM != 'EACH'" class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('orderedUOM')}">
                                            <input  id="orderedUOM" name="orderedUOM" ng-model="ctrl.newOrder.orderLine[$index].orderedUOM" class="form-control" disabled />
                                        </div>


                                        %{--<div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('orderedUOM'+$index)}" ng-if="!ctrl.lowestUomEach[$index]">--}%
                                        %{--<select  id="{{'orderedUOM'+$index}}" name="{{'orderedUOM'+$index}}" ng-model="ctrl.newOrder.orderLine[$index].orderedUOM" class="form-control" required >--}%
                                        %{--<option value="CASE">CASE</option>--}%
                                        %{--</select>--}%


                                        %{--<div class="my-messages" ng-messages="ctrl.createOrderForm.orderedUOM{{$index}}.$error" ng-if="ctrl.showMessagesOrder('orderedUOM'+$index)">--}%
                                        %{--<div class="message-animation" ng-message="required">--}%
                                        %{--<strong><g:message code="required.error.message" /></strong>--}%
                                        %{--</div>--}%
                                        %{--</div>--}%
                                        %{--</div>--}%

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('orderedUOM'+$index)}" ng-if="ctrl.newOrder.orderLine[$index].orderedUOM == 'EACH'">
                                            <select  id="{{'orderedUOM'+$index}}" name="{{'orderedUOM'+$index}}" ng-model="ctrl.newOrder.orderLine[$index].orderedUOM" class="form-control" required tabindex="{{6+($index*6)+4}}" >
                                                <option value="EACH">EACH</option>
                                                <option value="CASE">CASE</option>
                                            </select>


                                            <div class="my-messages" ng-messages="ctrl.createOrderForm.orderedUOM{{$index}}.$error" ng-if="ctrl.showMessagesOrder('orderedUOM'+$index)">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="col-md-1" style="text-align: center;">
                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('isCreateKittingOrder'+$index)}" ng-if="ctrl.kittingOrder[$index]">

                                            <input type="checkbox"  id="{{'isCreateKittingOrder'+$index}}"  name="{{'isCreateKittingOrder'+$index}}" ng-model="ctrl.newOrder.orderLine[$index].isCreateKittingOrder"  tabindex="{{6+($index*6)+5}}"  />

                                        </div>
                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('isCreateKittingOrder'+$index)}" ng-if="!ctrl.kittingOrder[$index]">

                                            <input type="checkbox"  id="{{'isCreateKittingOrder'+$index}}"  name="{{'isCreateKittingOrder'+$index}}" ng-model="ctrl.newOrder.orderLine[$index].isCreateKittingOrder" tabindex="{{6+($index*6)+5}}" disabled />

                                        </div>
                                    </div>
                                    <div class="col-md-2 form-group" style="text-align: center;">
                                        <input type="text" name="allByLpn" placeholder="Lpn" class="form-control" ng-blur="" ng-model="ctrl.newOrder.orderLine[$index].allocateByLpn" capitalize>
                                    </div>
                                    
                                    <div class="col-md-1">
                                        <button type="button"  ng-click = "ctrl.deleteOrderLineRaw($index)" class="btn btn-default">X</button>
                                    </div>
                                    <!-- <input type = "hidden" ng-model = "ctrl.lineCountIndex = $index" /> -->
                                    <div ng-init="ctrl.lineCountIndex = $index"></div>
                                </div>

                                <div class="col-md-12" ng-click = "ctrl.addNewField(ctrl.lineCountIndex);ctrl.automaticOrderSave();" ng-focus= "ctrl.addNewField(ctrl.lineCountIndex)" style="cursor:text" id="addNewLine" tabindex="{{6+(ctrl.lineCountindex*6)+5}}">
                                    <hr style="margin: 10px 0;">
                                    <div class = "col-md-1"><label>{{ctrl.lineCountIndex +2}}.</label></div>
                                </div>





                            </div>

                            <div class="col-md-12">
                                <div class="panel-footer">
                                    <div class="pull-left">
                                        <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                            <button class="btn btn-default" type="button" ng-click="ShowHide()"><g:message code="default.button.cancel.label" /></button>
                                        </a>

                                    </div>
                                    <div class="pull-right">
                                        <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disableSaveReportBtn"><g:message code="default.button.save.label" /></button>
                                    </div>
                                    <br style="clear: both;"/>
                                </div>
                            </div>


                        </div>
                    </div>
                </form>

            </div>
            <div style="clear: both;"></div>
    <%-- **************************** End of create order form **************************** --%>

    <!-- START search panel-->
    <div class="panel panel-default">
        <div class="panel-heading">
            <a href="javascript:void(0);" ng-click = "ctrl.showHideSearch()">
                <legend><em ng-if = "ctrl.isOrderSearchVisible" class="fa fa-minus-circle fa-fw mr-sm"></em>
                    <em ng-if = "!ctrl.isOrderSearchVisible" class="fa fa-plus-circle fa-fw mr-sm"></em>
                    <g:message code="default.search.label" />
                </legend></a>
        </div>
        <div class="panel-body" ng-show= "ctrl.isOrderSearchVisible">
            <form name="ctrl.orderSearchForm"  ng-submit="ctrl.orderSearch()">
                <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                    <!-- START Wizard Step inputs -->
                    <div>
                        <fieldset>
                            <!-- START row -->
                            <div class="row">

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.customer.label" /></label>
                                        <div class="controls">

                                            <div auto-complete  source="loadCustomerAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars="3" value-changed="ctrl.getCustomerContactName(value)">
                                                <input ng-model="ctrl.customer" placeholder="Customer" class="form-control" ng-blur='clearAutoCompText()'>
                                            </div>

                                        </div>
                                    </div>
                                </div>


                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.orderNo.label" /></label>
                                        <div class="controls">
                                            <input type="text" name="orderNumber" placeholder="Order Number" class="form-control"
                                                   ng-blur="" ng-model="ctrl.orderNumber">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.orderStatus.label" /></label>
                                        <select  name="orderStatus" ng-model="ctrl.orderStatus" class="form-control">
                                            <option selected value></option>
                                            <option>UNPLANNED</option>
                                            <option>PLANNED</option>
                                            <option>PARTIALLY PLANNED</option>
                                            <option>CLOSED</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.shipmentId.label" /></label>
                                        <div class="controls">
                                            <input type="text" name="ShipmentIdSearch" placeholder="Shipment Id" class="form-control"
                                                   ng-blur="" ng-model="ctrl.shipmentIdSearch">
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.shipmentSearch.label" /></label>
                                        <select  name="shipmentStatusSearch" ng-model="ctrl.shipmentStatusSearch" class="form-control">
                                            <option selected value></option>
                                            <option>PLANNED</option>
                                            <option>ALLOCATED</option>
                                            <option>KO PROCESSING</option>
                                            <option>STAGED</option>
                                            <option>COMPLETED</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="requestedShipSpeed"><g:message code="form.field.reqShipSpeed.label" /></label>
                                        <select  id="requestedShipSpeed" name="requestedShipSpeed" ng-model="ctrl.requestedShipSpeed" class="form-control">

                                            <option ng-repeat="shipSpeed in ctrl.listValueShipSpeed" value="{{shipSpeed.optionValue}}">{{shipSpeed.description}}
                                            </option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.earlyShipDate.label" /></label>
                                        <label ng-show="ctrl.displayEarlyShipDateRange"> : <g:message code="form.field.from.label" /></label>
                                        <div class="controls">
                                            %{--<input type="date" id="fromEarlyShipDate" name="fromEarlyShipDate" class="form-control" ng-model="ctrl.findOrders.fromEarlyShipDate" />--}%
                                            <p class="input-group">
                                                <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                       ng-model="ctrl.fromEarlyShipDate" is-open="popupEarlyShipDateFrom.opened"
                                                       datepicker-options="dateOptions"  ng-required="false" close-text="Close"
                                                       alt-input-formats="altInputFormats" />
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-default" ng-click="openEarlyShipDateFrom()">
                                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                                </span>
                                            </p>

                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4" ng-show="ctrl.displayEarlyShipDateRange">
                                    <div class="form-group">
                                        <label><g:message code="form.field.to.label" /></label>
                                        <div class="controls">
                                            %{--<input type="date" id="toEarlyShipDate" name="toEarlyShipDate" class="form-control" ng-model="ctrl.findOrders.toEarlyShipDate" />--}%
                                            <p class="input-group">
                                                <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                       ng-model="ctrl.toEarlyShipDate" is-open="popupEarlyShipDateTo.opened"
                                                       datepicker-options="dateOptions"  ng-required="false" close-text="Close"
                                                       alt-input-formats="altInputFormats" />
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-default" ng-click="openEarlyShipDateTo()">
                                                        <i class="glyphicon glyphicon-calendar"></i></button>
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
                                                    <input type="checkbox" value="" ng-click="ctrl.showEarlyShipDateRange()" ng-model="ctrl.earlyShipDateRange">
                                                    <span class="fa fa-check"></span><g:message code="form.field.dateRange.label" /></label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <br style="clear: both;"/>

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.lateShipDate.label" /></label>
                                        <label ng-show="ctrl.displayLateShipDateRange"> : <g:message code="form.field.from.label" /></label>
                                        <div class="controls">
                                            %{--<input type="date" id="fromLateShipDate" name="fromLateShipDate" class="form-control" ng-model="ctrl.findOrders.fromLateShipDate" />--}%

                                            <p class="input-group">
                                                <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                       ng-model="ctrl.fromLateShipDate" is-open="popupLateShipDateFrom.opened"
                                                       datepicker-options="dateOptions"  ng-required="false" close-text="Close"
                                                       alt-input-formats="altInputFormats" />
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-default" ng-click="openLateShipDateFrom()">
                                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                                </span>
                                            </p>

                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4" ng-show="ctrl.displayLateShipDateRange">
                                    <div class="form-group">
                                        <label><g:message code="form.field.to.label" /></label>
                                        <div class="controls">
                                            %{--<input type="date" id="toLateShipDate" name="toLateShipDate" class="form-control" ng-model="ctrl.findOrders.toLateShipDate" />--}%

                                            <p class="input-group">
                                                <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                       ng-model="ctrl.toLateShipDate" is-open="popupLateShipDateTo.opened"
                                                       datepicker-options="dateOptions"  ng-required="false" close-text="Close"
                                                       alt-input-formats="altInputFormats" />
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-default" ng-click="openLateShipDateTo()">
                                                        <i class="glyphicon glyphicon-calendar"></i></button>
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
                                                    <input type="checkbox" value="" ng-click="ctrl.showLateShipDateRange()" ng-model="ctrl.LateShipDateRange">
                                                    <span class="fa fa-check"></span><g:message code="form.field.dateRange.label" /></label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <br style="clear: both;"/>

                            </div>
                            <!-- END row -->

                        </fieldset>

                        <div class="pull-right">
                            <button class="btn btn-primary findBtn" type="submit">
                                <g:message code="default.button.searchOrder.label" />
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

    <div class="col-lg-3 panel-body table-responsive table-bordered" style="background-color: #fff;" ng-if = "ctrl.orderList.length == 0">

        <table class="table table-bordered">
            <tbody>

            <tr>
                <td>
                    <div class="media">
                        <div class="media-body">
                            <h5 class="media-heading" >No orders found.</h5>
                        </div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>

    </div>

    <div class="col-lg-3 panel-body table-responsive table-bordered" style="background-color: #fff;" ng-if = "ctrl.orderList.length > 0">

        <table class="table table-bordered">
            <tbody>

            <tr ng-repeat="order in ctrl.orderList">
                <td ng-class="{ 'selected-class-name':  order.order_number == ctrl.selectedOrderNumber }">
                    <div class="media">
                        <div class="media-body">
                            <%-- ****************** Selecting order Tab ****************** --%>

                            <a href = ''  ng-click="ctrl.getClickedOrder(order.order_number)">
                                <h5 class="media-heading" >{{ order.order_number }}</h5>
                                <span style="font-weight: normal; font-size: 11px;">{{order.contact_name}}</span>
                            </a>

                            <%-- ****************** End of selecting order Tab ****************** --%>

                        </div>
                    </div>
                </td>
                <tr>
                    <td ng-hide="ctrl.totalNumOfPages==null || ctrl.totalNumOfPages == 1">
                        <div class="pull-left">
                            <button class="btn btn-default" type="button" ng-click="ctrl.orderSearchForNextPrev('prev')" ng-disabled="ctrl.orderSearchPageNum==1">Prev</button>
                            <span style="font-style: italic;">&emsp;&emsp;&emsp;{{ctrl.orderSearchPageNum}} of {{ctrl.totalNumOfPages}}</span>
                        </div>                    
                        <div class="pull-right">
                            <button class="btn btn-default" type="button" ng-click="ctrl.orderSearchForNextPrev('next')" ng-disabled="ctrl.orderSearchPageNum==ctrl.totalNumOfPages">Next</button>
                        </div> 
                    </td>                    
                </tr>
            </tr>
            </tbody>
        </table>

    </div>

    <div class="col-lg-9">
        <!-- START panel-->
        <div class="panel panel-default">
            <div class="panel-body" style="overflow:hidden;">
                <!-- Nav tabs -->
                <ul class="nav nav-tabs">
                    <li id="lilocations" class="active"><a class="moveTabs moveFirstTab" href="#locations" data-toggle="tab"><g:message code="default.order.tab.label" /></a></li>
                    <li id="liareas"><a class="moveTabs moveLastTab" href="#areas" data-toggle="tab"><g:message code="default.shipment.tab.label" /></a></li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                    <div id="locations" class="tab-pane fade in active">

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showOrderEditedPrompt">
                            <g:message code="orders.edit.message" />
                        </div>

                        <div class="col-lg-12 noDataMessage" ng-if='!ctrl.orderFieldsEditabe && ctrl.orderList.length == 0'>
                            No Order details to display.
                        </div>


                        <div class="col-lg-12"  ng-if='!ctrl.orderFieldsEditabe && ctrl.orderList.length > 0' >
                            <div class="col-lg-6">
                                <div>
                                    <div class="label-desc-order">Customer :</div>
                                    <div class="label-content">{{ctrl.customerData[0].contact_name}}&emsp; [<a href="javascript:void(0);" ng-click = "ctrl.customerEdit()">Edit</a>]</div>
                                    <br style="clear: both;"/>
                                </div>
                                <div>
                                    <div class="label-desc-order">Company :</div>
                                    <div class="label-content">{{ctrl.customerData[0].company_name}}</div>
                                    <br style="clear: both;"/>
                                </div>
                                <div>
                                    <div class="label-desc-order">Requested Ship Speed :</div>
                                    <div class="label-content">{{ctrl.listValueShipSpeedDesc}}</div>
                                    <br style="clear: both;"/>
                                </div>
                                <div ng-if="ctrl.orderData[0].carrierCode">
                                    <div class="label-desc-order">Carrier Code :</div>
                                    <div class="label-content">{{ctrl.orderData[0].carrierCode}}</div>
                                    <br style="clear: both;"/>
                                </div>
                                <div ng-if="ctrl.orderData[0].serviceLevel">
                                    <div class="label-desc-order">Service Level :</div>
                                    <div class="label-content">{{ctrl.orderData[0].serviceLevel}}</div>
                                    <br style="clear: both;"/>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div>
                                    <div class="label-desc-order">Status :</div>
                                    <div class="label-content">{{ctrl.orderData[0].orderStatus}}</div>
                                    <br style="clear: both;"/>
                                </div>
                                <div>
                                    <div class="label-desc-order">Early Ship Date :</div>
                                    <div class="label-content">{{ctrl.convertedEarlyShipDate}}</div>
                                    <br style="clear: both;"/>
                                </div>
                                <div>
                                    <div class="label-desc-order">Late Ship Date :</div>
                                    <div class="label-content">{{ctrl.convertedLateShipDate}}</div>
                                    <br style="clear: both;"/>
                                </div>
                                <div>
                                    <div class="label-desc-order">Note :</div>
                                    <div class="">{{ctrl.orderData[0].notes}}</div>
                                    <br style="clear: both;"/>
                                </div>                                
                            </div>
                        </div>

                        <div class="col-lg-12"  ng-if='ctrl.orderFieldsEditabe && ctrl.orderList.length > 0' >
                            <form name="ctrl.editOrderFormfield" ng-submit="ctrl.editOrderHeader()" novalidate >
                                <div class="col-lg-12">
                                    <div class="col-lg-6">

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('earlyShipDate')}">
                                            <label for="earlyShipDate"><g:message code="form.field.earlyShipDate.label" /></label>
                                            <input id="earlyShipDate" name="earlyShipDate" class="form-control" type="date"
                                                   ng-model="ctrl.earlyShipDateEdit" ng-model-options="{ updateOn : 'blur' }"
                                                   ng-focus="ctrl.toggleEarlyShipDatePrompt(true)" ng-blur="ctrl.toggleEarlyShipDatePrompt(false)" />


                                        </div>


                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('requestedShipSpeed')}">
                                            <label for="requestedShipSpeed"><g:message code="form.field.reqShipDate.label" /></label>
                                            <select  id="requestedShipSpeed" name="requestedShipSpeed" ng-model="ctrl.requestedShipSpeedEdit" class="form-control">

                                                <option ng-repeat="shipSpeed in ctrl.listValueShipSpeed" value="{{shipSpeed.optionValue}}">{{shipSpeed.description}}
                                                </option>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label><g:message code="form.field.notes.label" /></label>
                                            <textarea rows="4" cols="6" class="form-control" ng-model="ctrl.orderNoteEdit" placeholder="Enter Notes Here........." tabindex="10"></textarea>
                                        </div>

                                    </div>
                                    <div class="col-lg-6">

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('lateShipDate')}">
                                            <label for="lateShipDate"><g:message code="form.field.lateShipDate.label" /></label>
                                            <input id="lateShipDate" name="lateShipDate" class="form-control" type="Date"
                                                   ng-model="ctrl.lateShipDateEdit" ng-model-options="{ updateOn : 'blur' }"
                                                   ng-focus="ctrl.toggleLateShipDatePrompt(true)" ng-blur="ctrl.toggleLateShipDatePrompt(false)" min="{{ctrl.getEarlyShipDate(ctrl.earlyShipDateEdit)}}" />

                                        </div>

                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('customerId')}">
                                            <label for="customerId"><g:message code="form.field.customerName.label" /></label>
                                            <div auto-complete  source="loadCustomerAutoCompleteForNewOrder"  xxxx-list-formatter="customListFormatter" value-changed="ctrl.addNewCustomerEdit(value.contactName,value.customerId); ctrl.checkCustomerHold(value)" style="z-index: 1000;">
                                                <input id="customerId" name="customerId"  ng-model="ctrl.customerNameEditForOrder"  ng-model-options="{ updateOn : 'default blur' }" placeholder="Customer Id" class="form-control" required />

                                            </div>
                                        </div>

                                        <div class="my-messages" ng-messages="ctrl.createOrderForm.customerId.$error" ng-if="ctrl.isCustomerHoldSelected">
                                            <div class="message-animation">
                                                <strong>This customer cannot be selected as the customer is in hold </strong>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="my-messages pull-right"  ng-messages="ctrl.createOrderForm.orderNumber.$error"
                                         ng-if="ctrl.shipmentDateValidMsg">
                                        <div class="message-animation" >
                                            <strong>Late Shipment Date and Early Shipment date aren't valid.</strong>
                                        </div>
                                    </div>
                                </div>


                                <div class="col-md-12">
                                    <div class="panel-footer">
                                        <div class="pull-left">
                                            <button class="btn btn-default" type="button" ng-click="ctrl.closeEditOrder()"><g:message code="default.button.cancel.label" /></button>
                                        </div>
                                        <div class="pull-right">
                                            <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disableEditOrdBtn"><g:message code="default.button.save.label" /></button>
                                        </div>
                                        <br style="clear: both;"/>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                        <div class="col-md-9" style="float: right;">
                            <div class="col-md-3" style="width: 150px;float: right;" ng-show='!ctrl.orderFieldsEditabe && ctrl.orderList.length > 0'>
                            <button class="btn btn-default" ng-click = "ctrl.printOrderReport()" ng-disabled = "ctrl.orderList.length == 0">Print</button>
                            </div>
                            <div class="col-md-3" style="width: 150px;float: right;" ng-show='!ctrl.orderFieldsEditabe && ctrl.orderList.length > 0'>
                            <button class="btn btn-primary editOrdBtn" ng-click = "ctrl.editOrder()" ng-disabled = "ctrl.orderList.length == 0"><em class="fa fa-edit fa-fw mr-sm"></em><g:message code="default.button.editOrder.label" /></button>
                            </div>
                            <div class="col-md-3" style="width: 150px;float: right;" ng-show='!ctrl.orderFieldsEditabe && ctrl.orderList.length > 0'>
                            <button class="btn btn-default delOrdBtn" ng-click = "ctrl.deleteOrder()" ng-disabled = "ctrl.orderList.length == 0"><em class="fa fa-trash-o fa-fw mr-sm"></em><g:message code="default.button.deleteOrder.label" /></button>
                            </div>
                        </div>
                        

                        <br style="clear: both;"/>
                        <div ng-if='ctrl.orderList.length > 0'>

                            <hr/>

                            <div style="float: left; margin-top: 20px;" ng-show='!ctrl.orderFieldsEditabe && ctrl.orderList.length > 0'>
                                <!-- <i class="fa fa-level-up fa-2x fa-rotate-180" ></i> -->
                                <button class="btn btn-primary btn-xs findBtn" ng-click = "ctrl.getSelectedRows()" ng-disabled = "ctrl.plannedOrderLineList.length > 0 || ctrl.selectedOrderLineCount.length == 0" style="margin-top: -40px;">
                                    Plan To Shipment
                                </button>
                            </div>

                            <br style="clear: both;"/>


                            <p>
                            <div  id="grid1" ui-grid="gridOrderLines"  ui-grid-exporter ui-grid-selection ui-grid-auto-resize ui-grid-resize-columns class="grid" >
                                <div class="noLocationMessage" ng-if="gridOrderLines.data.length == 0" ><g:message code="orderLine.grid.noData.message" /></div>
                            </div>
                        </p>

                            <div style="clear: both;"/></div>

                            <%-- ****************** END OF Location Grid  ****************** --%>

                            <button ng-hide="ctrl.orderData[0].orderStatus == 'CLOSED'" type="button" class="btn btn-primary findBtn pull-right" ng-click="ctrl.addOrderLine()" style="margin-top: 20px;"
                                    ng-disabled = "ctrl.orderList.length == 0" >
                                Add New Order line
                            </button>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                        </div>
                    </div>
                    <div id="areas" class="tab-pane fade">

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showAllocationSuccessMessage">
                            {{ctrl.allocationSuccessMessage}}
                        </div>

                        <div ng-if='ctrl.orderList.length > 0 '>
                            <div class="col-lg-12" >
                                <div class="col-lg-6">
                                    <div>
                                        <div class="label-desc-order">Customer :</div>
                                        <div class="label-content">{{ctrl.customerData[0].contact_name}}</div>
                                        <br style="clear: both;"/>
                                    </div>

                                </div>
                                <div class="col-lg-6">
                                    <div>
                                        <div class="label-desc-order">Company :</div>
                                        <div class="label-content">{{ctrl.customerData[0].company_name}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                </div>
                            </div>
                            <br style="clear: both;"/>
                            <hr/>
                            <div ng-if='ctrl.shipmentDataByOrder.length > 0'>
                                <div ng-repeat="shipmentData in ctrl.shipmentDataByOrder">

                                    <div class="col-lg-12">
                                        <div class="col-lg-6">

                                            <div>
                                                <div class="label-desc-order">Shipment Id :</div>
                                                <div class="label-content">{{shipmentData.shipment_id}}</div>
                                                <br style="clear: both;"/>
                                            </div>
                                            <div>
                                                <div class="label-desc-order">Status :</div>
                                                <div class="label-content">{{shipmentData.shipment_status}}</div>
                                                <br style="clear: both;"/>
                                            </div>
                                            <div>
                                                <div class="label-desc-order">Shipping Contact :</div>
                                                <div class="label-content">{{shipmentData.contactName ? shipmentData.contactName : ctrl.customerData[0].contact_name}}</div>
                                                <br style="clear: both;"/>
                                            </div>
                                            <div>
                                                <div class="label-desc-order">Carrier Code :</div>
                                                <div class="label-content">{{shipmentData.carrier_code}}</div>
                                                <br style="clear: both;"/>
                                            </div>
                                            <div>
                                                <div class="label-desc-order">Service Level :</div>
                                                <div class="label-content">{{shipmentData.service_level}}</div>
                                                <br style="clear: both;"/>
                                            </div>
                                            <div ng-if="shipmentData.shipment_notes">
                                                <div class="label-desc-order" >Shipment Notes :</div>
                                                <div class="label-content"><a href="javascript:void(0)"  popover-trigger="outsideClick"  uib-popover="{{shipmentData.shipment_notes}}" popover-title="" popover-append-to-body="true" > View</a></div>
                                            </div>

                                        </div>
                                        <div class="col-lg-6">
                                            <div ng-if = "shipmentData.is_parcel == true">
                                                <div class="label-desc-order">Small Package :</div>
                                                <div class="label-content">Yes</div>
                                                <br style="clear: both;"/>
                                            </div>
                                            <div ng-if = "shipmentData.is_parcel == false">
                                                <div class="label-desc-order">Small Package :</div>
                                                <div class="label-content">No</div>
                                                <br style="clear: both;"/>
                                            </div>
                                            <div>
                                                <div class="label-desc-order">Truck No :</div>
                                                <div class="label-content">{{shipmentData.truck_number}}</div>
                                                <br style="clear: both;"/>
                                            </div>
                                            <div>
                                                <div class="label-desc-order">Tracking No./Pro No. :</div>
                                                <div class="label-content" ng-if="ctrl.getCarrierCodeLink(shipmentData.carrier_code,shipmentData.tracking_no)"> <a href="{{ctrl.getCarrierCodeLink(shipmentData.carrier_code,shipmentData.tracking_no)}}"  target="_blank">{{shipmentData.tracking_no}} </a></div>
                                                <div class="label-content" ng-if="!ctrl.getCarrierCodeLink(shipmentData.carrier_code,shipmentData.tracking_no)">{{shipmentData.tracking_no}}</div>
                                                <br style="clear: both;"/>
                                            </div>

                                            <div>
                                                <div class="label-desc-order">Shipping Address :</div>
                                                <div class="label-content" style="width:220px;">
                                                    {{shipmentData.street_address}},&nbsp;
                                                    {{shipmentData.city}},&nbsp;
                                                    {{shipmentData.state}}<br/>
                                                    {{shipmentData.post_code}}<br/>
                                                    {{shipmentData.country}}</div>
                                                <br style="clear: both;"/>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="float: right;" ng-show="shipmentData.shipment_status == 'PLANNED'">
                                        <button class="btn btn-default" ng-click = "ctrl.cancelShipment(shipmentData.shipment_id)"><g:message code="default.button.cancelShipment.label" /></button>
                                        <button class="btn btn-warning" ng-click = "ctrl.editShipment(shipmentData)"><em class="fa fa-edit fa-fw mr-sm"></em><g:message code="default.button.editShipment.label" /></button>
                                    </div>

                                    <br style="clear: both;"/>
                                    <div ng-init="ctrl.getShipmentLineData(shipmentData.shipment_id,$index)"></div>
                                    <p>
                                    <div id="grid1" ui-grid="{data: ctrl.shipmentLineDataByOrder[$index], columnDefs: ctrl.ShipmentLineColumns}" ui-grid-exporter ui-grid-auto-resize ui-grid-resize-columns class="shipmentGrid">
                                        <div class="noLocationMessage" ng-if="ctrl.shipmentLineDataByOrder.length == 0"><g:message code="shipment.grid.noData.message" /></div>
                                    </div>
                                </p>


                                    %{--Start Allocate Button--}%

                                    <div style="float: right; margin-top: 0px; margin-bottom: 20px;">
                                        <button class="btn btn-default"  ng-show="ctrl.shipmentIdAllocationCancel[$index]" ng-click="ctrl.cancelAllocation(shipmentData.shipment_id)"><g:message code="default.button.cancelAllocation.label" /></button>
                                        <button class="btn btn-primary" ng-show="shipmentData.shipment_status == 'PLANNED'" ng-disabled="ctrl.allocationDisabled[$index] || shipmentData.waveNumber" ng-click = "ctrl.allocate(shipmentData)" ><g:message code="default.button.allocate.label" /></button>
                                        <button class="btn btn-primary" ng-show="shipmentData.shipment_status == 'ALLOCATED' || shipmentData.shipment_status == 'COMPLETED' || shipmentData.shipment_status == 'STAGED'" ng-click = "ctrl.viewPicks(shipmentData)" >View Picks</button>
                                    </div>

                                    <div style="float: left; margin-top: 0px; margin-bottom: 20px;">
                                        <button  class="btn btn-primary" ng-show="shipmentData.shipment_status == 'PLANNED' && ctrl.allocationFailedMessageDisplay[$index]" ng-click = "ctrl.allocationFailedMessageViewPopUp(shipmentData)" >View Allocation Messages</button>
                                    </div>
                                    <br style="clear: both;"/>
                                    <div class="my-messages pull-right" ng-if='shipmentData.waveNumber'>
                                        This shipment is a part of the wave "{{shipmentData.waveNumber}}"
                                    </div>

                                    <br style="clear: both;"/>

                                    %{--End  Allocate Button--}%

                                    <hr/>
                                </div>
                            </div>
                            <div class="noDataMessage" ng-if='ctrl.shipmentDataByOrder.length == 0'>
                                This Order doesn't have any shipments.
                            </div>
                        </div>
                        <div class="col-lg-12 noDataMessage" ng-if='ctrl.orderList.length == 0'>
                            No Shipment details to display.
                        </div>
                        <br style="clear: both;"/>



                    </div>
                </div>
            </div>
            <!--/.panel-body -->
        </div>
        <!-- END panel-->
    </div>

    <!-- start order line view popup -->

    <div id="createOrderLineModel" class="modal fade" role="dialog" data-backdrop="static">
        <div class="modal-dialog"  style="width: 70%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4><g:message code="form.field.orderNo.label" /> : {{ctrl.selectedOrderNumber}}</h4>
                    <br style="clear: both;"/>
                </div>
                <form name="ctrl.orderLineForm" ng-submit="ctrl.saveOrderLine()" novalidate >
                    <div class="modal-body">


                        <div class="col-md-12">
                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLine('itemId')}">
                                    <label for="itemId"><g:message code="form.field.itemId.label" /></label>
                                    <div auto-complete  source="loadItemAutoComplete"  xxxx-list-formatter="customListFormatter" value-changed="ctrl.validateItemId(value.contactName)" style="z-index: 1000;">
                                        <input id="itemId" name="itemId" ng-model="ctrl.orderLineItemId"  ng-model-options="{ updateOn : 'default blur' }" placeholder="Item Id" class="form-control" required/>

                                        <div class="my-messages" ng-messages="ctrl.orderLineForm.itemId.$error" ng-if="ctrl.showMessagesForOrderLine('itemId')">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>

                                    </div>
                                </div>



                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLine('orderedQuantity')}">
                                    <label for="orderedQuantity"><g:message code="form.field.orderedQty.label" /></label>
                                    <input id="orderedQuantity" name="orderedQuantity" class="form-control" type="number" min="1"
                                           ng-model="ctrl.orderLineOrderedQuantity" ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleOrderedQuantityPrompt($index)" ng-blur="ctrl.toggleOrderedQuantityPrompt(-1)"  required />



                                    <div class="my-messages" ng-messages="ctrl.orderLineForm.orderedQuantity.$error" ng-if="ctrl.showMessagesForOrderLine('orderedQuantity')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages" ng-messages="ctrl.orderLineForm.orderedQuantity.$error" ng-if="ctrl.orderLineForm.orderedQuantity.$error.min">
                                        <div class="message-animation">
                                            <strong>Cannot enter zero.</strong>
                                        </div>
                                    </div>


                                </div>


                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLine('requestedInventoryStatus')}" style="margin-bottom: 0px; margin-top: 15px;">
                                    <label for="requestedInventoryStatus"><g:message code="form.field.reqInventoryStatus.label" /></label>
                                    <select  id="requestedInventoryStatus" name="requestedInventoryStatus" ng-model="ctrl.orderLineRequestedInventoryStatus" class="form-control" required>
                                        <option ng-repeat="option in ctrl.inventoryStatusOptions" value="{{option.optionValue}}">{{option.description}}</option>
                                    </select>

                                    <div class="my-messages" ng-messages="ctrl.orderLineForm.requestedInventoryStatus.$error" ng-if="ctrl.showMessagesForOrderLine('requestedInventoryStatus')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>
                                </div>


                            </div>

                            <div class="col-md-6">


                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLine('orderedUOM')}" ng-if="ctrl.orderLineOrderedUOM == 'EACH'">
                                    <label for="orderedUOM"><g:message code="form.field.orderedUom.label" /></label>
                                    <select  id="orderedUOM" name="orderedUOM" ng-model="ctrl.orderLineOrderedUOM" class="form-control" required >

                                        <option value="EACH" >EACH</option>
                                        <option value="CASE">CASE</option>
                                    </select>


                                    <div class="my-messages" ng-messages="ctrl.orderLineForm.orderedUOM.$error" ng-if="ctrl.showMessagesForOrderLine('orderedUOM')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLine('orderedUOM')}" ng-if="ctrl.orderLineOrderedUOM != 'EACH'">
                                    <label for="orderedUOM"><g:message code="form.field.orderedUom.label" /></label>
                                    <input  id="orderedUOM" name="orderedUOM" type = "text" ng-model="ctrl.orderLineOrderedUOM" class="form-control" disabled>
                                </div>


                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLine('displayOrderLineNumber')}">
                                    <label for="displayOrderLineNumber"><g:message code="form.field.displayOrderLineNumber.label" /></label>
                                    <input id="displayOrderLineNumber" name="displayOrderLineNumber" class="form-control" type="text"
                                           ng-model="ctrl.orderLineDisplayOrderLineNumber" ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleDisplayOrderLineNumberPrompt($index)" ng-blur="ctrl.toggleDisplayOrderLineNumberPrompt(-1)" numbers-only />

                                </div>

                                <div class="form-group">
                                    <label for="allByLpnNew">Allocate By LPN</label>
                                    <input id="allByLpnNew" name="allByLpnNew" class="form-control" type="text"
                                           ng-model="ctrl.allocateByLpnNew" ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleDisplayOrderLineNumberPrompt($index)" ng-blur="ctrl.toggleDisplayOrderLineNumberPrompt(-1)" capitalize/>
                                </div>



                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLine('isCreateKittingOrder')}" ng-if="ctrl.kittingOrder">
                                    <label for="isCreateKittingOrder"><g:message code="form.field.createKittingOrder.label" /></label>
                                    <br/>
                                    <input type="checkbox"  id="isCreateKittingOrder"  name="isCreateKittingOrder" ng-model="ctrl.orderLineIsCreateKittingOrder"  />

                                </div>


                            </div>


                        </div>

                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>


                    </div>

                    <div class="modal-footer">
                        <div class="pull-left">
                            <button class="btn btn-default" type="button" data-dismiss="modal" ng-click="ctrl.clearOrderLineForm()"><g:message code="default.button.cancel.label" /></button>
                        </div>
                        <div class="pull-right">
                            <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disableSaveOrderLineBtn"><g:message code="default.button.save.label" /></button>
                        </div>
                        <br style="clear: both;"/>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- end order line view popup -->

    <!-- start order line edit view popup -->

    <div id="createOrderLineModelEdit" class="modal fade" role="dialog" data-backdrop="static">
        <div class="modal-dialog"  style="width: 70%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4><g:message code="form.field.orderNo.label" /> : {{ctrl.selectedOrderNumber}}</h4>
                    <br style="clear: both;"/>
                </div>
                <form name="ctrl.orderLineFormEdit" ng-submit="ctrl.saveOrderLineEdit()" novalidate >
                    <div class="modal-body">


                        <div class="col-md-12">
                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLineEdit('itemId')}">
                                    <label for="itemId"><g:message code="form.field.itemId.label" /></label>
                                    <div auto-complete  source="loadItemAutoComplete"  xxxx-list-formatter="customListFormatter" value-changed="ctrl.validateItemId(value.contactName)" style="z-index: 1000;">
                                        <input id="itemId" name="itemId" ng-model="ctrl.orderLineItemIdEdit"  ng-model-options="{ updateOn : 'default blur' }" placeholder="Item Id" class="form-control" required/>

                                        <div class="my-messages" ng-messages="ctrl.orderLineFormEdit.itemId.$error" ng-if="ctrl.showMessagesForOrderLineEdit('itemId')">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLineEdit('orderedQuantity')}">
                                    <label for="orderedQuantity"><g:message code="form.field.orderedQty.label" /></label>
                                    <input id="orderedQuantity" name="orderedQuantity" class="form-control" type="number" min="1"
                                           ng-model="ctrl.orderLineOrderedQuantityEdit" ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleOrderedQuantityPrompt($index)" ng-blur="ctrl.toggleOrderedQuantityPrompt(-1)"  required />



                                    <div class="my-messages" ng-messages="ctrl.orderLineFormEdit.orderedQuantity.$error" ng-if="ctrl.showMessagesForOrderLineEdit('orderedQuantity')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages" ng-messages="ctrl.orderLineFormEdit.orderedQuantity.$error" ng-if="ctrl.orderLineFormEdit.orderedQuantity.$error.min">
                                        <div class="message-animation">
                                            <strong>Cannot enter zero.</strong>
                                        </div>
                                    </div>


                                </div>


                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLineEdit('requestedInventoryStatus')}" style="margin-bottom: 0px; margin-top: 15px;">
                                    <label for="requestedInventoryStatus"><g:message code="form.field.reqInventoryStatus.label" /></label>
                                    <select  id="requestedInventoryStatus" name="requestedInventoryStatus" ng-model="ctrl.orderLineRequestedInventoryStatusEdit" class="form-control" required>
                                        <option ng-repeat="option in ctrl.inventoryStatusOptions" value="{{option.optionValue}}">{{option.description}}</option>
                                    </select>

                                    <div class="my-messages" ng-messages="ctrl.orderLineFormEdit.requestedInventoryStatus.$error" ng-if="ctrl.showMessagesForOrderLineEdit('requestedInventoryStatus')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>
                                </div>


                            </div>

                            <div class="col-md-6">


                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLineEdit('orderedUOM')}" ng-if="ctrl.lowestUomEach">
                                    <label for="orderedUOM"><g:message code="form.field.orderedUom.label" /></label>
                                    <select  id="orderedUOM" name="orderedUOM" ng-model="ctrl.orderLineOrderedUOMEdit" class="form-control" required >

                                        <option value="EACH" >EACH</option>
                                        <option value="CASE">CASE</option>
                                    </select>


                                    <div class="my-messages" ng-messages="ctrl.orderLineFormEdit.orderedUOM.$error" ng-if="ctrl.showMessagesForOrderLineEdit('orderedUOM')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLine('orderedUOM')}" ng-if="!ctrl.lowestUomEach">
                                    <div ng-init="ctrl.orderLineOrderedUOMEdit = 'CASE'"></div>
                                    <label for="orderedUOM"><g:message code="form.field.orderedUom.label" /></label>
                                    <input  id="orderedUOM" name="orderedUOM" type = "text" ng-model="ctrl.orderLineOrderedUOMEdit" class="form-control" disabled>
                                </div>


                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLineEdit('displayOrderLineNumber')}">
                                <label for="displayOrderLineNumber"><g:message code="form.field.displayOrderLineNumber.label" /></label>
                                <input id="displayOrderLineNumber" name="displayOrderLineNumber" class="form-control" type="text"
                                       ng-model="ctrl.orderLineDisplayOrderLineNumberEdit" ng-model-options="{ updateOn : 'default blur' }"
                                       ng-focus="ctrl.toggleDisplayOrderLineNumberPrompt($index)" ng-blur="ctrl.toggleDisplayOrderLineNumberPrompt(-1)" numbers-only />

                                </div>

                                <div class="form-group">
                                    <label for="allByLpnEdit">Allocate By LPN</label>
                                    <input id="allByLpnEdit" name="allByLpnEdit" class="form-control" type="text"
                                           ng-model="ctrl.allocateByLpnEdit" ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleDisplayOrderLineNumberPrompt($index)" ng-blur="ctrl.toggleDisplayOrderLineNumberPrompt(-1)" capitalize/>

                                </div>

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForOrderLineEdit('isCreateKittingOrder')}" ng-if="ctrl.kittingOrder">
                                    <label for="isCreateKittingOrder"><g:message code="form.field.createKittingOrder.label" /></label>
                                    <br/>
                                    <input type="checkbox"  id="isCreateKittingOrder"  name="isCreateKittingOrder" ng-model="ctrl.orderLineIsCreateKittingOrderEdit"  />

                                </div>

                            </div>



                        </div>

                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>


                    </div>

                    <div class="modal-footer">
                        <div class="pull-left">
                            <button class="btn btn-default" type="button" data-dismiss="modal" ng-click="ctrl.clearOrderLineFormEdit()"><g:message code="default.button.cancel.label" /></button>
                        </div>
                        <div class="pull-right">
                            <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disableEditOrderLineBtn"><g:message code="default.button.save.label" /></button>
                        </div>
                        <br style="clear: both;"/>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- end order line edit view popup -->


    <%-- **************************** create Customer form **************************** --%>
    <div id="addCustomer" class="modal fade" role="dialog">
        <div class="customer-modal-dialog modal-dialog" >
            <div class="customer-modal-content modal-content">

                <div class="customer-modal-header modal-header">
                    <button type="button" class="customer-close close" data-dismiss="modal" aria-hidden="true"  ng-click="ctrl.clearCreateCustomer()">&times;</button>
                    <br style="clear: both;"/>

                    <div class="panel-heading">
                        <div class="customer-panel-title panel-title"><h4><g:message code="default.customer.add.label" /></h4></div>
                    </div>

                </div>

                <div class="customer-modal-body modal-body">

                    <form name="ctrl.createCustomerForm" ng-submit="ctrl.createCustomer()"  novalidate >

                        <div class="panel-body">

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('contactName')}">
                                    <label><g:message code="form.field.contactName.label" /></label>
                                    <div class="controls">
                                        <input id="contactName" name="contactName" class="form-control" type="text"
                                               ng-model="ctrl.newCustomer.contactName" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Customer Name" required/>

                                        <div class="my-messages" ng-messages="ctrl.createCustomerForm.contactName.$error" ng-if="ctrl.showMessages('contactName')">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>


                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('companyName')}">
                                    <label for="companyName"><g:message code="form.field.companyName.label" /></label>
                                    <div class="controls">
                                        <input id="companyName" name="companyName" class="form-control" type="text"
                                               ng-model="ctrl.newCustomer.companyName" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Customer Company Name" required/>

                                        <div class="my-messages" ng-messages="ctrl.createCustomerForm.contactName.$error" ng-if="ctrl.showMessages('companyName')">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <br style="clear: both;"/>


                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('phonePrimary')}">
                                    <label><g:message code="form.field.phonePrimary.label" /></label>
                                    <div class="controls">
                                        <input id="phonePrimary" name="phonePrimary" class="form-control" type="text"
                                               ng-model="ctrl.newCustomer.phonePrimary" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Phone Number" maxlength="15" phone-numbers />
                                    </div>
                                </div>

                            </div>


                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('phoneAlternate')}">
                                    <label for="phoneAlternate"><g:message code="form.field.phoneAlternate.label" /></label>
                                    <div class="controls">
                                        <input id="phoneAlternate" name="phoneAlternate" class="form-control" type="text"
                                               ng-model="ctrl.newCustomer.phoneAlternate" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Phone Number" maxlength="15" phone-numbers/>
                                    </div>
                                </div>

                            </div>

                            <br style="clear: both;"/>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('email')}">
                                    <label><g:message code="form.field.email.label" /></label>
                                    <div class="controls">
                                        <input id="email" name="email" class="form-control" type="email"
                                               ng-model="ctrl.newCustomer.email" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Email Address"/>
                                        <div class="my-messages" ng-messages="ctrl.createCustomerForm.email.$error" ng-if="ctrl.showMessages('email')">
                                            <div class="message-animation" ng-message="email">
                                                <strong>Please enter a valid email.</strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('fax')}">
                                    <label for="fax"><g:message code="form.field.fax.label" /></label>
                                    <div class="controls">
                                        <input id="fax" name="fax" class="form-control" type="text"
                                               ng-model="ctrl.newCustomer.fax" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Fax Number" maxlength="15" phone-numbers/>
                                    </div>
                                </div>

                            </div>

                            <br style="clear: both;"/>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="isCustomerHold"><g:message code="form.field.customerHold.label" /></label>
                                    <div class="checkbox c-checkbox">
                                        <label>
                                            <input id="isCustomerHold" name="isCustomerHold" type="checkbox" value="" ng-click="" ng-model="ctrl.newCustomer.isCustomerHold">
                                            <span class="fa fa-check"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>


                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="notes"><g:message code="form.field.notes.label" /></label>
                                    <div class="controls">
                                        <textarea id="notes" name="notes" class="form-control"
                                                  ng-model="ctrl.newCustomer.notes" ng-model-options="{ updateOn : 'default blur' }"
                                                  placeholder="Notes"></textarea>
                                    </div>
                                </div>
                            </div>

                            <br style="clear: both;"/>

                            <h4><g:message code="form.field.billing.label" /> <g:message code="form.field.details.label" />:</h4>

                            <div class="col-md-6">
                                <div class="form-group" style="margin-bottom: 0px; margin-top: 0px;">
                                    <label for="billingStreetAddress"><g:message code="form.field.billing.label" /> <g:message code="form.field.street.label" /></label>
                                    <div class="controls">
                                        <textarea id="billingStreetAddress" name="billingStreetAddress" class="form-control"
                                                  ng-model="ctrl.newCustomer.billingStreetAddress" ng-model-options="{ updateOn : 'default blur' }"
                                                  placeholder="Street Address"></textarea>

                                    </div>
                                </div>
                            </div>


                            <div class="col-md-6" >

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('billingCity')}" >
                                    <label for="billingCity"><g:message code="form.field.billing.label" /> <g:message code="form.field.city.label" /></label>
                                    <div class="controls">
                                        <input id="billingCity" name="billingCity" class="form-control" type="text"
                                               ng-model="ctrl.newCustomer.billingCity" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="City/Town"/>
                                    </div>

                                </div>
                            </div>
                            <br style="clear: both;"/>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('billingState')}" style="margin-bottom: 10px; margin-top: 17px;">
                                    <label for="billingState"><g:message code="form.field.billing.label" /> <g:message code="form.field.state.label" /></label>
                                    <div class="controls">
                                        <input id="billingState" name="billingState" class="form-control" type="text"
                                               ng-model="ctrl.newCustomer.billingState" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="State/Province"/>
                                    </div>

                                </div>
                            </div>


                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('billingPostCode')}" style="margin-bottom: 10px; margin-top: 17px;">
                                    <label for="billingPostCode"><g:message code="form.field.billing.label" /> <g:message code="form.field.postCode.label" /></label>
                                    <div class="controls">
                                        <input id="billingPostCode" name="billingPostCode" class="form-control" type="text"
                                               ng-model="ctrl.newCustomer.billingPostCode" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="ZIP/Post Code"/>
                                    </div>
                                </div>
                            </div>

                            <br style="clear: both;"/>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('billingCountry')}">
                                    <label for="billingCountry"><g:message code="form.field.billing.label" /> <g:message code="form.field.country.label" /></label>
                                    <select  id="billingCountry" name="billingCountry" ng-model="ctrl.newCustomer.billingCountry" class="form-control" >
                                        <option selected disabled value="">Select Country</option>
                                        <option ng-repeat="country in  countryList" value="{{country}}">{{country}}</option>
                                    </select>
                                </div>

                            </div>

                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <h4><g:message code="form.field.shipping.label" /> <g:message code="form.field.details.label" />:</h4>

                            <div class="col-md-6">

                                <div class="form-group">
                                    <div class="checkbox c-checkbox">
                                        <label>
                                            <input type="checkbox" value="" ng-click="ctrl.checkShippingAddress()" ng-model="ctrl.shippingAddress">
                                            <span class="fa fa-check"></span><g:message code="form.field.sameAs.label" /></label>
                                    </div>

                                    <label for="shippingStreetAddress"><g:message code="form.field.shipping.label" /> <g:message code="form.field.street.label" /></label>

                                    <div class="controls">
                                        <textarea id="shippingStreetAddress" name="shippingStreetAddress" class="form-control"
                                                  ng-model="ctrl.newCustomer.shippingStreetAddress" ng-model-options="{ updateOn : 'default blur' }"
                                                  placeholder="Street Address" ng-disabled="ctrl.shippingAddress"></textarea>

                                    </div>

                                </div>
                            </div>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('shippingCity')}" style="margin-bottom: 0px; margin-top: 38px;">
                                    <label for="shippingCity"><g:message code="form.field.shipping.label" /> <g:message code="form.field.city.label" /></label>
                                    <div class="controls">
                                        <input id="shippingCity" name="shippingCity" class="form-control" type="text"
                                               ng-model="ctrl.newCustomer.shippingCity" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="City/Town" ng-disabled="ctrl.shippingAddress"/>
                                    </div>

                                </div>
                            </div>
                            <br style="clear: both;"/>


                            <div class="col-md-6">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('shippingState')}">
                                    <label for="shippingState"><g:message code="form.field.shipping.label" /> <g:message code="form.field.state.label" /></label>
                                    <div class="controls">
                                        <input id="shippingState" name="shippingState" class="form-control" type="text"
                                               ng-model="ctrl.newCustomer.shippingState" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="State/Province" ng-disabled="ctrl.shippingAddress"/>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('shippingPostCode')}">
                                    <label for="shippingPostCode"><g:message code="form.field.shipping.label" /> <g:message code="form.field.postCode.label" /></label>
                                    <div class="controls">
                                        <input id="shippingPostCode" name="shippingPostCode" class="form-control" type="text"
                                               ng-model="ctrl.newCustomer.shippingPostCode" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="ZIP/Post Code" ng-disabled="ctrl.shippingAddress"/>
                                    </div>
                                </div>

                            </div>

                            <br style="clear: both;"/>

                            <div class="col-md-6">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('shippingCountry')}">
                                    <label for="shippingCountry"><g:message code="form.field.shipping.label" /> <g:message code="form.field.country.label" /></label>
                                    <select  id="shippingCountry" name="shippingCountry" ng-model="ctrl.newCustomer.shippingCountry" class="form-control" ng-disabled="ctrl.shippingAddress">
                                        <option selected disabled value="">Select Country</option>
                                        <option ng-repeat="country in  countryList" value="{{country}}">{{country}}</option>
                                    </select>
                                </div>
                            </div>

                        </div>

                </div>
                <div class="customer-modal-footer modal-footer">
                    %{--<button class="btn btn-default" type="button" data-dismiss="modal" style="margin-left: 0px; margin-right: 433px;"><g:message code="default.button.cancel.label" /></button>--}%
                    %{--<button class="btn btn-primary" type="submit" style="margin-left: 100px; margin-right: 10px;" ><g:message code="default.button.save.label" /></button>--}%

                    <button class="btn btn-default pull-left" type="button" data-dismiss="modal" ng-click="ctrl.clearCreateCustomer()"><g:message code="default.button.cancel.label" /></button>
                    <button class="btn btn-primary" type="submit" style="margin-left: 100px; margin-right: 10px;" ><g:message code="default.button.save.label" /></button>

                    <br style="clear: both;"/>
                    <br style="clear: both;"/>

                </div>

            </form>

            </div>
        </div>
    </div>
    <%-- **************************** End of create Customer form **************************** --%>


    <%-- **************************** Edit Customer form ************************************* --%>
    <div id="editCustomer" class="modal fade" role="dialog">
        <div class="customer-modal-dialog modal-dialog" >
            <div class="customer-modal-content modal-content">

                <div class="customer-modal-header modal-header">
                    <button type="button" class="customer-close close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <br style="clear: both;"/>
                    <div class="panel-heading">
                        <div class="customer-panel-title panel-title"><g:message code="default.customer.edit.label" /></div>
                    </div>

                </div>

                <div class="customer-modal-body modal-body">

                    <form name="ctrl.editCustomerForm" ng-submit="ctrl.updateCustomer()"  novalidate >

                        <div class="panel-body">

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('contactName')}">
                                    <label><g:message code="form.field.contactName.label" /></label>
                                    <div class="controls">
                                        <input id="contactName" name="contactName" class="form-control" type="text"
                                               ng-model="ctrl.editCustomer.contactName" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Customer Name" required/>

                                        <div class="my-messages" ng-messages="ctrl.editCustomerForm.contactName.$error" ng-if="ctrl.showMessagesEdit('contactName')">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>


                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('companyName')}">
                                    <label for="companyName"><g:message code="form.field.companyName.label" /></label>
                                    <div class="controls">
                                        <input id="companyName" name="companyName" class="form-control" type="text"
                                               ng-model="ctrl.editCustomer.companyName" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Customer Company Name" required/>

                                        <div class="my-messages" ng-messages="ctrl.editCustomerForm.contactName.$error" ng-if="ctrl.showMessagesEdit('companyName')">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <br style="clear: both;"/>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('phonePrimary')}">
                                    <label><g:message code="form.field.phonePrimary.label" /></label>
                                    <div class="controls">
                                        <input id="phonePrimary" name="phonePrimary" class="form-control" type="text"
                                               ng-model="ctrl.editCustomer.phonePrimary" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Phone Number" maxlength="15" phone-numbers />
                                    </div>
                                </div>

                            </div>


                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('phoneAlternate')}">
                                    <label for="phoneAlternate"><g:message code="form.field.phoneAlternate.label" /></label>
                                    <div class="controls">
                                        <input id="phoneAlternate" name="phoneAlternate" class="form-control" type="text"
                                               ng-model="ctrl.editCustomer.phoneAlternate" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Phone Number" maxlength="15" phone-numbers/>
                                    </div>
                                </div>

                            </div>


                            <br style="clear: both;"/>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('email')}">
                                    <label><g:message code="form.field.email.label" /></label>
                                    <div class="controls">
                                        <input id="email" name="email" class="form-control" type="email"
                                               ng-model="ctrl.editCustomer.email" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Email Address"/>
                                        <div class="my-messages" ng-messages="ctrl.editCustomerForm.email.$error" ng-if="ctrl.showMessagesEdit('email')">
                                            <div class="message-animation" ng-message="email">
                                                <strong>Please enter a valid email.</strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('fax')}">
                                    <label for="fax"><g:message code="form.field.fax.label" /></label>
                                    <div class="controls">
                                        <input id="fax" name="fax" class="form-control" type="text"
                                               ng-model="ctrl.editCustomer.fax" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Fax Number" maxlength="15" phone-numbers/>
                                    </div>
                                </div>

                            </div>

                            <br style="clear: both;"/>

                            <g:if test="${session.user.adminActiveStatus == true}">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="isCustomerHold"><g:message code="form.field.customerHold.label" /></label>
                                        <div class="checkbox c-checkbox">
                                            <label>
                                                <input id="isCustomerHold" name="isCustomerHold" type="checkbox" value="" ng-click="" ng-model="ctrl.editCustomer.isCustomerHold">
                                                <span class="fa fa-check"></span></label>
                                        </div>
                                    </div>
                                </div>
                            </g:if>


                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="notes"><g:message code="form.field.notes.label" /></label>
                                    <div class="controls">
                                        <textarea id="notes" name="notes" class="form-control"
                                                  ng-model="ctrl.editCustomer.notes" ng-model-options="{ updateOn : 'default blur' }"
                                                  placeholder="Notes"></textarea>
                                    </div>
                                </div>
                            </div>

                            <br style="clear: both;"/>

                            <h4><g:message code="form.field.billing.label" /> <g:message code="form.field.details.label" />:</h4>

                            <div class="col-md-6">

                                <div class="form-group" style="margin-bottom: 0px; margin-top: 0px;">
                                    <label for="billingStreetAddress"><g:message code="form.field.billing.label" /> <g:message code="form.field.street.label" /></label>
                                    <div class="controls">
                                        <textarea id="billingStreetAddress" name="billingStreetAddress" class="form-control"
                                                  ng-model="ctrl.editCustomer.billingStreetAddress" ng-model-options="{ updateOn : 'default blur' }"
                                                  placeholder="Street Address"></textarea>

                                    </div>
                                </div>

                            </div>


                            <div class="col-md-6" >

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('billingCity')}">
                                    <label for="billingCity"><g:message code="form.field.billing.label" /> <g:message code="form.field.city.label" /></label>
                                    <div class="controls">
                                        <input id="billingCity" name="billingCity" class="form-control" type="text"
                                               ng-model="ctrl.editCustomer.billingCity" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="City/Town"/>
                                    </div>

                                </div>
                            </div>

                            <br style="clear: both;"/>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('billingState')}" style="margin-bottom: 10px; margin-top: 17px;">
                                    <label for="billingState"><g:message code="form.field.billing.label" /> <g:message code="form.field.state.label" /></label>
                                    <div class="controls">
                                        <input id="billingState" name="billingState" class="form-control" type="text"
                                               ng-model="ctrl.editCustomer.billingState" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="State/Province"/>
                                    </div>

                                </div>
                            </div>


                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('billingPostCode')}" style="margin-bottom: 10px; margin-top: 17px;">
                                    <label for="billingPostCode"><g:message code="form.field.billing.label" /> <g:message code="form.field.postCode.label" /></label>
                                    <div class="controls">
                                        <input id="billingPostCode" name="billingPostCode" class="form-control" type="text"
                                               ng-model="ctrl.editCustomer.billingPostCode" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="ZIP/Post Code"/>
                                    </div>
                                </div>
                            </div>

                            <br style="clear: both;"/>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('billingCountry')}">
                                    <label for="billingCountry"><g:message code="form.field.billing.label" /> <g:message code="form.field.country.label" /></label>
                                    <select  id="billingCountry" name="billingCountry" ng-model="ctrl.editCustomer.billingCountry" class="form-control" >
                                        <option selected disabled value="">Select Country</option>
                                        <option ng-repeat="country in countryList" value="{{country}}">{{country}}
                                        </option>
                                    </select>
                                </div>

                            </div>

                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <h4><g:message code="form.field.shipping.label" /> <g:message code="form.field.details.label" />:</h4>

                            <div class="col-md-6">

                                <div class="form-group">
                                    <div class="checkbox c-checkbox">
                                        <label>
                                            <input type="checkbox" value="" ng-click="ctrl.checkEditShippingAddress()" ng-model="ctrl.editShippingAddress">
                                            <span class="fa fa-check"></span><g:message code="form.field.sameAs.label" /></label>
                                    </div>

                                    <label for="shippingStreetAddress"><g:message code="form.field.shipping.label" /> <g:message code="form.field.street.label" /></label>
                                    <div class="controls">
                                        <textarea id="shippingStreetAddress" name="shippingStreetAddress" class="form-control"
                                                  ng-model="ctrl.editCustomer.shippingStreetAddress" ng-model-options="{ updateOn : 'default blur' }"
                                                  placeholder="Street Address" ng-disabled="ctrl.editShippingAddress"></textarea>

                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('shippingCity')}" style="margin-bottom: 0px; margin-top: 38px;">
                                    <label for="shippingCity"><g:message code="form.field.shipping.label" /> <g:message code="form.field.city.label" /></label>
                                    <div class="controls">
                                        <input id="shippingCity" name="shippingCity" class="form-control" type="text"
                                               ng-model="ctrl.editCustomer.shippingCity" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="City/Town" ng-disabled="ctrl.editShippingAddress"/>
                                    </div>

                                </div>
                            </div>

                            <br style="clear: both;"/>

                            <div class="col-md-6">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('shippingState')}">
                                    <label for="shippingState"><g:message code="form.field.shipping.label" /> <g:message code="form.field.state.label" /></label>
                                    <div class="controls">
                                        <input id="shippingState" name="shippingState" class="form-control" type="text"
                                               ng-model="ctrl.editCustomer.shippingState" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="State/Province" ng-disabled="ctrl.editShippingAddress"/>
                                    </div>

                                </div>
                            </div>

                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('shippingPostCode')}" >
                                    <label for="shippingPostCode"><g:message code="form.field.shipping.label" /> <g:message code="form.field.postCode.label" /></label>
                                    <div class="controls">
                                        <input id="shippingPostCode" name="shippingPostCode" class="form-control" type="text"
                                               ng-model="ctrl.editCustomer.shippingPostCode" ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="ZIP/Post Code" ng-disabled="ctrl.editShippingAddress"/>
                                    </div>
                                </div>

                            </div>

                            <br style="clear: both;"/>

                            <div class="col-md-6">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('shippingCountry')}">
                                    <label for="shippingCountry"><g:message code="form.field.shipping.label" /> <g:message code="form.field.country.label" /></label>
                                    <select  id="shippingCountry" name="shippingCountry" ng-model="ctrl.editCustomer.shippingCountry" class="form-control" ng-disabled="ctrl.editShippingAddress" >
                                        <option selected disabled value="">Select Country</option>
                                        <option ng-repeat="country in countryList" value="{{country}}">{{country}}</option>
                                    </select>
                                </div>

                            </div>
                        </div>
                </div>

                <div class="customer-modal-footer modal-footer">
                    %{--<button class="btn btn-default" type="button" data-dismiss="modal" style="margin-left: 0px; margin-right: 425px;"><g:message code="default.button.cancel.label" /></button>--}%
                    %{--<button class="btn btn-primary" type="submit" style="margin-left: 100px; margin-right: 10px;" ><g:message code="default.button.update.label" /></button>--}%

                    <button class="btn btn-default pull-left" type="button" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button class="btn btn-primary" type="submit" style="margin-left: 100px; margin-right: 10px;" ><g:message code="default.button.update.label" /></button>

                    <br style="clear: both;"/>
                    <br style="clear: both;"/>

                </div>

            </form>

            </div>
        </div>
    </div>

    <%-- **************************** End of Edit Customer form **************************** --%>




    <%-- **************************** Start Plan to Shipment ************************************* --%>

    <div id="planToShipment" class="modal fade" role="dialog" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true" ng-click = "ctrl.closeShipmentModel()">&times;</button>
                    <h4 class="modal-title">Allocate Wave</h4>
                </div>
                <div class="modal-body">

                    <div ng-show="ctrl.assignShipmentWarning" class="alert alert-warning message-animation" role="alert" >
                        {{ctrl.assignShipmentWarningMessage}}
                    </div>

                    <div style="padding: 5px 0px; font-size: 14px; font-weight: bold;">
                        <div class="col-md-2">
                            Wave Number :
                        </div>
                        <div class="col-md-4">
                            {{ctrl.selectedOrderNumber}}
                        </div>
                        <div class="col-md-3" ng-show="ctrl.assignShipmentOrderLineNumber">
                            Order Line :
                        </div>
                        <div class="col-md-3">
                            {{ctrl.assignShipmentOrderLineNumber.toString()}}
                        </div>
                        <br style="clear:both;"/>
                    </div>

                    <div style="padding: 5px 0px; font-size: 14px; font-weight: bold;">

                        <div class="col-md-3" style="padding-right: 0px; margin-right: 0px;">
                            Billing Contact:
                        </div>
                        <div class="col-md-3" style="padding-left: 0px; margin-left: 0px;">
                            {{ctrl.customerData[0].contact_name}}
                        </div>

                        <div class="col-md-2" >
                            Company:
                        </div>
                        <div class="col-md-4" >
                            {{ctrl.customerData[0].company_name}}
                        </div>
                        <br style="clear:both;"/>
                    </div>
                    <div style="padding: 5px 0px; font-size: 14px; font-weight: bold;" ng-show="!IsVisibleExistingShipment">
                        <div class="col-md-3">
                            Shipping Contact:
                        </div>
                        <div class="col-md-9" ng-hide="ctrl.isEditCutomerName">
                            {{ctrl.customerData[0].contact_name}}&emsp;<a href="" ng-click="ctrl.editCutomerName()"><span class="glyphicon glyphicon-pencil"></span></a>
                        </div>
                        <div class="col-md-9" ng-show="ctrl.isEditCutomerName">
                            <input id="cutomerNameEdit" name="cutomerNameEdit" class="form-control" type="text" ng-model="ctrl.cutomerNameFieldEdit" ng-model-options="{ updateOn : 'default blur' }" style="width: 200px; display: inline-block;" />&emsp;
                            <a href="" ng-click=""><span class="glyphicon glyphicon-pencil"></span></a>
                        </div>
                        <br style="clear:both;"/>
                    </div>

                    <div style="padding: 20px 0px; font-size: 14px; font-weight: bold;" ng-show="!IsVisibleExistingShipment">
                        <div class="col-md-3">
                           Shipping Address:
                        </div>
                        <div class="col-md-9" style="font-weight: normal;">
                            <div>
                                <div class="radio">
                                    <label><input type="radio" name="optChooseAddrs" ng-model="ctrl.optAddress" value="existingAddress">Choose Existing Address</label>
                                </div>

                                <select ng-if="ctrl.optAddress == 'existingAddress'" name="mySelect" id="mySelect" class="form-control" ng-options="option.shippingAddress for option in customerShippingAddressList track by option.id" ng-model="ctrl.shippingAddressFromOpt"></select>                                
                                <!-- <select   id="shippingAddress" name="shippingAddress" ng-model="ctrl.shippingAddressFromOpt"  >
                                    <option ng-repeat="address in customerShippingAddressList" >{{address.id}}</option>
                                </select> -->
                                <div class="radio">
                                    <label><input type="radio" name="optChooseAddrs" ng-model="ctrl.optAddress" value="newAddress">Enter New Address</label>
                                </div>
                                <div ng-form="ctrl.newAddressForm" ng-if="ctrl.optAddress == 'newAddress'">
                                    <div class="col-md-6" style="padding: 2px 0px;" ng-class="{'has-error':ctrl.newAddressForm.shippingStreetAddress.$touched && ctrl.newAddressForm.shippingStreetAddress.$invalid}">
                                        <label for="streetAddress"><g:message code="form.field.shipping.label" /> <g:message code="form.field.street.label" /></label>
                                        <div class="controls">
                                            <textarea id="streetAddress" name="shippingStreetAddress" rows="4" class="form-control" ng-model="ctrl.customerShippingStreetAddress" ng-model-options="{ updateOn : 'default blur' }" placeholder="Street Address" required></textarea>

                                        </div>
                                        <div class="my-messages" ng-messages="ctrl.newAddressForm.shippingStreetAddress.$error" ng-if="ctrl.newAddressForm.shippingStreetAddress.$touched || ctrl.newAddressForm.$submitted">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>                                        

                                    </div>
                                    <div class="col-md-6" style="padding: 2px;" ng-class="{'has-error':ctrl.newAddressForm.shippingCity.$touched && ctrl.newAddressForm.shippingCity.$invalid}">

                                        <label for="city"><g:message code="form.field.shipping.label" /> <g:message code="form.field.city.label" /></label>
                                        <div class="controls">
                                            <input id="city" name="shippingCity" class="form-control" type="text" ng-model="ctrl.customerShippingCity" ng-model-options="{ updateOn : 'default blur' }" placeholder="City/Town" required />
                                        </div>
                                        <div class="my-messages" ng-messages="ctrl.newAddressForm.shippingCity.$error" ng-if="ctrl.newAddressForm.shippingCity.$touched || ctrl.newAddressForm.$submitted">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="col-md-6" style="padding: 2px;" ng-class="{'has-error':ctrl.newAddressForm.shippingState.$touched && ctrl.newAddressForm.shippingState.$invalid}">

                                        <label for="state"><g:message code="form.field.shipping.label" /> <g:message code="form.field.state.label" /></label>
                                        <div class="controls">
                                            <input id="state" name="shippingState" class="form-control" type="text" ng-model="ctrl.customerShippingState" ng-model-options="{ updateOn : 'default blur' }" placeholder="State/Province" required />
                                        </div>
                                        <div class="my-messages" ng-messages="ctrl.newAddressForm.shippingState.$error" ng-if="ctrl.newAddressForm.shippingState.$touched || ctrl.newAddressForm.$submitted">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="col-md-6" style="padding: 2px;" ng-class="{'has-error':ctrl.newAddressForm.shippingPostCode.$touched && ctrl.newAddressForm.shippingPostCode.$invalid}">

                                        <label for="postCode"><g:message code="form.field.shipping.label" /> <g:message code="form.field.postCode.label" /></label>
                                        <div class="controls">
                                            <input id="postCode" name="shippingPostCode" class="form-control" type="text" ng-model="ctrl.customerShippingPostCode" ng-model-options="{ updateOn : 'default blur' }"  placeholder="ZIP/Post Code" required />
                                        </div>
                                        <div class="my-messages" ng-messages="ctrl.newAddressForm.shippingPostCode.$error" ng-if="ctrl.newAddressForm.shippingPostCode.$touched || ctrl.newAddressForm.$submitted">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="col-md-6" style="padding: 2px;" ng-class="{'has-error':ctrl.newAddressForm.shippingCountry.$touched && ctrl.newAddressForm.shippingCountry.$invalid}">

                                        <label for="country"><g:message code="form.field.shipping.label" /> <g:message code="form.field.country.label" /></label>
                                        <select  id="country" name="shippingCountry" ng-model="ctrl.customerShippingCountry" class="form-control" required>
                                            <option selected disabled value="">Select Country</option>
                                            <option ng-repeat="country in countryList" value="{{country}}">{{country}}</option>
                                        </select>
                                        <div class="my-messages" ng-messages="ctrl.newAddressForm.shippingCountry.$error" ng-if="ctrl.newAddressForm.shippingCountry.$touched || ctrl.newAddressForm.$submitted">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>

                        </div>
                        <br style="clear:both;"/>
                    </div>

                    <div style="padding: 20px 0px;" ng-show="IsVisibleExistingShipment">

                        <form name="ctrl.addToPlannedShipment" ng-submit="ctrl.assignToPlannedShipment()" novalidate >
                            <div class="col-md-4">
                                Add to this Shipment:
                            </div>
                            <div class="col-md-5">
                                <select name="existingShipmentId" id="existingShipmentId" ng-model="ctrl.existingShipmentId" class="form-control">
                                    <option ng-repeat="option in ctrl.availablePlannedShipments" >{{option.shipment_id}}</option>
                                </select>

                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-primary" type="submit" ng-disabled="ctrl.existingShipmentId==null">Assign</button>
                            </div>
                        </form>

                        <br style="clear: both;"/>
                    </div>


                    <div style="padding: 20px 0px;" ng-show="!IsVisibleExistingShipment">

                        <form name="ctrl.addToNewShipment" ng-submit="ctrl.saveToNewShipment()" novalidate >

                            <div class="col-md-2">
                                Carrier Code:
                            </div>
                            <div class="col-md-4">
                                <select name="carrierCode" id="carrierCode" ng-model="ctrl.carrierCode" class="form-control" ng-change="ctrl.loadServiceForCarrier()">
                                    <option ng-repeat="option in ctrl.carrierCodeOptions" ng-value="option.optionValue" >{{option.description}}</option>
                                </select>
                            </div>

                            <div class="col-md-2">
                                Small Package?:
                            </div>
                            <div class="col-md-4">
                                <input type="checkbox" name="smallPackage" id="smallPackage" value=""
                                       ng-model="ctrl.smallPackage">
                            </div>

                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="col-md-2" ng-show="ctrl.smallPackage">
                                Service Level:
                            </div>
                            <div class="col-md-4" ng-show="ctrl.smallPackage">
                                <select name="serviceLevel" id="serviceLevel" ng-model="ctrl.serviceLevel"  class="form-control">
                                    <option ng-repeat="option in ctrl.serviceLevelOptions" >{{option}}</option>
                                </select>
                            </div>

                            <div class="col-md-2" ng-show="!ctrl.smallPackage">
                                Truck Number:
                            </div>
                            <div class="col-md-4" ng-show="!ctrl.smallPackage" ng-class="{'has-error':ctrl.hasErrorClassEdit('truckNumber')}">
                                <input type="text" name="truckNumber" id="truckNumber" class="form-control"
                                       ng-model="ctrl.truckNumber" ng-blur="ctrl.validateTruckNumber(ctrl.truckNumber)" placeholder="(Optional)" capitalize>
                                        
                                        <div class="my-messages"  ng-messages="ctrl.addToNewShipment.truckNumber.$error"
                                             ng-if="ctrl.truckValidationError">
                                            <div class="message-animation" >
                                                <strong>{{ctrl.truckValidationErrorMsg}}</strong>
                                            </div>
                                        </div>

                            </div>

                            <div class="col-md-2">
                                Tracking No./PRO No.:
                            </div>
                            <div class="col-md-4">
                                <input type="text" name="trackingNo" id="trackingNo" class="form-control"
                                       ng-model="ctrl.trackingNo" placeholder="(Optional)" ng-disabled="ctrl.disableTrackingNo" >
                            </div>
                            <br style="clear: both;"/>
                            <div class="col-md-2">
                                Notes :
                            </div>
                            <!-- <div class="col-md-4 form-group">
                                        <textarea rows="4" cols="6" class="form-control" ng-model="ctrl.shipmentNotes" placeholder="Enter Notes Here........." ></textarea>
                            </div> -->
                            <div class="col-md-4">
                            <div ng-init="ctrl.getPopoverTemplateUrl = 'notesPopover'"></div>
                            <a href="javascript:void(0)" uib-popover-template="ctrl.getPopoverTemplateUrl" popover-title=""  popover-append-to-body="true" popover-placement="top" popover-trigger="outsideClick">Enter here..</a> &emsp;

                                    <script type="text/ng-template" id="notesPopover">
                                        <div class="form-group">
                                          <label>Notes :</label>
                                          <textarea class='form-control' rows='5' id='notes' ng-model='ctrl.shipmentNotes' placeholder='Enter Note Here....' tabindex="8"></textarea>
                                        </div>
                                    </script>    
                            </div>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <button class="btn btn-primary pull-right" type="submit" >Plan to New Shipment</button>

                        </form>

                        <br style="clear: both;"/>
                    </div>




                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary pull-right" ng-click="showHideShipmentPlan()"
                                ng-show="IsPlannedShipmentAvailable">
                            {{ctrl.ToggleButtonText}}
                        </button>
                        <button type="button" class="btn btn-default pull-left" ng-click = "ctrl.closeShipmentModel()" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    </div>

                    <br style="clear: both;"/>

                </div>
            </div>
        </div>
    </div>

    <%-- **************************** End Plan to Shipment ************************************* --%>


    <%-- **************************** Edit Shipment ************************************* --%>

    <div id="editShipment" class="modal fade" role="dialog" >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" ng-click = "ctrl.closeShipmentModel()" data-dismiss="modal" aria-hidden="true">&times;</button> 
                    <h4 class="modal-title">Edit Shipment</h4>
                </div>
                <div class="modal-body">

                    <div style="padding: 20px 0px; font-size: 14px; font-weight: bold;">
                        <div class="col-md-3">
                            Order Number:
                        </div>
                        <div class="col-md-2">
                            {{ctrl.selectedOrderNumber}}
                        </div>
                        <div class="col-md-4">
                            Order Line Number:
                        </div>
                        <div class="col-md-3" ng-show="ctrl.assignShipmentOrderLineNumber">
                            {{ctrl.assignShipmentOrderLineNumber.toString()}}
                        </div>
                    </div>

                    <div style="padding: 20px 0px; clear:both;">

                        <form name="ctrl.editShipmentForm" ng-submit="ctrl.updateShipment()" novalidate >


                        <div style="padding: 5px 0px; font-size: 14px; font-weight: bold;">
                            <div class="col-md-3" >
                                Billing Contact:
                            </div>
                            <div class="col-md-3">
                                {{ctrl.customerData[0].contact_name}}
                            </div>
                            <div class="col-md-3" >
                                Company:
                            </div>
                            <div class="col-md-3">
                                {{ctrl.customerData[0].company_name}}
                            </div>
                            <br style="clear:both;"/>
                        </div>
                        <div style="padding: 5px 0px; font-size: 14px; font-weight: bold;">
                            <div class="col-md-3">
                                Shipping Contact:
                            </div>
                            <div class="col-md-9" ng-hide="ctrl.isEditCutomerName">
                                {{ctrl.cutomerNameFieldEdit}}&emsp;<a href="" ng-click="ctrl.editCutomerName()"><span class="glyphicon glyphicon-pencil"></span></a>
                            </div>
                            <div class="col-md-9" ng-show="ctrl.isEditCutomerName">
                                <input id="cutomerNameEdit" name="cutomerNameEdit" class="form-control" type="text" ng-model="ctrl.cutomerNameFieldEdit" ng-model-options="{ updateOn : 'default blur' }" style="width: 200px; display: inline-block;" />&emsp;
                                <a href="" ng-click=""><span class="glyphicon glyphicon-pencil"></span></a>
                            </div>
                            <br style="clear:both;"/>

                        </div>

                        <div class="col-md-3">
                           Shipping Address:
                        </div>
                        <div class="col-md-9" style="font-weight: normal;">
                            <div>
                                <div class="radio">
                                    <label><input type="radio" name="optChooseAddrs" ng-model="ctrl.optAddress" value="existingAddress">Choose Existing Address</label>
                                </div>

                                <select ng-if="ctrl.optAddress == 'existingAddress'" name="mySelect" id="mySelect" class="form-control" ng-options="option.shippingAddress for option in customerShippingAddressList track by option.id" ng-model="ctrl.shippingAddressFromOpt"></select>                                
                                <!-- <select   id="shippingAddress" name="shippingAddress" ng-model="ctrl.shippingAddressFromOpt"  >
                                    <option ng-repeat="address in customerShippingAddressList" >{{address.id}}</option>
                                </select> -->
                                <div class="radio">
                                    <label><input type="radio" name="optChooseAddrs" ng-model="ctrl.optAddress" value="newAddress">Enter New Address</label>
                                </div>
                                <div ng-if="ctrl.optAddress == 'newAddress'">
                                    <div class="col-md-6" style="padding: 2px 0px;" ng-class="{'has-error':ctrl.editShipmentForm.shippingStreetAddress.$touched && ctrl.editShipmentForm.shippingStreetAddress.$invalid}">
                                        <label for="streetAddress"><g:message code="form.field.shipping.label" /> <g:message code="form.field.street.label" /></label>
                                        <div class="controls">
                                            <textarea id="streetAddress" name="shippingStreetAddress" rows="4" class="form-control" ng-model="ctrl.customerShippingStreetAddress" ng-model-options="{ updateOn : 'default blur' }" placeholder="Street Address" required></textarea>

                                        </div>
                                        <div class="my-messages" ng-messages="ctrl.editShipmentForm.shippingStreetAddress.$error" ng-if="ctrl.editShipmentForm.shippingStreetAddress.$touched || ctrl.editShipmentForm.$submitted">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="col-md-6" style="padding: 2px;" ng-class="{'has-error':ctrl.editShipmentForm.shippingCity.$touched && ctrl.editShipmentForm.shippingCity.$invalid}">

                                        <label for="city"><g:message code="form.field.shipping.label" /> <g:message code="form.field.city.label" /></label>
                                        <div class="controls">
                                            <input id="city" name="shippingCity" class="form-control" type="text" ng-model="ctrl.customerShippingCity" ng-model-options="{ updateOn : 'default blur' }" placeholder="City/Town" required />
                                        </div>

                                    </div>
                                    <div class="col-md-6" style="padding: 2px;">

                                        <label for="state"><g:message code="form.field.shipping.label" /> <g:message code="form.field.state.label" /></label>
                                        <div class="controls">
                                            <input id="state" name="shippingState" class="form-control" type="text" ng-model="ctrl.customerShippingState" ng-model-options="{ updateOn : 'default blur' }" placeholder="State/Province" required />
                                        </div>
                                        <div class="my-messages" ng-messages="ctrl.editShipmentForm.shippingState.$error" ng-if="ctrl.editShipmentForm.shippingState.$touched || ctrl.editShipmentForm.$submitted">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6" style="padding: 2px;" ng-class="{'has-error':ctrl.editShipmentForm.shippingPostCode.$touched && ctrl.editShipmentForm.shippingPostCode.$invalid}">

                                        <label for="postCode"><g:message code="form.field.shipping.label" /> <g:message code="form.field.postCode.label" /></label>
                                        <div class="controls">
                                            <input id="postCode" name="shippingPostCode" class="form-control" type="text" ng-model="ctrl.customerShippingPostCode" ng-model-options="{ updateOn : 'default blur' }"  placeholder="ZIP/Post Code" required />
                                        </div>
                                        <div class="my-messages" ng-messages="ctrl.editShipmentForm.shippingPostCode.$error" ng-if="ctrl.editShipmentForm.shippingPostCode.$touched || ctrl.editShipmentForm.$submitted">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="col-md-6" style="padding: 2px;" ng-class="{'has-error':ctrl.editShipmentForm.shippingCountry.$touched && ctrl.editShipmentForm.shippingCountry.$invalid}">

                                        <label for="country"><g:message code="form.field.shipping.label" /> <g:message code="form.field.country.label" /></label>
                                        <select  id="country" name="shippingCountry" ng-model="ctrl.customerShippingCountry" class="form-control" required>
                                            <option selected disabled value="">Select Country</option>
                                            <option ng-repeat="country in countryList" value="{{country}}">{{country}}</option>
                                        </select>
                                        <div class="my-messages" ng-messages="ctrl.editShipmentForm.shippingCountry.$error" ng-if="ctrl.editShipmentForm.shippingCountry.$touched || ctrl.editShipmentForm.$submitted">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>

                        </div>
                        <br style="clear:both;"/>
                        <br style="clear:both;"/>

                            <div class="col-md-2">
                                Carrier Code:
                            </div>
                            <div class="col-md-4">
                                <select name="carrierCode" id="carrierCode" ng-model="ctrl.carrierCode" class="form-control">
                                    <option ng-repeat="option in ctrl.carrierCodeOptions" value="{{option.optionValue}}">{{option.description}}</option>
                                </select>
                            </div>

                            <div class="col-md-2">
                                Small Package?:
                            </div>
                            <div class="col-md-4">
                                <input type="checkbox" name="smallPackage" id="smallPackage" value=""
                                       ng-model="ctrl.smallPackage">
                            </div>

                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="col-md-2" ng-show="ctrl.smallPackage">
                                Service Level:
                            </div>
                            <div class="col-md-4" ng-show="ctrl.smallPackage">
                                <select name="serviceLevel" id="serviceLevel" ng-model="ctrl.serviceLevel" class="form-control">
                                    <option ng-repeat="option in ctrl.serviceLevelOptions" >{{option}}</option>
                                </select>
                            </div>

                            <div class="col-md-2" ng-show="!ctrl.smallPackage">
                                Truck Number:
                            </div>
                            <div class="col-md-4" ng-show="!ctrl.smallPackage">
                                <input type="text" name="truckNumber" id="truckNumber" class="form-control"
                                       ng-model="ctrl.truckNumber" ng-blur="ctrl.validateTruckNumber(ctrl.truckNumber)" placeholder="(Optional)" capitalize >

                                        <div class="my-messages"  ng-messages="ctrl.addToNewShipment.truckNumber.$error"
                                             ng-if="ctrl.truckValidationError">
                                            <div class="message-animation" >
                                                <strong>{{ctrl.truckValidationErrorMsg}}</strong>
                                            </div>
                                        </div>

                            </div>

                            <div class="col-md-2">
                                Tracking No./PRO No.:
                            </div>
                            <div class="col-md-4">
                                <input type="text" name="trackingNo" id="trackingNo" class="form-control"
                                       ng-model="ctrl.trackingNo" placeholder="(Optional)" >
                            </div>
                            <br style="clear: both;"/>
                            <div class="col-md-2">
                                Notes :
                            </div>
                            <!-- <div class="col-md-4 form-group">
                                        <textarea rows="4" cols="6" class="form-control" ng-model="ctrl.shipmentNotes" placeholder="Enter Notes Here........." ></textarea>
                            </div> --> 
                            <div class="col-md-4">
                            <div ng-init="ctrl.getPopoverTemplateUrlEdit = 'notesPopoverEdit'"></div>
                            <a href="javascript:void(0)" uib-popover-template="ctrl.getPopoverTemplateUrlEdit" popover-title=""  popover-append-to-body="true" popover-placement="top" popover-trigger="outsideClick">Enter here..</a> &emsp;

                                    <script type="text/ng-template" id="notesPopoverEdit">
                                        <div class="form-group">
                                          <label>Notes :</label>
                                          <textarea class='form-control' rows='5' id='notes' ng-model='ctrl.shipmentNotes' placeholder='Enter Note Here....' tabindex="8"></textarea>
                                        </div>
                                    </script>   
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>                        
                            </div>
                            <br style="clear: both;"/>
                    </div>




                    <div class="modal-footer">
                        <button class="btn btn-primary pull-right" type="submit" ><g:message code="default.button.update.label" /></button>
                        <button type="button" ng-click = "ctrl.closeShipmentModel()" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    </div>
                </form>
                </div>
            </div>
        </div>
    </div>

    <%-- **************************** Edit Shipment ************************************* --%>
    <%-- **************************** Edit Shipment ************************************* --%>

    <div id="selectedAllModel" class="modal fade" role="dialog" >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" ng-click = "" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">

                    <br style="clear: both;"/>
                </div>
                Order Line Id's = {{ctrl.selectedOrderLineList}}
                <div class="modal-footer">
                    <button class="btn btn-primary pull-right" type="submit" ><g:message code="default.button.update.label" /></button>
                    <button type="button" ng-click = "" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                </div>
            </div>
        </div>
    </div>

    <%-- **************************** Edit Shipment ************************************* --%>

    <!-- start allocate view popup -->

    <div id="allocationProcess" class="modal fade" role="dialog">
        <div class="modal-dialog"  style="width: 80%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4>Allocation</h4>
                    <br style="clear: both;"/>
                </div>

                <div class="modal-body">
                    <div class="alert alert-warning message-animation" role="alert" ng-if="ctrl.showAllocationErrorMessage">
                        {{ctrl.allocationErrorMessage}}
                    </div>

                    <form name="ctrl.allocationCreateFrom" ng-submit="ctrl.saveAllocation()" novalidate >

                        <div class="col-md-12">

                            <div class ="col-md-6" >
                                <div class="label-desc-order" style="text-align: left; width: 100px;">Shipment Id &nbsp; :</div>
                                <div class="label-content" style="text-align: left;"> {{ctrl.shipmentIdForEdit}}</div>
                            </div>

                            <div class ="col-md-6" >
                                <div class="label-desc-order" style="text-align: left; width: 130px;">Shipping Contact &nbsp; :</div>
                                <div class="label-content" style="text-align: left;"> {{ctrl.shippingContact}}</div>
                            </div>

                            <br style="clear:both;"/>
                        </div>
                        <div class="col-md-12">

                            <div class ="col-md-6" >
                                <div class="label-desc-order" style="text-align: left; width: 130px;">Billing Contact &nbsp; :</div>
                                <div class="label-content" style="text-align: left;"> {{ctrl.customerData[0].contact_name}}</div>
                            </div>


                            <div class="col-md-6">
                                <div class="label-desc-order" style="text-align: left; width: 90px;">Company &nbsp; :</div>
                                <div class="label-content" style="text-align: left;">
                                    {{ctrl.customerData[0].company_name}}
                                </div>
                            </div>

                            <br style="clear:both;"/>
                        </div>



                        <div class="col-md-12" style="margin-top: 5px;">
                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForAllocationCreate('locationId')}">
                                    <label for="locationId">Staging Location</label>
                                    <div auto-complete  source="loadLocationAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars = '0'
                                         value-changed="ctrl.callback(value.location_id)" style="z-index: 1000;">
                                        <input id="locationId" name="locationId" ng-model="ctrl.locationId"  ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Location Id" class="form-control"/>
                                    </div>

                                </div>

                            </div>

                            <div class="col-md-6">
                                <button style="margin-left: 20px; margin-top: 22px" class="btn btn-primary" type="submit" ng-disabled = "!ctrl.locationId" ng-hide="loadingAnimSaveAllocation">Begin Allocation</button>
                                <span ng-show="loadingAnimSaveAllocation"><img src="${request.contextPath}/foysonis2016/app/img/loading.gif"/></span>
                            </div>

                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="col-md-12">

                                <div ng-if="ctrl.allocationFailedMsg.length > 0">
                                    <h4>Errors from Previous Allocation Attempt:</h4>
                                    <ul>
                                        <li ng-repeat="allocationmsg in ctrl.allocationFailedMsg" value="{{allocationmsg.message}}">{{allocationmsg.message}}</li>
                                    </ul>
                                </div>

                                <br style="clear: both;"/>

                                <br style="clear: both;"/>

                                %{--<h5 ng-if="ctrl.selectedLocationLocationId != ctrl.locationId">{{ctrl.selectedLocationMessage}}</h5>--}%
                                %{--<div ng-if="ctrl.selectedLocationLocationId == ctrl.locationId &&  ctrl.selectedLocationShipment">--}%
                                    <div ng-if="ctrl.locationId">
                                <h4>Staging Location Shipments:</h4>
                                %{--<pre>{{ctrl.selectedLocationShipment}}</pre>--}%
                                    <!-- Start Inventory Grid-->
                                    <div id="grid1" ui-grid="gridShipmentAndCustomer" ui-grid-exporter ui-grid-pagination ui-grid-pinning ui-grid-resize-columns class="grid">
                                        <div class="noItemMessage" ng-if="gridShipmentAndCustomer.data.length == 0">This Staging Location is Free</div>
                                    </div>
                                    <!-- END OF Inventory Grid-->

                                </div>

                                %{--<div ng-if="ctrl.selectedLocationLocationId == ctrl.locationId &&  ctrl.selectedLocationInventory">--}%
                                %{--<div ng-if="ctrl.locationId">--}%
                                %{--<h4>Staging Location Inventory </h4>--}%
                                    %{--<pre>{{ctrl.selectedLocationInventory}}</pre>--}%

                                    %{--<!-- Start Inventory Grid-->--}%
                                %{--<div id="grid1" ui-grid="gridInventory" ui-grid-exporter ui-grid-selection ui-grid-pagination ui-grid-pinning ui-grid-expandable class="inventoryGrid">--}%
                                    %{--<div class="noItemMessage" ng-if="gridInventory.data.length == 0"><g:message code="inventory.grid.noData.message" /></div>--}%
                                %{--</div>--}%
                                %{--<!-- END OF Inventory Grid-->--}%

                                %{--</div>--}%

                            </div>

                        </div>

                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- end allocate view popup -->


    <!-- start allocateFailedMessage view popup -->

    <div id="allocationMessage" class="modal fade" role="dialog">
        <div class="modal-dialog"  style="width: 60%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4>Errors from Previous Allocation Attempt</h4>
                    <br style="clear: both;"/>
                </div>

                <div class="modal-body">
                            <div class="col-md-12">
                                    <ul>
                                        <li ng-repeat="allocationmsg in ctrl.allocationFailedMsg" value="{{allocationmsg.message}}">{{allocationmsg.message}}<br style="clear: both;"/><br style="clear: both;"/></li>
                                    </ul>
                            </div>

                        <br style="clear: both;"/>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.close.label" /></button>
                </div>
            </div>
        </div>
    </div>

    <!-- end allocateFailedMessage view popup -->


    <div id="viewOrderReportModel" class="modal fade" role="dialog">
        <div class="modal-dialog" style="width:80%">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div class="modal-body">
                    <div>
                        <embed id="pdfReport" style="height:450px; width: 100%;" type="application/pdf" ng-src="{{ctrl.orderReportSrcStrg}}"/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click="printReport(ctrl.orderReportSrcStrg)">Print</button>
                    <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click="ctrl.openMailAddrModal()">Email</button>
                </div>
            </div>
        </div>
    </div>
    <g:render template="/report/sendReportMailTemp" />

</div><!-- End Of ctrl -->

<!-- bootstrap modal confirmation dialog-->

<div id="OrderLineDelete" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <g:message code="orders.orderLineDelete.message" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "orderLineDeleteButton" class="btn btn-primary"><em class="fa fa-trash-o fa-fw mr-sm"></em><g:message code="default.button.delete.label" /></button>
            </div>
        </div>
    </div>
</div>

<div id="OrderLineDeleteWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <g:message code="orders.deleteWarning.message" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>

<div id="OrderLineEditWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <g:message code="orders.editWarning.message" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>

<div id="addNewOrderWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <g:message code="orders.addNewOrderLineWarning.message" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="editOrderWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <g:message code="orders.editOrderWarning.message" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="deleteOrder" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <g:message code="orders.orderDelete.message" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "orderDeleteButton" class="btn btn-primary"><em class="fa fa-trash-o fa-fw mr-sm"></em><g:message code="default.button.delete.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="deleteOrderWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <g:message code="orders.orderDeleteWarning.message" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="ClosedOrderEditWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <g:message code="orders.orderDeleteWarning.message" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="shipmentLineDeleteWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <g:message code="shipmentLine.cancelWarning.message" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>

<div id="shipmentLineDelete" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <g:message code="shipmentLine.cancel.message" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "shipmentLineDeleteButton" class="btn btn-primary"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="shipmentCancel" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <g:message code="shipment.cancel.message" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "shipmentCancelButton" class="btn btn-primary"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="shipmentPlanWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <!-- <g:message code="shipment.cancel.message" /> -->The shipment cannot be planned due to the customer of this order is in hold
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="shipmentPlanWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <!-- <g:message code="shipment.cancel.message" /> -->The shipment cannot be allocated due to the customer of this order is in hold
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="createNewOrderLineWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <!-- <g:message code="shipment.cancel.message" /> -->Order line cannot be created due to the customer of this order is in hold
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="cancelAllocation" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                Are you sure you want to cancel the allocation?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "cancelAllocationButton" class="btn btn-primary"><em class="fa fa-trash-o fa-fw mr-sm"></em><g:message code="default.button.delete.label" /></button>
            </div>
        </div>
    </div>
</div>


<asset:javascript src="datagrid/order.js"/>

%{--<asset:javascript src="signup/angular.min.js"/>--}%
<asset:javascript src="signup/angular-aria.min.js"/>
<asset:javascript src="signup/angular-messages.min.js"/>
<asset:javascript src="signup/angular-animate.min.js"/>

%{--<asset:javascript src="datagrid/angular.js"/>--}%
<asset:javascript src="datagrid/angular-touch.js"/>
<asset:javascript src="datagrid/angular-animate.js"/>
<asset:javascript src="datagrid/csv.js"/>
<asset:javascript src="datagrid/pdfmake.js"/>
%{--<asset:javascript src="datagrid/vfs_fonts.js"/>--}%
<asset:javascript src="datagrid/ui-grid.js"/>
%{--<link rel="stylesheet" href="http://ui-grid.info/release/ui-grid.css" type="text/css">--}%
%{--<asset:stylesheet src="datagrid/ui-grid.css"/>--}%


<script type="text/javascript">
    var dvOrder = document.getElementById('dvOrder');
    angular.element(document).ready(function() {
        angular.bootstrap(dvOrder, ['order']);
    });
</script>

%{--<asset:javascript src="autocomplete/angular-auto.js"/>--}%
<asset:javascript src="autocomplete/angular-sanitize.js"/>
<asset:javascript src="autocomplete/auto-complete.js"/>
<asset:javascript src="autocomplete/auto-complete-multi.js"/>
<asset:javascript src="inventory/order-auto-complete-div.js"/>
<asset:javascript src="autocomplete/auto-complete-textbox.js"/>

</body>
</html>
