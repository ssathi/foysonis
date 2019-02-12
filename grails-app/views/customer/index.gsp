<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2015-12-10
  Time: 4:27 PM
--%>

<html>
<head>
    <meta name="layout" content="foysonis2016"/>
    <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>


    <style>

    .grid {
        height:450px;
    }


    .grid-align {
        text-align: center;
    }

    .grid-action-align {
        padding-left: 10px;
    }

    .dropdown-menu {
        min-width: 90px;
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

    .textInfo {

        background-color: #F3F3F2;
    }

    .textWarning {
        background-color: #FFFF99;
        color:#FF5C33;
    }

    .customer-modal-dialog {
      width: 100%;
      height: 100%;
      margin: 0;
      padding: 0;
    }

    .customer-modal-content {
      height: auto;
      min-height: 100%;
      border-radius: 0;
    }


    .customer-modal-header {
      background: #547CA2;
      height: 70px;
    }

    .customer-panel-title {
        margin-top: -30px;
        color: #ffffff;
    }

    .customer-modal-body {
      position: fixed;
      top: 70px;
      bottom: 70px;
      width: 100%;
      overflow: scroll;
    }

    .customer-modal-footer {
      position: fixed;
      right: 0;
      bottom: 0;
      left: 0;
      border-top: 2px solid #547CA2;
      height: 70px;      
    }

    .customer-close {
        color: #FFFFFF;
        opacity: 1;
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

    </style>



</head>

<body>

    <div class="col-lg-12">
        <div ng-cloak class="row" id="dvCustomer" ng-controller="CustomerCtrl as ctrl">
        <div style="display: inline;"><em class="fa  fa-fw mr-sm" style="padding-right: 40px;" ><img style="width: 35px;" src="/foysonis2016/app/img/customer_header.svg"></em>&nbsp;<span class="headerTitle" style="vertical-align: bottom;">Customers</span></div>
        <button type="button" class="btn btn-primary newFormCreateBtn pull-right" ng-click="ShowHide()">
                        %{--<em class="fa fa-plus-circle fa-fw mr-sm"></em>--}%
                        <g:message code="default.button.createCustomer.label" />
                    </button>  
        <!-- START panel-->
        <!-- <div class="panel panel-default">
            <div class="panel-body"> -->
                <br style="clear: both;"/>
                <br style="clear: both;"/>


                <div  ng-show="ctrl.showSubmittedPrompt" class="alert alert-success message-animation" role="alert" >
                    <g:message code="customerAdd.success.message"/>
                </div>

                <div ng-show="ctrl.showUpdatedPrompt" class="alert alert-success message-animation" role="alert" >
                    <g:message code="customerEdit.success.message"/>
                </div>

                <div ng-show="ctrl.showDeletedPrompt" class="alert alert-success message-animation" role="alert" >
                    <g:message code="customerDelete.success.message"/>
                </div>

                <%-- **************************** create Customer form **************************** --%>
                    <div id="addCustomer" class="modal fade" role="dialog">
                        <div class="customer-modal-dialog modal-dialog" >
                            <div class="customer-modal-content modal-content">

                                <div class="customer-modal-header modal-header">
                                    <button type="button" class="customer-close close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <br style="clear: both;"/>

                                    <div class="panel-heading">
                                        <div class="customer-panel-title panel-title"><h4><g:message code="default.customer.add.label" /></h4></div>
                                    </div>

                                </div>

                                <div class="customer-modal-body modal-body">

                                    <form name="ctrl.createCustomerForm" ng-submit="ctrl.createCustomer()"  novalidate >

                                        <div class="panel-body">

                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('contactName')}">
                                                    <label><g:message code="form.field.contactName.label" /></label>
                                                    <div class="controls">
                                                        <input id="contactName" name="contactName" class="form-control" type="text"
                                                           ng-model="ctrl.newCustomer.contactName" ng-model-options="{ updateOn : 'default blur' }"
                                                               placeholder="Customer Name" required/>

                                                        <div class="my-messages" ng-messages="ctrl.createCustomerForm.contactName.$error" ng-if="ctrl.showMessages('contactName')">
                                                            <div class="message-animation" ng-message="required">
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>


                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('companyName')}">
                                                    <label for="companyName"><g:message code="form.field.companyName.label" /></label>
                                                    <div class="controls">
                                                        <input id="companyName" name="companyName" class="form-control" type="text"
                                                               ng-model="ctrl.newCustomer.companyName" ng-model-options="{ updateOn : 'default blur' }"
                                                               placeholder="Customer Company Name" required/>

                                                        <div class="my-messages" ng-messages="ctrl.createCustomerForm.companyName.$error" ng-if="ctrl.showMessages('companyName')">
                                                            <div class="message-animation" ng-message="required">
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>

                                            <br style="clear: both;"/>


                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('phonePrimary')}">
                                                    <label><g:message code="form.field.phonePrimary.label" /></label>
                                                    <div class="controls">
                                                        <input id="phonePrimary" name="phonePrimary" class="form-control" type="text"
                                                               ng-model="ctrl.newCustomer.phonePrimary" ng-model-options="{ updateOn : 'default blur' }"
                                                               placeholder="Phone Number" maxlength="15" phone-numbers />
                                                    </div>
                                                </div>

                                            </div>


                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('phoneAlternate')}">
                                                    <label for="phoneAlternate"><g:message code="form.field.phoneAlternate.label" /></label>
                                                    <div class="controls">
                                                        <input id="phoneAlternate" name="phoneAlternate" class="form-control" type="text"
                                                               ng-model="ctrl.newCustomer.phoneAlternate" ng-model-options="{ updateOn : 'default blur' }"
                                                               placeholder="Phone Number" maxlength="15" phone-numbers/>
                                                    </div>
                                                </div>

                                            </div>

                                             <br style="clear: both;"/>

                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('email')}">
                                                    <label><g:message code="form.field.email.label" /></label>
                                                    <div class="controls">
                                                        <input id="email" name="email" class="form-control" type="email"
                                                               ng-model="ctrl.newCustomer.email" ng-model-options="{ updateOn : 'default blur' }"
                                                               placeholder="Email Address"/>
                                                        <div class="my-messages" ng-messages="ctrl.createCustomerForm.email.$error" ng-if="ctrl.showMessages('email')">
                                                            <div class="message-animation" ng-message="email">
                                                                <strong>Please enter a valid email.</strong>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>

                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('fax')}">
                                                        <label for="fax"><g:message code="form.field.fax.label" /></label>
                                                        <div class="controls">
                                                            <input id="fax" name="fax" class="form-control" type="text"
                                                                   ng-model="ctrl.newCustomer.fax" ng-model-options="{ updateOn : 'default blur' }"
                                                                   placeholder="Fax Number" maxlength="15" phone-numbers/>
                                                        </div>
                                                    </div>

                                            </div>

                                            <br style="clear: both;"/>

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="isCustomerHold"><g:message code="form.field.customerHold.label" /></label>
                                                    <div class="checkbox c-checkbox">
                                                        <label>
                                                            <input id="isCustomerHold" name="isCustomerHold" type="checkbox" value="" ng-click="" ng-model="ctrl.newCustomer.isCustomerHold">
                                                            <span class="fa fa-check"></span>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>


                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="notes"><g:message code="form.field.notes.label" /></label>
                                                    <div class="controls">
                                                        <textarea id="notes" name="notes" class="form-control"
                                                                  ng-model="ctrl.newCustomer.notes" ng-model-options="{ updateOn : 'default blur' }"
                                                                  placeholder="Notes"></textarea>
                                                    </div>
                                                </div>
                                            </div>

                                            <br style="clear: both;"/>

                                            <h4><g:message code="form.field.billing.label" /> <g:message code="form.field.details.label" />:</h4>

                                            <div class="col-md-6">
                                                <div class="form-group" style="margin-bottom: 0px; margin-top: 0px;">
                                                    <label for="billingStreetAddress"><g:message code="form.field.billing.label" /> <g:message code="form.field.street.label" /></label>
                                                        <div class="controls">
                                                            <textarea id="billingStreetAddress" name="billingStreetAddress" class="form-control" ng-model="ctrl.newCustomer.billingStreetAddress" ng-model-options="{ updateOn : 'default blur' }" placeholder="Street Address" required ></textarea>

                                                            <div class="my-messages" ng-messages="ctrl.createCustomerForm.billingStreetAddress.$error" ng-if="ctrl.showMessages('billingStreetAddress')">
                                                                <div class="message-animation" ng-message="required">
                                                                    <strong><g:message code="required.error.message" /></strong>
                                                                </div>
                                                            </div>

                                                        </div>
                                                </div>
                                            </div>


                                            <div class="col-md-6" >

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('billingCity')}" >
                                                        <label for="billingCity"><g:message code="form.field.billing.label" /> <g:message code="form.field.city.label" /></label>
                                                        <div class="controls">
                                                            <input id="billingCity" name="billingCity" class="form-control" type="text"
                                                                   ng-model="ctrl.newCustomer.billingCity" ng-model-options="{ updateOn : 'default blur' }"
                                                                   placeholder="City/Town" required />

                                                            <div class="my-messages" ng-messages="ctrl.createCustomerForm.billingCity.$error" ng-if="ctrl.showMessages('billingCity')">
                                                                <div class="message-animation" ng-message="required">
                                                                    <strong><g:message code="required.error.message" /></strong>
                                                                </div>
                                                            </div>
                                                        </div>

                                                    </div>
                                            </div>
                                            <br style="clear: both;"/>

                                            <div class="col-md-6">

                                                <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('billingState')}" style="margin-bottom: 10px; margin-top: 17px;">
                                                    <label for="billingState"><g:message code="form.field.billing.label" /> <g:message code="form.field.state.label" /></label>
                                                    <div class="controls">
                                                        <input id="billingState" name="billingState" class="form-control" type="text"
                                                               ng-model="ctrl.newCustomer.billingState" ng-model-options="{ updateOn : 'default blur' }"
                                                               placeholder="State/Province" required />


                                                        <div class="my-messages" ng-messages="ctrl.createCustomerForm.billingState.$error" ng-if="ctrl.showMessages('billingState')">
                                                            <div class="message-animation" ng-message="required">
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>


                                            <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('billingPostCode')}" style="margin-bottom: 10px; margin-top: 17px;">
                                                <label for="billingPostCode"><g:message code="form.field.billing.label" /> <g:message code="form.field.postCode.label" /></label>
                                            <div class="controls">
                                                <input id="billingPostCode" name="billingPostCode" class="form-control" type="text"
                                                       ng-model="ctrl.newCustomer.billingPostCode" ng-model-options="{ updateOn : 'default blur' }"
                                                       placeholder="ZIP/Post Code" required/>
                                                <div class="my-messages" ng-messages="ctrl.createCustomerForm.billingPostCode.$error" ng-if="ctrl.showMessages('billingPostCode')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>
                                            </div>
                                            </div>
                                            </div>

                                            <br style="clear: both;"/>

                                             <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('billingCountry')}">
                                                        <label for="billingCountry"><g:message code="form.field.billing.label" /> <g:message code="form.field.country.label" /></label>
                                                        <select  id="billingCountry" name="billingCountry" ng-model="ctrl.newCustomer.billingCountry" class="form-control" required >
                                                            <option selected disabled value="">Select Country</option>
                                                            <option ng-repeat="country in  countryList" value="{{country}}">{{country}}</option>
                                                        </select>

                                                        <div class="my-messages" ng-messages="ctrl.createCustomerForm.billingCountry.$error" ng-if="ctrl.showMessages('billingCountry')">
                                                            <div class="message-animation" ng-message="required">
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>
                                                    </div>

                                             </div>

                                            <br style="clear: both;"/>
                                            <br style="clear: both;"/>

                                             <h4><g:message code="form.field.shipping.label" /> <g:message code="form.field.details.label" />:</h4>

                                            <div class="col-md-6">

                                                <div class="form-group">
                                                <div class="checkbox c-checkbox">
                                                    <label>
                                                        <input type="checkbox" value="" ng-click="ctrl.checkShippingAddress()" ng-model="ctrl.shippingAddress">
                                                        <span class="fa fa-check"></span><g:message code="form.field.sameAs.label" /></label>
                                                </div>

                                                    <label for="shippingStreetAddress"><g:message code="form.field.shipping.label" /> <g:message code="form.field.street.label" /></label>

                                                    <div class="controls">
                                                        <textarea id="shippingStreetAddress" name="shippingStreetAddress" class="form-control"
                                                                  ng-model="ctrl.newCustomer.shippingStreetAddress" ng-model-options="{ updateOn : 'default blur' }"
                                                                  placeholder="Street Address" ng-disabled="ctrl.shippingAddress" ng-required="!ctrl.shippingAddress" ></textarea>

                                                        <div class="my-messages" ng-messages="ctrl.createCustomerForm.shippingStreetAddress.$error" ng-if="ctrl.showMessages('shippingStreetAddress') && !ctrl.shippingAddress" >
                                                            <div class="message-animation" ng-message="required">
                                                                <strong><g:message code="required.error.message" /></strong>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>

                                            <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('shippingCity')}" style="margin-bottom: 0px; margin-top: 38px;">
                                                <label for="shippingCity"><g:message code="form.field.shipping.label" /> <g:message code="form.field.city.label" /></label>
                                                <div class="controls">
                                                    <input id="shippingCity" name="shippingCity" class="form-control" type="text"
                                                           ng-model="ctrl.newCustomer.shippingCity" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="City/Town" ng-disabled="ctrl.shippingAddress" ng-required="!ctrl.shippingAddress" />

                                                    <div class="my-messages" ng-messages="ctrl.createCustomerForm.shippingCity.$error" ng-if="ctrl.showMessages('shippingCity') && !ctrl.shippingAddress" >
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                            </div>
                                            <br style="clear: both;"/>


                                            <div class="col-md-6">
                                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('shippingState')}">
                                                            <label for="shippingState"><g:message code="form.field.shipping.label" /> <g:message code="form.field.state.label" /></label>
                                                            <div class="controls">
                                                                <input id="shippingState" name="shippingState" class="form-control" type="text"
                                                                       ng-model="ctrl.newCustomer.shippingState" ng-model-options="{ updateOn : 'default blur' }"
                                                                       placeholder="State/Province" ng-disabled="ctrl.shippingAddress" ng-required="!ctrl.shippingAddress" />
                                                                <div class="my-messages" ng-messages="ctrl.createCustomerForm.shippingState.$error" ng-if="ctrl.showMessages('shippingState') && !ctrl.shippingAddress" >
                                                                    <div class="message-animation" ng-message="required">
                                                                        <strong><g:message code="required.error.message" /></strong>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                            </div>

                                            <div class="col-md-6">

                                                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('shippingPostCode')}">
                                                        <label for="shippingPostCode"><g:message code="form.field.shipping.label" /> <g:message code="form.field.postCode.label" /></label>
                                                        <div class="controls">
                                                            <input id="shippingPostCode" name="shippingPostCode" class="form-control" type="text"
                                                                   ng-model="ctrl.newCustomer.shippingPostCode" ng-model-options="{ updateOn : 'default blur' }"
                                                                   placeholder="ZIP/Post Code" ng-disabled="ctrl.shippingAddress" ng-required="!ctrl.shippingAddress"/>
                                                            <div class="my-messages" ng-messages="ctrl.createCustomerForm.shippingPostCode.$error" ng-if="ctrl.showMessages('shippingPostCode') && !ctrl.shippingAddress" >
                                                                <div class="message-animation" ng-message="required">
                                                                    <strong><g:message code="required.error.message" /></strong>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                            </div>

                                             <br style="clear: both;"/>

                                            <div class="col-md-6">
                                                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('shippingCountry')}">
                                                            <label for="shippingCountry"><g:message code="form.field.shipping.label" /> <g:message code="form.field.country.label" /></label>
                                                            <select  id="shippingCountry" name="shippingCountry" ng-model="ctrl.newCustomer.shippingCountry" class="form-control" ng-disabled="ctrl.shippingAddress" ng-required="!ctrl.shippingAddress" >
                                                                <option selected disabled value="">Select Country</option>
                                                                <option ng-repeat="country in  countryList" value="{{country}}">{{country}}</option>
                                                            </select>

                                                            <div class="my-messages" ng-messages="ctrl.createCustomerForm.shippingCountry.$error" ng-if="ctrl.showMessages('shippingCountry') && !ctrl.shippingAddress" >
                                                                <div class="message-animation" ng-message="required">
                                                                    <strong><g:message code="required.error.message" /></strong>
                                                                </div>
                                                            </div>
                                                        </div>
                                            </div>

                                        </div>

                                    </div>        
                                            <div class="customer-modal-footer modal-footer">
                                                %{--<button class="btn btn-default" type="button" data-dismiss="modal" style="margin-left: 0px; margin-right: 433px;"><g:message code="default.button.cancel.label" /></button>--}%
                                                %{--<button class="btn btn-primary" type="submit" style="margin-left: 100px; margin-right: 10px;" ><g:message code="default.button.save.label" /></button>--}%

                                                <button class="btn btn-default pull-left" type="button" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                                                <button class="btn btn-primary" type="submit" style="margin-left: 100px; margin-right: 10px;" ><g:message code="default.button.save.label" /></button>

                                            <br style="clear: both;"/>
                                            <br style="clear: both;"/>

                                            </div>

                                        </form>
                                
                        </div>
                    </div>
            </div>
                <%-- **************************** End of create Customer form **************************** --%>


                <%-- **************************** Edit Customer form ************************************* --%>
                <div id="editCustomer" class="modal fade" role="dialog">
                        <div class="customer-modal-dialog modal-dialog" >
                            <div class="customer-modal-content modal-content">

                                <div class="customer-modal-header modal-header">
                                <button type="button" class="customer-close close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <br style="clear: both;"/>
                                <div class="panel-heading">
                                    <div class="customer-panel-title panel-title"><h4><g:message code="default.customer.edit.label" /></h4></div>
                                </div>

                            </div>

                            <div class="customer-modal-body modal-body">

                                <form name="ctrl.editCustomerForm" ng-submit="ctrl.updateCustomer()"  novalidate >

                                    <div class="panel-body">

                                        <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('contactName')}">
                                                <label><g:message code="form.field.contactName.label" /></label>
                                                <div class="controls">
                                                    <input id="contactName" name="contactName" class="form-control" type="text"
                                                           ng-model="ctrl.editCustomer.contactName" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="Customer Name" required/>

                                                    <div class="my-messages" ng-messages="ctrl.editCustomerForm.contactName.$error" ng-if="ctrl.showMessagesEdit('contactName')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>


                                        <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('companyName')}">
                                                <label for="companyName"><g:message code="form.field.companyName.label" /></label>
                                                <div class="controls">
                                                    <input id="companyName" name="companyName" class="form-control" type="text"
                                                           ng-model="ctrl.editCustomer.companyName" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="Customer Company Name" required/>

                                                    <div class="my-messages" ng-messages="ctrl.editCustomerForm.companyName.$error" ng-if="ctrl.showMessagesEdit('companyName')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                        <br style="clear: both;"/>

                                        <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('phonePrimary')}">
                                                <label><g:message code="form.field.phonePrimary.label" /></label>
                                                <div class="controls">
                                                    <input id="phonePrimary" name="phonePrimary" class="form-control" type="text"
                                                           ng-model="ctrl.editCustomer.phonePrimary" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="Phone Number" maxlength="15" phone-numbers />
                                                </div>
                                            </div>

                                        </div>


                                        <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('phoneAlternate')}">
                                                <label for="phoneAlternate"><g:message code="form.field.phoneAlternate.label" /></label>
                                                <div class="controls">
                                                    <input id="phoneAlternate" name="phoneAlternate" class="form-control" type="text"
                                                           ng-model="ctrl.editCustomer.phoneAlternate" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="Phone Number" maxlength="15" phone-numbers/>
                                                </div>
                                            </div>

                                        </div>


                                        <br style="clear: both;"/>

                                        <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('email')}">
                                                <label><g:message code="form.field.email.label" /></label>
                                                <div class="controls">
                                                    <input id="email" name="email" class="form-control" type="email"
                                                           ng-model="ctrl.editCustomer.email" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="Email Address"/>
                                                    <div class="my-messages" ng-messages="ctrl.editCustomerForm.email.$error" ng-if="ctrl.showMessagesEdit('email')">
                                                        <div class="message-animation" ng-message="email">
                                                            <strong>Please enter a valid email.</strong>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                        <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('fax')}">
                                                <label for="fax"><g:message code="form.field.fax.label" /></label>
                                                <div class="controls">
                                                    <input id="fax" name="fax" class="form-control" type="text"
                                                           ng-model="ctrl.editCustomer.fax" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="Fax Number" maxlength="15" phone-numbers/>
                                                </div>
                                            </div>

                                        </div>

                                        <br style="clear: both;"/>

                                        <g:if test="${session.user.adminActiveStatus == true}">
                                             <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="isCustomerHold"><g:message code="form.field.customerHold.label" /></label>
                                                    <div class="checkbox c-checkbox">
                                                        <label>
                                                            <input id="isCustomerHold" name="isCustomerHold" type="checkbox" value="" ng-click="" ng-model="ctrl.editCustomer.isCustomerHold">
                                                            <span class="fa fa-check"></span></label>
                                                    </div>
                                                </div>
                                             </div>
                                        </g:if>


                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="notes"><g:message code="form.field.notes.label" /></label>
                                                <div class="controls">
                                                    <textarea id="notes" name="notes" class="form-control"
                                                              ng-model="ctrl.editCustomer.notes" ng-model-options="{ updateOn : 'default blur' }"
                                                              placeholder="Notes"></textarea>
                                                </div>
                                            </div>
                                        </div>

                                        <br style="clear: both;"/>

                                        <h4><g:message code="form.field.billing.label" /> <g:message code="form.field.details.label" />:</h4>

                                        <div class="col-md-6">

                                            <div class="form-group" style="margin-bottom: 0px; margin-top: 0px;">
                                                <label for="billingStreetAddress"><g:message code="form.field.billing.label" /> <g:message code="form.field.street.label" /></label>
                                                <div class="controls">
                                                    <textarea id="billingStreetAddress" name="billingStreetAddress" class="form-control"
                                                              ng-model="ctrl.editCustomer.billingStreetAddress" ng-model-options="{ updateOn : 'default blur' }"
                                                              placeholder="Street Address" required ></textarea>

                                                    <div class="my-messages" ng-messages="ctrl.editCustomerForm.billingStreetAddress.$error" ng-if="ctrl.showMessagesEdit('billingStreetAddress')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>

                                        </div>


                                        <div class="col-md-6" >

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('billingCity')}">
                                                <label for="billingCity"><g:message code="form.field.billing.label" /> <g:message code="form.field.city.label" /></label>
                                                <div class="controls">
                                                    <input id="billingCity" name="billingCity" class="form-control" type="text"
                                                           ng-model="ctrl.editCustomer.billingCity" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="City/Town" required />

                                                    <div class="my-messages" ng-messages="ctrl.editCustomerForm.billingCity.$error" ng-if="ctrl.showMessagesEdit('billingCity')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                        <br style="clear: both;"/>

                                        <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('billingState')}" style="margin-bottom: 10px; margin-top: 17px;">
                                                <label for="billingState"><g:message code="form.field.billing.label" /> <g:message code="form.field.state.label" /></label>
                                                <div class="controls">
                                                    <input id="billingState" name="billingState" class="form-control" type="text"
                                                           ng-model="ctrl.editCustomer.billingState" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="State/Province" required />

                                                    <div class="my-messages" ng-messages="ctrl.editCustomerForm.billingState.$error" ng-if="ctrl.showMessagesEdit('billingState')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>


                                        <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('billingPostCode')}" style="margin-bottom: 10px; margin-top: 17px;">
                                                <label for="billingPostCode"><g:message code="form.field.billing.label" /> <g:message code="form.field.postCode.label" /></label>
                                                <div class="controls">
                                                    <input id="billingPostCode" name="billingPostCode" class="form-control" type="text"
                                                           ng-model="ctrl.editCustomer.billingPostCode" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="ZIP/Post Code" required />

                                                    <div class="my-messages" ng-messages="ctrl.editCustomerForm.billingPostCode.$error" ng-if="ctrl.showMessagesEdit('billingPostCode')">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <br style="clear: both;"/>

                                        <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('billingCountry')}">
                                                <label for="billingCountry"><g:message code="form.field.billing.label" /> <g:message code="form.field.country.label" /></label>
                                                <select  id="billingCountry" name="billingCountry" ng-model="ctrl.editCustomer.billingCountry" class="form-control" required >
                                                <option selected disabled value="">Select Country</option>
                                                    <option ng-repeat="country in countryList" value="{{country}}">{{country}}
                                                    </option>
                                                </select>
                                                <div class="my-messages" ng-messages="ctrl.editCustomerForm.billingCountry.$error" ng-if="ctrl.showMessagesEdit('billingCountry')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                        <br style="clear: both;"/>
                                        <br style="clear: both;"/>

                                        <h4><g:message code="form.field.shipping.label" /> <g:message code="form.field.details.label" />:</h4>

                                        <div class="col-md-6">

                                            <div class="form-group">
                                                <div class="checkbox c-checkbox">
                                                    <label>
                                                        <input type="checkbox" value="" ng-click="ctrl.checkEditShippingAddress()" ng-model="ctrl.editShippingAddress">
                                                        <span class="fa fa-check"></span><g:message code="form.field.sameAs.label" /></label>
                                                </div>

                                                <label for="shippingStreetAddress"><g:message code="form.field.shipping.label" /> <g:message code="form.field.street.label" /></label>
                                                <div class="controls">
                                                    <textarea id="shippingStreetAddress" name="shippingStreetAddress" class="form-control"
                                                              ng-model="ctrl.editCustomer.shippingStreetAddress" ng-model-options="{ updateOn : 'default blur' }"
                                                              placeholder="Street Address" ng-disabled="ctrl.editShippingAddress" ng-required="!ctrl.editShippingAddress" ></textarea>
                                                    <div class="my-messages" ng-messages="ctrl.editCustomerForm.shippingStreetAddress.$error" ng-if="ctrl.showMessagesEdit('shippingStreetAddress') && !ctrl.editShippingAddress">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>


                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('shippingCity')}" style="margin-bottom: 0px; margin-top: 38px;">
                                                <label for="shippingCity"><g:message code="form.field.shipping.label" /> <g:message code="form.field.city.label" /></label>
                                                <div class="controls">
                                                    <input id="shippingCity" name="shippingCity" class="form-control" type="text"
                                                           ng-model="ctrl.editCustomer.shippingCity" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="City/Town" ng-disabled="ctrl.editShippingAddress" ng-required="!ctrl.editShippingAddress" />
                                                    <div class="my-messages" ng-messages="ctrl.editCustomerForm.shippingCity.$error" ng-if="ctrl.showMessagesEdit('shippingCity') && !ctrl.editShippingAddress">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                        <br style="clear: both;"/>

                                        <div class="col-md-6">
                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('shippingState')}">
                                                <label for="shippingState"><g:message code="form.field.shipping.label" /> <g:message code="form.field.state.label" /></label>
                                                <div class="controls">
                                                    <input id="shippingState" name="shippingState" class="form-control" type="text"
                                                           ng-model="ctrl.editCustomer.shippingState" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="State/Province" ng-disabled="ctrl.editShippingAddress" ng-required="!ctrl.editShippingAddress"/>
                                                    <div class="my-messages" ng-messages="ctrl.editCustomerForm.shippingState.$error" ng-if="ctrl.showMessagesEdit('shippingState') && !ctrl.editShippingAddress">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                        <div class="col-md-6">

                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('shippingPostCode')}" >
                                                <label for="shippingPostCode"><g:message code="form.field.shipping.label" /> <g:message code="form.field.postCode.label" /></label>
                                                <div class="controls">
                                                    <input id="shippingPostCode" name="shippingPostCode" class="form-control" type="text"
                                                           ng-model="ctrl.editCustomer.shippingPostCode" ng-model-options="{ updateOn : 'default blur' }"
                                                           placeholder="ZIP/Post Code" ng-disabled="ctrl.editShippingAddress" ng-required="!ctrl.editShippingAddress"/>
                                                    <div class="my-messages" ng-messages="ctrl.editCustomerForm.shippingPostCode.$error" ng-if="ctrl.showMessagesEdit('shippingPostCode') && !ctrl.editShippingAddress">
                                                        <div class="message-animation" ng-message="required">
                                                            <strong><g:message code="required.error.message" /></strong>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                        <br style="clear: both;"/>

                                        <div class="col-md-6">
                                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClassEdit('shippingCountry')}">
                                                <label for="shippingCountry"><g:message code="form.field.shipping.label" /> <g:message code="form.field.country.label" /></label>
                                                <select  id="shippingCountry" name="shippingCountry" ng-model="ctrl.editCustomer.shippingCountry" class="form-control" ng-disabled="ctrl.editShippingAddress" ng-required="!ctrl.editShippingAddress">
                                                    <option selected disabled value="">Select Country</option>
                                                    <option ng-repeat="country in countryList" value="{{country}}">{{country}}</option>
                                                </select>
                                                <div class="my-messages" ng-messages="ctrl.editCustomerForm.shippingCountry.$error" ng-if="ctrl.showMessagesEdit('shippingCountry') && !ctrl.editShippingAddress">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                
                                    <div class="customer-modal-footer modal-footer">
                                        %{--<button class="btn btn-default" type="button" data-dismiss="modal" style="margin-left: 0px; margin-right: 425px;"><g:message code="default.button.cancel.label" /></button>--}%
                                        %{--<button class="btn btn-primary" type="submit" style="margin-left: 100px; margin-right: 10px;" ><g:message code="default.button.update.label" /></button>--}%

                                        <button class="btn btn-default pull-left" type="button" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                                        <button class="btn btn-primary" type="submit" style="margin-left: 100px; margin-right: 10px;" ><g:message code="default.button.update.label" /></button>

                                        <br style="clear: both;"/>
                                        <br style="clear: both;"/>

                                    </div>

                                </form>
                            
                        </div>
                    </div>
                </div>

                <%-- **************************** End of Edit Customer form **************************** --%>

                <%-- **************************** Start of Find Customer **************************** --%>

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

                                            <div class="col-md-6">
                                                <div class="form-group" ng-class="">
                                                    <label for="customerId"></label>
                                                    <input id="customerId" name="customerId" class="form-control" type="text" value="${customerId}"
                                                           ng-model="ctrl.customerId" ng-blur="ctrl.disableFindButton()"
                                                           placeholder="Customer Name / Company / Phone / City / Country" />
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-group" ng-class="" style="margin-left: 15px; margin-top: 20px;">
                                                    <button type="submit" class="btn btn-primary findBtn">
                                                        %{--<button type="submit" class="btn btn-primary" ng-disabled="ctrl.disabledFind">--}%
                                                        <g:message code="default.button.searchCustomer.label" />
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                    </fieldset>

                                </div>
                                <!-- END Wizard Step inputs -->
                            </div>
                        </form>
                    </div>
                </div>

                <!-- end search form-->
                <br style="clear: both;"/>


                <!-- Start Customer Grid-->

                <div id="grid1" ui-grid="gridItem" ui-grid-exporter ui-grid-pagination ui-grid-pinning ui-grid-resize-columns  class="grid">
                    <div class="noDataMessage" ng-if="gridItem.data.length == 0"><g:message code="customer.grid.noData.message" /></div>
                </div>

                <%-- **************************** End of Find Customer **************************** --%>

            <!-- </div>

        </div> -->
        <!-- END panel-->

    <!-- </div> --> <!-- DIV do not need -->

    <!--start delete modal -->

    <div id="DeleteCustomer" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Confirmation</h4>
                </div>
                <div class="modal-body">
                    <p>Are you sure want to delete {{ctrl.deleteCustomerForMessage}} ?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id ="deleteButton" class="btn btn-primary"><g:message code="default.button.delete.label" /></button>
                </div>
            </div>
        </div>
    </div>

    <div id="DeleteCustomerWarning" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Warning</h4>
                </div>
                <div class="modal-body">
                    <p>You can not delete {{ctrl.deleteCustomerForMessage}} as this customer has order.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>

    <!--end delete modal -->


    <!--start Shipping Address modal -->

    <div id="CustomerShippingAddress" class="modal fade" role="dialog" >
        <div class="modal-dialog" style="width: 90%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Shipping Address</h4>
                </div>
                <div class="modal-body">

                <div  ng-show="ctrl.showShippingAddSavePrompt" class="alert alert-success message-animation" role="alert" >
                    Shipping address has been created.
                </div>

                <div  ng-show="ctrl.showShippingAddUpdatePrompt" class="alert alert-success message-animation" role="alert" >
                    Shipping address has been updated.
                </div>

                <div  ng-show="ctrl.showMakeDefaultPrompt" class="alert alert-success message-animation" role="alert" >
                    This shipping address has been made as default.
                </div>

                <div  ng-show="ctrl.showShippingAddDeletePrompt" class="alert alert-success message-animation" role="alert" >
                    Shipping address has been deleted.
                </div>                
                    <button type="button" class="btn btn-primary pull-right" ng-click="ShowHideAddressForm()" >
                        <em class="fa fa-plus-circle fa-fw mr-sm"></em>
                        New Shipping Address
                    </button>

                    <div ng-show = "IsVisibleAddressForm" class="row" style="padding:10px 20px;">
                        <h4>{{ctrl.addressFormLabel}}</h4>

                        <form name="ctrl.addressForm" ng-submit="createShippingAddress()" novalidate >
                            <div class="col-md-6" style="padding: 5px;" ng-class="{'has-error':ctrl.hasErrorClassShipping('shippingStreetAddress')}">
                                <label for="streetAddress"><g:message code="form.field.shipping.label" /> <g:message code="form.field.street.label" /></label>
                                <div class="controls">
                                    <textarea id="shippingStreetAddress" name="shippingStreetAddress" rows="4" class="form-control" ng-model="ctrl.customerShippingStreetAddress" ng-model-options="{ updateOn : 'default blur' }" placeholder="Street Address" required></textarea>

                                </div>
                                <div class="my-messages" ng-messages="ctrl.addressForm.shippingStreetAddress.$error" ng-if="ctrl.showMessagesShipping('shippingStreetAddress')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" style="padding: 5px;"  ng-class="{'has-error':ctrl.hasErrorClassShipping('shippingCity')}">

                                <label for="city"><g:message code="form.field.shipping.label" /> <g:message code="form.field.city.label" /></label>
                                <div class="controls">
                                    <input id="shippingCity" name="shippingCity" class="form-control" type="text" ng-model="ctrl.customerShippingCity" ng-model-options="{ updateOn : 'default blur' }" placeholder="City/Town" required />
                                </div>
                                <div class="my-messages" ng-messages="ctrl.addressForm.shippingCity.$error" ng-if="ctrl.showMessagesShipping('shippingCity')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" style="padding: 5px;"  ng-class="{'has-error':ctrl.hasErrorClassShipping('shippingState')}">

                                <label for="state"><g:message code="form.field.shipping.label" /> <g:message code="form.field.state.label" /></label>
                                <div class="controls">
                                    <input id="shippingState" name="shippingState" class="form-control" type="text" ng-model="ctrl.customerShippingState" ng-model-options="{ updateOn : 'default blur' }" placeholder="State/Province" required />
                                </div>
                                <div class="my-messages" ng-messages="ctrl.addressForm.shippingState.$error" ng-if="ctrl.showMessagesShipping('shippingState')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" style="padding: 5px;"  ng-class="{'has-error':ctrl.hasErrorClassShipping('shippingPostCode')}">

                                <label for="postCode"><g:message code="form.field.shipping.label" /> <g:message code="form.field.postCode.label" /></label>
                                <div class="controls">
                                    <input id="shippingPostCode" name="shippingPostCode" class="form-control" type="text" ng-model="ctrl.customerShippingPostCode" ng-model-options="{ updateOn : 'default blur' }"  placeholder="ZIP/Post Code" required />
                                </div>
                                <div class="my-messages" ng-messages="ctrl.addressForm.shippingPostCode.$error" ng-if="ctrl.showMessagesShipping('shippingPostCode')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" style="padding: 5px;"  ng-class="{'has-error':ctrl.hasErrorClassShipping('shippingCountry')}">

                            <label for="country"><g:message code="form.field.shipping.label" /> <g:message code="form.field.country.label" /></label>
                            <select  id="shippingCountry" name="shippingCountry" ng-model="ctrl.customerShippingCountry" class="form-control"  required>
                                <option selected disabled value="">Select Country</option>
                                <option ng-repeat="country in countryList" value="{{country}}">{{country}}</option>
                            </select>
                            <div class="my-messages" ng-messages="ctrl.addressForm.shippingCountry.$error" ng-if="ctrl.showMessagesShipping('shippingCountry')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>
                        </div>

                            <div class="pull-right" style="padding-top: 10px;">
                                <button class="btn btn-primary" type="submit"><g:message code="default.button.save.label" /></button>
                            </div>

                        </form>


                    </div>

                    <div ng-show = "IsVisibleAddressFormEdit" class="row" style="padding:10px 20px;">
                        <h4>Shipping Address Edit</h4>

                        <form name="ctrl.addressFormEdit" ng-submit="updateShippingAddress()" novalidate >
                            <div class="col-md-6" style="padding: 5px;" ng-class="{'has-error':ctrl.hasErrorClassShippingEdit('shippingStreetAddress')}">
                                <label for="streetAddress"><g:message code="form.field.shipping.label" /> <g:message code="form.field.street.label" /></label>
                                <div class="controls">
                                    <textarea id="shippingStreetAddress" name="shippingStreetAddress" rows="4" class="form-control" ng-model="ctrl.customerShippingStreetAddressEdit" ng-model-options="{ updateOn : 'default blur' }" placeholder="Street Address" required></textarea>

                                </div>
                                <div class="my-messages" ng-messages="ctrl.addressFormEdit.shippingStreetAddress.$error" ng-if="ctrl.showMessagesShippingEdit('shippingStreetAddress')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>

                            </div>
                            <div class="col-md-6" style="padding: 5px;" ng-class="{'has-error':ctrl.hasErrorClassShippingEdit('shippingCity')}">

                                <label for="city"><g:message code="form.field.shipping.label" /> <g:message code="form.field.city.label" /></label>
                                <div class="controls">
                                    <input id="shippingCity" name="shippingCity" class="form-control" type="text" ng-model="ctrl.customerShippingCityEdit" ng-model-options="{ updateOn : 'default blur' }" placeholder="City/Town"  required />
                                </div>
                                <div class="my-messages" ng-messages="ctrl.addressFormEdit.shippingCity.$error" ng-if="ctrl.showMessagesShippingEdit('shippingCity')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>

                            </div>
                            <div class="col-md-6" style="padding: 5px;" ng-class="{'has-error':ctrl.hasErrorClassShippingEdit('shippingState')}">

                                <label for="state"><g:message code="form.field.shipping.label" /> <g:message code="form.field.state.label" /></label>
                                <div class="controls">
                                    <input id="shippingState" name="shippingState" class="form-control" type="text" ng-model="ctrl.customerShippingStateEdit" ng-model-options="{ updateOn : 'default blur' }" placeholder="State/Province" required />
                                </div>
                                <div class="my-messages" ng-messages="ctrl.addressFormEdit.shippingState.$error" ng-if="ctrl.showMessagesShippingEdit('shippingState')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>


                            </div>
                            <div class="col-md-6" style="padding: 5px;" ng-class="{'has-error':ctrl.hasErrorClassShippingEdit('shippingPostCode')}">

                                <label for="postCode"><g:message code="form.field.shipping.label" /> <g:message code="form.field.postCode.label" /></label>
                                <div class="controls">
                                    <input id="shippingPostCode" name="shippingPostCode" class="form-control" type="text" ng-model="ctrl.customerShippingPostCodeEdit" ng-model-options="{ updateOn : 'default blur' }"  placeholder="ZIP/Post Code" required />
                                </div>
                                <div class="my-messages" ng-messages="ctrl.addressFormEdit.shippingPostCode.$error" ng-if="ctrl.showMessagesShippingEdit('shippingPostCode')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>

                            </div>
                            <div class="col-md-6" style="padding: 5px;" ng-class="{'has-error':ctrl.hasErrorClassShippingEdit('shippingCountry')}">

                            <label for="country"><g:message code="form.field.shipping.label" /> <g:message code="form.field.country.label" /></label>
                            <select  id="shippingCountry" name="shippingCountry" ng-model="ctrl.customerShippingCountryEdit" class="form-control" required>
                                <option selected disabled value="">Select Country</option>
                                <option ng-repeat="country in countryList" value="{{country}}">{{country}}</option>
                            </select>
                            <div class="my-messages" ng-messages="ctrl.addressFormEdit.shippingCountry.$error" ng-if="ctrl.showMessagesShippingEdit('shippingCountry')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>

                        </div>

                            <div class="pull-right" style="padding-top: 10px;">
                                <button class="btn btn-primary" type="submit"><g:message code="default.button.save.label" /></button>
                            </div>
                            <div class="pull-left">
                                <button class="btn btn-default pull-left" type="button" ng-click="ctrl.clearAddressFormEdit()"><g:message code="default.button.cancel.label" /></button>
                            </div>

                        </form>


                    </div>

                    <br style="clear: both;"/>
                    <br style="clear: both;"/>
                    <div ng-if="ctrl.viewShippingAddressGrid"  id="grid4" ui-grid="gridShippingAddress" ui-grid-exporter ui-grid-pagination ui-grid-pinning ui-grid-resize-columns  class="grid">
                        <div class="noDataMessage" ng-if="gridShippingAddress.data.length == 0"><g:message code="address.grid.noData.message" /></div>
                    </div>
                    <div style="clear: both;"/></div>
                    <div style="clear: both;"/></div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.close.label" /></button>
                </div>
            </div>
        </div>
    </div>



    <!--end Shipping Address modal -->


</div><!-- End of CustomerCtrl -->
</div>

<div id="dvDeleteShippingAdd" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure want to delete this shippping Address ?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                <button type="button" id = "shippingAddDeleteButton" class="btn btn-primary"><g:message code="default.button.delete.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="dvDeleteshippingAddWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>You can not delete this shipping address as it has been already used.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<div id="dvDeleteDefaultAddressWarning" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Warning</h4>
            </div>
            <div class="modal-body">
                <p>You can not delete default shipping address.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
            </div>
        </div>
    </div>
</div>
<asset:javascript src="datagrid/customer.js"/>



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

<script type="text/javascript">
    var dvCustomer = document.getElementById('dvCustomer');
    angular.element(document).ready(function() {
        angular.bootstrap(dvCustomer, ['customer']);
    });
</script>

%{--<asset:javascript src="autocomplete/angular-auto.js"/>--}%
<asset:javascript src="autocomplete/angular-sanitize.js"/>
<asset:javascript src="autocomplete/auto-complete.js"/>
<asset:javascript src="autocomplete/auto-complete-multi.js"/>
<asset:javascript src="inventory/auto-complete-div.js"/>
<asset:javascript src="autocomplete/auto-complete-textbox.js"/>

<asset:javascript src="datagrid/customerService.js"/>

</body>
</html>
