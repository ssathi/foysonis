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
            padding-left: 50px;
            //padding-top: 20px;
            padding-bottom: 15px;
        }

        .customItemDiv {
            padding-left: 30px;
            padding-top: 20px;            
        }

        .mainHeading {
            //border-bottom: 1px solid #a0a0a0;    
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
            <div class="col-lg-8">
            <div><em class="fa  fa-fw mr-sm" ><img style="width: 30px; padding-bottom: 10px;" src="/foysonis2016/app/img/invoice_ico50.png"></em>&emsp;&emsp;<span class="headerTitle">Setup Rates</span></div>
            <br style="clear: both;"/>
            <div id="setupRateSaved" class="alert alert-success message-animation" role="alert" ng-if="ctrl.setupRateSavedPrompt">
                <p>Rates have been saved.</p>
            </div>    
            <div class="panel panel-default">
                <div class="panel-heading">
                    <!-- <div class="panel-title mainHeading">Setup Rates</div> -->
                </div>            
                <div class="panel-body" >
                    <div>
                        <!-- <ul class="list-group"> -->
                            <div ng-repeat="billingItem in billingItemData" class="col-md-12 mainItemfield">
                                    <div class="col-md-4">
                                      <label>{{billingItem.name}}</label>  
                                    </div>

                                    
                                    <div class="col-md-4" ng-if="!disableTextBox[$index]"><input id="{{billingItem.id}}" name="{{billingItem.id}}" class="form-control" type="number" maxlength="30"  ng-model="billingItemData[$index].billing_amount" placeholder="Enter Amount" style="width: 200px;" /></div>
                                    <div ng-if="!disableTextBox[$index]" >
                                        &emsp;Min Rate&nbsp;:&emsp;
                                        <input id="minRate_{{billingItem.id}}" name="minRate_{{billingItem.id}}" class="form-control" type="number" maxlength="30"  ng-model="billingItemData[$index].min_rate" placeholder="Enter Amount" style="width: 100px; display: inline;" />
                                    </div>

                                    <br style="clear: both;">                         
                                <div ng-init="ctrl.getSubBillingItemData(billingItem.id, $index);"></div>
                                <div>
                                    <div ng-if="subBillingItemData.length > 0" class="list-group">
                                        <div ng-repeat="subItem in subBillingItemData[$index]" class="col-md-12 subItemDiv">
                                            <div class="form-group">
                                                <div class="col-md-4">
                                                    <label>{{subItem.name}}</label>
                                                </div>
                                                <div class="col-md-4">
                                                    <input id="{{subItem.id}}" name="{{subItem.id}}" class="form-control" type="number" maxlength="30"  ng-model="subBillingItemData[$parent.$index][$index].billing_amount" placeholder="Enter Amount" style="width: 200px;" />                                
                                                </div>
                                                <div class="col-md-4">
                                                    &emsp;Min Rate&nbsp;:&emsp;
                                                    <input id="minRate_{{subItem.id}}" name="minRate_{{subItem.id}}" class="form-control" type="number" maxlength="30"  ng-model="subBillingItemData[$parent.$index][$index].min_rate" placeholder="Enter Amount" style="width: 100px; display: inline;" />
                                                </div>                                                    
                                            </div> 
                                        </div>
                                        <div>
                                    </div>
                            </div>                           
                        <!-- </ul> -->
                    </div>
                </div>
                <br style="clear:both;">
                <!--/.panel-body -->
            </div>
            <!-- END panel-->


        </div>
        <div class="panel-footer itmfooter">
            <div class="">
                <button type="button" class="btn btn-primary newFormCreateBtn" ng-click="ctrl.saveBillingItem()" ng-disabled="ctrl.disableBillingItemSave" style="width: 110px;">
                    {{ctrl.billingItemSaveBtnText}}
                </button>
            </div>  
            <br style="clear: both;"/>                
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
