<%--
  Created by IntelliJ IDEA.
  User: home
  Date: 9/26/15
  Time: 12:41
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="foysonis2016"/>

    <asset:javascript src="signup/angular-aria.min.js"/>
    <asset:javascript src="signup/angular-messages.min.js"/>
    <asset:javascript src="signup/angular-animate.min.js"/>

    <asset:javascript src="datagrid/angular-touch.js"/>
    <asset:javascript src="datagrid/angular-animate.js"/>
    <asset:javascript src="datagrid/csv.js"/>
    <asset:javascript src="datagrid/pdfmake.js"/>
    <asset:javascript src="datagrid/vfs_fonts.js"/>
    <asset:javascript src="datagrid/ui-grid.js"/>

    <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>


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
        height:420px;
        width: 100%;
    }

    .csvGrid {
        height:380px;
        width: 1300px;
    }

    .grid-align {
        text-align: center;
    }

    .grid-action-align {
        padding-left: 60px;
    }

    .dropdown-menu {
        min-width: 90px;
    }

    .noLocationMessage {
        position: absolute;
        top : 30%;
        opacity: 0.4;
        font-size: 40px;
        width: 100%;
        text-align: center;
        z-index: auto;
    }

    .gridCheckbox {
        position: relative;
        display: block;
        margin-top: 5px;
        margin-bottom: 10px;
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

    .label-desc-order {
        text-align: left;
        width: 50%;
    }   

    .label-content {
       width: 50%; 
    } 

    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    </style>

    <%-- **************************** End of CSS **************************** --%>

</head>

<body>

<div ng-cloak class="row" id="dvAdminKittingOrder" ng-controller="kittingOrderCtrl as ctrl">
    <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 40px;" src="/foysonis2016/app/img/kitting_header.svg"></em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">Kitting Order</span></div>


    <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation"  href="javascript:void(0);">
        <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ctrl.showCreateKittingOrderForm()" >
            <em class="fa fa-plus-circle fa-fw mr-sm"></em>
            <g:message code="default.button.createKittingOrder.label" />
        </button>
    </a>

    <br style="clear: both;">
    <br style="clear: both;">

    <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showKOSubmittedPrompt">
        <g:message code="kittingOrder.create.success.message" />
    </div>

    <!-- <div class="alert alert-warning message-animation" role="alert" ng-if="ctrl.showBOMDuplicatedItemIdPrompt">
        <g:message code="bom.create.duplicatedItem.message" />
    </div> -->

    <!-- <div class="alert alert-warning message-animation" role="alert" ng-if="ctrl.showBOMDuplicatedEditItemIdPrompt">
        <g:message code="bom.create.duplicatedEditItem.message" />
    </div> -->

    <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showKOUpdatedPrompt">
        <g:message code="kittingOrder.edit.success.message" />
    </div>

    <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showKODeletedPrompt">
        <g:message code="kittingOrder.delete.success.message" />
    </div>

    <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showBOMCopyPrompt">
        <g:message code="kittingOrder.copyBOM.success.message" />
    </div>

    %{--Start Add New BOM--}%
    <div class="panel panel-default" ng-show="IsVisibleNewKittingOrderWindow">

        <div class="panel-heading">
            <div class="panel-title">Create New Kitting Order</div>
        </div>        
        <div class="panel-body">
            <form name="ctrl.createKittingOrderForm" ng-submit="ctrl.createKittingOrder()" novalidate >

            <div class="col-md-6">
                
                <div class="form-group" ng-class="{'has-error':ctrl.hasKOErrorClass('kittingOrderNumber')}">
                    <label for="kittingOrderNumber"><g:message code="form.field.KittingOrd.kittingOrderNumber.label" /></label>
                    <input id="kittingOrderNumber" name="kittingOrderNumber" class="form-control" type="text" maxlength="50" capitalize
                           ng-model="ctrl.newKittingOrder.kittingOrderNumber" ng-blur="ctrl.validateKittingOrderNum(ctrl.newKittingOrder.kittingOrderNumber)" tabindex="1" required />


                    <div class="my-messages"  ng-messages="ctrl.createKittingOrderForm.kittingOrderNumber.$error"
                         ng-if="ctrl.createKittingOrderForm.$error.kittingOrderNumberExists">
                        <div class="message-animation" >
                            <strong>Kitting order number exists already.</strong>
                        </div>
                    </div>

                    <div class="my-messages" ng-messages="ctrl.createKittingOrderForm.kittingOrderNumber.$error" ng-if="ctrl.showKOMessages('kittingOrderNumber')">
                        <div class="message-animation" ng-message="required">
                            <strong><g:message code="required.error.message" /></strong>
                        </div>
                    </div>

                </div>

                <div class="form-group" ng-class="{'has-error':ctrl.hasKOErrorClass('defaultProductionQuantity')}">
                    <label for="defaultProductionQuantity"><g:message code="form.field.KittingOrd.productionQuantity.label" /></label>
                    <input id="defaultProductionQuantity" name="defaultProductionQuantity" class="form-control" type="number"
                           ng-model="ctrl.newKittingOrder.productionQuantity" ng-model-options="{ updateOn : 'default blur' }"
                           min="1" required />

                    <div class="my-messages"  ng-messages="ctrl.createKittingOrderForm.defaultProductionQuantity.$error"
                         ng-if="ctrl.createKittingOrderForm.defaultProductionQuantity.$error.min">
                        <div class="message-animation" >
                            <strong>The value should be greater than 0 (zero).</strong>
                        </div>
                    </div>

                    <div class="my-messages" ng-messages="ctrl.createKittingOrderForm.defaultProductionQuantity.$error" ng-if="ctrl.showKOMessages('defaultProductionQuantity')">
                        <div class="message-animation" ng-message="required">
                            <strong><g:message code="required.error.message" /></strong>
                        </div>
                    </div>

                </div>
                <!-- <div class="form-group" ng-class="{'has-error':ctrl.hasKOErrorClass('orderInfo')}">
                    <label for="orderInfo"><g:message code="form.field.KittingOrd.orderInfo.label" /></label>
                    <input id="orderInfo" name="orderInfo" class="form-control" type="text"
                           ng-model="ctrl.newKittingOrder.orderInfo" ng-model-options="{ updateOn : 'default blur' }" />
                </div> -->
                <div class="form-group" ng-class="{'has-error':ctrl.hasKOErrorClass('productionUom')}" >
                    <label for="productionUom" ><g:message code="form.field.productionUom.label" /></label>
                    <select name="productionUom" id="productionUom" ng-model="ctrl.newKittingOrder.productionUom" class="form-control" ng-change="ctrl.selectCase()" ng-disabled="ctrl.disableProductionUom" tabindex="6" required>
                        <option ng-repeat="option in data.availableOptions" ng-value="option.id">{{option.name}}</option>
                    </select>
                    <div class="my-messages" ng-messages="ctrl.createKittingOrderForm.productionUom.$error" ng-if="ctrl.showKOMessages('productionUom')">
                        <div class="message-animation" ng-message="required">
                            <strong><g:message code="required.error.message" /></strong>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6">

                <div class="form-group" ng-class="{'has-error':ctrl.hasKOErrorClass('itemId')}">
                    <label><g:message code="form.field.kittedItem.label" /></label>
                    <div auto-complete  source="sourceItems" xxxx-list-formatter="customListFormatter"
                         value-changed="ctrl.validateItemId(value.locationId);ctrl.checkAndCopyBOMDataToKitting(value.locationId)" style="z-index: 1000000000;">
                        <input ng-model="ctrl.newKittingOrder.kittingItemId" id="itemId" name='itemId' ng-model-options="{ updateOn : 'default blur' }" placeholder="Item Id" class="form-control" tabindex="1" required />
                    </div>

                    <div class="my-messages" ng-messages="ctrl.createKittingOrderForm.itemId.$error" ng-if="ctrl.showKOMessages('itemId')">
                        <div class="message-animation" ng-message="required">
                            <strong>Please Select an Item.</strong>
                        </div>
                    </div>

                </div>

                <div class="form-group" ng-class="{'has-error':ctrl.hasKOErrorClass('finishedProductDefaultStatus')}" >
                    <label for="finishedProductDefaultStatus"><g:message code="form.field.finishedProductDefaultStatus.label" /></label>
                    <select  id="finishedProductDefaultStatus" name="finishedProductDefaultStatus" ng-model="ctrl.newKittingOrder.finishedProductInventoryStatus" class="form-control" tabindex="2" required>
                        <option ng-repeat="option in ctrl.inventoryStatusOptions" value="{{option.optionValue}}">{{option.description}}</option>
                    </select>

                    <div class="my-messages" ng-messages="ctrl.createKittingOrderForm.finishedProductDefaultStatus.$error" ng-if="ctrl.showKOMessages('finishedProductDefaultStatus')">
                        <div class="message-animation" ng-message="required">
                            <strong><g:message code="required.error.message" /></strong>
                        </div>
                    </div>
                </div>                

            </div>

                <br style="clear: both;"/>

                <div class="panel-footer">
                    <div class="pull-left">
                        <button  type="button" class="btn btn-default" ng-click="ctrl.cancelCreateKittingOrder()"><g:message code="default.button.cancel.label" /></button>
                    </div>
                    <div class="pull-right">
                        <button class="btn btn-primary" type="submit" ng-disabled="ctrl.createKOBtnDisable"><g:message code="default.button.save.label" /></button>
                    </div>
                    <br style="clear: both;"/>
                </div>

            </form>
        </div>
    </div>
    %{--End Add New BOM--}%


    %{--Start Edit BOM--}%
    <div id="editKittingOrderPanel" class="panel panel-default" ng-show="ctrl.isShowEditKittingOrderForm">
        <div class="panel-heading">
            <div class="panel-title">Edit Ktting Order</div>
        </div> 
        <div class="panel-body">
            <form name="ctrl.editKittingOrderForm" ng-submit="ctrl.updateKittingOrder()" novalidate >

            <div class="col-md-6">

                <div class="form-group">
                    <label for="kittingOrderNumber"><g:message code="form.field.KittingOrd.kittingOrderNumber.label" /></label>
                    <input id="kittingOrderNumber" name="kittingOrderNumber" class="form-control" type="text" capitalize
                           ng-model="ctrl.selectedKittingOrder.kitting_order_number" required disabled/>
                </div>

                <div class="form-group" ng-class="{'has-error':ctrl.editKittingOrderForm.defaultProductionQuantity.$touched && ctrl.editKittingOrderForm.defaultProductionQuantity.$invalid}">
                    <label for="defaultProductionQuantity"><g:message code="form.field.defaultProductionQuantity.label" /></label>
                    <input id="defaultProductionQuantity" name="defaultProductionQuantity" class="form-control" type="number"
                           ng-model="ctrl.selectedKittingOrder.production_quantity" ng-model-options="{ updateOn : 'default blur' }"
                           min="0" />

                    <div class="my-messages"  ng-messages="ctrl.editKittingOrderForm.defaultProductionQuantity.$error"
                         ng-if="ctrl.editKittingOrderForm.defaultProductionQuantity.$error.min">
                        <div class="message-animation" >
                            <strong>The value should be greater than 0 (zero).</strong>
                        </div>
                    </div>

                </div>

                <div class="form-group" ng-class="{'has-error':ctrl.editKittingOrderForm.productionUom.$touched && ctrl.editKittingOrderForm.productionUom.$invalid}" >
                    <label for="productionUom" ><g:message code="form.field.productionUom.label" /></label>
                    <select name="productionUom" id="productionUom" ng-model="ctrl.selectedKittingOrder.production_uom" class="form-control" ng-change="ctrl.selectCase()" ng-disabled="ctrl.disableProductionUom" tabindex="6" required>
                        <option ng-repeat="option in data.availableOptions" ng-value="option.id">{{option.name}}</option>
                    </select>
                    <div class="my-messages" ng-messages="ctrl.editKittingOrderForm.productionUom.$error" ng-if="ctrl.editKittingOrderForm.productionUom.$touched || ctrl.editKittingOrderForm.$submitted">
                        <div class="message-animation" ng-message="required">
                            <strong><g:message code="required.error.message" /></strong>
                        </div>
                    </div>
                </div>
                <!-- <div class="form-group" ng-class="{'has-error':ctrl.hasKOErrorClass('orderInfo')}">
                    <label for="orderInfo"><g:message code="form.field.KittingOrd.orderInfo.label" /></label>
                    <input id="orderInfo" name="orderInfo" class="form-control" type="text"
                           ng-model="ctrl.selectedKittingOrder.order_info" ng-model-options="{ updateOn : 'default blur' }" />
                </div> -->


            </div>
            <div class="col-md-6">

                <div class="form-group" ng-class="{'has-error':ctrl.editKittingOrderForm.itemId.$touched && ctrl.editKittingOrderForm.itemId.$invalid}">
                    <label><g:message code="form.field.kittedItem.label" /></label>
                    <div auto-complete  source="sourceItems" xxxx-list-formatter="customListFormatter"
                         value-changed="ctrl.validateItemIdEdit(value.locationId)" style="z-index: 1000000000;">
                        <input ng-model="ctrl.selectedKittingOrder.kitting_item_id" id="itemId" name='itemId' ng-model-options="{ updateOn : 'default blur' }" placeholder="Item Id" class="form-control" tabindex="1" required />
                    </div>

                    <div class="my-messages" ng-messages="ctrl.editKittingOrderForm.itemId.$error" ng-if="ctrl.editKittingOrderForm.itemId.$touched || ctrl.editKittingOrderForm.$submitted">
                        <div class="message-animation" ng-message="required">
                            <strong>Please Select an Item.</strong>
                        </div>
                    </div>

                </div>


                <div class="form-group" ng-class="{'has-error':ctrl.editKittingOrderForm.finishedProductDefaultStatus.$touched && ctrl.editKittingOrderForm.finishedProductDefaultStatus.$invalid}" >
                    <label for="finishedProductDefaultStatus"><g:message code="form.field.finishedProductDefaultStatus.label" /></label>
                    <select  id="finishedProductDefaultStatus" name="finishedProductDefaultStatus" ng-model="ctrl.selectedKittingOrder.finished_product_inventory_status" class="form-control" tabindex="2" required>
                        <option ng-repeat="option in ctrl.inventoryStatusOptions" value="{{option.optionValue}}">{{option.description}}</option>
                    </select>

                    <div class="my-messages" ng-messages="ctrl.editKittingOrderForm.finishedProductDefaultStatus.$error" ng-if="ctrl.editKittingOrderForm.finishedProductDefaultStatus.$touched || ctrl.editKittingOrderForm.$submitted">
                        <div class="message-animation" ng-message="required">
                            <strong><g:message code="required.error.message" /></strong>
                        </div>
                    </div>
                </div>                                
            </div>
                <br style="clear: both;"/>


                <div class="panel-footer">
                    <div class="pull-left">
                        <button class="btn btn-default" type="button" ng-click="ctrl.cancelEditKittingOrder()"><g:message code="default.button.cancel.label" /></button>
                    </div>
                    <div class="pull-right">
                        <button class="btn btn-primary" type="submit"><g:message code="default.button.update.label" /></button>
                    </div>
                    <br style="clear: both;"/>
                </div>


            </form>
        </div>
    </div>
    %{--End Edit BOM--}%

    <!-- START search panel-->
    <div class="panel panel-default">
        <div class="panel-heading">
            <a href="javascript:void(0);" ng-click = "ctrl.showHideSearch()">
                <legend><em ng-if = "ctrl.isBOMSearchVisible" class="fa fa-minus-circle fa-fw mr-sm"></em>
                    <em ng-if = "!ctrl.isBOMSearchVisible" class="fa fa-plus-circle fa-fw mr-sm"></em>
                    <g:message code="default.search.label" />
                </legend></a>
        </div>

        <div class="panel-body" ng-show= "ctrl.isBOMSearchVisible">
            <form name="ctrl.bOMSearchForm"  ng-submit="ctrl.kittingOrderSearch()">
                <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                    <!-- START Wizard Step inputs -->
                    <div>
                        <fieldset>
                            <!-- START row -->
                            <div class="row">

                                <div class="col-md-5">
                                    <div class="form-group">
                                        <label><g:message code="form.field.kittedItem.label" /></label>
                                        <div class="controls">
                                            <input type="text" name="itemIdSearch" placeholder="Kitted Item Id or Description" class="form-control"
                                                   ng-blur="" ng-model="ctrl.searchKittingOrder.itemId" >
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-5">
                                    <label><g:message code="form.field.KittingOrd.kittingOrderNumber.label" /></label>
                                    <input type="text" name="kittingOrderNumberSearch" placeholder="Kitting Order Number" class="form-control"
                                           ng-blur="" ng-model="ctrl.searchKittingOrder.kittingOrderNumber" >
                                </div>
                                <br style="clear: both;"/>
                                <div class="col-md-5">
                                    <label><g:message code="form.field.KittingOrd.kittingOrderStatus.label" /></label>
                                    <select  name="kittingOrderStatus" ng-model="ctrl.searchKittingOrder.kittingOrderStatus" class="form-control">
                                        <option selected value></option>
                                        <option>OPEN</option>
                                        <option>ALLOCATED</option>
                                        <option>COMPONENT READY</option>
                                        <option>PROCESSING</option>
                                        <option>COMPLETED</option>
                                        <option>CLOSED</option>
                                    </select>
                                </div>
                                <div class="col-md-5">
                                    <label><g:message code="form.field.KittingOrd.orderNumber.label" /></label>
                                    <input type="text" name="orderNumberSearch" placeholder="Order Number" class="form-control"
                                           ng-blur="" ng-model="ctrl.searchKittingOrder.orderNumber" >
                                </div>
                            </div>

                        </fieldset>

                        <div class="pull-right">
                            <button class="btn btn-primary findBtn" type="submit">
                                <g:message code="default.button.searchKittingOrder.label" />
                            </button>
                        </div>
                        <br style="clear:both;"/> 
                    </div>
                    <!-- END Wizard Step inputs -->
                </div>
            </form>
        </div>
    </div>
    <!-- END search panel -->
    <br style="clear:both;"/>

    <div class="col-lg-3 panel-body table-responsive table-bordered" style="background-color: #fff;" ng-if = "ctrl.kittingOrderList.length == 0">
        <table class="table table-bordered">
            <tbody>
                <tr>
                    <td>
                        <div class="media">
                            <div class="media-body">
                                <h5 class="media-heading" >No Kitting Orders Found.</h5>
                            </div>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="col-lg-3 panel-body table-responsive table-bordered" style="background-color: #fff;" ng-if = "ctrl.kittingOrderList.length > 0">
        <table class="table table-bordered">
            <tbody>
                <tr ng-repeat="kittingOrder in ctrl.kittingOrderList" ng-if = "ctrl.kittingOrderList.length > 0">
                    <td ng-class="{ 'selected-class-name': kittingOrder.kitting_order_number == ctrl.selectedItemId }">
                        <div class="media">
                            <div class="media-body">


                                <%-- ****************** Selecting Area Tab ****************** --%>

                                <a href = ''  ng-click="ctrl.getClickedKittingOrder($index)">
                                    <h5 class="media-heading" >{{ kittingOrder.kitting_order_number }}</h5></a>

                                <%-- ****************** End of selecting Area Tab ****************** --%>

                            </div>
                        </div>
                    </td>
                    <tr>
                    <td ng-hide="ctrl.totalNumOfPages==null || ctrl.totalNumOfPages == 1">
                        <div class="pull-left">
                            <button class="btn btn-default" type="button" ng-click="ctrl.kittingSearchForNextPrev('prev')" ng-disabled="ctrl.orderSearchPageNum==1">Prev</button>
                            <span style="font-style: italic;">&emsp;&emsp;&emsp;{{ctrl.orderSearchPageNum}} of {{ctrl.totalNumOfPages}}</span>
                        </div>                    
                        <div class="pull-right">
                            <button class="btn btn-default" type="button" ng-click="ctrl.kittingSearchForNextPrev('next')" ng-disabled="ctrl.orderSearchPageNum==ctrl.totalNumOfPages">Next</button>
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
                <ul class="nav nav-tabs" ng-if="ctrl.kittingOrderList.length > 0">                      
                    <li id="liComponents" class="active"><a href="#components" data-toggle="tab"><g:message code="default.component.tab.label" /></a></li>
                    <li id="liInstructions"><a href="#instructions" data-toggle="tab"><g:message code="default.instructions.tab.label" /></a></li>
                <li id="liComponentInventory"><a href="#componentInventory" data-toggle="tab"><g:message code="default.componentInventory.label" /></a></li>
                    <li id="liKittingInventory"><a href="#kittingInventory" data-toggle="tab"><g:message code="default.productionInventory.label" /></a></li>
                </ul>
                <ul class="nav nav-tabs" ng-if="ctrl.kittingOrderList.length == 0">                      
                    <li id="liComponents" class="disabled"><a href="" data-toggle="tab"><g:message code="default.component.tab.label" /></a></li>
                    <li id="liInstructions" class="disabled"><a href="" data-toggle="tab"><g:message code="default.instructions.tab.label" /></a></li>
                    <li id="liComponentInventory" class="disabled"><a href="" data-toggle="tab"><g:message code="default.componentInventory.label" /></a></li>
                    <li id="liKittingInventory" class="disabled"><a href="" data-toggle="tab"><g:message code="default.productionInventory.label" /></a></li>
                </ul>                
                <!-- Tab panes -->
                <div class="tab-content">

                    <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showAllocationSuccessMessage">
                        {{ctrl.allocationSuccessMessage}}
                    </div>

                    <div id="components" class="tab-pane fade in active">

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showComponentSubmittedPrompt">
                            <g:message code="component.create.message" />
                        </div>

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showComponentUpdatedPrompt">
                            <g:message code="component.edit.message" />
                        </div>
                        
                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showComponentDeletedPrompt">
                            <g:message code="component.delete.message" />
                        </div>
                        <br style="clear: both;">  
                                             
                        <div ng-hide="ctrl.kittingOrderList.length == 0" style="float: left;">
                            <div class="form-group">
                                <div><h4><g:message code="form.field.KittingOrd.kittingOrderNumber.label" />&emsp;:&emsp;{{ctrl.selectedItemId}}</h4></div>
                            </div>
                        </div>

                        <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">


                            <button ng-hide="ctrl.kittingOrderList.length == 0" type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ctrl.showComponentsCreateForm()">
                                <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                <g:message code="default.button.createComponent.label" />
                            </button>
                        </a>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                        %{--Start Display A BOM Details--}%

                        <div ng-show="ctrl.isShowBOMDetails" ng-hide="ctrl.kittingOrderList.length == 0" class="col-lg-12">
                            <div class="col-lg-6">
                                <div>
                                    <div class="label-desc-order"><g:message code="form.field.kittedItem.label" /></div>
                                    <div class="label-content">: {{ctrl.selectedKittingOrder.kitting_item_id}}</div>
                                    <br style="clear: both;">
                                </div> 
                                
                                <div>
                                    <div class="label-desc-order"><g:message code="form.field.itemDescription.label" /></div>
                                    <div class="label-content">: {{ctrl.selectedKittingOrder.itemDescription}}</div>
                                    <br style="clear: both;">
                                </div>                              

                                <div>
                                    <div class="label-desc-order"><g:message code="form.field.finishedProductDefaultStatus.label" /></div>
                                    <div class="label-content">: {{ctrl.selectedKittingOrder.finishedProductInventoryStatusDesc}}</div>
                                    <br style="clear: both;"> 
                                </div>    
                                
                                <div>
                                    <div class="label-desc-order"><g:message code="form.field.productionUom.label" /></div>
                                    <div class="label-content">: {{ctrl.selectedKittingOrder.production_uom}}</div>
                                    <br style="clear: both;">
                                </div>
                                                                     
                            </div>
                            
                            <div class="col-lg-6">
                                <div>
                                    <div class="label-desc-order"><g:message code="form.field.defaultProductionQuantity.label" /></div>
                                    <div class="label-content">: {{ctrl.selectedKittingOrder.production_quantity}}</div>
                                    <br style="clear: both;"> 
                                </div>

                                <div>
                                    <div class="label-desc-order">Kitting Order Type</div>
                                    <div class="label-content">: {{ctrl.selectedKittingOrder.kitting_order_type}}</div>
                                    <br style="clear: both;">
                                </div>

                                <div ng-if="ctrl.selectedKittingOrder.kitting_order_type == 'TRIGGERED'">
                                    <div class="label-desc-order">Order Number</div>
                                    <div class="label-content">: {{ctrl.selectedKittingOrder.salesOrderNumber}}</div>
                                    <br style="clear: both;">
                                </div>
                                <div>
                                    <div class="label-desc-order">Kitting Order Status</div>
                                    <div class="label-content">: {{ctrl.selectedKittingOrder.kitting_order_status}}</div>
                                    <br style="clear: both;"> 
                                </div>  
                            </div>                           
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>
                            <div class="col-md-6" style="float: right;">
                                <div class="col-md-3" style="width: 130px;float: right;" >
                                <button type="button" class="btn btn-primary editOrdBtn" ng-click="ctrl.showEditKittingOrderForm()" >
                                    <em class="fa fa-edit fa-fw mr-sm"></em>Edit
                                </button>
                                </div>
                                <div class="col-md-3" style="width: 150px;float: right;">
                                <button type="button" class="btn btn-default delOrdBtn" ng-click="ctrl.deleteKittingOrder()" >
                                    <em class="fa fa-trash-o fa-fw mr-sm"></em><g:message code="default.button.delete.label" />
                                </button>
                                </div>
                            </div>
                        </div>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                        %{--End Display A BOM Details--}%

                        <div ng-show = "isVisibleNewComponentWindow" class="row">

                            <form name="ctrl.createComponentForm" ng-submit="ctrl.createComponent()" novalidate >

                                <div class="panel panel-default" id="panel-anim-fadeInDown">
                                    <div class="panel-heading">
                                        <!-- <div class="panel-title" ng-if="ctrl.newLocation.hiddenlocationId"><g:message code="default.location.edit.label" /></div> -->
                                        <div class="panel-title">Add New Component</div>
                                    </div>

                                    <div class="panel-body">
                                        <div class="col-md-6">
                                            <div class="form-group" ng-class="{'has-error':ctrl.createComponentForm.itemId.$touched && ctrl.createComponentForm.itemId.$invalid}">
                                                <label><g:message code="form.field.componentItem.label" /></label>
                                                <div auto-complete  source="sourceItems" xxxx-list-formatter="customListFormatter"
                                                     value-changed="ctrl.validateItemIdComponent(value.locationId)" style="z-index: 1000000000;">
                                                    <input ng-model="ctrl.newComponent.componentItemId" id="itemId" name='itemId' ng-model-options="{ updateOn : 'default blur' }" placeholder="Item Id" class="form-control" tabindex="1" required />
                                                </div>

                                                <div class="my-messages" ng-messages="ctrl.createComponentForm.itemId.$error" ng-if="ctrl.createComponentForm.itemId.$touched || ctrl.createComponentForm.$submitted">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong>Please Select an Item.</strong>
                                                    </div>
                                                </div>

                                            </div>

                                            <div class="form-group" ng-class="{'has-error':ctrl.createComponentForm.componentQuantity.$touched && ctrl.createComponentForm.componentQuantity.$invalid}">
                                                <label for="componentQuantity"><g:message code="form.field.componentQuantity.label" /></label>
                                                <input id="componentQuantity" name="componentQuantity" class="form-control" type="number"
                                                       ng-model="ctrl.newComponent.componentQuantity" ng-model-options="{ updateOn : 'default blur' }"
                                                       min="1" required />

                                                <div class="my-messages"  ng-messages="ctrl.createComponentForm.componentQuantity.$error"
                                                     ng-if="ctrl.createComponentForm.componentQuantity.$error.min">
                                                    <div class="message-animation" >
                                                        <strong>The value should be greater than 0 (zero).</strong>
                                                    </div>
                                                </div>

                                                <div class="my-messages" ng-messages="ctrl.createComponentForm.componentQuantity.$error" ng-if="ctrl.createComponentForm.componentQuantity.$touched || ctrl.createComponentForm.$submitted">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                            </div>

                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group" ng-class="{'has-error':ctrl.createComponentForm.componentInventoryStatus.$touched && ctrl.createComponentForm.componentInventoryStatus.$invalid}" >
                                                <label for="componentInventoryStatus"><g:message code="form.field.componentInventoryStatus.label" /></label>
                                                <select  id="componentInventoryStatus" name="componentInventoryStatus" ng-model="ctrl.newComponent.componentInventoryStatus" class="form-control" tabindex="2" required>
                                                    <option ng-repeat="option in ctrl.inventoryStatusOptions" value="{{option.optionValue}}">{{option.description}}</option>
                                                </select>

                                                <div class="my-messages" ng-messages="ctrl.createComponentForm.componentInventoryStatus.$error" ng-if="ctrl.createComponentForm.componentInventoryStatus.$touched || ctrl.createComponentForm.$submitted">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>
                                            </div>                

                                            <div class="form-group" ng-class="{'has-error':ctrl.createComponentForm.componentUom.$touched && ctrl.createComponentForm.componentUom.$invalid}" >
                                                <label for="componentUom" ><g:message code="form.field.componentUom.label" /></label>
                                                <select name="componentUom" id="componentUom" ng-model="ctrl.newComponent.componentUom" class="form-control" ng-change="ctrl.selectCase()" ng-disabled="ctrl.disableProductionUom" tabindex="6" required>
                                                    <option ng-repeat="option in data.availableOptions" ng-value="option.id">{{option.name}}</option>
                                                </select>
                                                <div class="my-messages" ng-messages="ctrl.createComponentForm.componentUom.$error" ng-if="ctrl.createComponentForm.componentUom.$touched || ctrl.createComponentForm.$submitted">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="panel-footer">
                                        <div class="pull-left">
                                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                <button class="btn btn-default" type="button" ng-click="ctrl.closeNewComponent()"><g:message code="default.button.cancel.label" /></button>
                                            </a>

                                        </div>
                                        <div class="pull-right">
                                            <button class="btn btn-primary" type="submit"><g:message code="default.button.save.label" /></button>
                                        </div>
                                        <br style="clear: both;"/>
                                    </div>
                                </div>
                            </form>

                        </div>

                        <div ng-show = "isVisibleEditComponentWindow" class="row">

                            <form name="ctrl.upddateComponentForm" ng-submit="ctrl.updateComponent()" novalidate >

                                <div class="panel panel-default" id="panel-anim-fadeInDown">
                                    <div class="panel-heading">
                                        <!-- <div class="panel-title" ng-if="ctrl.newLocation.hiddenlocationId"><g:message code="default.location.edit.label" /></div> -->
                                        <div class="panel-title">Edit Component</div>
                                    </div>

                                    <div class="panel-body">
                                        <div class="col-md-6">
                                            <div class="form-group" ng-class="{'has-error':ctrl.upddateComponentForm.itemId.$touched && ctrl.upddateComponentForm.itemId.$invalid}">
                                                <label><g:message code="form.field.componentItem.label" /></label>
                                                <div auto-complete  source="sourceItems" xxxx-list-formatter="customListFormatter"
                                                     value-changed="ctrl.validateItemIdComponentEdit(value.locationId)" style="z-index: 1000000000;">
                                                    <input ng-model="ctrl.editComponent.componentItemId" id="itemId" name='itemId' ng-model-options="{ updateOn : 'default blur' }" placeholder="Item Id" class="form-control" tabindex="1" required />
                                                </div>

                                                <div class="my-messages" ng-messages="ctrl.upddateComponentForm.itemId.$error" ng-if="ctrl.upddateComponentForm.itemId.$touched || ctrl.upddateComponentForm.$submitted">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong>Please Select an Item.</strong>
                                                    </div>
                                                </div>

                                            </div>

                                            <div class="form-group" ng-class="{'has-error':ctrl.upddateComponentForm.componentQuantity.$touched && ctrl.upddateComponentForm.componentQuantity.$invalid}">
                                                <label for="componentQuantity"><g:message code="form.field.componentQuantity.label" /></label>
                                                <input id="componentQuantity" name="componentQuantity" class="form-control" type="number"
                                                       ng-model="ctrl.editComponent.componentQuantity" ng-model-options="{ updateOn : 'default blur' }"
                                                       min="1" required />

                                                <div class="my-messages"  ng-messages="ctrl.upddateComponentForm.componentQuantity.$error"
                                                     ng-if="ctrl.upddateComponentForm.componentQuantity.$error.min">
                                                    <div class="message-animation" >
                                                        <strong>The value should be greater than 0 (zero).</strong>
                                                    </div>
                                                </div>
                                                <div class="my-messages" ng-messages="ctrl.upddateComponentForm.componentQuantity.$error" ng-if="ctrl.upddateComponentForm.componentQuantity.$touched || ctrl.upddateComponentForm.$submitted">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                            </div>

                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group" ng-class="{'has-error':ctrl.upddateComponentForm.componentInventoryStatus.$touched && ctrl.upddateComponentForm.componentInventoryStatus.$invalid}" >
                                                <label for="componentInventoryStatus"><g:message code="form.field.componentInventoryStatus.label" /></label>
                                                <select  id="componentInventoryStatus" name="componentInventoryStatus" ng-model="ctrl.editComponent.componentInventoryStatus" class="form-control" tabindex="2" required>
                                                    <option ng-repeat="option in ctrl.inventoryStatusOptions" value="{{option.optionValue}}">{{option.description}}</option>
                                                </select>

                                                <div class="my-messages" ng-messages="ctrl.upddateComponentForm.componentInventoryStatus.$error" ng-if="ctrl.upddateComponentForm.componentInventoryStatus.$touched || ctrl.upddateComponentForm.$submitted">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>
                                            </div>                

                                            <div class="form-group" ng-class="{'has-error':ctrl.upddateComponentForm.componentUom.$touched && ctrl.upddateComponentForm.componentUom.$invalid}" >
                                                <label for="componentUom" ><g:message code="form.field.componentUom.label" /></label>
                                                <select name="componentUom" id="componentUom" ng-model="ctrl.editComponent.componentUom" class="form-control" ng-change="ctrl.selectCase()" ng-disabled="ctrl.disableProductionUom" tabindex="6" required>
                                                    <option ng-repeat="option in data.availableOptions" ng-value="option.id">{{option.name}}</option>
                                                </select>
                                                <div class="my-messages" ng-messages="ctrl.upddateComponentForm.componentUom.$error" ng-if="ctrl.upddateComponentForm.componentUom.$touched || ctrl.upddateComponentForm.$submitted">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="panel-footer">
                                        <div class="pull-left">
                                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                <button class="btn btn-default" type="button" ng-click="ctrl.closeEditComponent()"><g:message code="default.button.cancel.label" /></button>
                                            </a>

                                        </div>
                                        <div class="pull-right">
                                            <button class="btn btn-primary" type="submit"><g:message code="default.button.update.label" /></button>
                                        </div>
                                        <br style="clear: both;"/>
                                    </div>
                                </div>
                            </form>

                        </div>

                        <%--  ****************** component Grid  ****************** --%>

                        <p>
                        <div ng-hide="ctrl.kittingOrderList.length == 0" id="grid1" ui-grid="gridKittingOrderComponents" ui-grid-exporter  ui-grid-pagination ui-grid-resize-columns class="grid">
                            <div class="noLocationMessage" ng-if="gridKittingOrderComponents.data.length == 0"><g:message code="kittingOrder.component.grid.noData.message" /></div>
                        </div>
                    </p>
                        <%-- ****************** END OF component Grid  ****************** --%>




                    </div>
                    <div id="instructions" class="tab-pane fade">


                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showInstructionSubmittedPrompt">
                                <g:message code="instruction.create.message" />
                            </div>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showInstructionUpdatedPrompt">
                                <g:message code="instruction.edit.message" />
                            </div>
                            
                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showInstructionDeletedPrompt">
                                <g:message code="instruction.delete.message" />
                            </div> 
                            <br style="clear: both;">  

                            <div ng-hide="ctrl.kittingOrderList.length == 0" style="float: left;">
                                <div class="form-group">
                                    <div><h4><g:message code="form.field.KittingOrd.kittingOrderNumber.label" />&emsp;:&emsp;{{ctrl.selectedItemId}}</h4></div>
                                </div>

                            </div>
                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">


                                <button ng-hide="ctrl.kittingOrderList.length == 0" type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ctrl.showInstructionCreateForm()">
                                    <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                    <g:message code="default.button.createInstruction.label" />
                                </button>
                            </a>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>
                            
                            <div ng-show = "isVisibleNewInstructionWindow" class="row">

                                <form name="ctrl.createInstructionForm" ng-submit="ctrl.createInstruction()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">
                                            <!-- <div class="panel-title" ng-if="ctrl.newLocation.hiddenlocationId"><g:message code="default.location.edit.label" /></div> -->
                                            <div class="panel-title">Add New Instruction</div>
                                        </div>

                                        <div class="panel-body">

                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.createInstructionForm.instructionId.$touched && ctrl.createInstructionForm.instructionId.$invalid}">
                                                    <label for="instructionId"><g:message code="form.field.instructionId.label" /></label>
                                                    <input id="instructionId" name="instructionId" class="form-control" type="text"
                                                           ng-model="ctrl.newInstruction.instructionId" ng-model-options="{ updateOn : 'default blur' }" />

                                                </div> 

                                                <div class="form-group" ng-class="{'has-error':ctrl.createInstructionForm.instructionType.$touched && ctrl.createInstructionForm.instructionType.$invalid}" >
                                                    <label for="instructionType" ><g:message code="form.field.instructionType.label" /></label>
                                                    <select name="instructionType" id="instructionType" ng-model="ctrl.newInstruction.instructionType" class="form-control" ng-change="ctrl.selectInstructionType(ctrl.newInstruction)" ng-disabled="" tabindex="6" required>
                                                        <option ng-repeat="option in ctrl.instructionTypeObj" ng-value="option">{{option}}</option>
                                                    </select>
                                                    <div class="my-messages" ng-messages="ctrl.createInstructionForm.instructionType.$error" ng-if="ctrl.createInstructionForm.instructionType.$touched || ctrl.createInstructionForm.$submitted">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-group" ng-class="{'has-error':ctrl.createInstructionForm.instructionInventoryStatus.$touched && ctrl.createInstructionForm.instructionInventoryStatus.$invalid}" >
                                                    <label for="instructionInventoryStatus"><g:message code="form.field.instructionInventoryStatus.label" /></label>
                                                    <select  id="instructionInventoryStatus" name="instructionInventoryStatus" ng-model="ctrl.newInstruction.inventoryStatus" class="form-control" ng-disabled="ctrl.disableInstructionInventoryStatus" tabindex="2" >
                                                        <option ng-repeat="option in ctrl.inventoryStatusOptions" value="{{option.optionValue}}">{{option.description}}</option>
                                                    </select>
                                                </div>   

                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-group" ng-class="{'has-error':ctrl.createInstructionForm.instructionsDesc.$touched && ctrl.createInstructionForm.instructionsDesc.$invalid}">
                                                    <label for="instructionsDesc"><g:message code="form.field.instructionsDesc.label" /></label>
                                                    <textarea id="instructionsDesc" name="instructionsDesc" class="form-control" type="text" rows="9" 
                                                           ng-model="ctrl.newInstruction.instruction" ng-model-options="{ updateOn : 'default blur' }" required /></textarea>

                                                    <div class="my-messages" ng-messages="ctrl.createInstructionForm.instructionsDesc.$error" ng-if="ctrl.createInstructionForm.instructionsDesc.$touched || ctrl.createInstructionForm.$submitted">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>

                                                </div>

                                            </div>                                            

                                        </div>

                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="ctrl.closeNewInstruction()"><g:message code="default.button.cancel.label" /></button>
                                                </a>

                                            </div>
                                            <div class="pull-right">
                                                <button class="btn btn-primary" type="submit"><g:message code="default.button.save.label" /></button>
                                            </div>
                                            <br style="clear: both;"/>
                                        </div>
                                    </div>
                                </form>

                            </div>

                            <div ng-show = "isVisibleEditInstructionWindow" class="row">

                                <form name="ctrl.editInstructionForm" ng-submit="ctrl.updateInstruction()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">
                                            <!-- <div class="panel-title" ng-if="ctrl.newLocation.hiddenlocationId"><g:message code="default.location.edit.label" /></div> -->
                                            <div class="panel-title">Edit Instruction</div>
                                        </div>

                                        <div class="panel-body">

                                            <div class="col-md-6">
                                                <div class="form-group" ng-class="{'has-error':ctrl.editInstructionForm.instructionId.$touched && ctrl.upddateComponentForm.instructionId.$invalid}">
                                                    <label for="instructionId"><g:message code="form.field.instructionId.label" /></label>
                                                    <input id="instructionId" name="instructionId" class="form-control" type="text"
                                                           ng-model="ctrl.editInstruction.instructionId" ng-model-options="{ updateOn : 'default blur' }"
                                                           min="0"/>

                                                </div>
                                                <div class="form-group" ng-class="{'has-error':ctrl.editInstructionForm.instructionType.$touched && ctrl.editInstructionForm.instructionType.$invalid}" >
                                                    <label for="instructionType" ><g:message code="form.field.instructionType.label" /></label>
                                                    <select name="instructionType" id="instructionType" ng-model="ctrl.editInstruction.instructionType" class="form-control" ng-change="ctrl.selectInstructionType(ctrl.editInstruction)" ng-disabled="" tabindex="6" required>
                                                        <option ng-repeat="option in ctrl.instructionTypeObj" ng-value="option">{{option}}</option>
                                                    </select>
                                                    <div class="my-messages" ng-messages="ctrl.editInstructionForm.instructionType.$error" ng-if="ctrl.editInstructionForm.instructionType.$touched || ctrl.editInstructionForm.$submitted">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-group" ng-class="{'has-error':ctrl.editInstructionForm.instructionInventoryStatus.$touched && ctrl.editInstructionForm.instructionInventoryStatus.$invalid}" >
                                                    <label for="instructionInventoryStatus"><g:message code="form.field.instructionInventoryStatus.label" /></label>
                                                    <select  id="instructionInventoryStatus" name="instructionInventoryStatus" ng-model="ctrl.editInstruction.inventoryStatus" class="form-control" ng-disabled="ctrl.disableInstructionInventoryStatus" tabindex="2" >
                                                        <option ng-repeat="option in ctrl.inventoryStatusOptions" value="{{option.optionValue}}">{{option.description}}</option>
                                                    </select>
                                                </div>   
                                                

                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-group" ng-class="{'has-error':ctrl.editInstructionForm.instructionsDesc.$touched && ctrl.editInstructionForm.instructionsDesc.$invalid}">
                                                    <label for="instructionsDesc"><g:message code="form.field.instructionsDesc.label" /></label>
                                                    <textarea id="instructionsDesc" name="instructionsDesc" class="form-control" type="text" rows="9" 
                                                           ng-model="ctrl.editInstruction.instruction" ng-model-options="{ updateOn : 'default blur' }" required /></textarea>

                                                    <div class="my-messages" ng-messages="ctrl.editInstructionForm.instructionsDesc.$error" ng-if="ctrl.editInstructionForm.instructionsDesc.$touched || ctrl.editInstructionForm.$submitted">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>

                                                </div>

                                            </div>                                            

                                        </div>

                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="ctrl.closeEditInstruction()"><g:message code="default.button.cancel.label" /></button>
                                                </a>

                                            </div>
                                            <div class="pull-right">
                                                <button class="btn btn-primary" type="submit"><g:message code="default.button.save.label" /></button>
                                            </div>
                                            <br style="clear: both;"/>
                                        </div>
                                    </div>
                                </form>

                            </div>
                            <%--  ****************** instruction Grid  ****************** --%>

                                <p>
                                <div ng-hide="ctrl.kittingOrderList.length == 0" id="grid1" ui-grid="gridKttingOrderInstructions" ui-grid-exporter  ui-grid-pagination ui-grid-resize-columns ui-grid-auto-resize class="grid">
                                    <div class="noLocationMessage" ng-if="gridKttingOrderInstructions.data.length == 0"><g:message code="kittingOrder.instruction.grid.noData.message" /></div>
                                </div>
                                </p>


                                <%-- ****************** END OF instruction Grid  ****************** --%>
                    </div>

                    <div id="componentInventory" class="tab-pane fade">

                    <div ng-hide="ctrl.kittingOrderList.length == 0" style="float: left;">
                        <div class="form-group">
                            <div><h4><g:message code="form.field.KittingOrd.kittingOrderNumber.label" />&emsp;:&emsp;{{ctrl.selectedItemId}}</h4></div>
                        </div>

                    </div>
                    <br style="clear: both;">
                    <%--  ****************** inventory Grid  ****************** --%>

                    <p>
                    <div ng-hide="ctrl.kittingOrderList.length == 0" id="grid1" ui-grid="gridKttingComponentInventory" ui-grid-exporter  ui-grid-pagination ui-grid-resize-columns ui-grid-auto-resize class="grid">
                        <div class="noLocationMessage" ng-if="gridKttingComponentInventory.data.length == 0"><g:message code="kittingOrder.ComponentInventory.grid.noData.message" /></div>
                    </div>
                </p>


                    <%-- ****************** END OF inventory Grid  ****************** --%>
                </div>

                    <div id="kittingInventory" class="tab-pane fade"> 

                            <div ng-hide="ctrl.kittingOrderList.length == 0" style="float: left;">
                                <div class="form-group">
                                    <div><h4><g:message code="form.field.KittingOrd.kittingOrderNumber.label" />&emsp;:&emsp;{{ctrl.selectedItemId}}</h4></div>
                                </div>

                            </div>
                            <br style="clear: both;">  
                            <%--  ****************** inventory Grid  ****************** --%>

                                <p>
                                <div ng-hide="ctrl.kittingOrderList.length == 0" id="grid1" ui-grid="gridKttingOrderInventory" ui-grid-exporter  ui-grid-pagination ui-grid-resize-columns ui-grid-auto-resize class="grid">
                                    <div class="noLocationMessage" ng-if="gridKttingOrderInventory.data.length == 0"><g:message code="kittingOrder.inventory.grid.noData.message" /></div>
                                </div>
                                </p>


                                <%-- ****************** END OF inventory Grid  ****************** --%>
                    </div>
                    %{--Start Action Button--}%

                    <br style="clear: both;"/>
                    <br style="clear: both;"/>

                    <div style="float: right; margin-top: 0px; margin-bottom: 20px;">
                        <!-- <button class="btn btn-default"  ng-show="ctrl.shipmentIdAllocationCancel[$index]" ng-click="ctrl.cancelAllocation(shipmentData.shipment_id)"><g:message code="default.button.cancelAllocation.label" /></button> -->
                        <button class="btn btn-primary" ng-show="ctrl.selectedKittingOrder.kitting_order_status == 'OPEN'" ng-disabled="" ng-click = "ctrl.allocate(ctrl.selectedKittingOrder)" ><g:message code="default.button.allocate.label" /></button>
                        <button class="btn btn-primary" ng-show="ctrl.selectedKittingOrder.kitting_order_status == 'ALLOCATED' " ng-click = "ctrl.viewPicks(ctrl.selectedKittingOrder.kitting_order_number)" >View Picks</button>
                        <button class="btn btn-primary" ng-show="ctrl.selectedKittingOrder.kitting_order_status == 'COMPONENT READY' || ctrl.selectedKittingOrder.kitting_order_status == 'PROCESSING'" ng-click = "ctrl.processKitting(ctrl.selectedKittingOrder)" >Process</button>
                    </div>

                    <div style="float: left; margin-top: 0px; margin-bottom: 20px;">
                        <button  class="btn btn-primary" ng-show="ctrl.selectedKittingOrder.kitting_order_status == 'OPEN' && ctrl.allocationFailedMessageDisplay[ctrl.selectedKittingOrderIndex]" ng-click = "ctrl.allocationFailedMessageViewPopUp(ctrl.selectedKittingOrder.kitting_order_number)" >View Allocation Messages</button>
                    </div>

                    <br style="clear: both;"/>

                    %{--End  Action Button--}%

                </div>
            </div>
            <!--/.panel-body -->
        </div>

        <!-- END panel-->

    <div id="dvCopyBOMWarning" class="modal fade" role="dialog" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Confirmation</h4>
                </div>
                <div class="modal-body">
                    <p>You have selected a bill of material item</p>
                    <p>Do you want to copy all the data of this item from bill of material?</p>
                    <br style="clear: both;">
                    <div ng-show="ctrl.showKONumberToCopyForm">
                        <div class="form-group">
                            <label for="kittingOrderNumber">Please provide a <g:message code="form.field.KittingOrd.kittingOrderNumber.label" /></label>
                            <input id="kittingOrderNumber" name="kittingOrderNumber" class="form-control" type="text" maxlength="32" capitalize
                           ng-model="ctrl.kittingOrderNumForCopy" ng-blur="ctrl.validateKittingOrderNum(ctrl.newKittingOrder.kittingOrderNumber)" tabindex="1" required />


                            <div style="color: #f30303;"  ng-if="ctrl.showOrderNumberExistError">
                                <!-- <div class="message-animation" > -->
                                    <strong>Kitting order number exists already.</strong>
                                <!-- </div> -->
                            </div>

                            <div style="color: #f30303;" ng-if="ctrl.showOrderNumberRequiredError">
                                <!-- <div class="message-animation"> -->
                                    <strong><g:message code="required.error.message" /></strong>
                                <!-- </div> -->
                            </div>

                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button ng-hide="ctrl.showKONumberToCopyForm" type="button" class="btn btn-primary" ng-click="ctrl.copyBOMDataButton()"><g:message code="default.button.ok.label" /></button>
                    <button ng-show="ctrl.showKONumberToCopyForm" type="button" class="btn btn-primary" ng-click="ctrl.copyBOMDataAndCreateKitting()">Copy</button>
                </div>
            </div>
        </div>
    </div>     

    <!-- start allocate view popup -->

    <div id="allocationProcess" class="modal fade" role="dialog" data-backdrop="static">
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
                                <div class="label-desc-order" style="text-align: left; width: 150px;"><g:message code="form.field.KittingOrd.kittingOrderNumber.label"/>&nbsp; :</div>
                                <div class="label-content" style="text-align: left;"> {{ctrl.kittigOrderNumForAllocation}}</div>
                            </div>

                            <!-- <div class ="col-md-6" >
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
                            </div> -->

                            <br style="clear:both;"/>
                        </div>



                        <div class="col-md-12" style="margin-top: 5px;">
                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForAllocationCreate('locationId')}">
                                    <label for="locationId">Processing Location</label>
                                    <div auto-complete  source="loadLocationAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars = '0'
                                         value-changed="ctrl.callback(value.location_id)" style="z-index: 1000;">
                                        <input id="locationId" name="locationId" ng-model="ctrl.locationIdForAllocation"  ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="Location Id" class="form-control"/>
                                    </div>

                                </div>

                            </div>

                            <div class="col-md-6">
                                <button style="margin-left: 20px; margin-top: 22px" class="btn btn-primary" type="submit" ng-disabled = "!ctrl.locationIdForAllocation" ng-hide="loadingAnimSaveAllocation">Begin Allocation</button>
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
                                    %{--<div id="grid1" ui-grid="gridShipmentAndCustomer" ui-grid-exporter ui-grid-selection ui-grid-pagination ui-grid-pinning ui-grid-resize-columns class="grid">
                                        <div class="noItemMessage" ng-if="gridShipmentAndCustomer.data.length == 0">This Staging Location is Free</div>
                                    </div>--}%
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



    <!-- start kitting processing popup -->
    <div id="kittingProcessing" class="modal fade" role="dialog" >
        <div class="receipt-modal-dialog modal-dialog"  style="width: 100%;">
            <div class="receipt-modal-content modal-content">
                <div class="receipt-modal-header modal-header">
                    <button type="button" class="receipt-close close" ng-click="ctrl.clearProcessKittingModal()" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <br style="clear: both;"/>

                    <div class="panel-heading">
                        <div class="receipt-panel-title panel-title"><h4>Process Kitting</h4></div>
                    </div>
                </div>

                <div class="receipt-modal-body modal-body">

                    <div ng-show="ctrl.kittingInventoryNotify" class="alert alert-success message-animation" role="alert" >
                        %{--<g:message code="receipt.inventoryReceivedStart.message" /> {{ctrl.receiptLineNoForView}}--}%
                        <g:message code="receipt.kittingInventory.Received.message" />
                    </div>

                    <div class = "col-md-12" >
                        <div class = "col-md-4" >
                            <h4><g:message code="form.field.kittedItem.label" />: {{ctrl.kittingItemForProcessing}} - {{ctrl.kittingItemDescriptionForView}}</h4>
                        </div>
                        <div class = "col-md-4" >
                            <h4><g:message code="form.field.KittingOrd.kittingOrderNumber.label" />: {{ctrl.kittingOrderNumForProcessing}}</h4>
                        </div>
                        <div class = "col-md-4" >
                            <h4><g:message code="form.field.KittingOrd.productionQuantity.label" />: {{ctrl.kittingQtyForProcessing}} &nbsp; {{ctrl.kittingUomForProcessing}}</h4>
                        </div>

                    </div>
                    <br style="clear: both;"/>


                    <br style="clear: both;"/>


                    <div>

                        <div class = "col-md-12" >
                            <div class="col-md-2"><label>Pallet Id</label></div>
                            <div class="col-md-2"><label>Case Id</label></div>
                            <div class="col-md-1"><label>Uom</label></div>
                            <div class="col-md-1"><label>Qty</label></div>
                            <div class="col-md-1"><label>Lot Code</label></div>
                            <div class="col-md-2"><label>Expiration Date</label></div>
                            <!-- <div class="col-md-1"><label>Status</label></div> -->
                        </div>


                        <div class="col-md-12">
                            <form name="ctrl.kittingInventory" ng-submit="ctrl.saveKittingInventory()" novalidate >

                                <div class="col-md-2" ng-class="{'has-error':ctrl.hasErrorClassForKitting('kittingInventoryPalletId')}" ng-if = "ctrl.kittingInventoryCaseIdDisabled">
                                    <input id="kittingInventoryPalletId" name="kittingInventoryPalletId" class="form-control" type="text" ng-model="ctrl.kittingInventoryPalletId" ng-blur="ctrl.uniquePalletIdValidation(ctrl.kittingInventoryPalletId)" ng-keypress="ctrl.barcodeScanInput($event)" capitalize required tabindex="1" />

                                    <div class="my-messages" ng-messages="ctrl.kittingInventory.kittingInventoryPalletId.$error" ng-if="ctrl.showMessagesForKitting('kittingInventoryPalletId')">
                                        <div class="message-animation" ng-message="required">
                                            %{--<strong>This field is required.</strong>--}%
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages"  ng-messages="ctrl.kittingInventory.kittingInventoryPalletId.$error"
                                         ng-if="ctrl.kittingInventory.$error.palletIdExists">
                                        <div class="message-animation" >
                                            <strong><g:message code="receipt.palletIdExists.error.message" /></strong>
                                        </div>
                                    </div>


                                </div>



                                <div class="col-md-2" ng-class="{'has-error':ctrl.hasErrorClassForKitting('kittingInventoryPalletId')}" ng-if = "!ctrl.kittingInventoryCaseIdDisabled">
                                    <input id="kittingInventoryPalletId" name="kittingInventoryPalletId" class="form-control" type="text" ng-model="ctrl.kittingInventoryPalletId" ng-blur="ctrl.uniquePalletIdValidation(ctrl.kittingInventoryPalletId)" ng-keypress="ctrl.barcodeScanInput($event)"  capitalize tabindex="1" />

                                    <div class="my-messages"  ng-messages="ctrl.kittingInventory.kittingInventoryPalletId.$error"
                                         ng-if="ctrl.kittingInventory.$error.palletIdExists">
                                        <div class="message-animation" >
                                            <strong><g:message code="receipt.palletIdExists.error.message" /></strong>
                                        </div>
                                    </div>

                                </div>



                                <div class="col-md-2" ng-class="{'has-error':ctrl.hasErrorClassForKitting('kittingInventoryCaseId')}" ng-if = "!ctrl.kittingInventoryCaseIdDisabled">
                                    <input id="kittingInventoryCaseId" name="kittingInventoryCaseId" class="form-control" type="text" ng-model="ctrl.kittingInventoryCaseId" ng-blur="ctrl.uniqueCaseIdValidation(ctrl.kittingInventoryCaseId)" ng-keypress="ctrl.barcodeScanInput($event)" capitalize required tabindex="2" />

                                    <div class="my-messages" ng-messages="ctrl.kittingInventory.kittingInventoryCaseId.$error" ng-if="ctrl.showMessagesForKitting('kittingInventoryCaseId')">
                                        <div class="message-animation" ng-message="required">
                                            %{--<strong>This field is required.</strong>--}%
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages"  ng-messages="ctrl.kittingInventory.kittingInventoryCaseId.$error"
                                         ng-if="ctrl.kittingInventory.$error.caseIdExists">
                                        <div class="message-animation" >
                                            <strong><g:message code="receipt.caseIdExists.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages"  ng-messages="ctrl.kittingInventory.kittingInventoryCaseId.$error"
                                         ng-if="(ctrl.kittingInventoryCaseId == ctrl.kittingInventoryPalletId) && (ctrl.kittingInventoryCaseId && ctrl.kittingInventoryPalletId)">
                                        <div class="message-animation" >
                                            <strong>Pallet Id and Case id cannot be the same</strong>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-2" ng-if = "ctrl.kittingInventoryCaseIdDisabled">
                                    <input id="kittingInventoryCaseId" name="kittingInventoryCaseId" class="form-control" type="text" ng-model="ctrl.kittingInventoryCaseId" ng-disabled="ctrl.kittingInventoryCaseIdDisabled" capitalize tabindex="2" />
                                </div>


                                <div class="col-md-1" ng-class="{'has-error':ctrl.hasErrorClassForKitting('kittingInventoryUom')}">
                                    <select name="kittingInventoryUom" id="kittingInventoryUom" ng-model="ctrl.kittingInventoryUom" class="form-control" ng-change="ctrl.selectCase()" required tabindex="3">
                                        <option ng-repeat="option in data.availableOptions" ng-value="{{option.id}}">{{option.name}}</option>
                                    </select>

                                    <div class="my-messages" ng-messages="ctrl.kittingInventory.kittingInventoryUom.$error" ng-if="ctrl.showMessagesForKitting('kittingInventoryUom')">
                                        <div class="message-animation" ng-message="required">
                                            <strong>Please select an option.</strong>
                                        </div>
                                    </div>

                                </div>

                                <div class="col-md-1" ng-class="{'has-error':ctrl.hasErrorClassForKitting('kittingInventoryQty')}" ng-if = "!ctrl.kittingInventoryQtyDisabled" >

                                    <input id="kittingInventoryQty" name="kittingInventoryQty" class="form-control" type="text"
                                           ng-model="ctrl.kittingInventoryQty" required numbers-only tabindex="4" />

                                    <div class="my-messages" ng-messages="ctrl.kittingInventory.kittingInventoryQty.$error" ng-if="ctrl.showMessagesForKitting('kittingInventoryQty')">
                                        <div class="message-animation" ng-message="required">
                                            %{--<strong>This field is required.</strong>--}%
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                </div>


                                <div class="col-md-1" ng-if = "ctrl.kittingInventoryQtyDisabled">
                                    <input id="kittingInventoryQty" name="kittingInventoryQty" class="form-control" type="text"
                                           ng-model="ctrl.kittingInventoryQty" ng-disabled="ctrl.kittingInventoryQtyDisabled" tabindex="4"  />
                                </div>

                                <div class="col-md-1" ng-if = "!ctrl.kittingInventoryLotCodeDisabled" ng-class="{'has-error':ctrl.hasErrorClassForKitting('kittingInventoryLotCode')}" >
                                    <input id="kittingInventoryLotCode" name="kittingInventoryLotCode" class="form-control" type="text" ng-model="ctrl.kittingInventoryLotCode" required tabindex="5"  />

                                    <div class="my-messages" ng-messages="ctrl.kittingInventory.kittingInventoryLotCode.$error" ng-if="ctrl.showMessagesForKitting('kittingInventoryLotCode')">
                                        <div class="message-animation" ng-message="required">
                                            %{--<strong>This field is required.</strong>--}%
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                </div>

                                <div class="col-md-1" ng-if = "ctrl.kittingInventoryLotCodeDisabled" >
                                    <input id="kittingInventoryLotCode" name="kittingInventoryLotCode" class="form-control" type="text" ng-model="ctrl.kittingInventoryLotCode" ng-disabled="ctrl.kittingInventoryLotCodeDisabled"  tabindex="5"/>
                                </div>

                                <div class="col-md-2" ng-if = "!ctrl.kittingInventoryExpireDateDisabled" ng-class="{'has-error':ctrl.hasErrorClassForKitting('kittingInventoryExpireDate')}" >
                                    <input id="kittingInventoryExpireDate" name="kittingInventoryExpireDate" class="form-control" type="date" ng-model="ctrl.kittingInventoryExpireDate" required  tabindex="6"/>

                                    <div class="my-messages" ng-messages="ctrl.kittingInventory.kittingInventoryExpireDate.$error" ng-if="ctrl.showMessagesForKitting('kittingInventoryExpireDate')">
                                        <div class="message-animation" ng-message="required">
                                            %{--<strong>This field is required.</strong>--}%
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>


                                </div>


                                <div class="col-md-2" ng-if = "ctrl.kittingInventoryExpireDateDisabled">
                                    <input id="kittingInventoryExpireDate" name="kittingInventoryExpireDate" class="form-control" type="date" ng-model="ctrl.kittingInventoryExpireDate" ng-disabled="ctrl.kittingInventoryExpireDateDisabled"  tabindex="6" />
                                </div>

                                <div class="col-md-3">

                                    <a href="javascript:void(0)" uib-popover-template="ctrl.getPopoverTemplateUrl" popover-title=""  popover-append-to-body="true" popover-placement="bottom" popover-trigger="outsideClick" ng-show = "!ctrl.kittingInventoryCaseIdDisabled" tabindex="8">Notes</a> &emsp;

                                    <script type="text/ng-template" id="notesPopover">
                                    <div class="form-group">
                                        <label>Notes :</label>
                                        <textarea class='form-control' rows='5' id='notes' ng-model='ctrl.kittingInventoryItemNotes' placeholder='Enter Note Here....' tabindex="8"></textarea>
                                    </div>
                                    </script>

                                    <button class="btn btn-primary" type="submit" tabindex="9" ng-disabled="ctrl.disableKittingInvSaveBtn">{{ctrl.kittingInvSaveSaveBtnText}}</button>
                                </div>
                            </form>
                        </div>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>




                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showInstructionsCompletedPrompt">
                            <p>All the instructions have been successfully confirmed.</p>
                        </div>
                        <div class="alert alert-warning message-animation" role="alert" ng-if="ctrl.showPendingInstructionsPrompt">
                            <p>Some instructions are pending to be confirmed for this inventory.</p>
                        </div>
                        <div class="col-md-12" ng-show="ctrl.showKOInstructionData && ctrl.kOInstructionsDataList.length > 0">
                            <div class="panel-heading">
                                <legend>
                                    Kitting Instruction : {{ctrl.kOInstructionsDataList[ctrl.instructionIndx].instruction_type}}
                                </legend>
                            </div>
                            <div>
                                <p>{{ctrl.kOInstructionsDataList[ctrl.instructionIndx].instruction}}</p>
                            </div>
                            <div>
                                <button ng-if="ctrl.kOInstructionsDataList[ctrl.instructionIndx].instruction_type == 'Mandatory' || ctrl.kOInstructionsDataList[ctrl.instructionIndx].instruction_type == 'Optional'" class="btn btn-primary" ng-click="ctrl.confirmKOInstruction()" type="button" >Confirm</button>
                                <button ng-if="ctrl.kOInstructionsDataList[ctrl.instructionIndx].instruction_type == 'Informational'" class="btn btn-primary" ng-click="ctrl.confirmKOInstruction()" type="button" >Next</button>
                                <button ng-if="ctrl.kOInstructionsDataList[ctrl.instructionIndx].instruction_type == 'Optional'" class="btn btn-primary" ng-click="ctrl.skipKOInstruction();" type="button" >Skip</button>
                                <button class="btn btn-default" ng-click="ctrl.cancelInstruction();" type="button" >Cancel</button>
                            </div>                          
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
                        <div class="col-md-6 pull-right" style="width: initial;">
                            <button type="button" class="btn btn-primary" ng-click="ctrl.clearProcessKittingModal()" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- end kitting processing popup -->

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
    <!-- ********** Putaway modal ********** -->
    <div id="putawayModal" class="modal fade" role="dialog" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Putaway</h4>
                </div>
                <div class="modal-body">
                    <div class = "col-md-12" >
                        <div class="col-md-12">
                            <label>Item Id:</label>&nbsp;{{ctrl.selectedKittingOrder.kitting_item_id}} - {{ctrl.selectedKittingOrder.itemDescription}}
                        </div>
                    </div>

                    <div class = "col-md-12" >
                        <div class="col-md-6"><label>{{ctrl.putawayLpnLevel}} Id:</label></div>
                        <div class="col-md-6" style="width:220px;" style="width:220px;"><label>System Suggested Location:</label></div>
                    </div>


                    <div class="col-md-12">
                        <form name="ctrl.putawayInventory" ng-submit="ctrl.saveKittingPutaway()" novalidate >
                            <div class="col-md-6">
                                {{ctrl.putawayInventoryLpnId}}
                            </div>
                            <div class="col-md-6" style="width:220px;">
                                <span style="font-weight: bold; ">{{ctrl.putawaySystemLocation}}</span>
                                <span style="color: red;">{{ctrl.putawaySystemLocationError}} </span>
                                <br style="clear: both;"/>
                                <br style="clear: both;"/>
                                
                                      
                            </div>
                            <div class="col-md-12" style="padding-left: 1px;" ng-if="ctrl.putawaySystemLocation">
                                <div class="col-md-4" style="font-weight: bold;">
                                    Putaway Location :
                                </div>
                                <div class="col-md-5">
                                    <input id="confirmLocation" name="confirmLocationId" class="form-control" type="text"
                                       ng-model="ctrl.confirmLocationId" ng-blur="ctrl.confirmLocationForPutaway(ctrl.confirmLocationId)" placeholder="Confirm Location" required capitalize />

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
                                    <button class="btn btn-primary" type="submit" ng-disabled="ctrl.putawaySystemLocationError || ctrl.disableConfirmForUnmatchedlocation || !ctrl.confirmLocationId || ctrl.disableKittingPutaway">Confirm</button>
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
                        <form name="ctrl.putawayInventoryUserDefined" ng-submit="ctrl.saveKittingPutawayUserDefined()" novalidate >
                            <div class="col-md-8" ng-class="{'has-error':ctrl.hasErrorClassForPutaway('putawayUserLocation')}">
                                <input id="putawayUserLocation" name="putawayUserLocation" class="form-control" type="text"
                                       ng-model="ctrl.putawayUserLocation" ng-blur="ctrl.checkLocationIdExist(ctrl.putawayUserLocation)" ng-keydown="ctrl.lowestUomCaseForBin=false;" placeholder="Override" required capitalize/>

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
                                        <strong>CASE lowest UOM inventory cannot be received to a bin location.</strong>
                                    </div>
                                </div> 


                            </div>
                            <div class="col-md-2">
                                <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disablePutawayUserDefined" >Override</button>
                            </div>
                        </form>
                    </div>

                    <br style="clear: both;"/>
                    <br style="clear: both;"/>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.close.label" /></button>
                </div>
            </div>
        </div>
    </div> 

    <!-- ********** Putaway modal ********** -->

    <div id="stageModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Move to Staging Location</h4>
                </div>
                <div class="modal-body">
                    <form name="ctrl.kittingToStageForm" ng-submit="ctrl.sendKittedItemToStage()" novalidate >
                        <div class="col-md-4">
                            <label>Staging Location<span style="text-align: right;">:</span></label>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>
                            <label>Confirm Location Id<span style="text-align: right;">:</span></label>
                        </div>
                        <div class="col-md-6">
                            <label>{{ctrl.kittingStageLocDisplay}}</label>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>
                            <div class="form-group" ng-class="{'has-error':ctrl.kittingToStageForm.kittingDestinationLocation.$touched && ctrl.kittingToStageForm.kittingDestinationLocation.$invalid}">
                               <input type="text" name="kittingDestinationLocation" class="form-control" ng-model="ctrl.confirmKittingLocation" style="width: 200px; display: inline;" capitalize required />  
                                    <div class="my-messages" ng-messages="ctrl.kittingToStageForm.kittingDestinationLocation.$error" ng-if="ctrl.kittingToStageForm.kittingDestinationLocation.$touched || ctrl.kittingToStageForm.$submitted">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages" ng-messages="ctrl.kittingToStageForm.kittingDestinationLocation.$error" ng-if="ctrl.kittingDestinationLocErrorMsg">
                                        <div class="message-animation">
                                            <strong>{{ctrl.kittingDestinationLocErrorMsg}}</strong>
                                        </div>
                                    </div>
                            </div>
                            

                        </div>
                        <br style="clear: both;"/>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="submit" class="btn btn-primary" ng-disabled="ctrl.disableMoveToStageBtn" ><g:message code="default.button.moveToStage.label" /></button>
                    </form>
                </div>
            </div>
        </div>
    </div>    




</div>

<!-- bootstrap modal confirmation dialog-->

<div id="componentDeleteWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure want to delete this component ?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "deleteComponentButton" class="btn btn-primary"><g:message code="default.button.delete.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="instructionDeleteWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure want to delete this Instruction ?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "deleteInstructionButton" class="btn btn-primary"><g:message code="default.button.delete.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="dvDeleteKOWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure want to delete this Kitting order ?</p>
                <p>If a Kitting is deleted, The corresponding component and instruction will also be deleted along with it. </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "koDeleteButton" class="btn btn-primary"><g:message code="default.button.delete.label" /></button>
            </div>
        </div>
    </div>
</div>

<div id="dvEditKOComponentWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>You can not edit this component due to it' kitting order status is not "OPEN".</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="dvEditKittingWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>You can not edit this kitting order due to it' status is not "OPEN".</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="dvDeleteKittingWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>You can not delete this kitting order due to it' status is not "OPEN".</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="dvCreateKOComponentWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>You can not create any component due to it' kitting order status is not "OPEN".</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="dvCreateKOInstuctionWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>You can not create any instruction due to it' kitting order status is not "OPEN".</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="dvEditKOInstructionWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>You can not edit this instruction due to it' kitting order status is not "OPEN".</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="dvDeleteKOComponentWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>You can not delete this component due to it' kitting order status is not "OPEN".</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>

<div id="dvDeleteKOInstructionWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>You can not delete this instruction due to it' kitting order status is not "OPEN".</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>

<div id="dvOverReceivedAlert" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>You are trying to receive more than planned in Kitting Order.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.close.label" /></button>
            </div>
        </div>
    </div>
</div>


<asset:javascript src="datagrid/admin-kitting-order.js"/>

<script type="text/javascript">
    var dvAdminBillOfMaterial = document.getElementById('dvAdminKittingOrder');
    angular.element(document).ready(function() {
        angular.bootstrap(dvAdminBillOfMaterial, ['adminKittingOrder']);
    });
</script>


%{--<asset:javascript src="autocomplete/angular-auto.js"/>--}%
<asset:javascript src="autocomplete/angular-sanitize.js"/>
<asset:javascript src="autocomplete/auto-complete.js"/>
<asset:javascript src="autocomplete/auto-complete-multi.js"/>
<asset:javascript src="inventory/auto-complete-div.js"/>
<asset:javascript src="autocomplete/auto-complete-textbox.js"/>


</body>
</html>
