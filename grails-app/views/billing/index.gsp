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

    <script type="text/javascript" src="https://js.stripe.com/v2/"></script>
    <script type="text/javascript">
//        Stripe.setPublishableKey('pk_live_fZ3GjdCVZnXCQ5mIQ5lQoBem');
        Stripe.setPublishableKey('pk_test_VukkoSDQFtWsdcc5CTd8i6bK');
    </script>


<style>

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
    width: 100%;
}

.noItemMessage {
    position: absolute;
    top : 20%;
    opacity: 0.4;
    font-size: 40px;
    width: 100%;
    text-align: center;
    z-index: auto;
}

.cardLogo {
    width: 50px;
}

.payDataAttr{
    padding-bottom: 20px;
}

.payDataValue{
    padding-bottom: 20px;
}


    </style>



</head>

<body>

    <div ng-cloak id="dvAdminUserBilling" ng-controller="MainCtrl as ctrl">

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


        <!-- START Billing Button-->
        <div ng-show="ctrl.showBillingButton == true && 1 == 2" class="row" style="padding-left: 15px;">

            <button ng-if="ctrl.planDetails == 'Individual'" type="button" class="btn btn-primary pull-left" ng-click ="ctrl.openBilling()" >
                <g:message code="default.button.upgrade.label" />
            </button>

            <!-- START button group-->
            <div class="btn-group mb-sm" ng-if="ctrl.planDetails == 'Standard'">
                <button type="button" class="btn btn-primary" ng-click ="ctrl.openBilling()">
                    <g:message code="default.button.upgrade.label" /></button>
                <button type="button" data-toggle="dropdown" class="btn btn-primary dropdown-toggle" style="width: 0px;">
                    <span class="caret"></span>
                </button>
                <ul role="menu" class="dropdown-menu">
                    <li>
                        <a href="javascript:void(0);" ng-click ="ctrl.upgradeCurrentPlanStandard()"><g:message code="default.button.buyMoreUsers.label" /></a>
                    </li>
                </ul>
            </div>
            <!-- END button group-->

            <button type="button" class="btn btn-primary pull-left" ng-click ="ctrl.openBuyMoreUsers()" ng-if="ctrl.planDetails == 'Premium'">
                <g:message code="default.button.buyMoreUsers.label" />
            </button>

        </div>

        <!-- END Billing Button-->
        <br style="clear: both;"/>

        <div class="row">
            <div class="panel panel-default">
                <div class="panel-body">
                    <!-- <div class="col-md-3"></div> -->
                    <div class="col-md-9">

                        <!-- <div class="col-md-3"></div>
 -->
                        <!-- <div class="col-md-9" style="font-size: 15px; text-align: left;"> -->

                            <div class="col-md-4 payDataAttr">Subscription Status</div>
                            <div class="col-md-8 payDataValue"><label>{{ctrl.subscriptionStatus}}</label></div>
                            <br style="clear: both;">
                            
                            <div class="col-md-4 payDataAttr">Plan Details</div>
                            <div class="col-md-8 payDataValue"><label>{{ctrl.viewPlan}}&nbsp;({{ctrl.currentCost | currency}} / {{ctrl.period}})</label>&emsp;
                                <button ng-if= "ctrl.planDetails != 'Premium' && ctrl.planDetails != 'Enterprise' && ctrl.planDetails != 'Premium-V2'" class="btn btn-primary" style="padding: 0px 20px !important; height: 30px;" type="button" ng-click="ctrl.upgrade()" >
                                    <g:message code="default.button.upgrade.label" />
                                </button>
                            </div>
                            <br style="clear: both;">

                            <div class="col-md-4 payDataAttr" >No. of Users</div>
                            <div class="col-md-8 payDataValue"><label>{{ctrl.noOfUsers}}</label>&emsp;
                                <button ng-if="ctrl.planDetails == 'Standard'" class="btn btn-primary" style="padding: 0px 20px !important; height: 30px;" type="button" ng-click="ctrl.upgradeCurrentPlanStandard()" >
                                    <g:message code="default.button.buyMoreUsers.label" />
                                </button>
                                <button ng-if="ctrl.planDetails == 'Premium'" class="btn btn-primary" style="padding: 0px 20px !important; height: 30px;" type="button" ng-click="ctrl.openBuyMoreUsers()" >
                                <g:message code="default.button.buyMoreUsers.label" />
                                </button>
                            </div>
                            <br style="clear: both;">

                            <div class="col-md-4 payDataAttr">Cost per additional user</div>
                            <div class="col-md-8 payDataValue"><label>
                                <label ng-if="ctrl.planDetails == 'Individual'">No additional Users allowed for your plan, please Upgrade to Standard or Premium</label>
                                <label ng-if="ctrl.planDetails == 'Standard'">$15.00</label>
                                <label ng-if="ctrl.planDetails == 'Premium'">$20.00</label>
                                <label ng-if="ctrl.planDetails == 'Premium-V2'">$49.00</label>
                                </label>
                            </div>
                            <br style="clear: both;">

                            <div class="col-md-4 payDataAttr">Next Charge Amount</div>
                            <div class="col-md-8 payDataValue"><label>{{ctrl.viewTotalAmount | currency}}</label></div>
                            <br style="clear: both;">
                            
                            <div class="col-md-4 payDataAttr">Next Charge Date</div>
                            <div class="col-md-8 payDataValue"><label>{{ctrl.nextPayment | date}}</label></div>
                            <br style="clear: both;">
                            
                            <div class="col-md-4 payDataAttr">Payment Method / Credit Card</div>
                            <div class="col-md-8 payDataValue"><label>{{ctrl.paymentMethod}}</label>&emsp;
                                %{--<label>{{ccinfo.type}}</label>&emsp;--}%
                                <button  class="btn btn-primary" style="padding: 0px 20px !important; height: 30px;" type="button" ng-click="ctrl.edit()">Edit </button>
                            </div>
                            <br style="clear: both;">

                            <div class="col-md-4 payDataAttr" >Past Payments</div>
                            <div class="col-md-8 payDataValue">
                                <button class="btn btn-primary" style="padding: 0px 20px !important; height: 30px;" type="button" ng-click="ctrl.payment()">View Payment History</button>
                            </div>
                            <br style="clear: both;">
                            

                            <div ng-if="ctrl.isTrialPeriod == true" class="">
                                <div class="col-md-4 payDataAttr">Remaining Days on Trial</div>
                                <div class="col-md-8 payDataValue"><label style="margin-left: 220px;">{{ctrl.remainingDaysOnTrial}}</label></div>
                            </div>
                            


                        <!-- </div> -->

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


                                <div class="" ng-if="ctrl.planDetails != 'Individual'">Payment Method / Credit Card
                                    <label style="margin-left: 262px;">{{ctrl.paymentMethod}}</label>&emsp;
                                    %{--<label style="margin-left: 262px;">{{ccinfo.type}}</label>&emsp;--}%
                                    <button  class="btn btn-primary" style="padding: 0px 20px !important; height: 30px;" type="button" style="height: 50px;" ng-click="ctrl.edit()">
                                        Edit
                                    </button>
                                </div>
                                <br style="clear:both;" />


                                <div class="" ng-if="ctrl.planDetails != 'Individual'">Past Payments
                                    <button class="btn btn-primary" style="padding: 0px 20px !important; margin-left: 280px; height: 30px;" type="button" style="height: 40px; " ng-click="ctrl.payment()">
                                        View Payment History</button>
                                </div>
                                <br style="clear:both;" />


                            </div>

                        </div>


                        <br style="clear:both;" />


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

                        <div id="grid1" ui-grid="gridHistory" ui-grid-exporter ui-grid-pinning ui-grid-resize-columns ui-grid-auto-resize class="historyGrid"></div>
                        %{--<div ng-if='columnChanged'></div>--}%
                        <div class="noItemMessage" ng-if="gridHistory.data.length == 0">History Not Found</div>

                    </div>

                    <div class="receipt-modal-footer modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
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
                                <div class="table-responsive" style="padding-left: 10%; padding-right: 10%;">

                                    <h3>Run your Business Efficiently</h3>
                                    <h4>Upgrade your plan to save time and improve your bottom line</h4>
                                    <table class="table table-striped table-bordered table-hover">
                                        <thead>
                                        <tr>
                                            <th style="text-align:center; background-color:#015B91; color: white; width: 33%;">
                                                <span style="font-size: 20px; text-transform: uppercase;">Individual</span>
                                                <br><span style="font-size: 12px;">&nbsp;</span></th>

                                            <th style="text-align: center;background-color:#1BA39C; color: white; width: 33%;">
                                                <span style="font-size: 20px; text-transform: uppercase;">Standard</span>
                                                <br><span style="font-size: 12px;">(MOST POPULAR)</span></th>

                                            <th style="text-align: center;background-color:#015B91; color: white; width: 34%;">
                                                <span style="font-size: 20px; text-transform: uppercase;">Premium</span>
                                                <br><span style="font-size: 12px;">&nbsp;</span></th>
                                                </th>

                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td style="text-align: center; font-size: 15px; background-color: #DFECF4;">
                                                <b>$9</b> per month <br>
                                                Includes 1 User <br>
                                                No Additional user allowed
                                            </td>
                                            <td style="text-align: center; font-size: 15px; background-color: #D7ECEB;">
                                                <b>$49</b> per month <br>
                                                Includes 2 Users<br>
                                                $15 / Additional user
                                            </td>
                                            <td style="text-align: center; font-size: 15px; background-color: #DFECF4;">
                                                <b>$99</b> per month <br>
                                                Includes 5 Users<br>
                                                $20 / Additional user
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Receiving and Putaway
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Receiving and Putaway
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Receiving and Putaway
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Orders, Shipment and Allocation
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Orders, Shipment and Allocation
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Orders, Shipment and Allocation
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Picking and Replenishments
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Picking and Replenishments
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Picking and Replenishments
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Inventory Management
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Inventory Management
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Inventory Management
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Reports
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Reports
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Reports
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Item Management
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Item Management
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Item Management
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Dashboard
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Dashboard
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Dashboard
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                100 Items Allowed
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Unlimited Items Allowed
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Unlimited Items Allowed
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                300 Locations Allowed
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Unlimited Locations Allowed
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Unlimited Locations Allowed
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;">
                                                &nbsp;
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                WMS app for iOS - (Coming Soon)
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                WMS app for iOS - (Coming Soon)
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;">
                                                &nbsp;
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Email(Four hours response time)
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Email(Four hours response time)
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;">
                                                &nbsp;
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Chat Online with Live Person
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Chat Online with Live Person
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;">
                                                &nbsp;
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;">
                                                &nbsp;
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Kitting - (Coming Soon)
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;">
                                                &nbsp;
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;">
                                                &nbsp;
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Client Billing (3PL)
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;">
                                                &nbsp;
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;">
                                                &nbsp;
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                Client Portal
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left; padding-left: 20px;">
                                                &nbsp;
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;">
                                                &nbsp;
                                            </td>
                                            <td style="text-align: left; padding-left: 20px;"><em class="fa fa-circle" style="color: #315B91;"></em>
                                                24 x 7 Phone Support(Talk to Live Person)
                                            </td>
                                        </tr>
                                        <tr style="text-align: center">
                                            <td></td>
                                            <td>
                                                <button ng-if="ctrl.planDetails == 'Individual'" type="button" class="btn btn-primary" ng-click="ctrl.upgradeStandard()"><g:message code="default.button.upgrade.label" /></button>
                                            </td>
                                            <td>
                                                <button ng-if="ctrl.planDetails == 'Individual' || ctrl.planDetails == 'Standard'" type="button" class="btn btn-primary" ng-click="ctrl.upgradePremium()"><g:message code="default.button.upgrade.label" /></button>
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

                                <div class="col-md-12" ng-if="ctrl.isTrialPeriod == true">
                                    <div class="alert alert-warning" style="background-color: #F7F7F7; color: #000; font-weight: bold;">
                                        <g:message code="companyBilling.trialPeriod.BuyUser.Message" />
                                    </div>
                                </div>

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

                                <div class="col-md-12" ng-if="ctrl.isTrialPeriod == true">
                                    <div class="alert alert-warning" style="background-color: #F7F7F7; color: #000; font-weight: bold;">
                                        <g:message code="companyBilling.trialPeriod.BuyUser.Message" />
                                    </div>
                                </div>

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




    <asset:javascript src="datagrid/admin-user-billing.js"/>

    <script type="text/javascript">
        var dvAdminUserBilling = document.getElementById('dvAdminUserBilling');
        angular.element(document).ready(function() {
            angular.bootstrap(dvAdminUserBilling, ['adminUserBilling']);
        });
    </script>

    <asset:javascript src="datagrid/admin-billing.js"/>


</body>
</html>
