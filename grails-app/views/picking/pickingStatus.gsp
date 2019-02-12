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
            height:420px;
        }
        
        .pickWorkGrid {
            height:420px;
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

        .ui-grid-header-cell .ui-grid-cell-contents {
            height: 48px;
            white-space: normal;
            -ms-text-overflow: clip;
            -o-text-overflow: clip;
            text-overflow: clip;
            overflow: visible;
        }

        [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
            display: none !important;
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

<%-- **************************** End of CSS **************************** --%>    

</head>

<body>

    <div ng-cloak class="row" id="dvPicking" ng-controller="pickingCtrl as ctrl">

        <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 40px; padding-bottom: 3px;" src="/foysonis2016/app/img/allocationPicks_header.svg"></em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">Allocation & Pick Status
        </span></div>
        <br style="clear: both;">
        <br style="clear: both;">
        <!-- START search panel-->
        <div class="panel panel-default">
            <div class="panel-heading">
                <a href="javascript:void(0);" ng-click = "ctrl.showHideSearch()">
                <legend><em ng-if = "ctrl.isShipmentSearchVisible" class="fa fa-minus-circle fa-fw mr-sm"></em>
                <em ng-if = "!ctrl.isShipmentSearchVisible" class="fa fa-plus-circle fa-fw mr-sm"></em>
                   <g:message code="default.search.label" />
                </legend></a>
            </div>
            <div class="panel-body" ng-show= "ctrl.isShipmentSearchVisible">
                <form name="ctrl.shipmentSearchForm"  ng-submit="ctrl.shipmentSearch()">
                    <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                        <div>
                            <fieldset>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Shipment Id</label>
                                            <div class="controls">

                                                <input type="text" name="shipmentId" placeholder="Shipment Id" class="form-control"
                                                       ng-blur="" ng-model="ctrl.findShipment.shipmentId">

                                            </div>
                                        </div>
                                    </div>


                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label><g:message code="form.field.orderNo.label" /></label>
                                            <div class="controls">
                                                <input type="text" name="orderNumber" placeholder="Order Number" class="form-control"
                                                       ng-blur="" ng-model="ctrl.findShipment.orderNumber">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Allocation Status</label>
                                            <select  name="allocationStatus" ng-model="ctrl.findShipment.allocationStatus" class="form-control" ng-disabled="ctrl.findShipment.completedShipment">
                                                <option value="NONE"></option>
                                                <option value="ALLOCATED" >ALLOCATED</option>
                                                <option value="UNALLOCATED">UNALLOCATED</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>&nbsp;</label>
                                            <div class="controls">
                                                <div class="checkbox c-checkbox">
                                                    <label>
                                                        <input type="checkbox" value="" ng-model="ctrl.findShipment.completedShipment" ng-disabled="ctrl.findShipment.allocationStatus !='NONE' && ctrl.findShipment.allocationStatus != null">
                                                        <span class="fa fa-check"></span>Include Completed Shipments</label>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <br style="clear: both;"/>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Shipment Creation Date </label>
                                            <label ng-show="ctrl.displayShipmentCreationDate"> : <g:message code="form.field.from.label"/></label>
                                            <div class="controls">
                                                %{--<input type="date" id="fromShipmentCreation" name="fromShipmentCreation" class="form-control" ng-model="ctrl.findShipment.fromShipmentCreation" />--}%

                                                <p class="input-group">
                                                    <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                           ng-model="ctrl.findShipment.fromShipmentCreation" is-open="popupShipmentCreateDateFrom.opened"
                                                           datepicker-options="dateOptions"  ng-required="false" close-text="Close"
                                                           alt-input-formats="altInputFormats" />
                                                    <span class="input-group-btn">
                                                        <button type="button" class="btn btn-default" ng-click="openShipmentCreateDateFrom()">
                                                            <i class="glyphicon glyphicon-calendar"></i></button>
                                                    </span>
                                                </p>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4" ng-show="ctrl.displayShipmentCreationDate">
                                        <div class="form-group">
                                            <label><g:message code="form.field.to.label" /></label>
                                            <div class="controls">
                                                %{--<input type="date" id="toShipmentCreation" name="toShipmentCreation" class="form-control" min="{{ctrl.getCreatedDate(ctrl.findShipment.fromShipmentCreation)}}" ng-model="ctrl.findShipment.toShipmentCreation" />--}%

                                                <p class="input-group">
                                                    <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                           ng-model="ctrl.findShipment.toShipmentCreation" is-open="popupShipmentCreateDateTo.opened"
                                                           datepicker-options="dateOptions"  ng-required="false" close-text="Close"
                                                           alt-input-formats="altInputFormats" min="{{ctrl.getCreatedDate(ctrl.findShipment.fromShipmentCreation)}}" />
                                                    <span class="input-group-btn">
                                                        <button type="button" class="btn btn-default" ng-click="openShipmentCreateDateTo()">
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
                                                        <input type="checkbox" value="" ng-click="ctrl.shipmentCreationDateRange()" ng-model="ctrl.shipmentCreationRange">
                                                        <span class="fa fa-check"></span><g:message code="form.field.dateRange.label" /></label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <br style="clear: both;"/>
                                </div>


                            </fieldset>

                            <div class="pull-right">
                                <button class="btn btn-primary findBtn" type="submit" ng-disabled="">
                                    <g:message code="default.button.searchShipment.label" />
                                </button>
                            </div>

                        </div>

                    </div>
                </form>
            </div>
        </div>
        <!-- END search panel -->
        <br style="clear: both;"/>

        <div class="col-lg-3 panel-body table-responsive table-bordered" style="background-color: #fff;" ng-if = "ctrl.shipmentData.length == 0">

            <table class="table table-bordered">
                <tbody>

                    <tr>
                        <td>
                            <div class="media">
                                <div class="media-body">
                                    <h5 class="media-heading" >No Shipments found.</h5>
                                </div>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>

        </div>

        <div class="col-lg-3 panel-body table-responsive table-bordered" style="background-color: #fff;" ng-if = "ctrl.shipmentData.length > 0">

            <table class="table table-bordered">
                <tbody>
                    <th>Shipment ID</th>
                    <tr ng-repeat="shipment in ctrl.shipmentData">
                        <td ng-class="{ 'selected-class-name':  shipment.shipment_id == ctrl.selectedShipmentId }">
                            <div class="media">
                                <div class="media-body">
                                    <%-- ****************** Selecting shipmemnt Tab ****************** --%>

                                    <a href = '' ng-click="ctrl.getClickedShipment(shipment.shipment_id, shipment.shipment_status)">
                                        <h5 class="media-heading" style="font-weight: bold;font-size: 15px;">{{ shipment.shipment_id }}</h5>
                                        <span style="font-weight: normal; font-size: 11px;">{{ shipment.shipment_status }}</span>
                                    </a>

                                    <%-- ****************** End of selecting shipmemnt Tab ****************** --%>

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
                <!-- <div class="panel-body" ng-if="ctrl.selectedShipmentStatus != 'PLANNED'"> -->
                    <!-- Nav tabs -->
                    <ul class="nav nav-tabs" ng-if="ctrl.selectedShipmentStatus != 'PLANNED'">
                        <li id="liReplen"><a class="moveTabs moveFirstTab" href="#replen" data-toggle="tab"><g:message code="default.replenWork.tab.label" /></a></li>  
                        <li id="liPickList"><a class="moveTabs" href="#pickList" data-toggle="tab"><g:message code="default.pickList.tab.label" /></a></li>                                          
                        <li id="liPallet"><a class="moveTabs" href="#palletPick" data-toggle="tab"><g:message code="default.palletPicking.tab.label" /></a></li> 
                        <li id="liShipment"><a class="moveTabs moveLastTab" href="#shipment" data-toggle="tab"><g:message code="default.shipment.tab.label" /></a></li>                        
                    </ul>
                    <ul class="nav nav-tabs" ng-if="ctrl.selectedShipmentStatus == 'PLANNED'">
                        <li id="liReplenPlnd" class="disabled"><a class="moveTabs moveFirstTab" href=""><g:message code="default.replenWork.tab.label" /></a></li> 
                        <li id="liPickListPlnd" class="disabled"><a class="moveTabs" href="" ><g:message code="default.pickList.tab.label" /></a></li>
                        <li id="liPalletPlnd" class="disabled"><a class="moveTabs" href="" ><g:message code="default.palletPicking.tab.label" /></a></li>
                        <li id="liShipmentPlnd" class="active"><a class="moveTabs moveLastTab" href="#shipment"><g:message code="default.shipment.tab.label" /></a></li>                        
                    </ul>                    
                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div id="palletPick" class="tab-pane fade in active" ng-if="ctrl.selectedShipmentStatus != 'PLANNED'">                        


                            <p ng-if="ctrl.shipmentData.length > 0">
                            <div  id="grid1" ui-grid="gridPalletPicks"  ui-grid-exporter  ui-grid-auto-resize ng-style="getTableHeight()" ui-grid-resize-columns class="grid">
                                <div class="noLocationMessage" ng-if="gridPalletPicks.data.length == 0" ><g:message code="palletPicks.grid.noData.message" /></div>
                            </div>
                            </p>
                        <%-- ****************** END OF Grid  ****************** --%>

                        </div>
                        <div id="palletPick" class="tab-pane fade" ng-if="ctrl.selectedShipmentStatus == 'PLANNED'"></div>
                        <div id="pickList" class="tab-pane fade">
                            <div ng-if="ctrl.shipmentData.length > 0" >
                                <!-- <div ng-if="ctrl.pickWorkData.length > 0"> -->
                                    <div ng-repeat="pickListData in ctrl.pickListByShipment">

                                        <div class="col-lg-12">
                                            <div class="col-lg-6">
                                                <div>
                                                    <div class="label-desc">Pick List Id :</div>
                                                    <div class="label-content"><a href="javascript:void(0)" ng-click="ctrl.navigateToListPicking(pickListData.pick_list_id)">{{pickListData.pick_list_id}}</a></div>
                                                    <br style="clear: both;"/>
                                                </div>
                                                <div>
                                                    <div class="label-desc">Status :</div>
                                                    <div class="label-content" ng-if="pickListData.pick_list_status =='P'">Partially Ready</div>
                                                    <div class="label-content" ng-if="pickListData.pick_list_status =='R'">Ready for pick</div>
                                                    <div class="label-content" ng-if="pickListData.pick_list_status =='C'">Completed</div>
                                                    <br style="clear: both;"/>
                                                </div>
                                                <div>
                                                    <div class="label-desc">Completion Date :</div>
                                                    <div class="label-content">{{ctrl.getConvertedDate(pickListData.completion_date)}}</div>
                                                    <br style="clear: both;"/>
                                                </div>
                                            </div> 
                                            <div class="col-lg-6">
                                                <div>
                                                    <div class="label-desc">Created Date :</div>
                                                    <div class="label-content">{{ctrl.getConvertedDate(pickListData.created_date)}}</div>
                                                    <br style="clear: both;"/>
                                                </div>
                                                <div>
                                                    <div class="label-desc">Last Update Date :</div>
                                                    <div class="label-content">{{ctrl.getConvertedDate(pickListData.last_update_date)}}</div>
                                                    <br style="clear: both;"/>
                                                </div>
                                            </div>
                                        </div>

                                        <br style="clear: both;"/>
                                        <br style="clear: both;"/>

                                        <div ng-init="ctrl.getPickWorkDataByPickList(pickListData.pick_list_id,$index)"></div>
                                        <p>
                                        <div id="grid1" ui-grid="{data: ctrl.pickWorkData[$index]}" ui-grid-exporter  ui-grid-auto-resize ng-style="getTableHeight()" ui-grid-resize-columns class="pickWorkGrid">
                                        <div class="noLocationMessage" ng-if="ctrl.pickWorkData.length == 0"><g:message code="palletWorks.grid.noData.message" /></div>
                                        </div> 
                                        </p>
                                        <br style="clear: both;"/>
                                       <hr/>
                                    </div>
                                <!-- </div>
                                <div class="noDataMessage" ng-if='ctrl.pickWorkData.length == 0'>
                                    This Shipment doesn't have any Picks.
                                </div>  -->                                
                            </div>
                            <div class="col-lg-12 noDataMessage" ng-if='ctrl.shipmentData.length == 0'>
                                No Pick details to display.
                            </div>
                            <br style="clear: both;"/>



                        </div>
                        <div id="replen" class="tab-pane fade">
                            <p>
                            <div  id="grid1" ui-grid="gridReplenWork"  ui-grid-exporter  ui-grid-auto-resize ui-grid-expandable ng-style="getTableHeight()" ui-grid-resize-columns class="grid">
                                <div class="noLocationMessage" ng-if="gridReplenWork.data.length == 0" >This Shipment doesn't have any replenishment work.</div>
                            </div>
                            </p>                          
                        </div>
                        <div id="shipment" class="tab-pane fade" ng-if="ctrl.selectedShipmentStatus != 'PLANNED'">
                            <div class="col-lg-12">
                                <div class="col-lg-6">
                                    <div>
                                        <div class="label-desc">Shipment Id :</div>
                                        <div class="label-content">{{ctrl.selectedShipmentData.shipmentId}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                    <div>
                                        <div class="label-desc">Status :</div>
                                        <div class="label-content">{{ctrl.selectedShipmentData.shipmentStatus}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                    <div>
                                        <div class="label-desc">Carrier Code :</div>
                                        <div class="label-content">{{ctrl.selectedShipmentData.carrierCode}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                    <div>
                                        <div class="label-desc">Service Level :</div>
                                        <div class="label-content">{{ctrl.selectedShipmentData.serviceLevel}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                </div> 
                                <div class="col-lg-6">

                                    <div ng-if = "ctrl.selectedShipmentData.isParcel == true">
                                        <div class="label-desc" style="width: 155px;">Small Package :</div>
                                        <div class="label-content">Yes</div>
                                        <br style="clear: both;"/>
                                    </div>
                                    <div ng-if = "ctrl.selectedShipmentData.isParcel == false">
                                        <div class="label-desc" style="width: 155px;">Small Package :</div>
                                        <div class="label-content">No</div>
                                        <br style="clear: both;"/>
                                    </div>
                                    <div>
                                        <div class="label-desc" style="width: 155px;">Truck No :</div>
                                        <div class="label-content">{{ctrl.selectedShipmentData.truckNumber}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                    <div>
                                        <div class="label-desc" style="width: 155px;">Tracking No/Pro No. :</div>
                                        <div class="label-content">{{ctrl.selectedShipmentData.trackingNo}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                </div>
                            </div>

                            <br style="clear: both;"/>
                            <br style="clear: both;"/>
                            <p>
                            <div  id="grid1" ui-grid="gridShipmentLines"  ui-grid-exporter  ui-grid-auto-resize ng-style="getTableHeight()" ui-grid-resize-columns class="grid">
                                <div class="noLocationMessage" ng-if="gridShipmentLines.data.length == 0" ><g:message code="shipment.grid.noData.message" /></div>
                            </div>
                            </p>
                        </div> 
                        <div id="shipment" class="tab-pane fade in active" ng-if="ctrl.selectedShipmentStatus == 'PLANNED'">
                            <div class="col-lg-12">
                                <div class="col-lg-6">
                                    <div>
                                        <div class="label-desc">Shipment Id :</div>
                                        <div class="label-content">{{ctrl.selectedShipmentData.shipmentId}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                    <div>
                                        <div class="label-desc">Status :</div>
                                        <div class="label-content">{{ctrl.selectedShipmentData.shipmentStatus}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                    <div>
                                        <div class="label-desc">Carrier Code :</div>
                                        <div class="label-content">{{ctrl.selectedShipmentData.carrierCode}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                    <div>
                                        <div class="label-desc">Service Level :</div>
                                        <div class="label-content">{{ctrl.selectedShipmentData.serviceLevel}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                </div>
                                <div class="col-lg-6">

                                    <div ng-if = "ctrl.selectedShipmentData.isParcel == true">
                                        <div class="label-desc" style="width: 155px;">Small Package :</div>
                                        <div class="label-content">Yes</div>
                                        <br style="clear: both;"/>
                                    </div>
                                    <div ng-if = "ctrl.selectedShipmentData.isParcel == false">
                                        <div class="label-desc" style="width: 155px;">Small Package :</div>
                                        <div class="label-content">No</div>
                                        <br style="clear: both;"/>
                                    </div>
                                    <div>
                                        <div class="label-desc" style="width: 155px;">Truck No :</div>
                                        <div class="label-content">{{ctrl.selectedShipmentData.truckNumber}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                    <div>
                                        <div class="label-desc" style="width: 155px;">Tracking No/Pro No. :</div>
                                        <div class="label-content">{{ctrl.selectedShipmentData.trackingNo}}</div>
                                        <br style="clear: both;"/>
                                    </div>
                                </div>
                            </div>

                            <br style="clear: both;"/>
                            <br style="clear: both;"/>
                            <p>
                            <div  id="grid1" ui-grid="gridShipmentLines"  ui-grid-exporter  ui-grid-auto-resize ng-style="getTableHeight()" ui-grid-resize-columns class="grid">
                                <div class="noLocationMessage" ng-if="gridShipmentLines.data.length == 0" ><g:message code="shipment.grid.noData.message" /></div>
                            </div>
                            </p>

                        </div>                                               
                    </div>
                <!-- </div> -->
                <!--/.panel-body -->
            </div>
            <!-- END panel-->
        </div>


        <!-- start allocate view popup -->

        <div id="allocationProcess" class="modal fade" role="dialog">
            <div class="modal-dialog"  style="width: 40%;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4>Allocation</h4>
                        <br style="clear: both;"/>
                    </div>
                    <form name="ctrl.allocationCreateFrom" ng-submit="ctrl.saveAllocation()" novalidate >
                        <div class="modal-body">

                            <div class="col-md-12">
                                <div class="col-md-6">

                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForAllocationCreate('locationId')}">
                                        <label for="locationId">Staging Location</label>
                                        <div auto-complete  source="loadCompanyLocations"  xxxx-list-formatter="customListFormatter" value-changed="ctrl.validateItemId(value.contactName)" style="z-index: 1000;">
                                            <input id="locationId" name="locationId" ng-model="ctrl.location"  ng-model-options="{ updateOn : 'default blur' }" placeholder="location Id" class="form-control" required/>

                                            <div class="my-messages" ng-messages="ctrl.allocationCreateFrom.locationId.$error" ng-if="ctrl.showMessagesForAllocationCreate('locationId')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                </div>

                                <div class="col-md-6">
                                    <button style="margin-left: 20px; margin-top: 22px" class="btn btn-primary" type="submit">Begin Allocation</button>
                                </div>

                            </div>

                            <br style="clear: both;"/>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>


                        </div>

                    </form>
                </div>
            </div>
        </div>
        <!-- end allocate view popup -->


                <!-- start allocate view popup -->

        <div id="allocationProcess" class="modal fade" role="dialog">
            <div class="modal-dialog"  style="width: 40%;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4>Allocation</h4>
                        <br style="clear: both;"/>
                    </div>
                    <form name="ctrl.allocationCreateFrom" ng-submit="ctrl.saveAllocation()" novalidate >
                        <div class="modal-body">

                            <div class="col-md-12">
                                <div class="col-md-6">

                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForAllocationCreate('locationId')}">
                                        <label for="locationId">Staging Location</label>
                                        <div auto-complete  source="loadCompanyLocations"  xxxx-list-formatter="customListFormatter" value-changed="ctrl.validateItemId(value.contactName)" style="z-index: 1000;">
                                            <input id="locationId" name="locationId" ng-model="ctrl.location"  ng-model-options="{ updateOn : 'default blur' }" placeholder="location Id" class="form-control" required/>

                                            <div class="my-messages" ng-messages="ctrl.allocationCreateFrom.locationId.$error" ng-if="ctrl.showMessagesForAllocationCreate('locationId')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                </div>

                                <div class="col-md-6">
                                    <button style="margin-left: 20px; margin-top: 22px" class="btn btn-primary" type="submit">Begin Allocation</button>
                                </div>

                            </div>

                            <br style="clear: both;"/>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>


                        </div>

                    </form>
                </div>
            </div>
        </div>
        <!-- end allocate view popup -->



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
                <button type="button" id = "cancelAllocationButton" class="btn btn-primary"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>


    <asset:javascript src="datagrid/picking.js"/>

    <script type="text/javascript">
        var dvPicking = document.getElementById('dvPicking');
        angular.element(document).ready(function() {
            angular.bootstrap(dvPicking, ['picking']);
        });
    </script>

%{--<asset:javascript src="autocomplete/angular-auto.js"/>--}%
<asset:javascript src="autocomplete/angular-sanitize.js"/>
<asset:javascript src="autocomplete/auto-complete.js"/>
<asset:javascript src="autocomplete/auto-complete-multi.js"/>
<asset:javascript src="inventory/order-auto-complete-div.js"/>
<asset:javascript src="autocomplete/auto-complete-textbox.js"/>
<asset:javascript src="datagrid/pickingService.js"/>

</body>
</html>