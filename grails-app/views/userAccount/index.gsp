<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2016-07-21
  Time: 10:17 AM
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
    <asset:javascript src="dragAndDrop/angular-drag-and-drop-lists"/>
    <asset:javascript src="ng-img-crop.js"/>
    %{--<link rel="stylesheet" href="http://ui-grid.info/release/ui-grid.css" type="text/css">--}%
    %{--<asset:stylesheet src="datagrid/ui-grid.css"/>--}%

    %{--Sign Up Form--}%
    <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>
    <asset:stylesheet src="ng-img-crop.css"/>


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

    hr {
        border-style: solid;
        border-width: 2px;
    }

    .labelLook{
        font-size: 15px;
        font-weight: normal;
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

    .comInfo {
        border-left: 4px solid #315d90;
        box-shadow: -13px 2px 16px -13px rgba(0,0,0,0.5);
        padding-top: 10px;
        /*height:208px;*/
    }

    .trial-modal-dialog {
        width: 80%;
        height: 100%;
        margin: 0;
        padding: 0;
        margin-right: 10%;
        margin-left: 10%;    
        text-align: center;
    }

    .trial-modal-content {
        height: auto;
        min-height: 100%;
        border-radius: 0;
    }


    .trial-modal-header {
        background: #547CA2;
        height: 70px;
    }

    .terms-box-highlight {
        background-color: rgba(245, 245, 162, 0.26);
        border: 2px solid #b2b200;
        padding: 5px;
    }
    .trial-modal-body {
        position: fixed;
        top: 70px;
        bottom: 70px;
        width: inherit;
        overflow: scroll;
        padding: 15px
    }

    .trial-modal-footer {
        position: fixed;
        right: 0;
        bottom: 0;
        left: 0;
        border-top: 2px solid #547CA2;
        height: 70px;
    }

    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    </style>

    <%-- **************************** End of CSS **************************** --%>

</head>

<body>


<div ng-cloak class="row" id="dvUserAccountProfile" ng-controller="userProfileCtrl as ctrl">

    <div class="col-lg-12">

        <div style="display: inline;"><em class="fa  fa-fw mr-sm" ><img style="width: 40px; padding-bottom: 3px;" src="/foysonis2016/app/img/userrProInfo_header.svg"></em>&emsp;&emsp;<span class="headerTitle" style="vertical-align: bottom;">User Profile Info
        </span></div>
        <br style="clear: both;">
        <br style="clear: both;">

        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showTermsAcceptedPrompt">
            <g:message code="userProfile.termsAccepted.message" />
        </div>


        <!-- <h3>User Profile Info</h3> -->
        <!-- START panel-->
        <%-- **************************** create user profile form **************************** --%>

        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showUpdatedPrompt">
            <g:message code="userProfile.updated.message" />
        </div>

        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showPasswordUpdatedPrompt">
            Password Updated Succesfully
        </div>

        <form name="ctrl.updateUserInfoForm" ng-submit="ctrl.updateUser()" novalidate  ng-hide="ctrl.changePassword" >

            <div class="panel panel-default" id="panel-anim-fadeInDown">
                <div class="panel-heading">
                    <div class="panel-title">
                        <button class="btn btn-warning pull-right" type="button" ng-click="ctrl.editUser()" ng-if="!ctrl.profileEditable">
                            <em class="fa fa-edit fa-fw mr-sm"></em>Edit</button>

                    </div>
                </div>
                <div class="panel-body" ng-show="ctrl.profileEditable">
                    <div class="col-md-12">
                        <div class="col-md-3">
                            <label>Select user image : </label>
                            <div ><input type="file" id="fileInput" /></div>
                            <div class='compLogo'><img src="{{myCroppedImage}}" /></div>
                            <br style="clear:both;" />
                            <p ng-if='invalidFileSize' style="color:#F51B1B; font-weight:bold; font-size: 13px;">The file is bigger than 1MB.</p>
                            <p ng-if='invalidFileType' style="color:#F51B1B; font-weight:bold; font-size: 13px;">This is an invalid file type, Please upload a file in JPEG or PNG formats </p>
                        </div>
                        <div class="col-md-6">

                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('firstName')}">
                                <label for="firstName">First Name</label>
                                <input id="firstName" name="firstName" class="form-control" type="text"    ng-model="ctrl.userInfo.firstName" ng-model-options="{ updateOn : 'blur' }" required />


                                <div class="my-messages" ng-messages="ctrl.updateUserInfoForm.firstName.$error" ng-if="ctrl.showMessages('firstName')">
                                    <div class="message-animation" ng-message="required">
                                        <strong>This field is required.</strong>
                                    </div>
                                </div>

                            </div>


                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('lastName')}">
                                <label for="lastName">Last Name</label>
                                <input id="lastName" name="lastName" class="form-control" type="text"    ng-model="ctrl.userInfo.lastName" ng-model-options="{ updateOn : 'blur' }" required />


                                <div class="my-messages" ng-messages="ctrl.updateUserInfoForm.lastName.$error" ng-if="ctrl.showMessages('lastName')">
                                    <div class="message-animation" ng-message="required">
                                        <strong>This field is required.</strong>
                                    </div>
                                </div>

                            </div>

                            <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass('email')}">
                                <label for="email">Email</label>
                                <input id="email" name="email" class="form-control" type="email" ng-model="ctrl.userInfo.email"  placeholder="Email" />

                                <div class="my-messages" ng-messages="ctrl.updateUserInfoForm.email.$error" ng-if="!ctrl.updateUserInfoForm.email.$valid">
                                    <div class="message-animation" ng-message="email">
                                        <strong>Please enter a valid email.</strong>
                                    </div>
                                </div>

                            </div>

                            <div class="form-group">
                                <label for="email">Default Printer </label>
                                <select id="storageAttributes" name="storageAttributes" data-ng-model="ctrl.userInfo.defaultPrinter"
                                        ng-options="option.displayName for option in ctrl.defaultPrinterOptions track by option.id" class="form-control">
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="email">Default Label Printer</label>
                                <select id="storageAttributes" name="storageAttributes" data-ng-model="ctrl.userInfo.labelPrinter"
                                        ng-options="option.displayName for option in ctrl.defaultLabelOptions track by option.id" class="form-control">
                                </select>
                            </div>


                        </div>

                </div>

                </div>



                <div class="panel-body" ng-hide="ctrl.profileEditable">
                    <div class="col-md-12">
                        <div class="col-md-3">
                            <label>User Image</label>
                            <!-- <div class="cropArea">
                                                        <img-crop image="myImage" area-type="square" result-image-size="200" result-image="myCroppedImage"></img-crop>
                                                        </div> -->
                            <div class='compLogo'><img src="{{myCroppedImage}}" /></div>
                            <br style="clear:both;" />
                        </div>
                        <div class="col-md-9 comInfo">

                            <label class="labelLook"><span>First Name</span>&emsp;&emsp;:&emsp;{{ctrl.userInfo.firstName}}</label>
                            <br style="clear:both;" />
                            <br style="clear:both;" />

                            <label class="labelLook">Last Name&emsp;&emsp;:&emsp;{{ctrl.userInfo.lastName}}</label>
                            <br style="clear:both;" />
                            <br style="clear:both;" />

                            <label class="labelLook">Email&emsp;&emsp;&emsp;&emsp;&nbsp;:&emsp;{{ctrl.userInfo.email}}</label>
                            <br style="clear:both;" />
                            <br style="clear:both;" />

                            <label class="labelLook">Password&emsp;&emsp;&nbsp;:&emsp;
                                <button class="btn btn-primary" style="padding: 0px 20px !important;" type="button" style="height: 40px;" ng-click="ctrl.editPassword()" ng-if="!ctrl.profileEditable" ng-hide="ctrl.changePassword">
                                Change Password</button>
                            </label>
                            <br style="clear:both;" />
                            <br style="clear:both;" />

                            <label class="labelLook">Default Printer&nbsp;:&emsp;{{ctrl.userInfo.defaultPrinter.displayName}}</label>
                            <br style="clear:both;" />
                            <br style="clear:both;" />

                            <label class="labelLook">Label Printer&emsp;&nbsp;:&emsp;{{ctrl.userInfo.labelPrinter.displayName}}</label>
                            <br style="clear:both;" />
                            <br style="clear:both;" />

                        </div>
                    </div>
                </div>

                <div class="panel-footer">

                    %{--<button class="btn btn-warning pull-right" type="button" ng-click="ctrl.editPassword()" ng-if="!ctrl.profileEditable" ng-hide="ctrl.changePassword">--}%
                    %{--<em class="fa fa-edit fa-fw mr-sm"></em>Change Password</button>--}%


                    <div class="pull-right" ng-show="ctrl.profileEditable">
                        <button class="btn btn-primary" type="submit">Update</button>
                    </div>
                    <div class="pull-left" ng-show="ctrl.profileEditable">
                        <button class="btn btn-default" type="button" ng-click="ctrl.cancelUpdateCompany()">Cancel</button>
                    </div>
                    <br style="clear: both;"/>
                </div>
            </div>
        </form>
        <%-- **************************** End of user profile form **************************** --%>


        <%-- **************************** start update password form **************************** --%>
        <div class="panel panel-default" id="panel-anim-fadeInDown" ng-show="ctrl.changePassword">
        <form name="ctrl.updatePasswordForm" ng-submit="ctrl.updatePassword()" novalidate >

            <div class="panel-body">
                <div class="col-md-12">

                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass1('currentPassword')}">
                        <label for="currentPassword">Current Password</label>
                        <input id="currentPassword" name="currentPassword" class="form-control" type="password" ng-model="ctrl.userInfo.currentPassword"
                                ng-blur="ctrl.passwordUniqueValidation(ctrl.userInfo.username)" required />

                        <div class="my-messages" ng-messages="ctrl.updatePasswordForm.currentPassword.$error" ng-if="ctrl.updatePasswordForm.$error.passwordExists">
                            <div class="message-animation">
                                <strong>Current Password Not Matched</strong>
                            </div>
                        </div>


                        <div class="my-messages" ng-messages="ctrl.updatePasswordForm.currentPassword.$error" ng-if="ctrl.showMessages1('currentPassword')">
                            <div class="message-animation" ng-message="required">
                                <strong>This field is required.</strong>
                            </div>
                        </div>

                    </div>

                </div>

                <div class="col-md-12">

                    <div class="form-group">
                        <label for="newPassword">New Password</label>

                        <div class="input-group" ng-class="{'has-error':ctrl.hasErrorClass1('newPassword')}" ng-if="!ctrl.userInfo.hiddenUsername">
                            <input id="newPassword" name="newPassword" class="form-control" required
                                   type="{{ctrl.getPasswordType()}}"
                                   ng-model-options="{ updateOn : 'default blur' }"
                                   ng-model="ctrl.userInfo.newPassword"
                                   validate-password-characters />
                            <span class="input-group-addon">
                                <input type="checkbox" ng-model="ctrl.updatePasswordForm.showPassword"> Show
                            </span>
                        </div>
                        <div class="input-group" ng-class="{'has-error':ctrl.hasErrorClass1('newPassword')}" ng-if="ctrl.userInfo.hiddenUsername">
                            <input id="newPassword" name="newPassword" class="form-control"
                                   type="{{ctrl.getPasswordType()}}"
                                   ng-model-options="{ updateOn : 'default blur' }"
                                   ng-model="ctrl.userInfo.newPassword"
                                   validate-password-characters-for-edit />
                            <span class="input-group-addon">
                                <input type="checkbox" ng-model="ctrl.updatePasswordForm.showPassword"> Show
                            </span>
                        </div>

                        <div class="my-messages" ng-messages="ctrl.updatePasswordForm.newPassword.$error" ng-if="ctrl.showMessages1('newPassword')">
                            <div class="message-animation" ng-message="required">
                                <strong><g:message code="required.error.message" /></strong>
                            </div>
                        </div>

                        <div class="password-requirements" ng-if="!ctrl.updatePasswordForm.newPassword.$valid">
                            <ul class="float-left">
                                <li ng-class="{'completed':!ctrl.updatePasswordForm.newPassword.$error.lowerCase}">One lowercase character</li>
                                <li ng-class="{'completed':!ctrl.updatePasswordForm.newPassword.$error.upperCase}">One uppercase character</li>
                                <li ng-class="{'completed':!ctrl.updatePasswordForm.newPassword.$error.number}">One number</li>
                            </ul>
                            <ul class="selfclear clearfix">
                                <li ng-class="{'completed':!ctrl.updatePasswordForm.newPassword.$error.specialCharacter}">One special character</li>
                                <li ng-class="{'completed':!ctrl.updatePasswordForm.newPassword.$error.eightCharacters}">Eight characters minimum</li>
                            </ul>
                        </div>

                        <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.updatePasswordForm.newPassword.$valid" style="margin-top: 5px;">
                            %{--Your password is secure and you are good to go!--}%
                            <g:message code="user.password.message" />
                        </div>
                    </div>

                </div>

                <div class="col-md-12">

                    <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass1('confirmPassword')}">
                        <label for="confirmPassword">Confirm New Password</label>
                        <input id="confirmPassword" name="confirmPassword" class="form-control" type="password" ng-model="ctrl.userInfo.confirmPassword" required
                               ng-disabled="!ctrl.updatePasswordForm.newPassword.$valid" ng-blur=""/>

                        <div class="my-messages" ng-messages="ctrl.updatePasswordForm.confirmPassword.$error" ng-if="ctrl.userInfo.confirmPassword && ctrl.userInfo.newPassword != ctrl.userInfo.confirmPassword">
                            <div class="message-animation">
                                <strong>Confirm password did not match with new password</strong>
                            </div>
                        </div>


                        <div class="my-messages" ng-messages="ctrl.updatePasswordForm.confirmPassword.$error" ng-if="ctrl.showMessages1('confirmPassword')">
                            <div class="message-animation" ng-message="required">
                                <strong>This field is required.</strong>
                            </div>
                        </div>

                    </div>

                </div>

            </div>

            <div class="panel-footer">

                <div class="pull-right" ng-show="ctrl.changePassword">
                    <button class="btn btn-primary" type="submit">Update</button>
                </div>
                <div class="pull-left" ng-show="ctrl.changePassword">
                    <button class="btn btn-default" type="button" ng-click="ctrl.cancelUpdateCompany()">Cancel</button>
                </div>
                <br style="clear: both;"/>
            </div>

        </form>
    </div>

        <%-- **************************** end update password form **************************** --%>
    </div>

    <div id="cropImageModel" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Crop Image</h4>
                </div>
                <div class="modal-body">
                    <div class="cropArea">
                        <img-crop image="myImage" area-type="square" result-image-size="200"  result-image="myCroppedImage"></img-crop>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>



    <div id="trialEndWarning" class="modal fade" role="dialog" data-backdrop="static">
        <div class="trial-modal-dialog modal-dialog" style="padding-right: 10%; padding-left: 10%;">
            <div class="trial-modal-content modal-content">
                <div class="trial-modal-header modal-header">
                    <h4 style="color: #fff;">Subscription Expiration</h4>
                </div>
                <div class="modal-body">
                    <p>Thank you for using Foysonis WMS. We hope Foysonis WMS adds value to your business.</p>
                    <p>Unfortunately the current subscription appears to be expired. Please contact your Administrator for extending the subscription for your company.</p>
                    <p><b><i>Foysonis Team</i></b></p>
                    <br style="clear: both;"/>
                </div>

            </div>
        </div>
    </div>

    <div id="termsAndConditions" class="modal fade" role="dialog" data-backdrop="static">
        <div class="trial-modal-dialog modal-dialog" >
            <div class="trial-modal-content modal-content">
                <div class="trial-modal-header modal-header">
                    <h4 style="color: #fff;">Terms and Conditions</h4>
                </div>
                <div class="modal-body trial-modal-body">
                    <ol style="text-align: justify;">

                        <div>

                            <p>
                                The following terms and conditions govern all use of the Foysonis.com website and all
                                content, services, and products available at or through the website, including, but not
                                limited to, Foysonis WMS. Our Services are offered subject to your acceptance without
                                modification of all of the terms and conditions contained herein and all other operating
                                rules, policies (including, without limitation, Foysonis Privacy Policy) and procedures
                                that
                                may be published from time to time by Foysonis(collectively, the "Agreement"). You agree
                                that we may automatically upgrade our Services, and these terms will apply to any
                                upgrades.
                            </p>

                            <p>
                                Please read this Agreement carefully before accessing or using our Services. By
                                accessing or
                                using any part of our services, you agree to become bound by the terms and conditions of
                                this agreement. If you do not agree to all the terms and conditions of this agreement,
                                then
                                you may not access or use any of our services. If these terms and conditions are
                                considered
                                an offer by Foysonis, acceptance is expressly limited to these terms.
                            </p>

                            <p>
                                Our Services are not directed to children younger than 13, and access and use of our
                                Services is only offered to users 13 years of age or older. If you are under 13 years
                                old,
                                please do not register to use our Services. Any person who registers as a user or
                                provides
                                their personal information to our Services represents that they are 13 years of age or
                                older.
                            </p>
                            <p>
                                Use of our Services requires a Foysonis.com account. You agree to provide us with
                                complete
                                and accurate information when you register for an account. You will be solely
                                responsible
                                and liable for any activity that occurs under your username. You are responsible for
                                keeping
                                your password secure.
                            </p>
                        </div>

                        <li><h3>Foysonis.com</h3>

                            <ul>
                                <li>
                                    <b>Your Foysonis.com Account and Website.</b> If you create an account on
                                Foysonis.com, you are responsible for maintaining the security of your account, and
                                you are fully responsible for all activities that occur under the account and any
                                other actions taken in connection with the account. You must immediately notify
                                Foysonis of any unauthorized uses of your your account, or any other breaches of
                                security. Foysonis will not be liable for any acts or omissions by you, including
                                any damages of any kind incurred as a result of such acts or omissions
                                </li>
                                <li>
                                    <b>Responsibility of Account Holders.</b> If you operate a warehouse, or otherwise
                                make (or allow any third party to make) changes to data, you are entirely
                                responsible for the data, and any harm resulting from, that data or your conduct.
                                That is the case regardless of what form the data takes, which includes, but is not
                                limited to text, photo, video, audio, or code. By using Foysonis.com, you represent
                                and warrant that your Content and conduct do not violate these terms. By submitting
                                data to Foysonis for inclusion on your website, you grant Foysonis access to this
                                data to used during Support calls, backup and other data related activities.
                                </li>
                                <li>
                                    <b>HTTPS.</b> We offer HTTPS on all Foysonis.com sites by default. By signing up on
                                Foysonis.com, you authorize us to use HTTPS encryption while accessing Foysonis.com
                                </li>
                                <li>
                                    <b>Payment and Renewal.</b>
                                    <ul>
                                        <li>
                                            <b>General Terms. </b>Optional paid services such as extra users or add-on
                                        module
                                        purchases are available (any such services, an "Upgrade"). By selecting an
                                        Upgrade
                                        you agree to pay Foysonis the monthly or annual subscription fees indicated
                                        for that
                                        service. Payments will be charged on a pre-pay basis on the day you sign up
                                        for an
                                        Upgrade and will cover the use of that service for a monthly or
                                        annual subscription period as indicated.
                                        </li>
                                        <li>
                                            <b> Automatic Renewal.</b> Unless you notify Foysonis before the end of the
                                        applicable subscription period that you want to cancel an Account or
                                        Upgrade, your
                                        subscription will automatically renew and you authorize us to collect the
                                        then-applicable annual or monthly subscription fee for such Services (as
                                        well as any
                                        taxes) using any credit card or other payment mechanism we have on record
                                        for you.
                                        Accounts and Upgrades can be canceled at any time by calling Foysonis
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                        <li><h3>Responsibility of Visitors</h3>
                            <p>
                                Foysonis has not reviewed, and cannot review, all of the material, including data,
                                entered into our Services, and cannot therefore be responsible for that material's
                                content, use or effects. By operating our Services, Foysonis does not represent or imply
                                that it endorses the material there posted, or that it believes such material to be
                                accurate, useful, or non-harmful. You are responsible for taking precautions as
                                necessary to protect yourself and your computer systems from viruses, worms, Trojan
                                horses, and other harmful or destructive content. Our Services may contain content that
                                is offensive, indecent, or otherwise objectionable, as well as content containing
                                technical inaccuracies, typographical mistakes, and other errors. Our Services may also
                                contain material that violates the privacy or publicity rights, or infringes the
                                intellectual property and other proprietary rights, of third parties, or the
                                downloading, copying or use of which is subject to additional terms and conditions,
                                stated or unstated. Foysonis disclaims any responsibility for any harm resulting from
                                the use by visitors of our Services, or from any downloading by those visitors of
                                content there posted.
                            </p>
                        </li>
                        <li>
                            <h3>Copyright Infringement and DMCA Policy.</h3>

                            <p>
                                As Foysoinis asks others to respect its intellectual property rights, it respects the
                                intellectual property rights of others. If you believe that material located on or
                                linked to by Foysonis.com violates your copyright, you are encouraged to notify
                                Foysonis. Foysonis will respond to all such notices, including as required or
                                appropriate by removing the infringing material or disabling all links to the infringing
                                material. Foysonis will terminate a visitor's access to and use of the Website if, under
                                appropriate circumstances, the visitor is determined to be a repeat infringer of the
                                copyrights or other intellectual property rights of Foysonis or others. In the case of
                                such termination, Foysonis will have no obligation to provide a refund of any amounts
                                previously paid to Foysonis
                            </p></li>
                        <li>
                            <h3>Intellectual Property</h3>
                            <p>
                                This Agreement does not transfer from Foysonis to you any Foysonis or third party
                                intellectual property, and all right, title, and interest in and to such property will
                                remain (as between the parties) solely with Foysonis. Foysonis, Foysonis.com, the
                                Foysonis.com logo, and all other trademarks, service marks, graphics and logos used in
                                connection with WordPress.com or our Services, are trademarks or registered trademarks
                                of
                                Foysonis or Foysonis's licensors. Other trademarks, service marks, graphics and logos
                                used
                                in connection with our Services may be the trademarks of other third parties. Your use
                                of
                                our Services grants you no right or license to reproduce or otherwise use any Foysonis
                                or
                                third-party trademarks.
                            </p>
                        </li>
                        <li>
                            <h3>Changes</h3>
                            <p>
                                We are constantly updating our Services, and that means sometimes we have to change the
                                legal terms under which our Services are offered. If we make changes that are material,
                                we
                                will let you know by posting on one of our blogs, or by sending you an email or other
                                communication before the changes take effect. The notice will designate a reasonable
                                period
                                of time after which the new terms will take effect. If you disagree with our changes,
                                then
                                you should stop using our Services within the designated notice period. Your continued
                                use
                                of our Services will be subject to the new terms. However, any dispute that arose before
                                the
                                changes shall be governed by the Terms (including the binding individual arbitration
                                clause)
                                that were in place when the dispute arose.
                            </p></li>
                        <li>
                            <h3>Termination</h3>
                            <p>
                                Foysonis may terminate your access to all or any part of our Services at any time, with
                                or
                                without cause, with or without notice, effective immediately. If you wish to terminate
                                this
                                Agreement or your Foysonis.com account (if you have one), you may simply discontinue
                                using
                                our Services. All provisions of this Agreement which by their nature should survive
                                termination shall survive termination, including, without limitation, ownership
                                provisions,
                                warranty disclaimers, indemnity and limitations of liability.
                            </p></li>
                        <li>
                            <h3>Disclaimer of Warranties</h3>
                            <p class="terms-box-highlight">
                                Our Services are provided "as is." Foysonis and its suppliers and licensors hereby
                                disclaim all warranties of any kind, express or implied, including, without limitation,
                                the warranties of merchantability, fitness for a particular purpose and
                                non-infringement. Neither Foysonis nor its suppliers and licensors, makes any warranty
                                that our Services will be error free or that access thereto will be continuous or
                                uninterrupted. You understand that you download from, or otherwise obtain content or
                                services through, our Services at your own discretion and risk.
                            </p></li>
                        <li><h3>Limitation of Liability</h3>
                            <p class="terms-box-highlight">
                                In no event will Foysonis, or its suppliers or licensors, be liable with respect to any
                                subject matter of this Agreement under any contract, negligence, strict liability or
                                other legal or equitable theory for: (i) any special, incidental or consequential
                                damages; (ii) the cost of procurement for substitute products or services; (iii) for
                                interruption of use or loss or corruption of data; or (iv) for any amounts that exceed
                                the fees paid by you to Foysonis under this agreement during the three (3) month period
                                prior to the cause of action. Foysonis shall have no liability for any failure or delay
                                due to matters beyond their reasonable control. The foregoing shall not apply to the
                                extent prohibited by applicable law
                            </p></li>
                        <li><h3>General Representation and Warrant</h3>
                            <p>
                                You represent and warrant that (i) your use of our Services will be in strict accordance
                                with the Foysonis Privacy Policy, with this Agreement, and with all applicable laws and
                                regulations (including without limitation any local laws or regulations in your country,
                                state, city, or other governmental area, regarding online conduct and acceptable
                                content, and including all applicable laws regarding the transmission of technical data
                                exported from the United States or the country in which you reside) and (ii) your use of
                                our Services will not infringe or misappropriate the intellectual property rights of any
                                third party
                            </p></li>
                        <li><h3>US Economic Sanction</h3>
                            <p>
                                You expressly represent and warrant that your use of our Services and or associated
                                services and products is not contrary to applicable U.S. Sanctions. Such use is
                                prohibited, and Foysonis reserve the right to terminate accounts or access of those in
                                the event of a breach of this condition
                            </p>
                        </li>
                        <li><h3>Indemnification</h3>
                            <p>aYou agree to indemnify and hold harmless Foysonis, its contractors, and its licensors,
                            and their respective directors, officers, employees, and agents from and against any and
                            all claims and expenses, including attorneys' fees, arising out of your use of our
                            Services, including but not limited to your violation of this Agreement</p>
                        </li>
                        <li><h3>Translation</h3>
                            <p>
                                These Terms of Service were originally written in English (US). We may translate these
                                terms into other languages. In the event of a conflict between a translated version of
                                these Terms of Service and the English version, the English version will control
                            </p>
                        </li>
                        <li><h3>Miscellaneous</h3>
                            <p>
                                This Agreement constitutes the entire agreement between Foysonis and you concerning the
                                subject matter hereof, and they may only be modified by a written amendment signed by an
                                authorized executive of Foysonis, or by the posting by Foysonis of a revised version.
                                Except to the extent applicable law, if any, provides otherwise, this Agreement, any
                                access to or use of our Services will be governed by the laws of the state of North
                                Carolina, U.S.A., excluding its conflict of law provisions, and the proper venue for any
                                disputes arising out of or relating to any of the same will be the state and federal
                                courts located in Wake County, North Carolina. Except for claims for injunctive or
                                equitable relief or claims regarding intellectual property rights (which may be brought
                                in any competent court without the posting of a bond), any dispute arising under this
                                Agreement shall be finally settled in accordance with the Comprehensive Arbitration
                                Rules of the Judicial Arbitration and Mediation Service, Inc. ("JAMS") by three
                                arbitrators appointed in accordance with such Rules. The arbitration shall take place in
                                Raleigh, North Carolina, in the English language and the arbitral decision may be
                                enforced in any court. The prevailing party in any action or proceeding to enforce this
                                Agreement shall be entitled to costs and attorneys' fees. If any part of this Agreement
                                is held invalid or unenforceable, that part will be construed to reflect the parties'
                                original intent, and the remaining portions will remain in full force and effect. A
                                waiver by either party of any term or condition of this Agreement or any breach thereof,
                                in any one instance, will not waive such term or condition or any subsequent breach
                                thereof. You may assign your rights under this Agreement to any party that consents to,
                                and agrees to be bound by, its terms and conditions; Foysonis may assign its rights
                                under this Agreement without condition. This Agreement will be binding upon and will
                                inure to the benefit of the parties, their successors and permitted assigns.
                                <br>
                                <br>
                                <br>
                                <br>
                            </p>
                        </li>
                    </ol>
                </div>
                <div class="modal-footer trial-modal-footer">
                    <button type="submit" class="btn btn-default" ng-click="denyTerms()"><g:message code="default.button.cancel.label" /></button>
                    <button type="submit" class="btn btn-primary" ng-click="acceptTerms()"><g:message code="default.button.accept.label" /></button>
                </div>

            </div>
        </div>
    </div>

</div><!-- End of user profileCtrl -->


<asset:javascript src="datagrid/user-account-profile.js"/>

<script type="text/javascript">
    var dvUserAccountProfile = document.getElementById('dvUserAccountProfile');
    angular.element(document).ready(function() {
        angular.bootstrap(dvUserAccountProfile, ['userAccountProfile']);
    });
</script>

</body>
</html>
