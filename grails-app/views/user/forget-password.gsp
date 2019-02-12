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
    <script src="${request.contextPath}/foysonis2016/vendor/modernizr/modernizr.js"
            type="application/javascript"></script>
    <!-- FastClick for mobiles-->
    <script src="${request.contextPath}/foysonis2016/vendor/fastclick/fastclick.js"
            type="application/javascript"></script>

    <link rel="shortcut icon" type="image/png" href="${request.contextPath}/foysonis2016/app/img/favicon.png"/>

</head>

<body style='font-family: "Open Sans", "Helvetica Neue", Helvetica, Arial, sans-serif'>

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

            <div class="panel-body">

                <g:form name="userForm" action="forgotPasswordAction" method="post" autocomplete="off">

                    <g:if test="${flash.error}">
                        <div class="alert alert-danger alert-dismissable">
                            <button type="button" data-dismiss="alert" aria-hidden="true" class="close">×</button>
                            ${flash.error}
                        </div>
                    </g:if>
                    <g:if test="${flash.message}">
                        <div class="alert alert-success alert-dismissable">
                            <button type="button" data-dismiss="alert" aria-hidden="true" class="close">×</button>
                            ${flash.message}
                        </div>
                    </g:if>
                    <div id="emailErrorMsg" class="alert alert-danger alert-dismissable hidden">
                            <button type="button" data-dismiss="alert" aria-hidden="true" class="close">×</button>
                            Please enter a valid e-mail address.
                    </div>

                    <div class="text-left mb-sm">Enter your email address to reset your password. You may need to
                    check your spam folder or unblock no-reply@foysonis.com
                    </div>

                    <br>

                    <div class="form-group has-feedback">
                        <input id="email" type="text" placeholder="Company Email Address" name='email'
                               class="form-control">

                        <span class="fa fa-user form-control-feedback text-muted"></span>

                    </div>

                    <button type="submit" class="btn btn-block btn-primary">Submit</button>

                </g:form>

            </div>
        </div>
        <!-- END panel-->
    </div>
</div>
<!-- END wrapper-->

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
