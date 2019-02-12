<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="author" content="">
    <title>Foysonis - Login</title>
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->

    <asset:javascript src="angular.js"/>

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

    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <!-- Bootstrap CSS-->
    <link rel="stylesheet" href="${request.contextPath}/foysonis2016/vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${request.contextPath}/foysonis2016/app/css/bootstrap.css">
    <!-- Vendor CSS-->
    <link rel="stylesheet" href="${request.contextPath}/foysonis2016/vendor/fontawesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="${request.contextPath}/foysonis2016/vendor/animo/animate+animo.css">
    <!-- App CSS-->
    <link rel="stylesheet" href="${request.contextPath}/foysonis2016/app/css/app.css">
    <link rel="stylesheet" href="${request.contextPath}/foysonis2016/app/css/common.css">
    <!-- Modernizr JS Script-->
    <script src="${request.contextPath}/foysonis2016/vendor/modernizr/modernizr.js"
            type="application/javascript"></script>
    <!-- FastClick for mobiles-->
    <script src="${request.contextPath}/foysonis2016/vendor/fastclick/fastclick.js"
            type="application/javascript"></script>

    <link rel="shortcut icon" type="image/png" href="${request.contextPath}/foysonis2016/app/img/favicon.png"/>

    <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>
    <asset:stylesheet src="ng-img-crop.css"/>

    <style>
    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }
    </style>

</head>

<body>

<div class="row row-table page-wrapper">
    <div class="col-lg-4 col-md-6 col-sm-8 col-xs-12 align-middle">

        <!-- START panel-->
        <div data-toggle="play-animation" data-play="fadeIn" data-offset="0" class="panel panel-dark panel-flat">
            <div class="panel-heading text-center">
                <a href="#">
                    <img src="${request.contextPath}/foysonis2016/app/img/logo.png" alt="Image"
                         class="block-center img-rounded">
                </a>

                <p class="text-center mt-lg">
                    <strong>Forgot your password?</strong>
                </p>
            </div>

            <div ng-cloak class="panel-body" id="dvResetPassword" ng-controller="resetPasswordCtrl as ctrl">

                <div class="alert alert-success message-animation" role="alert" ng-if="ctrl.showUpdatedPrompt">
                    Your password has been saved!
                </div>

                <form  name="ctrl.updatePasswordForm"  autocomplete="off" ng-submit="ctrl.updatePassword()" novalidate>

                    <br>

                    <div class="text-left mb-sm">Please enter a new password for your <b>${emailid}</b> account</div>

                    <br>

                    <div class="form-group">
                        <label for="newPassword">New Password</label>

                        <div class="input-group" ng-class="{'has-error':ctrl.hasErrorClass1('newPassword')}" ng-if="!ctrl.userInfo.hiddenUsername">
                            <input id="newPassword" name="newPassword" class="form-control" required
                                   type="{{ctrl.getPasswordType()}}"
                                   ng-model-options="{ updateOn : 'default blur' }"
                                   ng-model="ctrl.userInfo.newPassword"
                                   validate-password-characters />
                            <span class="input-group-addon">
                                <input type="checkbox" ng-model="ctrl.showPassword"> Show
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

                    <div class="">

                        <div class="form-group" ng-class="{'has-error':ctrl.hasErrorClass1('confirmPassword')}">
                            <label for="confirmPassword">Confirm New Password</label>
                            <input id="confirmPassword" name="confirmPassword" class="form-control" type="password" ng-model="ctrl.userInfo.confirmPassword" required
                                   ng-disabled="!ctrl.updatePasswordForm.newPassword.$valid" ng-blur=""/>

                            <div class="my-messages" ng-messages="ctrl.updatePasswordForm.confirmPassword.$error" ng-if="ctrl.userInfo.confirmPassword && ctrl.userInfo.newPassword !=ctrl.userInfo.confirmPassword">
                                <div class="message-animation">
                                    <strong>Password Not Matched</strong>
                                </div>
                            </div>


                            <div class="my-messages" ng-messages="ctrl.updatePasswordForm.confirmPassword.$error" ng-if="ctrl.showMessages1('confirmPassword')">
                                <div class="message-animation" ng-message="required">
                                    <strong>This field is required.</strong>
                                </div>
                            </div>

                        </div>

                    </div>

                    %{--<div class="form-group has-feedback">
                        <input id="newpassword" type="text" placeholder="New Password" name='newpassword'
                               class="form-control">
                        <input id="emailid" type="hidden" value="${emailid}" name='emailid'>

                        <span class="fa fa-user form-control-feedback text-muted"></span>

                    </div>--}%


                   %{-- <div class="form-group has-feedback">
                        <input id="confirmpassword" type="text" placeholder="Retype Password" name='confirmpassword'
                               class="form-control">

                        <span class="fa fa-user form-control-feedback text-muted"></span>

                    </div>
--}%

                    <div class="">
                        <button class="btn btn-block btn-primary" type="submit">Update</button>
                    </div>

                </form>

            </div>
        </div>
        <!-- END panel-->
    </div>
</div>
<!-- END wrapper-->



<asset:javascript src="datagrid/user-forget-password.js"/>

<script type="text/javascript">
    var dvResetPassword = document.getElementById('dvResetPassword');
    angular.element(document).ready(function () {
        angular.bootstrap(dvResetPassword, ['resetPassword']);
    });
</script>

<!-- START Scripts-->
<!-- Main vendor Scripts-->
<script src="${request.contextPath}/foysonis2016/vendor/jquery/jquery.min.js"></script>
<script src="${request.contextPath}/foysonis2016/vendor/bootstrap/js/bootstrap.min.js"></script>
<!-- Animo-->
<script src="${request.contextPath}/foysonis2016/vendor/animo/animo.min.js"></script>
<!-- Form Validation-->
%{--<script src="${request.contextPath}/foysonis2016/vendor/parsley/parsley.min.js"></script>--}%
<!-- Custom script for pages-->
<script src="${request.contextPath}/foysonis2016/app/js/pages.js"></script>



</body>
</html>
