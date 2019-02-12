<%--
  Created by IntelliJ IDEA.
  User: home
  Date: 9/8/15
  Time: 16:56
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
    %{--<asset:stylesheet src="datagrid/ui-grid.css"/>--}%

    %{--Sign Up Form--}%
    <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>
    %{--<script src="http://code.angularjs.org/1.1.4/angular.js"></script>--}%

    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>



<style>

.grid-align {
    text-align: center;
}

.grid-action-align {
    padding-left: 90px;
}

.dropdown-menu {
    min-width: 90px;
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

.receipt-modal-dialog-edit {
    width: 100%;
    height: 100%;
    /*margin: 0;*/
    margin-left: auto;
    margin-right: auto;
    margin-top: auto;
    margin-bottom: auto;
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

.receipt-modal-body-billing {
    position: fixed;
    top: 70px;
    bottom: 70px;
    width: 100%;
    overflow-y: auto;
    overflow-x: hidden;
    padding: 15px
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
    background: #547CA2;
}

.receipt-close {
    color: #FFFFFF;
    opacity: 1;
}

.historyGrid {
    height:380px;
    width: 1300px;
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

.cardLogo {
    width: 50px;
}


    </style>



</head>

<body>

    <div ng-cloak id="dvAdminUser" ng-controller="MainCtrl as ctrl">

        <div style="display: inline;"><em class="fa  fa-fw mr-sm" style="padding-right: 40px;" ><img style="height: 35px;" src="/foysonis2016/app/img/user_header.svg"></em>&nbsp;<span class="headerTitle" style="vertical-align: bottom;">Users
        </span></div>
        <br style="clear: both;">
        <br style="clear: both;">
        <div class="row">
            <div class="col-md-6">
                <!-- START widget-->
                <div data-play="fadeInLeft" data-offset="0" data-delay="100" class="panel widget">
                    <div class="panel-body bg-primary">
                        <div class="row row-table row-flush">
                            <div class="col-xs-8">
                                <p class="mb0">Maximum allowed number of users</p>
                                <h3 class="m0"  ng-model="ctrl.licensedUser">{{ctrl.licensedUser}}</h3>
                            </div>
                            <div class="col-xs-4 text-right">
                                <em class="fa fa-share-alt fa-2x"></em>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <!-- START widget-->
                <div data-play="fadeInDown" data-offset="0" data-delay="100" class="panel widget">
                    <div class="panel-body bg-success">
                        <div class="row row-table row-flush">
                            <div class="col-xs-8">
                                <p class="mb0">Current number of users</p>
                                <h3 class="m0">{{ctrl.activeUsersCount}}</h3>
                            </div>
                            <div class="col-xs-4 text-right">
                                <em class="fa fa-cloud-upload fa-2x"></em>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" href="javascript:void(0);">

            <button type="button" class="btn btn-primary pull-right" ng-click="ShowHide()" ng-if="ctrl.activeUsersCount < ctrl.licensedUser">
            <em class="fa fa-plus-circle fa-fw mr-sm"></em>
            <g:message code="default.button.createUser.label" />
            </button>

        </a>

        <!-- START Billing Button-->
        <div ng-show="ctrl.showBillingButton == true" class="row" style="padding-left: 15px;">

            <button ng-if="ctrl.planDetails == 'Individual'" type="button" class="btn btn-primary pull-left" ng-click ="ctrl.redirectToBillingPage()" >
                <g:message code="default.button.upgrade.label" />
            </button>

            <!-- START button group-->
            <div class="btn-group mb-sm" ng-if="ctrl.planDetails == 'Standard'">
                <button type="button" class="btn btn-primary" ng-click ="ctrl.redirectToBillingPage()">
                    <g:message code="default.button.upgrade.label" /></button>
                <button type="button" data-toggle="dropdown" class="btn btn-primary dropdown-toggle" style="width: 0px;">
                    <span class="caret"></span>
                </button>
                <ul role="menu" class="dropdown-menu">
                    <li>
                        <a href="javascript:void(0);" ng-click ="ctrl.redirectToBillingPage()"><g:message code="default.button.buyMoreUsers.label" /></a>
                    </li>
                </ul>
            </div>
            <!-- END button group-->

            <button type="button" class="btn btn-primary pull-left" ng-click ="ctrl.redirectToBillingPage()" ng-if="ctrl.planDetails == 'Premium'">
                <g:message code="default.button.buyMoreUsers.label" />
            </button>

        </div>

        <!-- END Billing Button-->


        <br style="clear: both;"/>
        <br style="clear: both;"/>


        %{--New user signup form--}%
        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showSubmittedPrompt">
            <g:message code="user.create.message" />
        </div>
        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showDeletedPrompt">
            <g:message code="user.delete.message" />
        </div>
        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showUpdatedPrompt">
            <g:message code="user.update.message" />
        </div>
        <div ng-show = "IsVisible" class="row">

            <form name="ctrl.signupForm" ng-submit="ctrl.signup()" novalidate >


                <div class="panel panel-default" id="panel-anim-fadeInDown">
                    <div class="panel-heading">
                        <div class="panel-title">
                            %{--<g:message code="default.user.add.label" />--}%
                            {{ctrl.userFormLabel}}
                        </div>
                    </div>

                    <div class="panel-body">
                        <div class="col-md-6">
                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('firstName')}">
                                <label for="firstName"><g:message code="form.field.firstName.label" /></label>
                                <input id="firstName" name="firstName" class="form-control" type="text" required
                                       ng-model="ctrl.newCustomer.firstName" ng-model-options="{ updateOn : 'default blur' }"
                                       ng-focus="ctrl.toggleFirstNamePrompt(true)" ng-blur="ctrl.toggleFirstNamePrompt(false)"/>

                                <div class="my-messages" ng-messages="ctrl.signupForm.firstName.$error" ng-if="ctrl.showMessages('firstName')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>

                            </div>

                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('lastName')}">
                                <label for="lastName"><g:message code="form.field.lastName.label" /></label>
                                <input id="lastName" name="lastName" class="form-control" type="text" required
                                       ng-model="ctrl.newCustomer.lastName" ng-model-options="{ updateOn : 'default blur' }"
                                       ng-focus="ctrl.toggleLastNamePrompt(true)" ng-blur="ctrl.toggleLastNamePrompt(false)"/>

                                <div class="my-messages" ng-messages="ctrl.signupForm.lastName.$error" ng-if="ctrl.showMessages('lastName')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>

                            </div>

                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('email')}">
                                <label for="email"><g:message code="form.field.email.label" /></label>
                                <input id="email" name="email" class="form-control" type="email"
                                       ng-model="ctrl.newCustomer.email" ng-model-options="{ updateOn : 'default blur' }"
                                       ng-focus="ctrl.toggleEmailPrompt(true)" ng-blur="ctrl.toggleEmailPrompt(false);ctrl.emailUniqueValidation(ctrl.newCustomer.email);" required />


                                <div class="my-messages" ng-messages="ctrl.signupForm.email.$error" ng-if="ctrl.showMessages('email')">
                                    <div class="message-animation" ng-message="email">
                                        <strong>Please enter a valid email.</strong>
                                    </div>
                                </div>

                                <div class="my-messages" ng-messages="ctrl.signupForm.email.$error" ng-if="ctrl.showMessages('email')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>

                                <div class="my-messages"  ng-messages="ctrl.signupForm.email.$error" ng-if="ctrl.signupForm.$error.emailExists">
                                    <div class="message-animation" >
                                        <strong>This email is used already</strong>
                                    </div>
                                </div>

                            </div>

                            <div class="form-group">
                                <label for="adminActiveStatus" ><g:message code="form.field.adminStatus.label" /></label>
                                <input id="adminActiveStatus" name="adminActiveStatus" class="form-control"  type="checkbox" ng-model="ctrl.newCustomer.adminActiveStatus" ng-model-options="{ updateOn : 'default blur' }" style="width: auto;" ng-change="adminActiveStatusCheckBoxChange()" />

                            </div>

                            <input type='hidden' name="hiddenUsername" ng-model="ctrl.newCustomer.hiddenUsername" />
                        </div>


                        <div class="col-md-6">




                            <div class="form-group">
                                <label for="portalOnlyUser"><g:message code="form.field.portalOnlyUser.label" /></label>
                                <input id="portalOnlyUser" name="portalOnlyUser" class="form-control"  type="checkbox" ng-model="ctrl.newCustomer.portalOnlyUser" ng-model-options="{ updateOn : 'default blur' }" style="width: auto;" ng-change="portalOnlyUserCheckBoxChange()"/>

                            </div>

                            <div class="form-group" ng-if="ctrl.newCustomer.hiddenUsername">
                                <label for="activeStatus"><g:message code="form.field.activeStatus.label" /></label>
                                <input id="activeStatus" name="activeStatus" class="form-control"  type="checkbox" ng-model="ctrl.newCustomer.activeStatus" ng-model-options="{ updateOn : 'default blur' }" style="width: auto;" />

                            </div>



                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('username')}" ng-if="!ctrl.newCustomer.hiddenUsername">
                                <label for="username"><g:message code="form.field.userName.label" /></label>
                                <input id="username" name="username" class="form-control" type="text" required
                                       ng-model="ctrl.newCustomer.username"
                                       ng-focus="ctrl.toggleUsernamePrompt(true)" ng-blur="ctrl.toggleUsernamePrompt(false); ctrl.usernameUniqueValidation(ctrl.newCustomer.username)"
                                    />


                                <div class="my-messages" ng-messages="ctrl.signupForm.username.$error" ng-if="ctrl.showMessages('username')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>

                                <div class="my-messages"  ng-messages="ctrl.signupForm.username.$error" ng-if="ctrl.signupForm.$error.usernameExists">
                                    <div class="message-animation" >
                                        <strong>Username is already used for this company.</strong>
                                    </div>
                                </div>

                            </div>

                            <div class="form-group">
                                <label for="password"><g:message code="form.field.password.label" /></label>

                                <div class="input-group" ng-class="{'has-error':ctrl.hasErrorClass('password')}" ng-if="!ctrl.newCustomer.hiddenUsername">
                                    <input id="password" name="password" class="form-control" required
                                           type="{{ctrl.getPasswordType()}}"
                                           ng-model-options="{ updateOn : 'default blur' }"
                                           ng-model="ctrl.newCustomer.password"
                                           validate-password-characters />
                                    <span class="input-group-addon">
                                        <input type="checkbox" ng-model="ctrl.signupForm.showPassword"> Show
                                    </span>
                                </div>
                                <div class="input-group" ng-class="{'has-error':ctrl.hasErrorClass('password')}" ng-if="ctrl.newCustomer.hiddenUsername">
                                    <input id="password" name="password" class="form-control"
                                           type="{{ctrl.getPasswordType()}}"
                                           ng-model-options="{ updateOn : 'default blur' }"
                                           ng-model="ctrl.newCustomer.password"
                                           validate-password-characters-for-edit />
                                    <span class="input-group-addon">
                                        <input type="checkbox" ng-model="ctrl.signupForm.showPassword"> Show
                                    </span>
                                </div>

                                <div class="my-messages" ng-messages="ctrl.signupForm.password.$error" ng-if="ctrl.showMessages('password')">
                                    <div class="message-animation" ng-message="required">
                                        <strong><g:message code="required.error.message" /></strong>
                                    </div>
                                </div>

                                <div class="password-requirements" ng-if="!ctrl.signupForm.password.$valid">
                                    <ul class="float-left">
                                        <li ng-class="{'completed':!ctrl.signupForm.password.$error.lowerCase}">One lowercase character</li>
                                        <li ng-class="{'completed':!ctrl.signupForm.password.$error.upperCase}">One uppercase character</li>
                                        <li ng-class="{'completed':!ctrl.signupForm.password.$error.number}">One number</li>
                                    </ul>
                                    <ul class="selfclear clearfix">
                                        <li ng-class="{'completed':!ctrl.signupForm.password.$error.specialCharacter}">One special character</li>
                                        <li ng-class="{'completed':!ctrl.signupForm.password.$error.eightCharacters}">Eight characters minimum</li>
                                    </ul>
                                </div>

                                <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.signupForm.password.$valid" style="margin-top: 5px;">
                                    %{--Your password is secure and you are good to go!--}%
                                    <g:message code="user.password.message" />
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="panel-footer">
                        <div class="pull-left">
                            <a data-play="fadeInDown" data-target="#panel-anim-fadeInDown" href="javascript:void(0);">
                                <button class="btn btn-default" ng-click="ShowHide()"><g:message code="default.button.cancel.label" /></button>
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

        <div id="grid1" ui-grid="gridOptions" ui-grid-exporter ui-grid-resize-columns  class="grid"></div>
        <div ng-if='columnChanged'>
        </div>

        <div id="userEditWarning" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Confirmation</h4>
                    </div>
                    <div class="modal-body">
                        <g:message code="user.edit.warning.message" />
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                        <button type="button" id = "editUserButtonFromPopUp" class="btn btn-primary" ng-click="openEdit()"><g:message code="default.button.ok.label" /></button>
                    </div>
                </div>
            </div>
        </div>


        <!------------ start customer  billing pop up----------->
        <div id="billing" class="modal fade" role="dialog" >
            <div class="receipt-modal-dialog modal-dialog"  style="width: 100%;">
                <div class="receipt-modal-content modal-content">
                    <div class="receipt-modal-header modal-header">
                        <button type="button" class="receipt-close close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <br style="clear: both;"/>

                        <div class="panel-heading">
                            <div class="receipt-panel-title panel-title"><h4>Billing & Licenses</h4></div>
                        </div>
                    </div>


                    <div class="receipt-modal-body-billing  modal-body" style="clear: both;" >

                        <div  ng-show="ctrl.showPaymentUpdatedPrompt" class="alert alert-success message-animation" role="alert" >
                            <g:message code="companyBilling.success.message"/>
                        </div>

                        <div class="panel-heading" style="clear: both;" >
                            <legend>
                                <label style="font-size: 14px; color: green;">Company ID&emsp;:&emsp;{{ctrl.billingCompanyId}}</label>

                            <button style="margin-top: -10px;" ng-if="ctrl.planDetails == 'Standard-monthly' || ctrl.planDetails == 'Standard-yearly'"
                                    type="button" class="btn btn-primary pull-right" ng-click ="ctrl.upgradeCurrentPlanStandard()">
                                <g:message code="default.button.manageCurrentPlan.label"/>
                            </button>

                            <button ng-if="ctrl.planDetails == 'Premium-monthly' || ctrl.planDetails == 'Premium-yearly'"
                                    type="button" class="btn btn-primary pull-right" ng-click ="ctrl.upgradeCurrentPlanPremium()">
                                <g:message code="default.button.manageCurrentPlan.label"/>
                            </button>

                                <br style="clear:both;" />

                            </legend>

                        </div>

                        <div class="col-md-12">

                            <div class="col-md-3"></div>

                            <div class="col-md-9" style="font-size: 15px; text-align: left;">

                                <div class="">Subscription Status
                                    <label style="margin-left: 250px;">{{ctrl.subscriptionStatus}}</label>
                                </div>
                                <br style="clear:both;" />

                                <div class="">Plan Details
                                    <label style="margin-left: 300px;">{{ctrl.viewPlan}}
                                        <label ng-if="ctrl.planDetails != 'Individual'">({{ctrl.currentCost | currency}} / {{ctrl.period}})</label>
                                    </label>&emsp;
                                    <button ng-if= "ctrl.planDetails != 'Premium'" class="btn btn-primary" style="padding: 0px 20px !important; height: 30px;" type="button" style="height: 40px; " ng-click="ctrl.upgrade()" >
                                        <g:message code="default.button.upgrade.label" />
                                    </button>
                                </div>

                                <br style="clear:both;" />

                                <div class="" ng-if="ctrl.planDetails != 'Individual'">No. of Users
                                    <label style="margin-left: 295px;">{{ctrl.noOfUsers}}</label>
                                </div>
                                <br style="clear:both;" />


                                <div class="" ng-if="ctrl.planDetails != 'Individual'">Next Charge Amount
                                    <label style="margin-left: 241px;">{{ctrl.viewTotalAmount | currency}}</label>
                                </div>
                                <br style="clear:both;" />


                                <div class="" ng-if="ctrl.planDetails != 'Individual'">Next Charge Date
                                    <label style="margin-left: 260px;">{{ctrl.nextPayment | date}}</label>
                                </div>
                                <br style="clear:both;" />


                                <div class="" ng-if="ctrl.planDetails != 'Individual'">Payment Method
                                    <label style="margin-left: 262px;">{{ctrl.paymentMethod}}</label>&emsp;
                                    %{--<label style="margin-left: 262px;">{{ccinfo.type}}</label>&emsp;--}%
                                    <button  class="btn btn-primary" style="padding: 0px 20px !important; height: 30px;" type="button" style="height: 50px;" ng-click="ctrl.edit()">
                                        Edit
                                    </button>
                                </div>
                                <br style="clear:both;" />


                                <div class="" ng-if="ctrl.planDetails != 'Individual'">Past Payments
                                    <button class="btn btn-primary" style="padding: 0px 20px !important; margin-left: 280px; height: 30px;" type="button" style="height: 40px; " ng-click="ctrl.payment()">
                                        View payment history</button>
                                </div>
                                <br style="clear:both;" />


                            </div>

                        </div>


                        <br style="clear:both;" />

                        <div class="modal-footer" style="text-align: center; font-size: 12px;">Privacy&emsp;| &emsp; Security&emsp; | &emsp; Terms of Service</div>

                    </div>

                    %{--<div class="modal-footer" style="text-align: center; font-size: 12px;">Privacy&emsp;| &emsp; Security&emsp; | &emsp; Terms of Service</div>--}%

                    <div class="receipt-modal-footer modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.close.label" /></button>
                    </div>

                </div>
            </div>
        </div>
        <!------------ end customer  billing pop up----------->



        <!-- start edit customer  billing popup -->
        <div id="editPayment" class="modal fade" role="dialog">
            <div class="receipt-modal-dialog-edit modal-dialog"  style="width: 50%;">
                <div class="receipt-modal-content modal-content">

                    <form name="ctrl.billingEditForm" ng-submit="ctrl.updateBilling()">


                    <div class="receipt-modal-header modal-header">
                        <button type="button" class="receipt-close close" id ="closeButton" aria-hidden="true">&times;</button>
                        <div class="panel-heading">
                            <div class="receipt-panel-title panel-title"><h4>Payment Information</h4></div>
                        </div>
                    </div>

                    <div class="receipt-modal-body modal-body">
                        <!--start form1 -->
                        <div class="row">

                        <div class="col-md-12">
                            <div ng-show="ctrl.paymentProcessMessage" class="alert alert-info message-animation" role="alert" >
                                Please wait...
                            </div>
                        </div>

                        <div class="col-md-12">
                            <div  ng-show="ctrl.paymentErrorMessage" class="alert alert-danger message-animation" role="alert" >
                                {{ctrl.paymentErrorMessage}}
                            </div>
                        </div>

                        <div class="col-md-12">

                            <input type="hidden" name="stripeToken" id="stripeToken" ng-model="ctrl.stripeToken"/>

                            <div class="col-md-12">
                                <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit('name')}">
                                    <label for="name"><g:message code="form.field.nameOnCard.label" /></label>

                                    <input id="name" name="name" class="form-control" type="text" ng-model="ctrl.nameOnCard"
                                           ng-model-options="{ updateOn : 'default blur' }" placeholder="Name on Card" ng-blur=""  required/>

                                    <div class="my-messages" ng-messages="ctrl.billingEditForm.name.$error" ng-if="ctrl.showMessagesEdit('name')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>



                                </div>
                            </div>


                            <div class="col-md-10">
                                <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit('creditCard')}">
                                    <label for="cardNumber"><g:message code="form.field.cardNo.label" /></label>

                                    <input class="form-control"
                                           type="text"
                                           name="creditCard"
                                           ng-model="ctrl.cardNumber"
                                           data-credit-card-type
                                           data-ng-minlength="15"
                                           maxlength="16"
                                           placeholder="Card Number"
                                           id="cc_number"
                                           ng-model-options="{ updateOn : 'default blur' }" ng-blur=""
                                           numbers-only required/>

                                    <div class="my-messages" ng-messages="ctrl.billingEditForm.creditCard.$error" ng-if="ctrl.showMessagesEdit('creditCard')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages" style="text-align: left;color: red;" role="alert" ng-if="ctrl.viewResult && ccinfo.type!='Invalid card number'">
                                        Invalid card number.
                                    </div>


                                </div>
                            </div>

                            <div class="col-md-2">
                                <div class="form-group"  style="margin-left: 10px; margin-top: 30px;">
                                    %{--{{ccinfo.type}}--}%
                                    <span><img  ng-if="ccinfo.type=='mastercard'" src="${request.contextPath}/foysonis2016/app/img/MasterCard_logo.png" class="cardLogo"/></span>
                                    <span><img  ng-if="ccinfo.type=='visa'" src="${request.contextPath}/foysonis2016/app/img/Visa_Logo.png" class="cardLogo"/></span>
                                    <span><img  ng-if="ccinfo.type=='amex'" src="${request.contextPath}/foysonis2016/app/img/AmericanExpress_logo.png" class="cardLogo"/></span>
                                    <span><img  ng-if="ccinfo.type=='discover'" src="${request.contextPath}/foysonis2016/app/img/discoverCard-logo.png" class="cardLogo"/></span>
                                    <span class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ccinfo.type=='Invalid card number'" >{{ccinfo.type}}.</span>


                                </div>
                            </div>


                            <div class="col-md-6">
                                <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit('cvc')}">
                                    <label for="cvc"><g:message code="form.field.cvc.label" /></label>

                                    <input id="cvc" name="cvc" class="form-control" type="text" ng-model="ctrl.cvc"
                                           ng-model-options="{ updateOn : 'default blur' }" placeholder="CVC" ng-blur="" numbers-only required/>

                                    <div class="my-messages" ng-messages="ctrl.billingEditForm.cvc.$error" ng-if="ctrl.showMessagesEdit('cvc')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                </div>
                            </div>


                            <div class="col-md-6">

                                <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit('expirationMonth')}">
                                    <label for="expirationDate"><g:message code="form.field.expiration.label" /></label>

                                    <input id="exp_month" name="expirationMonth" class="form-control" type="text" ng-model="ctrl.expirationMonth" maxlength="2"
                                           ng-model-options="{ updateOn : 'default blur' }" placeholder="mm" ng-blur=""  numbers-only required style="width: 70px;"/>

                                    <input id="exp_year" name="expirationYear" class="form-control" type="text" ng-model="ctrl.expirationYear"
                                           ng-model-options="{ updateOn : 'default blur' }" placeholder="yyyy" ng-blur=""  numbers-only required maxlength="4"
                                           style="margin-top:-37px; margin-left:90px; width: 83px;"/>

                                    <div class="my-messages" ng-messages="ctrl.billingEditForm.expirationMonth.$error" ng-if="ctrl.showMessagesEdit('expirationMonth')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                    <div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.expirationMonth > 12
                                    || 2040 < ctrl.expirationYear || ctrl.expirationYear < ${new Date().format("yyyy")}
                                    || (ctrl.expirationMonth < ${new Date().format("MM")} && ctrl.expirationYear == ${new Date().format("yyyy")})">
                                        <div class="">
                                            <g:message code="form.expMonth.error.message" />
                                        </div>
                                    </div>

                                    %{--<div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.expirationMonth > 12">--}%
                                        %{--<div class="">--}%
                                            %{--<g:message code="form.expMonth.error.message" />--}%
                                        %{--</div>--}%
                                    %{--</div>--}%


                                </div>
                            </div>


                            %{--<div class="col-md-3" style="margin-top: 25px;" >--}%

                                %{--<div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit('expirationYear')}">--}%

                                    %{--<input id="exp_year" name="expirationYear" class="form-control" type="text" ng-model="ctrl.expirationYear"--}%
                                           %{--ng-model-options="{ updateOn : 'default blur' }" placeholder="yyyy" ng-blur=""  numbers-only required maxlength="4"/>--}%

                                    %{--<div class="my-messages" ng-messages="ctrl.billingEditForm.expirationYear.$error" ng-if="ctrl.showMessagesEdit('expirationYear')">--}%
                                        %{--<div class="message-animation" ng-message="required">--}%
                                            %{--<strong><g:message code="required.error.message" /></strong>--}%
                                        %{--</div>--}%
                                    %{--</div>--}%
                                    %{--<div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="2040 < ctrl.expirationYear || ctrl.expirationYear < ${new Date().format("yyyy")}">--}%
                                        %{--<div class="">--}%
                                            %{--<g:message code="form.expYear.error.message" />--}%
                                        %{--</div>--}%
                                    %{--</div>--}%

                                    %{--<div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.expirationMonth < ${new Date().format("MM")} && ctrl.expirationYear = ${new Date().format("yyyy")}">--}%
                                        %{--<div class="">--}%
                                            %{--<g:message code="form.expYear.error.message" />--}%
                                        %{--</div>--}%
                                    %{--</div>--}%

                                %{--</div>--}%
                            %{--</div>--}%


                            <div class="col-md-12">
                                <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit('billingAddress')}">
                                    <label for="billingAddress"><g:message code="form.field.billingAddress.label" /></label>

                                    <textarea id="address_line1" name="billingAddress" class="form-control"  ng-model="ctrl.billingAddress"
                                           ng-model-options="{ updateOn : 'default blur' }" placeholder="Billing Address"  required></textarea>


                                    <div class="my-messages" ng-messages="ctrl.billingEditForm.billingAddress.$error" ng-if="ctrl.showMessagesEdit('billingAddress')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit('city')}">
                                    <label for="city"><g:message code="form.field.billingCity.label" /></label>

                                    <input id="address_city" name="city" class="form-control" type="text" ng-model="ctrl.city"
                                           ng-model-options="{ updateOn : 'default blur' }" placeholder="City" ng-blur=""  required/>

                                    <div class="my-messages" ng-messages="ctrl.billingEditForm.city.$error" ng-if="ctrl.showMessagesEdit('city')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <div class="col-md-3">
                                <div class="form-group"  style="margin-left: 10px">
                                    <label for="state"><g:message code="form.field.billingState.label" /></label>

                                    <input id="address_state" name="state" class="form-control" type="text" ng-model="ctrl.state"
                                           ng-model-options="{ updateOn : 'default blur' }" placeholder="State" ng-blur="" />

                                </div>
                            </div>

                            <div class="col-md-3">
                                <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit('zip')}">
                                    <label for="zip"><g:message code="form.field.billingZip.label" /></label>

                                    <input id="address_zip" name="zip" class="form-control" type="text" ng-model="ctrl.zip"
                                           ng-model-options="{ updateOn : 'default blur' }" placeholder="ZIP Code" ng-blur=""  numbers-only required/>

                                    <div class="my-messages" ng-messages="ctrl.billingEditForm.zip.$error" ng-if="ctrl.showMessagesEdit('zip')">
                                        <div class="message-animation" ng-message="required">
                                            <strong><g:message code="required.error.message" /></strong>
                                        </div>
                                    </div>

                                </div>
                            </div>

                        </div>

                        </div>
                        <!--end form1 -->

                        <br style="clear: both;"/>

                    </div>

                    <div class="receipt-modal-footer modal-footer">
                        <button type="submit" class="btn btn-primary"><g:message code="default.button.save.label" /></button>
                    </div>

                    </form>

                </div>
            </div>
        </div>
        <!-- end edit customer  billing popup -->


        <!------------ start customer  billing payment pop up----------->
        <div id="paymentHistory" class="modal fade" role="dialog" >
            <div class="receipt-modal-dialog modal-dialog"  style="width: 100%;">
                <div class="receipt-modal-content modal-content">
                    <div class="receipt-modal-header modal-header">
                        <button type="button" class="receipt-close close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <br style="clear: both;"/>

                        <div class="panel-heading">
                            <div class="receipt-panel-title panel-title"><h4>Payment History</h4></div>
                        </div>
                    </div>

                    <div class="receipt-modal-body modal-body">

                        <div id="grid1" ui-grid="gridHistory" ui-grid-exporter ui-grid-pinning ui-grid-resize-columns  class="historyGrid"></div>
                        %{--<div ng-if='columnChanged'></div>--}%
                        <div class="noItemMessage" ng-if="gridHistory.data.length == 0">History Not Found</div>

                    </div>

                    <div class="receipt-modal-footer modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal">Back</button>
                    </div>

                </div>
            </div>
        </div>
        <!------------ end customer  billing payment pop up----------->


        <!------------ start customer  upgrade pop up----------->
        <div id="upgrade" class="modal fade" role="dialog" >
            <div class="receipt-modal-dialog modal-dialog"  style="width: 100%;">
                <div class="receipt-modal-content modal-content">
                    <div class="receipt-modal-header modal-header">
                        <button type="button" class="receipt-close close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <br style="clear: both;"/>

                        <div class="panel-heading">
                            <div class="receipt-panel-title panel-title"><h4>Payment Upgrade</h4></div>
                        </div>
                    </div>

                    <div class="receipt-modal-body modal-body">

                        <!-- START panel-->

                            <div class="panel-body">
                                <!-- START table-responsive-->
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover">
                                        <thead>
                                        <tr>
                                            <th><span style="font-size: 22px;font-weight: bold;">Run your Business Efficiently</span>
                                                <br><br><span style="font-size: 16px;">Upgrade your plan to save time and improve your bottom line</span>
                                            </th>

                                            <th style="text-align: center;background-color: lightgray;color: white;"><span style="font-size: 20px;">Individual</span>
                                                <br><br><span style="font-size: 16px;">Current Version</span></th>

                                            <th style="text-align: center;background-color: #40A3FD;color: white;"><span style="font-size: 20px;">Standard</span>
                                                <br><br><span style="font-size: 16px;">Save time on<br> back office tasks</span></th>

                                            <th style="text-align: center;background-color: #547CA2;color: white;"><span style="font-size: 20px;">Premium</span>
                                                <br><br><span style="font-size: 16px;">improve your<br> bottom line</span></th>

                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td>1</td>
                                            <td style="text-align: center"><em class="fa fa-circle"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                        </tr>
                                        <tr>
                                            <td>2</td>
                                            <td style="text-align: center"><em class="fa fa-circle"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                        </tr>
                                        <tr>
                                            <td>3</td>
                                            <td style="text-align: center"><em class="fa fa-circle"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                        </tr>
                                        <tr>
                                            <td>4</td>
                                            <td style="text-align: center"><em class="fa fa-circle"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                        </tr>
                                        <tr>
                                            <td>5</td>
                                            <td style="text-align: center"><em class="fa fa-circle"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                        </tr>
                                        <tr>
                                            <td>6</td>
                                            <td style="text-align: center"><em class="fa fa-circle"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                        </tr>
                                        <tr>
                                            <td>7</td>
                                            <td style="text-align: center"><em class="fa fa-circle"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                        </tr>
                                        <tr>
                                            <td>8</td>
                                            <td style="text-align: center"><em class="fa fa-circle"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                        </tr>
                                        <tr>
                                            <td>9</td>
                                            <td style="text-align: center"><em class="fa fa-circle"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                        </tr>
                                        <tr>
                                            <td>10</td>
                                            <td style="text-align: center"><em class="fa fa-circle"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                            <td style="text-align: center"><em class="fa fa-check" style="color: blue"></em></td>
                                        </tr>
                                        <tr style="text-align: center">
                                            <td></td>
                                            <td></td>
                                            <td>
                                                <button ng-if="ctrl.planDetails == 'Individual'" type="button" class="btn btn-primary" ng-click="ctrl.upgradeStandard()"><g:message code="default.button.upgrade.label" /></button>
                                                <br><a href="" ng-if="ctrl.planDetails == 'Individual'"><g:message code="default.link.yourPricingDetails.label"/></a>
                                            </td>
                                            <td>
                                                <button ng-if="ctrl.planDetails == 'Individual' || ctrl.planDetails == 'Standard'" type="button" class="btn btn-primary" ng-click="ctrl.upgradePremium()"><g:message code="default.button.upgrade.label" /></button>
                                                <br><a href="" ng-if="ctrl.planDetails == 'Individual' || ctrl.planDetails == 'Standard'"><g:message code="default.link.yourPricingDetails.label"/></a>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <!-- END table-responsive-->
                            </div>

                        <!-- END panel-->

                    </div>

                    <div class="receipt-modal-footer modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                    </div>

                </div>
            </div>
        </div>
        <!------------ end customer upgrade pop up----------->


        <!-- start upgrade Standard -->
        <div id="upgradeStandard" class="modal fade" role="dialog">
            <div class="receipt-modal-dialog-edit modal-dialog"  style="width: 50%;">

                <div class="receipt-modal-content modal-content">



                    <div class="receipt-modal-header modal-header">
                        <button type="button" class="receipt-close close" id ="closeButton1" aria-hidden="true">&times;</button>
                        <div class="panel-heading">
                            <div class="receipt-panel-title panel-title"><h4>Upgrade To Standard</h4></div>
                        </div>
                    </div>



                        <div class="receipt-modal-body modal-body">

                            <div class="col-md-12">
                                <div ng-show="ctrl.paymentProcessMessage" class="alert alert-info message-animation" role="alert" >
                                    Please wait...
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div  ng-show="ctrl.paymentErrorMessage" class="alert alert-danger message-animation" role="alert" >
                                    {{ctrl.paymentErrorMessage}}
                                </div>
                            </div>

                            <form name="ctrl.upgradeStandardForm" ng-submit="ctrl.upgradeStandardSaveAction()" >

                                <div class="row">

                                <div class="col-md-12">


                                    <div class="col-md-6">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('NoOfUsers')}">
                                            <label for="NoOfUsers"><g:message code="form.field.NoOfUsers.label" /></label>

                                            <input ng-if="ctrl.noOfUsers >= 2" id="NoOfUsers" name="NoOfUsers" class="form-control" type="number" ng-model="ctrl.NoOfUsers" min="{{ctrl.noOfUsers}}" ng-model-options="{ updateOn : 'default blur' }" placeholder="No.of Users" ng-blur=""  required/>

                                            <input ng-if="ctrl.noOfUsers < 2" id="NoOfUsers" name="NoOfUsers" class="form-control" type="number" ng-model="ctrl.NoOfUsers" min="2" ng-model-options="{ updateOn : 'default blur' }" placeholder="No.of Users" ng-blur="" required/>


                                            <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.NoOfUsers.$error" ng-if="ctrl.showMessagesEdit3('NoOfUsers')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.NoOfUsers < ctrl.noOfUsers">
                                                <div class="">
                                                    <g:message code="form.NoOfUsers.error.message" />
                                                </div>
                                            </div>


                                        </div>
                                    </div>


                                    <div class="col-md-6">
                                        <div class="form-group"  style="margin-left: 10px">

                                            %{--<label for="plan"><g:message code="form.field.plan.label" /></label>--}%
                                            <br style="clear:both;" />
                                            %{--<input type="radio" name="plan" id="plan" value="Standard" ng-model="ctrl.plan" ng-checked="true"> STANDARD--}%

                                        </div>
                                    </div>


                                </div>

                                <br style="clear:both;" />
                                <legend>
                                <h4 style="margin-left: 40px;">Payment Information</h4>
                                </legend>

                                <div class="col-md-12">

                                    <input type="hidden" name="stripeToken" id="stripeToken" ng-model="ctrl.stripeToken"/>

                                    <div class="col-md-12">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('name')}">
                                            <label for="name"><g:message code="form.field.nameOnCard.label" /></label>

                                            <input id="name" name="name" class="form-control" type="text" ng-model="ctrl.nameOnCard"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="Name on Card" ng-blur=""  required/>

                                            <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.name.$error" ng-if="ctrl.showMessagesEdit3('name')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>


                                    <div class="col-md-10">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('creditCard')}">
                                            <label for="creditCard"><g:message code="form.field.cardNo.label" /></label>

                                            <input class="form-control"
                                                   type="text"
                                                   name="creditCard"
                                                   ng-model="ctrl.cardNumber"
                                                   required
                                                   data-credit-card-type
                                                   data-ng-minlength="15"
                                                   maxlength="16"
                                                   placeholder="Card Number"
                                                   id="cc_number"
                                                   numbers-only required/>

                                            <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.creditCard.$error" ng-if="ctrl.showMessagesEdit3('creditCard')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages" style="text-align: left;color: red;" role="alert" ng-if="ctrl.viewResult && ccinfo.type!='Invalid card number'">
                                                Invalid card number.
                                            </div>


                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <div class="form-group"  style="margin-left: 10px; margin-top: 30px;">
                                            %{--{{ccinfo.type}}--}%
                                            <span><img  ng-if="ccinfo.type=='mastercard'" src="${request.contextPath}/foysonis2016/app/img/MasterCard_logo.png" class="cardLogo"/></span>
                                            <span><img  ng-if="ccinfo.type=='visa'" src="${request.contextPath}/foysonis2016/app/img/Visa_Logo.png" class="cardLogo"/></span>
                                            <span><img  ng-if="ccinfo.type=='amex'" src="${request.contextPath}/foysonis2016/app/img/AmericanExpress_logo.png" class="cardLogo"/></span>
                                            <span><img  ng-if="ccinfo.type=='discover'" src="${request.contextPath}/foysonis2016/app/img/discoverCard-logo.png" class="cardLogo"/></span>
                                            <span class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ccinfo.type=='Invalid card number'" >{{ccinfo.type}}.</span>
                                        </div>
                                    </div>


                                    <div class="col-md-6">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('cvc')}">
                                            <label for="cvc"><g:message code="form.field.cvc.label" /></label>

                                            <input id="cvc" name="cvc" class="form-control" type="text" ng-model="ctrl.cvc"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="CVC" ng-blur="" numbers-only required/>

                                            <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.cvc.$error" ng-if="ctrl.showMessagesEdit3('cvc')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>


                                    <div class="col-md-6">

                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('expirationMonth')}">
                                            <label for="expirationDate"><g:message code="form.field.expiration.label" /></label>

                                            <input id="exp_month" name="expirationMonth" class="form-control" type="text" ng-model="ctrl.expirationMonth" maxlength="2"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="mm" ng-blur=""  numbers-only required style="width: 70px;"/>

                                            <input id="exp_year" name="expirationYear" class="form-control" type="text" ng-model="ctrl.expirationYear"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="yyyy" ng-blur=""  numbers-only required maxlength="4"
                                                   style="margin-top:-37px; margin-left:90px; width: 83px;"/>

                                            <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.expirationMonth.$error" ng-if="ctrl.showMessagesEdit3('expirationMonth')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.expirationMonth > 12
                                    || 2040 < ctrl.expirationYear || ctrl.expirationYear < ${new Date().format("yyyy")}
                                    || (ctrl.expirationMonth < ${new Date().format("MM")} && ctrl.expirationYear == ${new Date().format("yyyy")})">
                                                <div class="">
                                                    <g:message code="form.expMonth.error.message" />
                                                </div>
                                            </div>

                                            %{--<div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.expirationMonth > 12">--}%
                                            %{--<div class="">--}%
                                            %{--<g:message code="form.expMonth.error.message" />--}%
                                            %{--</div>--}%
                                            %{--</div>--}%


                                        </div>
                                    </div>

                                    %{--<div class="col-md-3">--}%

                                        %{--<div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit('expirationMonth')}">--}%
                                            %{--<label for="expirationDate"><g:message code="form.field.expiration.label" /></label>--}%

                                            %{--<input id="exp_month" name="expirationMonth" class="form-control" type="text" ng-model="ctrl.expirationMonth" maxlength="2"--}%
                                                   %{--ng-model-options="{ updateOn : 'default blur' }" placeholder="mm" ng-blur=""  numbers-only required style="width: 70px;"/>--}%

                                            %{--<div class="my-messages" ng-messages="ctrl.billingEditForm.expirationMonth.$error" ng-if="ctrl.showMessagesEdit('expirationMonth')">--}%
                                                %{--<div class="message-animation" ng-message="required">--}%
                                                    %{--<strong><g:message code="required.error.message" /></strong>--}%
                                                %{--</div>--}%
                                            %{--</div>--}%

                                            %{--<div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.expirationMonth > 12">--}%
                                                %{--<div class="">--}%
                                                    %{--<g:message code="form.expMonth.error.message" />--}%
                                                %{--</div>--}%
                                            %{--</div>--}%

                                        %{--</div>--}%
                                    %{--</div>--}%


                                    %{--<div class="col-md-3" style="margin-top: 25px;" >--}%

                                        %{--<div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit('expirationYear')}">--}%

                                            %{--<input id="exp_year" name="expirationYear" class="form-control" type="text" ng-model="ctrl.expirationYear"--}%
                                                   %{--ng-model-options="{ updateOn : 'default blur' }" placeholder="yyyy" ng-blur=""  numbers-only required maxlength="4"/>--}%

                                            %{--<div class="my-messages" ng-messages="ctrl.billingEditForm.expirationYear.$error" ng-if="ctrl.showMessagesEdit('expirationYear')">--}%
                                                %{--<div class="message-animation" ng-message="required">--}%
                                                    %{--<strong><g:message code="required.error.message" /></strong>--}%
                                                %{--</div>--}%
                                            %{--</div>--}%

                                            %{--<div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="2040 < ctrl.expirationYear || ctrl.expirationYear < ${new Date().format("yyyy")}">--}%
                                                %{--<div class="">--}%
                                                    %{--<g:message code="form.expYear.error.message" />--}%
                                                %{--</div>--}%
                                            %{--</div>--}%

                                        %{--</div>--}%
                                    %{--</div>--}%


                                    <div class="col-md-12">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('billingAddress')}">
                                            <label for="billingAddress"><g:message code="form.field.billingAddress.label" /></label>

                                            <textarea id="address_line1" name="billingAddress" class="form-control"  ng-model="ctrl.billingAddress"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="Billing Address"  required></textarea>

                                            <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.billingAddress.$error" ng-if="ctrl.showMessagesEdit3('billingAddress')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('city')}">
                                            <label for="city"><g:message code="form.field.billingCity.label" /></label>

                                            <input id="address_city" name="city" class="form-control" type="text" ng-model="ctrl.city"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="City" ng-blur=""  required/>

                                            <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.city.$error" ng-if="ctrl.showMessagesEdit3('city')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group"  style="margin-left: 10px">
                                            <label for="state"><g:message code="form.field.billingState.label" /></label>

                                            <input id="address_state" name="state" class="form-control" type="text" ng-model="ctrl.state"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="State" ng-blur="" />

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('zip')}">
                                            <label for="zip"><g:message code="form.field.billingZip.label" /></label>

                                            <input id="address_zip" name="zip" class="form-control" type="text" ng-model="ctrl.zip"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="ZIP Code" ng-blur=""  numbers-only required/>

                                            <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.zip.$error" ng-if="ctrl.showMessagesEdit3('zip')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                </div>


                        </div>
                        </div>

                        <div class="receipt-modal-footer modal-footer">
                            <button type="submit" class="btn btn-primary"><g:message code="default.button.save.label" /></button>
                        </div>

                    </form>

                </div>
            </div>
        </div>
        <!-- end upgrade Standard -->


        <!-- start upgrade Premium -->
        <div id="upgradePremium" class="modal fade" role="dialog">
            <div class="receipt-modal-dialog-edit modal-dialog"  style="width: 50%;">
                <div class="receipt-modal-content modal-content">

                    <form name="ctrl.upgradePremiumForm" ng-submit="ctrl.upgradePremiumSaveAction()">

                        <div class="receipt-modal-header modal-header">
                            <button type="button" class="receipt-close close" id ="closeButton2" aria-hidden="true">&times;</button>
                            <div class="panel-heading">
                                <div class="receipt-panel-title panel-title"><h4>Upgrade To Premium</h4></div>
                            </div>
                        </div>

                        <div class="receipt-modal-body modal-body">

                            <div class="row">
                                <div class="col-md-12">
                                    <div ng-show="ctrl.paymentProcessMessage" class="alert alert-info message-animation" role="alert" >
                                        Please wait...
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <div  ng-show="ctrl.paymentErrorMessage" class="alert alert-danger message-animation" role="alert" >
                                        {{ctrl.paymentErrorMessage}}
                                    </div>
                                </div>


                                <div class="col-md-12">


                                    <div class="col-md-6">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit1('NoOfUsers')}">
                                            <label for="NoOfUsers"><g:message code="form.field.NoOfUsers.label" /></label>

                                            <input ng-if="ctrl.noOfUsers >= 5" id="NoOfUsers" name="NoOfUsers" class="form-control" type="number" ng-model="ctrl.NoOfUsers" step="1" min="{{ctrl.noOfUsers}}"  ng-model-options="{ updateOn : 'default blur' }" placeholder="No.of Users" ng-blur=""  required/>

                                            <input ng-if="ctrl.noOfUsers < 5" id="NoOfUsers" name="NoOfUsers" class="form-control" type="number" ng-model="ctrl.NoOfUsers" step="1" min="5"  ng-model-options="{ updateOn : 'default blur' }" placeholder="No.of Users" ng-blur="" required/>

                                            <div class="my-messages" ng-messages="ctrl.upgradePremiumForm.NoOfUsers.$error" ng-if="ctrl.showMessagesEdit1('NoOfUsers')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.NoOfUsers < ctrl.noOfUsers">
                                                <div class="">
                                                    <g:message code="form.NoOfUsers.error.message" />
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                </div>


                                <br style="clear:both;" />
                                <legend>
                                    <h4 style="margin-left: 40px;">Payment Information</h4>
                                </legend>

                                <div class="col-md-12">

                                    <input type="hidden" name="stripeToken" id="stripeToken" ng-model="ctrl.stripeToken"/>

                                    <div class="col-md-12">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit1('name')}">
                                            <label for="name"><g:message code="form.field.nameOnCard.label" /></label>

                                            <input id="name" name="name" class="form-control" type="text" ng-model="ctrl.nameOnCard"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="Name on Card" ng-blur=""  required/>

                                            <div class="my-messages" ng-messages="ctrl.upgradePremiumForm.name.$error" ng-if="ctrl.showMessagesEdit1('name')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>


                                    <div class="col-md-10">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit1('creditCard')}">
                                            <label for="cardNumber"><g:message code="form.field.cardNo.label" /></label>

                                            <input class="form-control"
                                                   type="text"
                                                   name="creditCard"
                                                   ng-model="ctrl.cardNumber"
                                                   required
                                                   data-credit-card-type
                                                   data-ng-minlength="15"
                                                   maxlength="16"
                                                   placeholder="Card Number"
                                                   id="cc_number"
                                                   numbers-only required/>

                                            <div class="my-messages" ng-messages="ctrl.upgradePremiumForm.creditCard.$error" ng-if="ctrl.showMessagesEdit1('creditCard')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages" style="text-align: left;color: red;" role="alert" ng-if="ctrl.viewResult && ccinfo.type!='Invalid card number'">
                                                Invalid card number.
                                            </div>

                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <div class="form-group"  style="margin-left: 10px; margin-top: 30px;">
                                            %{--{{ccinfo.type}}--}%
                                            <span><img  ng-if="ccinfo.type=='mastercard'" src="${request.contextPath}/foysonis2016/app/img/MasterCard_logo.png" class="cardLogo"/></span>
                                            <span><img  ng-if="ccinfo.type=='visa'" src="${request.contextPath}/foysonis2016/app/img/Visa_Logo.png" class="cardLogo"/></span>
                                            <span><img  ng-if="ccinfo.type=='amex'" src="${request.contextPath}/foysonis2016/app/img/AmericanExpress_logo.png" class="cardLogo"/></span>
                                            <span><img  ng-if="ccinfo.type=='discover'" src="${request.contextPath}/foysonis2016/app/img/discoverCard-logo.png" class="cardLogo"/></span>
                                            <span class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ccinfo.type=='Invalid card number'" >{{ccinfo.type}}.</span>
                                        </div>
                                    </div>


                                    <div class="col-md-6">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit1('cvc')}">
                                            <label for="cvc"><g:message code="form.field.cvc.label" /></label>

                                            <input id="cvc" name="cvc" class="form-control" type="text" ng-model="ctrl.cvc"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="CVC" ng-blur="" numbers-only required/>

                                            <div class="my-messages" ng-messages="ctrl.upgradePremiumForm.cvc.$error" ng-if="ctrl.showMessagesEdit1('cvc')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                    <div class="col-md-6">

                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit1('expirationMonth')}">
                                            <label for="expirationDate"><g:message code="form.field.expiration.label" /></label>

                                            <input id="exp_month" name="expirationMonth" class="form-control" type="text" ng-model="ctrl.expirationMonth" maxlength="2"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="mm" ng-blur=""  numbers-only required style="width: 70px;"/>

                                            <input id="exp_year" name="expirationYear" class="form-control" type="text" ng-model="ctrl.expirationYear"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="yyyy" ng-blur=""  numbers-only required maxlength="4"
                                                   style="margin-top:-37px; margin-left:90px; width: 83px;"/>

                                            <div class="my-messages" ng-messages="ctrl.upgradePremiumForm.expirationMonth.$error" ng-if="ctrl.showMessagesEdit1('expirationMonth')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.expirationMonth > 12
                                    || 2040 < ctrl.expirationYear || ctrl.expirationYear < ${new Date().format("yyyy")}
                                    || (ctrl.expirationMonth < ${new Date().format("MM")} && ctrl.expirationYear == ${new Date().format("yyyy")})">
                                                <div class="">
                                                    <g:message code="form.expMonth.error.message" />
                                                </div>
                                            </div>

                                            %{--<div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.expirationMonth > 12">--}%
                                            %{--<div class="">--}%
                                            %{--<g:message code="form.expMonth.error.message" />--}%
                                            %{--</div>--}%
                                            %{--</div>--}%


                                        </div>
                                    </div>


                                    %{--<div class="col-md-3">--}%

                                        %{--<div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit('expirationMonth')}">--}%
                                            %{--<label for="expirationDate"><g:message code="form.field.expiration.label" /></label>--}%

                                            %{--<input id="exp_month" name="expirationMonth" class="form-control" type="text" ng-model="ctrl.expirationMonth" maxlength="2"--}%
                                                   %{--ng-model-options="{ updateOn : 'default blur' }" placeholder="mm" ng-blur=""  numbers-only required style="width: 70px;"/>--}%

                                            %{--<div class="my-messages" ng-messages="ctrl.billingEditForm.expirationMonth.$error" ng-if="ctrl.showMessagesEdit('expirationMonth')">--}%
                                                %{--<div class="message-animation" ng-message="required">--}%
                                                    %{--<strong><g:message code="required.error.message" /></strong>--}%
                                                %{--</div>--}%
                                            %{--</div>--}%

                                            %{--<div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.expirationMonth > 12">--}%
                                                %{--<div class="">--}%
                                                    %{--<g:message code="form.expMonth.error.message" />--}%
                                                %{--</div>--}%
                                            %{--</div>--}%

                                        %{--</div>--}%
                                    %{--</div>--}%


                                    %{--<div class="col-md-3" style="margin-top: 25px;" >--}%

                                        %{--<div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit('expirationYear')}">--}%

                                            %{--<input id="exp_year" name="expirationYear" class="form-control" type="text" ng-model="ctrl.expirationYear"--}%
                                                   %{--ng-model-options="{ updateOn : 'default blur' }" placeholder="yyyy" ng-blur=""  numbers-only required maxlength="4"/>--}%

                                            %{--<div class="my-messages" ng-messages="ctrl.billingEditForm.expirationYear.$error" ng-if="ctrl.showMessagesEdit('expirationYear')">--}%
                                                %{--<div class="message-animation" ng-message="required">--}%
                                                    %{--<strong><g:message code="required.error.message" /></strong>--}%
                                                %{--</div>--}%
                                            %{--</div>--}%

                                            %{--<div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="2040 < ctrl.expirationYear || ctrl.expirationYear < ${new Date().format("yyyy")}">--}%
                                                %{--<div class="">--}%
                                                    %{--<g:message code="form.expYear.error.message" />--}%
                                                %{--</div>--}%
                                            %{--</div>--}%

                                        %{--</div>--}%
                                    %{--</div>--}%


                                    <div class="col-md-12">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit1('billingAddress')}">
                                            <label for="billingAddress"><g:message code="form.field.billingAddress.label" /></label>

                                            <textarea id="address_line1" name="billingAddress" class="form-control"  ng-model="ctrl.billingAddress"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="Billing Address"  required></textarea>

                                            <div class="my-messages" ng-messages="ctrl.upgradePremiumForm.billingAddress.$error" ng-if="ctrl.showMessagesEdit1('billingAddress')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit1('city')}">
                                            <label for="city"><g:message code="form.field.billingCity.label" /></label>

                                            <input id="address_city" name="city" class="form-control" type="text" ng-model="ctrl.city"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="City" ng-blur=""  required/>

                                            <div class="my-messages" ng-messages="ctrl.upgradePremiumForm.city.$error" ng-if="ctrl.showMessagesEdit1('city')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group"  style="margin-left: 10px">
                                            <label for="state"><g:message code="form.field.billingState.label" /></label>

                                            <input id="address_state" name="state" class="form-control" type="text" ng-model="ctrl.state"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="State" ng-blur="" />

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit1('zip')}">
                                            <label for="zip"><g:message code="form.field.billingZip.label" /></label>

                                            <input id="address_zip" name="zip" class="form-control" type="text" ng-model="ctrl.zip"
                                                   ng-model-options="{ updateOn : 'default blur' }" placeholder="ZIP Code" ng-blur=""  numbers-only required/>

                                            <div class="my-messages" ng-messages="ctrl.upgradePremiumForm.zip.$error" ng-if="ctrl.showMessagesEdit1('zip')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                </div>

                            </div>
                        </div>

                        <div class="receipt-modal-footer modal-footer">
                            <button type="submit" class="btn btn-primary"><g:message code="default.button.save.label" /></button>
                        </div>

                    </form>

                </div>
            </div>
        </div>
        <!-- end upgrade Premium -->


        <!-- start manage current plan -standard -->
        <div id="manageCurrentPlanStandard" class="modal fade" role="dialog">
            <div class="receipt-modal-dialog-edit modal-dialog"  style="width: 50%; height: 50%;">
                <div class="receipt-modal-content modal-content">

                    <form name="ctrl.manageCurrentPlanForm" ng-submit="ctrl.upgradeCurrentPlanStandardSave()"  novalidate >

                        <div class="receipt-modal-header modal-header">
                            <button type="button" class="receipt-close close" id ="closeButton4" aria-hidden="true">&times;</button>
                            <div class="panel-heading">
                                <div class="receipt-panel-title panel-title"><h4>Upgrade</h4></div>
                            </div>
                        </div>

                        <div class="receipt-modal-body modal-body">
                            <!--start form1 -->
                            <div class="row">

                                <div class="col-md-12">
                                    <div ng-show="ctrl.paymentProcessMessage" class="alert alert-info message-animation" role="alert" >
                                        Please wait...
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <div  ng-show="ctrl.paymentErrorMessage" class="alert alert-danger message-animation" role="alert" >
                                        {{ctrl.paymentErrorMessage}}
                                    </div>
                                </div>

                                <div class="col-md-12">


                                    <div class="col-md-6">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit2('NoOfUsers')}">
                                            <label for="name"><g:message code="form.field.NoOfUsers.label" /></label>

                                            <input id="NoOfUsers" name="NoOfUsers" class="form-control" type="number" ng-model="ctrl.NoOfUsers" step="1" min="{{ctrl.noOfUsers+1}}" ng-model-options="{ updateOn : 'default blur' }" placeholder="No.of Users" ng-blur=""  required/>

                                            <div class="my-messages" ng-messages="ctrl.manageCurrentPlanForm.NoOfUsers.$error" ng-if="ctrl.showMessagesEdit2('NoOfUsers')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="!ctrl.NoOfUsers || ctrl.NoOfUsers <= ctrl.noOfUsers">
                                                The user count should be more than current user count {{ctrl.noOfUsers}}

                                            </div>

                                        </div>
                                    </div>

                                </div>
                                <!--end form1 -->

                            </div>
                        </div>

                        <div class="receipt-modal-footer modal-footer">
                            <button type="submit" class="btn btn-primary"><g:message code="default.button.save.label" /></button>
                        </div>

                    </form>

                </div>
            </div>
        </div>
        <!-- end manage current plan -standard-->

        <!-- start manage current plan -premium-->
        <div id="manageCurrentPlanPremium" class="modal fade" role="dialog">
            <div class="receipt-modal-dialog-edit modal-dialog"  style="width: 50%; height: 50%;">
                <div class="receipt-modal-content modal-content">

                    <form name="ctrl.manageCurrentPlanForm" ng-submit="ctrl.upgradeCurrentPlanPremiumSave()"  novalidate >

                        <div class="receipt-modal-header modal-header">
                            <button type="button" class="receipt-close close" id ="closeButton5" aria-hidden="true">&times;</button>
                            <div class="panel-heading">
                                <div class="receipt-panel-title panel-title"><h4>Upgrade</h4></div>
                            </div>
                        </div>

                        <div class="receipt-modal-body modal-body">
                            <!--start form1 -->
                            <div class="row">

                                <div class="col-md-12">
                                    <div ng-show="ctrl.paymentProcessMessage" class="alert alert-info message-animation" role="alert" >
                                        Please wait...
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <div  ng-show="ctrl.paymentErrorMessage" class="alert alert-danger message-animation" role="alert" >
                                        {{ctrl.paymentErrorMessage}}
                                    </div>
                                </div>

                                <div class="col-md-12">


                                    <div class="col-md-6">
                                        <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit2('NoOfUsers')}">
                                            <label for="NoOfUsers"><g:message code="form.field.NoOfUsers.label" /></label>

                                            <input id="NoOfUsers" name="NoOfUsers" class="form-control" type="number" ng-model="ctrl.NoOfUsers" step="1" min="{{ctrl.noOfUsers+1}}" ng-model-options="{ updateOn : 'default blur' }" placeholder="No.of Users" ng-blur=""  required/>

                                            <div class="my-messages" ng-messages="ctrl.manageCurrentPlanForm.NoOfUsers.$error" ng-if="ctrl.showMessagesEdit2('NoOfUsers')">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>

                                            <div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="!ctrl.NoOfUsers || ctrl.NoOfUsers <= ctrl.noOfUsers">
                                                The user count should be more than current user count {{ctrl.noOfUsers}}
                                            </div>

                                        </div>
                                    </div>


                                </div>
                                <!--end form1 -->

                            </div>
                        </div>

                        <div class="receipt-modal-footer modal-footer">
                            <button type="submit" class="btn btn-primary"><g:message code="default.button.save.label" /></button>
                        </div>

                    </form>

                </div>
            </div>
        </div>
        <!-- end manage current plan -premium-->

        <!------------ start trial period over pop up----------->
        %{--<div id="trialPeriodOver" class="modal fade" role="dialog" >--}%
            %{--<div class="receipt-modal-dialog modal-dialog"  style="width: 100%;">--}%
                %{--<div class="receipt-modal-content modal-content">--}%
                    %{--<div class="receipt-modal-header modal-header">--}%

                        %{--<div class="panel-heading" style="margin-top: 10px;">--}%
                            %{--<div class="receipt-panel-title panel-title"><h4>Trial Period is Over</h4></div>--}%
                        %{--</div>--}%
                    %{--</div>--}%


                    %{--<div class="receipt-modal-body-billing  modal-body" style="clear: both;" >--}%




                        %{--<div class="col-md-12">--}%

                            %{--<p>Thanks for signing up for Foysonis. We hope you have been enjoying your free trial.</p>--}%
                            %{--<p><b>Unfortunately, your free trial is over now.</b></p>--}%
                            %{--<p>Please upgrade your account now.</p>--}%
                            %{----}%
                        %{--</div>--}%
                        %{--<div class="col-md-12">--}%
                            %{--<p><b><i>Foysonis Team</i></b></p>--}%
                        %{--</div>--}%


                        %{--<br style="clear:both;" />--}%


                    %{--</div>--}%



                %{--</div>--}%
            %{--</div>--}%
        %{--</div>--}%
        <!------------ end ctrial period over pop up----------->

        <!-- start upgrade from Trial -->
        <div id="upgradeFromTrial" class="modal fade" role="dialog" data-backdrop="static">
            <div class="receipt-modal-dialog-edit modal-dialog"  style="width: 50%;">

                %{--<div class="receipt-modal-dialog-edit modal-dialog" style="width: 50%; overflow: hidden;">--}%

                <div class="receipt-modal-content modal-content" >

                    <div class="receipt-modal-header modal-header">
                        <div class="panel-heading" style="margin-top: 10px;">
                            <div class="receipt-panel-title panel-title"><h4>Upgrade From Trial</h4></div>
                        </div>
                    </div>


                    <form name="ctrl.upgradeFromTrialForm" ng-submit="ctrl.upgradeFromTrialSaveAction()" >

                        <div class="receipt-modal-body modal-body">

                            <div class="col-md-12">
                                <div ng-show="ctrl.paymentProcessMessage" class="alert alert-info message-animation" role="alert" >
                                    Please wait...
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div  ng-show="ctrl.paymentErrorMessage" class="alert alert-danger message-animation" role="alert" >
                                    {{ctrl.paymentErrorMessage}}
                                </div>
                            </div>



                            <div class="row">

                                <div class="col-md-12">

                                    <p>Thank you for using Foysonis WMS. We hope Foysonis WMS adds value to your business.</p>
                                    <p>Unfortunately the current subscription appears to be expired.</p>
                                    <p>Provide your Credit card information to extend the subscription.</p>
                                    <p><b><i>Foysonis Team</i></b></p>

                                </div>

                                <legend>
                                </legend>

                                <div class="col-md-12">


                                    %{--<div class="col-md-6">--}%
                                    %{--<div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('NoOfUsers')}">--}%
                                    %{--<label for="NoOfUsers"><g:message code="form.field.NoOfUsers.label" /></label>--}%

                                    %{--<input id="NoOfUsers" name="NoOfUsers" class="form-control" type="number" ng-model="ctrl.NoOfUsers" min="{{ctrl.noOfUsers}}" ng-model-options="{ updateOn : 'default blur' }" placeholder="No.of Users" ng-blur=""  required/>--}%

                                    %{--<input ng-if="ctrl.noOfUsers < 2" id="NoOfUsers" name="NoOfUsers" class="form-control" type="number" ng-model="ctrl.NoOfUsers" min="1" ng-model-options="{ updateOn : 'default blur' }" placeholder="No.of Users" ng-blur="" required/>--}%


                                    %{--<div class="my-messages" ng-messages="ctrl.upgradeStandardForm.NoOfUsers.$error" ng-if="ctrl.showMessagesEdit3('NoOfUsers')">--}%
                                    %{--<div class="message-animation" ng-message="required">--}%
                                    %{--<strong><g:message code="required.error.message" /></strong>--}%
                                    %{--</div>--}%
                                    %{--</div>--}%

                                    %{--<div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.NoOfUsers < ctrl.noOfUsers">--}%
                                    %{--<div class="">--}%
                                    %{--<g:message code="form.NoOfUsers.error.message" />--}%
                                    %{--</div>--}%
                                    %{--</div>--}%


                                    %{--</div>--}%
                                    %{--</div>--}%


                                    %{--</div>--}%

                                    <br style="clear:both;" />
                                    <legend>
                                        <h4 style="margin-left: 40px;">Payment Information</h4>
                                    </legend>

                                    <div class="col-md-12">

                                        <input type="hidden" name="stripeToken" id="stripeToken" ng-model="ctrl.stripeToken"/>

                                        <div class="col-md-12">
                                            <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('name')}">
                                                <label for="name"><g:message code="form.field.nameOnCard.label" /></label>

                                                <input id="name" name="name" class="form-control" type="text" ng-model="ctrl.nameOnCard"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="Name on Card" ng-blur=""  required/>

                                                <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.name.$error" ng-if="ctrl.showMessagesEdit3('name')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>


                                        <div class="col-md-10">
                                            <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('creditCard')}">
                                                <label for="creditCard"><g:message code="form.field.cardNo.label" /></label>

                                                <input class="form-control"
                                                       type="text"
                                                       name="creditCard"
                                                       ng-model="ctrl.cardNumber"
                                                       required
                                                       data-credit-card-type
                                                       data-ng-minlength="15"
                                                       maxlength="16"
                                                       placeholder="Card Number"
                                                       id="cc_number"
                                                       numbers-only required/>

                                                <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.creditCard.$error" ng-if="ctrl.showMessagesEdit3('creditCard')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                                <div class="my-messages" style="text-align: left;color: red;" role="alert" ng-if="ctrl.viewResult && ccinfo.type!='Invalid card number'">
                                                    Invalid card number.
                                                </div>


                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group"  style="margin-left: 10px; margin-top: 30px;">
                                                <span><img  ng-if="ccinfo.type=='mastercard'" src="${request.contextPath}/foysonis2016/app/img/MasterCard_logo.png" class="cardLogo"/></span>
                                                <span><img  ng-if="ccinfo.type=='visa'" src="${request.contextPath}/foysonis2016/app/img/Visa_Logo.png" class="cardLogo"/></span>
                                                <span><img  ng-if="ccinfo.type=='amex'" src="${request.contextPath}/foysonis2016/app/img/AmericanExpress_logo.png" class="cardLogo"/></span>
                                                <span><img  ng-if="ccinfo.type=='discover'" src="${request.contextPath}/foysonis2016/app/img/discoverCard-logo.png" class="cardLogo"/></span>
                                                <span class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ccinfo.type=='Invalid card number'" >{{ccinfo.type}}.</span>
                                            </div>
                                        </div>


                                        <div class="col-md-6">
                                            <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('cvc')}">
                                                <label for="cvc"><g:message code="form.field.cvc.label" /></label>

                                                <input id="cvc" name="cvc" class="form-control" type="text" ng-model="ctrl.cvc"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="CVC" ng-blur="" numbers-only required/>

                                                <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.cvc.$error" ng-if="ctrl.showMessagesEdit3('cvc')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>


                                        <div class="col-md-6">

                                            <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('expirationMonth')}">
                                                <label for="expirationDate"><g:message code="form.field.expiration.label" /></label>

                                                <input id="exp_month" name="expirationMonth" class="form-control" type="text" ng-model="ctrl.expirationMonth" maxlength="2"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="mm" ng-blur=""  numbers-only required style="width: 70px;"/>

                                                <input id="exp_year" name="expirationYear" class="form-control" type="text" ng-model="ctrl.expirationYear"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="yyyy" ng-blur=""  numbers-only required maxlength="4"
                                                       style="margin-top:-37px; margin-left:90px; width: 83px;"/>

                                                <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.expirationMonth.$error" ng-if="ctrl.showMessagesEdit3('expirationMonth')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                                <div class="my-messages" style="text-align: left;color: red;" role="alert"  ng-if="ctrl.expirationMonth > 12
                                        || 2040 < ctrl.expirationYear || ctrl.expirationYear < ${new Date().format("yyyy")}
                                        || (ctrl.expirationMonth < ${new Date().format("MM")} && ctrl.expirationYear == ${new Date().format("yyyy")})">
                                                    <div class="">
                                                        <g:message code="form.expMonth.error.message" />
                                                    </div>
                                                </div>


                                            </div>
                                        </div>


                                        <div class="col-md-12">
                                            <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('billingAddress')}">
                                                <label for="billingAddress"><g:message code="form.field.billingAddress.label" /></label>

                                                <textarea id="address_line1" name="billingAddress" class="form-control"  ng-model="ctrl.billingAddress"
                                                          ng-model-options="{ updateOn : 'default blur' }" placeholder="Billing Address"  required></textarea>

                                                <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.billingAddress.$error" ng-if="ctrl.showMessagesEdit3('billingAddress')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('city')}">
                                                <label for="city"><g:message code="form.field.billingCity.label" /></label>

                                                <input id="address_city" name="city" class="form-control" type="text" ng-model="ctrl.city"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="City" ng-blur=""  required/>

                                                <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.city.$error" ng-if="ctrl.showMessagesEdit3('city')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group"  style="margin-left: 10px">
                                                <label for="state"><g:message code="form.field.billingState.label" /></label>

                                                <input id="address_state" name="state" class="form-control" type="text" ng-model="ctrl.state"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="State" ng-blur="" />

                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group"  style="margin-left: 10px" ng-class="{'has-error':ctrl.hasErrorClassEdit3('zip')}">
                                                <label for="zip"><g:message code="form.field.billingZip.label" /></label>

                                                <input id="address_zip" name="zip" class="form-control" type="text" ng-model="ctrl.zip"
                                                       ng-model-options="{ updateOn : 'default blur' }" placeholder="ZIP Code" ng-blur=""  numbers-only required/>

                                                <div class="my-messages" ng-messages="ctrl.upgradeStandardForm.zip.$error" ng-if="ctrl.showMessagesEdit3('zip')">
                                                    <div class="message-animation" ng-message="required">
                                                        <strong><g:message code="required.error.message" /></strong>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                    </div>


                                </div>
                            </div>

                            <div class="receipt-modal-footer modal-footer">
                                <button type="submit" class="btn btn-primary"><g:message code="default.button.save.label" /></button>
                            </div>

                    </form>

                </div>

                %{--</div>--}%

            </div>
        </div>
        <!-- end upgrade from Trial-->


        <!-- Start Upgrade Trial End Warning-->
        <div id="warningTrialEndMessage" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Subscription Expiration</h4>
                    </div>
                    <div class="modal-body">
                        <p>Thank you for using Foysonis WMS. We hope Foysonis WMS adds value to your business.</p>
                        <p><b>Unfortunately the current subscription appears to be expired.</b></p>
                        <p>Please upgrade your account now.</p>
                        <p><b><i>Foysonis Team</i></b></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Upgrade Trial End Warning -->

        <!-- start No Credit Card-->
        <div id="noCreditCard" class="modal fade" role="dialog">
            <div class="receipt-modal-dialog-edit modal-dialog" style="width: 40%; height: 50%;">
                <div class="receipt-modal-content modal-content">
                    <div class="receipt-modal-header modal-header">
                        <button type="button" class="receipt-close close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title" style="color: #fff;">No Credit Card Found</h4>
                    </div>
                    <div class="modal-body">
                        There is no credit card associated with your account. Please enter your credit card details.
                    </div>
                    <div class="receipt-modal-footer modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                    </div>
                </div>
            </div>
        </div>
        <!-- end No Credit Card-->


    </div>



    <div id="userDeleteWarning" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Confirmation</h4>
                </div>
                <div class="modal-body">
                    <g:message code="user.delete.warning.message" />
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><g:message code="default.button.cancel.label" /></button>
                    <button type="button" id = "deleteUserButtonFromPopUp" class="btn btn-primary"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>    

    <div id="userCannotBeEditedWarning" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Warning</h4>
                </div>
                <div class="modal-body">
                    <g:message code="user.cannotEdit.warning.message" />
                </div>
                <div class="modal-footer">
                    <button type="button" id = "editUserButtonFromPopUp" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>    
    <div id="userCannotBeDeletedWarning" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Warning</h4>
                </div>
                <div class="modal-body">
                    <g:message code="user.cannotDelete.warning.message" />
                </div>
                <div class="modal-footer">
                    <button type="button" id = "editUserButtonFromPopUp" class="btn btn-primary" data-dismiss="modal"><g:message code="default.button.ok.label" /></button>
                </div>
            </div>
        </div>
    </div>




    <asset:javascript src="datagrid/admin-user.js"/>

    <script type="text/javascript">
        var dvAdminUser = document.getElementById('dvAdminUser');
        angular.element(document).ready(function() {
            angular.bootstrap(dvAdminUser, ['adminUser']);
        });
    </script>

    <asset:javascript src="datagrid/admin-billing.js"/>


</body>
</html>