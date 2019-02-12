    <div class="col-lg-12">
        <!-- START panel-->
        <div class="panel panel-default" style="padding: 0px 1px 0 10px;">
            <div class="panel-header"><h4>Pending Putaway Report</h4></div>
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
                    <button class="btn btn-primary" type="button" ng-click="getPendingPutawayInventoryReport()">Get Pending Putaway Report</button>
                </div>
                <br style="clear: both;"/>
            </div>
        </div>
        <!-- END panel-->

    </div>


    <div id="pendingPutawayInventoryReport" class="modal fade" role="dialog">
    <div class="modal-dialog" style="width:80%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div>
                 <!-- <embed id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.pendingPutawayInvSrcStrg}}"/> -->
                 <iframe id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.pendingPutawayInvSrcStrg}}"></iframe>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click='printReport(ctrl.pendingPutawayInvSrcStrg)'>Print</button>
                <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click="ctrl.openMailAddrModal(ctrl.pendingPutawayInvSrcStrg)">Email</button>
            </div>
        </div>
    </div>
    </div> 



<!-- </div> --><!-- End of CustomerCtrl -->


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