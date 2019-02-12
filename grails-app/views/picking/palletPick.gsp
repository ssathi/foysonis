<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2016-02-02
  Time: 8:20 PM
--%>

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
    <asset:javascript src="dragAndDrop/angular-drag-and-drop-lists"/>
    %{--<link rel="stylesheet" href="http://ui-grid.info/release/ui-grid.css" type="text/css">--}%
    %{--<asset:stylesheet src="datagrid/ui-grid.css"/>--}%

    %{--Sign Up Form--}%
    <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>


    <%-- *************************** CSS for Location Grid **************************** --%>
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
        /*width: 950px;*/
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

    .ui-grid-header-cell .ui-grid-cell-contents {
        height: 48px;
        white-space: normal;
        -ms-text-overflow: clip;
        -o-text-overflow: clip;
        text-overflow: clip;
        overflow: visible;
    }

    .ui-grid-cell-contents {
        display: inherit; 
        float: none; 
    }    

    .confrmaPalPickBtn{
        background-color: #16c98d !important;
        height: 37px;
        line-height: 1;
        border: 0px;
    }
    .nav-tabs > li > a.moveTabs{
        background-color: #878a8d;
        color: #ffffff;
        height: 37px;
        width: 150px;
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



    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    </style>

    <%-- **************************** End of CSS **************************** --%>

</head>

<body>

<div ng-cloak class="row" id="dvPalletPick" ng-controller="palletPickCtrl as ctrl">


    <div class="col-lg-12">
        <div style="display: inline;"><em class="fa  fa-fw mr-sm" style="padding-right: 40px;" ><img style="width: 35px;" src="/foysonis2016/app/img/replanishment_header.svg"></em>&nbsp;<span class="headerTitle" style="vertical-align: bottom;">Pallet Picks & Replenishment
        </span></div>
        <br style="clear: both;"/>
        <br style="clear: both;"/>        
        <!-- START panel-->

        <div class="panel panel-default">
            <div class="panel-body" >
                <!-- Nav tabs -->
                <ul class="nav nav-tabs">
                    <li id="liAdjReason" class="active"><a class="moveTabs moveFirstTab" href="#palletPick" data-toggle="tab" ng-click = "ctrl.getAllPalletPick()"><g:message code="default.tap.palletPick.label"/></a></li>
                    <li id="liItmcat"><a class="moveTabs moveLastTab" href="#replens" data-toggle="tab" ng-click = "ctrl.getAllReplens()"><g:message code="default.tap.replensWork.label"/></a></li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">

                <%--  ****************** Picking Grid  ****************** --%>
                    <div id="palletPick" class="tab-pane fade in active">
                            <div class="checkbox c-checkbox">
                                <label></label>
                                <label>
                                    <input type="checkbox" value="" ng-click="ctrl.getCompletedPalletPick()" ng-model="ctrl.completePallet">
                                    <span class="fa fa-check"></span><g:message code="default.field.completed.label" /></label>
                            </div>
                            <br>

                            <p>
                            <div id="grid1" ui-grid="gridPalletPick" ui-grid-exporter  ui-grid-pagination ui-grid-resize-columns ui-grid-auto-resize class="grid">
                                <div class="noItemMessage" ng-if="gridPalletPick.data.length == 0"><g:message code="palletPick.grid.noData.message" /></div>
                            </div>
                            </p>
                    </div>

                    <div id="replens" class="tab-pane fade">
                            <div class="checkbox c-checkbox">
                                <label></label>
                                <label>
                                    <input type="checkbox" value="" ng-click="ctrl.checkBoxFunction()" ng-model="ctrl.completeReplens">
                                    <span class="fa fa-check"></span><g:message code="default.field.completed.label" /></label>
                                <label></label><label></label>

                                <label>
                                    <input type="checkbox" value="" ng-click="ctrl.checkBoxFunction()" ng-model="ctrl.expiredReplens">
                                    <span class="fa fa-check"></span><g:message code="checkbox.field.expired.label" /></label>
                            </div>
                            <br>

                            <p>
                            <div id="grid2" ui-grid="gridReplens" ui-grid-exporter  ui-grid-pagination ui-grid-expandable ui-grid-resize-columns ui-grid-auto-resize class="grid">
                                <div class="noItemMessage" ng-if="gridReplens.data.length == 0"><g:message code="replens.grid.noData.message" /></div>
                            </div>
                            </p>
                    </div>
                <%-- ****************** END OF Picking Grid  ****************** --%>

                <!-- start replens confirm popup -->

                <div id="replensView" class="modal fade" role="dialog">
                    <div class="modal-dialog"  style="width: 75%;">
                        <div class="modal-content">

                            <div class="modal-header">
                                <button type="button" class="close" id ="closeButton" aria-hidden="true">&times;</button>
                                <div class="panel-heading">
                                <h4><g:message code="default.dialog.replensTop.label" /></h4>
                                </div>
                            </div>

                            <div class="panel-body">

                                <div class = "col-md-6" >
                                    <div class="panel-title"><g:message code="default.replenReferenceForView.label" />&nbsp;:&emsp; {{ctrl.replenReferenceForView}}</div>
                                </div>

                                <div class = "col-md-6" ng-if="ctrl.viewSourceLocation" >
                                    <div class="panel-title"><g:message code="default.sourceLocationForView.label" />&nbsp;:&emsp; {{ctrl.sourceLocationForView}}</div>
                                </div>

                                    <br style="clear: both;"/>
                                    <br style="clear: both;"/>

                                <div class = "col-md-6" ng-if="ctrl.viewConfirmLpn">
                                    <div class="panel-title"><g:message code="default.palletLpnForConfirmed.label" />&nbsp;:&emsp; {{ctrl.confirmReplenLpn}}</div>
                                </div>

                                <div class = "col-md-6" ng-if="ctrl.viewConfirmCaseLpn">
                                    <div class="panel-title"><g:message code="default.caseLpnForConfirmed.label" />&nbsp;:&emsp; {{ctrl.confirmCaseLpn}}</div>
                                </div>

                                <div class = "col-md-6" ng-if="ctrl.viewConfirmQty">
                                    <div class="panel-title"><g:message code="default.qtyForConfirmed.label" />&nbsp;:&emsp; {{ctrl.confirmQty}}</div>
                                </div>

                                <div class = "col-md-6" ng-if="ctrl.level == 'PALLET' && ctrl.viewDestinationLocation">
                                    <div class="panel-title"><g:message code="default.destinationLocationForView.label" />&nbsp;:&emsp; {{ctrl.destinationLocationForView}}</div>
                                </div>

                                <div class = "col-md-6" ng-if=" ctrl.level != 'PALLET' && ctrl.caseLevel == true && ctrl.viewDestinationLocation">
                                    <div class="panel-title"><g:message code="default.destinationLocationForView.label" />&nbsp;:&emsp; {{ctrl.destinationLocationForView}}</div>
                                </div>

                                    <br style="clear: both;"/>
                                    <br style="clear: both;"/>

                                <div class = "col-md-6" ng-if=" ctrl.level != 'PALLET' && ctrl.caseLevel != true && ctrl.viewDestinationLocation">
                                    <div class="panel-title"><g:message code="default.destinationLocationForView.label" />&nbsp;:&emsp; {{ctrl.destinationLocationForView}}</div>
                                </div>

                                <br style="clear: both;"/>
                                <br style="clear: both;"/>

                                <!-- start source location -->
                                    <!--start form1 -->
                                    <div class="row" id="SourceLocationForm" ng-if="ctrl.SourceLocationForm">

                                <form name="ctrl.confirmSourceLocationForm" ng-submit="ctrl.confirmSourceLocationButton()"  novalidate >

                                    <div class="col-md-3">
                                            <div class="form-group"  style="text-align: center;">
                                                <label for="sourceLocationId"><g:message code="form.field.confirmSourceLocation.label" />&nbsp;:</label>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group" style="text-align: left;">
                                                    <input id="sourceLocationId" name="sourceLocationId" class="form-control" type="text" ng-model="ctrl.sourceLocationId"
                                                           ng-model-options="{ updateOn : 'default blur' }" placeholder="Source Location" ng-blur="ctrl.disableFindButton()" capitalize required/>

                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <button type="submit" class="btn btn-primary" ng-disabled="ctrl.disabledFind"><g:message code="default.button.confirm.label" /></button>
                                            </div>
                                        </div>

                                    <div class="col-md-4">
                                    <div class="form-group" style="text-align: left;color: red;" role="alert" ng-if="ctrl.sourceLocationError">
                                        <p><g:message code="replens.sourceLocation.warning.message" /></p>
                                    </div>
                                    </div>

                                </form>
                                    </div>
                                    <!--end form1 -->
                                    <!-- end source location -->

                                <!-- start lpn -- level=pallet-->
                                    <!--start form2 -->
                                <div class="row" id="LpnForm" ng-if="ctrl.LpnForm">

                                    <form name="ctrl.confirmLpnForm" ng-submit="ctrl.confirmLpnButton()"  novalidate >

                                        <div class="col-md-3">
                                            <div class="form-group"  style="text-align: center;">
                                                <label for="lpn"><g:message code="form.field.confirmLpn.label" />&nbsp;:</label>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group"style="text-align: left;">
                                                <input id="lpn" name="lpn" class="form-control" type="text" ng-model="ctrl.lpn"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="LPN"  ng-blur="ctrl.disableFindButton1()" capitalize required/>
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <button type="submit" class="btn btn-primary" ng-disabled="ctrl.disabledFind1"><g:message code="default.button.confirm.label" /></button>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group" style="text-align: left;color: red;" role="alert" ng-if="ctrl.palletLpnError">
                                                <p><g:message code="replens.lpn.warning.message" /></p>
                                            </div>
                                        </div>

                                    </form>

                                    </div>
                                    <!--end form2 -->
                                    <!-- end lpn -->

                                <br style="clear: both;"/>


                                    <!-- start lpn level=case -->
                                    <div class="row" id="CheckCaseLevelForm" ng-if="ctrl.CheckCaseLevelForm">
                                        <div class="checkbox c-checkbox">
                                            <div class="form-group"  style="margin-left: 70px;">
                                                <label>
                                                    <input type="checkbox" value="" ng-click="ctrl.CheckCaseLevel()" ng-model="ctrl.caseLevel">
                                                    <span class="fa fa-check"></span><g:message code="checkbox.field.case.label" />
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- end lpn -->


                                    <!--start form2-1 -->

                                <div class="row" id="CaseLpnForm" ng-if="ctrl.CaseLpnForm">

                                    <form name="ctrl.confirmCaseLpnForm" ng-submit="ctrl.confirmCaseLpnButton()"  novalidate >

                                        <div class="col-md-3">
                                            <div class="form-group"  style="text-align: center;">
                                                <label for="caseLpn"><g:message code="form.field.confirmCaseLpn.label" />&nbsp;:</label>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group"style="text-align: left;">
                                                <input id="caseLpn" name="caseLpn" class="form-control" type="text" ng-model="ctrl.caseLpn"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="LPN"  ng-blur="ctrl.disableFindButton3()" capitalize required/>
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <button type="submit" class="btn btn-primary" ng-disabled="ctrl.disabledFind3"><g:message code="default.button.confirm.label" /></button>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group" style="text-align: left;color: red;" role="alert" ng-if="ctrl.caseLpnError">
                                                <p><g:message code="replens.caseLpn.warning.message" /></p>
                                            </div>
                                        </div>

                                    </form>

                                </div>
                                <!--end form2-1 -->


                                <!--start form2-2 -->
                                <div class="row" id="QtyForm" ng-if="ctrl.QtyForm">

                                    <form name="ctrl.confirmQtyForm" ng-submit="ctrl.confirmQtyButton()"  novalidate >

                                        <div class="col-md-3">
                                            <div class="form-group"  style="text-align: center;">
                                                <label for="qty"><g:message code="form.field.confirmQty.label" />&nbsp;:</label>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group"style="text-align: left;">
                                                <input id="qty" name="qty" class="form-control" type="text" ng-model="ctrl.qty"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="Qty"  ng-blur="ctrl.disableFindButton4()" required/>
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <button type="submit" class="btn btn-primary" ng-disabled="ctrl.disabledFind4"><g:message code="default.button.confirm.label" /></button>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group" style="text-align: left;color: red;" role="alert" ng-if="ctrl.qtyError">
                                                <p><g:message code="replens.qty.warning.message" /></p>
                                            </div>
                                        </div>

                                    </form>

                                </div>
                                <!--end form2-2 -->


                                <!-- start Destination location -->

                                    <!--start form3 -->
                                <div class="row" id="DestinationLocationForm" ng-if="ctrl.DestinationLocationForm">

                                    <form name="ctrl.confirmDestinationLocationForm" ng-submit="ctrl.confirmDestinationLocationButton()"  novalidate >

                                        <div class="col-md-3">
                                            <div class="form-group"  style="text-align: center;">
                                                <label for="destinationLocationId"><g:message code="form.field.confirmDestinationLocation.label" />&nbsp;:</label>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group" style="text-align: left;">
                                                <input id="destinationLocationId" name="destinationLocationId" class="form-control" type="text" ng-model="ctrl.destinationLocationId"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="Destination Location" ng-blur="ctrl.disableFindButton2()" capitalize required/>
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <button type="submit" class="btn btn-primary" ng-disabled="ctrl.disabledFind2"><g:message code="default.button.confirm.label" /></button>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group" style="text-align: left;color: red;" role="alert" ng-if="ctrl.destinationLocationError">
                                                <p><g:message code="replens.destinationLocation.warning.message" /></p>
                                            </div>
                                        </div>

                                    </form>

                                    </div>
                                    <!--end form3 -->
                                    <!-- end Destination location -->

                                %{--<div class = "col-md-12" >--}%
                                    %{--<h4><g:message code="default.inventoryGrid.heading.label" /></h4>--}%
                                %{--</div>--}%

                                %{--<br style="clear: both;"/>--}%
                                %{--<br style="clear: both;"/>--}%

                                %{--<!-- Start Inventory Grid-->--}%
                                %{--<div id="grid1" ui-grid="gridInventory" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-expandable ui-grid-resize-columns ui-grid-auto-resize class="grid">--}%
                                    %{--<div class="noItemMessage" ng-if="gridInventory.data.length == 0"><g:message code="inventory.grid.noData.message" /></div>--}%
                                %{--</div>--}%
                                <!-- END OF Inventory Grid-->

                                <br style="clear: both;"/>
                                <br style="clear: both;"/>

                                </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.close.label" /></button>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- end replens confirm popup -->

                <!-- start pick work confirm popup -->

                <div id="pickWorkView" class="modal fade" role="dialog">
                    <div class="modal-dialog"  style="width: 75%;">
                        <div class="modal-content">

                            <div class="modal-header">
                                <button type="button" class="close" id ="closeButton1" aria-hidden="true">&times;</button>
                                <div class="panel-heading">
                                    <h4><g:message code="default.dialog.pickWorkTop.label" /></h4>
                                </div>
                            </div>

                            <div class="panel-body">

                                <div class="alert alert-success message-animation" role="alert" ng-show="ctrl.showSubmittedDestinationLocationPrompt">
                                    Successfully Confirmed Destination / PND Location.
                                </div>

                                <div class = "col-md-4" >
                                    <div class="panel-title"><g:message code="default.pickWorkReferenceForView.label" />&nbsp;:&emsp; {{ctrl.pickWorkReferenceForView}}</div>
                                </div>

                                <div class = "col-md-4" ng-if="ctrl.viewSourceLocation1" >
                                    <div class="panel-title"><g:message code="default.sourceLocationForView.label" />&nbsp;:&emsp; {{ctrl.picksourceLocationForView}}</div>
                                </div>

                                <div class = "col-md-4" >
                                    <div class="panel-title">Pick Qty &nbsp;:&emsp; {{ctrl.pickWorkPickQtyForView}}</div>
                                </div>

                                <br style="clear: both;"/>
                                <br style="clear: both;"/>

                                <div class = "col-md-6" ng-if="ctrl.viewConfirmLpn1">
                                    <div class="panel-title"><g:message code="default.palletLpnForConfirmed.label" />&nbsp;:&emsp; {{ctrl.confirmPickWorkLpn}}</div>
                                </div>

                                <div class = "col-md-6" ng-if="ctrl.viewDestinationLocation1">
                                    <div class="panel-title"><g:message code="default.destinationLocationForView.label" />&nbsp;:&emsp; {{ctrl.pickdestinationLocationForView}}</div>
                                </div>

                                <br style="clear: both;"/>
                                <br style="clear: both;"/>

                                <!-- start source location -->
                                <!--start form1 -->
                                <div class="row" id="SourceLocationForm1">

                                    <form name="ctrl.confirmSourceLocationForm1" ng-submit="ctrl.confirmSourceLocationButton1()"  novalidate >

                                        <div class="col-md-3">
                                            <div class="form-group"  style="text-align: center;">
                                                <label for="sourceLocationId"><g:message code="form.field.confirmSourceLocation.label" />&nbsp;:</label>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group" style="text-align: left;">
                                                <input id="sourceLocationId" name="sourceLocationId" class="form-control" type="text" ng-model="ctrl.sourceLocationId"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="Source Location" ng-blur="ctrl.disableFindButton()" ng-disabled="!ctrl.SourceLocationForm1" capitalize required/>

                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <button type="submit" class="btn btn-primary" ng-disabled="ctrl.disabledFind || !ctrl.SourceLocationForm1"><g:message code="default.button.confirm.label" /></button>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group" style="text-align: left;color: red;" role="alert" ng-if="ctrl.sourceLocationError1">
                                                <p><g:message code="replens.sourceLocation.warning.message" /></p>
                                            </div>
                                        </div>

                                    </form>
                                </div>
                                <!--end form1 -->
                                <!-- end source location -->

                                <!-- start lpn -- level=pallet-->
                                <!--start form2 -->
                                <div class="row" id="LpnForm1" ng-if="ctrl.LpnForm1">

                                    <form name="ctrl.confirmLpnForm1" ng-submit="ctrl.confirmLpnButton1()"  novalidate >

                                        <div class="col-md-3">
                                            <div class="form-group"  style="text-align: center;">
                                                <label for="lpn"><g:message code="form.field.confirmLpn.label" />&nbsp;:</label>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group"style="text-align: left;">
                                                <input id="lpn" name="lpn" class="form-control" type="text" ng-model="ctrl.lpn"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="LPN"  ng-blur="ctrl.disableFindButton1()" capitalize required/>
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <button type="submit" class="btn btn-primary" ng-disabled="ctrl.disabledFind1"><g:message code="default.button.confirm.label" /></button>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group" style="text-align: left;color: red;" role="alert" ng-if="ctrl.palletLpnError1">
                                                %{--<p><g:message code="replens.lpn.warning.message" /></p>--}%
                                                {{ctrl.palletLpnError1}}
                                            </div>
                                        </div>

                                    </form>

                                </div>
                                <!--end form2 -->
                                <!-- end lpn -->

                                <br style="clear: both;"/>


                                <!-- start Destination location -->

                                <!--start form3 -->
                                <div class="row" id="DestinationLocationForm1" ng-if="ctrl.DestinationLocationForm1">

                                    <form name="ctrl.confirmDestinationLocationForm1" ng-submit="ctrl.confirmDestinationLocationButton1()"  novalidate >

                                        <div class="col-md-3">
                                            <div class="form-group"  style="text-align: center;">
                                                <label for="destinationLocationId"><g:message code="form.field.confirmDestinationLocation.label" />&nbsp;:</label>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group" style="text-align: left;">
                                                <input id="destinationLocationId" name="destinationLocationId" class="form-control" type="text" ng-model="ctrl.destinationLocationId"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="Destination Location" ng-blur="ctrl.disableFindButton2()" capitalize required/>
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <button type="submit" class="btn btn-primary" ng-disabled="ctrl.disabledFind2"><g:message code="default.button.confirm.label" /></button>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group" style="text-align: left;color: red;" role="alert" ng-if="ctrl.destinationLocationError1">
                                                <p><g:message code="replens.destinationLocation.warning.message" /></p>
                                            </div>
                                        </div>

                                    </form>

                                </div>
                                <!--end form3 -->
                                <!-- end Destination location -->

                                %{--<div class = "col-md-12" >--}%
                                    %{--<h4><g:message code="default.inventoryGrid.heading.label" /></h4>--}%
                                %{--</div>--}%

                                %{--<br style="clear: both;"/>--}%
                                %{--<br style="clear: both;"/>--}%

                                <!-- Start Inventory Grid-->
                                %{--<div id="grid1" ui-grid="gridInventory" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-expandable ui-grid-resize-columns ui-grid-auto-resize class="grid">--}%
                                    %{--<div class="noItemMessage" ng-if="gridInventory.data.length == 0"><g:message code="inventory.grid.noData.message" /></div>--}%
                                %{--</div>--}%
                                <!-- END OF Inventory Grid-->

                                <br style="clear: both;"/>
                                <br style="clear: both;"/>

                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.close.label" /></button>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- end pick work confirm popup -->

                </div>
            </div>
            <!--panel-body -->
        </div>
        <!-- END panel-->


        <!--start warning dialog-replens  -->
        <div id="ConfirmWarning" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title"><g:message code="default.dialog.warning.label" /></h4>
                    </div>
                    <div class="modal-body">
                        <p><g:message code="replens.checkStatus.warning.message" /></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                    </div>
                </div>
            </div>
        </div>
        <!--end warning dialog  -->


        <!--start warning dialog -replens -->
        <div id="ConfirmCaseLpnWarning" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title"><g:message code="default.dialog.warning.label" /></h4>
                    </div>
                    <div class="modal-body">
                        <p><g:message code="replens.checkInventory.warning.message" /></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                    </div>
                </div>
            </div>
        </div>
        <!--end warning dialog  -->

        <!--start warning dialog- pick work  -->
        <div id="ConfirmWarningForPick" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title"><g:message code="default.dialog.warning.label" /></h4>
                    </div>
                    <div class="modal-body">
                        %{--<p><g:message code="replens.checkStatus.warning.message" /></p>--}%
                        <p>This Pick Work Already Completed in Other User.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                    </div>
                </div>
            </div>
        </div>
        <!--end warning dialog  -->


<asset:javascript src="datagrid/pallet-pick-replens.js"/>

<script type="text/javascript">
    var dvPalletPick = document.getElementById('dvPalletPick');
    angular.element(document).ready(function() {
        angular.bootstrap(dvPalletPick, ['palletPick']);
    });
</script>

        <asset:javascript src="datagrid/palletPickReplensService.js"/>

</body>
</html>