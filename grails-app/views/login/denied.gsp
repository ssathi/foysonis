<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
	<meta name="description" content="">
	<meta name="keywords" content="">
	<meta name="author" content="">
	<title>Foysonis - <g:message code='springSecurity.denied.title' /></title>
	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->

	<!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
	<!-- Bootstrap CSS-->
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


<div class="row row-table page-wrapper">
	<div class="col-lg-3 col-md-6 col-sm-8 col-xs-12 align-middle">
			<div class="alert alert-danger alert-dismissable">
				<g:message code='springSecurity.denied.message' />
			</div>
	</div>
</div>
<!-- END wrapper-->


<asset:javascript src="angular.js"/>
<asset:javascript src="foysonis.js"/>



<!-- START Scripts-->
<!-- Main vendor Scripts-->
<script src="${request.contextPath}/beadmin/vendor/jquery/jquery.min.js"></script>
<script src="${request.contextPath}/beadmin/vendor/bootstrap/js/bootstrap.min.js"></script>
<!-- Animo-->
<script src="${request.contextPath}/beadmin/vendor/animo/animo.min.js"></script>
<!-- Form Validation-->
<script src="${request.contextPath}/beadmin/vendor/parsley/parsley.min.js"></script>
<!-- Custom script for pages-->
<script src="${request.contextPath}/beadmin/app/js/pages.js"></script>

</body>
</html>

