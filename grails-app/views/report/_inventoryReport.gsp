    <div class="col-lg-12">
        <!-- START panel-->
        <div class="panel panel-default" style="padding: 0px 1px 0 10px;">
            <div class="panel-header"><h4>Inventory Report</h4></div>
            <div class="panel-body">
<!--                 <div class="col-md-12">

                <div class="col-md-4">
                    <label for="areaSearch">Area</label>
                    <select  id="areaSearch" name="areaSearch" ng-model="ctrl.areaSearchVal" class="form-control" >
                        <option ng-repeat="area in ctrl.allAreaData" value="{{area.areaId}}">{{area.areaId}}</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <div class="form-group">
                        <label><g:message code="form.field.location.label" /></label>
                        <div class="controls">

                            <div auto-complete  source="loadLocationAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars = '3'
                                 value-changed="" style="position: absolute; z-index: 1;">
                                <input ng-model="ctrl.locationSearchVal" placeholder="Location Id" class="form-control" ng-blur='ctrl.clearAutoCompText()'>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <label for="inventoryStatusSearch"><g:message code="form.field.inventoryStatus.label" /></label>
                    <select  id="inventoryStatusSearch" name="inventoryStatusSearch" ng-model="ctrl.inventoryStatusSearchVal" class="form-control">
                        <option>GOOD</option>
                        <option>DAMAGED</option>
                        <option>HOLD</option>
                        <option>EXPIRED</option>
                    </select>
                </div>
                </div>
                <div class="col-md-12">
                <div class="col-md-4">
                    <div class="form-group">
                        <label><g:message code="form.field.itemId.label" /></label>
                            <div auto-complete  source="loadCompanyItems"  xxxx-list-formatter="customListFormatter"
                                 value-changed="" style="position: absolute; z-index: 1;">
                                <input ng-model="ctrl.itemSearchVal" placeholder="Item" class="form-control" ng-blur='ctrl.clearItemAutoCompText()'>
                            </div>

                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label>&nbsp;</label>
                        <div class="controls">
                            <div class="checkbox c-checkbox">
                                <label>
                                    <input type="checkbox" value="" ng-model="ctrl.includePickedInventorySearch">
                                    <span class="fa fa-check"></span>Include Picked Inventory</label>
                            </div>
                        </div>
                    </div>
                </div>
                </div> -->
                <div ng-repeat="reportParam in ctrl.getReportParameter">
                    
                    <div class="col-md-4" ng-if="reportParam.valueType=='java.lang.String'">

                        <div ng-switch="reportParam.name">
                          <div ng-switch-when="areaId">
                                    <div class="form-group">
                                    <label for="areaSearch">Area</label>
                                    <select  id="areaSearch" name="areaSearch" ng-model="reportParam.inputValues" class="form-control" >
                                        <option ng-repeat="area in ctrl.allAreaData" value="{{area.areaId}}">{{area.areaId}}</option>
                                    </select>
                                    </div>

                          </div>
                          <div ng-switch-when="locationId">

                                <div class="form-group">
                                    <label><g:message code="form.field.location.label" /></label>
                                    <div class="controls">

                                        <div auto-complete  source="loadLocationAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars = '3'
                                             value-changed="" style="position: absolute; z-index: 1;">
                                            <input ng-model="reportParam.inputValues" placeholder="Location Id" class="form-control" ng-blur="reportParam.inputValues=''">
                                        </div>

                                    </div>
                                </div>

                          </div>
                          <div ng-switch-when="inventoryStatus">

                                <div class="form-group">
                                <label for="inventoryStatusSearch"><g:message code="form.field.inventoryStatus.label" /></label>
                                <select  id="inventoryStatusSearch" name="inventoryStatusSearch" ng-model="reportParam.inputValues" class="form-control">
                                    <option ng-repeat="option in ctrl.inventoryStatusOptions" ng-value="option.optionValue">{{option.description}}</option>                                </select>
                                </div>
 
                          </div>
                          <div ng-switch-when="itemId">

                                    <label><g:message code="form.field.itemId.label" /></label>
                                        <div auto-complete  source="loadCompanyItems"  xxxx-list-formatter="customListFormatter"
                                             value-changed="" style="position: absolute; z-index: 1;">
                                            <input ng-model="reportParam.inputValues" placeholder="Item" class="form-control" ng-blur="reportParam.inputValues=''">
                                        </div>

                          </div> 
                          <div ng-switch-when="itemCategory">

                                    <label><g:message code="form.field.category.label" /></label>
                                                <select  id="itemCategory" name="itemCategory" ng-model="reportParam.inputValues" class="form-control">
                                                    <option value="">None</option>
                                                    <option ng-repeat="listValue in  ctrl.listValue" value="{{listValue.optionValue}}" >{{listValue.description}}
                                                    </option>
                                                </select>

                          </div>                          
                          <div ng-switch-default>
                                <div class="form-group">
                                <label for="{{reportParam.name}}">{{filterLabelText(reportParam.name)}}</label>
                                <input id="{{reportParam.name}}" name="{{reportParam.name}}" class="form-control" type="text" capitalize 
                                       ng-model="reportParam.inputValues"
                                       ng-focus="ctrl.toggleItemIdPrompt(true)" ng-blur=""/>

                                </div>
                          </div>
                        </div>
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
                    <button class="btn btn-primary" type="button" ng-click="getInventoryReport(ctrl.fileType)">Get Inventory Report</button>
                </div>
                <div class="pull-right" style="padding-right: 20px;">
                    <div ng-init="ctrl.fileType='PDF'"></div>
                    <select  id="fileType" name="fileType" ng-model="ctrl.fileType" class="form-control" style="height: 47px;">
                        <option value="PDF">PDF</option> 
                        <option value="CSV">Excel (CSV)</option>                                
                    </select>&emsp;                      
                </div>              
                <br style="clear: both;"/>
            </div>
        </div>
        <!-- END panel-->

    </div>


    <div id="viewInventoryReport" class="modal fade" role="dialog">
    <div class="modal-dialog" style="width:80%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div>
                    <iframe id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.inventorySrcStrg}}"><iframe/>
                    <!-- <embed id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.inventorySrcStrg}}"/> -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click='printReport(ctrl.inventorySrcStrg)'>Print</button>
                <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click="ctrl.openMailAddrModal(ctrl.inventorySrcStrg)">Email</button>
            </div>
        </div>
    </div>
    </div> 

<!-- </div> --><!-- End of CustomerCtrl -->