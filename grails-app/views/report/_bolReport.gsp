    <div class="col-lg-12">
        <!-- START panel-->
        <div class="panel panel-default" style="padding: 0px 1px 0 10px;">
            <div class="panel-header"><h4>Bill Of Lading Report</h4></div>
            <div class="panel-body">
                <div ng-repeat="reportParam in ctrl.getReportParameter">
                    
                    <div class="col-md-4" ng-if="reportParam.valueType=='java.lang.String'">
                        <label for="{{reportParam.name}}">{{filterLabelText(reportParam.name)}}</label>
                        <input id="{{reportParam.name}}" name="{{reportParam.name}}" class="form-control" type="text" capitalize 
                               ng-model="reportParam.inputValues"
                               ng-focus="ctrl.toggleItemIdPrompt(true)" ng-blur=""/>
                   </div>

                    <div class="col-md-4" ng-if="reportParam.valueType=='java.lang.Number' || reportParam.valueType=='java.lang.Integer' ">
                        <label for="{{reportParam.name}}">{{filterLabelText(reportParam.name)}}</label>
                        <input id="{{reportParam.name}}" name="{{reportParam.name}}" class="form-control" type="number" capitalize 
                               ng-model="reportParam.inputValues"
                               ng-focus="ctrl.toggleItemIdPrompt(true)" ng-blur=""/>
                   </div>

                    <div class="col-md-4" ng-if="reportParam.valueType=='java.util.Date'">
                        <label for="{{reportParam.name}}">{{filterLabelText(reportParam.name)}}</label>
                        <input id="{{reportParam.name}}" name="{{reportParam.name}}" class="form-control" type="date" capitalize 
                               ng-model="reportParam.inputValues"
                               ng-focus="ctrl.toggleItemIdPrompt(true)" ng-blur=""/>
                   </div>

                </div>
            </div>
            <div class="panel-footer">
                <div class="pull-right">
                    <button class="btn btn-primary" type="button" ng-click="getBolReport()">Print BOL</button>
                </div>
                <br style="clear: both;"/>
            </div>
        </div>
        <!-- END panel-->

    </div>


    <div id="viewBolReport" class="modal fade" role="dialog">
    <div class="modal-dialog" style="width:80%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div>
                <!-- <embed id="pdfReport" style="height:450px; width: 100%;" src="/report?format=PDF&file=billOfLading&_controller=com.foysonis.orders.ShipmentController&_action=getBillOfLadingReport&fileFormat=PDF&accessType=inline"> -->
                    <iframe id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.bolSrcStrg}}"></iframe>
                 <!-- <embed id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.bolSrcStrg}}"/> -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" class="btn btn-default" data-dismiss="modal" ng-click='editBOL()'>Edit</button>
                <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click='printReport(ctrl.bolSrcStrg)'>Print</button>
                <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click="ctrl.openMailAddrModal(ctrl.bolSrcStrg)">Email</button>
            </div>
        </div>
    </div>
    </div> 


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
                                    <input id="itemId" name="pkgs" class="form-control" type="text"
                                                   ng-model="ctrl.customerOrderInfo[$index].pkgs" />

                                </div> 
                            </div>

                            <div class="col-md-2">
                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('expectedExpirationDate'+ $index)}">
                                    <input id="{{'weight' + $index}}" name="{{'expectedExpirationDate' + $index}}" class="form-control" type="text" required
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
                    <div><!-- Carrier Information -->
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
                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showReportUpdatedPrompt"> Report Information for shipment {{ctrl.selectedShipmentId}} has been updated successfully
                        </div> 
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


<!-- </div> --><!-- End of CustomerCtrl -->

<div id="truckIdValidationWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>Truck Id is mandatory. Please enter a value and continue.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>

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
