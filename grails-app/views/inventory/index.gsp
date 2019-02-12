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


<div ng-cloak id="dvInventory" ng-controller="InventoryCtrl as ctrl">

    <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 40px;" src="/foysonis2016/app/img/inventory_header.svg"></em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">View Inventory</span></div>
    <br style="clear: both;">
    <br style="clear: both;">
    <!-- START search panel-->
    <div class="panel panel-default">
        <div class="panel-body">
            <form name="ctrl.inventorySearchForm"  ng-submit="ctrl.inventorySearch()">
                <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                    <!-- START Wizard Step inputs -->
                    <div>
                        <fieldset>

                            <legend> <g:message code="default.search.label" /></legend>
                            <!-- START row -->
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.item.label" /></label>
                                        <div class="controls">
                                            <input type="text" name="item" placeholder="Item Id or Description or UPC code" class="form-control"
                                                   ng-model="ctrl.itemId" capitalize>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.lpn.label" /></label>
                                        <div class="controls">
                                            <input type="text" name="lpn" placeholder="Pallet or Case Id" class="form-control"
                                                   ng-model="ctrl.lpn" capitalize>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.location.label" /></label>
                                        <div class="controls">

                                            <div auto-complete  source="loadLocationAutoComplete"  xxxx-list-formatter="customListFormatter" min-chars = '3'
                                                 value-changed="ctrl.disableFindButtonForAutoComp(ctrl.findInventory.location)" style="position: absolute; z-index: 1;">
                                                <input ng-model="ctrl.location" placeholder="Location Id or Barcode" class="form-control" ng-blur='ctrl.clearAutoCompText()' capitalize>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label for="areaSearch">Area</label>
                                    <div class="controls">
                                        <input type="text" id="areaSearch" name="areaSearch" placeholder="Area Id"
                                               class="form-control" ng-model="ctrl.areaSearch"
                                               capitalize>
                                    </div>                                    
                                </div>
                            </div>
                            <!-- END row -->

                            <!-- START row -->
                            <div style="margin-bottom: 50px; margin-top: 20px;" >
                                <div class="col-md-12">
                                    <a href="#"  ng-click="ctrl.showAdditionalSearch()" >
                                        <g:message code="form.field.additionalSearchForInventory.label" />
                                    </a>
                                </div>
                            </div>
                            <!-- END row -->


                            <!-- START Additional Search row -->
                            <div class="row" ng-show="ctrl.displayAdditionalSearch">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.reqInventoryStatus.label" /></label>
                                        <div class="controls">
                                            <select  id="findInventoryStatus" name="findInventoryStatus" ng-model="ctrl.findInventoryStatus" class="form-control">
                                                <option ng-repeat="option in ctrl.inventoryStatusOptions" ng-value="option.optionValue">{{option.description}}</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.notes.label" /></label>
                                        <div class="controls">
                                            <input type="text" name="inventoryNote" placeholder="Inventory Notes" class="form-control" ng-model="ctrl.inventoryNote">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.lotCode.label" /></label>
                                        <div class="controls">
                                            <input type="text" name="lotCode" placeholder="Lot Code" class="form-control" ng-model="ctrl.lotCode">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.originCode.label" /></label>
                                        <div class="controls">
                                            %{--<select ng-model="ctrl.originCode" class="form-control" ng-options="option for option in ctrl.originCodes">--}%
                                            %{--</select>--}%

                                            <select id="originCode" name="originCode" ng-model="ctrl.originCode" class="form-control" >
                                                <option ng-repeat="originCode in ctrl.originCodes" value="{{originCode.code}}">{{originCode.name}}
                                                </option>
                                            </select>

                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.itemCategory.label" /></label>
                                        <div class="controls">
                                            <select  id="findItemCategory" name="findItemCategory" ng-model="ctrl.findItemCategory" class="form-control">
                                                <option ng-repeat="option in ctrl.itemCategoryOptions" ng-value="option.optionValue">{{option.description}}</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <br style="clear: both;"/>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.expDate.label" /></label>
                                        <label ng-show="ctrl.displayExpirationDateRange"> : From</label>
                                        <div class="controls">
                                            %{--<input type="date" id="fromExpirationDate" name="fromExpirationDate" class="form-control" ng-model="ctrl.findInventory.fromExpirationDate" />--}%


                                            <p class="input-group">
                                                <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                       ng-model="ctrl.fromExpirationDate" is-open="popupExpirationDateFrom.opened"
                                                       datepicker-options="dateOptions"  ng-required="false" close-text="Close"
                                                       alt-input-formats="altInputFormats" />
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-default" ng-click="openExpirationDateFrom()">
                                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                                </span>
                                            </p>


                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4" ng-show="ctrl.displayExpirationDateRange">
                                    <div class="form-group">
                                        <label><g:message code="form.field.to.label" /></label>
                                        <div class="controls">
                                            %{--<input type="date" id="toExpirationDate" name="toExpirationDate" class="form-control" ng-model="ctrl.findInventory.toExpirationDate" />--}%

                                            <p class="input-group">
                                                <input type="text" class="form-control" uib-datepicker-popup="{{format}}"
                                                       ng-model="ctrl.toExpirationDate" is-open="popupExpirationDateTo.opened"
                                                       datepicker-options="dateOptions"  ng-required="false" close-text="Close"
                                                       alt-input-formats="altInputFormats" />
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-default" ng-click="openExpirationDateTo()">
                                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                                </span>
                                            </p>

                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>&nbsp;</label>
                                        <div class="controls">
                                            <div class="checkbox c-checkbox">
                                                <label>
                                                    <input type="checkbox" value="" ng-click="ctrl.showExpirationDateRange()" ng-model="ctrl.expirationDateRange">
                                                    <span class="fa fa-check"></span><g:message code="form.field.dateRange.label" /></label>
                                            </div>
                                        </div>
                                    </div>
                                    <br style="clear: both;"/>
                                </div>
                                <br style="clear: both;"/>
                            </div>
                            <!-- END Additional Search row -->

                        </fieldset>

                        <div class="pull-right">
                            <button type="submit" class="btn btn-primary findBtn">
                                <g:message code="default.button.searchInventory.label" />
                            </button>
                        </div>

                    </div>
                    <!-- END Wizard Step inputs -->
                </div>
            </form>
        </div>
    </div>
    <!-- END search panel -->
    <br style="clear: both;"/>


    <!-- Start Inventory Grid-->
    <p>
        <div id="grid1" ui-grid="gridItem" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-expandable ui-grid-resize-columns class="grid" ui-grid-auto-resize>
            <div class="noDataMessage" ng-if="gridItem.data.length == 0"><g:message code="inventory.grid.noData.message" /></div>
            <!--<div ng-if='columnChanged'></div>-->
        </div>
    </p>

    <!-- END OF Inventory Grid-->


    <br style="clear: both"/>
    
</div>

<asset:javascript src="datagrid/inventory.js"/>

<script type="text/javascript">
    var dvInventory = document.getElementById('dvInventory');
    angular.element(document).ready(function() {
        angular.bootstrap(dvInventory, ['inventory']);
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
