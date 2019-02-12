<!DOCTYPE html>
<head>
    <!-- Meta-->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="author" content="">

    <title>Foysonis</title>
    <link rel="shortcut icon" type="image/png" href="${request.contextPath}/foysonis2016/app/img/favicon.png"/>

    <asset:stylesheet src="bootstrap-datepicker.css"/>

    %{--<link rel="stylesheet" href="${request.contextPath}/foysonis2016/vendor/bootstrap/css/bootstrap.min.css">--}%
    <link rel="stylesheet" href="${request.contextPath}/foysonis2016/vendor/animo/animate+animo.css">
    <link rel="stylesheet" href="${request.contextPath}/foysonis2016/app/css/bootstrap.css">
    <!-- Vendor CSS-->
    <link rel="stylesheet" href="${request.contextPath}/foysonis2016/vendor/fontawesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="${request.contextPath}/foysonis2016/vendor/csspinner/csspinner.min.css">



    <!-- Modernizr JS Script-->
    <script src="${request.contextPath}/foysonis2016/vendor/modernizr/modernizr.js" type="application/javascript"></script>
    <!-- FastClick for mobiles-->


    <asset:javascript src="angular.js"/>
    %{--<asset:javascript src="alert.js"/>--}%

    <script src="${request.contextPath}/foysonis2016/vendor/fastclick/fastclick.js"
            type="application/javascript"></script>

    %{--<script src="${request.contextPath}/foysonis2016/master/bower_components/angular-ui-grid/ui-grid.min.js"></script>--}%
    %{--<link rel="stylesheet" href="http://ui-grid.info/release/ui-grid-unstable.min.css">--}%
    <link rel="stylesheet" href="${request.contextPath}/foysonis2016/vendor/grid/ui-grid-unstable.min.css">

    %{--<link rel="stylesheet" href="${request.contextPath}/foysonis2016/master/bower_components/angular-ui-grid/ui-grid.css">--}%
    %{--<link rel="stylesheet" href="${request.contextPath}/foysonis2016/master/bower_components/angular-ui-grid/latest-ui-grid.css">--}%

    <link rel="stylesheet" href="${request.contextPath}/foysonis2016/app/css/app.css">
        <asset:stylesheet src="signup/style.css"/>
    <asset:stylesheet src="signup/animations.css"/>





    <g:layoutHead/>

    <style>

    [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
        display: none !important;
    }

    .panel button {
        margin-bottom: 0px;
    }

    @media only screen and (max-width: 450px) {
        .userImage {
            vertical-align: top;
            //height: 30px;
        }
    }

    .supportLinkBtn{
        //padding-right: 5px;
        //padding-left: 5px;
        padding-top: 25px;
    }

    .userGuideBtn {
        padding-left: 0px;

    }
    .supportLinkModal{
        margin-top: 50px;
        margin-right:0px;
        width: 30%;
    }
    .upgradeNotifyText{
        overflow-wrap:break-word;
    }
    .nav-wrapper {
        height: 50px;
        background-color: #041936;
    }

    .nav-wrapper .nav.navbar-nav {
        margin-top: -10px;
    }    
    .content-wrapper {
        margin-top: -20px;
    }
    .navbar-top {
        background-color: transparent;
    }    

    .aside-collapsed .navbar-top .navbar-header {
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.15);
    }    

    .navbar-top .navbar-header {
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.15);
    }
    .nav-wrapper .nav.navbar-nav > li > a {
        color: #ffffff;
    }
    </style>

    <!--[if lt IE 9]>
        <script src="${request.contextPath}/foysonis2016/vendor/ie9/html5shiv.js"></script>
        <script src="${request.contextPath}/foysonis2016/vendor/ie9/respond.min.js"></script>
    <![endif]-->


</head>



<body class="aside-collapsed">
<!-- START Main wrapper-->
<div class="wrapper">
    <!-- START Top Navbar-->
    <nav role="navigation" class="navbar navbar-default navbar-top navbar-fixed-top">
        <!-- START navbar header-->
        <div class="navbar-header">
            <a href="/dashboard" class="navbar-brand">
                <div class="brand-logo"><i class="icon icon-logo"></i>
                    <!--img.img-responsive(src="app/img/logo.png", alt="App Logo")-->
                </div>

                <div class="brand-logo-collapsed"><i class="icon icon-icon"></i>
                </div>
            </a>
        </div>
        <!-- END navbar header-->
        <!-- START Nav wrapper-->
        <div class="nav-wrapper">
            <!-- START Left navbar-->
            <ul class="nav navbar-nav">
                <li class="hidden-xs">
                    <!-- Button used to collapse the left sidebar. Only visible on tablet and desktops-->
                    <a href="#" data-toggle-state="aside-collapsed" class="hidden-xs" style="height: 60px;">
                        <em><img src="/foysonis2016/app/img/menu_Header.svg" width="25px"></em>
                    </a>
                    <!-- Button to show/hide the sidebar on mobile. Visible on mobile only.-->
                    <a href="#" data-toggle-state="aside-toggled" class="visible-xs">
                        <em><img src="/foysonis2016/app/img/menu_Header.svg" width="25px"></em>
                    </a>
                </li>
                <!-- START Page Title-->
                <!-- <li class="page-title hidden-xs"><i class="icon icon-admin"></i>

                    <h1>${pageTitle}</h1>
                </li> -->
                %{--<li>--}%
                %{--<nav class="menu-res visible-xs">--}%
                %{--<span class="menu-res-toggle"></span>--}%
                %{--<ul class="nav">--}%
                %{--<li><a href="/dashboard">Dashboard</a></li>--}%
                %{--<li><a href="#">Receiving</a></li>--}%
                %{--<li><a href="#">Orders</a></li>--}%
                %{--<li><a href="#">Inventory</a></li>--}%
                %{--<li><a href="#">Shipping</a></li>--}%
                %{--<li><a href="#">Reports</a></li>--}%
                %{--<li><a href="#">Adminstration <span class="icon icon-down pull-right"></span></a>--}%
                %{--<ul class="nav">--}%
                %{--<li><a href="#">Users</a></li>--}%
                %{--<li><a href="#">Locations &amp; Areas</a></li>--}%
                %{--<li><a href="#">Items</a></li>--}%
                %{--<li><a href="#">Inventory Adjustment</a></li>--}%
                %{--</ul>--}%
                %{--</li>--}%
                %{--<li><a href="#">Settings</a></li>--}%
                %{--</ul>--}%
                %{--</nav>--}%
                %{--</li>--}%
                <!-- END Page Title-->
                <!-- START User avatar toggle-->
                <!--li// Button used to collapse the left sidebar. Only visible on tablet and desktops
//a(href='#', data-toggle-state="aside-user")
 // em.fa.fa-user-->
                <!-- END User avatar toggle-->
            </ul>
            <!-- END Left navbar-->
            <!-- START Right Navbar-->
            <ul class="nav navbar-nav navbar-right">
                <!-- Search icon-->
                <!--li//a(href='#', data-toggle="navbar-search")
  //em.fa.fa-search-->
                <!-- Fullscreen-->

                <li class="full-item">
                    <a href="#" data-toggle="fullscreen" style="padding-top: 18px; padding-right: 0;">
                        <em class="icon icon-full hidden-xs" style="font-size: 40px;"></em>
                    </a>
                </li>
                <!-- START Contacts button-->
                %{--<li data-toggle-class="active">--}%
                %{--<a href="#" data-toggle-state="offsidebar-open">--}%
                %{--<em class="icon icon-notification"></em>--}%
                %{--</a>--}%
                %{--</li>--}%
                <!-- END Contacts menu-->
                <!-- START Alert menu-->
                <li class="userGuideBtn">
                    <a href="javascript:void(0)" onClick="openUserGuide()" style="padding-left: 10px;">
                        <em><img src="/foysonis2016/app/img/foyHelp.png" style="width:24px; vertical-align: top;"></em>
                    </a>
                    <div id="userGuideModal" class="modal fade" role="dialog">
                      <div class="modal-dialog" style="width: 90%; height: 90%;">

                        <!-- Modal content-->
                        <div class="modal-content" style="min-height: 100%;">
                          <div class="modal-header" style="height: 35px;">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title"></h4>
                          </div>
                          <div class="modal-body" style="position: fixed; top: 30px; bottom: 30px; width: 100%;">
                                <iframe id="userGuideFrame" frameborder="0" style="width: 100%; height: 100%;">
                                </iframe>                    
                          </div>
                          <div class="modal-footer" style="position: fixed; bottom: 0; right: 0; left: 0; height: 60px;">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                          </div>
                        </div>

                      </div>
                    </div>
                </li>
                <g:if test="${session.SPRING_SECURITY_CONTEXT.getAuthentication().companyPaymentMethod}">
                <li class="supportLinkBtn">
                    <div ng-app="supportLink" ng-controller="MainCtrl as ctrl">
                        <a href="#" ng-click="supportMailBox()">
                            <em>
                                <img src="/foysonis2016/app/img/Support_icon.svg" style="width:25px; vertical-align: top;">
                            </em>
                        </a>

                        <div id="supportMailModel" class="modal fade" role="dialog" data-backdrop="static">
                            <div class="modal-dialog supportLinkModal">
                                <div class="modal-content" ng-if="companyBillingData=='Premium' || companyBillingData=='Standard'">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h4 class="modal-title">Email Support</h4>
                                    </div>
                                    <form name="ctrl.sendSupportMailForm" ng-submit="sendSupportMail()" novalidate>
                                    <div class="modal-body">
                                        <div class="form-group" ng-class="{'has-error':ctrl.sendSupportMailForm.mailSubject.$touched && ctrl.sendSupportMailForm.mailSubject.$invalid}">
                                            <label for="pickFrom">Subject :</label>
                                            <input type="text" name="mailSubject" class="form-control" ng-model="supportMail.subject" required />
                                            <div class="my-messages" ng-messages="ctrl.sendSupportMailForm.mailSubject.$error" ng-if="ctrl.sendSupportMailForm.mailSubject.$touched || ctrl.sendSupportMailForm.$submitted;">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>
                                        </div>
                                        <br style="clear: both;">
                                        <div class="form-group" ng-class="{'has-error':ctrl.sendSupportMailForm.mailDescription.$touched && ctrl.sendSupportMailForm.mailDescription.$invalid}">
                                            <label for="pickFrom">Description :</label>
                                            <textarea name="mailDescription" class="form-control" ng-model="supportMail.description" required></textarea>
                                            <div class="my-messages" ng-messages="ctrl.sendSupportMailForm.mailDescription.$error" ng-if="ctrl.sendSupportMailForm.mailDescription.$touched || ctrl.sendSupportMailForm.$submitted;">
                                                <div class="message-animation" ng-message="required">
                                                    <strong><g:message code="required.error.message" /></strong>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="checkbox c-checkbox">
                                            <label>
                                                <input type="checkbox" value="" ng-click="ctrl.showEarlyShipDateRange()" ng-model="supportMail.sendACopy">
                                                <span class="fa fa-check"></span>Send me a copy of this mail.</label>
                                        </div>    
                                    </div>
                                    <div class="modal-footer">
                                        <button type="submit" class="btn btn-primary" ng-disabled="disableSendMail">{{sendSupportMailBtn}}</button>
                                        <br style="clear: both;">
                                        <br style="clear: both;">
                                        <div class="row" style="border-top: 1px solid #e5e5e5; text-align: left;">
                                            <div class="col-md-12">
                                                <h4>Phone Support</h4>
                                            </div>
                                            <div class="col-md-12" ng-if="companyBillingData=='Premium'">
                                                <p style="font-size: 16px; font-weight: bold;">Please call : <a href="tel:+1-855-333-2812">+1-855-333-2812</a></p>
                                            </div>
                                            <div class="col-md-12 upgradeNotifyText" ng-if="companyBillingData=='Standard'">
                                                <p><g:message code="companyBilling.standard.phone.message" /></p>
                                                <g:link url="/billing">
                                                    <button type="button" class="btn btn-primary">Upgrade</button>
                                                </g:link>
                                            </div>
                                        </div>
                                        <br style="clear: both;">
                                    </div>
                                    </form>
                                </div>
                                <div class="modal-content" ng-if="companyBillingData=='Individual'">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h4 class="modal-title">Foysonis Support</h4>
                                    </div>
                                    <div class="modal-body">
                                        <div class="upgradeNotifyText"><p><g:message code="companyBilling.Individual.support.message"/></p></div>
                                    </div>
                                    <div class="modal-footer">
                                        <g:link url="/billing">
                                            <button type="button" class="btn btn-primary">Upgrade</button>
                                        </g:link>
                                    </div>
                                </div>                                
                            </div>
                        </div>

                        <div id="sendMailSuccessModel" class="modal fade" role="dialog">
                            <div class="modal-dialog">
                                <div class="alert alert-success message-animation" role="alert">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <div>
                                            Email has been sent successfully.
                                        </div>
                                </div>
                            </div>
                        </div>
                        <div id="sendingMailModal" class="modal fade" role="dialog">
                            <div class="modal-dialog">
                                <div class="alert alert-success message-animation" role="alert">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <div>
                                            Sending Email.......
                                        </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </li>
                </g:if>
                <li class="dropdown dropdown-list">
                    <a href="#" data-toggle="dropdown" data-play="flipInX" class="dropdown-toggle"
                       style="padding-bottom: 0px;">
                        <div id="userAccountImageDiv" ng-app="userAccountImage" ng-controller="userImageCtrl">

                            <em ng-if="!myImage"><img src="/foysonis2016/app/img/User_profile.svg" style="width: 24px;"></em>
                            <img ng-if="myImage" class="userImage" ng-src="{{myImage}}"
                                 style="width: 24px;  vertical-align: top; border-radius: 50%;"/>

                        </div>

                        <!--.label.label-danger 11-->
                    </a>
                    <!-- START Dropdown menu-->
                    <ul class="dropdown-menu">
                        <li>
                            <!-- START list group-->
                            <div class="list-group">

                                <a href="/userAccount" class="list-group-item">
                                    <small>Account</small>
                                </a>

                                <g:if test="${session.user && session.user.adminActiveStatus == true}">
                                    <g:link url="/billing" class="list-group-item" >
                                        <small>Billing & Licenses</small>
                                    </g:link>
                                    <!-- <div id="dvCompanyBilling" ng-controller="billingCtrl as ctrl" >
                                            <a href="javascript:void(0)" class="list-group-item" ng-click ="ctrl.openBilling()">
                                                <small>Billing & Licenses</small>
                                            </a>
                                    </div> -->

                                </g:if>

                                <g:link url="/logout" class="list-group-item">
                                    <small>Log out</small>
                                </g:link>

                            </div>
                            <!-- END list group-->
                        </li>
                    </ul>
                    <!-- END Dropdown menu-->
                </li>
                <!-- END Alert menu-->
            </ul>
            <!-- END Right Navbar-->
        </div>
        <!-- END Nav wrapper-->
        <!-- START Search form-->
        <form role="search" action="search.html" class="navbar-form">
            <div class="form-group has-feedback">
                <input type="text" placeholder="Type and hit Enter.." class="form-control">

                <div data-toggle="navbar-search-dismiss" class="fa fa-times form-control-feedback"></div>
            </div>
            <button type="submit" class="hidden btn btn-default">Submit</button>
        </form>
        <!-- END Search form-->
    </nav>
    <!-- END Top Navbar-->
    <!-- START aside-->
    <aside class="aside">
        <!-- START Sidebar (left)-->
        <nav class="sidebar">
            <!-- START user info-->
            <div class="item user-block">
                <!-- User picture-->
                <div class="user-block-picture">
                    <div class="user-block-status">
                        %{--<img src="app/img/user/02.jpg" alt="Avatar" width="60" height="60" class="img-thumbnail img-circle">--}%
                        <div class="circle circle-success circle-lg"></div>
                    </div>
                    <!-- Status when collapsed-->
                </div>
                <!-- Name and Role-->
                <div class="user-block-info">
                    <span class="user-block-name item-text">Welcome User</span>
                    <span class="user-block-role">UX-Dev</span>
                </div>
            </div>
            <!-- END user info-->
            <ul class="nav main-nav">
                <!-- START Menu-->
                <li id="liDashBoard">
                    <a href="/dashboard" title="Dashboard" data-toggle="" class="no-submenu">
                        <em class="icon icon-dashboar"></em>
                        <span class="item-text">Dashboard</span>
                    </a>
                </li>
                <li id="liReceiving">
                    <g:link url="[action: 'index', controller: 'Receiving']" data-toggle="" class="no-submenu"
                            title="Receiving">
                        <em class="icon icon-receiving"></em>
                        <span class="item-text">Receiving</span>
                    </g:link>
                </li>

                <li id="liShipping">
                    <a href="#" title="Shipping" data-toggle="collapse-next" class="has-submenu">
                        <em class="icon icon-shipping"></em>
                        <span class="item-text">Shipping</span>
                    </a>

                    <ul id="ulShipping" class="nav collapse out">
                        <li>
                            <g:link url="[action: 'index', controller: 'order']" data-toggle="" class="no-submenu">
                                <span class="item-text" style="font-size: 13px;">Orders & Shipments</span>
                            </g:link>
                        </li>

                        <li>
                            <g:link url="[action: 'waveScreen', controller: 'wave']" data-toggle="" class="no-submenu">
                                <span class="item-text" style="font-size: 13px;">Waving</span>
                            </g:link>
                        </li>

                        <li>
                            <g:link url="[action: 'index', controller: 'customer']" data-toggle="" class="no-submenu">
                                <span class="item-text" style="font-size: 13px;">Customers</span>
                            </g:link>
                        </li>

                        <li>
                            <g:link url="[action: 'index', controller: 'shipping']" data-toggle="" class="no-submenu">
                                <span class="item-text" style="font-size: 13px;">Shipping Dock</span>
                            </g:link>
                        </li>

                        <li>
                            <g:link url="[action: 'shippedInventory', controller: 'inventory']" data-toggle="" class="no-submenu">
                                <span class="item-text" style="font-size: 13px;">Shipped Inventory</span>
                            </g:link>
                        </li>

                        <li>
                            <g:link url="[action: 'packOut', controller: 'wave']" data-toggle="" class="no-submenu">
                                <span class="item-text" style="font-size: 13px;">Packout Station</span>
                            </g:link>
                        </li>

                    </ul>
                </li>


                <li id="liPicking">
                    <a href="#" title="Picking" data-toggle="collapse-next" class="has-submenu">
                        <em class="icon icon-orders"></em>
                        <span class="item-text">Picking</span>
                    </a>

                    <ul id="ulPicking" class="nav collapse out">
                        <li>
                            <g:link url="[action: 'pickingStatus', controller: 'picking']" data-toggle=""
                                    class="no-submenu">
                                <span class="item-text" style="font-size: 13px;">Allocation & Pick Status</span>
                            </g:link>
                        </li>
                        <li>
                            <g:link url="[action: 'index', controller: 'picking']" data-toggle="" class="no-submenu">
                                <span class="item-text" style="font-size: 13px;">List Picking</span>
                            </g:link>
                        </li>

                        <li>
                            <g:link url="[action: 'palletPick', controller: 'picking']" data-toggle=""
                                    class="no-submenu">
                                <span class="item-text" style="font-size: 13px;">Pallet Picks & Replens</span>
                            </g:link>
                        </li>

                    </ul>
                </li>


                <li id="liInventory">
                    <a href="#" title="Inventory" data-toggle="collapse-next" class="has-submenu">
                        <em class="icon icon-inventory"></em>
                        <span class="item-text">Inventory</span>
                    </a>


                    <ul id="ulInventory" class="nav collapse out">
                        <li>
                            <g:link url="[action: 'index', controller: 'inventory']" data-toggle="" class="no-submenu">
                                <span class="item-text" style="font-size: 13px;">View Inventory</span>
                            </g:link>
                        </li>
                        <li>
                            <g:link url="[action: 'moveInventory', controller: 'inventory']" data-toggle=""
                                    class="no-submenu">
                                <span class="item-text" style="font-size: 13px;">Move Inventory</span>
                            </g:link>
                        </li>
                    </ul>
                </li>

            <g:if test="${session.SPRING_SECURITY_CONTEXT.getAuthentication().companyPaymentMethod == 'Premium' }">
                <li id="liKitting">
                    <a href="#" title="Kitting" data-toggle="collapse-next" class="has-submenu">
                        <em class=""><img src="/foysonis2016/app/img/kitting_icon.svg" style="width: 22px;"></em>
                        <span class="item-text">Kitting</span>
                    </a>


                    <ul id="ulKitting" class="nav collapse out">
                        <g:if test="${session.user && session.user.adminActiveStatus == true}">
                            <li>
                                <g:link url="[action: 'index', controller: 'billMaterial']" data-toggle="" class="no-submenu">
                                    <span class="item-text" style="font-size: 13px;">Bill of Material</span>
                                </g:link>
                            </li>
                        </g:if>
                        <li>
                            <g:link url="[action: 'index', controller: 'kittingOrder']" data-toggle=""
                                    class="no-submenu">
                                <span class="item-text" style="font-size: 13px;">Kitting Orders</span>
                            </g:link>
                        </li>
                    </ul>
                </li>
            </g:if>


                <li id="liReport">
                    <g:link url="[action: 'getReport', controller: 'report']" data-toggle="" class="no-submenu"
                            title="Report">
                        <em class="icon icon-reports"></em>
                        <span class="item-text">Reports</span>
                    </g:link>
                </li>

                <g:if test="${session.user && session.user.adminActiveStatus == true && session.SPRING_SECURITY_CONTEXT.getAuthentication().companyPaymentMethod == 'Premium' }">

                    <li id="liClientBilling">
                        <a href="#" title="clientBilling" data-toggle="collapse-next" class="has-submenu">
                            <em class="fa fa-credit-card"></em>
                            <span class="item-text">Client Billing</span>
                        </a>


                        <ul id="ulClientBilling" class="nav collapse out">
                            <li>
                                <g:link url="[action: 'setupRates', controller: 'clientBilling']" data-toggle=""
                                        class="no-submenu">
                                    <span class="item-text" style="font-size: 13px;">Setup Rates</span>
                                </g:link>
                            </li>
                            <li>
                                <g:link url="[action: 'generateInvoice', controller: 'clientBilling']" data-toggle=""
                                        class="no-submenu">
                                    <span class="item-text" style="font-size: 13px;">Generate Invoice</span>
                                </g:link>
                            </li>
                            <g:if test="${session.user.companyId == 'HDWNINT' || session.user.companyId == 'HDWNODY'}">
                                <li>
                                    <g:link url="[action: 'commercialInvoice', controller: 'clientBilling']" data-toggle=""
                                            class="no-submenu">
                                        <span class="item-text" style="font-size: 13px;">Commercial Invoice</span>
                                    </g:link>
                                </li>   
                            </g:if>                         
                        </ul>

                    </li>
                </g:if>

                <g:if test="${session.user && session.user.adminActiveStatus == true}">

                    <li id="liAdmin">
                        <a href="#" title="Administration" data-toggle="collapse-next" class="has-submenu">
                            <em class="icon icon-admin"></em>
                            <span class="item-text">Administration</span>
                        </a>


                        <ul id="ulAdmin" class="nav collapse out">
                            <li>
                                <g:link url="[action: 'adminUser', controller: 'user']" data-toggle=""
                                        class="no-submenu">
                                    <span class="item-text" style="font-size: 13px;">Users</span>
                                </g:link>
                            </li>
                            <li>
                                <g:link url="[action: 'adminAreaList', controller: 'area']" data-toggle=""
                                        class="no-submenu">
                                    <span class="item-text" style="font-size: 13px;">Locations & Areas</span>
                                </g:link>
                            </li>
                            <li>
                                <g:link url="[action: 'adminItemList', controller: 'item']" data-toggle=""
                                        class="no-submenu">
                                    <span class="item-text" style="font-size: 13px;">Items</span>
                                </g:link>
                            </li>
                            <li>
                                <g:link url="[action: 'newInventory', controller: 'inventory']" data-toggle=""
                                        class="no-submenu">
                                    <span class="item-text" style="font-size: 13px;">Inventory Adjustment</span>
                                </g:link>
                            </li>
                            <li>
                                <g:link url="[action: 'inventoryTrackingReport', controller: 'inventory']" data-toggle=""
                                        class="no-submenu">
                                    <span class="item-text" style="font-size: 13px;">Activity Log</span>
                                </g:link>
                            </li>
                            <li>
                                <g:link url="[action: 'adminListValue', controller: 'settings']" data-toggle=""
                                        class="no-submenu">
                                    <span class="item-text" style="font-size: 13px;">Configuration</span>
                                </g:link>
                            </li>
                            <li>
                                <g:link url="[action: 'companyProfile', controller: 'company']" data-toggle=""
                                        class="no-submenu">
                                    <span class="item-text" style="font-size: 13px;">Company Profile</span>
                                </g:link>
                            </li>
                            <li>
                                <g:link url="[action: 'index', controller: 'printer']" data-toggle=""
                                        class="no-submenu">
                                    <span class="item-text" style="font-size: 13px;">Printers</span>
                                </g:link>
                            </li>
                        </ul>

                    </li>
                </g:if>


                <li id="liUserAccount">
                    <g:link url="[action: 'index', controller: 'userAccount']" data-toggle="" class="no-submenu"
                            title="Account">
                        <em class="icon icon-settings"></em>
                        <span class="item-text">Account</span>
                    </g:link>
                </li>

                <!--+build-menu-items(secondMenu)-->
                <!-- START Theme color options -->
                <!-- END Theme color options-->
                <!-- END Menu-->
            </ul>

            <div data-toggle-state="aside-collapsed" class="">
            </div>
        </nav>
        <!-- END Sidebar (left)-->
    </aside>
    <!-- End aside-->
    <!-- START aside-->
    %{--<aside class="offsidebar">
        <!-- START Off Sidebar (right)-->
        <nav>
            <div class="text-center">
                <h3>Alert</h3>
            </div>

            <div class="p-recent p-lg text-left">
                <p>Recent Alerts</p>
            </div>
            <ul class="nav">
                <li ng-app="alertapp" ng-controller="alertContoller" ng-init="showData()">
                    <!-- START Alert status-->
                    <a href="#" class="media p mt0" ng-repeat="datalist in datalists | limitTo: paginationLimit()">
                        <!-- Contact info-->
                        <span class="media-body">
                            <span class="media-heading">
                                <strong>{{ datalist.senderId }}</strong>
                                <br>
                                <small class="text-muted">{{ datalist.message }}</small>
                            </span>
                        </span>
                    </a>
                    <!-- END Alert status-->

                    <div class="p-lg text-center">
                        <!-- Optional link to list more alerts-->
                        <button ng-show="hasMoreItemsToShow()" ng-click="showMoreItems()"
                                class="btn btn-purple btn-sm">Load more..</button>
                    </div>
                </li>
            </ul>

            <div class="task p p-lg">
                <p>Tasks completion</p>

                <div class="progress progress-xs m0">
                    <div role="progressbar" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"
                         class="progress-bar progress-bar-blue progress-50">
                        <span class="sr-only">50% Complete</span>
                    </div>
                </div>
            </div>

            <div class="task p p-lg">
                <p>Upload quota</p>

                <div class="progress progress-xs m0">
                    <div role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100"
                         class="progress-bar progress-bar-red progress-40">
                        <span class="sr-only">40% Complete</span>
                    </div>
                </div>
            </div>
        </nav>
        <!-- END Off Sidebar (right)-->
    </aside>--}%
    <!-- END aside-->
    <!-- START Main section-->
    <section class="main-section">

        <!-- START Page content-->
        <div class="content-wrapper" style="">

            <g:layoutBody/>


        </div>
        <!-- END Page content-->

    </section>
    <!-- END Main section-->
</div>
<!-- END Main wrapper-->
<!-- START Scripts-->
<!-- Main vendor Scripts-->
<script src="${request.contextPath}/foysonis2016/vendor/jquery/jquery.min.js"></script>
<script src="${request.contextPath}/foysonis2016/vendor/bootstrap/js/bootstrap.min.js"></script>
<!-- Plugins-->
<script src="${request.contextPath}/foysonis2016/vendor/chosen/chosen.jquery.min.js"></script>
<script src="${request.contextPath}/foysonis2016/vendor/slider/js/bootstrap-slider.js"></script>
<script src="${request.contextPath}/foysonis2016/vendor/filestyle/bootstrap-filestyle.min.js"></script>
<!-- Animo-->
<!-- Sparklines-->
<script src="${request.contextPath}/foysonis2016/vendor/sparklines/jquery.sparkline.min.js"></script>
<!-- Slimscroll-->
<script src="${request.contextPath}/foysonis2016/vendor/slimscroll/jquery.slimscroll.min.js"></script>
<!-- Store + JSON-->
<script src="${request.contextPath}/foysonis2016/vendor/store/store+json2.min.js"></script>
<!-- ScreenFull-->
<script src="${request.contextPath}/foysonis2016/vendor/screenfull/screenfull.min.js"></script>
<script src="${request.contextPath}/foysonis2016/vendor/animo/animo.min.js"></script>
<!-- START Page Custom Script-->
<!--if (firstMenu['Elements']['S']['Portlets']['active'] || secondMenu['Extras']['S']['Calendar']['active'])// jQuery UI
script(src='vendor/jqueryui/js/jquery-ui-1.10.4.custom.min.js')
script(src='vendor/touch-punch/jquery.ui.touch-punch.min.js')
-->
<!--if (secondMenu['Extras']['S']['Calendar']['active'])// MomentJs
script(src='vendor/moment/min/moment-with-langs.min.js')
// FulCalendar
script(src='vendor/fullcalendar/fullcalendar.min.js')
-->
<!--if (firstMenu['Forms']['S']['Extended']['active'])// Markdown Area Codemirror and dependencies
script(src='vendor/codemirror/lib/codemirror.js')
script(src='vendor/codemirror/addon/mode/overlay.js')
script(src='vendor/codemirror/mode/markdown/markdown.js')
script(src='vendor/codemirror/mode/xml/xml.js')
script(src='vendor/codemirror/mode/gfm/gfm.js')
script(src='vendor/marked/marked.js')
-->
<!--if (firstMenu['Forms']['S']['Extended']['active'] || secondMenu['Extras']['S']['Search']['active'])// MomentJs and Datepicker
script(src='vendor/moment/min/moment-with-langs.min.js')
script(src='vendor/datetimepicker/js/bootstrap-datetimepicker.min.js')
// Tags input
script(src='vendor/tagsinput/bootstrap-tagsinput.min.js')
// Input Mask
script(src='vendor/inputmask/jquery.inputmask.bundle.min.js')
-->
<!--if (firstMenu['Forms']['S']['Wizard']['active'])script(src='vendor/wizard/js/bwizard.min.js')
-->
<!--if (firstMenu['Tables']['S']['DataTables']['active'])// Data Table Scripts
script(src='vendor/datatable/media/js/jquery.dataTables.min.js')
script(src='vendor/datatable/extensions/datatable-bootstrap/js/dataTables.bootstrap.js')
script(src='vendor/datatable/extensions/datatable-bootstrap/js/dataTables.bootstrapPagination.js')
script(src='vendor/datatable/extensions/ColVis/js/dataTables.colVis.min.js')

-->
<!--if (firstMenu['Forms']['S']['Validation']['active'] || firstMenu['Forms']['S']['Wizard']['active'])// Form Validation
script(src='vendor/parsley/parsley.min.js')

-->
<!--if (firstMenu['Charts']['S']['Flot']['active'] || firstMenu['Dashboard']['active'])//  Flot Charts
script(src='vendor/flot/jquery.flot.min.js')
script(src='vendor/flot/jquery.flot.tooltip.min.js')
script(src='vendor/flot/jquery.flot.resize.min.js')
script(src='vendor/flot/jquery.flot.pie.min.js')
script(src='vendor/flot/jquery.flot.time.min.js')
script(src='vendor/flot/jquery.flot.categories.min.js')

<!--[if lt IE 8]>
script(src='js/excanvas.min.js')
<![endif]-->


<!--if (firstMenu['Widgets']['active'] || firstMenu['Elements']['S']['Maps']['active'])// Gmap
script(type='text/javascript', src='http://maps.google.com/maps/api/js?sensor=false')
script(src='vendor/gmap/jquery.gmap.min.js')
-->
<!-- END Page Custom Script-->
<!-- App Main-->
<script src="${request.contextPath}/foysonis2016/app/js/app.js"></script>
<!-- END Scripts-->

%{--Date Control--}%
%{--<asset:javascript src="i18n/angular-locale_de-at.js"/>--}%
<asset:javascript src="ui-bootstrap-tpls.js"/>
%{--Date Control--}%

<asset:javascript src="datagrid/user-account-image.js"/>
<asset:javascript src="datagrid/support-link.js"/>
<asset:javascript src="datagrid/admin-billing.js"/>


<script type="text/javascript">
var dvCompanyBilling = document.getElementById('dvCompanyBilling');
angular.element(document).ready(function() {
angular.bootstrap(dvCompanyBilling, ['companyBilling']);
});

var dvUserAccountImage = document.getElementById('userAccountImageDiv');
angular.element(document).ready(function() {
    angular.bootstrap(dvUserAccountImage, ['userAccountImage']);
});

var openUserGuide = function(){
    $("#userGuideFrame").attr("src","/user/getUserGuideHtml");
    $('#userGuideModal').appendTo("body").modal('show');
};

</script>

<!-- Start of foysonishelp Zendesk Widget script -->
<g:if test="${session.SPRING_SECURITY_CONTEXT.getAuthentication().companyPaymentMethod == 'Standard' || session.SPRING_SECURITY_CONTEXT.getAuthentication().companyPaymentMethod == 'Premium'}">
<script>

    /*<![CDATA[*/window.zEmbed||function(e,t){var n,o,d,i,s,a=[],r=document.createElement("iframe");window.zEmbed=function(){a.push(arguments)},window.zE=window.zE||window.zEmbed,r.src="javascript:false",r.title="",r.role="presentation",(r.frameElement||r).style.cssText="display: none",d=document.getElementsByTagName("script"),d=d[d.length-1],d.parentNode.insertBefore(r,d),i=r.contentWindow,s=i.document;try{o=s}catch(e){n=document.domain,r.src='javascript:var d=document.open();d.domain="'+n+'";void(0);',o=s}o.open()._l=function(){var o=this.createElement("script");n&&(this.domain=n),o.id="js-iframe-async",o.src=e,this.t=+new Date,this.zendeskHost=t,this.zEQueue=a,this.body.appendChild(o)},o.write('<body onload="document._l();">'),o.close()}("https://assets.zendesk.com/embeddable_framework/main.js","foysonishelp.zendesk.com");
/*]]>*/

</script>
</g:if>
<!-- End of foysonishelp Zendesk Widget script -->


</body>

</html>
