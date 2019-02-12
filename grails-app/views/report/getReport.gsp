<%--
  Created by IntelliJ IDEA.
  User: home
  Date: 7/20/16
  Time: 10:33
--%>

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


    <style>

    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    </style>



</head>

<body>


<div ng-cloak class="row" id="dvReport" ng-controller="ReportCtrl as ctrl">

    <div class="col-lg-12">
    <div style="display: inline;"><em class="fa  fa-fw mr-sm" style="padding-right: 40px;" ><img style="height: 35px;" src="/foysonis2016/app/img/report_header.svg"></em>&nbsp;<span class="headerTitle" style="vertical-align: bottom;">Reports
        </span></div>
        <br style="clear: both;">
        <br style="clear: both;">
        <!-- START panel-->
        <div class="panel panel-default">
            <div class="panel-body">
                <!-- <h4>Reports</h4> -->

                <select  id="report" name="report" ng-model="reportType" class="form-control" style="width: 300px;">
                <option value="billOfLading">BOL</option>
                <option value="packingSlip">Packing Slip</option>
                <option value="inventoryReport">Inventory Report</option>
                <option value="pendingPutawayInventory">Pending Putaway Inventory</option>
                <option value="picksReport">Picks Report</option>
                <option value="pickListReport">Pick List Report</option>
                <option value="inventorySummaryReport">Inventory Summary Report</option>
                <option value="itemReorder">Reorder level item report</option>
                <option value="receiptReport">Receipt Report</option>
                <option value="orderReport">Order Report</option>
                </select>

            </div>
        </div>
        <div ng-if="ctrl.displayDiv =='billOfLading'"><g:render template="bolReport" /></div>
        <div ng-if="ctrl.displayDiv =='packingSlip'"><g:render template="packingSlipReport" /></div>
        <div ng-if="ctrl.displayDiv =='inventoryReport'"><g:render template="inventoryReport" /></div>
        <div ng-if="ctrl.displayDiv =='pendingPutawayInventory'"><g:render template="pendingPutawayReport" /></div>
        <div ng-if="ctrl.displayDiv =='picksReport'"><g:render template="picksReport" /></div>
        <div ng-if="ctrl.displayDiv =='pickListReport'"><g:render template="pickListReport" /></div>
        <div ng-if="ctrl.displayDiv =='inventorySummaryReport'"><g:render template="inventorySummaryReport" /></div>
        <div ng-if="ctrl.displayDiv =='itemReorder'"><g:render template="reorderLevelItemReport" /></div>
        <div ng-if="ctrl.displayDiv =='receiptReport'"><g:render template="receiptReport" /></div>
        <div ng-if="ctrl.displayDiv =='orderReport'"><g:render template="orderReport" /></div>

    </div>
    <g:render template="sendReportMailTemp" />

</div><!-- End of CustomerCtrl -->



<asset:javascript src="datagrid/report.js"/>

<script type="text/javascript">
    var dvReport = document.getElementById('dvReport');
    angular.element(document).ready(function() {
        angular.bootstrap(dvReport, ['report']);
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
