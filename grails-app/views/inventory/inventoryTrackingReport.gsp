<%--
  Created by IntelliJ IDEA.
  User: home
  Date: 10/14/15
  Time: 12:10
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="foysonis2016"/>


    %{--<link rel="stylesheet" href="http://ui-grid.info/release/ui-grid.css" type="text/css">--}%
    %{--<asset:stylesheet src="datagrid/ui-grid.css"/>--}%

    %{--Sign Up Form--}%
    <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>

    %{--date picker--}%
    <asset:javascript src="angular-datepicker.js"/>
    <asset:stylesheet src="angular-datepicker.css"/>


    <%-- *************************** CSS for Location Grid **************************** --%>
    <style>

    .grid {
        height:420px;
        width: 100%;
    }

    .qtyNumberGrid{
        text-align: right; 
    }

    .noDataMessage {
        position: absolute;
        top : 30%;
        opacity: 0.4;
        font-size: 40px;
        width: 100%;
        text-align: center;
        z-index: auto;
    }     
    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    </style>

    <%-- **************************** End of CSS **************************** --%>


</head>

<body>


<div ng-cloak id="dvInventory" ng-controller="inventoryTrackingReportCtrl as ctrl">

    <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 40px;" src="/foysonis2016/app/img/report_header.svg"></em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">Warehouse Activity Log</span></div>
    <br style="clear: both;">
    <br style="clear: both;">

<div class="panel panel-default" style="margin-top: 20px;">
        <div class="panel-body">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs">
                <li class="active"><a class="moveTabs moveFirstTab" href="#move_pallet" data-toggle="tab">Inventory Received</a>
                </li>
                <li><a class="moveTabs" href="#move_case" data-toggle="tab">Inventory Adjusted</a>
                </li>
                <li><a class="moveTabs moveLastTab" href="#move_entire_loc" data-toggle="tab">Inventory Moved</a>
                </li>
            </ul>
            <!-- Tab panes -->
            <div class="tab-content">
                <div id="move_pallet" class="tab-pane fade in active" style="padding: 50px 10px 100px 10px;">

                    <div class="alert alert-success message-animation" role="alert" ng-show="ctrl.movePalletPrompt" >
                        {{ctrl.movePalletSuccessMessage}}
                    </div>

                    <form name="ctrl.findReceivedInventoryForm"  ng-submit="ctrl.findInventoryReceived()">

                        <div class="col-md-1">
                            From :
                        </div>
                        <div class="col-md-3">
                            <p class="input-group">
                                <input type="text" id="fromDateReceived" name="fromDateReceived" class="form-control" uib-datepicker-popup="{{format}}"
                                       ng-model="ctrl.fromDateReceived" is-open="popupFromDate.opened"
                                       datepicker-options="dateOptions"  ng-required="true" close-text="Close"
                                       alt-input-formats="altInputFormats" tabindex="3" />
                                <span class="input-group-btn">
                                    <button type="button" class="btn btn-default" ng-click="openFromDate()">
                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                </span>
                            </p>
                        </div>
                        <div class="col-md-2" style="text-align: right;">
                            To :
                        </div>
                        <div class="col-md-3">
                            <p class="input-group">
                                <input id="ToDateReceived" name="ToDateReceived" type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                       ng-model="ctrl.toDateReceived" is-open="popupToDate.opened"
                                       datepicker-options="dateOptions"  ng-required="true" close-text="Close"
                                       alt-input-formats="altInputFormats" tabindex="4" required />
                                <span class="input-group-btn">
                                    <button type="button" class="btn btn-default" ng-click="openToDate()">
                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                </span>
                            </p>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-primary moveSubmitBtn" type="submit" ng-disabled="ctrl.disabledBtnMovePallet">Find</button>
                        </div>                       

                    </form>

                    <br style="clear: both;"/>
                    <br style="clear: both;"/>

                    <div id="grid2" ui-grid="gridReceivedInventory" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-resize-columns class="grid" ui-grid-auto-resize>
                        <div class="noDataMessage" ng-if="gridReceivedInventory.data.length == 0">There is no records found!</div>
                        <!--<div ng-if='columnChanged'></div>-->
                    </div>

                </div>
                <div id="move_case" class="tab-pane fade" style="padding: 50px 10px 100px 10px;">

                    <form name="ctrl.findInventoryAdjustedForm"  ng-submit="ctrl.findInventoryAdjustment()">

                        <div class="col-md-1">
                            From :
                        </div>
                        <div class="col-md-3">
                            <p class="input-group">
                                <input type="text" id="fromDateInvAdj" name="fromDateInvAdj" class="form-control" uib-datepicker-popup="{{format}}"
                                       ng-model="ctrl.fromDateInvAdj" is-open="popupFromDate.opened"
                                       datepicker-options="dateOptions"  ng-required="true" close-text="Close"
                                       alt-input-formats="altInputFormats" tabindex="3" />
                                <span class="input-group-btn">
                                    <button type="button" class="btn btn-default" ng-click="openFromDate()">
                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                </span>
                            </p>
                        </div>
                        <div class="col-md-2" style="text-align: right;">
                            To :
                        </div>
                        <div class="col-md-3">
                            <p class="input-group">
                                <input id="ToDateInvAdj" name="ToDateInvAdj" type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                       ng-model="ctrl.toDateInvAdj" is-open="popupToDate.opened"
                                       datepicker-options="dateOptions"  ng-required="true" close-text="Close"
                                       alt-input-formats="altInputFormats" tabindex="4" required />
                                <span class="input-group-btn">
                                    <button type="button" class="btn btn-default" ng-click="openToDate()">
                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                </span>
                            </p>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-primary moveSubmitBtn" type="submit" >Find</button>
                        </div>                       

                    </form>
                    
                    <br style="clear: both;"/>
                    <br style="clear: both;"/>

                    <div id="grid2" ui-grid="gridAdjustedInventory" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-resize-columns class="grid" ui-grid-auto-resize>
                        <div class="noDataMessage" ng-if="gridAdjustedInventory.data.length == 0">There is no records found!</div>
                        <!--<div ng-if='columnChanged'></div>-->
                    </div>
                 </div>
                <div id="move_entire_loc" class="tab-pane fade" style="padding: 50px 10px 100px 10px;">

                   <form name="ctrl.findInventoryMovedForm"  ng-submit="ctrl.findMovedInventory()">

                        <div class="col-md-1">
                            From :
                        </div>
                        <div class="col-md-3">
                            <p class="input-group">
                                <input type="text" id="fromDateMove" name="fromDateMove" class="form-control" uib-datepicker-popup="{{format}}"
                                       ng-model="ctrl.fromDateMove" is-open="popupFromDate.opened"
                                       datepicker-options="dateOptions"  ng-required="true" close-text="Close"
                                       alt-input-formats="altInputFormats" tabindex="3" />
                                <span class="input-group-btn">
                                    <button type="button" class="btn btn-default" ng-click="openFromDate()">
                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                </span>
                            </p>
                        </div>
                        <div class="col-md-2" style="text-align: right;">
                            To :
                        </div>
                        <div class="col-md-3">
                            <p class="input-group">
                                <input id="ToDateMove" name="ToDateMove" type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                       ng-model="ctrl.toDateMove" is-open="popupToDate.opened"
                                       datepicker-options="dateOptions"  ng-required="true" close-text="Close"
                                       alt-input-formats="altInputFormats" tabindex="4" required />
                                <span class="input-group-btn">
                                    <button type="button" class="btn btn-default" ng-click="openToDate()">
                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                </span>
                            </p>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-primary moveSubmitBtn" type="submit" >Find</button>
                        </div>                       

                    </form>
                    
                    <br style="clear: both;"/>
                    <br style="clear: both;"/>

                    <div id="grid2" ui-grid="gridMoveInventory" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-resize-columns class="grid" ui-grid-auto-resize>
                        <div class="noDataMessage" ng-if="gridMoveInventory.data.length == 0">There is no records found!</div>
                        <!--<div ng-if='columnChanged'></div>-->
                    </div>

                </div>

            </div>
        </div>
    </div>
    
</div>

<asset:javascript src="datagrid/inventoryTrackingReport.js"/>

<script type="text/javascript">
    var dvInventory = document.getElementById('dvInventory');
    angular.element(document).ready(function() {
        angular.bootstrap(dvInventory, ['inventoryTrackingReport']);
    });


  /*  $(document).ready(function(){
        $('[data-toggle="tooltip"]').tooltip();
    });*/
</script>


%{--Signup form--}%
<asset:javascript src="signup/angular-aria.min.js"/>
<asset:javascript src="signup/angular-messages.min.js"/>

%{--UI Grid JS files--}%
%{--<asset:javascript src="datagrid/angular.js"/>--}%
<asset:javascript src="datagrid/angular-touch.js"/>
<asset:javascript src="datagrid/angular-animate.js"/>
<asset:javascript src="datagrid/csv.js"/>
<asset:javascript src="datagrid/pdfmake.js"/>
<asset:javascript src="datagrid/vfs_fonts.js"/>
<asset:javascript src="datagrid/ui-grid.js"/>

%{--<asset:javascript src="autocomplete/angular-auto.js"/>--}%
<asset:javascript src="autocomplete/angular-sanitize.js"/>
<asset:javascript src="autocomplete/auto-complete.js"/>
<asset:javascript src="autocomplete/auto-complete-multi.js"/>
<asset:javascript src="inventory/auto-complete-div.js"/>
<asset:javascript src="autocomplete/auto-complete-textbox.js"/>

</body>
</html>
