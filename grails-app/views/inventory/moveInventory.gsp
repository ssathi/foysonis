<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="foysonis2016"/>

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

    .nav-tabs > li > a.moveTabs{
        background-color: #878a8d;
        color: #ffffff;
        height: 37px;
        width: 170px;
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

    .moveSubmitBtn{
        background-color: #22a49c !important;
        height: 37px;
        width: 120px;
        line-height: 1;
        border: 0px;
    }
    .headerTitle{
    //font-weight: bold;
        font-family: inherit;
        font-size: 22px;
    }
    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    </style>

    <%-- **************************** End of CSS **************************** --%>


</head>

<body>


<div ng-cloak id="dvInventoryMove" ng-controller="InventoryMoveCtrl as ctrl">

    <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 45px; padding-bottom: 5px;" src="/foysonis2016/app/img/moveInventory_header.svg"></em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">Move Inventory</span></div>
    <br style="clear: both"/>
    <!-- Start Inventory Move-->
    <div class="panel panel-default" style="margin-top: 20px;">
        <div class="panel-heading"><h4>Inventory Move</h4></div>
        <div class="panel-body">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs">
                <li class="active"><a class="moveTabs moveFirstTab" href="#move_pallet" data-toggle="tab">Move Pallet</a>
                </li>
                <li><a class="moveTabs" href="#move_case" data-toggle="tab">Move Case</a>
                </li>
                <li><a class="moveTabs" href="#move_entire_loc" data-toggle="tab">Move Entire Location</a>
                </li>
                <li><a class="moveTabs moveLastTab" href="#move_eaches" data-toggle="tab">Move Each</a>
                </li>
            </ul>
            <!-- Tab panes -->
            <div class="tab-content">
                <div id="move_pallet" class="tab-pane fade in active" style="padding: 50px 10px 100px 10px;">

                    <div class="alert alert-success message-animation" role="alert" ng-show="ctrl.movePalletPrompt" >
                        {{ctrl.movePalletSuccessMessage}}
                    </div>

                    <form name="ctrl.movePalletForm"  ng-submit="ctrl.movePalletToLocation()">

                        <div class="col-md-1">
                            Pallet Id :
                        </div>
                        <div class="col-md-3">
                            <div class="controls">
                                %{--<div auto-complete  source="sourcePallets"  xxxx-list-formatter="customListFormatter"--}%
                                %{--value-changed="callbackPalletMovePalletId(value)" style="z-index: 1000000;">--}%
                                %{--<input ng-model="ctrl.movePallet.pallet" placeholder="Pallet Id" class="form-control">--}%
                                %{--</div>--}%
                                <div auto-complete  source="loadPalletAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars='0'
                                     value-changed="callbackPalletMovePalletId(value)" style="z-index: 1000000;">
                                    <input ng-model="ctrl.movePallet.pallet" placeholder="Pallet Id" class="form-control">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2" style="text-align: right;">
                            Move To Location :
                        </div>
                        <div class="col-md-3">
                            <div class="controls">
                                <div auto-complete  source="loadUnblockedLocationAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars='0'
                                     value-changed="callbackPalletMoveLocationId(value)" style="z-index: 1000000;">
                                    <input ng-model="ctrl.movePallet.location" placeholder="Move To Location" class="form-control">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-primary moveSubmitBtn" type="submit" ng-disabled="ctrl.disabledBtnMovePallet">Move</button>
                        </div>

                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                        <div class="col-md-5">
                            {{ctrl.PalletMovePalletInfo}}
                        </div>
                        <div class="col-md-5">
                            %{--{{ctrl.PalletMoveLocationInfo}}--}%

                            <label ng-if="ctrl.PalletMoveLocationInfo.length != 0 && ctrl.movePallet.location">This location contains:</label>
                            <ul ng-if="ctrl.PalletMoveLocationInfo.length != 0 && ctrl.movePallet.location">
                                <li ng-repeat="locationInfo in ctrl.PalletMoveLocationInfo" value="{{locationInfo}}">{{locationInfo.level}} - {{locationInfo.lPN}}</li>
                            </ul>
                            <label ng-if="ctrl.PalletMoveLocationInfo.length == 0 && ctrl.movePallet.location">This location doesn't have any pallet or case</label>

                        </div>
                        <br style="clear: both;"/>

                        <!-- <div class="pull-right">
                            <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disabledBtnMovePallet">Move</button>
                        </div> -->

                    </form>
                </div>
                <div id="move_case" class="tab-pane fade" style="padding: 50px 10px 100px 10px;">

                    <div class="alert alert-success message-animation" role="alert" ng-show="ctrl.moveCasePrompt" >
                        {{ctrl.moveCaseSuccessMessage}}
                    </div>

                    <form name="ctrl.moveCaseForm"  ng-submit="ctrl.moveCaseToPalletOrLocation()">

                        <div class="col-md-1">
                            Case Id :
                        </div>
                        <div class="col-md-3" style="width: 385px; padding-right: 130px;">
                            <div class="controls">
                                <div auto-complete  source="loadCaseAutoComplete"  xxxx-list-formatter="customListFormatter"
                                     value-changed="callbackCaseMoveCaseId(value)" style="z-index: 1000000;">
                                    <input ng-model="ctrl.moveCase.case" placeholder="Case Id" class="form-control">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            Move To Pallet :
                        </div>
                        <div class="col-md-3">
                            <div class="controls">
                                <div auto-complete  source="loadPalletAutoComplete"  xxxx-list-formatter="customListFormatter"
                                     value-changed="callbackCaseMovePalletId(value)" style="z-index: 100000000;">
                                    <input ng-model="ctrl.moveCase.pallet" placeholder="Pallet Id" class="form-control">
                                </div>
                            </div>
                        </div>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                        <div class="col-md-5">
                            {{ctrl.CaseMoveCaseInfo}}
                        </div>
                        <div class="col-md-5">
                            {{ctrl.CaseMovePalletInfo}}
                        </div>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                        <div class="col-md-1">
                            &nbsp;
                        </div>
                        <div class="col-md-3" style="width: 385px; padding-right: 130px;">
                            &nbsp;
                        </div>
                        <div class="col-md-2">
                            Move To Location :
                        </div>
                        <div class="col-md-3">
                            <div class="controls">
                                <div auto-complete  source="loadUnblockedLocationAutoComplete"  xxxx-list-formatter="customListFormatter"
                                     value-changed="callbackCaseMoveLocationId(value)" style="z-index: 1000000;">
                                    <input ng-model="ctrl.moveCase.location" placeholder="Move To Location" class="form-control">
                                </div>
                            </div>
                        </div>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>
                        <div class="col-md-5">
                            &nbsp;
                        </div>
                        <div class="col-md-5">
                            {{ctrl.CaseMoveLocationInfo}}
                        </div>
                        <br style="clear: both;"/>
                        <div class="pull-right">
                            <button class="btn btn-primary moveSubmitBtn" type="submit" ng-disabled="ctrl.disabledBtnMoveCase">Move</button>
                        </div>

                    </form>
                </div>
                <div id="move_entire_loc" class="tab-pane fade" style="padding: 50px 10px 100px 10px;">

                    <div class="alert alert-success message-animation" role="alert" ng-show="ctrl.moveEntireLocPrompt" style="margin-top: -40px;" >
                        {{ctrl.moveEntireLocSuccessMessage}}
                    </div>
                    <div class="alert alert-danger message-animation" role="alert" ng-show="ctrl.disableMoveForEntireLoc"  style="margin-top: -40px;">
                        {{ctrl.moveEntireLocErrorMessage}}
                    </div>

                    <form name="ctrl.moveEntireLocForm"  ng-submit="ctrl.moveEntireLocation()">

                        <div class="col-md-2" style="width: 150px;">
                            From Location :
                        </div>
                        <div class="col-md-3">
                            <div class="controls">

                                <div auto-complete  source="loadUnblockedLocationAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars='0'
                                     value-changed="ctrl.getLocationIdInventoryData(value, 'fromLocation')" style="z-index: 1000000;">
                                    <input ng-model="ctrl.entireLoc.fromLocation" placeholder="Move From Location" class="form-control">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2" style="text-align: right;">
                            To Location :
                        </div>
                        <div class="col-md-3">
                            <div class="controls">
                                <div auto-complete  source="loadUnblockedLocationAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars='0'
                                     value-changed="ctrl.getLocationIdInventoryData(value, 'toLocation')" style="z-index: 1000000;">
                                    <input ng-model="ctrl.entireLoc.toLocation" placeholder="Move To Location" class="form-control">
                                </div>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <button class="btn btn-primary moveSubmitBtn" type="submit" ng-disabled="!(ctrl.entireLoc.fromLocation && ctrl.entireLoc.toLocation)">Move</button>
                        </div>

                        <div class="col-md-5">

                            <label ng-if="ctrl.fromLocationInventoryInfo.length != 0 && ctrl.entireLoc.fromLocation">This location contains:</label>
                            <ul ng-if="ctrl.fromLocationInventoryInfo.length != 0 && ctrl.entireLoc.fromLocation">
                                <li ng-repeat="locationInfo in ctrl.fromLocationInventoryInfo" value="{{locationInfo}}">
                                    <span ng-if="locationInfo.pallet_id && locationInfo.level=='CASE'">
                                        PALLET - {{locationInfo.pallet_id}}
                                    </span>
                                    <span ng-if="(locationInfo.level=='CASE'||locationInfo.level=='PALLET') && !locationInfo.pallet_id">
                                        {{locationInfo.level}} - {{locationInfo.lpn}}
                                    </span>
                                    <span ng-if="locationInfo.level!='CASE' && locationInfo.level!='PALLET'">
                                        EACH - {{locationInfo.item_id}}
                                    </span>
                                </li>
                            </ul>
                            <label ng-if="ctrl.fromLocationInventoryInfo.length == 0 && ctrl.entireLoc.fromLocation">This location doesn't have any inventory</label>

                        </div>

                        <div class="col-md-5">

                            <label ng-if="ctrl.toLocationInventoryInfo.length != 0 && ctrl.entireLoc.toLocation">This location contains:</label>
                            <ul ng-if="ctrl.toLocationInventoryInfo.length != 0 && ctrl.entireLoc.toLocation">
                                <li ng-repeat="locationInfo in ctrl.toLocationInventoryInfo" value="{{locationInfo}}">
                                    <span ng-if="locationInfo.pallet_id && locationInfo.level=='CASE'">
                                        PALLET - {{locationInfo.pallet_id}}
                                    </span>
                                    <span ng-if="(locationInfo.level=='CASE'||locationInfo.level=='PALLET') && !locationInfo.pallet_id">
                                        {{locationInfo.level}} - {{locationInfo.lpn}}
                                    </span>
                                    <span ng-if="locationInfo.level!='CASE' && locationInfo.level!='PALLET'">
                                        EACH - {{locationInfo.item_id}}
                                    </span>
                                </li>
                            </ul>
                            <label ng-if="ctrl.toLocationInventoryInfo.length == 0 && ctrl.entireLoc.toLocation">This location doesn't have any inventory</label>

                        </div>

                        <br style="clear: both;"/>

                        <!-- <div class="pull-right">
                            <button class="btn btn-primary" type="submit" ng-disabled="!(ctrl.entireLoc.fromLocation && ctrl.entireLoc.toLocation)">Move</button>
                        </div> -->

                    </form>
                </div>

                <div id="move_eaches" class="tab-pane fade" style="padding: 50px 10px 100px 10px;">

                    <div class="alert alert-success message-animation" role="alert" ng-show="ctrl.eachesMovePrompt" >
                        {{ctrl.eachesMoveSuccessMessage}}
                    </div>
                    <div class="alert alert-danger message-animation" role="alert" ng-show="ctrl.disableMoveForEaches" >
                        {{ctrl.eachesMoveLocErrorMessage}}
                    </div>

                    <form name="ctrl.moveEachesForm"  ng-submit="ctrl.moveEachesToLocation()">

                        <div class="col-md-2">
                            From Location :
                        </div>
                        <div class="col-md-3">
                            <div class="controls">

                                <div auto-complete  source="loadUnblockedLocationAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars='0'
                                     value-changed="ctrl.callLocationForinventory(value)" style="z-index: 1000000;">
                                    <input ng-model="ctrl.eachesMove.fromLocation" placeholder="Move From Location" class="form-control" ng-disabled="ctrl.disableAllMoveEach || ctrl.disableItemSelection">
                                </div>
                            </div>
                        </div>

                        <div class="col-md-2" style="text-align: right;">
                            To Location :
                        </div>
                        <div class="col-md-3">
                            <div class="controls">
                                <div auto-complete  source="loadUnblockedLocationAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars='0'
                                     value-changed="" style="z-index: 1000000;">
                                    <input ng-model="ctrl.eachesMove.toLocation" placeholder="Move To Location" class="form-control">
                                </div>
                            </div>
                        </div>

                        <br style="clear: both;">
                        <br style="clear: both;">
                        <div ng-show="ctrl.allInventoryItemByLocation.length != 0 ">
                            <div class="col-md-2">Item Id :</div>
                            <div class="col-md-3">
                                <select name="itemSelect" id="itemSelect" ng-model="ctrl.eachesMove.itemId" class="form-control"  ng-disabled="ctrl.disableAllMoveEach || ctrl.disableItemSelection">
                                    <option ng-repeat="itemData in ctrl.allInventoryItemByLocation" value="{{itemData.item_id}}">{{itemData.item_id}}</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-primary" type="button" ng-click="ctrl.confirmItemIdForEachesMove(ctrl.eachesMove.itemId)" ng-disabled="!ctrl.eachesMove.itemId || ctrl.disableAllMoveEach || ctrl.disableItemSelection">Confirm</button>
                            </div>

                        </div>
                        <div class="col-md-5" ng-if="ctrl.allInventoryItemByLocation.length == 0 && ctrl.eachesMove.fromLocation">
                            <label>This location doesn't have any eaches</label>
                        </div>
                        <br style="clear: both;">
                        <br style="clear: both;">
                        <div ng-show="ctrl.allInventoryStatusData.length != 0">
                            <div class="col-md-2">Inventory Status :</div>
                            <div class="col-md-3">
                                <select name="invStatusSelect" id="invStatusSelect" ng-model="ctrl.eachesMove.inventoryStatus" class="form-control"  ng-disabled="ctrl.disableAllMoveEach">
                                    <option ng-repeat="invStatusData in ctrl.allInventoryStatusData" value="{{invStatusData.inventory_status_opt}}">{{invStatusData.inventory_status}}</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-primary" type="button" ng-click="ctrl.confirmItemIdForEachesMove(ctrl.eachesMove.itemId, ctrl.eachesMove.inventoryStatus)" ng-disabled="!ctrl.eachesMove.inventoryStatus || ctrl.disableAllMoveEach">Confirm</button>
                            </div>

                        </div>
                        <br style="clear: both;">
                        <br style="clear: both;">

                        <div ng-show="ctrl.inventoryTotalQty.length != 0">
                            <div class="col-md-2">Quantity :</div>
                            <div class="col-md-3" >
                                <input class="form-control" type="number" name="moveInvQty" id="moveInvQty" ng-model="ctrl.eachesMove.moveQty" min="1">
                            </div>

                            <div class="col-md-3 my-messages"  ng-messages="ctrl.moveEachesForm.moveInvQty.$error"
                                 ng-if="ctrl.moveEachesForm.moveInvQty.$error.min">
                                <div class="message-animation" >
                                    <strong>The value should be greater than 0(zero).</strong>
                                </div>
                            </div>

                            <div class="col-md-3 my-messages"  ng-messages="ctrl.moveEachesForm.moveInvQty.$error"
                                 ng-if="ctrl.inventoryTotalQty[0].total_inventory_qty < ctrl.eachesMove.moveQty">
                                <div class="message-animation" >
                                    <strong>Quantity cannot exceed inventory quantity.</strong>
                                </div>
                            </div>

                        </div>
                        <br style="clear: both;"/>
                        <div class="pull-right">
                            <button class="btn btn-primary moveSubmitBtn" type="submit" ng-disabled="!(ctrl.eachesMove.fromLocation && ctrl.eachesMove.toLocation && ctrl.eachesMove.moveQty)">Move</button>
                        </div>

                    </form>
                </div>


            </div>
        </div>
    </div>

    <!-- End Inventory Move-->

    <div id="binAreaSelectWarning" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Bin Location Warning</h4>
                </div>
                <div class="modal-body">
                    The Bin Location has been selected.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>

    <div id="lowestUOMInCaseLocation" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Bin Location Warning</h4>
                </div>
                <div class="modal-body">
                    The inventory on this location cannot be moved to a bin location as it contains lowest UOM case item.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>

    <div id="lowestUOMInCasePallet" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Bin Location Warning</h4>
                </div>
                <div class="modal-body">
                    The inventory on this Pallet cannot be moved to a bin location as it contains lowest UOM case item.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>

    <div id="lowestUOMInCaseForCase" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Bin Location Warning</h4>
                </div>
                <div class="modal-body">
                    The inventory on this Case cannot be moved to a bin location as it contains lowest UOM case item.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>

    <div id="caseTrackToBinWarn" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Bin Location Warning</h4>
                </div>
                <div class="modal-body">
                    Lowest UOM case item and case tracked items cannot be moved to a bin location.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>

    <div id="tempLocationMoveWarn" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Bin Location Warning</h4>
                </div>
                <div class="modal-body">
                    The inventory on TEMPLOCATION cannot be moved.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <div id="palletMoveToBinWarn" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Bin Location Warning</h4>
                </div>
                <div class="modal-body">
                    This inventory cannot be moved to a BIN location as this pallet contains cases.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <div id="caseMoveToBinWarn" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Bin Location Warning</h4>
                </div>
                <div class="modal-body">
                    Lowest UOM Case or Case tracked inventory can not be moved into Bin location.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>
</div>

<asset:javascript src="datagrid/inventoryMove.js"/>

<script type="text/javascript">
    var dvInventoryMove = document.getElementById('dvInventoryMove');
    angular.element(document).ready(function() {
        angular.bootstrap(dvInventoryMove, ['inventoryMove']);
    });


    $(document).ready(function(){
        $('[data-toggle="tooltip"]').tooltip();
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
