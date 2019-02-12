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

    %{--date picker--}%
    <asset:javascript src="angular-datepicker.js"/>
    <asset:stylesheet src="angular-datepicker.css"/>


    <style>

    .grid {
        height: 420px;
    }

    .grid-align {
        text-align: center;
    }

    .grid-action-align {
        padding-left: 50px;
    }

    .dropdown-menu {
        min-width: 90px;
    }

    .noDataMessage {
        position: absolute;
        top: 30%;
        opacity: 0.4;
        font-size: 40px;
        width: 100%;
        text-align: center;
        z-index: auto;
    }

    .textInfo {

        background-color: #F3F3F2;
    }

    .textWarning {
        background-color: #FFFF99;
        color: #FF5C33;
    }

    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    </style>

</head>

<body>

<div ng-cloak class="row" id="dvAdminInventory" ng-controller="InventoryCtrl as ctrl">

    <div class="col-lg-12">
        <!-- START panel-->
        <div class="panel panel-default">
            <div class="panel-body" style="overflow:hidden;">

                <%-- **************************** create Inventory form **************************** --%>
                <div style="display: inline;"><em class="fa  fa-fw mr-sm"><img style="width: 40px;"
                                                                               src="/foysonis2016/app/img/inventory_header.svg">
                </em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">Inventory Adjustment</span>
                </div>

                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" data-toggle="play-animation"
                   href="javascript:void(0);">

                    <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide()">
                        <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                        <g:message code="default.button.createInventory.label"/>
                    </button>
                </a>
                <br style="clear: both;"/>
                <br style="clear: both;"/>


                <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showSubmittedPrompt">
                    <g:message code="inventory.create.message"/>
                </div>

                <div ng-show="IsVisible" class="row">

                    <form name="ctrl.createInventoryForm" ng-submit="ctrl.createInventory()" novalidate>

                        <div class="panel panel-default" id="panel-anim-fadeInDown">
                            <div class="panel-heading">
                                <div class="panel-title"><g:message code="default.inventory.add.label"/></div>
                            </div>

                            <div class="panel-body">

                                <div class="col-md-5">

                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('itemId')}">
                                        <label><g:message code="form.field.item.label"/></label>

                                        <div auto-complete source="sourceItems"
                                             xxxx-list-formatter="customListFormatter"
                                             value-changed="ctrl.validateItemId(value.locationId, $index)"
                                             style="z-index: 1000000000;">
                                            <input ng-model="ctrl.newInventory.itemId" id="itemId" name='itemId'
                                                   ng-model-options="{ updateOn : 'default blur' }"
                                                   placeholder="Item Id" class="form-control" tabindex="1" required/>
                                        </div>

                                        <div class="my-messages" ng-messages="ctrl.createInventoryForm.itemId.$error"
                                             ng-if="ctrl.showMessages('itemId')">
                                            <div class="message-animation" ng-message="required">
                                                <strong>Please Select an Item.</strong>
                                            </div>
                                        </div>

                                    </div>

                                </div>

                                <div class="col-md-5">

                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('locationId')}">
                                        <label><g:message code="form.field.location.label"/></label>


                                        <div auto-complete source="loadUnblockedLocationAutoComplete"
                                             xxxx-list-formatter="customListFormatter"
                                             value-changed="ctrl.callSelectedLocation(value)" min-chars='0'
                                             style="z-index: 10000000000;">
                                            <input ng-model="ctrl.newInventory.locationId" id="locationId"
                                                   name="locationId" placeholder="Location Id" class="form-control"
                                                   ng-blur='ctrl.clearAutoCompText()' tabindex="2" required>
                                        </div>


                                        <div class="my-messages"
                                             ng-messages="ctrl.createInventoryForm.locationId.$error"
                                             ng-if="ctrl.showMessages('locationId')">
                                            <div class="message-animation" ng-message="required">
                                                <strong>Please Select a Location.</strong>
                                            </div>
                                        </div>

                                    </div>

                                </div>

                                <div class="col-md-5">

                                    <div class="form-group" ng-if="!ctrl.addInventoryCaseIdDisabled"
                                         ng-class="{'has-error':ctrl.hasErrorClass('caseTrackedPallet')}">
                                        <label><g:message code="form.field.pallet.label"/></label>

                                        <div class="controls">
                                            <input ng-model="ctrl.newInventory.palletId"
                                                   ng-blur="ctrl.validatePalletIdForItemAndLocation(ctrl.newInventory.palletId)"
                                                   ng-focus="getPalletsByLocationAndItem()" name="caseTrackedPallet"
                                                   placeholder="Pallet Id" class="form-control"
                                                   list="autoCompletePallet" autocomplete="off" tabindex="3"
                                                   ng-disabled="ctrl.binLocationSelected" capitalize>
                                        </div>
                                        <datalist id="autoCompletePallet" ng-if="loadPallets.length > 0">
                                            <option ng-repeat="pallets in loadPallets" value="{{pallets.lpn}}">
                                        </datalist>

                                        <div class="my-messages"
                                             ng-messages="ctrl.createInventoryForm.caseTrackedPallet.$error"
                                             ng-if="ctrl.createInventoryForm.$error.palletIdExistForLocationAndItem">
                                            <div class="message-animation">
                                                <strong>This Pallet ID exists already with another item and location.</strong>
                                            </div>
                                        </div>

                                        <div class="my-messages"
                                             ng-messages="ctrl.createInventoryForm.caseUntrackedPallet.$error"
                                             ng-if="ctrl.createInventoryForm.$error.palletIdExist">
                                            <div class="message-animation">
                                                <strong>This Pallet ID exists already.</strong>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="form-group" ng-if="ctrl.addInventoryCaseIdDisabled"
                                         ng-class="{'has-error':ctrl.hasErrorClass('caseUntrackedPallet')}">
                                        <label><g:message code="form.field.pallet.label"/></label>

                                        <div class="controls">
                                            <input ng-model="ctrl.newInventory.palletId" name="caseUntrackedPallet"
                                                   id="caseUntrackedPallet" placeholder="Pallet Id"
                                                   ng-blur="ctrl.validatePalletIdExist(ctrl.newInventory.palletId)"
                                                   class="form-control" tabindex="5"
                                                   ng-disabled="ctrl.binLocationSelected"
                                                   ng-required="ctrl.newInventory.handlingUom == 'PALLET'" capitalize>
                                        </div>

                                        <div class="my-messages"
                                             ng-messages="ctrl.createInventoryForm.caseUntrackedPallet.$error"
                                             ng-if="ctrl.createInventoryForm.$error.palletIdExist">
                                            <div class="message-animation">
                                                <strong>This Pallet ID exists already.</strong>
                                            </div>
                                        </div>

                                        <div class="my-messages"
                                             ng-messages="ctrl.createInventoryForm.caseUntrackedPallet.$error"
                                             ng-if="ctrl.showMessages('caseUntrackedPallet')">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message"/></strong>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('handlingUom')}">
                                        <label for="handlingUom"><g:message code="form.field.unitOf.label"/></label>
                                        <select name="handlingUom" id="handlingUom"
                                                ng-model="ctrl.newInventory.handlingUom" class="form-control"
                                                ng-change="ctrl.selectCase()" ng-disabled="ctrl.disableHandlingUom"
                                                tabindex="6" required>
                                            <option ng-repeat="option in data.availableOptions"
                                                    ng-value="option.id">{{option.name}}</option>
                                        </select>

                                        <div class="my-messages"
                                             ng-messages="ctrl.createInventoryForm.handlingUom.$error"
                                             ng-if="ctrl.showMessages('handlingUom')">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message"/></strong>
                                            </div>
                                        </div>
                                    </div>


                                    <div class="form-group"
                                         ng-class="{'has-error':ctrl.hasErrorClass('inventoryStatus')}"
                                         style="margin-bottom: 0px; margin-top: 15px;">
                                        <label for="inventoryStatus"><g:message
                                                code="form.field.inventoryStatus.label"/></label>
                                        <select id="inventoryStatus" name="inventoryStatus"
                                                ng-model="ctrl.newInventory.inventoryStatus" class="form-control"
                                                tabindex="9" required>
                                            <option ng-repeat="option in ctrl.inventoryStatusOptions"
                                                    value="{{option.optionValue}}">{{option.description}}</option>
                                        </select>

                                        <div class="my-messages"
                                             ng-messages="ctrl.createInventoryForm.inventoryStatus.$error"
                                             ng-if="ctrl.showMessages('inventoryStatus')">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message"/></strong>
                                            </div>
                                        </div>
                                    </div>


                                    <div ng-if="!ctrl.addInventoryExpireDateDisabled" class="form-group"
                                         style="margin-bottom: 10px; margin-top: 15px;">
                                        <label for="expirationDate"><g:message code="form.field.expDate.label"/></label>

                                        <div class="controls" date-format="yyyy-MM-dd"
                                             ng-class="{'has-error':ctrl.hasErrorClass('expirationDate')}">
                                            %{--<input type="date" id="expirationDate" name="expirationDate" class="form-control" placeholder="Expiration Date" ng-model="ctrl.newInventory.expirationDate" />--}%


                                            <p class="input-group">
                                                <input type="text" name="expirationDate" class="form-control"
                                                       uib-datepicker-popup="{{format}}"
                                                       ng-model="ctrl.newInventory.expirationDate"
                                                       is-open="popupExpirationDate.opened"
                                                       datepicker-options="dateOptions" close-text="Close"
                                                       alt-input-formats="altInputFormats" tabindex="11" required/>
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-default"
                                                            ng-click="openExpirationDate()">
                                                        <i class="glyphicon glyphicon-calendar"></i></button>
                                                </span>
                                            </p>

                                            <div class="my-messages"
                                                 ng-messages="ctrl.createInventoryForm.expirationDate.$error"
                                                 ng-if="ctrl.showMessages('expirationDate')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message"/></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>


                                    <div ng-if="ctrl.addInventoryExpireDateDisabled" class="form-group"
                                         style="margin-bottom: 0px; margin-top: 15px;">
                                        <label for="expirationDate"><g:message code="form.field.expDate.label"/></label>
                                        <input class="form-control" type="text" value="This item doesn't expire."
                                               readonly/>
                                    </div>

                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('reasonCode')}"
                                         style="margin-bottom: 15px; margin-top: 15px;">
                                        <label for="reasonCode"><g:message code="form.field.reason.label"/></label>
                                        <select id="reasonCode" name="reasonCode"
                                                ng-model="ctrl.newInventory.reasonCode" class="form-control"
                                                ng-change="ctrl.addNewValue()" tabindex="12" required>
                                            <option ng-repeat="listValue in  ctrl.listValue"
                                                    value="{{listValue.description}}">{{listValue.description}}
                                            </option>
                                            <option value="newItemCategory">+ Add new Reason</option>
                                        </select>

                                        <div class="my-messages"
                                             ng-messages="ctrl.createInventoryForm.reasonCode.$error"
                                             ng-if="ctrl.showMessages('reasonCode')">
                                            <div class="message-animation" ng-message="required">
                                                <strong><g:message code="required.error.message"/></strong>
                                            </div>
                                        </div>

                                    </div>

                                </div>

                                <div class="col-md-5">
                                    <!-- <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('locationId')}">
                                        <label><g:message code="form.field.location.label"/></label>

                                        %{--<div auto-complete  source="sourceLocation" min-char="3"  xxxx-list-formatter="customListFormatter"--}%
                                    %{--value-changed="ctrl.selectLocation(value.locationId)" style="z-index: 1000;">--}%
                                    %{--<input ng-model="ctrl.newInventory.locationId" placeholder="Location Id" class="form-control" >--}%
                                    %{--</div>--}%

                                            <div auto-complete  source="loadLocationAutoComplete"  xxxx-list-formatter="customListFormatter"
                                                 value-changed="callback(value)" min-chars='0' style="z-index: 10000000000;">
                                                <input ng-model="ctrl.newInventory.locationId" id="locationId" name="locationId" placeholder="Location Id" class="form-control" ng-blur='ctrl.clearAutoCompText()' tabindex="2" required>
                                            </div>

                                        %{--<input ng-model="ctrl.newInventory.locationId" placeholder="Location Id" class="form-control" ng-blur="ctrl.selectLocation()" ng-model-options="{ updateOn : 'default blur' }" >--}%

                                            <div class="my-messages" ng-messages="ctrl.createInventoryForm.locationId.$error" ng-if="ctrl.showMessages('locationId')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong>Please Select a Location.</strong>
                                                </div>
                                            </div>

                                    </div> -->


                                    <div ng-if="!ctrl.addInventoryCaseIdDisabled && !ctrl.binLocationSelected"
                                         class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('caseId')}">
                                        <label for="caseId"><g:message code="form.field.case.label"/></label>

                                        <div class="controls">
                                            <input id="caseId" name="caseId" class="form-control" type="text"
                                                   ng-model="ctrl.newInventory.caseId"
                                                   ng-model-options="{ updateOn : 'default blur' }"
                                                   ng-focus="ctrl.toggleQuantityPrompt(true)"
                                                   ng-blur="ctrl.validateCaseId(ctrl.newInventory.caseId); ctrl.checkSimilarPalletAndCaseIds()"
                                                   placeholder="Case Id" tabindex="4"
                                                   ng-required="ctrl.validateCaseRequired"
                                                   ng-disabled="ctrl.binLocationSelected" capitalize/>
                                        </div>

                                        <div class="my-messages" ng-messages="ctrl.createInventoryForm.caseId.$error"
                                             ng-if="ctrl.showMessages('caseId')">
                                            <div class="message-animation" ng-message="required">
                                                <strong>Please Select Case.</strong>
                                            </div>
                                        </div>

                                        <div class="my-messages" ng-messages="ctrl.createInventoryForm.caseId.$error"
                                             ng-if="ctrl.createInventoryForm.$error.caseIdExist">
                                            <div class="message-animation">
                                                <strong>This Case ID exists already.</strong>
                                            </div>
                                        </div>

                                        <div class="my-messages" ng-messages="ctrl.createInventoryForm.caseId.$error"
                                             ng-if="ctrl.createInventoryForm.$error.checkSimilarCaseAndPallet">
                                            <div class="message-animation">
                                                <strong>Similar IDs for case and pallet cannot be used.</strong>
                                            </div>
                                        </div>
                                    </div>


                                    <div ng-if="ctrl.addInventoryCaseIdDisabled && !ctrl.binLocationSelected"" class="form-group">
                                    <label for="caseId"><g:message code="form.field.case.label"/></label>
                                    <input class="form-control" type="text" value="This Item doesn't track case."
                                           readonly/>
                                </div>


                                <div ng-if="(ctrl.addInventoryCaseIdDisabled || !ctrl.addInventoryCaseIdDisabled) && ctrl.binLocationSelected"
                                     class="form-group">
                                    <label for="caseId"><g:message code="form.field.case.label"/></label>
                                    <input class="form-control" type="text" placeholder="Case Id" disabled/>
                                </div>

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('quantity')}">
                                    <label for="quantity"><g:message code="form.field.qty.label"/></label>
                                    <input id="quantity" name="quantity" class="form-control" type="text"
                                           ng-model="ctrl.newInventory.quantity"
                                           ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleQuantityPrompt(true)"
                                           ng-blur="ctrl.toggleQuantityPrompt(false)" placeholder="Quantity"
                                           maxlength="15" ng-disabled="ctrl.addInventoryQtyDisabled" tabindex="6"
                                           numbers-only required/>

                                    <div class="my-messages" ng-messages="ctrl.createInventoryForm.quantity.$error"
                                         ng-if="ctrl.showMessages('quantity')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message"/></strong>
                                        </div>
                                    </div>
                                </div>

                                <div ng-if="!ctrl.addInventoryLotCodeDisabled" class="form-group"
                                     ng-class="{'has-error':ctrl.hasErrorClass('lotCode')}">
                                    <label for="lotCode"><g:message code="form.field.lotCode.label"/></label>
                                    <input id="lotCode" name="lotCode" class="form-control" type="text"
                                           ng-model="ctrl.newInventory.lotCode"
                                           ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleLotCodePrompt(true)"
                                           ng-blur="ctrl.toggleLotCodePrompt(false)" placeholder="Lot Code"
                                           maxlength="15" tabindex="8" required/>

                                    <div class="my-messages" ng-messages="ctrl.createInventoryForm.lotCode.$error"
                                         ng-if="ctrl.showMessages('lotCode')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message"/></strong>
                                        </div>
                                    </div>
                                </div>

                                <div ng-if="ctrl.addInventoryLotCodeDisabled" class="">
                                    <label for="lotCode"><g:message code="form.field.lotCode.label"/></label>
                                    <input class="form-control" type="text" value="This Item doesn't track Lot Code."
                                           readonly/>
                                </div>


                                <div class="form-group" ng-if="ctrl.newItemNotesVisible"
                                     style="margin-bottom: 0px; margin-top: 15px;">
                                    <label><g:message code="form.field.notes.label"/></label>
                                    <textarea rows="4" cols="6" class="form-control"
                                              ng-model="ctrl.newInventory.itemNote"
                                              placeholder="Enter Notes Here........." tabindex="10"></textarea>
                                </div>

                            </div>
                        </div>

                        <div class="panel-footer">
                            <div class="pull-left">
                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown"
                                   data-toggle="play-animation" href="javascript:void(0);">
                                    <button class="btn btn-default" type="button" ng-click="ShowHide()"><g:message
                                            code="default.button.cancel.label"/></button>
                                </a>

                            </div>

                            <div class="pull-right" style="margin-left:20px; margin-right:15px;">
                                <button class="btn btn-primary" type="submit"
                                        ng-disabled="ctrl.disableInventorySave"><!-- <g:message
                                        code="default.button.save.label"/> -->{{ctrl.inventorySaveBtnText}}</button>
                            </div>


                            <div class="pull-right" ng-show="ctrl.addInventoryCaseIdSubmit">
                                <button class="btn btn-primary" type="button" ng-click='ctrl.caseSubmitForm()'
                                        ng-disabled="ctrl.disableInventorySave || ctrl.binLocationSelected"><!-- <g:message
                                        code="default.button.saveAdd.label"/> -->{{ctrl.caseInventorySaveBtnText}}</button>
                            </div>


                            <br style="clear: both;"/>
                        </div>

                </div>

            </form>

            </div>
            <%-- **************************** End of create Inventory form **************************** --%>



            <%-- **************************** Edit inventory form **************************** --%>
            <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showAdjustedPrompt">
                <g:message code="inventory.edit.message"/>
            </div>

            <div ng-show="ctrl.editInventoryState" class="row">

                <form name="ctrl.editInventoryForm" ng-submit="ctrl.editInventoryFunction()" novalidate>

                    <div class="panel panel-default" id="panel-anim-fadeInDown">
                        <div class="panel-heading">
                            <div class="panel-title"><g:message code="default.inventory.edit.label"/></div>
                        </div>

                        <div class="panel-body">
                            <div class="col-md-6">

                                <div class="form-group">
                                    <label><g:message code="form.field.item.label"/></label>
                                    <input ng-model="ctrl.editInventory.itemId" placeholder="Item Id"
                                           class="form-control" disabled>

                                </div>


                                <div class="form-group">
                                    <label><g:message code="form.field.pallet.label"/></label>
                                    <input ng-model="ctrl.editInventory.palletId" placeholder="Pallet Id"
                                           class="form-control" disabled>
                                </div>


                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('quantity')}">
                                    <label for="quantity"><g:message code="form.field.qty.label"/></label>
                                    <input id="quantity" name="quantity" class="form-control" type="text"
                                           ng-model="ctrl.editInventory.quantity"
                                           ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleEditQuantityPrompt(true)"
                                           ng-blur="ctrl.toggleEditQuantityPrompt(false)" maxlength="5"
                                           ng-disabled="ctrl.editInventoryQtyDisabled" required numbers-only
                                           quantity-zero-validation/>

                                    <div class="my-messages" ng-messages="ctrl.editInventoryForm.quantity.$error"
                                         ng-if="ctrl.showMessagesEdit('quantity')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message"/></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages" ng-messages="ctrl.editInventoryForm.quantity.$error"
                                         ng-if="ctrl.editInventoryForm.$error.zeroValidation">
                                        <div class="message-animation">
                                            <strong>The Value '0' cannot be added.</strong>
                                        </div>
                                    </div>

                                </div>


                                <label for="lotCode"><g:message code="form.field.lotCode.label"/></label>

                                <div ng-if="ctrl.lotCodeTracked" class="form-group"
                                     ng-class="{'has-error':ctrl.hasErrorClassEdit('lotCode')}">
                                    <input id="lotCode" name="lotCode" class="form-control" type="text"
                                           ng-model="ctrl.editInventory.lotCode"
                                           ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleEditLotCodePrompt(true)"
                                           ng-blur="ctrl.toggleEditLotCodePrompt(false)" maxlength="30" required/>

                                    <div class="my-messages" ng-messages="ctrl.editInventoryForm.lotCode.$error"
                                         ng-if="ctrl.showMessagesEdit('lotCode')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message"/></strong>
                                        </div>
                                    </div>

                                </div>


                                <div ng-if="!ctrl.lotCodeTracked" class="form-group"
                                     ng-class="{'has-error':ctrl.hasErrorClassEdit('lotCode')}">
                                    <input id="adjustmentDescription" name="adjustmentDescription" class="form-control"
                                           type="text" value="This Item doesn't track Lot Code." disabled/>

                                </div>


                                <div class="form-group" ng-show="ctrl.editItemNotesVisible"
                                     style="margin-bottom: 0px; margin-top: 15px;">
                                    <label><g:message code="form.field.notes.label"/></label>
                                    <textarea rows="4" cols="6" class="form-control"
                                              ng-model="ctrl.editInventory.itemNote"
                                              placeholder="Enter Notes Here........."></textarea>
                                </div>

                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('reasonCode')}">
                                    <label for="reasonCode"><g:message code="form.field.reason.label"/></label>
                                    <select id="reasonCode" name="reasonCode" ng-model="ctrl.editInventory.reasonCode"
                                            class="form-control" ng-change="ctrl.addNewValueEdit()">
                                        <option ng-repeat="listValue in  ctrl.listValue"
                                                value="{{listValue.description}}">{{listValue.description}}
                                        </option>
                                        <option value="newReasonCode">+ Add new Reason</option>
                                    </select>

                                </div>

                                <div ng-show="ctrl.editInventory.reasonCode == ''" class="textWarning">
                                    <label>Please select a reason.</label>

                                </div><br/>

                            </div>

                            <div class="col-md-6">

                                <div class="form-group">
                                    <label><g:message code="form.field.location.label"/></label>
                                    <input ng-model="ctrl.editInventory.locationId" placeholder="Location Id"
                                           class="form-control" disabled>
                                </div>

                                <div ng-show="ctrl.caseTracked" class="form-group">
                                    <label><g:message code="form.field.case.label"/></label>
                                    <input ng-model="ctrl.editInventory.caseId" placeholder="Case Id"
                                           class="form-control" disabled>
                                </div>

                                <div class="form-group">
                                    <label for="handlingUom"><g:message code="form.field.unitOf.label"/></label>
                                    <select id="handlingUom" name="handlingUom"
                                            ng-model="ctrl.editInventory.handlingUom" class="form-control" disabled>

                                        <option value="EACH">EACH</option>
                                        <option value="CASE">CASE</option>
                                        <option value="PALLET">PALLET</option>
                                    </select>

                                </div>


                                <div class="form-group"
                                     ng-class="{'has-error':ctrl.hasErrorClassEdit('inventoryStatus')}">
                                    <label for="inventoryStatus"><g:message
                                            code="form.field.inventoryStatus.label"/></label>
                                    <select id="inventoryStatus" name="inventoryStatus"
                                            ng-model="ctrl.editInventory.inventoryStatus" class="form-control">

                                        <option ng-repeat="option in ctrl.inventoryStatusOptions"
                                                value="{{option.optionValue}}">{{option.description}}</option>
                                    </select>
                                </div>

                                <div ng-show="ctrl.editInventory.inventoryStatus == ''" class="textWarning">
                                    <label>Please select an inventory Status.</label>

                                </div>



                                <label for="expirationDate"><g:message code="form.field.expDate.label"/></label>

                                <div ng-if="ctrl.isExpired" class="form-group"
                                     ng-class="{'has-error':ctrl.hasErrorClassEdit('expirationDate')}">
                                    <input id="expirationDate" name="expirationDate" class="form-control" type="date"
                                           ng-model="ctrl.editInventory.expirationDate"
                                           ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleEditExpirationDatePrompt(true)"
                                           ng-blur="ctrl.toggleEditExpirationDatePrompt(false)" required/>


                                    <div class="my-messages" ng-messages="ctrl.editInventoryForm.expirationDate.$error"
                                         ng-if="ctrl.showMessagesEdit('expirationDate')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message"/></strong>
                                        </div>
                                    </div>

                                </div>


                                <div ng-if="!ctrl.isExpired" class="form-group"
                                     ng-class="{'has-error':ctrl.hasErrorClassEdit('expirationDate')}">
                                    <input id="adjustmentDescription" name="adjustmentDescription" class="form-control"
                                           type="text" value="This item doesn't expire." disabled/>
                                </div>


                                <div class="form-group"
                                     ng-class="{'has-error':ctrl.hasErrorClassEdit('adjustmentDescription')}">
                                    <label for="adjustmentDescription"><g:message
                                            code="form.field.adjustDesc.label"/></label>
                                    <input id="adjustmentDescription" name="adjustmentDescription" class="form-control"
                                           type="text"
                                           ng-model="ctrl.editInventory.adjustmentDescription"
                                           ng-model-options="{ updateOn : 'default blur' }"
                                           ng-focus="ctrl.toggleEditAdjustmentDescriptionPrompt(true)"
                                           ng-blur="ctrl.toggleEditAdjustmentDescriptionPrompt(false)" maxlength="100"/>

                                </div>

                            </div>
                        </div>

                        <div class="panel-footer">
                            <div class="pull-left">
                                <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown"
                                   data-toggle="play-animation" href="javascript:void(0);">
                                    <button class="btn btn-default" type="button" ng-click="HideEditForm()"><g:message
                                            code="default.button.cancel.label"/></button>
                                </a>

                            </div>

                            <div class="pull-right">
                                <button class="btn btn-primary" type="submit"
                                        ng-disabled="ctrl.disableInventoryEdit"><!-- <g:message
                                        code="default.button.update.label"/> -->{{ctrl.inventoryUpdateBtnText}}</button>
                            </div>
                            <br style="clear: both;"/>
                        </div>

                    </div>
                </form>

            </div>

            <!-- Bootstrap model for deleting a inventory -->
            <div id="DeleteInventoryModal" class="modal fade" role="dialog">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">Confirmation</h4>
                        </div>

                        <div class="modal-body">
                            <p>Are you sure want to delete this Inventory?</p>

                            <div class="form-group">
                                <label for="reasonDelete">Reason</label>
                                <select id="reasonDelete" name="reasonDelete" ng-model="ctrl.reasonDelete"
                                        class="form-control">
                                    <option value="noOption">Please select a reason.</option>
                                    <option ng-repeat="listValue in  ctrl.listValue"
                                            value="{{listValue.description}}">{{listValue.description}}
                                    </option>
                                </select>

                            </div>

                        </div>

                        <div class="modal-footer">
                            <button type="button" id="cancelDelete" class="btn btn-default"
                                    data-dismiss="modal"><g:message code="default.button.cancel.label"/></button>
                            <button type="button" id="deleteInventoryButton" class="btn btn-primary"
                                    ng-disabled="ctrl.reasonDelete == 'noOption'||ctrl.disableInventoryDelete"><!-- <g:message
                                    code="default.button.delete.label"/> -->{{ctrl.inventoryDeleteBtnText}}</button>
                        </div>
                    </div>
                </div>
            </div>

            <%-- **************************** End of Edit Inventory form **************************** --%>

            <%-- **************************** Start of Find Inventory **************************** --%>

            <div class="panel panel-default">
                <div class="panel-body">
                    <form name="ctrl.inventorySearchForm" ng-submit="ctrl.inventorySearch()">
                        <div data-toggle="wizard" class="form-wizard wizard-horizontal">

                            <!-- START Wizard Step inputs -->
                            <div>
                                <fieldset>
                                    <legend><g:message code="default.search.label"/></legend>
                                    <!-- START row -->
                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label><g:message code="form.field.area.label"/></label>

                                                <div class="controls">
                                                    <input type="text" name="area" placeholder="Area Id"
                                                           class="form-control" ng-model="ctrl.findInventory.area"
                                                           capitalize>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label><g:message code="form.field.location.label"/></label>

                                                <div class="controls">

                                                    <div auto-complete source="loadLocationAutoComplete"
                                                         xxxx-list-formatter="customListFormatter"
                                                         value-changed="callback(value)" min-chars='3'
                                                         style="z-index: 1000;">
                                                        <input ng-model="ctrl.findInventory.location"
                                                               placeholder="Location Id or Barcode" class="form-control"
                                                               ng-blur='ctrl.clearAutoCompText()'>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label><g:message code="form.field.lpn.label"/></label>

                                                <div class="controls">
                                                    <input type="text" name="lpn" placeholder="Pallet or Case Id"
                                                           class="form-control" ng-model="ctrl.findInventory.lpn"
                                                           capitalize>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label><g:message code="form.field.item.label"/></label>

                                                <div class="controls">
                                                    <input type="text" name="item"
                                                           placeholder="Item Id or Description or UPC code"
                                                           class="form-control" ng-model="ctrl.findInventory.item"
                                                           capitalize>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="checkbox c-checkbox">
                                                <label for="selectedSummaryPickable">
                                                    <input id="selectedSummaryPickable" name="selectedSummaryPickable"
                                                           type="checkbox" ng-model="ctrl.isShowInventorySumGrid"
                                                           ng-change="ctrl.switchToInventorySummary()"/>
                                                    <span class="fa fa-check"></span>&nbsp;View Summary
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- END row -->

                                    <!-- START Additional Search row -->
                                    <div class="row" ng-show="ctrl.displayAdditionalSearch">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label><g:message code="form.field.expDate.label"/></label>
                                                <label ng-show="ctrl.displayExpirationDateRange">: From</label>

                                                <div class="controls">
                                                    <input type="date" id="fromExpirationDate" name="fromExpirationDate"
                                                           class="form-control"
                                                           ng-model="ctrl.findInventory.fromExpirationDate"/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- END Additional Search row -->

                                </fieldset>

                                <div class="pull-right">
                                    <button class="btn btn-primary findBtn" type="submit">
                                        <g:message code="default.button.searchInventory.label"/>
                                    </button>
                                </div>

                            </div>
                            <!-- END Wizard Step inputs -->
                        </div>
                    </form>
                </div>
            </div>
            <br style="clear: both;"/>


            <!-- Start Inventory Grid-->
            <div ng-if="!ctrl.isShowInventorySumGrid" id="grid1" ui-grid="gridItem" ui-grid-exporter ui-grid-pagination
                 ui-grid-pinning ui-grid-resize-columns class="grid">
                <div class="noDataMessage" ng-if="gridItem.data.length == 0"><g:message
                        code="item.grid.noData.message"/></div>
            </div>
            <!-- END OF Inventory Grid-->
            <!-- Inventory summary Grid-->
            <div ng-if="ctrl.isShowInventorySumGrid" id="grid1" ui-grid="consolidatedInventory" ui-grid-exporter
                 ui-grid-pagination ui-grid-pinning ui-grid-resize-columns class="grid">
                <div class="noDataMessage" ng-if="consolidatedInventory.data.length == 0"><g:message
                        code="item.grid.noData.message"/></div>
            </div>
            <!-- END OF Inventory summary Grid-->
            <%-- **************************** End of Find Inventory **************************** --%>

        </div>

    </div>
    <!-- END panel-->

</div>

<!-- Modal for Adding new reason-->
<div id="AddNewItemCategory" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Add new Reason</h4>
            </div>

            <div class="modal-body">
                <label>Reason :</label>
                <input id="addItemCategory" name="addItemCategory" class="form-control" type="text"
                       ng-model="ctrl.addItemCategory" placeholder="Enter Reason"/>
            </div>

            <div class="modal-footer">
                <button type="button" id="itemCategorycancelSave" class="btn btn-default"
                        data-dismiss="modal"><g:message code="default.button.cancel.label"/></button>
                <button type="button" id="itemCategorySave" class="btn btn-primary"><g:message
                        code="default.button.add.label"/></button>
            </div>
        </div>
    </div>
</div>

<div id="addNewReasonCodeEdit" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Add new Reason</h4>
            </div>

            <div class="modal-body">
                <label>Reason :</label>
                <input id="addReasonCodeEdit" name="addReasonCodeEdit" class="form-control" type="text"
                       ng-model="ctrl.addReasonCodeEdit" placeholder="Enter Reason"/>
            </div>

            <div class="modal-footer">
                <button type="button" id="reasonCodecancelSaveEdit" class="btn btn-default"
                        data-dismiss="modal"><g:message code="default.button.cancel.label"/></button>
                <button type="button" id="reasonCodeSaveEdit" class="btn btn-primary"><g:message
                        code="default.button.add.label"/></button>
            </div>
        </div>
    </div>
</div>

</div><!-- End of ItemCtrl -->

<div id="inventoryDeleteWarningForStaging" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>

            <div class="modal-body">
                <p>This Inventory cannot be deleted as it has been assigned for the picking.</p>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Ok</button>
            </div>
        </div>
    </div>
</div>

<div id="inventoryDeleteWarningForPnd" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>

            <div class="modal-body">
                <p>This Inventory cannot be deleted as it is on outbound pick and deposit location.</p>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Ok</button>
            </div>
        </div>
    </div>
</div>

<div id="inventoryEditWarningForStaging" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>

            <div class="modal-body">
                <p>This Inventory cannot be edited as it has been assigned for the picking.</p>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Ok</button>
            </div>
        </div>
    </div>
</div>

<div id="inventoryEditWarningForPnd" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>

            <div class="modal-body">
                <p>This Inventory cannot be edited as it is on outbound pick and deposit location.</p>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Ok</button>
            </div>
        </div>
    </div>
</div>

<div id="binAreaSelectWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Bin Location Warning</h4>
            </div>

            <div class="modal-body">
                The Bin Location has been selected.
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message
                        code="default.button.ok.label"/></button>
            </div>
        </div>
    </div>
</div>

<div id="caseToBin" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Bin Location Warning</h4>
            </div>

            <div class="modal-body">
                CASE tracked item cannot be received to a bin location.
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message
                        code="default.button.ok.label"/></button>
            </div>
        </div>
    </div>
</div>

<div id="lowestUOMCaseToBin" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Bin Location Warning</h4>
            </div>

            <div class="modal-body">
                Lowest UOM CASE item cannot be received to a bin location.
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message
                        code="default.button.ok.label"/></button>
            </div>
        </div>
    </div>
</div>

<div id="lowestUOMPalletToBin" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Bin Location Warning</h4>
            </div>

            <div class="modal-body">
                Lowest UOM PALLET item cannot be received to a bin location.
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message
                        code="default.button.ok.label"/></button>
            </div>
        </div>
    </div>
</div>

<asset:javascript src="datagrid/admin-inventory.js"/>

<script type="text/javascript">
    var dvAdminInventory = document.getElementById('dvAdminInventory');
    angular.element(document).ready(function () {
        angular.bootstrap(dvAdminInventory, ['adminInventory']);
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
