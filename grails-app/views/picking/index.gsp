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
            width: 700px;
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
        .startPickBtn{
            background-color: #16c98d !important;
            height: 25px;
            line-height: 1;
            border: 0px;
        }
        .pickData{
            font-weight: bold;
        }
        .pickAttr{
            padding: 5px;
        }
        .pickingHeader{
            background-color: #eff4f8;
        }
        .confirmPickBtn{
            background-color: #16c98d !important;
            height: 37px;
            width: 140px;
            line-height: 1;
            border: 0px;
        }
        [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
            display: none !important;
        }

    </style>

<%-- **************************** End of CSS **************************** --%>    

</head>

<body>

    <div ng-cloak class="row" id="dvListPicking" ng-controller="listPickingCtrl as ctrl">
    <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 40px;" src="/foysonis2016/app/img/list_picking_header.svg"></em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">List Picking</span></div>
    <br style="clear: both;">
    <br style="clear: both;">
        <!-- START search panel-->
        <div class="panel panel-default">
            <div class="panel-heading">
                <legend>
                   <g:message code="default.search.label" />
                </legend></a>
            </div>
            <div class="panel-body">
                <form name="ctrl.pickListSearchForm"  ng-submit="ctrl.pickListSearch()">
                    <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                        <div>
                            <fieldset>

                                <div class="row">

                                    <div class="col-md-12">

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label><g:message code="form.field.customer.label" /></label>
                                                <div class="controls">

                                                    <div auto-complete  source="loadCustomerAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars="3" value-changed="ctrl.getCustomerContactName(value)">
                                                        <input ng-model="ctrl.customer" placeholder="Customer" class="form-control" ng-blur="ctrl.customer=''">
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Pick List Id</label>
                                                <input type="text" name="palletId" class="form-control" ng-model="ctrl.findPickListId" placeholder="Pick List Id" ng-disabled="!ctrl.showPickToForm"capitalize />
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Pick List Status</label>
                                                <select  name="pickListStatus" ng-model="ctrl.findPickListStatus" class="form-control">
                                                    <option value="" ></option>
                                                    <option value="P">Partially Picked</option>
                                                    <option value="R" >Not Picked</option>
                                                    <option value="C">Completed</option>
                                                </select>
                                            </div>
                                        </div>                                        
                                        <div class="col-md-3">
                                        <label></label>
                                        <div class="form-group">
                                            <button class="btn btn-primary findBtn" type="submit" ng-hide="loadAnimPickListSearch">
                                                <g:message code="default.button.searchPickList.label" />
                                            </button>
                                             <span ng-show="loadAnimPickListSearch"><img src="${request.contextPath}/foysonis2016/app/img/loading.gif"/></span>
                                        </div>
                                        </div>
                                        <!-- <br style="clear: both;"/> -->
                                    </div>
                                </div>


                            </fieldset>
                        </div>

                    </div>
                </form>
            </div>
        </div>
        <!-- END search panel -->
        <br style="clear: both;"/>


        <div class="col-lg-12">
            <!-- START panel-->
            <div class="panel panel-default">
                <div class="panel-body">
                   
                    <p ng-if="ctrl.shipmentData.length > 0">
                    <div  id="grid1" ui-grid="gridListPicks"  ui-grid-exporter  ui-grid-auto-resize ui-grid-pagination ui-grid-resize-columns ng-style="getTableHeight()" class="grid">
                        <div class="noLocationMessage" ng-if="gridListPicks.data.length == 0" ><g:message code="pickList.grid.noData.message" /></div>
                    </div>
                    </p>

                </div>
                <!--/.panel-body -->
            </div>
            <!-- END panel-->
        </div>


        <!-- start List Picking popup -->

        <div id="listPickingProcess" class="modal fade" role="dialog"  data-backdrop="static">
            <div class="modal-dialog"  style="width: 55%;">
                <div class="modal-content">
                    <div class="modal-header" style="padding-top: 0px;">
                        <button  type="button" class="close" style="padding: 10px;" data-dismiss="modal" ng-click="ctrl.clearPickData()" aria-hidden="true">&times;</button>
                        <div ng-if="!ctrl.visibleDepositPage">
                            <div class="row pickingHeader">
                                <div class="col-md-6"><h4>Begin List Picking</h4></div>
                                <div ng-init="ctrl.pickIndex"></div>
                                <!-- <div class="col-md-6" ng-if="!ctrl.showPickToForm"><br style="clear: both;"/><label class="pull-right">Picking Progress&emsp;:&emsp;{{(ctrl.indexForDispaly%(ctrl.totalPickWorksOfPickList - ctrl.totalCompletedPicksOfPickList))+1}}&emsp;of&emsp;{{ctrl.totalPickWorksOfPickList - ctrl.totalCompletedPicksOfPickList}}</label></div> -->
                                <div class="col-md-6" ng-if="!ctrl.showPickToForm"><br style="clear: both;"/><label class="pull-right">Picking Progress&emsp;:&emsp;{{(ctrl.indexForDispaly%(ctrl.totalPickWorksToDisplay))+1}}&emsp;of&emsp;{{ctrl.totalPickWorksToDisplay}}</label></div>
                            </div> 
                            <br style="clear:both;">   
                            <div class="col-md-12 pickAttr">List ID&emsp;:&emsp;<span class="pickData">{{ctrl.pickWorkDataForPicking[ctrl.pickIndex].pickListId}}</span></div>
                            <div class="col-md-12 pickAttr">Total Number Of Picks&emsp;:&emsp;<span class="pickData">{{ctrl.totalPickWorksOfPickList}}</span></div>
                            <div class="col-md-12 pickAttr" >Number Of Completed Picks&emsp;:&emsp;<span class="pickData">{{ctrl.totalCompletedPicksOfPickList}}</span></div>                                
                            <div class="col-md-12 pickAttr" ng-if="ctrl.pickWorkDataForPicking[ctrl.pickIndex].customerName">Customer&emsp;:&emsp;<span class="pickData">{{ctrl.pickWorkDataForPicking[ctrl.pickIndex].customerName}}</span></div>
                            <div class="col-md-12 pickAttr" ng-if="ctrl.pickWorkDataForPicking[ctrl.pickIndex].companyName">Company&emsp;:&emsp;<span class="pickData">{{ctrl.pickWorkDataForPicking[ctrl.pickIndex].companyName}}</span></div>                                

                        </div>
                        <div ng-if="ctrl.visibleDepositPage">
                            <h4>Deposit All picks</h4>
                            <label>All picks have completed picking</label>
                        </div>
                        <br style="clear: both;"/>

                    </div>
                        <div class="modal-body">

                            <div class="alert alert-success message-animation" role="alert" ng-show="ctrl.showPickedPrompt">
                                <g:message code="picking.successfullypicked.message" />
                            </div>

                            <div class="col-md-12" ng-if="!ctrl.visibleDepositPage" style="padding: 0px;">
                                <div class="col-md-6" style="width: 40%; padding: 10px;">

                                    <div class="form-group">
                                        <label>Pick To&emsp;:&emsp;</label><br style="clear: both;">
                                        <select  name="pickTo" ng-model="ctrl.pickTo" class="form-control" style="width: 90%;display: inline;" ng-disabled = 'ctrl.disablePickToField'>
                                            <option ng-repeat = "options in ctrl.pickToOptions" value="{{options}}">{{options}}</option>
                                        </select>
                                        <em ng-show ='ctrl.disablePickToField' class="fa fa-check" style="font-size: 20px; color: #339933"></em>
                                    </div>

                                </div>

                                <div class="col-md-6" ng-if="ctrl.pickTo == 'PALLET'" style="padding: 10px; width: 60%;">

                                    <form name="ctrl.palletListPickingForm" ng-submit="ctrl.startPalletListPick()" novalidate >

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForPallet('palletId')}">
                                                <label for="palletId">Pick to Pallet Id&emsp;:&emsp;</label><br style="clear: both;">
                                                <input type="text" id="pickToPalletId" name="palletId" class="form-control" style="width: 50%; display: inline;" ng-model="ctrl.picking.palletId" placeholder="PalletId" ng-disabled="!ctrl.showPickToForm" ng-blur="ctrl.uniquePalletIdValidation(ctrl.picking.palletId)" ng-keypress="ctrl.palletIdValidationForScan($event)" capitalize required />

                                                <div class="my-messages" style="margin-left: 80px; position: absolute;" ng-messages="ctrl.palletListPickingForm.palletId.$error" ng-if="ctrl.showMessagesForPallet('palletId')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>


                                                <div class="my-messages" style="margin-left: 80px; position: absolute;" ng-messages="ctrl.palletListPickingForm.caseId.$error"
                                                     ng-if="ctrl.palletListPickingForm.$error.palletIdExists">
                                                    <div class="message-animation" >
                                                        <strong>Pallet Id exists already.</strong>
                                                    </div>
                                                </div>
                                                
                                                <button class="btn btn-primary confirmPickBtn" type="submit" ng-if="ctrl.showPickToForm" ng-disabled = "ctrl.palletListPickingForm.$error.palletIdExists || !ctrl.picking.palletId">Confirm</button>
                                                <em ng-if ='!ctrl.showPickToForm' class="fa fa-check" style="font-size: 20px; color: #339933"></em>
                                            </div>

                                            
                                    </form>

                                </div>  


                                <div class="col-md-6" ng-if="ctrl.pickTo == 'CARTON'" style="padding: 10px; width: 60%;">

                                    <form name="ctrl.caseListPickingForm" ng-submit="ctrl.startCaseListPick()" novalidate >
   
                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassForCase('caseId')}">
                                        <label for="caseId">Pick to Case Id&emsp;:&emsp;</label><br style="clear: both;">                                            
                                            <input type="text" id="pickToCaseId" name="caseId" class="form-control" style="width: 50%; display: inline;" ng-model="ctrl.picking.caseId" placeholder="Case Id" ng-disabled="!ctrl.showPickToForm" ng-blur="ctrl.uniqueCaseIdValidation(ctrl.picking.caseId)" ng-keypress="ctrl.caseIdValidationForScan($event)" capitalize required />

                                            <div class="my-messages" style="margin-left: 80px; position: absolute;" ng-messages="ctrl.caseListPickingForm.caseId.$error" ng-if="ctrl.showMessagesForCase('caseId')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>


                                            <div class="my-messages" style="margin-left: 80px; position: absolute;" ng-messages="ctrl.caseListPickingForm.caseId.$error"
                                                 ng-if="ctrl.caseListPickingForm.$error.caseIdExists">
                                                <div class="message-animation" >
                                                    <strong>Case Id exists already.</strong>
                                                </div>
                                            </div> 

                                            <button class="btn btn-primary confirmPickBtn" type="submit" ng-if="ctrl.showPickToForm" ng-disabled = "ctrl.caseListPickingForm.$error.caseIdExists">Confirm</button>
                                            <em ng-if ='!ctrl.showPickToForm' class="fa fa-check" style="font-size: 20px; color: #339933"></em>
                                        </div>
                                        
                                                                              
                                    </form>


                                </div>                                                             


                                <div class="col-md-6" ng-if="ctrl.pickTo == 'HAND CARRY'" style="padding: 15px; padding-left: 0px; margin-left: -40px;">
                                    <form name="ctrl.handCarryPickingForm" ng-submit="ctrl.startHandCarryListPick()" novalidate >
                                        <div class="col-md-3">
                                            <br style="clear: both;">
                                            <button class="btn btn-primary confirmPickBtn" type="submit" ng-if="ctrl.showPickToForm" >Confirm</button>
                                        </div>
                                    </form>
                                </div>

                            </div>

                            <form name="ctrl.confirmPickWorkForm" ng-submit="ctrl.confirmPickWork()" novalidate>
                            <div class="col-md-12" ng-if="!ctrl.showPickToForm">
                            
                            <hr/>
                                <div class="col-md-12" style="text-align: center;color: #e43737;padding-bottom: 20px;" ng-show=" ctrl.pickWorkDataForPicking[ctrl.pickIndex].isSkipped">Previously Skipped Pick</div>

                                <div class="col-md-6">

                                    <!-- <label>Pick To&emsp;:&emsp;{{ctrl.isPickToType}}</label>
                                    <br style="clear: both;"/>
                                    <br style="clear: both;"/>-->
                                    <label>Pick Work Reference&emsp;:&emsp;{{ctrl.picking.workReferenceNumber = ctrl.pickWorkDataForPicking[ctrl.pickIndex].workReferenceNumber}}</label>
                                    <br style="clear: both;"/>
                                    <br style="clear: both;"/>
                                    <label>Source Location&emsp;:&emsp;{{ctrl.pickWorkDataForPicking[ctrl.pickIndex].sourceLocationId}}</label>
                                    <br style="clear: both;"/>
                                    <br style="clear: both;"/>                                    

                                </div> 

                                <div class="col-md-3" style="width: 220px;">

                                    <!-- <label ng-if="ctrl.isPickToType == 'PALLET'">PALLET ID&emsp;:&emsp;{{ctrl.picking.palletId}}</label>
                                    <label ng-if="ctrl.isPickToType == 'CASE'">CASE ID&emsp;:&emsp;{{ctrl.picking.caseId}}</label> --> 
                                    <label>Status&emsp;:&emsp;{{ctrl.pickWorkDataForPicking[ctrl.pickIndex].pickStatus}}</label>
                                    <br style="clear: both;"/>
                                    <br style="clear: both;"/>
                                    <label ng-if="ctrl.pickWorkDataForPicking[ctrl.pickIndex].notes">Order Notes&emsp;:&emsp;{{ctrl.pickWorkDataForPicking[ctrl.pickIndex].notes}}</label>

                                </div>

                                <div class="col-md-6">
                                    <label>Item ID&emsp;:&emsp;{{ctrl.pickWorkDataForPicking[ctrl.pickIndex].itemId}} - {{ctrl.pickWorkDataForPicking[ctrl.pickIndex].itemDescription}}</label>
                                </div>
                                <div class="col-md-6">
                                    <label>Inventory Status&emsp;:&emsp;{{ctrl.pickWorkDataForPicking[ctrl.pickIndex].requestedInventoryStatus}}</label>
                                </div> <br style="clear:both;" /><br style="clear:both;" />                               
                                <div class="col-md-12" style="margin-left:-15px">
                                    <div class="col-md-6">
                                        <label for="pickQty">Pick Qty :</label>
                                        <div class="form-group">
                                            <input type="number" name="pickQty" class="form-control" ng-model="ctrl.picking.pickQty = ctrl.pickWorkDataForPicking[ctrl.pickIndex].pickQuantity - ctrl.pickWorkDataForPicking[ctrl.pickIndex].completedQuantity" disabled/>
                                        </div>  

                                        <label for="pickFrom">Pick From :</label>                                   
                                        <div class="form-group">
                                            <select  name="pickFrom" ng-model="ctrl.pickFrom" class="form-control" ng-disabled = "ctrl.disablePickFromOptions">
                                                <option ng-repeat = "pickingOptions in ctrl.pickFromOptions">{{pickingOptions}}</option>
                                            </select>
                                    </div>

                                    </div>

                                    <div class="col-md-6">
                                        <label for="pickQtyUom">Pick Qty UOM :</label>
                                        <div class="form-group">
                                            <input type="text" name="pickQtyUom" class="form-control" ng-model="ctrl.pickWorkDataForPicking[ctrl.pickIndex].pickQuantityUom" disabled/>
                                        </div>

                                        <div class="form-group" ng-if="ctrl.pickFrom == 'PALLET'">
                                            <label for="pickFrom">Pick From Pallet ID :</label>
                                            <input type="text" name="pickFromPalletId" class="form-control" ng-model="ctrl.picking.pickFromPalletId" ng-blur="ctrl.validatePalletIdForPick(ctrl.pickWorkDataForPicking[ctrl.pickIndex].orderLineNumber, ctrl.pickWorkDataForPicking[ctrl.pickIndex].sourceLocationId, ctrl.pickWorkDataForPicking[ctrl.pickIndex].pickType)" capitalize required/>


                                                <div class="my-messages" ng-messages="ctrl.confirmPickWorkForm.pickFromPalletId.$error" ng-if="ctrl.confirmPickWorkForm.pickFromPalletId.$touched || ctrl.confirmPickWorkForm.$submitted">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                                <div class="my-messages"  ng-messages="ctrl.confirmPickWorkForm.pickFromPalletId.$error"
                                                ng-if="ctrl.palletIdValidationError">
                                                    <div class="message-animation" >
                                                        <strong><g:message code="picking.palletIdValidationError.message" />
                                                        </strong>
                                                    </div>
                                                </div>
                                        </div>


                                        <div class="form-group" ng-if="ctrl.pickFrom == 'CASE'">
                                            <label for="pickFrom">Pick From Case ID :</label>
                                            <input type="text" name="pickFromCaseId" class="form-control" ng-model="ctrl.picking.pickFromCaseId" ng-blur="ctrl.validateCaseIdForPick(ctrl.pickWorkDataForPicking[ctrl.pickIndex].orderLineNumber, ctrl.pickWorkDataForPicking[ctrl.pickIndex].sourceLocationId,ctrl.pickWorkDataForPicking[ctrl.pickIndex].pickType)" capitalize required/>


                                                <div class="my-messages" ng-messages="ctrl.confirmPickWorkForm.pickFromCaseId.$error" ng-if="ctrl.confirmPickWorkForm.pickFromCaseId.$touched || ctrl.confirmPickWorkForm.$submitted">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                                <div class="my-messages"  ng-messages="ctrl.confirmPickWorkForm.pickFromCaseId.$error"
                                                ng-if="ctrl.caseIdValidationError">
                                                    <div class="message-animation" >
                                                        <strong>{{ctrl.caseValidationErrorMsg}}</strong>
                                                    </div>
                                                </div>
                                        </div>

                                    </div>                                    
                                </div>

                                <div class="col-md-8" style="margin-left:-15px">

                                    <div class="col-md-5">

                                        <label for="completedQty">Completed Qty :</label>
                                        <div class="form-group">
                                            <input type="number" name="completedQty" min="1" class="form-control" ng-model="ctrl.picking.completedQty" ng-blur = "" ng-disabled = "ctrl.palletIdValidationError || ctrl.caseIdValidationError" required/>
                                        </div>


                                            <div class="my-messages" ng-messages="ctrl.confirmPickWorkForm.completedQty.$error" ng-if="ctrl.confirmPickWorkForm.completedQty.$touched || ctrl.confirmPickWorkForm.$submitted">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages"  ng-messages="ctrl.confirmPickWorkForm.completedQty.$error"
                                            ng-if="ctrl.completedQtyValidationError">
                                                <div class="message-animation" >
                                                    <strong><g:message code="picking.completedQtyError.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages"  ng-messages="ctrl.confirmPickWorkForm.completedQty.$error"
                                            ng-if="ctrl.completedQtyValidationError && ctrl.completedQtyValidationErrorForPallet">
                                                <div class="message-animation" >
                                                    <strong><g:message code="picking.palletQtyError.message" /> {{ctrl.picking.pickFromPalletId}}.</strong>
                                                </div>
                                            </div> 

                                            <div class="my-messages"  ng-messages="ctrl.confirmPickWorkForm.completedQty.$error"
                                            ng-if="ctrl.completedQtyValidationError && ctrl.completedQtyValidationErrorForLocation">
                                                <div class="message-animation" >
                                                    <strong><g:message code="picking.locationQtyError.message" /> {{ctrl.pickWorkDataForPicking[ctrl.pickIndex].sourceLocationId}}.</strong>
                                                </div>
                                            </div>   

                                            <div class="my-messages"  ng-messages="ctrl.confirmPickWorkForm.completedQty.$error"
                                            ng-if="ctrl.completedQtyValidationError && ctrl.completedQtyValidationErrorForCase">
                                                <div class="message-animation" >
                                                    <strong><g:message code="picking.caseQtyError.message" /> {{ctrl.picking.pickFromCaseId}}.</strong>
                                                </div>
                                            </div>                                                                                                                                  

                                    </div>

                                    <div class="col-md-3" style="padding: 5px;">
                                        <br style="clear: both;"/>
                                        <button type="submit" class="btn btn-primary confirmPickBtn" ng-disabled = "!ctrl.picking.completedQty || ctrl.picking.completedQty <= 0 || ctrl.disableConfirmBtn">{{ctrl.ConfirmBtnText}}</button>
                                    </div>
                                                                    
                                </div>


                            </div>

                            <div class="col-md-12" ng-if="ctrl.visibleDepositPage">
                            

                                <div class="col-md-6">

                                    <label>Pick List Id&emsp;:&emsp;{{ctrl.rowsOfPickList.pick_list_id}}</label>
                                    <br style="clear: both;"/>
                                    <br style="clear: both;"/>
                                    <label>Created Date&emsp;:&emsp;{{ctrl.getConvertedDate(ctrl.rowsOfPickList.created_date)}}</label>
                                    <br style="clear: both;"/>
                                    <br style="clear: both;"/>
                                    <label>Last Update Date&emsp;:&emsp;{{ctrl.getConvertedDate(ctrl.rowsOfPickList.last_update_date)}}</label>
                                    <br style="clear: both;"/>
                                    <br style="clear: both;"/>

                                </div>

                                <div class="col-md-6">
                                    <label>Status&emsp;:&emsp;{{ctrl.pickListStatus}}</label>
                                    <br style="clear: both;"/>
                                    <br style="clear: both;"/>

                                    <label>Destination Location&emsp;:&emsp;{{ctrl.pickWorkDataForPicking[ctrl.pickIndex].destinationLocationId}}</label>
                                    <br style="clear: both;"/>
                                    <br style="clear: both;"/>

                                </div>

                            </div>



                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="modal-footer" ng-if="!ctrl.showPickToForm">
                                <div class="controls pull-left">
                                    <div class="checkbox c-checkbox" style="display: none;">
                                        <label>
                                            <input type="checkbox" value="" ng-click="" ng-model="ctrl.picking.tryToReAllocate">
                                            <span class="fa fa-check"></span><!-- <g:message code="form.field.dateRange.label" /> -->Try to re-allocate</label>
                                    </div>
                                </div>

                                <br style="clear: both;"/>

                                <button type="button" class="btn btn-default" ng-hide="((ctrl.totalPickWorksOfPickList - ctrl.totalCompletedPicksOfPickList) <= 1 ) || ctrl.hideSkipPickBtn" ng-click="ctrl.skipPickWork()" ng-disabled = "">Skip Pick</button>

                                <button ng-show = "ctrl.isAdminUser && ctrl.pickWorkDataForPicking[ctrl.pickIndex].pickType != 'KITTING'" type="button" class="mb-sm btn btn-danger pull-left" ng-click = "ctrl.cancelAllocationForPickWork(ctrl.picking.workReferenceNumber, ctrl.pickWorkDataForPicking[ctrl.pickIndex].completedQuantity)"><g:message code="default.button.cancelPick.label" /></button>
                                <button type="button" class="btn btn-primary" ng-click = 'ctrl.directToDeposit()' ng-disabled = "ctrl.pickIndex == 0"><!-- <g:message code="default.button.confirm.label" /> -->Deposit</button>
                            </div>

                            <div class="modal-footer" ng-if = "ctrl.visibleDepositPage" style="text-align: center;">
                                <input type="text" name="destinationLocation" class="form-control" ng-model="ctrl.picking.destinationLocation" ng-blur = "ctrl.validateDestinationLoc(ctrl.picking.destinationLocation, ctrl.pickWorkDataForPicking[ctrl.pickIndex].destinationLocationId)" style="width: 200px; display: inline;" capitalize/> 

                                    <div class="my-messages" style="margin-left: 80px; position: absolute;" ng-messages=""
                                         ng-if="ctrl.disableDeposit">
                                        <div class="message-animation" >
                                            <strong>{{ctrl.destinationLocationErrorMsg}}</strong>
                                        </div>
                                    </div>                                                            
                                <button type="button" class="btn btn-primary" ng-click = 'ctrl.depositePicks(ctrl.picking.destinationLocation, ctrl.pickWorkDataForPicking[ctrl.pickIndex].destinationLocationId)' ng-disabled="!ctrl.picking.destinationLocation || ctrl.disableDeposit || ctrl.disableDepositPick">Deposit</button>
                                <br style="clear: both;"/>
                                <br style="clear: both;"/>
                            </div>                            
                        </form>

                        </div>
                </div>
            </div>
        </div>
        <!-- end List Picking popup -->

        <div id="CancelPickWarningModel" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Confirmation</h4>
                    </div>
                    <div class="modal-body">
                        <!-- <g:message code="picking.cancelPickWarning.message" /> --><p>Do you really want to cancel this pick?</p>
                        <div class="form-group">
                            <label for="reasonCancelPick">Reason</label>
                            <select  id="reasonCancelPick" name="reasonCancelPick" ng-model="ctrl.reasonCancelPick" class="form-control" >
                                <option value="noOption" >Please select a reason.</option>
                                <option ng-repeat="listValue in  ctrl.listValueCancelPick" value="{{listValue.optionValue}}">{{listValue.description}}
                                </option>
                            </select>

                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                        <button type="button" id = "cancelPickButton" class="btn btn-primary" ng-disabled="ctrl.reasonCancelPick == 'noOption' || !ctrl.reasonCancelPick"><g:message code="default.button.ok.label" /></button>
                    </div>
                </div>
            </div>
        </div>

    </div><!-- End Of ctrl -->

<!-- bootstrap modal confirmation dialog-->

<div id="partiallyReadyWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <!-- <g:message code="picking.partiallyReadyWarning.message" /> -->Not all picks can be completed at this time. Some picks are waiting for inventory on Pick Face
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "acceptPartiallyPickingButton" class="btn btn-primary"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>

<div id="CancelPickSuccessModel" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Cancel Pick</h4>
            </div>
            <div class="modal-body">
                <g:message code="picking.cancel.successfull.message" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
    <asset:javascript src="datagrid/listPicking.js"/>

    <script type="text/javascript">
        var dvListPicking = document.getElementById('dvListPicking');
        angular.element(document).ready(function() {
            angular.bootstrap(dvListPicking, ['listPicking']);
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
