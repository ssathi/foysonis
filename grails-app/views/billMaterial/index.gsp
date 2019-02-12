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

    .bom-col-padding{
        padding-left: 0px;
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

<div ng-cloak class="row" id="dvAdminBillOfMaterial" ng-controller="BillOfMaterialCtrl as ctrl">
    <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 40px;" src="/foysonis2016/app/img/bom_header.svg"></em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">Bill Of Material</span></div>

    <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation"  href="javascript:void(0);">
        <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ctrl.showCreateBOMForm()" >
            <em class="fa fa-plus-circle fa-fw mr-sm"></em>
            <g:message code="default.button.createBOM.label" />
        </button>
    </a>

    <br style="clear: both;">
    <br style="clear: both;">

    <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showBOMSubmittedPrompt">
        <g:message code="bom.create.success.message" />
    </div>

    <div class="alert alert-warning message-animation" role="alert" ng-if="ctrl.showBOMDuplicatedItemIdPrompt">
        <g:message code="bom.create.duplicatedItem.message" />
    </div>

    <div class="alert alert-warning message-animation" role="alert" ng-if="ctrl.showBOMDuplicatedEditItemIdPrompt">
        <g:message code="bom.create.duplicatedEditItem.message" />
    </div>

    <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showBOMUpdatedPrompt">
        <g:message code="bom.edit.success.message" />
    </div>

    <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showBOMDeletedPrompt">
        <g:message code="bom.delete.success.message" />
    </div>

    %{--Start Add New BOM--}%
    <div class="panel panel-default" ng-show="IsVisibleNewBOMWindow">

        <div class="panel-heading">
            <div class="panel-title">Create New Bill Of Material</div>
        </div>        
        <div class="panel-body">
            <form name="ctrl.createBOMForm" ng-submit="ctrl.createBOM()" novalidate >

            <div class="col-md-6">
                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('itemId')}">
                    <label><g:message code="form.field.item.label" /></label>
                    <div auto-complete  source="sourceItems" xxxx-list-formatter="customListFormatter"
                         value-changed="ctrl.validateItemId(value.locationId)" style="z-index: 1000000000;">
                        <input ng-model="ctrl.newBOM.itemId" id="itemId" name='itemId' ng-model-options="{ updateOn : 'default blur' }" placeholder="Item Id" class="form-control" tabindex="1" required />
                    </div>

                    <div class="my-messages" ng-messages="ctrl.createBOMForm.itemId.$error" ng-if="ctrl.showBOMMessages('itemId')">
                        <div class="message-animation" ng-message="required">
                            <strong>BOM can be created only for existing items.</strong>
                        </div>
                    </div>

                </div>

                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('defaultProductionQuantity')}">
                    <label for="defaultProductionQuantity"><g:message code="form.field.defaultBOMProductionQuantity.label" /></label>
                    <input id="defaultProductionQuantity" name="defaultProductionQuantity" class="form-control" type="number"
                           ng-model="ctrl.newBOM.defaultProductionQuantity" ng-model-options="{ updateOn : 'default blur' }"
                           min="0" />

                    <div class="my-messages"  ng-messages="ctrl.createBOMForm.defaultProductionQuantity.$error"
                         ng-if="ctrl.createBOMForm.defaultProductionQuantity.$error.min">
                        <div class="message-animation" >
                            <strong>The value should be greater than 0 (zero).</strong>
                        </div>
                    </div>

                </div>

            </div>

            <div class="col-md-6">
                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('finishedProductDefaultStatus')}" >
                    <label for="finishedProductDefaultStatus"><g:message code="form.field.finishedProductDefaultStatus.label" /></label>
                    <select  id="finishedProductDefaultStatus" name="finishedProductDefaultStatus" ng-model="ctrl.newBOM.finishedProductDefaultStatus" class="form-control" tabindex="2" required>
                        <option ng-repeat="option in ctrl.inventoryStatusOptions" value="{{option.optionValue}}">{{option.description}}</option>
                    </select>

                    <div class="my-messages" ng-messages="ctrl.createBOMForm.finishedProductDefaultStatus.$error" ng-if="ctrl.showBOMMessages('finishedProductDefaultStatus')">
                        <div class="message-animation" ng-message="required">
                            <strong><g:message code="required.error.message" /></strong>
                        </div>
                    </div>
                </div>                

                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('productionUom')}" >
                    <label for="productionUom" ><g:message code="form.field.productionUom.label" /></label>
                    <select name="productionUom" id="productionUom" ng-model="ctrl.newBOM.productionUom" class="form-control" ng-change="ctrl.selectCase()" ng-disabled="ctrl.disableProductionUom" tabindex="6" required>
                        <option ng-repeat="option in data.availableOptions" ng-value="option.id">{{option.name}}</option>
                    </select>
                    <div class="my-messages" ng-messages="ctrl.createBOMForm.productionUom.$error" ng-if="ctrl.showBOMMessages('productionUom')">
                        <div class="message-animation" ng-message="required">
                            <strong><g:message code="required.error.message" /></strong>
                        </div>
                    </div>
                </div>
            </div>

                <br style="clear: both;"/>

                <div class="panel-footer">
                    <div class="pull-left">
                        <button  type="button" class="btn btn-default" ng-click="ctrl.cancelCreateBOM()"><g:message code="default.button.cancel.label" /></button>
                    </div>
                    <div class="pull-right">
                        <button class="btn btn-primary" type="submit"><g:message code="default.button.save.label" /></button>
                    </div>
                    <br style="clear: both;"/>
                </div>

            </form>
        </div>
    </div>
    %{--End Add New BOM--}%


    %{--Start Edit BOM--}%
    <div id="editBOMFormPanel" class="panel panel-default" ng-show="ctrl.isShowEditBOMForm">
        <div class="panel-heading">
            <div class="panel-title">Edit Bill Of Material</div>
        </div> 
        <div class="panel-body">
            <form name="ctrl.editBOMForm" ng-submit="ctrl.updateBOM()" novalidate >

            <div class="col-md-6">
                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('itemId')}">
                    <label><g:message code="form.field.item.label" /></label>
                    <div auto-complete  source="sourceItems" xxxx-list-formatter="customListFormatter"
                         value-changed="ctrl.validateItemIdEdit(value.locationId)" style="z-index: 1000000000;">
                        <input ng-model="ctrl.selectedBOM.itemId" id="itemId" name='itemId' ng-model-options="{ updateOn : 'default blur' }" placeholder="Item Id" class="form-control" tabindex="1" required />
                    </div>

                    <div class="my-messages" ng-messages="ctrl.editBOMForm.itemId.$error" ng-if="ctrl.showBOMMessages('itemId')">
                        <div class="message-animation" ng-message="required">
                            <strong>Please Select an Item.</strong>
                        </div>
                    </div>

                </div>

                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('defaultProductionQuantity')}">
                    <label for="defaultProductionQuantity"><g:message code="form.field.defaultBOMProductionQuantity.label" /></label>
                    <input id="defaultProductionQuantity" name="defaultProductionQuantity" class="form-control" type="number"
                           ng-model="ctrl.selectedBOM.defaultProductionQuantity" ng-model-options="{ updateOn : 'default blur' }"
                           min="0" />

                    <div class="my-messages"  ng-messages="ctrl.editBOMForm.defaultProductionQuantity.$error"
                         ng-if="ctrl.editBOMForm.defaultProductionQuantity.$error.min">
                        <div class="message-animation" >
                            <strong>The value should be greater than 0 (zero).</strong>
                        </div>
                    </div>

                </div>


            </div>
            <div class="col-md-6">
                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('finishedProductDefaultStatus')}" >
                    <label for="finishedProductDefaultStatus"><g:message code="form.field.finishedProductDefaultStatus.label" /></label>
                    <select  id="finishedProductDefaultStatus" name="finishedProductDefaultStatus" ng-model="ctrl.selectedBOM.finishedProductDefaultStatus" class="form-control" tabindex="2" required>
                        <option ng-repeat="option in ctrl.inventoryStatusOptions" value="{{option.optionValue}}">{{option.description}}</option>
                    </select>

                    <div class="my-messages" ng-messages="ctrl.editBOMForm.finishedProductDefaultStatus.$error" ng-if="ctrl.showBOMMessages('finishedProductDefaultStatus')">
                        <div class="message-animation" ng-message="required">
                            <strong><g:message code="required.error.message" /></strong>
                        </div>
                    </div>
                </div>                

                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('productionUom')}" >
                    <label for="productionUom" ><g:message code="form.field.productionUom.label" /></label>
                    <select name="productionUom" id="productionUom" ng-model="ctrl.selectedBOM.productionUom" class="form-control" ng-change="ctrl.selectCase()" ng-disabled="ctrl.disableProductionUom" tabindex="6" required>
                        <option ng-repeat="option in data.availableOptions" ng-value="option.id">{{option.name}}</option>
                    </select>
                    <div class="my-messages" ng-messages="ctrl.editBOMForm.productionUom.$error" ng-if="ctrl.showBOMMessages('productionUom')">
                        <div class="message-animation" ng-message="required">
                            <strong><g:message code="required.error.message" /></strong>
                        </div>
                    </div>
                </div>                
            </div>
                <br style="clear: both;"/>


                <div class="panel-footer">
                    <div class="pull-left">
                        <button class="btn btn-default" type="button" ng-click="ctrl.cancelEditBOM()"><g:message code="default.button.cancel.label" /></button>
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
            <form name="ctrl.bOMSearchForm"  ng-submit="ctrl.bOMSearch()">
                <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                    <!-- START Wizard Step inputs -->
                    <div>
                        <fieldset>
                            <!-- START row -->
                            <div class="row">

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.kittedItem.label" /></label>
                                        <div class="controls">
                                            <input type="text" name="itemIdSearch" placeholder="Item Id or Description" class="form-control"
                                                   ng-blur="" ng-model="ctrl.searchBOM.itemId" >
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="pull-left" style="margin-top: 15px;">
                                        <button class="btn btn-primary findBtn" type="submit">
                                            <g:message code="default.button.searchBOM.label" />
                                        </button>
                                    </div>
                                </div>
                            </div>

                        </fieldset>
                        <br style="clear:both;"/> 
                    </div>
                    <!-- END Wizard Step inputs -->
                </div>
            </form>
        </div>
    </div>
    <!-- END search panel -->
    <br style="clear:both;"/>

    <div class="col-lg-3 panel-body table-responsive table-bordered" style="background-color: #fff;">
        <table class="table table-bordered">
            <tbody>
                <tr ng-repeat="bom in ctrl.bOMList" ng-if = "ctrl.bOMList.length > 0">
                    <td ng-class="{ 'selected-class-name': bom.itemId == ctrl.selectedItemId }">
                        <div class="media">
                            <div class="media-body">


                                <%-- ****************** Selecting Area Tab ****************** --%>

                                <a href = ''  ng-click="ctrl.getClickedBOM($index)">
                                    <h5 class="media-heading" >{{ bom.itemId }}</h5></a>

                                <%-- ****************** End of selecting Area Tab ****************** --%>

                            </div>
                        </div>
                    </td>
                </tr>
                <tr ng-if = "ctrl.bOMList.length == 0">
                    <td>
                        <div class="media">
                            <div class="media-body">
                                <h5 class="media-heading" >No Bill Of Materials Found.</h5>
                            </div>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="col-lg-9">
        <!-- START panel-->
        <div class="panel panel-default">
            <div class="panel-body" style="overflow:hidden;">
                <!-- Nav tabs -->
                <ul class="nav nav-tabs" ng-if="ctrl.bOMList.length > 0">                      
                    <li id="liComponents" class="active"><a href="#components" data-toggle="tab"><g:message code="default.component.tab.label" /></a></li>
                    <li id="liInstructions"><a href="#instructions" data-toggle="tab"><g:message code="default.instructions.tab.label" /></a></li>
                </ul>
                <ul class="nav nav-tabs" ng-if="ctrl.bOMList.length == 0">                      
                    <li id="liComponents" class="disabled"><a href="" data-toggle="tab"><g:message code="default.component.tab.label" /></a></li>
                    <li id="liInstructions" class="disabled"><a href="" data-toggle="tab"><g:message code="default.instructions.tab.label" /></a></li>
                </ul>                
                <!-- Tab panes -->
                <div class="tab-content">
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
                                             
                        <div ng-hide="ctrl.bOMList.length == 0" style="float: left;">
                            <div class="form-group">
                                <div><h4><g:message code="form.field.kittedItem.label" />&emsp;:&emsp;{{ctrl.selectedItemId}}</h4></div>
                            </div>
                        </div>

                        <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">


                            <button ng-hide="ctrl.bOMList.length == 0" type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ctrl.showComponentsCreateForm()">
                                <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                <g:message code="default.button.createComponent.label" />
                            </button>
                        </a>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                        %{--Start Display A BOM Details--}%

                        <div ng-show="ctrl.isShowBOMDetails" ng-hide="ctrl.bOMList.length == 0">
                            <div class="col-md-6">
                                <div>
                                    <div class="label-desc-order"><g:message code="form.field.itemDescription.label" /></div>
                                    <div class="label-content">: {{ctrl.selectedBOM.itemDescription}}</div>
                                    <br style="clear: both;"/>
                                </div>
                                <div>
                                    <div class="label-desc-order"><g:message code="form.field.defaultBOMProductionQuantity.label" /></div>
                                    <div class="label-content">: {{ctrl.selectedBOM.defaultProductionQuantity}}</div>
                                    <br style="clear: both;"/>
                                </div>        
                            </div>
                            <div class="col-md-6">
                                <div>
                                    <div class="label-desc-order"><g:message code="form.field.finishedProductDefaultStatus.label" /></div>
                                    <div class="label-content">: {{ctrl.selectedBOM.finishedProductDefaultStatusDesc}}</div>
                                    <br style="clear: both;"/>
                                </div>
                                
                                <div>
                                    <div class="label-desc-order"><g:message code="form.field.productionUom.label" /></div>
                                    <div class="label-content">: {{ctrl.selectedBOM.productionUom}}</div>
                                    <br style="clear: both;"/>
                                </div>    
                            </div>

                            <br style="clear: both;">
                            <br style="clear: both;">
                            <div class="col-md-6" style="float: right;">
                                <div class="col-md-3" style="width: 130px;float: right;" >
                                <button type="button" class="btn btn-primary editOrdBtn" ng-click="ctrl.showEditBOMForm()" >
                                    <em class="fa fa-edit fa-fw mr-sm"></em>Edit
                                </button>
                                </div>
                                <div class="col-md-3" style="width: 150px;float: right;">
                                <button type="button" class="btn btn-default delOrdBtn" ng-click="ctrl.deleteBOM()" >
                                    <em class="fa fa-trash-o fa-fw mr-sm"></em><g:message code="default.button.delete.label" />
                                </button>
                                </div>
                            </div>
                        <br style="clear: both;"/>
                        </div>
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
                                                <label><g:message code="form.field.item.label" /></label>
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
                                                <label><g:message code="form.field.item.label" /></label>
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
                        <div ng-hide="ctrl.bOMList.length == 0" id="grid1" ui-grid="gridBOMComponents" ui-grid-exporter  ui-grid-pagination ui-grid-resize-columns class="grid">
                            <div class="noLocationMessage" ng-if="gridBOMComponents.data.length == 0"><g:message code="component.grid.noData.message" /></div>
                        </div>
                    </p>
                    <br style="clear: both;"/>

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

                            <div ng-hide="ctrl.bOMList.length == 0" style="float: left;">
                                <div class="form-group">
                                    <div><h4><g:message code="form.field.kittedItem.label" />&emsp;:&emsp;{{ctrl.selectedItemId}}</h4></div>
                                </div>

                            </div>
                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">


                                <button ng-hide="ctrl.bOMList.length == 0" type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ctrl.showInstructionCreateForm()">
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

                                                <div class="form-group" ng-class="{'has-error':ctrl.createInstructionForm.instructionId.$touched && ctrl.upddateComponentForm.instructionId.$invalid}">
                                                    <label for="instructionId"><g:message code="form.field.instructionId.label" /></label>
                                                    <input id="instructionId" name="instructionId" class="form-control" type="text"
                                                           ng-model="ctrl.newInstruction.instructionId" ng-model-options="{ updateOn : 'default blur' }"/>

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
                                                           ng-model="ctrl.editInstruction.instructionId" ng-model-options="{ updateOn : 'default blur' }" />

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
                                <div ng-hide="ctrl.bOMList.length == 0" id="grid1" ui-grid="gridBOMInstructions" ui-grid-exporter  ui-grid-pagination ui-grid-resize-columns class="grid">
                                    <div class="noLocationMessage" ng-if="gridBOMInstructions.data.length == 0"><g:message code="instruction.grid.noData.message" /></div>
                                </div>
                                </p>


                                <%-- ****************** END OF instruction Grid  ****************** --%>
                    </div>

                </div>
            </div>
            <!--/.panel-body -->
        </div>

        <!-- END panel-->

    </div>

    <!-- Modal for Adding new Attribute-->
    <div id="addNewAttribute" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Add New Storage Attribute</h4>
                </div>
                <div class="modal-body">
                    <label>Storage Attribute :</label>
                    <input id="addNewStrgAttribute" name="addNewStrgAttribute" class="form-control" type="text" ng-model="ctrl.addNewStrgAttribute" placeholder = "Enter A New Storage Attribute"/>

                </div>
                <div class="modal-footer">
                    <button type="button"  id = "strgAttributeCancelSave" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "strgAttributeSave" class="btn btn-primary"><g:message code="default.button.add.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <div id="addNewAttributeEdit" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Add New Storage Attribute</h4>
                </div>
                <div class="modal-body">
                    <label>Storage Attribute :</label>
                    <input id="addNewStrgAttributeEdit" name="addNewStrgAttribute" class="form-control" type="text" ng-model="ctrl.addNewStrgAttributeEdit" placeholder = "Enter A New Storage Attribute"/>

                </div>
                <div class="modal-footer">
                    <button type="button"  id = "strgAttributeCancelSaveEdit" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "strgAttributeSaveEdit" class="btn btn-primary"><g:message code="default.button.add.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <div id="binAreaWarning" class="modal fade" role="dialog" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Confirmation</h4>
                </div>
                <div class="modal-body">
                    <p>Some of the locations in this area has got pallets or cases, if this area changed as a "bin" area the pallets and cases will be disappear.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" ng-disabled="ctrl.disableConfirmBinArea"><g:message code="default.button.cancel.label"/></button>
                    <button type="button" class="btn btn-primary" ng-click="ctrl.changeAreaToBin()" ng-disabled="ctrl.disableConfirmBinArea">{{ctrl.confirmBinAreaBtnText}}</button>
                </div>
            </div>
        </div>
    </div>
    <div id="itemLowestUOMInCase" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Bin Location Warning</h4>
                </div>
                <div class="modal-body">
                    This area contains lowest UOM CASE inventory, this area cannot be changed as a "bin" area. 
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <!-- import CSV dialog model -->
    <div id="importLocation" class="modal fade" role="dialog">
    <div class="receipt-modal-dialog modal-dialog"  style="width: 100%;">
        <div class="receipt-modal-content modal-content">
            <div class="receipt-modal-header modal-header">
                <button type="button" class="receipt-close close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <br style="clear: both;"/>

                <div class="panel-heading">
                    <div class="receipt-panel-title panel-title"><h4>Import CSV</h4></div>
                </div>

                </div>

                <div class="receipt-modal-body modal-body">

                    <p>Dowload a sample location CSV file <g:link controller="location" action="downloadLocationCsvFile">Here.</g:link></p>
                    <br style="clear: both;">
                    <input type="file"  id="csvImport" /> <span ng-show="loadAnimPickListSearch"><img src="${request.contextPath}/foysonis2016/app/img/loading.gif"/></span>
                    <br style="clear: both;"/>

                    <div id="grid1" ui-grid="gridOptions" ui-grid-exporter ui-grid-pinning ui-grid-resize-columns  class="csvGrid"></div>
                    <br style="clear: both;"/>

                    <button type="button" class="btn btn-primary" id ="importCSVButton" ng-show="ctrl.uploadCSV">Import CSV</button>

                </div>


                <div class="receipt-modal-footer modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                </div>

            </div>
        </div>
    </div>   
    <!-- end import CSV dialog model -->
    <div id="dvPreventAddLocation" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Confirmation</h4>
                </div>
                <div class="modal-body">
                    <p>{{ctrl.errorMsgForLocationCreate}}</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
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
<div id="dvDeleteBOMWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure want to delete this Bill of material ?</p>
                <p>If bill of material is deleted, The corresponding component and instruction will also be deleted along with it. </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "bomDeleteButton" class="btn btn-primary"><g:message code="default.button.delete.label" /></button>
            </div>
        </div>
    </div>
</div>

<div id="dvDeleteAreaWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Alert</h4>
            </div>
            <div class="modal-body">
                <p>You can not delete this area as it contains locations.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>

<div id="deleteLocationWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Alert</h4>
            </div>
            <div class="modal-body">
                <p>You can not delete this Location as it contains inventory.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>

<!-- Location unblock confirmation dialog model -->
<div id="locationUnBlock" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p><b>Are you sure want to Unblock this Location ?</b></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "locationUnBlockButton" class="btn btn-primary">UnBlock</button>
            </div>
        </div>
    </div>
</div>
<!-- end Location unblock confirmation dialog model -->


<!-- Location block confirmation dialog model -->
<div id="locationBlock" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p><b>Are you sure want to Block this Location ?</b></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "locationBlockButton" class="btn btn-primary">Block</button>
            </div>
        </div>
    </div>
</div>
<!-- end Location block confirmation dialog model -->


<asset:javascript src="datagrid/admin-bill-of-material.js"/>

<script type="text/javascript">
    var dvAdminBillOfMaterial = document.getElementById('dvAdminBillOfMaterial');
    angular.element(document).ready(function() {
        angular.bootstrap(dvAdminBillOfMaterial, ['adminBillOfMaterial']);
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
