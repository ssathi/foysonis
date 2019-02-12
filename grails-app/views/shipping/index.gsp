<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2016-03-31
  Time: 3:05 PM
--%>
<html>
<head>
    <meta name="layout" content="foysonis2016"/>
    <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>


    <style>


    ul[dnd-list] * {
        pointer-events: none;
    }

    ul[dnd-list], ul[dnd-list] > li {
        pointer-events: auto;
        position: relative;
    }



    /**
     * The dnd-list should always have a min-height,
     * otherwise you can't drop to it once it's empty
     */
    ul[dnd-list] {
        min-height: 42px;
        padding-left: 0px;
    }

    /**
     * The dndDraggingSource class will be applied to
     * the source element of a drag operation. It makes
     * sense to hide it to give the user the feeling
     * that he's actually moving it.
     */
    ul[dnd-list] .dndDraggingSource {
        display: none;
    }

    /**
     * An element with .dndPlaceholder class will be
     * added to the dnd-list while the user is dragging
     * over it.
     */
    ul[dnd-list] .dndPlaceholder {
        display: block;
        background-color: #ddd;
        min-height: 42px;
    }

    /**
     * The dnd-lists's child elements currently MUST have
     * position: relative. Otherwise we can not determine
     * whether the mouse pointer is in the upper or lower
     * half of the element we are dragging over. In other
     * browsers we can use event.offsetY for this.
     */
    ul[dnd-list] li {
        background-color: #fff;
        border: 1px solid #ddd;
        border-top-right-radius: 4px;
        border-top-left-radius: 4px;
        display: block;
        padding: 10px 15px;
        margin-bottom: -1px;
        cursor: pointer;
    }

    /**
     * Show selected elements in green
     */
    ul[dnd-list] li.selected {
        background-color: #dff0d8;
        color: #3c763d;
    }



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
        /*width: 1158px;*/
        width: 100%;
    }

    .grid1 {
        height:420px;
        /*width: 1158px;*/
        width: 100%;
    }

    .grid-align {
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

    hr {
        border-style: solid;
        border-width: 2px;
    }

    .dataRow{
        padding-left: 1px;
        padding-right: 5px;
    }

    #streetAddress{
        resize: none;
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

    .nav-tabs > li > a.moveTabs{
        background-color: #878a8d;
        color: #ffffff;
        height: 37px;
        width: 180px;
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

    </style>

</head>

<body>


<div ng-cloak class="row" id="dvShipping" ng-controller="shippingCtrl as ctrl">
    <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 45px; padding-bottom: 5px;" src="/foysonis2016/app/img/shippingDock-Header.svg"></em>&emsp;&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">Shipping Dock
</span></div>
    <br style="clear: both;">
    <br style="clear: both;">
    <div class="col-lg-12">
        <!-- START panel-->
        <div class="panel panel-default">
            <div class="panel-body">

                <%-- **************************** Start of Find Shipping **************************** --%>
                <br style="clear: both;"/>

                %{-- start tab--}%
                <ul class="nav nav-tabs">
                    <li id="liAdjReason" class="active"><a class="moveTabs moveFirstTab" href="#activeShipments" data-toggle="tab" ng-click = "ctrl.getAllPalletPick()"><g:message code="default.activeShipments.tab.label" /></a></li>
                    <li id="liItmcat"><a class="moveTabs moveLastTab" href="#activeTrucks" data-toggle="tab" ng-click = "ctrl.getAllReplens()"><g:message code="default.activeTrucks.tab.label"/></a></li>
                </ul>
                <div class="tab-content">

                    <%--  ****************** Start Tab****************** --%>
                    <!--Start Active Shipments Tab -->

                    <div id="activeShipments" class="tab-pane fade in active">

                        <br style="clear: both;"/>

                        <!-- START active shipments search panel-->
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <a href="javascript:void(0);" ng-click = "ctrl.showHideSearch()">
                                    <legend><em ng-if = "ctrl.isOrderSearchVisible" class="fa fa-minus-circle fa-fw mr-sm"></em>
                                        <em ng-if = "!ctrl.isOrderSearchVisible" class="fa fa-plus-circle fa-fw mr-sm"></em>
                                        <g:message code="default.search.label" />
                                    </legend></a>
                            </div>
                            <div class="panel-body" ng-show= "ctrl.isOrderSearchVisible">
                                <form name="ctrl.searchForm"  ng-submit="ctrl.search()">
                                    <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                                        <!-- START Wizard Step inputs -->
                                        <div>
                                            <fieldset>
                                                <!-- START row -->
                                                <div class="row">

                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label><g:message code="form.field.orderNo.label" /></label>
                                                            <div class="controls">
                                                                <input type="text" id="orderNumber" name="orderNumber" placeholder="Order Number" class="form-control" value="${orderNumber}"
                                                                       ng-model="ctrl.orderNumber" capitalize>

                                                            </div>

                                                        </div>
                                                    </div>


                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label><g:message code="form.field.shipmentId.label" /></label>
                                                            <div class="controls">
                                                                <input type="text" name="shipmentId" placeholder="Shipment Id" class="form-control" value="${shipmentId}"
                                                                       ng-model="ctrl.shipmentId" capitalize>
                                                            </div>
                                                        </div>
                                                    </div>


                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label><g:message code="form.field.truckNo.label" /></label>
                                                            <div class="controls">
                                                                <input type="text" name="truckNumber" placeholder="Truck Number" class="form-control" value="${truckNumber}"
                                                                       ng-model="ctrl.truckNumber">
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label><g:message code="form.field.KittingOrd.kittingOrderNumber.label" /></label>
                                                            <div class="controls">
                                                                <input type="text" id="kittingOrderNumber" name="kittingOrderNumber" placeholder="Kitting Order Number" class="form-control" value="${kittingOrderNumber}"
                                                                       ng-model="ctrl.kittingOrderNumber" capitalize>

                                                            </div>

                                                        </div>
                                                    </div>


                                                    <!-- <div class="col-md-5">
                                                        <div class="form-group">
                                                            <label><g:message code="default.inventoryId.label" /></label>
                                                            <div class="controls">
                                                                        <input type="text" name="inventoryIdSearch" placeholder="Inventory Id" class="form-control"
                                                                       ng-model="ctrl.inventoryIdSearch">
                                                            </div>
                                                        </div>
                                                    </div> -->


                                                    <!-- <div class="col-md-5">
                                                        <div class="form-group">
                                                            <label><g:message code="form.field.notes.label" /></label>
                                                            <div class="controls">
                                                                        <textarea rows="4" cols="6" class="form-control" ng-model="ctrl.itemNoteSearch" placeholder="Enter Notes Here........." tabindex="10"></textarea>
                                                            </div>
                                                        </div>
                                                    </div> -->


                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label><g:message code="form.field.smallPackage.label" /></label>
                                                            <div class="controls">
                                                                <div class="checkbox c-checkbox">
                                                                    <label>
                                                                        <input name="smallPackage" type="checkbox" ng-model="ctrl.smallPackage" value="${smallPackage}">
                                                                        <span class="fa fa-check"></span>
                                                                    </label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>


                                                    <br style="clear: both;"/>

                                                    <div class="col-md-3">
                                                        <div class="form-group">
                                                            <label>&nbsp;</label>
                                                            <div class="controls">
                                                                <div class="checkbox c-checkbox">
                                                                    <label>
                                                                        <input name="CompletedDateRange" type="checkbox" ng-model="ctrl.completedDateRange"  value="${completedDateRange}"
                                                                               ng-click="ctrl.showCompletedDateRange()">
                                                                        <span class="fa fa-check"></span><g:message code="form.field.showCompleteShipment.label" /></label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>


                                                    <div class="col-md-2" ng-show="ctrl.displayCompletedDateRange">
                                                        <div class="form-group">
                                                            <label></label>
                                                            <select id="completedDate" name="completedDate" ng-model="ctrl.completedDate" class="form-control" value="${completedDate}">
                                                                <option value=""><g:message code="form.dropdown.today.label" /></option>
                                                                <option value="last7Days"><g:message code="form.dropdown.Last7Days.label" /></option>
                                                                <option value="last14Days"><g:message code="form.dropdown.Last14Days.label" /></option>
                                                                <option value="last30Days"><g:message code="form.dropdown.Last30Days.label" /></option>
                                                            </select>

                                                        </div>
                                                    </div>

                                                    <br style="clear: both;"/>
                                                    <br style="clear: both;"/>

                                                </div>
                                                <!-- END row -->

                                            </fieldset>

                                            <div class="pull-right">
                                                <button type="submit" class="btn btn-primary findBtn">
                                                    <g:message code="default.button.searchShipment.label" />
                                                </button>
                                            </div>

                                        </div>
                                        <!-- END Wizard Step inputs -->
                                    </div>
                                </form>
                            </div>
                        </div>
                        <!-- END active shipments search panel -->
                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showEasyPostManifestedPrompt">
                            This shipment has been manifested through EasyPost
                        </div>
                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showEasyPostVoidPrompt">
                            This shipment has been removed from EasyPost
                        </div>

                        <br style="clear: both;"/>

                        <div id="grid1" ui-grid="gridShipment" ui-grid-exporter  ui-grid-pagination ui-grid-expandable ui-grid-resize-columns ui-grid-auto-resize class="grid">
                            <div class="noItemMessage" ng-if="gridShipment.data.length == 0"><g:message code="activeShipments.grid.noData.message" /></div>
                        </div>

                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                    </div>

                    <!-- End Active Shipments Tab -->


                    <!--Start Active Trucks Tab -->

                    <div id="activeTrucks" class="tab-pane fade">
                        <br style="clear: both;"/>

                        <!-- START active trucks search panel-->
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <a href="javascript:void(0);" ng-click = "ctrl.showHideTruckSearch()">
                                    <legend><em ng-if = "ctrl.isTruckSearchVisible" class="fa fa-minus-circle fa-fw mr-sm"></em>
                                        <em ng-if = "!ctrl.isTruckSearchVisible" class="fa fa-plus-circle fa-fw mr-sm"></em>
                                        <g:message code="default.search.label" />
                                    </legend></a>
                            </div>
                            <div class="panel-body" ng-show= "ctrl.isTruckSearchVisible">
                                <form name="ctrl.searchTrackForm"  ng-submit="ctrl.searchTrack()">
                                    <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                                        <!-- START Wizard Step inputs -->
                                        <div>
                                            <fieldset>
                                                <!-- START row -->
                                                <div class="row">

                                                    <div class="col-md-5">
                                                        <div class="form-group">
                                                            <label><g:message code="form.field.truckNo.label" /></label>
                                                            <div class="controls">
                                                                <input type="text" id="truckNumber" name="truckNumber" placeholder="Truck Number" class="form-control" ng-blur=""
                                                                       ng-model="ctrl.truckNumber">
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-3">
                                                        <div class="form-group">
                                                            <label>&nbsp;</label>
                                                            <div class="controls">
                                                                <div class="checkbox c-checkbox">
                                                                    <label>
                                                                        <input name="dispatchedDateRange" type="checkbox" ng-model="ctrl.dispatchedDateRange"  value="${dispatchedDateRange}"
                                                                               ng-click="ctrl.showDispatchedDateRange()">
                                                                        <span class="fa fa-check"></span><g:message code="form.field.showDispatchedTrucks.label" /></label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>


                                                    <div class="col-md-2" ng-show="ctrl.displayDispatchedDateRange">
                                                        <div class="form-group">
                                                            <label></label>
                                                            <select id="dispatchedDate" name="dispatchedDate" ng-model="ctrl.dispatchedDate" class="form-control" value="${dispatchedDate}">
                                                                <option value=""><g:message code="form.dropdown.Last3Days.label" /></option>
                                                                <option value="last7Days"><g:message code="form.dropdown.Last7Days.label" /></option>
                                                                <option value="last14Days"><g:message code="form.dropdown.Last14Days.label" /></option>
                                                                <option value="last30Days"><g:message code="form.dropdown.Last30Days.label" /></option>
                                                            </select>

                                                        </div>
                                                    </div>

                                                    <br style="clear: both;"/>
                                                    <br style="clear: both;"/>

                                                </div>
                                                <!-- END row -->

                                            </fieldset>

                                            <div class="pull-right">
                                                <button type="submit" class="btn btn-primary findBtn">
                                                    <g:message code="default.button.searchTruck.label" />
                                                </button>
                                            </div>

                                        </div>
                                        <!-- END Wizard Step inputs -->
                                    </div>
                                </form>
                            </div>
                        </div>
                        <!-- END active trucks search panel -->

                        <br style="clear: both;"/>

                        <div id="grid3" ui-grid="gridTruck" ui-grid-exporter  ui-grid-pagination ui-grid-expandable ui-grid-resize-columns ui-grid-auto-resize class="grid">
                            <div class="noItemMessage" ng-if="gridTruck.data.length == 0"><g:message code="activeTrucks.grid.noData.message" /></div>
                        </div>

                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                    </div>

                    <!-- End Active Trucks Tab -->

                    <%-- ****************** END Tab****************** --%>

                </div>
                %{--end tab--}%
            </div>
        </div>
        <!-- END panel-->

    </div>


    <!-- start pick work view popup -->
    <div id="pickWorkView" class="modal fade" role="dialog">
        <div class="modal-dialog"  style="width: 80%;">
            <div class="modal-content">

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <div class="panel-heading">
                        <h4><g:message code="default.dialog.pickWorkTop.label" /></h4>
                    </div>
                </div>

                <div class="modal-body">

                    <div ng-if="ctrl.viewGrid" id="grid2" ui-grid="gridPickWork" ui-grid-exporter   ui-grid-pagination ui-grid-resize-columns class="grid1">
                        <div class="noItemMessage" ng-if="gridPickWork.data.length == 0"><g:message code="pickWork.grid.noData.message" /></div>
                    </div>

                    <br style="clear: both;"/>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <!-- end pick work view popup -->

    <!-- start inventory view popup -->
    <div id="inventoryView" class="modal fade" role="dialog">
        <div class="modal-dialog"  style="width: 90%;">
            <div class="modal-content">

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <div class="panel-heading">
                        <h4><g:message code="default.inventoryTop.label" /></h4>
                        %{--<h4>Inventory</h4>--}%
                    </div>
                </div>

                <div class="modal-body">

                    %{--<div ng-if="ctrl.viewInventoryGrid" id="grid4" ui-grid="gridInventory" ui-grid-exporter ui-grid-selection ui-grid-pagination ui-grid-pinning ui-grid-expandable class="grid">--}%
                    %{--<div class="noItemMessage" ng-if="gridInventory.data.length == 0">No Inventory Found.</div>--}%
                    %{--</div>--}%

                    <div ng-if="ctrl.viewInventoryGrid" id="grid4" ui-grid="gridInventory" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-resize-columns  class="grid">
                        <div class="noItemMessage" ng-if="gridInventory.data.length == 0"><g:message code="inventory.grid.noData.message" /></div>
                    </div>

                    <br style="clear: both;"/>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <!-- end inventory view popup -->



    <!--Start Edit Shipment-->
    <div id="editShipment" class="modal fade" role="dialog" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" ng-click = "ctrl.closeShipmentModel()" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><g:message code="default.button.editShipment.label" /></h4>
                </div>
                <div class="modal-body">

                    <div style="padding: 20px 0px; font-size: 14px; font-weight: bold;">
                        <div class="col-md-3">
                            <g:message code="form.field.orderNo.label" />:
                        </div>
                        <div class="col-md-3">
                            {{ctrl.selectedOrderNumber}}
                        </div>
                        <div class="col-md-3">
                            <g:message code="form.field.shipmentId.label" />:
                        </div>
                        <div class="col-md-3">
                            {{ctrl.shipmentIdForEdit}}
                        </div>
                    </div>

                    <div style="padding: 20px 0px;">

                        <form name="ctrl.editShipmentForm" ng-submit="ctrl.updateShipment()" novalidate >


                        <div style="padding: 5px 0px; font-size: 14px; font-weight: bold;">
                            <div class="col-md-3" style="padding-right: 0px; margin-right: 0px;">
                                Billing Contact:
                            </div>
                            <div class="col-md-3" style="padding-left: 0px; margin-left: 0px;">
                                {{ctrl.billingContact}}
                            </div>

                            <div class="col-md-2" >
                                Company:
                            </div>
                            <div class="col-md-4" >
                                {{ctrl.billingCompany}}
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
                                    <div class="col-md-6" style="padding: 2px 0px;"  ng-class="{'has-error':ctrl.editShipmentForm.shippingStreetAddress.$touched && ctrl.editShipmentForm.shippingStreetAddress.$invalid}">
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
                                        <div class="my-messages" ng-messages="ctrl.editShipmentForm.shippingState.$error" ng-if="ctrl.editShipmentForm.shippingState.$touched || ctrl.editShipmentForm.$submitted">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message" /></strong>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="col-md-6" style="padding: 2px;">

                                        <label for="state"><g:message code="form.field.shipping.label" /> <g:message code="form.field.state.label" /></label>
                                        <div class="controls">
                                            <input id="state" name="shippingState" class="form-control" type="text" ng-model="ctrl.customerShippingState" ng-model-options="{ updateOn : 'default blur' }" placeholder="State/Province" required />
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
                                        <select  id="country" name="shippingCountry" ng-model="ctrl.customerShippingCountry" class="form-control" required >
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
                                <g:message code="form.field.carrierCode.label" />:
                            </div>
                            <div class="col-md-4">
                                <select name="carrierCode" id="carrierCode" ng-model="ctrl.carrierCode" class="form-control" ng-change="ctrl.loadServiceForCarrier()">
                                    <option ng-repeat="option in ctrl.carrierCodeOptions" value="{{option.optionValue}}" >{{option.description}}</option>
                                </select>
                            </div>

                            <div class="col-md-2">
                                <g:message code="form.field.smallPackage.label" />:
                            </div>
                            <div class="col-md-4">
                                <input type="checkbox" name="smallPackage" id="smallPackage" value=""
                                       ng-model="ctrl.smallPackage">
                            </div>

                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="col-md-2" ng-show="ctrl.smallPackage">
                                <g:message code="form.field.serviceLevel.label" />:
                            </div>
                            <div class="col-md-4" ng-show="ctrl.smallPackage">
                                <select name="serviceLevel" id="serviceLevel" ng-model="ctrl.serviceLevel" class="form-control">
                                    <option ng-repeat="option in ctrl.serviceLevelOptions" >{{option}}</option>
                                </select>
                            </div>

                            <div class="col-md-2" ng-show="!ctrl.smallPackage">
                                <g:message code="form.field.truckNo.label" />:
                            </div>
                            <div class="col-md-4" ng-show="!ctrl.smallPackage">
                                <input type="text" name="truckNumber" id="truckNumber" class="form-control"
                                       ng-model="ctrl.truckNumber" ng-blur="ctrl.validateTruckNumber(ctrl.truckNumber)" placeholder="(Optional)" capitalize >

                                        <div class="my-messages"  ng-messages="ctrl.editShipmentForm.truckNumber.$error"
                                             ng-if="ctrl.truckValidationError">
                                            <div class="message-animation" >
                                                <strong>{{ctrl.truckValidationErrorMsg}}</strong>
                                            </div>
                                        </div>

                            </div>

                            <div class="col-md-2">
                                <g:message code="form.field.trackingNo.label" />:
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
                            </div>  -->  
                            <div class="col-md-4">
                            <div ng-init="ctrl.getPopoverTemplateUrlEdit = 'notesPopoverEdit'"></div>
                            <a href="javascript:void(0)" uib-popover-template="ctrl.getPopoverTemplateUrlEdit" popover-title=""  popover-append-to-body="true" popover-placement="top" popover-trigger="outsideClick">Enter here..</a> &emsp;

                                    <script type="text/ng-template" id="notesPopoverEdit">
                                        <div class="form-group">
                                          <label>Notes :</label>
                                          <textarea class='form-control' rows='5' id='notes' ng-model='ctrl.shipmentNotes' placeholder='Enter Note Here....' tabindex="8"></textarea>
                                        </div>
                                    </script> 
                            </div>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>
                            <div class="modal-footer">
                                <button class="btn btn-primary pull-right" type="submit" ><g:message code="default.button.update.label" /></button>
                                <button type="button" ng-click = "ctrl.closeShipmentModel()" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                            </div>

                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--Start Edit Shipment-->


    <!-- Shipment completion confirmation dialog model -->
    <div id="shipmentComplete" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><g:message code="default.dialog.confirmation.label" /></h4>
                </div>
                <div class="modal-body">

                    <div style="margin: 10px 0px 30px 0px; font-size: 14px;" ng-show="ctrl.orderNotes" >

                        <div class="col-md-2" style="text-align: left; padding: 0px; font-weight: bold;" >
                            Order Notes:
                        </div>
                        <div class="col-md-10">
                           {{ctrl.orderNotes}}
                        </div>
                    </div>                
                    <br style="clear: both;"/>
                    <p style="font-size: 16px;"><b><g:message code="shipment.complete.message" /></b></p>
                    <p><g:message code="shipment.completeSub.message" /></p>
                    <div style="margin: 10px 0px 30px 0px; font-size: 14px;" ng-show="ctrl.showNoOfLabelField">
                        <div class="col-md-2" style="text-align: left; padding: 0px; font-weight: bold;">
                            No Of Labels :
                        </div>

                        <div class="col-md-4">
                            <input type="number" name="noOfLabels" id="noOfLabels" class="form-control" ng-model="ctrl.noOfLabels"
                                   placeholder="No Of Labels" ng-model-options="{ updateOn : 'default blur' }"/>
                        
                            <div class="my-messages"  ng-messages=""  ng-if="ctrl.noOfLabels < 0">
                                <div class="message-animation" >
                                    <strong>The value should be positive.</strong>
                                </div>
                            </div>

                        </div>
                         
                    </div>   
                    <br style="clear: both;"/>
                    <br style="clear: both;"/>                                        
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "shipmentCompleteButton" class="btn btn-primary"><g:message code="default.button.complete.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <!-- end Shipment completion confirmation dialog model -->

    <!-- Start Tracking No Required dialog model -->
    <div id="trackingNoRequired" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><g:message code="trackingNo.required.warning" /></h4>
                </div>
                <div class="modal-body">
                    <p><b><g:message code="trackingNo.required.message" /></b></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" ng-click = "ctrl.editShipmentTrackingNo()" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <!-- end Tracking No Required dialog model -->


    <!--Start Edit Shipment line qty-->
    <div id="shipmentLineQty" class="modal fade" role="dialog" >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" ng-click = "ctrl.closeShippedQtyModel()" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><g:message code="default.dialog.editQtyTop.label" /></h4>
                </div>
                <div class="modal-body">

                    <div style="padding: 20px 0px; font-size: 14px; font-weight: bold;">
                        <div class="col-md-3">
                            <g:message code="form.field.shipmentId.label" />:
                        </div>
                        <div class="col-md-3">
                            {{ctrl.shipmentIdForEdit}}
                        </div>

                        <div class="col-md-3">
                            <g:message code="form.field.shipmentLine.label" />:
                        </div>
                        <div class="col-md-3">
                            {{ctrl.shipmentLineIdForEdit}}
                        </div>
                    </div>

                    <div style="padding: 20px 0px;">

                        <form name="ctrl.editShippedQtyForm" ng-submit="ctrl.updateShippedQty()" novalidate >

                            <div class="col-md-2">
                                <g:message code="form.field.shippedQty.label" />:
                            </div>
                            <div class="col-md-4">
                                <input type="number" name="shippedQuantity" id="shippedQuantity" class="form-control"
                                       ng-model="ctrl.shippedQuantity" placeholder="Qty" ng-model-options="{ updateOn : 'default blur' }" ng-blur="">
                            </div>

                            <div class="col-md-6" ng-show="ctrl.shippedQtyError">
                                <div class="form-group" style="text-align: left;color: red;" role="alert">
                                    %{--<p><g:message code="form.shippedQty.error.message" /></p>--}%
                                    {{ctrl.shippedQtyError}}
                                </div>
                            </div>

                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="modal-footer">
                                <button class="btn btn-primary pull-right" type="submit" ><g:message code="default.button.update.label" /></button>
                                <button type="button" ng-click = "ctrl.closeShippedQtyModel()" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                            </div>

                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--Start Edit Shipment line qty-->


    <!--Start Shipment load-->
    <div id="loadShipmentLine" class="modal fade" role="dialog" >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" ng-click = "ctrl.closeLoadModel()" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><g:message code="default.dialog.loadTop.label" /></h4>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger message-animation" role="alert" ng-if="ctrl.showShipTrailerErrorPrompt">
                        {{ctrl.trailerErrorMsg}}
                    </div>

                    <div style="padding: 20px 0px; font-size: 14px;">
                        <div class="col-md-2" style="text-align: left; padding: 0px; font-weight: bold;">
                            <g:message code="form.field.orderNo.label" />:
                        </div>
                        <div class="col-md-4" style="text-align: left;">
                            {{ctrl.selectedOrderNumber}}
                        </div>
                        <div class="col-md-2" style="text-align: left; padding: 0px; font-weight: bold;">
                            <g:message code="form.field.shipmentId.label" />:
                        </div>
                        <div class="col-md-4" style=" text-align: left;">
                            {{ctrl.shipmentIdForEdit}}
                        </div>

                    </div>

                    <div style="padding: 20px 0px; font-size: 14px;" ng-show="ctrl.orderNotes">

                        <div class="col-md-2" style="text-align: left; padding: 0px; font-weight: bold;">
                            Order Notes:
                        </div>
                        <div class="col-md-10">
                            {{ctrl.orderNotes}}
                        </div>
                    </div>

                    <br style="clear: both;"/>

                    <div style="padding: 20px 0px;">

                        <form name="ctrl.loadForm" ng-submit="ctrl.updateLoad()" novalidate >

                            <div class="col-md-2" style="text-align: left; padding: 0px; font-weight: bold;">
                                <g:message code="form.field.truckNo.label" />:
                            </div>

                            <div class="col-md-5">
                                <input type="text" name="truckNumber" id="truckNumber" class="form-control" ng-model="ctrl.truckNumber"
                                       placeholder="Truck Number" ng-model-options="{ updateOn : 'default blur' }"/>
                            </div>

                            <div class="col-md-5" ng-show="ctrl.truckNoError">
                                <div class="form-group" style="text-align: left;color: red;" role="alert">
                                    %{--<p>This Truck Number Doesn't Match.</p>--}%
                                    <p><g:message code="truckNoMatch.error.message" /></p>
                                </div>
                            </div>

                            <div class="col-md-5" ng-show="ctrl.truckNoRequiredError">
                                <div class="form-group" style="text-align: left;color: red;" role="alert">
                                    <p><g:message code="required.error.message" /></p>
                                </div>
                            </div>
                            <div ng-show='ctrl.showNoOfLabelField' >
                                <br style="clear: both;"/>
                                <br style="clear: both;"/>
                                <div class="col-md-2" style="text-align: left; padding: 0px; font-weight: bold;">
                                    No Of Labels :
                                </div>

                                <div class="col-md-5">
                                    <input type="number" name="noOfLabels" id="noOfLabels" class="form-control" ng-model="ctrl.noOfLabels"
                                           placeholder="No Of Labels" min="0" ng-model-options="{ updateOn : 'default blur' }"/>
                                <div class="my-messages"  ng-messages="ctrl.loadForm.noOfLabels.$error"
                                                                 ng-if="ctrl.loadForm.noOfLabels.$error.min">
                                    <div class="message-animation" >
                                        <strong>The value should be positive.</strong>
                                    </div>
                                </div>  


                                </div>                                  
                            </div>                                                     

                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="modal-footer">
                                <button class="btn btn-primary pull-right" type="submit" ><g:message code="default.button.update.label" /></button>
                                <button type="button" ng-click = "ctrl.closeLoadModel()" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                            </div>

                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--Start Shipment load-->


    <!-- start void view popup -->
    <div id="voidShipment" class="modal fade" role="dialog">
        <div class="modal-dialog"  style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" ng-click = "ctrl.closeLocationModel()" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4><g:message code="default.dialog.voidTop.label" /></h4>
                    <br style="clear: both;"/>
                </div>
                <form name="ctrl.allocationCreateFrom" ng-submit="ctrl.saveAllocation()" novalidate >
                    <div class="modal-body">

                        <div class="col-md-12">
                            <div class="col-md-6">

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForAllocationCreate('locationId')}">
                                    <label for="locationId"><g:message code="form.field.stagingLocation.label" /></label>
                                    %{--<div auto-complete  source="loadCompanyLocations"  xxxx-list-formatter="customListFormatter"--}%
                                         %{--value-changed="ctrl.selectLocation(value)" style="z-index: 1000;">--}%
                                        %{--<input id="locationId" name="locationId" ng-model="ctrl.locationId"  ng-model-options="{ updateOn : 'default blur' }"--}%
                                               %{--placeholder="location Id" class="form-control"/>--}%

                                    %{--</div>--}%

                                    <div auto-complete  source="loadLocationAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars = '0'
                                         value-changed="ctrl.callback(value.location_id)" style="z-index: 1000;">
                                        <input id="locationId" name="locationId" ng-model="ctrl.locationId"  ng-model-options="{ updateOn : 'default blur' }"
                                               placeholder="location Id" class="form-control"/>
                                    </div>

                                </div>

                            </div>

                            <div class="col-md-6">
                                <button style="margin-left: 20px; margin-top: 22px" class="btn btn-primary" type="submit" ng-disabled = "!ctrl.locationId">
                                    Move
                                </button>
                            </div>

                        </div>

                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                    </div>

                </form>
            </div>
        </div>
    </div>
    <!-- end void view popup -->


    <!--Start packingSlip-->
    <div id="packingSlipView" name="packingSlipView" class="modal fade" role="dialog" >
        <div class="modal-dialog" style="width: 60%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" ng-click = "ctrl.closeShipmentModel()" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Packing Slip for Shipment</h4>
                </div>
                <div class="modal-body">

                    <div style="padding: 20px 0px; font-size: 14px; font-weight: bold;">

                        <div class="col-md-3">
                            Company Name:
                        </div>
                        <div class="col-md-3">
                            {{ctrl.companyNameForView}}
                        </div>
                        <div class="col-md-3">
                            Company ID:
                        </div>
                        <div class="col-md-3">
                            {{ctrl.companyIdForView}}
                        </div>


                        <br style="clear: both;"/>
                        <br style="clear: both;"/>


                        <div class="col-md-3">
                            Order Number:
                        </div>
                        <div class="col-md-3">
                            {{ctrl.OrderNumberForView}}
                        </div>
                        <div class="col-md-3">
                            Shipment ID:
                        </div>
                        <div class="col-md-3">
                            {{ctrl.shipmentIdForView}}
                        </div>
                    </div>

                    <div style="padding: 20px 0px;">



                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--end packingSlip-->


    <!--Start truck close confirmation dialog model -->
    <div id="truckClose" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><g:message code="default.dialog.confirmation.label" /></h4>
                </div>
                <div class="modal-body">
                    <p><b><g:message code="truck.close.message" /></b></p>
                    %{--<p><b>Are you sure want to close this truck?</b></p>--}%
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "truckCloseButton" class="btn btn-primary"><g:message code="default.button.close.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <!-- end truck close confirmation dialog model -->


    <!--Start truck reopen confirmation dialog model -->
    <div id="truckReOpen" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><g:message code="default.dialog.confirmation.label" /></h4>
                </div>
                <div class="modal-body">
                    <p><b><g:message code="truck.open.message" /></b></p>
                    %{--<p><b>Are you sure want to re open this truck?</b></p>--}%
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "truckReOpenButton" class="btn btn-primary"><g:message code="default.button.reopen.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <!-- end truck reopen confirmation dialog model -->


    <!--Start truck dispatch confirmation dialog model -->
    <div id="truckDispatch" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><g:message code="default.dialog.confirmation.label" /></h4>
                </div>
                <div class="modal-body">
                    <p><b><g:message code="truck.dispatch.message" /></b></p>
                    %{--<p><b>Are you sure want to dispatch this truck?</b></p>--}%
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "truckDispatchButton" class="btn btn-primary"><g:message code="default.button.dispatch.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <!-- end truck dispatch confirmation dialog model -->

    <!-- ****************** BOL Edit Screen ****************** -->
    <div id="checkBOL" class="modal fade" role="dialog">
        <div class="modal-dialog"  style="width: 95%;">
            <div class="modal-content">

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <div class="panel-heading">
                        <h4>BOL</h4>
                    </div>
                </div>

                <div class="modal-body">


    <div class="col-md-3 panel-body table-responsive table-bordered" style="background-color: #fff;" 0">

        <table class="table table-bordered">
            <tbody>

            <tr ng-repeat="shipment in ctrl.ShipmentData">
                <td ng-class="{ 'selected-class-name':  shipment.shipmentId == ctrl.selectedShipmentId }">
                    <div class="media">
                        <div class="media-body">
                            <%-- ****************** Selecting shipment Tab ****************** --%>

                            <a href = ''  ng-click="ctrl.getClickedShipment(shipment.shipmentId)">
                                <h5 class="media-heading" >{{ shipment.shipmentId }}</h5>
                                <!-- <span style="font-weight: normal; font-size: 11px;">{{order.contact_name}}</span> -->
                            </a>

                            <%-- ****************** End of shipment order Tab ****************** --%>

                        </div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>

    </div>

    <div class = "col-md-9 table-bordered" >

                    <br style="clear:both;"/><br/>
                    <div class = "col-md-12" >   
                        <form name="ctrl.updateReportForm" ng-submit="ctrl.updateJasperReport()" novalidate >                
                        <div class = "col-md-6">Shipment ID&emsp;:-&emsp;{{ctrl.selectedShipmentId}}</div>
                        <div class = "col-md-6">BILL OF LADING NUMBER&emsp;:-&emsp;{{ctrl.reportInfoByShipment.bolNumber}}</div>
                        <div class = "col-md-6">SCAC&emsp;:-&emsp;<input style="width:150px; display:inline;" id="scac" name="scac" class="form-control" type="text" ng-model="ctrl.reportInfoByShipment.scac"/></div>
                        <div class = "col-md-6">
                            <label class="radio-inline" >
                                    <input id="prepaid" name="prepaid" type="radio" ng-model="ctrl.reportInfoByShipment.chargeTerms" value="prepaid">Prepaid&emsp;
                                </label>&emsp;
                            <label class="radio-inline" >
                                    <input id="collect" name="collect" type="radio" ng-model="ctrl.reportInfoByShipment.chargeTerms" value="collect">Collect&emsp;
                                   
                                </label>&emsp;
                            <label class="radio-inline" >
                                    <input id="thirdParty" name="thirdParty" type="radio" ng-model="ctrl.reportInfoByShipment.chargeTerms" value="thirdParty">Third Party&emsp;
                            </label>&emsp;<br style="clear:both;">
                            <div>seal Number(s)&emsp;:-&emsp;<input id="sealNumber" name="sealNumber" class="form-control" type="text" ng-model="ctrl.reportInfoByShipment.sealNumber" style="width:200px; display:inline;"/></div>
                        </div>                        
                    </div>
                    <div class = "col-md-12" ng-if="ctrl.CurrentCompanyBolType == 'tempControlledBol'">
                        <hr style="margin: 10px 0; border:solid 0.3px;">
                        <br style="clear: both;"/>
                        <div class = "col-md-4">Driver&emsp;:-&emsp;&emsp;<input style="width:150px; display:inline;" id="driver" name="driver" class="form-control" type="text" ng-model="ctrl.reportInfoByShipment.driver"/></div>
                        <div class = "col-md-8">
                            Temperature&emsp;:-<br/>
                            High&emsp;:- <input id="tempHigh" name="tempHigh" class="form-control" type="text" ng-model="ctrl.reportInfoByShipment.tempHigh" style="width:70px; display:inline;"/>
                            Low&emsp;:- <input id="tempLow" name="tempLow" class="form-control" type="text" ng-model="ctrl.reportInfoByShipment.tempLow" style="width:70px; display:inline;"/>
                            Loaded At&emsp;:- <input id="loadedAt" name="loadedAt" class="form-control" type="text" ng-model="ctrl.reportInfoByShipment.loadedAt" style="width:120px; display:inline;"/>
                        </div>
                        <div class = "col-md-4">Driver Lic&emsp;:-&nbsp;&nbsp;<input style="width:150px; display:inline;" id="driverLic" name="driverLic" class="form-control" type="text" ng-model="ctrl.reportInfoByShipment.driverLic"/></div>
                    </div>
    
                    <br style="clear:both;"/><br/>
                    <div>
                        <h4>Customer order Information</h4><br/>
                        <div class = "col-md-12" >
                            <div class="col-md-2"><label>ORDER NUMBER</label></div>
                            <div class="col-md-2"><label>#PKGS</label></div>
                            <div class="col-md-2"><label>WEIGHT</label></div>
                            <div class="col-md-2"><label>PALLET/SLIP</label></div>
                            <div class="col-md-4"><label>ADDTIONAL SHIPPER INFO</label></div>
                        </div>
                        <hr style="margin: 10px 0;">
                        <div class = "col-md-12" ng-repeat = "index in ctrl.getNewField(ctrl.addNewFieldNum) track by $index">

                            <div class="col-md-2">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('receiptLineNumber'+$index)}">
                                    <input id="{{'orderNumber'+$index}}" name="{{'receiptLineNumber'+$index}}" class="form-control" type="text"
                                           ng-model="ctrl.customerOrderInfo[$index].orderNumber" disabled />
                                </div>
                            </div>



                            <div class="col-md-2">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('itemId')}">
                                    <input id="itemId" name="pkgs" class="form-control" type="number"
                                                   ng-model="ctrl.customerOrderInfo[$index].pkgs" />

                                </div> 
                            </div>

                            <div class="col-md-2">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('expectedExpirationDate'+ $index)}">
                                    <input id="{{'weight' + $index}}" name="{{'expectedExpirationDate' + $index}}" class="form-control" type="number" required
                                           ng-model="ctrl.customerOrderInfo[$index].weight"/>
                                </div>
                            </div>

                            <div class="col-md-2">
                                <div class="checkbox c-checkbox">
                                    <label>
                                        <input id="isExpired" name="isExpired" type="checkbox" ng-model="ctrl.customerOrderInfo[$index].palletSlip">
                                        <span class="fa fa-check"></span>
                                    </label>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('expectedExpirationDate'+ $index)}">
                                    <input id="{{'additionalInfo' + $index}}" name="{{'additionalShipperInfo' + $index}}" class="form-control" type="text" required
                                           ng-model="ctrl.customerOrderInfo[$index].additionalShipperInfo" />
                                </div>
                            </div>

                            <input type = "hidden" ng-model = "ctrl.lineCountIndex = $index" />
                            <div ng-init = "ctrl.customerOrderInfo[$index].orderNumber = ctrl.dataForBol[$index].order_number; ctrl.customerOrderInfo[$index].pkgs = ctrl.dataForBol[$index].pkgs; ctrl.customerOrderInfo[$index].weight = ctrl.dataForBol[$index].weight; ctrl.customerOrderInfo[$index].palletSlip = ctrl.dataForBol[$index].pallet_slip; ctrl.customerOrderInfo[$index].additionalShipperInfo = ctrl.dataForBol[$index].additional_shipper_info">
                            </div>
                        </div>
                        <br style="clear:both;" />                        
                    </div>

                    <br style="clear:both;"/>
                    <div ng-if="ctrl.CurrentCompanyBolType != 'tempControlledBol'"><!-- Carrier Information -->
                        <h4>Carrier Information</h4><br/>
                        <div class = "col-md-12" >
                            <div class="col-md-2" style="width:180px;"><label>Handling Units</label></div>
                            <!-- <div class="col-md-2" style="width:90px;"><label>Type</label></div>
                            <div class="col-md-1" style="width:90px;"><label>Qty</label></div>
                            <div class="col-md-1" style="width:80px;"><label>Type</label></div>   -->                          
                        </div>
                        <div class = "col-md-12" >
                            <div class="col-md-1" style="width:90px;"><label>Qty</label></div>
                            <div class="col-md-1" style="width:90px;"><label>Type</label></div>
                            <div class="col-md-1" style="width:90px;"><label>Qty</label></div>
                            <div class="col-md-1" style="width:80px;"><label>Type</label></div>
                            <div class="col-md-2" style="width:90px;"><label>Weight</label></div>
                            <div class="col-md-1"><label>H.M.(x)</label></div>
                            <div class="col-md-3" style="width:180px;"><label>Commodity Description</label></div>
                            <div class="col-md-1"><label>NMFC#</label></div>
                            <div class="col-md-1"><label>CLASS</label></div>
                        </div>
                        <hr style="margin: 10px 0;">
                        <div class = "col-md-12 dataRow" ng-repeat = "index in ctrl.getNewCarrierField(ctrl.addNewCarrierFieldNum) track by $index">

                            <div class="col-md-1 dataRow" style="width:90px;">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('handlingUnitQty'+$index)}">
                                    <input id="{{'handlingUnitQty'+$index}}" name="{{'handlingUnitQty'+$index}}" class="form-control" type="number"
                                           ng-model="ctrl.carrierInformation[$index].handlingUnitQty"/>
                                </div>
                            </div>



                            <div class="col-md-1 dataRow" style="width:90px;">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('itemId')}">
                                    <input id="itemId" name="pkgs" class="form-control" type="text"
                                                   ng-model="ctrl.carrierInformation[$index].handlingUnitType" />

                                </div> 
                            </div>

                            <div class="col-md-1 dataRow" style="width:90px;">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('itemId')}">
                                    <input id="itemId" name="pkgs" class="form-control" type="number"
                                                   ng-model="ctrl.carrierInformation[$index].packageQty" />

                                </div> 
                            </div>                            

                            <div class="col-md-1 dataRow" style="width:90px;">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('itemId')}">
                                    <input id="itemId" name="pkgs" class="form-control" type="text"
                                                   ng-model="ctrl.carrierInformation[$index].packageType" />

                                </div> 
                            </div> 

                            <div class="col-md-1 dataRow" style="width:90px;">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('expectedExpirationDate'+ $index)}">
                                    <input id="{{'weight' + $index}}" name="{{'expectedExpirationDate' + $index}}" class="form-control" type="text" 
                                           ng-model="ctrl.carrierInformation[$index].weight"/>
                                </div>
                            </div>

                            <div class="col-md-1 dataRow">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('itemId')}">
                                    <input id="itemId" name="pkgs" class="form-control" type="text"
                                                   ng-model="ctrl.carrierInformation[$index].hm" />

                                </div> 
                            </div>

                            <div class="col-md-3 dataRow" style="width:180px;">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('expectedExpirationDate'+ $index)}">
                                    <input id="{{'additionalInfo' + $index}}" name="{{'additionalShipperInfo' + $index}}" class="form-control" type="text" 
                                           ng-model="ctrl.carrierInformation[$index].commodityDescription" />
                                </div>
                            </div>

                            <div class="col-md-1 dataRow">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('itemId')}">
                                    <input id="itemId" name="pkgs" class="form-control" type="text"
                                                   ng-model="ctrl.carrierInformation[$index].ltlNmfc" />

                                </div> 
                            </div>

                            <div class="col-md-1 dataRow">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('itemId')}">
                                    <input id="itemId" name="pkgs" class="form-control" type="text"
                                                   ng-model="ctrl.carrierInformation[$index].ltlClass" />

                                </div> 
                            </div>                                                        

                            <div class="col-md-1 dataRow" style="width:30px;">
                                <button type="button"  ng-click = "ctrl.deleteCarrierRaw($index)" class="btn btn-default">X</button>
                            </div>

                            <input type = "hidden" ng-model = "ctrl.lineCountIndex = $index" />
                            <div ng-init = "ctrl.carrierInformation[$index].handlingUnitQty = ctrl.carreirDataForBol[$index].handling_unit_qty; 
                            ctrl.carrierInformation[$index].handlingUnitType = ctrl.carreirDataForBol[$index].handling_unit_type; 
                            ctrl.carrierInformation[$index].packageQty = ctrl.carreirDataForBol[$index].package_qty; 
                            ctrl.carrierInformation[$index].packageType = ctrl.carreirDataForBol[$index].package_type; 
                            ctrl.carrierInformation[$index].weight = ctrl.carreirDataForBol[$index].weight;
                            ctrl.carrierInformation[$index].hm = ctrl.carreirDataForBol[$index].hm;
                            ctrl.carrierInformation[$index].commodityDescription = ctrl.carreirDataForBol[$index].commodity_description;
                            ctrl.carrierInformation[$index].ltlNmfc = ctrl.carreirDataForBol[$index].ltl_nmfc;
                            ctrl.carrierInformation[$index].ltlClass = ctrl.carreirDataForBol[$index].ltl_class;">
                            </div>
                            <br style="clear:both;" />
                        </div>
                        <button class="btn btn-default" type="button" ng-click="ctrl.addNewCarrierField(ctrl.lineCountIndex)">Add New Line</button>
                    </div> 
                    <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showReportUpdatedPrompt"> Report Information for shipment {{ctrl.selectedShipmentId}} has been updated successfully
                    </div> 
                    <hr/>
                    <button type="button" id = "UpdateReport" class="btn btn-primary" ng-click="ctrl.updateJasperReport()">Update Report</button>
                    </div>
                    </form>
                </div>

                <br style="clear:both;"/>
                <br style="clear:both;"/>

                <div class="modal-footer">
                    <button type="button" id = "previewPdf" class="btn btn-primary" ng-click="printBOL(ctrl.getRow)">Preview</button>
                </div>
            </div>
        </div>
    </div>
    <!-- ****************** End of edit BOL ****************** -->

    <div id="viewReport" class="modal fade" role="dialog">
    <div class="modal-dialog" style="width:80%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div>
                <!-- <embed id="pdfReport" style="height:450px; width: 100%;" src="/report?format=PDF&file=billOfLading&_controller=com.foysonis.orders.ShipmentController&_action=getBillOfLadingReport&fileFormat=PDF&accessType=inline"> -->
                <iframe id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.srcStrg}}"></iframe>
<!--                  <embed id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.srcStrg}}"/> -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" class="btn btn-default" data-dismiss="modal" ng-click='editBOL()'>Edit</button>
                <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click=printBolReport()>Print</button>
            </div>
        </div>
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
                        <iframe id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.srcStrg}}"></iframe>
                        <!-- <embed id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.srcStrgForPackSlip}}"/> -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click=printPack()>Print</button>
                </div>
            </div>
        </div>
    </div>

    <div id="viewEPostLabelModel" class="modal fade" role="dialog">
        <div class="modal-dialog" style="width:80%">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div class="modal-body">
                    <div>
                        <ifrmae id="easyPostPdfReport" style="height:450px; width: 100%;" type='application/pdf'></ifrmae>
                        <!-- <embed id="easyPostPdfReport" style="height:450px; width: 100%;" type='application/pdf'/> -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <!-- <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click=printPack()>Print</button> -->
                </div>
            </div>
        </div>
    </div>

    <div id="packageWeightModel" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><g:message code="default.dialog.confirmation.label" /></h4>
                </div>
                <div class="modal-body">
                <form name="ctrl.updateEasyPostWeightForm" ng-submit="ctrl.updateEasyPostWeight()" novalidate >
                    <div class = "col-md-12" >

                        <div class = "col-md-6">Package Weight&emsp;:&emsp;{{ctrl.selectedShipmentId}}</div>
                        <div class = "col-md-6">
                            <input id="packageWeight" name="packageWeight" class="form-control" type="number" ng-model="ctrl.packageWeightForEasyPost" style="width:200px; display:inline;"  min="1" required  />

                            <div class="my-messages" ng-messages="ctrl.updateEasyPostWeightForm.packageWeight.$error" ng-if="ctrl.updateEasyPostWeightForm.packageWeight.$touched || ctrl.updateEasyPostWeightForm.$submitted">
                                <div class="message-animation" ng-message="required">
                                    <strong><g:message code="required.error.message" /></strong>
                                </div>
                            </div>

                            <div class="my-messages" ng-messages="ctrl.updateEasyPostWeightForm.packageWeight.$error" ng-if="ctrl.updateEasyPostWeightForm.packageWeight.$error.min">
                                <div class="message-animation" >
                                    <strong>The value should be greater than 0(zero).</strong>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br style="clear: both;">
                    <br style="clear: both;">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="submit" id = "truckCloseButton" class="btn btn-primary" ng-disabled="ctrl.disablemanifestBtn">{{ctrl.ePManifestText}}</button>
                    </form>
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

    <div id="easyPostVoidFail" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><g:message code="default.dialog.warning.label" /></h4>
                </div>
                <div class="modal-body">
                    <div class="my-messages" ng-messages="ctrl.updateEasyPostWeightForm.packageWeight.$error">
                        <div class="message-animation" >
                            <strong>{{ctrl.easyPostRefundErrorMsg}}</strong>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>

</div><!-- End of CustomerCtrl -->


<!--start warning dialog- pick work  -->
<div id="confirmWarningForEdit" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title"><g:message code="default.dialog.warning.label" /></h4>
            </div>
            <div class="modal-body">
                <p><g:message code="shipment.checkStatus.warning.message" /></p>
                %{--<p>This Shipment Already Completed in Other User.</p>--}%
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<!--end warning dialog  -->


<!--start warning dialog- truck  -->
<div id="confirmWarningForClose" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title"><g:message code="default.dialog.warning.label" /></h4>
            </div>
            <div class="modal-body">
                <p><g:message code="truck.checkStatus.warning.message" /></p>
                %{--<p>This Truck Already Close or Dispatched in Other User.</p>--}%
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<!--end warning dialog  -->


<!--start warning dialog- truck  -->
<div id="confirmWarningForOpen" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title"><g:message code="default.dialog.warning.label" /></h4>
            </div>
            <div class="modal-body">
                <p><g:message code="truck.checkStatusClose.warning.message" /></p>
                %{--<p>This Truck Already Dispatched or Re Open in Other User.</p>--}%
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<!--end warning dialog  -->



<asset:javascript src="datagrid/shipping.js"/>

<script type="text/javascript">
    var dvShipping = document.getElementById('dvShipping');
    angular.element(document).ready(function() {
        angular.bootstrap(dvShipping, ['shipping']);
    });
</script>

%{--Signup form--}%
<asset:javascript src="signup/angular-aria.min.js"/>
<asset:javascript src="signup/angular-messages.min.js"/>

%{--UI Grid JS files--}%
<asset:javascript src="datagrid/angular-touch.js"/>
<asset:javascript src="datagrid/angular-animate.js"/>
<asset:javascript src="datagrid/csv.js"/>
<asset:javascript src="datagrid/pdfmake.js"/>
<asset:javascript src="datagrid/vfs_fonts.js"/>
<asset:javascript src="datagrid/ui-grid.js"/>
%{--<link rel="stylesheet" href="http://ui-grid.info/release/ui-grid.css" type="text/css">--}%
%{--<asset:stylesheet src="datagrid/ui-grid.css"/>--}%

<asset:javascript src="datagrid/shippingService.js"/>

<asset:javascript src="autocomplete/angular-sanitize.js"/>
<asset:javascript src="autocomplete/auto-complete.js"/>
<asset:javascript src="autocomplete/auto-complete-multi.js"/>
<asset:javascript src="inventory/order-auto-complete-div.js"/>
<asset:javascript src="autocomplete/auto-complete-textbox.js"/>

</body>
</html>
