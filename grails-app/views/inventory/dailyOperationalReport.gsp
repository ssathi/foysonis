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


<div ng-cloak id="dvInventory" ng-controller="InventoryDailyOperationalReportCtrl as ctrl">

    <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 40px;" src="/foysonis2016/app/img/report_header.svg"></em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">Daily Operational Report</span></div>
    <br style="clear: both;">
    <br style="clear: both;">

    <!-- Start Inventory Grid-->
    <h3>Inventory On Hand</h3>
    <p>
    <div id="grid1" ui-grid="gridInventory" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-resize-columns class="grid" ui-grid-auto-resize>
        <div class="noDataMessage" ng-if="gridInventory.data.length == 0">There is no records found!</div>
        <!--<div ng-if='columnChanged'></div>-->
    </div>

    <br style="clear: both;">
    <br style="clear: both;">

    <!-- END OF Inventory Grid-->


    <!-- Start Received Inventory Grid-->
    <h3>Inventory received the prior day</h3>
    <p>
    <div id="grid2" ui-grid="gridReceivedInventory" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-resize-columns class="grid" ui-grid-auto-resize>
        <div class="noDataMessage" ng-if="gridReceivedInventory.data.length == 0">There is no records found!</div>
        <!--<div ng-if='columnChanged'></div>-->
    </div>
    <!-- END OF Received Inventory Grid-->


    <br style="clear: both;">
    <br style="clear: both;">

    <!-- Start Shipped Inventory Grid-->
    <h3>Inventory shipped the prior day</h3>
    <p>
    <div id="grid2" ui-grid="gridShippedInventory" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-resize-columns class="grid" ui-grid-auto-resize>
        <div class="noDataMessage" ng-if="gridShippedInventory.data.length == 0">There is no records found!</div>
        <!--<div ng-if='columnChanged'></div>-->
    </div>
    <!-- END OF Shipped Inventory Grid-->

    <br style="clear: both;">
    <br style="clear: both;">

    <!-- Start Picked Inventory Grid-->
    <h3>Inventory picked the prior day</h3>
    <p>
    <div id="grid2" ui-grid="gridPickedInventory" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-resize-columns class="grid" ui-grid-auto-resize>
        <div class="noDataMessage" ng-if="gridPickedInventory.data.length == 0">There is no records found!</div>
        <!--<div ng-if='columnChanged'></div>-->
    </div>
    <!-- END OF Picked Inventory Grid-->

    <br style="clear: both;">
    <br style="clear: both;">

    <!-- Start Adjusted Inventory Grid-->
    <h3>Inventory adjusted the prior day</h3>
    <p>
    <div id="grid2" ui-grid="gridAdjustedInventory" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-resize-columns class="grid" ui-grid-auto-resize>
        <div class="noDataMessage" ng-if="gridAdjustedInventory.data.length == 0">There is no records found!</div>
        <!--<div ng-if='columnChanged'></div>-->
    </div>
    <!-- END OF Adjusted Inventory Grid-->
</p>




    <br style="clear: both"/>
    
</div>

<asset:javascript src="datagrid/inventory-daily-operational-report.js"/>

<script type="text/javascript">
    var dvInventory = document.getElementById('dvInventory');
    angular.element(document).ready(function() {
        angular.bootstrap(dvInventory, ['inventoryDailyOperationalReport']);
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
