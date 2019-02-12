<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="author" content="">
    <title>Foysonis - Login</title>
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->

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
    <script src="${request.contextPath}/foysonis2016/vendor/modernizr/modernizr.js" type="application/javascript"></script>
    <!-- FastClick for mobiles-->
    <script src="${request.contextPath}/foysonis2016/vendor/fastclick/fastclick.js" type="application/javascript"></script>

    <link rel="shortcut icon" type="image/png" href="${request.contextPath}/foysonis2016/app/img/favicon.png"/>

</head>

<body>


<div class="row row-table page-wrapper" style="background-image: url('/foysonis2016/app/img/login-bg.png'); background-repeat: no-repeat;  background-size: 100% 50%;">
    <div class="col-lg-4 col-md-6 col-sm-8 col-xs-12 align-middle">

        <g:if test="${flash.error}">
            <div class="alert alert-danger alert-dismissable">
                <button type="button" data-dismiss="alert" aria-hidden="true" class="close">×</button>${flash.error}
            </div>
        </g:if>
        <g:if test="${flash.warning}">
            <div class="alert alert-warning alert-dismissable">
                <button type="button" data-dismiss="alert" aria-hidden="true" class="close">×</button>${flash.warning}
            </div>
        </g:if>

        <g:if test='${flash.message}'>
            <div class="alert alert-info alert-dismissable">
                <button type="button" data-dismiss="alert" aria-hidden="true" class="close">×</button>${flash.message}
            </div>
        </g:if>


    <!-- START panel-->
        <div data-toggle="play-animation" data-play="fadeIn" data-offset="0" class="panel panel-dark panel-flat">
            <div class="panel-heading text-center">
                <a href="#">
                    <img src="${request.contextPath}/foysonis2016/app/img/logo.png" alt="Image"
                         class="block-center img-rounded">
                </a>

                <p class="text-center mt-lg">
                    <strong>SIGN IN TO CONTINUE.</strong>
                </p>
            </div>

            <div class="panel-body" id="dvUserLogin" ng-controller="mainController">

                <g:form name="userForm" action="authenticate" method="post" autocomplete="off" ng-submit="submitForm()" novalidate="" >

                    <div class="text-right mb-sm">&nbsp;
                    </div>

                    <div class="form-group has-feedback"
                         ng-class="{ 'has-error' : userForm.company_id.$invalid && userForm.company_id.$touched }">
                        <span class="fa fa-globe form-control-feedback text-muted"></span>
                        <input id="company_id" type="text" placeholder="Enter Company Id" name='company_id'
                               value='${user?.companyId}' class="form-control" required ng-model="user.company_id"
                               company-id-validator capitalize>
                        <p ng-show="userForm.company_id.$touched && userForm.company_id.$invalid"
                           class="help-block">Company Id is Invalid.</p>
                    </div>

                    <div class="form-group has-feedback"
                         ng-class="{ 'has-error' : userForm.username.$invalid && !userForm.username.$pristine }">
                        <input id="username" type="text" placeholder="Enter Username" name='username'
                               value='${user?.username}' class="form-control" required ng-model="user.username">
                        <span class="fa fa-user form-control-feedback text-muted"></span>

                        <p ng-show="userForm.username.$invalid && !userForm.username.$pristine"
                           class="help-block">Username is required.</p>
                    </div>

                    <div class="form-group has-feedback"
                         ng-class="{ 'has-error' : userForm.password.$invalid && !userForm.password.$pristine }" style="margin-bottom: 5px;">
                        <input id="password" type="password" placeholder="Enter Password" name='password'
                               value='${user?.password}' class="form-control" required ng-model="user.password">
                        <span class="fa fa-lock form-control-feedback text-muted"></span>

                        <p ng-show="userForm.password.$invalid && !userForm.password.$pristine"
                           class="help-block">Password is required.</p>
                    </div>

                    <div class="clearfix form-group">

                        <div class="pull-left"><a href="https://www.foysonis.com/pricing" class="text-muted">Need to Signup?</a>
                        </div>

                        <div class="pull-right"><a href="/user/forgotPassword" class="text-muted">Forgot your password?</a>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-block btn-primary" ng-disabled="userForm.$invalid">Login</button>

                </g:form>

            </div>
        </div>
        <!-- END panel-->
    </div>
</div>
<!-- END wrapper-->


<asset:javascript src="angular.js"/>
<asset:javascript src="foysonis.js"/>

<script>
    (function () {
        document.forms['userForm'].elements['${usernameParameter ?: 'username'}'].focus();
    })();
</script>


<script type="text/javascript">
    var dvUserLogin = document.getElementById('dvUserLogin');
    angular.element(document).ready(function () {
        angular.bootstrap(dvUserLogin, ['validationApp']);
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
