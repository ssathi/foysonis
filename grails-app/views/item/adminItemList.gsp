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
        }

        .csvGrid {
            height:380px;
            width: 1300px;
        }

        .grid-align {
            text-align: center;
        }

        .grid-action-align {
            padding-left: 70px;
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

        .csvImportBtn {
            background-color: #22a49c !important;
            height: 37px;
            line-height: 1;
            border: 0px;
        } 
            
        .cropArea {
            background: #333333;
            overflow: hidden;
            width:500px;
            height:350px;
        }

        .compLogo {
            width:208px;
            height:208px;
            border: 4px solid #315d90;
            background: #eaeae1;
            box-shadow: 9px 8px 21px -9px rgba(0,0,0,0.75);
        }        
        /*.ui-grid-top-panel {*/
        /*/!* overflow: hidden; *!/*/
        /*}*/

    </style>

<%-- **************************** End of CSS **************************** --%>    

</head>

<body>


    <div ng-cloak class="row" id="dvAdminItem" ng-controller="ItemCtrl as ctrl">

        <div class="col-lg-12">
            <!-- START panel-->
            <!-- <div class="panel panel-default">
                <div class="panel-body" style="overflow:hidden;"> -->
                        
                        <%-- **************************** createItem form **************************** --%>
                            <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 35px;" src="/foysonis2016/app/img/item-header.svg"></em>&emsp;&nbsp;<span class="headerTitle">Items</span></div>
                                
                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">

                                <button type="button" class="btn btn-import csvImportBtn pull-right" style="float: right; margin-left:20px;" ng-click="importItem()">
                                    <em class="fa  fa-fw mr-sm" >
                                        <img src="/foysonis2016/app/img/import_icon.svg">
                                    </em>
                                    CSV Item Import
                                </button>

                                <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide()">
                                    <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                                    <g:message code="default.button.createItem.label" />
                                </button>
                            </a>
                            <br style="clear: both;"/>
                            <br style="clear: both;"/>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showSubmittedPrompt">
                                <g:message code="item.create.message" />
                            </div>
                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showDeletedPrompt">
                                <g:message code="item.delete.message" />
                            </div>


                            <div class="alert alert-success message-animation" role="alert" ng-show="ctrl.showImportItemSubmittedPrompt">
                                <g:message code="item.import.message" />
                            </div>

                            <div ng-show="IsVisible" class="row">

                                <form name="ctrl.createItemForm" ng-submit="ctrl.createItem()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">                                         
                                            <div class="panel-title"><g:message code="default.item.add.label" /></div>
                                        </div>
                                        <!-- //TODO delete it -->
                                        <!-- <input type = "file" id="fileInput"/>
                                        <button type="button" ng-click = "uploadImageFile()">upload me</button> -->
                                        <!-- //TODO delete it -->

                                        <div class="panel-body">

                                            <div class="col-md-12">

                                                <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('itemId')}">

                                                        <label for="itemId"><g:message code="form.field.itemId.label" /></label>
                                                        <input id="itemId" name="itemId" class="form-control" type="text" maxlength="32" capitalize required
                                                               ng-model="ctrl.newItem.itemId"
                                                               ng-focus="ctrl.toggleItemIdPrompt(true)" ng-blur="ctrl.toggleItemIdPrompt(false); ctrl.itemIdUniqueValidation(ctrl.newItem.itemId)"/>


                                                        <div class="my-messages"  ng-messages="ctrl.createItemForm.itemId.$error"
                                                             ng-if="ctrl.createItemForm.$error.itemIdExists">
                                                            <div class="message-animation" >
                                                                <strong>Item Id exists already.</strong>
                                                            </div>
                                                        </div>

                                                        <div class="my-messages" ng-messages="ctrl.createItemForm.itemId.$error" ng-if="ctrl.showMessages('itemId')">
                                                            <div class="message-animation" ng-message="required">
                                                                %{--<strong>This field is required.</strong>--}%
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>

                                                <div class="col-md-6 pull-right">
                                                    <label>Select item image : </label>
                                                    <div ><input type="file" class="itemImageInput" /></div>
                                                    <button class="btn btn-default" style="height: 25px; line-height: 0;" type="button" ng-click="ctrl.clearLoadedItmImage()">Clear Image</button>
                                                    <div class='compLogo'><img src="{{itemCroppedImage}}" width="200px" /></div>
                                                    <br style="clear:both;" />
                                                    <p ng-if='invalidFileSize' style="color:#F51B1B; font-weight:bold; font-size: 13px;">The file is bigger than 1MB.</p>
                                                    <p ng-if='invalidFileType' style="color:#F51B1B; font-weight:bold; font-size: 13px;">This is an invalid file type, Please upload a file in JPEG or PNG formats </p>
                                                </div>

                                                <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('itemDescription')}">
                                                    <label for="itemDescription"><g:message code="form.field.itemDescription.label" /></label>
                                                    <input id="itemDescription" name="itemDescription" class="form-control" type="text" maxlength="140" required
                                                           ng-model="ctrl.newItem.itemDescription" ng-model-options="{ updateOn : 'blur' }"
                                                           ng-focus="ctrl.toggleItemDescriptionPrompt(true)" ng-blur="ctrl.toggleItemDescriptionPrompt(false)" />


                                                    <div class="my-messages" ng-messages="ctrl.createItemForm.itemDescription.$error" ng-if="ctrl.showMessages('itemDescription')">
                                                        <div class="message-animation" ng-message="required">
                                                            %{--<strong>This field is required.</strong>--}%
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>

                                            </div>

                                            <div class="col-md-12">



                                                <div class="col-md-6">


                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('itemCategory')}">
                                                        <label for="itemCategory"><g:message code="form.field.itemCategory.label" /></label>
                                                        <select  id="itemCategory" name="itemCategory" ng-model="ctrl.newItemCategory" class="form-control" ng-change = "ctrl.addNewValue()">

                                                            <option ng-repeat="listValue in  ctrl.listValue" value="{{listValue.description}}">{{listValue.description}}
                                                            </option>
                                                            <option value="newItemCategory" >+ Add new item category</option>
                                                        </select>


                                                    </div>

                                                    <br style="clear: both;"/>
                                                </div>


                                                <div class="col-md-6">


                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('lowestUom')}">
                                                    <label for="lowestUom"><g:message code="form.field.uom.label" /></label>
                                                    <select  id="lowestUom" name="lowestUom" ng-model="ctrl.newItem.lowestUom" class="form-control" ng-change="ctrl.clearEach(ctrl.newItem.lowestUom)">

                                                        <option value="EACH" >EACH</option>
                                                        <option value="CASE">CASE</option>
                                                        <option value="PALLET">PALLET</option>
                                                    </select>


                                                    <div class="my-messages" ng-messages="ctrl.createItemForm.areaId.$error" ng-if="ctrl.showMessages('areaId')">
                                                        <div class="message-animation" ng-message="required">
                                                            %{--<strong>This field is required.</strong>--}%
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>
                                                <br style="clear:both;"/>
                                            </div>

                                            </div>

                                            <div class="col-md-12">

                                                <div class="col-md-6">
                                                    <div class="col-md-4">



                                                        <div class="form-group">
                                                            <label for="isLotTracked"><g:message code="form.field.isLotTrack.label" /></label>
                                                            %{--<input id="isLotTracked" name="isLotTracked" class="form-control"  type="checkbox" ng-model="ctrl.newItem.isLotTracked">--}%

                                                            <div class="checkbox c-checkbox">
                                                                <label>
                                                                    <input id="isLotTracked" name="isLotTracked" type="checkbox" ng-model="ctrl.newItem.isLotTracked">
                                                                    <span class="fa fa-check"></span>
                                                                </label>
                                                            </div>

                                                        </div>
                                                    </div>


                                                    <div class="col-md-4">


                                                        <div class="form-group">
                                                            <label for="isExpirdeleteItemButtoned"><g:message code="form.field.isExp.label" /></label>
                                                            %{--<input id="isExpired" name="isExpired" class="form-control"  type="checkbox" ng-model="ctrl.newItem.isExpired">--}%

                                                            <div class="checkbox c-checkbox">
                                                                <label>
                                                                    <input id="isExpired" name="isExpired" type="checkbox" ng-model="ctrl.newItem.isExpired">
                                                                    <span class="fa fa-check"></span>
                                                                </label>
                                                            </div>

                                                        </div>
                                                    </div>

                                                    <div class="col-md-4">


                                                        <div class="form-group">
                                                            <label for="isCaseTracked"><g:message code="form.field.trackCase.label" /></label>
                                                            %{--<input id="isCaseTracked" name="isCaseTracked" class="form-control"  type="checkbox" ng-model="ctrl.newItem.isCaseTracked">--}%

                                                            <div class="checkbox c-checkbox">
                                                                <label ng-if = "ctrl.newItem.lowestUom != 'PALLET'">
                                                                    <input id="isCaseTracked" name="isCaseTracked" type="checkbox" ng-model="ctrl.newItem.isCaseTracked">
                                                                    <span class="fa fa-check"></span>
                                                                </label>
                                                                <label ng-if = "ctrl.newItem.lowestUom == 'PALLET'">
                                                                    <input id="isCaseTracked" name="isCaseTracked" type="checkbox" ng-model="ctrl.newItem.isCaseTracked" disabled>
                                                                    <span class="fa fa-check"></span>
                                                                </label>
                                                            </div>

                                                        </div>
                                                    </div>

                                                </div>

                                                <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('originCode')}">
                                                    <label for="originCode"><g:message code="form.field.originCode.label" /></label>
                                                    <select  id="originCode" name="originCode" ng-model="ctrl.newItem.originCode" class="form-control" >
                                                        <option ng-repeat="originCode in ctrl.originCode" value="{{originCode.code}}">{{originCode.name}}
                                                        </option>
                                                    </select>

                                                </div>
                                            </div>

                                                <br style="clear: both;"/>
                                            </div>

                                            <div class="col-md-12">

                                                <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('eachesPerCase')}" ng-if = "ctrl.newItem.lowestUom == 'EACH'">
                                                        <label for="eachesPerCase"><g:message code="form.field.eachPerCase.label" /></label>
                                                        <input id="eachesPerCase" name="eachesPerCase" class="form-control" type="number"
                                                               ng-model="ctrl.newItem.eachesPerCase" ng-model-options="{ updateOn : 'default blur' }"
                                                               ng-focus="ctrl.toggleEachesPerCasePrompt(true)" ng-blur="ctrl.toggleEachesPerCasePrompt(false);" min="1" required />

                                                        <div class="my-messages" ng-messages="ctrl.createItemForm.eachesPerCase.$error" ng-if="ctrl.showMessages('eachesPerCase')">
                                                            <div class="message-animation" ng-message="required">
                                                                %{--<strong>This field is required.</strong>--}%
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>
                                                        <div class="my-messages"  ng-messages="ctrl.createItemForm.eachesPerCase.$error"
                                                             ng-if="ctrl.createItemForm.eachesPerCase.$error.min">
                                                            <div class="message-animation" >
                                                                <strong>The value should be greater than 0(zero).</strong>
                                                            </div>
                                                        </div>

                                                    </div>

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('eachesPerCase')}" ng-if = "ctrl.newItem.lowestUom == 'CASE'">
                                                        <label for="eachesPerCase"><g:message code="form.field.eachPerCase.label" /></label>
                                                        <input id="eachesPerCase" name="eachesPerCase" class="form-control" type="text"
                                                               ng-model="ctrl.newItem.eachesPerCase" ng-model-options="{ updateOn : 'default blur' }"
                                                               ng-focus="ctrl.toggleEachesPerCasePrompt(true)" ng-blur="ctrl.toggleEachesPerCasePrompt(false)" numbers-only disabled />
                                                    </div>

                                                </div>

                                                <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('casesPerPallet')}" ng-if = "ctrl.newItem.lowestUom == 'EACH' || ctrl.newItem.lowestUom == 'CASE' ">
                                                    <label for="casesPerPallet"><g:message code="form.field.casePerPallet.label" /></label>
                                                    <input id="casesPerPallet" name="casesPerPallet" class="form-control" type="number"
                                                           ng-model="ctrl.newItem.casesPerPallet" ng-model-options="{ updateOn : 'default blur' }"
                                                           ng-focus="ctrl.toggleCasesPerPalletPrompt(true)" ng-blur="ctrl.toggleCasesPerPalletPrompt(false);ctrl.casesPerPalletZeroValidation(ctrl.newItem.casesPerPallet)" min="1" required/>


                                                    <div class="my-messages" ng-messages="ctrl.createItemForm.casesPerPallet.$error" ng-if="ctrl.showMessages('casesPerPallet')">
                                                        <div class="message-animation" ng-message="required">
                                                            %{--<strong>This field is required.</strong>--}%
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                    <div class="my-messages"  ng-messages="ctrl.createItemForm.casesPerPallet.$error"
                                                             ng-if="ctrl.createItemForm.casesPerPallet.$error.min">
                                                        <div class="message-animation" >
                                                            <strong>The value should be greater than 0(zero).</strong>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>

                                            </div>


                                            <div class="col-md-12">
                                                <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('upcCode')}">
                                                        <label for="upcCode"><g:message code="form.field.upc.label" /></label>
                                                        <input id="upcCode" name="upcCode" class="form-control" type="text"
                                                               ng-model="ctrl.newItem.upcCode" ng-model-options="{ updateOn : 'default blur' }"
                                                               ng-focus="ctrl.toggleUpcCodePrompt(true)" ng-blur="ctrl.toggleUpcCodePrompt(false)" maxlength="15"/>

                                                    </div>

                                                </div>


                                                <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('eanCode')}">
                                                        <label for="eanCode"><g:message code="form.field.ean.label" /></label>
                                                        <input id="eanCode" name="eanCode" class="form-control" type="text"
                                                               ng-model="ctrl.newItem.eanCode" ng-model-options="{ updateOn : 'default blur' }"
                                                               ng-focus="ctrl.toggleEanCodePrompt(true)" ng-blur="ctrl.toggleEanCodePrompt(false)" maxlength="15"/>

                                                    </div>

                                                </div>

                                            </div>

                                            <div class="col-md-12">

                                                <div class="col-md-6">

                                                    <label><g:message code="form.field.storageAttributes.label" /></label>
                                                    <div class="strgTagDiv">
                                                        <div ng-repeat="storageAttributes in ctrl.newItem.storageAttributes" style="padding-right: 5px; display: inline-block;">
                                                            <div class="tagArrowDiv" ng-class ="'tagArrowDivCol'+($index % 5)"></div><div class="tag label label-info attrTags" style="white-space: unset;" ng-class ="'attrTagColour'+($index % 5)"><button ng-click="ctrl.removeStorageAttributes(storageAttributes)" class="btnAttrTag" ><img src="/foysonis2016/app/img/close-tag-white.png" style="width: 13px;" ng-class="'tagCloseBtn'+($index % 2)"></button>&nbsp;
                                                            {{storageAttributes.optionValue}} 
                                                            </div>
                                                        </div>
                                                        

                                                    </div>

                                                    <div class="form-group">
                                                        <select id="storageAttributes" name="storageAttributes" data-ng-model="ctrl.getStorageAttributes"
                                                                ng-options="option.optionValue for option in ctrl.storageOptions track by option.optionValue" ng-change="ctrl.selectStorageAttributes(ctrl.getStorageAttributes);ctrl.addNewAttribute()" class="form-control">
                                                        </select>
                                                    </div>
                                                    <div ng-if = "!ctrl.isStorageAtrributeExist" >Warning : No area matches this storage attributes <span ng-repeat="selectedAttr in ctrl.selectedStorageAttr">{{selectedAttr}}{{$last ? '' : ', '}}</span>.</div>

                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('reOrderLevelQty')}">
                                                        <label for="reOrderLevelQty"><g:message code="form.field.reorderLevelQty" /></label>
                                                        <input id="reOrderLevelQty" name="reOrderLevelQty" class="form-control" type="number"
                                                               ng-model="ctrl.newItem.reOrderLevelQty" ng-model-options="{ updateOn : 'default blur' }"
                                                               ng-focus="ctrl.toggleEachesPerCasePrompt(true)" ng-blur="ctrl.toggleEachesPerCasePrompt(false);" min="0" />

                                                        <div class="my-messages"  ng-messages="ctrl.createItemForm.reOrderLevelQty.$error"
                                                             ng-if="ctrl.createItemForm.reOrderLevelQty.$error.min">
                                                            <div class="message-animation" >
                                                                <strong>The value should be greater than 0(zero).</strong>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </div>

                                                <br style="clear: both;"/>
                                            </div>
                                       
                                        </div>
                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="ShowHide()"><g:message code="default.button.cancel.label" /></button>
                                                </a>

                                            </div>
                                            <div class="pull-right">
                                                <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disableItemSave"><!-- <g:message code="default.button.save.label" /> -->{{ctrl.itemSaveBtnText}}</button>
                                            </div>
                                            <br style="clear: both;"/>
                                        </div>



                                  </div>  
                                </form>

                            </div>
<%-- **************************** End of createItem form **************************** --%>



<%-- **************************** Edit Item form **************************** --%>

                            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showUpdatedPrompt">
                                <g:message code="item.edit.message" />
                            </div>

                            <div ng-show="ctrl.editItemState" class="row">

                                <form name="ctrl.editItemForm" ng-submit="ctrl.editItemFunction()" novalidate >

                                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                                        <div class="panel-heading">                                         
                                            <div class="panel-title"><g:message code="default.item.edit.label" /></div>
                                        </div>

                                        <div class="panel-body">
                                            <div class="col-md-12">


                                                <div class="col-md-12">
                                                    <div class="col-md-6">
                                                        <label><g:message code="form.field.itemId.label" /> : {{ctrl.editItem.itemId}}</label>
                                                    </div>
                                                </div>

                                                <div class="col-md-12">
                                                    <div class="col-md-6">
                                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('itemDescription')}">
                                                            <label for="itemDescription"><g:message code="form.field.itemDescription.label" /></label>
                                                            <input id="itemDescription" name="itemDescription" class="form-control" type="text" maxlength="140" required
                                                                   ng-model="ctrl.editItem.itemDescription" ng-model-options="{ updateOn : 'blur' }"
                                                                   ng-focus="ctrl.toggleEditItemDescriptionPrompt(true)" ng-blur="ctrl.toggleEditItemDescriptionPrompt(false)" />



                                                            <div class="my-messages" ng-messages="ctrl.editItemForm.itemDescription.$error" ng-if="ctrl.showMessagesEdit('itemDescription')">
                                                                <div class="message-animation" ng-message="required">
                                                                    %{--<strong>This field is required.</strong>--}%
                                                                    <strong><g:message code="required.error.message" /></strong>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-6 pull-right">
                                                        <label>Select item image : </label>
                                                        <div ><input type="file" class="itemImageInput" /></div>
                                                        <button ng-if="itemCroppedImage" class="btn btn-default" style="height: 25px; line-height: 0;" type="button" ng-click="ctrl.deleteImageFile()">Delete Image</button>
                                                        <div class='compLogo'><img src="{{itemCroppedImage}}" width="200px" /></div>
                                                        <br style="clear:both;" />
                                                        <p ng-if='invalidFileSize' style="color:#F51B1B; font-weight:bold; font-size: 13px;">The file is bigger than 1MB.</p>
                                                        <p ng-if='invalidFileType' style="color:#F51B1B; font-weight:bold; font-size: 13px;">This is an invalid file type, Please upload a file in JPEG or PNG formats </p>
                                                    </div>                                                    

                                                    <div class="col-md-6">
                                                        <div ng-if = "!ctrl.inventoryExist"class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('lowestUom')}">
                                                            <label for="lowestUom"><g:message code="form.field.uom.label" /></label>
                                                            <select  id="lowestUom" name="lowestUom" ng-model="ctrl.editItem.lowestUom" class="form-control" ng-change="ctrl.clearEachEdit(ctrl.editItem.lowestUom)">

                                                                <option value="EACH" >EACH</option>
                                                                <option value="CASE">CASE</option>
                                                                <option value="PALLET">PALLET</option>
                                                            </select>


                                                            <div class="my-messages" ng-messages="ctrl.editItemForm.areaId.$error" ng-if="ctrl.showMessagesEdit('areaId')">
                                                                <div class="message-animation" ng-message="required">
                                                                    %{--<strong>This field is required.</strong>--}%
                                                                    <strong><g:message code="required.error.message" /></strong>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div ng-if = "ctrl.inventoryExist"class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('lowestUom')}">
                                                            <label><g:message code="form.field.uom.label" /> : {{ctrl.fixedLowestUom}} </label>

                                                        </div>

                                                    </div>

                                                </div>

                                                <div class="col-md-12">

                                                    <div class="col-md-6">

                                                        <div class="col-md-4">
                                                            <div ng-if = "!ctrl.inventoryExist" class="form-group">
                                                                <label for="isLotTracked"><g:message code="form.field.isLotTrack.label" /></label>
                                                                %{--<input id="isLotTracked" name="isLotTracked" class="form-control"  type="checkbox" ng-model="ctrl.editItem.isLotTracked">--}%

                                                                <div class="checkbox c-checkbox">
                                                                    <label>
                                                                        <input id="isLotTracked" name="isLotTracked" type="checkbox" ng-model="ctrl.editItem.isLotTracked">
                                                                        <span class="fa fa-check"></span>
                                                                    </label>
                                                                </div>

                                                            </div>

                                                            <div ng-if = "ctrl.inventoryExist" class="form-group">
                                                                <label for="isLotTracked"><g:message code="form.field.isLotTrack.label" /></label>
                                                                %{--<input id="isLotTracked" name="isLotTracked" class="form-control"  type="checkbox" ng-model="ctrl.editItem.isLotTracked">--}%

                                                                <div class="checkbox c-checkbox">
                                                                    <label>
                                                                        <input id="isLotTracked" name="isLotTracked" type="checkbox" ng-model="ctrl.editItem.isLotTracked" disabled>
                                                                        <span class="fa fa-check"></span>
                                                                    </label>
                                                                </div>

                                                            </div>




                                                        </div>


                                                        <div class="col-md-4">
                                                            <div ng-if = "!ctrl.inventoryExist" class="form-group">
                                                                <label for="isExpired"><g:message code="form.field.isExp.label" /></label>
                                                                %{--<input id="isExpired" name="isExpired" class="form-control"  type="checkbox" ng-model="ctrl.editItem.isExpired">--}%

                                                                <div class="checkbox c-checkbox">
                                                                    <label>
                                                                        <input id="isExpired" name="isExpired"  type="checkbox" ng-model="ctrl.editItem.isExpired">
                                                                        <span class="fa fa-check"></span>
                                                                    </label>
                                                                </div>

                                                            </div>

                                                            <div ng-if = "ctrl.inventoryExist" class="form-group">
                                                                <label for="isExpired"><g:message code="form.field.isExp.label" /></label>
                                                                %{--<input id="isExpired" name="isExpired" class="form-control"  type="checkbox" ng-model="ctrl.editItem.isExpired">--}%

                                                                <div class="checkbox c-checkbox">
                                                                    <label>
                                                                        <input id="isExpired" name="isExpired"  type="checkbox" ng-model="ctrl.editItem.isExpired" disabled>
                                                                        <span class="fa fa-check"></span>
                                                                    </label>
                                                                </div>

                                                            </div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <div ng-if = "!ctrl.inventoryExist" class="form-group">
                                                                <label for="isCaseTracked"><g:message code="form.field.trackCase.label" /></label>
                                                                %{--<input id="isCaseTracked" name="isCaseTracked" class="form-control"  type="checkbox" ng-model="ctrl.editItem.isCaseTracked">--}%

                                                                <div class="checkbox c-checkbox">
                                                                    <label>
                                                                        <input id="isCaseTracked" name="isCaseTracked"  type="checkbox" ng-model="ctrl.editItem.isCaseTracked" ng-disabled="ctrl.disableIsCaseTracked">
                                                                        <span class="fa fa-check"></span>
                                                                    </label>
                                                                </div>

                                                            </div>

                                                            <div ng-if = "ctrl.inventoryExist" class="form-group">
                                                                <label for="isCaseTracked"><g:message code="form.field.trackCase.label" /></label>
                                                                %{--<input id="isCaseTracked" name="isCaseTracked" class="form-control"  type="checkbox" ng-model="ctrl.editItem.isCaseTracked">--}%

                                                                <div class="checkbox c-checkbox">
                                                                    <label>
                                                                        <input id="isCaseTracked" name="isCaseTracked"  type="checkbox" ng-model="ctrl.editItem.isCaseTracked" disabled>
                                                                        <span class="fa fa-check"></span>
                                                                    </label>
                                                                </div>

                                                            </div>
                                                        </div>

                                                    </div>


                                                    <div class="col-md-6">
                                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('originCode')}">
                                                            <label for="originCode"><g:message code="form.field.originCode.label" /></label>
                                                            <select  id="originCode" name="originCode" ng-model="ctrl.editItem.originCode" class="form-control" >
                                                                <option ng-repeat="originCode in  ctrl.originCode" value="{{originCode.code}}">{{originCode.name}}
                                                                </option>
                                                            </select>

                                                        </div>

                                                    </div>

                                                </div>

                                                <div class="col-md-12">
                                                    <div class="col-md-6">
                                                        <div ng-if= "ctrl.editItem.lowestUom == 'EACH' && !ctrl.inventoryExist" class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('eachesPerCase')}" >
                                                            <label for="eachesPerCase"><g:message code="form.field.eachPerCase.label" /></label>
                                                            <input id="eachesPerCase" name="eachesPerCase" class="form-control" type="number" min="1" 
                                                                   ng-model="ctrl.editItem.eachesPerCase" ng-model-options="{ updateOn : 'default blur' }"
                                                                   ng-focus="ctrl.toggleEditEachesPerCasePrompt(true)" ng-blur="ctrl.toggleEditEachesPerCasePrompt(false)" required />

                                                            <div class="my-messages" ng-messages="ctrl.editItemForm.eachesPerCase.$error" ng-if="ctrl.showMessagesEdit('eachesPerCase')">
                                                                <div class="message-animation" ng-message="required">
                                                                    %{--<strong>This field is required.</strong>--}%
                                                                    <strong><g:message code="required.error.message" /></strong>
                                                                </div>
                                                            </div>
                                                            <div class="my-messages"  ng-messages="ctrl.editItemForm.eachesPerCase.$error"
                                                             ng-if="ctrl.editItemForm.eachesPerCase.$error.min">
                                                                <div class="message-animation" >
                                                                    <strong>The value should be greater than 0(zero).</strong>
                                                                </div>
                                                            </div>


                                                        </div>

                                                        <div ng-if= "ctrl.editItem.lowestUom == 'CASE' && !ctrl.inventoryExist" class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('eachesPerCase')}" >
                                                            <label for="eachesPerCase"><g:message code="form.field.eachPerCase.label" /></label>
                                                            <input id="eachesPerCase" name="eachesPerCase" class="form-control" type="text"
                                                                   ng-model="ctrl.editItem.eachesPerCase" ng-model-options="{ updateOn : 'default blur' }"
                                                                   ng-focus="ctrl.toggleEditEachesPerCasePrompt(true)" ng-blur="ctrl.toggleEditEachesPerCasePrompt(false)" numbers-only disabled />

                                                        </div>                                                        

                                                        <div ng-if= "ctrl.editItem.lowestUom == 'EACH' && ctrl.inventoryExist" class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('eachesPerCase')}">
                                                            <label for="eachesPerCase"><g:message code="form.field.eachPerCase.label" /> : {{ctrl.fixedEachesPerCase}}</label>

                                                        </div>


                                                    </div>

                                                    <div class="col-md-6">
                                                        <div ng-if= "!ctrl.inventoryExist && (ctrl.editItem.lowestUom == 'EACH' || ctrl.editItem.lowestUom == 'CASE')" class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('casesPerPallet')}">
                                                            <label for="casesPerPallet"><g:message code="form.field.casePerPallet.label" /></label>
                                                            <input id="casesPerPallet" name="casesPerPallet" class="form-control" type="number" min="1" 
                                                                   ng-model="ctrl.editItem.casesPerPallet" ng-model-options="{ updateOn : 'default blur' }"
                                                                   ng-focus="ctrl.toggleEditCasesPerPalletPrompt(true)" ng-blur="ctrl.toggleEditCasesPerPalletPrompt(false)" required/>

                                                            <div class="my-messages" ng-messages="ctrl.editItemForm.casesPerPallet.$error" ng-if="ctrl.showMessagesEdit('casesPerPallet')">
                                                                <div class="message-animation" ng-message="required">
                                                                    %{--<strong>This field is required.</strong>--}%
                                                                    <strong><g:message code="required.error.message" /></strong>
                                                                </div>
                                                            </div>
                                                            <div class="my-messages"  ng-messages="ctrl.editItemForm.casesPerPallet.$error"
                                                             ng-if="ctrl.editItemForm.casesPerPallet.$error.min">
                                                                <div class="message-animation" >
                                                                    <strong>The value should be greater than 0(zero).</strong>
                                                                </div>
                                                            </div>

                                                        </div>


                                                        <div ng-if= "ctrl.inventoryExist && (ctrl.editItem.lowestUom == 'EACH' || ctrl.editItem.lowestUom == 'CASE')" class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('casesPerPallet')}">
                                                            <label for="casesPerPallet"><g:message code="form.field.casePerPallet.label" /> : {{ctrl.fixedCasesPerPallet}}</label>



                                                        </div>
                                                    </div>

                                                </div>



                                                <div class="col-md-12">
                                                    <div class="col-md-6">
                                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('upcCode')}">
                                                            <label for="upcCode"><g:message code="form.field.upc.label" /></label>
                                                            <input id="upcCode" name="upcCode" class="form-control" type="text"
                                                                   ng-model="ctrl.editItem.upcCode" ng-model-options="{ updateOn : 'default blur' }"
                                                                   ng-focus="ctrl.toggleEditUpcCodePrompt(true)" ng-blur="ctrl.toggleEditUpcCodePrompt(false)" maxlength="15"/>

                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('eanCode')}">
                                                            <label for="eanCode"><g:message code="form.field.ean.label" /></label>
                                                            <input id="eanCode" name="eanCode" class="form-control" type="text"
                                                                   ng-model="ctrl.editItem.eanCode" ng-model-options="{ updateOn : 'default blur' }"
                                                                   ng-focus="ctrl.toggleEditEanCodePrompt(true)" ng-blur="ctrl.toggleEditEanCodePrompt(false)" maxlength="15"/>

                                                        </div>
                                                    </div>

                                                </div>

                                                <div class="col-md-12">
                                                    <div class="col-md-6">
                                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('itemCategory')}">
                                                            <label for="itemCategory"><g:message code="form.field.itemCategory.label" /></label>
                                                            <select  id="itemCategory" name="itemCategory" ng-model="ctrl.newItemCategory" class="form-control" ng-change = "ctrl.addNewValue()">

                                                                <option ng-repeat="listValue in  ctrl.listValue" value="{{listValue.description}}">{{listValue.description}}
                                                                </option>
                                                                <option value="newItemCategory" >+ Add new item category</option>
                                                            </select>


                                                        </div>

                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('reOrderLevelQty')}">
                                                        <label for="reOrderLevelQty"><g:message code="form.field.reorderLevelQty" /></label>
                                                        <input id="reOrderLevelQty" name="reOrderLevelQty" class="form-control" type="number"
                                                               ng-model="ctrl.editItem.reorderLevelQty" ng-model-options="{ updateOn : 'default blur' }"
                                                               ng-focus="ctrl.toggleEachesPerCasePrompt(true)" ng-blur="ctrl.toggleEachesPerCasePrompt(false);" min="0" />

                                                            <div class="my-messages"  ng-messages="ctrl.editItemForm.reOrderLevelQty.$error"
                                                                 ng-if="ctrl.editItemForm.reOrderLevelQty.$error.min">
                                                                <div class="message-animation" >
                                                                    <strong>The value should be greater than 0(zero).</strong>
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </div>

                                                </div>



                                                <div class="col-md-12">
                                                    <div class="col-md-6">
                                                        <label><g:message code="form.field.storageAttributes.label" /></label>
                                                        <div class="strgTagDiv">
                                                            <div ng-repeat="storageAttributes in ctrl.editItem.storageAttributes" style="padding-right: 5px; display: inline-block;">
                                                               <div class="tagArrowDiv" ng-class ="'tagArrowDivCol'+($index % 5)"></div><div class="tag label label-info attrTags" style="white-space: unset;" ng-class ="'attrTagColour'+($index % 5)">
                                                                      <button type="button" ng-click="ctrl.removeStorageAttributesForEdit(storageAttributes)" class="btnAttrTag"><img src="/foysonis2016/app/img/close-tag-white.png" style="width: 13px;"  ng-class="'tagCloseBtn'+($index % 2)"></button>&nbsp;{{storageAttributes.configValue}}
                                                                </div> 
                                                            </div>
                                                        </div>

                                                        <div class="form-group">
                                                            <select  id="storageAttributes" name="storageAttributes" data-ng-model="ctrl.getStorageAttributes"
                                                                     ng-options="option.optionValue for option in ctrl.storageOptions" ng-change="ctrl.selectStorageAttributesForEdit(ctrl.getStorageAttributes)" class="form-control">
                                                            </select>
                                                        </div>
                                                        <div ng-if = "!ctrl.isStorageAtrributeExist" >Warning : No area matches this storage attributes <span ng-repeat="selectedAttr in ctrl.selectedStorageAttr">{{selectedAttr}}{{$last ? '' : ', '}}</span>.</div>

                                                    </div>
                                                </div>
                                       

                                        <div class="panel-footer">
                                            <div class="pull-left">
                                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation" href="javascript:void(0);">
                                                    <button class="btn btn-default" type="button" ng-click="HideEditForm()"><g:message code="default.button.cancel.label" /></button>
                                                </a>

                                            </div>
                                            <div class="pull-right">
                                                <button class="btn btn-primary" type="submit" ng-disabled="ctrl.disableItemEdit">{{ctrl.itemEditBtnText}}<!-- <g:message code="default.button.update.label" /> --></button>  
                                            </div>
                                            <br style="clear: both;"/>
                                        </div>
                                        </div>
                                    </div>
                                  </div>  
                                </form>

                            </div>
<%-- **************************** End of Edit Item form **************************** --%>
                       <!-- </div>

                        
            </div> -->
            <!-- END panel-->
            <!-- start search form-->
            <div class="panel panel-default">
                <div class="panel-body">
                    <form name="ctrl.searchForm"  ng-submit="ctrl.search()">

                        <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                            <!-- START Wizard Step inputs -->
                            <div>
                                <fieldset>
                                    <legend> <g:message code="default.search.label" /></legend>

                                    <div class="row">

                                        <div class="col-md-5">
                                            <div class="form-group" ng-class="">
                                                <label for="itemId"><g:message code="form.field.item.label" /></label>
                                                <input id="itemId" name="itemId" class="form-control" type="text" value="${itemId}"
                                                       ng-model="ctrl.itemId" ng-blur="ctrl.disableFindButton()"
                                                       placeholder="Item Id" capitalize />
                                            </div>
                                        </div>

                                        <div class="col-md-5">
                                            <div class="form-group" ng-class="">
                                                <label for="itemDescription"><g:message code="form.field.description.label" /></label>
                                                <input id="itemDescription" name="itemDescription" class="form-control" type="text" value="${itemDescription}"
                                                       ng-model="ctrl.itemDescription" ng-blur="ctrl.disableFindButton()"
                                                       placeholder="Item Description" />
                                            </div>
                                        </div>
                                        <div class="col-md-2" style="padding-top: 20px;">
                                            <button type="submit" class="findBtn btn btn-primary">
                                                <g:message code="default.button.searchItem.label" />
                                            </button>
                                        </div>

                                    </div>

                                    <!--start  Additional Search Fields-->

                                    <!-- START row -->
                                    <div style="margin-bottom: 50px; margin-top: 10px;">
                                        <div class="col-md-12">
                                            <a href="#"  ng-click="ctrl.show = !ctrl.show" >
                                                <g:message code="form.field.additionalSearchForItem.label" />
                                            </a>
                                        </div>
                                    </div>
                                    <!-- END row -->

                                    <div class="row" ng-show="ctrl.show" >

                                        <div class="col-md-5">
                                            <div class="form-group" ng-class="">
                                                <label for="optionValue"><g:message code="form.field.storageAttributes.label" /></label>
                                                <div ng-dropdown-multiselect
                                                     options="multiComboData"
                                                     selected-model="ctrl.configValue"
                                                     checkboxes="true"
                                                     extra-settings="multiComboSettings">
                                                </div>
                                            </div>
                                        </div>


                                        <div class="col-md-5">
                                            <div class="form-group" ng-class="">
                                                <label for="itemCategory"><g:message code="form.field.category.label" /></label>
                                                <select  id="itemCategory" name="itemCategory" ng-model="ctrl.itemCategory" class="form-control" ng-change = "ctrl.disableFindButton()">
                                                    <option value="">None</option>
                                                    <option ng-repeat="listValue in  ctrl.listValue" value="{{listValue.optionValue}}" >{{listValue.description}}
                                                    </option>
                                                </select>
                                            </div>
                                        </div>


                                        <div class="col-md-5" style="margin-bottom: 30px; margin-top: 30px;">
                                            <div class="form-group">
                                                <label for="isLotTracked"><g:message code="form.field.lotTra.label" /></label>
                                                <select  id="isLotTracked" name="isLotTracked" ng-model="ctrl.isLotTracked" class="form-control" ng-change = "ctrl.disableFindButton()">
                                                    <option value="">None</option>
                                                    <option value="1" ${isLotTracked ? 'selected' : ''}>Yes</option>
                                                    <option value="0" ${!isLotTracked ? 'selected' : ''}>No</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-md-5" style="margin-bottom: 30px; margin-top: 30px;">
                                            <div class="form-group">
                                                <label for="isExpired"><g:message code="form.field.expired.label" /></label>
                                                <select  id="isExpired" name="isExpired" ng-model="ctrl.isExpired" class="form-control" ng-change = "ctrl.disableFindButton()">
                                                    <option value="">None</option>
                                                    <option value="1" ${isExpired ? 'selected' : ''}>Yes</option>
                                                    <option value="0" ${!isExpired ? 'selected' : ''}>No</option>
                                                </select>
                                            </div>
                                        </div>

                                    <div class="col-md-5" style="margin-bottom: 30px; margin-top: 20px;">
                                        <div class="form-group">
                                            <label for="isCaseTracked">Case Tracked?</label>
                                            <select  id="isCaseTracked" name="isCaseTracked" ng-model="ctrl.isCaseTracked" class="form-control" ng-change = "ctrl.disableFindButton()">
                                                <option value="">None</option>
                                                <option value="1" ${isCaseTracked ? 'selected' : ''}>Yes</option>
                                                <option value="0" ${!isCaseTracked ? 'selected' : ''}>No</option>
                                            </select>
                                        </div>
                                    </div>

                                    </div>
                                    <!-- end Additional search field -->

                                </fieldset>

                                <!-- <div class="pull-right">
                                    <button type="submit" class="btn btn-primary">
                                        <g:message code="default.button.searchItem.label" />
                                    </button>
                                    %{--<button type="submit" class="btn btn-primary" ng-disabled="ctrl.disabledFind">--}%
                                        %{--<g:message code="default.button.searchItem.label" />--}%
                                    %{--</button>--}%
                                </div> -->

                            </div>
                            <!-- END Wizard Step inputs -->
                        </div>
                    </form>
                </div>
            </div>

            <!-- end search form-->

            <!-- start Item Grid-->
            <p>
            <div id="grid1" ui-grid="gridItem" ui-grid-exporter  ui-grid-pagination ui-grid-pinning ui-grid-expandable ui-grid-resize-columns class="grid" >
                <div class="noItemMessage" ng-if="gridItem.data.length == 0"><g:message code="item.grid.noData.message" /></div>
            </div>
             </p>
            <!-- end OF Item Grid-->
        </div>

<!-- Modal for Adding new item category-->
<div id="AddNewItemCategory" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Add new item category</h4>
            </div>          
            <div class="modal-body">          
                <label>Item Category :</label>         
                <input id="addItemCategory" name="addItemCategory" class="form-control" type="text" ng-model="ctrl.addItemCategory" placeholder = "Enter item Category"/>

            </div>
            <div class="modal-footer">
                <button type="button"  id = "itemCategorycancelSave" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "itemCategorySave" class="btn btn-primary"><g:message code="default.button.add.label" /></button>
            </div>
        </div>
    </div>
</div>


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



        <!-- import CSV dialog model -->
        <div id="importItem" class="modal fade" role="dialog">
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

                        <p>Dowload a sample item CSV file <g:link controller="item" action="downloadItemCsvFile">Here.</g:link></p>
                        <br style="clear: both;">
                        <input type="file"  id="csvImport" />
                        <span ng-show="loadAnimPickListSearch"><img src="${request.contextPath}/foysonis2016/app/img/loading.gif"/></span>
                        <br style="clear: both;"/>

                        <div id="grid1" ui-grid="gridOptions" ui-grid-exporter ui-grid-resize-columns  class="csvGrid"></div>
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

<div id="cropImageModel" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Crop Image</h4>
                </div>
                <div class="modal-body">
                    <div class="cropArea">
                        <img-crop style="width:500px;" image="itemImage" area-type="square" result-image-size="400" result-image="itemCroppedImage" ></img-crop>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>


        <div id="itemDeleteWarning" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Warning</h4>
                    </div>
                    <div class="modal-body">
                        <p>{{ctrl.deleteItemForMessage}} cannot be deleted.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Ok</button>
                    </div>
                </div>
            </div>
        </div>



        <div id="itemDelete" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Confirmation</h4>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure want to delete {{ctrl.deleteItemForMessage}} ?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                        <button type="button" id = "deleteItemButton" class="btn btn-primary"><g:message code="default.button.delete.label" /></button>
                    </div>
                </div>
            </div>
        </div>

        <div id="itemCopy" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Copy Item</h4>
                    </div>
                    <div class="modal-body">
                        <h5>Item Id </h5>
                        <input id="itemId" name="itemId" placeholder="Item id" class="form-control"  type="text" maxlength="140" capitalize char-validator v gf required
                                                           ng-model="ctrl.copyItemData.itemId" ng-model-options="{ updateOn : 'blur' }"
                                                           ng-focus="ctrl.toggleItemIdPrompt(true)" ng-blur="ctrl.toggleItemIdPrompt(false)" /> <br/>
                         <h5>Description </h5>
                        <input id="itemDescription" placeholder="Item Description" name="itemDescription" class="form-control" type="text" maxlength="140" required
                                                           ng-model="ctrl.copyItemData.itemDescription" ng-model-options="{ updateOn : 'blur' }"
                                                           ng-focus="ctrl.toggleItemDescriptionPrompt(true)" ng-blur="ctrl.toggleItemDescriptionPrompt(false)" />
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                        <button type="button" id = "copyItemBtn" class="btn btn-primary">Copy</button>
                    </div>
                </div>
            </div>
        </div>




<div id="dvPreventAddItem" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p>{{ctrl.errorMsgForItemSave}}</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>


    </div><!-- End of ItemCtrl -->


<!-- bootstrap modal confirmation dialog-->

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
                <p>You can not delete this area.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
    <asset:javascript src="datagrid/admin-item.js"/>

    <script type="text/javascript">
        var dvAdminItem = document.getElementById('dvAdminItem');
        angular.element(document).ready(function() {
            angular.bootstrap(dvAdminItem, ['adminItem']);
        });
    </script>

<asset:javascript src="datagrid/itemImportService.js"/>
<asset:javascript src="ng-img-crop.js"/>
<asset:stylesheet src="ng-img-crop.css"/>

</body>
</html>
