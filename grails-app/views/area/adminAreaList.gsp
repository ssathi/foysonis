<%--
  Created by IntelliJ IDEA.
  User: home
  Date: 9/26/15
  Time: 12:41
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
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
    <!-- <link rel="stylesheet" href="http://ui-grid.info/release/ui-grid.css" type="text/css"> -->
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
    }

    .csvGrid {
        height:380px;
        width: 1300px;
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

    .noLocationMessage {
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

    .gridCheckbox {
        position: relative;
        display: block;
        margin-top: 5px;
        margin-bottom: 10px;
    }


    .receipt-modal-dialog {
        width: 100%;
        height: 100%;
        margin: 0;
        padding: 0;
    }

    .receipt-modal-content {
        height: auto;
        min-height: 100%;
        border-radius: 0;
    }


    .receipt-modal-header {
        background: #547CA2;
        height: 70px;
    }

    .receipt-panel-title {
        margin-top: -30px;
        color: #ffffff;
    }

    .receipt-modal-body {
        position: fixed;
        top: 70px;
        bottom: 70px;
        width: 100%;
        overflow: scroll;
        padding: 15px
    }

    .receipt-modal-footer {
        position: fixed;
        right: 0;
        bottom: 0;
        left: 0;
        border-top: 2px solid #547CA2;
        height: 70px;
    }

    .receipt-close {
        color: #FFFFFF;
        opacity: 1;
    }

    .ui-grid-header-viewport {
         /*width: 0px;*/
        /*width: 1300px;*/
    }

    /*.ui-grid-top-panel {*/
    /*/!* overflow: hidden; *!/*/
    /*}*/
    .nav-tabs > li > a.moveTabs{
        background-color: #878a8d;
        color: #ffffff;
        height: 37px;
        width: 180px;
        border-right: 1px;    
        font-size: 13px;   
        text-align: center;
        line-height: 1;
    }

    .nav-tabs > li > a.moveFirstTab{
        border-top-left-radius: 4.5px;
        border-bottom-left-radius: 4.5px;        
    }

    .nav-tabs > li > a.moveLastTab{
        border-top-right-radius: 4.5px;
        border-bottom-right-radius: 4.5px;        
    }    

    .nav-tabs > li.active > a, .nav-tabs > li.active > a:hover, .nav-tabs > li.active > a:focus{
        color: #ffffff;
        background-color: #40a3fd;       
        border-right: 1px; 
    }

    .nav-tabs{
        padding-bottom: 2px;
    }    

    .strgTagDiv1 {
        position: absolute;
        top: 727px;
        left: 45px;
    }   

    .strgTagDiv2 {
        position: absolute;
        top: 580px;
        left: 45px;
    }   
    </style>

    <%-- **************************** End of CSS **************************** --%>

</head>

<body>


<div ng-cloak class="row" id="dvAdminAreaLocation" ng-controller="AreaCtrl as ctrl">

    <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 40px; padding-bottom: 3px;" src="/foysonis2016/app/img/locationArea_header.svg"></em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">Locations & Areas
    </span></div>
    <br style="clear: both;">
    <br style="clear: both;">
    <!-- START search panel-->
    <div class="panel panel-default">
        <div class="panel-heading">
            <a href="javascript:void(0);" ng-click = "ctrl.showHideSearch()">
                <legend><em ng-if = "ctrl.isAreaSearchVisible" class="fa fa-minus-circle fa-fw mr-sm"></em>
                    <em ng-if = "!ctrl.isAreaSearchVisible" class="fa fa-plus-circle fa-fw mr-sm"></em>
                    <g:message code="default.search.label" />
                </legend></a>
        </div>
        <div class="panel-body" ng-show= "ctrl.isAreaSearchVisible">
            <form name="ctrl.areaSearchForm"  ng-submit="ctrl.areaSearch()">
                <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                    <!-- START Wizard Step inputs -->
                    <div>
                        <fieldset>
                            <!-- START row -->
                            <div class="row">

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.areaId.label" /></label>
                                        <div class="controls">
                                            <input ng-model="ctrl.searchArea.areaId" placeholder="Area Id" class="form-control" > 
                                        </div>
                                    </div>
                                </div>


                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label><g:message code="form.field.locationId.label" /></label>
                                        <div class="controls">
                                            <input type="text" name="locationIdSearch" placeholder="Location Id or Barcode" class="form-control"
                                                   ng-blur="" ng-model="ctrl.searchArea.locationId">
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="pull-left" style="margin-top: 15px;">
                                        <button class="btn btn-primary findBtn" type="submit">
                                            <g:message code="default.button.searchArea.label" />
                                        </button>
                                    </div>
                                </div>
                            </div>

                        </fieldset>
                        <br style="clear:both;"/> 
                    </div>
                    <!-- END Wizard Step inputs -->
                </div>
            </form>
        </div>
    </div>
    <!-- END search panel -->
    <br style="clear:both;"/> 

    <div class="col-lg-3 panel-body table-responsive table-bordered" style="background-color: #fff;" ng-if = "ctrl.areaList.length == 0">

        <table class="table table-bordered">
            <tbody>
            <tr>
                <td>
                    <div class="media">
                        <div class="media-body">
                            <h5 class="media-heading" >No Areas found.</h5>
                        </div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>

    </div>


    <div class="col-lg-3 panel-body table-responsive table-bordered" style="background-color: #fff;" ng-if = "ctrl.areaList.length > 0">

        <table class="table table-bordered">
            <tbody>

            <tr>
                <td>
                    <button type="button" class="btn btn-primary newFormCreateBtn" ng-click="showCreateAreaForm()" >
                        <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                        <g:message code="default.button.createArea.label" />
                    </button>
                </td>
            </tr>
            <tr ng-repeat="area in ctrl.areaList">
                <td ng-class="{ 'selected-class-name': area.areaId == ctrl.selectedAreaId }">
                    <div class="media">
                        <div class="media-body">


                            <%-- ****************** Selecting Area Tab ****************** --%>

                            <a href = ''  ng-click="getClickedAreaId(area.areaId)">
                                <h5 class="media-heading" >{{ area.areaId }}</h5></a>

                            <%-- ****************** End of selecting Area Tab ****************** --%>

                        </div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>

    </div>

    <div class="col-lg-9">
        <!-- START panel-->
        <div class="panel panel-default">
            <div class="panel-body" style="overflow:hidden;">
                <!-- Nav tabs -->
                <ul class="nav nav-tabs">
                    <li id="lilocations" class="active"><a class="moveTabs moveFirstTab" href="#locations" data-toggle="tab"><g:message code="default.location.tab.label" /></a></li>
                    <li id="liareas"><a class="moveTabs moveLastTab" href="#areas" data-toggle="tab"><g:message code="default.area.tab.label" /></a></li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                    <div id="locations" class="tab-pane fade in active">

                        <div ng-hide="ctrl.areaList.length == 0" style="float: left;">
                            <h4>{{ctrl.selectedAreaId}}</h4>
                        </div>

                        <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">

                            <button type="button" class="btn btn-import pull-right" style="float: right; margin-left:20px;" ng-hide="ctrl.allAreas.length == 0" ng-click="importLocation()">
                                <em class="fa  fa-fw mr-sm" >
                                    <img src="/foysonis2016/app/img/import_icon.svg">
                                </em>
                                CSV Location Import
                            </button>

                            <button ng-hide="ctrl.allAreas.length == 0" type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide()">
                                <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                <g:message code="default.button.createLocation.label" />
                            </button>
                        </a>
                        <br style="clear: both;"/>
                        <br style="clear: both;"/>

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showLocationSubmittedPrompt">
                            <g:message code="location.create.message" />
                        </div>

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showLocationUpdatedPrompt">
                            <g:message code="location.edit.message" />
                        </div>

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showLocationDeletedPrompt">
                            <g:message code="location.delete.message" />
                        </div>

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showLocationBlockedPrompt">
                            <g:message code="location.block.message" />
                        </div>

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showLocationUnBlockedPrompt">
                            <g:message code="location.unBlock.message" />
                        </div>

                        <div class="alert alert-success message-animation" role="alert" ng-show="ctrl.showImportLocationSubmittedPrompt">
                            <g:message code="location.import.message" />
                        </div>

                        <div ng-show = "IsVisible" class="row">

                            <form name="ctrl.createLocationForm" ng-submit="ctrl.createLocation()" novalidate >

                                <div class="panel panel-default" id="panel-anim-fadeInDown">
                                    <div class="panel-heading">
                                        <div class="panel-title" ng-if="ctrl.newLocation.hiddenlocationId"><g:message code="default.location.edit.label" /></div>
                                        <div class="panel-title" ng-if="!ctrl.newLocation.hiddenlocationId"><g:message code="default.location.add.label" /></div>
                                    </div>

                                    <div class="panel-body">
                                        <div class="col-md-6">


                                            <div class="form-group" ng-if="ctrl.newLocation.hiddenlocationId">
                                                <label for="locationId"><g:message code="form.field.locationId.label" /> : {{ctrl.newLocation.hiddenlocationId}}</label>
                                            </div>


                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('locationId')}" ng-if="!ctrl.newLocation.hiddenlocationId">

                                                <label for="locationId"><g:message code="form.field.locationId.label" /></label>
                                                <input id="locationId" name="locationId" class="form-control" type="text" maxlength="30" capitalize required
                                                       ng-model="ctrl.newLocation.locationId"
                                                       ng-focus="ctrl.toggleLocationIdPrompt(true)" ng-blur="ctrl.toggleLocationIdPrompt(false); ctrl.locationIdValidation(ctrl.newLocation.locationId)" />


                                                <div class="my-messages"  ng-messages="ctrl.createLocationForm.locationId.$error"
                                                     ng-if="ctrl.createLocationForm.$error.locationIdExists">
                                                    <div class="message-animation" >
                                                        <strong>Location Id exists already.</strong>
                                                    </div>
                                                </div>

                                                <div class="my-messages" ng-messages="ctrl.createLocationForm.locationId.$error" ng-if="ctrl.showMessages('locationId')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('areaId')}">
                                                <label for="areaId"><g:message code="form.field.areaId.label" /></label>
                                                <select  id="areaId" name="areaId" ng-model="ctrl.selectedAreaId" class="form-control" ng-change = "getLocationsByArea()">
                                                    <option ng-repeat="area in  ctrl.allAreas" value="{{area.areaId}}">{{area.areaId}}
                                                    </option>
                                                </select>


                                                <div class="my-messages" ng-messages="ctrl.createLocationForm.areaId.$error" ng-if="ctrl.showMessages('areaId')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>
                                            </div>


                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('locationBarcode')}" >
                                                <label for="locationBarcode"><g:message code="form.field.locationBar.label" /></label>
                                                <input id="locationBarcode" name="locationBarcode" class="form-control" type="text" maxlength="30" capitalize
                                                       ng-model="ctrl.newLocation.locationBarcode"
                                                       ng-focus="ctrl.toggleLocationBarcodePrompt(true)" ng-blur="ctrl.toggleLocationBarcodePrompt(false); ctrl.locationBarcodeValidation(ctrl.newLocation.locationBarcode, ctrl.newLocation.hiddenlocationId )"
                                                       />


                                                <div class="my-messages"  ng-messages="ctrl.createLocationForm.locationBarcode.$error"
                                                     ng-if="ctrl.createLocationForm.$error.locationBarcodeExists">
                                                    <div class="message-animation" >
                                                        <strong>Location Barcode exists already.</strong>
                                                    </div>
                                                </div>

                                            </div>

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('travelSequence')}">
                                                <label for="travelSequence"><g:message code="form.field.travelSeq.label" /></label>
                                                <input id="travelSequence" name="travelSequence" class="form-control" type="text"
                                                       ng-model="ctrl.newLocation.travelSequence" ng-model-options="{ updateOn : 'default blur' }"
                                                       ng-focus="ctrl.toggleTravelSequencePrompt(true)" ng-blur="ctrl.toggleTravelSequencePrompt(false)" numbers-only>

                                            </div>

                                            <div class="form-group">
                                                <label for="isBlocked"><g:message code="form.field.blockStatus.label" /></label>
                                                %{--<input id="isBlocked" name="isBlocked" class="form-control"  type="checkbox" ng-model="ctrl.newLocation.isBlocked">--}%

                                                <div class="checkbox c-checkbox">
                                                    <label>
                                                        <input id="isBlocked" name="isBlocked"  type="checkbox" ng-model="ctrl.newLocation.isBlocked">
                                                        <span class="fa fa-check"></span>
                                                    </label>
                                                </div>


                                                <div class="my-messages" ng-messages="ctrl.createLocationForm.isBlocked.$error" ng-if="ctrl.showMessages('isBlocked')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="panel-footer">
                                        <div class="pull-left">
                                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                <button class="btn btn-default" type="button" ng-click="ShowHide()"><g:message code="default.button.cancel.label" /></button>
                                            </a>

                                        </div>
                                        <div class="pull-right">
                                            <button class="btn btn-primary" type="submit"><g:message code="default.button.save.label" /></button>
                                        </div>
                                        <br style="clear: both;"/>
                                    </div>
                                </div>
                            </form>

                        </div>



                        <%--  ****************** Location Grid  ****************** --%>

                        <p>
                        <div id="grid1" ui-grid="gridLocation" ui-grid-exporter  ui-grid-pagination ui-grid-resize-columns class="grid">
                            <div class="noLocationMessage" ng-if="gridLocation.data.length == 0"><g:message code="location.grid.noData.message" /></div>
                        </div>
                    </p>


                        <%-- ****************** END OF Location Grid  ****************** --%>

                    </div>
                    <div id="areas" class="tab-pane fade">

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showAreaSubmittedPrompt">
                            <g:message code="area.create.message" />
                        </div>

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showAreaUpdatedPrompt">
                            <g:message code="area.edit.message" />
                        </div>

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showAreaDeletedPrompt">
                            <g:message code="area.delete.message" />
                        </div>

                        <div ng-show="ctrl.isShowDefaultAreaDetails">
                            <h4>This is a DEFAULT Area</h4>
                        </div>
                        %{--Start Display An Area Details--}%

                        <div ng-show="ctrl.isShowAreaDetails">
                            <div class="form-group">
                                <div class="col-lg-4"><h4><g:message code="form.field.id.label" />: {{ctrl.selectedAreaId}}</h4></div>
                                <div class="col-lg-5"><h4><g:message code="form.field.name.label" />: {{ctrl.selectedArea.areaName}}</h4></div>
                                <br style="clear: both;"/>
                            </div>
                            <div class="form-group">
                                %{--<input id="selectedAreaIsStorage" name="selectedAreaIsStorage" disabled type="checkbox" ng-model="ctrl.selectedArea.isStorage"/>--}%
                                %{--<label for="selectedAreaIsStorage"><g:message code="form.field.check1.label" /></label>--}%

                                <div class="checkbox c-checkbox">
                                    <label for="selectedAreaIsStorage">
                                        <input id="selectedAreaIsStorage" name="selectedAreaIsStorage" disabled type="checkbox" ng-model="ctrl.selectedArea.isStorage"/>
                                        <span class="fa fa-check"></span><g:message code="form.field.check1.label" />
                                    </label>
                                </div>

                                <div style="margin-left: 30px;" ng-show="ctrl.selectedArea.isStorage">
                                    %{--<input id="selectedAreaIsPickable" name="selectedAreaIsPickable"  disabled type="checkbox" ng-model="ctrl.selectedArea.isPickable" />--}%
                                    %{--<label for="selectedAreaIsPickable"><g:message code="form.field.check2.label" /></label>--}%

                                    <div class="checkbox c-checkbox">
                                        <label for="selectedAreaIsPickable">
                                            <input id="selectedAreaIsPickable" name="selectedAreaIsPickable"  disabled type="checkbox" ng-model="ctrl.selectedArea.isPickable" />
                                            <span class="fa fa-check"></span><g:message code="form.field.check2.label" />
                                        </label>
                                    </div>

                                    <div class="checkbox c-checkbox">
                                        <label for="isBin">
                                            <input id="isBin" name="isBin"  type="checkbox" ng-model="ctrl.selectedArea.isBin" disabled />
                                            <span class="fa fa-check"></span><g:message code="form.field.check6.label" />
                                        </label>
                                    </div>

                                </div>
                            </div>
                            <div class="form-group">
                                %{--<input id="selectedAreaIsProcessing" name="selectedAreaIsProcessing" disabled type="checkbox" ng-model="ctrl.selectedArea.isProcessing" ng-change="ctrl.processingCheckBoxChange()" />--}%
                                %{--<label for="selectedAreaIsProcessing"><g:message code="form.field.check3.label" /></label>--}%

                                <div class="checkbox c-checkbox">
                                    <label for="selectedAreaIsProcessing">
                                        <input id="selectedAreaIsProcessing" name="selectedAreaIsProcessing" disabled type="checkbox" ng-model="ctrl.selectedArea.isProcessing" ng-change="ctrl.processingCheckBoxChange()" />
                                        <span class="fa fa-check"></span><g:message code="form.field.check3.label" />
                                    </label>
                                </div>

                                <div style="margin-left: 30px;"  ng-show="ctrl.selectedArea.isProcessing">
                                    %{--<input id="selectedAreaIsStaging" name="selectedAreaIsStaging" disabled type="checkbox" ng-model="ctrl.selectedArea.isStaging" />--}%
                                    %{--<label for="selectedAreaIsStaging"><g:message code="form.field.check4.label" /></label>--}%

                                    <div class="checkbox c-checkbox">
                                        <label for="selectedAreaIsStaging">
                                            <input id="selectedAreaIsStaging" name="selectedAreaIsStaging" disabled type="checkbox" ng-model="ctrl.selectedArea.isStaging" />
                                            <span class="fa fa-check"></span><g:message code="form.field.check4.label" />
                                        </label>
                                    </div>

                                    <div class="checkbox c-checkbox">
                                        <label for="isKitting">
                                            <input id="isKitting" name="isKitting"  type="checkbox" class="stagingKittingCheckBox" ng-model="ctrl.selectedArea.isKitting"
                                                       disabled />
                                            <span class="fa fa-check"></span><g:message code="form.field.check7.label" />
                                        </label>
                                    </div>

                                </div>
                            </div>
                            <div class="form-group">
                                %{--<input id="selectedAreaIsPnd" name="selectedAreaIsPnd" disabled type="checkbox" ng-model="ctrl.selectedArea.isPnd" />--}%
                                %{--<label for="selectedAreaIsPnd"><g:message code="form.field.check5.label" /></label>--}%

                                <div class="checkbox c-checkbox">
                                    <label for="selectedAreaIsPnd">
                                        <input id="selectedAreaIsPnd" name="selectedAreaIsPnd" disabled type="checkbox" ng-model="ctrl.selectedArea.isPnd" />
                                        <span class="fa fa-check"></span><g:message code="form.field.check5.label" />
                                    </label>
                                </div>

                            </div>


                            <div  ng-show="ctrl.selectedArea.isStorage" style="padding: 0px 0px 20px 0px; border: solid 1px #333; border-width: 1px 0px;">
                                <h3>Storage Restriction</h3>

                                <div class="form-group" ng-repeat="option in ctrl.selectedAreaEntityAttributes | filter: {'configGroup':'MAXLOAD'}">
                                    Maximum Loads allowed per location in this area: {{option.configValue}}
                                </div>
                                <ul>
                                    <li ng-repeat="option in ctrl.selectedAreaEntityAttributes | filter: {'configGroup':'STRG'}">
                                        {{option.configValue}}
                                    </li>
                                </ul>
                            </div>

                            <div ng-show="ctrl.selectedArea.isPickable" style="padding: 0px 0px 20px 0px; border: solid 1px #333; border-width: 0px 0px 1px 0px;">
                                <h3>Picking Level Restriction</h3>
                                <p>The following are the levels in which inventory can be picked:</p>

                                <ul>
                                    <li ng-repeat="option in ctrl.selectedAreaEntityAttributes | filter: {'configGroup':'PICKLEVEL'}">
                                        {{option.configValue}}
                                    </li>
                                </ul>
                            </div>

                            <div ng-show="ctrl.selectedArea.isPickable" style="padding: 0px 0px 20px 0px; border: solid 1px #333; border-width: 0px 0px 1px 0px;">
                                <h3>Replenishment/Reserve Area</h3>
                                <p>This area can be replenished from the below areas (in that order)</p>
                                <ul>
                                    <li ng-repeat="option in ctrl.selectedAreaEntityAttributes | filter: {'configGroup':'RESERVEDAREA'}">
                                        {{option.configValue}}
                                    </li>
                                </ul>
                            </div>

                            <div ng-show="ctrl.selectedArea.isProcessing && !ctrl.selectedArea.isStaging && !ctrl.selectedArea.isKitting" style="padding: 0px 0px 20px 0px; border: solid 1px #333; border-width: 1px 0px;">
                                <h3>Next Processing Area</h3>
                                <p>The inventory picked in this area must be moved to this area next, before going to staging</p>

                                <li ng-repeat="option in ctrl.selectedAreaEntityAttributes | filter: {'configGroup':'NXTPROCESSAREA'}">
                                    {{option.configValue}}
                                </li>

                            </div>

                            <div class="panel-footer">
                                <div class="pull-left">
                                    <button type="button" class="btn btn-default" ng-click="deleteArea()" >
                                        <em class="fa fa-trash-o fa-fw mr-sm"></em><g:message code="default.button.delete.label" />
                                    </button>
                                </div>
                                <div class="pull-right">
                                    <button type="button" class="btn btn-warning" ng-click="showEditAreaForm()" >
                                        <em class="fa fa-edit fa-fw mr-sm"></em>
                                        Edit
                                    </button>
                                </div>
                                <br style="clear: both;"/>
                            </div>

                            <br style="clear: both;"/>

                        </div>

                        %{--End Display An Area Details--}%


                        %{--Start Add New Area--}%

                        <div ng-show="IsVisibleArea">

                            <form name="ctrl.createAreaForm" ng-submit="ctrl.createArea()" novalidate >

                                <div class="form-group" ng-class="{'has-error':ctrl.hasAreaErrorClass('areaId')}">
                                    <label for="areaId"><g:message code="form.field.areaId.label" /></label>
                                    <input id="areaId" name="areaId" class="form-control" type="text" required
                                           ng-model="ctrl.newArea.areaId"
                                           ng-focus="ctrl.toggleAreaIdPrompt(true)" ng-blur="ctrl.toggleAreaIdPrompt(false); ctrl.areaIdValidation(ctrl.newArea.areaId)"
                                           ng-change="ctrl.toCapitalLetter()"  maxlength="15" />


                                    <div class="my-messages" ng-messages="ctrl.createAreaForm.areaId.$error" ng-if="ctrl.showAreaMessages('areaId')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages"  ng-messages="ctrl.createAreaForm.areaId.$error" ng-if="ctrl.createAreaForm.$error.areaIdExists">
                                        <div class="message-animation" >
                                            <strong>Area Id exists already.</strong>
                                        </div>
                                    </div>


                                </div>

                                <div class="form-group" ng-class="{'has-error':ctrl.hasAreaErrorClass('areaName')}">
                                    <label for="areaName"><g:message code="form.field.name.label" /></label>
                                    <input id="areaName" name="areaName" class="form-control" type="text" required
                                           ng-model="ctrl.newArea.areaName" ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleAreaNamePrompt(true)" ng-blur="ctrl.toggleAreaNamePrompt(false)"
                                           maxlength="30" />


                                    <div class="my-messages" ng-messages="ctrl.createAreaForm.areaName.$error" ng-if="ctrl.showAreaMessages('areaName')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    %{--<input id="isStorage" name="isStorage"  type="checkbox" ng-model="ctrl.newArea.isStorage" ng-change="ctrl.storageCheckBoxChange()" />--}%
                                    %{--<label for="isStorage"><g:message code="form.field.check1.label" /></label>--}%
                                    <div class="checkbox c-checkbox">
                                        <label for="isStorage">
                                            <input id="isStorage" name="isStorage"  type="checkbox" ng-model="ctrl.newArea.isStorage" ng-change="ctrl.storageCheckBoxChange()" />
                                            <span class="fa fa-check"></span><g:message code="form.field.check1.label" />
                                        </label>
                                </div>


                                    <div style="margin-left: 30px;">
                                        %{--<input id="isPickable" name="isPickable"  type="checkbox" ng-model="ctrl.newArea.isPickable"--}%
                                        %{--ng-disabled="!ctrl.newArea.isStorage" />--}%
                                        %{--<label for="isPickable"><g:message code="form.field.check2.label" /></label>--}%

                                        <div class="checkbox c-checkbox">
                                            <label for="isPickable">
                                                <input id="isPickable" name="isPickable"  type="checkbox" ng-model="ctrl.newArea.isPickable" ng-change="ctrl.binCheckBoxChange()"
                                                       ng-disabled="!ctrl.newArea.isStorage" />
                                                <span class="fa fa-check"></span><g:message code="form.field.check2.label" />
                                            </label>
                                        </div>

                                        <div class="checkbox c-checkbox">
                                            <label for="isBinSelect">
                                                <input id="isBinSelect" name="isBinSelect"  type="checkbox" ng-model="ctrl.newArea.isBin" ng-change="ctrl.binCheckBoxChange()" ng-disabled="!ctrl.newArea.isStorage"/>
                                                <span class="fa fa-check"></span><g:message code="form.field.check6.label" />
                                            </label>
                                        </div>

                                    </div>

                                </div>

                                <div class="form-group">
                                    %{--<input id="isProcessing" name="isProcessing"  type="checkbox" ng-model="ctrl.newArea.isProcessing" ng-change="ctrl.processingCheckBoxChange()" />--}%
                                    %{--<label for="isProcessing"><g:message code="form.field.check3.label" /></label>--}%

                                    <div class="checkbox c-checkbox">
                                        <label for="isProcessing">
                                            <input id="isProcessing" name="isProcessing"  type="checkbox" ng-model="ctrl.newArea.isProcessing" ng-change="ctrl.processingCheckBoxChange()" />
                                            <span class="fa fa-check"></span><g:message code="form.field.check3.label" />
                                        </label>
                                    </div>

                                    <div style="margin-left: 30px;">
                                        %{--<input id="isStaging" name="isStaging"  type="checkbox" ng-model="ctrl.newArea.isStaging"--}%
                                        %{--ng-disabled="!ctrl.newArea.isProcessing" />--}%
                                        %{--<label for="isStaging"><g:message code="form.field.check4.label" /></label>--}%

                                        <div class="checkbox c-checkbox">
                                            <label for="isStaging">
                                                <input id="isStaging" name="isStaging"  type="checkbox" class="stagingKittingCheckBox" ng-model="ctrl.newArea.isStaging" ng-change="ctrl.newArea.isKitting = false;"
                                                       ng-disabled="!ctrl.newArea.isProcessing" />
                                                <span class="fa fa-check"></span><g:message code="form.field.check4.label" />
                                            </label>
                                        </div>

                                        <div class="checkbox c-checkbox">
                                            <label for="isKittingNew">
                                                <input id="isKittingNew" name="isKittingNew"  type="checkbox" class="stagingKittingCheckBox" ng-model="ctrl.newArea.isKitting" ng-change="ctrl.newArea.isStaging = false;"
                                                       ng-disabled="!ctrl.newArea.isProcessing" />
                                                <span class="fa fa-check"></span><g:message code="form.field.check7.label" />
                                            </label>
                                        </div>

                                    </div>

                                </div>

                                <div class="form-group">
                                    %{--<input id="isPnd" name="isPnd"  type="checkbox" ng-model="ctrl.newArea.isPnd" ng-change="ctrl.pndCheckBoxChange()" />--}%
                                    %{--<label for="isPnd"><g:message code="form.field.check5.label" /></label>--}%

                                    <div class="checkbox c-checkbox">
                                        <label for="isPnd">
                                            <input id="isPnd" name="isPnd"  type="checkbox" ng-model="ctrl.newArea.isPnd" ng-change="ctrl.pndCheckBoxChange()" />
                                            <span class="fa fa-check"></span><g:message code="form.field.check5.label" />
                                        </label>
                                    </div>

                                </div>



                                <div id="dvStorageRestriction" ng-show="ctrl.newArea.isStorage" style="padding: 0px 0px 20px 0px; border: solid 1px #333; border-width: 1px 0px;">
                                    <h3>Storage Restriction</h3>

                                    <div class="form-group">
                                        <label for="maximumLoad" style="float: left; margin-right: 10px; margin-top: 5px;">Maximum Loads allowed per location in this area: </label>
                                        <input id="maximumLoad" name="maximumLoad" class="form-control" type="text" maxlength="5" numbers-only
                                               ng-model="ctrl.newArea.maximumLoad" ng-change="ctrl.toCapitalLetter()" style="width: 80px; float: left;"/>
                                        <br style="clear: both;"/>

                                    </div>
                                    <ul>
                                        <div class="strgTagDiv2">
                                            <div ng-repeat="option in ctrl.newArea.selectedStorageRestrictionOptions" style="padding-right: 5px; display: inline-block;">
                                                <div class="tagArrowDiv" ng-class ="'tagArrowDivCol'+($index % 5)"></div><div class="tag label label-info attrTags" style="white-space: unset;" ng-class ="'attrTagColour'+($index % 5)">
                                                <button ng-click="ctrl.removeStorageRestrictionOptions(option)" class="btnAttrTag"><img src="/foysonis2016/app/img/close-tag-white.png" style="width: 13px;"  ng-class="'tagCloseBtn'+($index % 2)"></button>&nbsp;{{option.optionValue}}
                                                </div>
                                            </div>
                                        </div>
                                    </ul>

                                    <select  id="storageRestriction" name="storageRestriction" data-ng-model="ctrl.newArea.storageRestriction" class="form-control" style="width: 300px;"
                                             ng-options="option.optionValue for option in ctrl.storageRestrictionOptions track by option.optionValue" ng-change="ctrl.selectStorageRestrictionOptions(); ctrl.addNewAttribute()">
                                    </select>


                                </div>

                                <div id="dvPickingLevelRestriction" ng-show="ctrl.newArea.isPickable" style="padding: 0px 0px 20px 0px; border: solid 1px #333; border-width: 0px 0px 1px 0px;">
                                    <h3>Picking Level Restriction</h3>
                                    <p>The following are the levels in which inventory can be picked:</p>

                                    <ul>
                                        <div class="strgTagDiv1">
                                            <div ng-repeat="level in ctrl.newArea.pickedLevels" style="padding-right: 5px; display: inline-block;">
                                                <div class="tagArrowDiv" ng-class ="'tagArrowDivCol'+($index % 5)"></div><div class="tag label label-info attrTags" style="white-space: unset;" ng-class ="'attrTagColour'+($index % 5)">
                                                      <button ng-click="ctrl.removePickedLevel(level)" class="btnAttrTag"><img src="/foysonis2016/app/img/close-tag-white.png" style="width: 13px;" ng-class="'tagCloseBtn'+($index % 2)"></button>&nbsp;{{level}}
                                                </div>
                                            </div>
                                        </div>
                                        <li  ng-show="ctrl.pickedLevelAlertText" style="color: red;">
                                            Please select at least a picking level.
                                        </li>
                                    </ul>

                                    <select  id="pickingLevel" name="pickingLevel" data-ng-model="ctrl.newArea.pickingLevel" class="form-control" style="width: 300px;"
                                             ng-options="option for option in ctrl.pickingLevelOptions" ng-change="ctrl.selectPickingLevel()">
                                    </select>

                                    <div ng-show="ctrl.resetReplenishmentArea" style="margin-left: 10px; color: red; padding: 0px 10px;">
                                        Replenishment area has been reset.
                                    </div>


                                </div>

                                <div id="dvReplenishmentArea" ng-show="ctrl.newArea.isPickable" style="padding: 0px 0px 20px 0px; border: solid 1px #333; border-width: 0px 0px 1px 0px;">
                                    <h3>Replenishment/Reserve Area</h3>
                                    <p>This area can be replenished from the below areas (in that order)</p>

                                    <ul>
                                        <div class="tag label label-info" ng-repeat="level in ctrl.newArea.selectedReplenishmentAreas" style="margin-right: 10px;">
                                            {{level}} &nbsp; <button ng-click="ctrl.removeReplenishmentArea(level)" style="color: #326290">×</button>
                                        </div>
                                    </ul>

                                    <select  id="replenishmentArea" name="replenishmentArea" data-ng-model="ctrl.newArea.replenishmentArea" class="form-control" style="width: 300px;"
                                             ng-options="option for option in ctrl.replenishmentAreaValues" ng-change="ctrl.selectReplenishmentArea()">
                                    </select>

                                </div>

                                <div id="dvNextProcessingArea" ng-show="ctrl.newArea.isProcessing && !ctrl.newArea.isStaging && !ctrl.newArea.isKitting" style="padding: 0px 0px 20px 0px; border: solid 1px #333; border-width: 1px 0px;">
                                    <h3>Next Processing Area</h3>
                                    <p>The inventory picked in this area must be moved to this area next, before going to staging</p>

                                    <select  id="nextProcessingArea" name="nextProcessingArea" data-ng-model="ctrl.newArea.nextProcessingArea" class="form-control" style="width: 300px;"
                                             ng-options="area.areaId for area in ctrl.processingAreas">
                                    </select>

                                </div>


                                <div class="panel-footer">
                                    <div class="pull-left">
                                        <button  type="button" class="btn btn-default" ng-click="cancelCreateNewArea()"><g:message code="default.button.cancel.label" /></button>
                                    </div>
                                    <div class="pull-right">
                                        <button class="btn btn-primary" type="submit"><g:message code="default.button.save.label" /></button>
                                    </div>
                                    <br style="clear: both;"/>
                                </div>

                            </form>


                        </div>


                        %{--End Add New Area--}%

                        %{--Start Edit Area--}%
                        <div ng-show="ctrl.isShowEditAreaForm">

                            <form name="ctrl.editAreaForm" ng-submit="ctrl.updateArea()" novalidate >

                                <div class="form-group">
                                    <h4><g:message code="form.field.id.label" />: {{ctrl.selectedAreaId}}</h4>
                                </div>

                                <div class="form-group" ng-class="{'has-error':ctrl.hasEditAreaErrorClass('areaName')}">
                                    <label for="areaName"><g:message code="form.field.name.label" /></label>
                                    <input id="areaName" name="areaName" class="form-control" type="text" required
                                           ng-model="ctrl.selectedArea.areaName" ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleAreaNamePrompt(true)" ng-blur="ctrl.toggleAreaNamePrompt(false)"
                                           maxlength="30" />

                                    <div class="my-messages" ng-messages="ctrl.editAreaForm.areaName.$error" ng-if="ctrl.showEditAreaMessages('areaName')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    %{--<input id="isStorage" name="isStorage"  type="checkbox" ng-model="ctrl.selectedArea.isStorage" ng-change="ctrl.editStorageCheckBoxChange()" />--}%
                                    %{--<label for="isStorage"><g:message code="form.field.check1.label" /></label>--}%

                                    <div class="checkbox c-checkbox">
                                        <label for="isStorageEdit">
                                            <input id="isStorageEdit" name="isStorageEdit"  type="checkbox" ng-model="ctrl.selectedArea.isStorage" ng-change="ctrl.editStorageCheckBoxChange()" />
                                            <span class="fa fa-check"></span><g:message code="form.field.check1.label" />
                                        </label>
                                    </div>

                                    <div style="margin-left: 30px;">
                                        %{--<input id="isPickable" name="isPickable"  type="checkbox" ng-model="ctrl.selectedArea.isPickable"--}%
                                        %{--ng-disabled="!ctrl.selectedArea.isStorage" ng-change="ctrl.editPickableCheckBoxChange()" />--}%
                                        %{--<label for="isPickable"><g:message code="form.field.check2.label" /></label>--}%

                                        <div class="checkbox c-checkbox">
                                            <label for="isPickableEdit">
                                                <input id="isPickableEdit" name="isPickableEdit"  type="checkbox" ng-model="ctrl.selectedArea.isPickable" ng-change="ctrl.editBinCheckBoxChange()"
                                                       ng-disabled="!ctrl.selectedArea.isStorage" ng-change="ctrl.editPickableCheckBoxChange()" />
                                                <span class="fa fa-check"></span><g:message code="form.field.check2.label" />
                                            </label>
                                        </div>

                                        <div class="checkbox c-checkbox">
                                            <label for="isBinEdit">
                                                <input id="isBinEdit" name="isBinEdit"  type="checkbox" ng-model="ctrl.selectedArea.isBin" ng-change="ctrl.editBinCheckBoxChange()"
                                                       ng-disabled="!ctrl.selectedArea.isStorage" ng-change="ctrl.editPickableCheckBoxChange()" />
                                                <span class="fa fa-check"></span><g:message code="form.field.check6.label" />
                                            </label>
                                        </div>


                                    </div>

                                </div>

                                <div class="form-group">
                                    %{--<input id="isProcessing" name="isProcessing"  type="checkbox" ng-model="ctrl.selectedArea.isProcessing" ng-change="ctrl.editProcessingCheckBoxChange()" />--}%
                                    %{--<label for="isProcessing"><g:message code="form.field.check3.label" /></label>--}%

                                    <div class="checkbox c-checkbox">
                                        <label for="isProcessingEdit">
                                            <input id="isProcessingEdit" name="isProcessingEdit"  type="checkbox" ng-model="ctrl.selectedArea.isProcessing" ng-change="ctrl.editProcessingCheckBoxChange()" />
                                            <span class="fa fa-check"></span><g:message code="form.field.check3.label" />
                                        </label>
                                    </div>


                                    <div style="margin-left: 30px;">
                                        %{--<input id="isStaging" name="isStaging"  type="checkbox" ng-model="ctrl.selectedArea.isStaging"--}%
                                        %{--ng-disabled="!ctrl.selectedArea.isProcessing" />--}%
                                        %{--<label for="isStaging"><g:message code="form.field.check4.label" /></label>--}%

                                        <div class="checkbox c-checkbox">
                                            <label for="isStagingEdit">
                                                <input id="isStagingEdit" name="isStagingEdit"  type="checkbox" ng-model="ctrl.selectedArea.isStaging" ng-change="ctrl.selectedArea.isKitting = false;"
                                                       ng-disabled="!ctrl.selectedArea.isProcessing" />
                                                <span class="fa fa-check"></span><g:message code="form.field.check4.label" />
                                            </label>
                                        </div>
                                        <div class="checkbox c-checkbox">
                                            <label for="isKittingEdit">
                                                <input id="isKittingEdit" name="isKittingEdit"  type="checkbox" class="stagingKittingCheckBox" ng-model="ctrl.selectedArea.isKitting" ng-change="ctrl.selectedArea.isStaging = false;"
                                                       ng-disabled="!ctrl.selectedArea.isProcessing" />
                                                <span class="fa fa-check"></span><g:message code="form.field.check7.label" />
                                            </label>
                                        </div>

                                    </div>

                                </div>

                                <div class="form-group">
                                    %{--<input id="isPnd" name="isPnd"  type="checkbox" ng-model="ctrl.selectedArea.isPnd" ng-change="ctrl.editPndCheckBoxChange()" />--}%
                                    %{--<label for="isPnd"><g:message code="form.field.check5.label" /></label>--}%

                                    <div class="checkbox c-checkbox">
                                        <label for="isPndEdit">
                                            <input id="isPndEdit" name="isPndEdit"  type="checkbox" ng-model="ctrl.selectedArea.isPnd" ng-change="ctrl.editPndCheckBoxChange()" />
                                            <span class="fa fa-check"></span><g:message code="form.field.check5.label" />
                                        </label>
                                    </div>

                                </div>


                                <div ng-show="ctrl.selectedArea.isStorage" style="padding: 0px 0px 20px 0px; border: solid 1px #333; border-width: 1px 0px;">
                                    <h3>Storage Restriction</h3>

                                    <div class="form-group">
                                        <label for="maximumLoad" style="float: left; margin-right: 10px; margin-top: 5px;">Maximum Loads allowed per location in this area: </label>
                                        <input id="maximumLoad" name="maximumLoad" class="form-control" type="text" maxlength="5" numbers-only
                                               ng-model="ctrl.selectedArea.maximumLoad" ng-change="ctrl.toCapitalLetter()" style="width: 80px; float: left;"/>
                                        <br style="clear: both;"/>

                                    </div>

                                    <ul>
                                        <div class="strgTagDiv2" style="top: 551px;">
                                            <div ng-repeat="option in ctrl.editArea.selectedStorageRestrictionOptions" style="padding-right: 5px; display: inline-block;">
                                                <div class="tagArrowDiv" ng-class ="'tagArrowDivCol'+($index % 5)"></div>
                                                <div class="tag label label-info attrTags" style="white-space: unset;" ng-class ="'attrTagColour'+($index % 5)">
                                                 <button ng-click="ctrl.removeStorageRestrictionOptionsEdit(option)" class="btnAttrTag"><img src="/foysonis2016/app/img/close-tag-white.png" style="width: 13px;"  ng-class="'tagCloseBtn'+($index % 2)"></button>&nbsp; {{option.configValue}}
                                                </div>
                                            </div>
                                        </div>
                                    </ul>

                                    <select  id="storageRestriction" name="storageRestriction" data-ng-model="ctrl.editArea.storageRestriction" class="form-control" style="width: 300px;"
                                             ng-options="option.optionValue for option in ctrl.storageRestrictionOptionsEdit track by option.optionValue" ng-change="ctrl.selectStorageRestrictionOptionsEdit(); ctrl.addNewAttributeEdit()">
                                    </select>

                                </div>

                                <div ng-show="ctrl.selectedArea.isPickable" style="padding: 0px 0px 20px 0px; border: solid 1px #333; border-width: 0px 0px 1px 0px;">
                                    <h3>Picking Level Restriction</h3>
                                    <p>The following are the levels in which inventory can be picked:</p>

                                    <ul>
                                        <div class="strgTagDiv1" style=" top: 698px;">
                                            <div ng-repeat="level in ctrl.editArea.pickedLevels" style="padding-right: 5px; display: inline-block;">
                                                <div class="tagArrowDiv" ng-class ="'tagArrowDivCol'+($index % 5)"></div><div class="tag label label-info attrTags" style="white-space: unset;" ng-class ="'attrTagColour'+($index % 5)">
                                                <button ng-click="ctrl.removePickedLevelEdit(level)" class="btnAttrTag"><img src="/foysonis2016/app/img/close-tag-white.png" style="width: 13px;" ng-class="'tagCloseBtn'+($index % 2)"></button>&nbsp;{{level.configValue}}
                                        </div>
                                            </div>
                                        </div>
                                        <li  ng-show="ctrl.pickedLevelAlertTextEdit" style="color: red;">
                                            Please select at least a picking level.
                                        </li>
                                    </ul>

                                    <select  id="pickingLevel" name="pickingLevel" data-ng-model="ctrl.editArea.pickingLevel" class="form-control" style="width: 300px;"
                                             ng-options="option for option in ctrl.pickingLevelOptionsEdit" ng-change="ctrl.selectPickingLevelEdit()">
                                    </select>

                                    <div ng-show="ctrl.resetReplenishmentAreaEdit" style="margin-left: 10px; color: red; padding: 0px 10px;">
                                        Replenishment area has been reset.
                                    </div>

                                </div>

                                <div ng-show="ctrl.selectedArea.isPickable" style="padding: 0px 0px 20px 0px; border: solid 1px #333; border-width: 0px 0px 1px 0px;">
                                    <h3>Replenishment/Reserve Area</h3>
                                    <p>This area can be replenished from the below areas (in that order)</p>

                                    <ul>
                                        <div class="tag label label-info" ng-repeat="level in ctrl.editArea.selectedReplenishmentAreas"  style="margin-right: 10px;">
                                            {{level.configValue}}  &nbsp; <button ng-click="ctrl.removeReplenishmentAreaEdit(level)" style="color: #326290">×</button>
                                        </div>
                                    </ul>

                                    <select  id="replenishmentArea" name="replenishmentArea" data-ng-model="ctrl.editArea.replenishmentArea" class="form-control" style="width: 300px;"
                                             ng-options="option for option in ctrl.replenishmentAreaValuesEdit" ng-change="ctrl.selectReplenishmentAreaEdit()">
                                    </select>

                                </div>

                                <div ng-show="ctrl.selectedArea.isProcessing && !ctrl.selectedArea.isStaging && !ctrl.selectedArea.isKitting" style="padding: 0px 0px 20px 0px; border: solid 1px #333; border-width: 1px 0px;">
                                    <h3>Next Processing Area</h3>
                                    <p>The inventory picked in this area must be moved to this area next, before going to staging</p>

                                    <select  id="nextProcessingArea" name="nextProcessingArea" data-ng-model="ctrl.editArea.nextProcessingArea" class="form-control" style="width: 300px;"
                                             ng-options="area.areaId for area in ctrl.processingAreas">
                                    </select>

                                </div>


                                <div class="panel-footer">
                                    <div class="pull-left">
                                        <button class="btn btn-default" type="button" ng-click="cancelEditArea()"><g:message code="default.button.cancel.label" /></button>
                                    </div>
                                    <div class="pull-right">
                                        <button class="btn btn-primary" type="submit"><g:message code="default.button.update.label" /></button>
                                    </div>
                                    <br style="clear: both;"/>
                                </div>


                            </form>

                        </div>

                        %{--End Edit Area--}%


                    </div>
                </div>
            </div>
            <!--/.panel-body -->
        </div>

        <!-- END panel-->

    </div>

    <!-- Modal for Adding new Attribute-->
    <div id="addNewAttribute" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Add New Storage Attribute</h4>
                </div>
                <div class="modal-body">
                    <label>Storage Attribute :</label>
                    <input id="addNewStrgAttribute" name="addNewStrgAttribute" class="form-control" type="text" ng-model="ctrl.addNewStrgAttribute" placeholder = "Enter A New Storage Attribute"/>

                </div>
                <div class="modal-footer">
                    <button type="button"  id = "strgAttributeCancelSave" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "strgAttributeSave" class="btn btn-primary"><g:message code="default.button.add.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <div id="addNewAttributeEdit" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Add New Storage Attribute</h4>
                </div>
                <div class="modal-body">
                    <label>Storage Attribute :</label>
                    <input id="addNewStrgAttributeEdit" name="addNewStrgAttribute" class="form-control" type="text" ng-model="ctrl.addNewStrgAttributeEdit" placeholder = "Enter A New Storage Attribute"/>

                </div>
                <div class="modal-footer">
                    <button type="button"  id = "strgAttributeCancelSaveEdit" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "strgAttributeSaveEdit" class="btn btn-primary"><g:message code="default.button.add.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <div id="binAreaWarning" class="modal fade" role="dialog" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Confirmation</h4>
                </div>
                <div class="modal-body">
                    <p>Some of the locations in this area has got pallets or cases, if this area changed as a "bin" area the pallets and cases will be disappear.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" ng-disabled="ctrl.disableConfirmBinArea"><g:message code="default.button.cancel.label"/></button>
                    <button type="button" class="btn btn-primary" ng-click="ctrl.changeAreaToBin()" ng-disabled="ctrl.disableConfirmBinArea">{{ctrl.confirmBinAreaBtnText}}</button>
                </div>
            </div>
        </div>
    </div>
    <div id="itemLowestUOMInCase" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Bin Location Warning</h4>
                </div>
                <div class="modal-body">
                    This area contains lowest UOM CASE inventory, this area cannot be changed as a "bin" area. 
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>
    <!-- import CSV dialog model -->
    <div id="importLocation" class="modal fade" role="dialog">
    <div class="receipt-modal-dialog modal-dialog"  style="width: 100%;">
        <div class="receipt-modal-content modal-content">
            <div class="receipt-modal-header modal-header">
                <button type="button" class="receipt-close close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <br style="clear: both;"/>

                <div class="panel-heading">
                    <div class="receipt-panel-title panel-title"><h4>Import CSV</h4></div>
                </div>

                </div>

                <div class="receipt-modal-body modal-body">

                    <p>Dowload a sample location CSV file <g:link controller="location" action="downloadLocationCsvFile">Here.</g:link></p>
                    <br style="clear: both;">
                    <input type="file"  id="csvImport" /> <span ng-show="loadAnimPickListSearch"><img src="${request.contextPath}/foysonis2016/app/img/loading.gif"/></span>
                    <br style="clear: both;"/>

                    <div id="grid1" ui-grid="gridOptions" ui-grid-exporter ui-grid-pinning ui-grid-resize-columns  class="csvGrid"></div>
                    <br style="clear: both;"/>

                    <button type="button" class="btn btn-primary" id ="importCSVButton" ng-show="ctrl.uploadCSV">Import CSV</button>

                </div>


                <div class="receipt-modal-footer modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                </div>

            </div>
        </div>
    </div>   
    <!-- end import CSV dialog model -->
    <div id="dvPreventAddLocation" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Confirmation</h4>
                </div>
                <div class="modal-body">
                    <p>{{ctrl.errorMsgForLocationCreate}}</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div> 


</div>

<!-- bootstrap modal confirmation dialog-->

<div id="myModal" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure want to delete this location ?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "deleteButton" class="btn btn-primary"><g:message code="default.button.delete.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="dvDeleteArea" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure want to delete this area ?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "areaDeleteButton" class="btn btn-primary"><g:message code="default.button.delete.label" /></button>
            </div>
        </div>
    </div>
</div>

<div id="dvDeleteAreaWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Alert</h4>
            </div>
            <div class="modal-body">
                <p>You can not delete this area as it contains locations.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>

<div id="deleteLocationWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Alert</h4>
            </div>
            <div class="modal-body">
                <p>You can not delete this Location as it contains inventory.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>

<!-- Location unblock confirmation dialog model -->
<div id="locationUnBlock" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p><b>Are you sure want to Unblock this Location ?</b></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "locationUnBlockButton" class="btn btn-primary">UnBlock</button>
            </div>
        </div>
    </div>
</div>
<!-- end Location unblock confirmation dialog model -->


<!-- Location block confirmation dialog model -->
<div id="locationBlock" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p><b>Are you sure want to Block this Location ?</b></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "locationBlockButton" class="btn btn-primary">Block</button>
            </div>
        </div>
    </div>
</div>
<!-- end Location block confirmation dialog model -->


<asset:javascript src="datagrid/admin-area-location.js"/>

<script type="text/javascript">
    var dvAdminAreaLocation = document.getElementById('dvAdminAreaLocation');
    angular.element(document).ready(function() {
        angular.bootstrap(dvAdminAreaLocation, ['adminArea']);
    });
</script>

<asset:javascript src="datagrid/locationImportService.js"/>

</body>
</html>
