<%--
  Created by IntelliJ IDEA.
  User: home
  Date: 7/25/16
  Time: 10:10
--%>


<html>
<head>
    <meta name="layout" content="foysonis2016"/>

    %{--Signup form--}%
    <asset:javascript src="signup/angular-aria.min.js"/>
    <asset:javascript src="signup/angular-messages.min.js"/>

    %{--UI Grid JS files--}%
    <asset:javascript src="datagrid/angular.js"/>
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

    .grid-warning{
        color: red;
        background-color: red;

        text-align: left;
    }

    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    </style>



</head>

<body>


<div ng-cloak class="row" id="dvLocationImport" ng-controller="LocationImportCtrl as ctrl">

    <div class="col-lg-12">
        <!-- START panel-->
        <div class="panel panel-default">
            <div class="panel-body">
                <h4>Import CSV</h4>

                <input type="file"  id="csvImport" />
                %{--<input type="file" file-reader="fileContent"  />--}%

                %{--<div>{{fileContent}}</div>--}%

            </div>

            <div class="panel-body" style="padding-bottom: 100px;">
                <div id="grid1" ui-grid="gridOptions" ui-grid-exporter  class="grid">
                </div>
            </div>

        </div>
    </div>


</div><!-- End of CustomerCtrl -->



<asset:javascript src="datagrid/locationImport.js"/>

<script type="text/javascript">
    var dvLocationImport = document.getElementById('dvLocationImport');
    angular.element(document).ready(function() {
        angular.bootstrap(dvLocationImport, ['locationImport']);
    });
</script>

<asset:javascript src="autocomplete/angular-auto.js"/>
<asset:javascript src="autocomplete/angular-sanitize.js"/>
<asset:javascript src="autocomplete/auto-complete.js"/>
<asset:javascript src="autocomplete/auto-complete-multi.js"/>
<asset:javascript src="inventory/auto-complete-div.js"/>
<asset:javascript src="autocomplete/auto-complete-textbox.js"/>

<asset:javascript src="datagrid/locationImportService.js"/>


</body>
</html>