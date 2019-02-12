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
            width: 950px;
        }

        .grid-align {
            text-align: center;
        }

        .grid-action-align {
            padding-left: 60px;
        }

        .dropdown-menu {
            min-width: 90px;
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

        .mainItemfield {
            border-top: 1px solid #a0a0a0;
            padding-top: 10px;
        }

        .subItemDiv {
            padding-left: 100px;
            //padding-top: 20px;
            //padding-bottom: 30px;
        }

        .customItemDiv {
            padding-left: 30px;
            padding-top: 20px;            
        }

        .mainHeading {
            border-bottom: 1px solid #a0a0a0;    
            font-size: 20px;
            padding:10px;
        }

        .itmCheckBox {
            border: 1.2px solid #8ad6cc !important; 
        }

        .itmCheckInput:checked + span:before  {
          color: #8ad6cc !important;  
          background-color: #ffffff;
        }

        .itmfooter{
            background-color: #ffffff;
        }

        [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
            display: none !important;
        }

    </style>

<%-- **************************** End of CSS **************************** --%>    

</head>

<body>


    <div ng-cloak class="row" id="dvAdminClientBilling" ng-controller="clientBillingCtrl as ctrl">

        <div class="col-lg-12">
            <!-- START search panel-->
            <div class="col-lg-8">
                <div><em class="fa  fa-fw mr-sm" ><img style="width: 30px; padding-bottom: 10px;" src="/foysonis2016/app/img/invoice_ico50.png"></em>&emsp;&emsp;<span class="headerTitle">Commercial Invoice</span></div>
                <br style="clear: both;"/>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <legend style="border-bottom: 1px solid #a0a0a0;">
                           <g:message code="default.search.label" />
                        </legend></a>
                    </div>
                    <div class="panel-body">
                        <form name="ctrl.invoiceSearchForm"  ng-submit="ctrl.commercialInvoiceSearch()">
                            <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                                <div>
                                    <fieldset>

                                        <div class="row">

                                            <div class="col-md-12">

                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label>Invoice Number</label>
                                                        <input type="text" name="invNumber" class="form-control" ng-model="ctrl.findCommercialInvNum" placeholder="Enter Number" ng-keypress = "ctrl.commercialInvNumErrorMsg = false" capitalize />
                                                    </div>
                                                    <div class="my-messages" ng-messages="ctrl.invoiceSearchForm.invNumber.$error" ng-if="ctrl.commercialInvNumErrorMsg">
                                                        <div class="message-animation">
                                                           Invalid invoice number
                                                        </div>
                                                    </div>
                                                </div>                                        
                                                <div class="col-md-6">
                                                <label></label>
                                                <div class="form-group">
                                                    <button class="btn btn-primary findBtn" type="submit" ng-hide="loadAnimPickListSearch">
                                                        Find
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
            </div>

            <!-- END search panel -->
            <br style="clear: both;"/>

            <div class="col-lg-8">

            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="panel-title mainHeading">Generate Invoice</div>
                </div>
                <form name="ctrl.generateInvoiceForm" ng-submit="ctrl.saveCommercialInvoice()" novalidate >           
                <div class="panel-body">
                    
                    <div>
                        <div class="col-md-4">
                            <label>Invoice Number</label>
                            <input id="invoiceNumber" name="invoiceNumber" class="form-control" type="text" maxlength="30"  ng-model="ctrl.commercialInvoiceData.invoiceNumber" ng-blur="ctrl.validateCommercialInvNumber(ctrl.commercialInvoiceData.invoiceNumber)" placeholder="Enter Amount" style="width: 250px;" required />

                            <div class="my-messages" ng-messages="ctrl.generateInvoiceForm.invoiceNumber.$error" ng-if="ctrl.showMessages('invoiceNumber')">
                                <div class="message-animation" ng-message="required">
                                    <strong><g:message code="required.error.message" /></strong>
                                </div>
                            </div>
                            <div class="my-messages" ng-messages="ctrl.generateInvoiceForm.invoiceNumber.$error" ng-if="ctrl.generateInvoiceForm.$error.commercialNumberExists">
                                <div class="message-animation">
                                    Invoice number already exist
                                </div>
                            </div>

                        </div>
                        <div class="col-md-4">
                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('fromDate')}">
                                <label for="fromDate">From :</label>
                                <p class="input-group">
                                    <input type="text" id="fromDate" name="fromDate" class="form-control" uib-datepicker-popup="{{format}}"
                                           ng-model="ctrl.commercialInvoiceData.fromDate" is-open="popupFromDate.opened"
                                           datepicker-options="dateOptions"  ng-required="true" close-text="Close"
                                           alt-input-formats="altInputFormats" ng-model-options="{timezone:'UTC'}" tabindex="3" />
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-default" ng-click="openFromDate()">
                                            <i class="glyphicon glyphicon-calendar"></i></button>
                                    </span>
                                </p>
                            </div> 

                            <div class="my-messages" ng-messages="ctrl.generateInvoiceForm.fromDate.$error" ng-if="ctrl.showMessages('fromDate')">
                                <div class="message-animation" ng-message="required">
                                    <strong><g:message code="required.error.message" /></strong>
                                </div>
                            </div>                           
                        </div>
                        <div class="col-md-4">
                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassOrder('lateShipDate')}">
                                        <label for="ToDate">To :</label>
                                        <p class="input-group">
                                            <input id="ToDate" name="ToDate" type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                   ng-model="ctrl.commercialInvoiceData.toDate" is-open="popupToDate.opened"
                                                   datepicker-options="dateOptions"  ng-required="true" close-text="Close"
                                                   alt-input-formats="altInputFormats" ng-model-options="{timezone:'UTC'}" tabindex="4" required />
                                            <span class="input-group-btn">
                                                <button type="button" class="btn btn-default" ng-click="openToDate()">
                                                    <i class="glyphicon glyphicon-calendar"></i></button>
                                            </span>
                                        </p>

                                    </div>
                                    <div class="my-messages" ng-messages="ctrl.generateInvoiceForm.ToDate.$error" ng-if="ctrl.showMessages('ToDate')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>                           
                        </div>                        
                        <br style="clear: both;" />
                        <br style="clear: both;" />
                            <div ng-repeat="billingItem in commercialBillingItemData" class="col-md-12 mainItemfield">
                                <div class="form-group">
                                    <div class="col-md-4" style="width: 290px;">
                                        <div ng-init="commercialBillingItemData[$index].is_item_selected = true;"></div>
                                        <div class="checkbox c-checkbox">
                                            <label><input id="{{billingItem.id}}" name="{{billingItem.id}}"  type="checkbox" ng-model="commercialBillingItemData[$index].is_item_selected" class="itmCheckInput"/>
                                            <span class="fa fa-check itmCheckBox"></span>&emsp;{{billingItem.name}}</label> 
                                        </div>
                                    </div>
                                    <div class="col-md-4" ng-if="!disableTextBox[$index]"><input id="{{billingItem.id}}" name="{{billingItem.id}}" class="form-control" type="number" maxlength="30"  ng-model="commercialBillingItemData[$index].billing_amount" placeholder="Enter Amount" style="width: 200px;" /></div>
                                    <div ng-if="!disableTextBox[$index]" >
                                        &emsp;Min Rate&nbsp;:&emsp;
                                        <input id="minRate_{{billingItem.id}}" name="minRate_{{billingItem.id}}" class="form-control" type="number" maxlength="30"  ng-model="commercialBillingItemData[$index].min_rate" placeholder="Enter Amount" style="width: 100px; display: inline;" />
                                    </div>
                                    <br style="clear: both;">
                                </div>                                
<!--                                 <div ng-init="ctrl.getSubBillingItemData(billingItem.id, $index);"></div>
                                <div>
                                    <ul ng-if="subBillingItemData.length > 0" class="list-group">
                                        <li ng-repeat="subItem in subBillingItemData[$index]" class="list-group-item" style="height: 60px;">
                                            <div class="form-group">
                                                <div ng-init="subBillingItemData[$parent.$index][$index].is_item_selected = true;"></div>
                                                <div class="col-md-5">
                                                       <div class="checkbox c-checkbox">
                                                       <label for="{{subItem.id}}"><input id="{{subItem.id}}" name="{{subItem.id}}"  type="checkbox" ng-model="subBillingItemData[$parent.$index][$index].is_item_selected"/>
                                                        <span class="fa fa-check"></span>&emsp;{{subItem.name}}</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <input id="{{subItem.id}}" name="{{subItem.id}}" class="form-control" type="number" maxlength="30"  ng-model="subBillingItemData[$parent.$index][$index].billing_amount" placeholder="Enter Amount" style="width: 200px;" />
                                                </div>
                                            </div> 
                                        </li>
                                    </ul>
                                </div> -->
                            </div>  
                            <br style="clear: both;">
                            <br style="clear: both;">
                            <div style="border-top: 1px solid #a0a0a0;">
                                <label class="customItemDiv">Additional Items</label> 
                                    <br style="clear: both;">
                                    <br style="clear: both;">                           
                                    <div ng-repeat="i in ctrl.getNumberLoop(5) track by $index" class="col-md-12">
                                        <div class="form-group">
                                            <div class="col-md-2" style="width: 40px;">
                                                <div class="checkbox c-checkbox">
                                                <label><input id="customeItemCheck" name="customeItemCheck"  type="checkbox" ng-model="customBillingItem[$index].is_item_selected" class="itmCheckInput"/>
                                                <span class="fa fa-check itmCheckBox" class="itmCheckInput"></span></label> 
                                                </div>
                                            </div>
                                            <div class="col-md-4" style="width: 270px">
                                                <input id="customeItemName" name="customeItemName" class="form-control" type="text" maxlength="30"  ng-model="customBillingItem[$index].item_name" placeholder="Enter Item" style="width: 250px;" />
                                            </div>
                                            <div class="col-md-4"><input id="customeItemAmount" name="customeItemAmount" class="form-control" type="number" maxlength="30"  ng-model="customBillingItem[$index].billing_amount" placeholder="Enter Amount" style="width: 200px;" /></div>
                                            <br style="clear: both;">
                                        </div>                                            
                                    </div>
                            </div>                                              
                    </div>
                </div>
                <div class="panel-footer itmfooter">
                    <div>
                        <button type="submit" class="btn btn-primary newFormCreateBtn" ng-disabled="ctrl.disableInvoiceSave">
                            {{ctrl.invoiceSaveBtnText}}
                        </button>
                    </div>  
                <br style="clear: both;"/>         
                </div>
                <!--/.panel-body -->
                </form>
            </div>
            <!-- END panel-->


        </div>


</div>

<div id="clientBillingReport" class="modal fade" role="dialog" data-backdrop="static">
<div class="modal-dialog" style="width:80%">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        </div>
        <div class="modal-body">
            <div>
                <embed id="pdfReport" style="height:450px; width: 100%;" ng-src="{{ctrl.clientBillingInvoiceSrcStrg}}"/>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
            <button type="button" id = "PrintPdf" class="btn btn-primary" ng-click=printReport(ctrl.clientBillingInvoiceSrcStrg)>Print</button>
        </div>
    </div>
</div>
</div> 


</div>

<div id="listValueDeleteWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p><g:message code="listValue.delete.warning" /></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>


    <asset:javascript src="datagrid/admin-clientBilling.js"/>

    <script type="text/javascript">
        var dvAdminClientBilling = document.getElementById('dvAdminClientBilling');
        angular.element(document).ready(function() {
            angular.bootstrap(dvAdminClientBilling, ['adminClientBilling']);
        });
    </script>

</body>
</html>
