

    <div class="col-lg-12">
        <!-- START panel-->
        <div class="panel panel-default" style="padding: 0px 1px 0 10px;">
            <div class="panel-header"><h4>Order Report</h4></div>
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

                    <div class="col-md-4" ng-if="reportParam.valueType=='java.lang.Boolean'">
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <div class="controls">
                                <div class="checkbox c-checkbox">
                                    <label for="{{reportParam.name}}">
                                        <input id="{{reportParam.name}}" type="checkbox" value="" ng-model="reportParam.inputValues">
                                        <span class="fa fa-check"></span>{{filterLabelText(reportParam.name)}}</label>
                                </div>
                            </div>
                        </div>
                    </div>


                </div>
            </div>
            <div class="panel-footer">
                <div class="pull-right">
                    <button class="btn btn-primary" type="button" ng-click="getOrderReport()">Get order Report</button>
                </div>
                <br style="clear: both;"/>
            </div>
        </div>
        <!-- END panel-->

    </div>


    <div id="orderReportModal" class="modal fade" role="dialog">
    <div class="modal-dialog" style="width:80%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div>
                 <!-- <embed id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.orderReportSrcStrg}}"/> -->
                 <iframe id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.orderReportSrcStrg}}"/></iframe>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click='printReport(ctrl.orderReportSrcStrg)'>Print</button>
                <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click="ctrl.openMailAddrModal(ctrl.orderReportSrcStrg)">Email</button>
            </div>
        </div>
    </div>
    </div> 



<!-- </div> --><!-- End of CustomerCtrl -->


<!--start warning dialog- pick work  -->
<div id="orderValidationModal" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title"><g:message code="default.dialog.warning.label" /></h4>
            </div>
            <div class="modal-body">
                <p>Please enter a valid order number.</p>
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
