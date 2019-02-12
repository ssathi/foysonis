<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="foysonis2016"/>

    <style>

        [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
            display: none !important;
        }

        .arrowDiv{
          width: 0; 
          height: 0; 
          border-top: 45px solid transparent;
          border-bottom: 45px solid transparent;
          border-left: 50px solid rgb(243,243,244);
        }

        .putawayTitle{
            float: left; 
            background-color: rgb(243,243,244); 
            padding: 10px;
            border: 2px solid #bcbcbd;
            border-right: 0px;
        }

        .putawayValues{
            margin-left: 0px;
            margin-top: 0px;
            background-color: rgb(218,218,220);
            padding: 10px;
            height: 94px;
            text-align: right;  
            border: 2px solid #bcbcbd;
        }

        .panel-default > .panel-heading{
            border-bottom: 1px solid #cfdbe2;
        }

    </style>

    <asset:javascript src="dashboard/ng-google-chart.js"/>
    <asset:javascript src="dashboard/loader.js"/>
    <script type="application/javascript">
        window.onload = function(){
            document.getElementById('receiptDuration').selectedIndex = 1;
            document.getElementById('userPicksDuration').selectedIndex = 1;
        }



    </script>

</head>

<body>

<div class="row">

    <div class="col-lg-12">

        <div style="display: inline;"><em class="icon icon-dashboar" style="font-size: 20px; color: #315B91;"></em>&emsp;<span class="headerTitle" style="vertical-align: bottom;">Dashboard</span></div>

        <br style="clear: both;">
        <br style="clear: both;">


        <div ng-cloak id="dvDashboard" ng-controller="dashboardCtrl as ctrl">

            %{--<!-- START widget-->--}%
            %{--<div class="panel widget bg-inverse" style="padding: 0px; border-radius: 2px;">--}%
                %{--<div class="row">--}%
                    %{--<div class="col-sm-2 text-right">--}%
                        %{--<div class="row">--}%
                            %{--<div class="col-sm-9 col-xs-4">--}%
                                %{--<div class="ph">--}%
                                    %{--<p class="h3 mb0">11200</p>--}%
                                    %{--<p class="m0 text-muted">Picks</p>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                            %{--<div class="col-sm-9 col-xs-4">--}%
                                %{--<div class="ph">--}%
                                    %{--<p class="h3 mb0">2000</p>--}%
                                    %{--<p class="m0 text-muted">Shipments</p>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                            %{--<div class="col-sm-9 col-xs-4">--}%
                                %{--<div class="ph">--}%
                                    %{--<p class="h3 mb0">1500</p>--}%
                                    %{--<p class="text-muted">Orders</p>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                    %{--</div>--}%
                    %{--<div class="col-sm-10 bg-primary">--}%
                        %{--<div class="p-lg">--}%
                            %{--<div class="h5 mt0">Latest statistics</div>--}%
                            %{--<!-- Line chart-->--}%
                            %{--<div data-type="line" data-height="100" data-width="100%" data-line-width="2" data-line-color="#dddddd" data-spot-color="#bbbbbb" data-fill-color="" data-highlight-line-color="#fff" data-spot-radius="3" data-resize="true"--}%
                                 %{--class="inlinesparkline sparkline">--}%
                                %{--<!-- 1,5,3,6,5,11,2,4,5,7,9,6,4-->--}%
                            %{--</div>--}%
                            %{--<!-- Bar chart-->--}%
                            %{--<div class="text-center">--}%
                                %{--<div data-bar-color="#fff" data-height="60" data-bar-width="8" data-bar-spacing="6" class="inlinesparkline inline">1,5,3,6,5,8,2,4,5,7,9,6,4,3,6,5,9,2</div>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                    %{--</div>--}%
                %{--</div>--}%
            %{--</div>--}%
            <!-- END widget-->


            %{--<div class="row">--}%
                %{--<div class="col-md-4">--}%
                    %{--<!-- START widget-->--}%
                    %{--<div data-toggle="play-animation" data-play="fadeInLeft" data-offset="0" data-delay="100" class="panel widget">--}%
                        %{--<div class="panel-body bg-primary">--}%
                            %{--<div class="row row-table row-flush">--}%
                                %{--<div class="col-xs-8">--}%
                                    %{--<p class="mb0">New Orders Today</p>--}%
                                    %{--<h3 class="m0">150</h3>--}%
                                %{--</div>--}%
                                %{--<div class="col-xs-4 text-right">--}%
                                    %{--<em class="fa fa-share-alt fa-2x"></em>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                        %{--<div class="panel-body">--}%
                            %{--<!-- Bar chart-->--}%
                            %{--<div class="text-center">--}%
                                %{--<div data-bar-color="primary" data-height="30" data-bar-width="6" data-bar-spacing="6" class="inlinesparkline inline">5,3,4,6,5,9,4,4,10,5,9,6,4</div>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                    %{--</div>--}%
                %{--</div>--}%
                %{--<div class="col-md-4">--}%
                    %{--<!-- START widget-->--}%
                    %{--<div data-toggle="play-animation" data-play="fadeInDown" data-offset="0" data-delay="100" class="panel widget">--}%
                        %{--<div class="panel-body bg-success">--}%
                            %{--<div class="row row-table row-flush">--}%
                                %{--<div class="col-xs-8">--}%
                                    %{--<p class="mb0">Pending Shipments</p>--}%
                                    %{--<h3 class="m0">540</h3>--}%
                                %{--</div>--}%
                                %{--<div class="col-xs-4 text-right">--}%
                                    %{--<em class="fa fa-cloud-upload fa-2x"></em>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                        %{--<div class="panel-body">--}%
                            %{--<!-- Bar chart-->--}%
                            %{--<div class="text-center">--}%
                                %{--<div data-bar-color="success" data-height="30" data-bar-width="6" data-bar-spacing="6" class="inlinesparkline inline">10,30,40,70,50,90,70,50,90,40,40,60,40</div>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                    %{--</div>--}%
                %{--</div>--}%
                %{--<div class="col-md-4">--}%
                    %{--<!-- START widget-->--}%
                    %{--<div data-toggle="play-animation" data-play="fadeInRight" data-offset="0" data-delay="100" class="panel widget">--}%
                        %{--<div class="panel-body bg-danger">--}%
                            %{--<div class="row row-table row-flush">--}%
                                %{--<div class="col-xs-8">--}%
                                    %{--<p class="mb0">Pending Picks</p>--}%
                                    %{--<h3 class="m0">7000</h3>--}%
                                %{--</div>--}%
                                %{--<div class="col-xs-4 text-right">--}%
                                    %{--<em class="fa fa-star fa-2x"></em>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                        %{--<div class="panel-body">--}%
                            %{--<!-- Bar chart-->--}%
                            %{--<div class="text-center">--}%
                                %{--<div data-bar-color="danger" data-height="30" data-bar-width="6" data-bar-spacing="6" class="inlinesparkline inline">2,7,5,9,4,2,7,5,7,5,9,6,4</div>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                    %{--</div>--}%
                %{--</div>--}%
            %{--</div>--}%




                <!-- START messages and activity-->
            <div class="row">

                <!-- START Google Chart-->

                <div class="col-md-4">
                    <div class="panel panel-default" style="height: 360px;">
                        <div class="panel-heading">
                            <div class="panel-title">Receipts</div>
                        </div>
                        <!-- START list group-->
                        <div style="padding: 10px 100px;">
                            <select  id="receiptDuration" name="receiptDuration" ng-model="$scope.receiptDuration" class="form-control" ng-change="filterReceipt($scope.receiptDuration)">
                                <option  disabled hidden style='display: none' value=''></option>
                                <option selected value="0">Today</option>
                                <option value="3">3 Days</option>
                                <option value="7">7 Days</option>
                                <option value="30">30 Days</option>
                            </select>
                        </div>



                        <div google-chart chart="chart" style="padding: 10px;" ng-if="!showEmptyResults">
                        </div>
                        <div class="alert  message-animation" role="alert" ng-if="showEmptyResults" style="text-align: center;">
                            0 receipts processed {{receiptSelectedText | lowercase}}
                        </div>


                        <!-- END list group-->
                    </div>
                </div>

                <!-- END Google Chart-->


                <div class="col-md-4">

                    <div class="panel panel-default"  style="height: 360px;">

                        <div class="panel-heading">
                            <div class="panel-title">Pending Putaway</div>
                        </div>

                        <div class="panel-body" style="margin-top: 75px;">

                            <div class="putawayTitle">
                                <h4>{{pendingPallets}} Pending Pallets</h4>
                                <h4>{{pendingCases}} Pending Cases</h4>
                            </div>

                            <div class="arrowDiv" style="float: left;">
                                <!-- <p><span class="fa fa-hand-o-right fa-3x" aria-hidden="true"></span></p> -->
                            </div>
                            <div class="putawayValues">
                                <h5>{{pendingEachesTotalCount}} Eaches</h5>
                                <h5>{{pendingCasesTotalCount}} Cases</h5>
                            </div>

                            <br style="clear: both;"/>

                        </div>

                    </div>
                </div>

                <div class="col-md-4">
                    <div class="panel panel-default" style="height: 360px;">
                        <div class="panel-heading">
                            <div class="panel-title">Open Receipts</div>
                        </div>


                        <div id="chart_div"></div>
                        <div id="receipt_case_chart_div"></div>


                    </div>
                </div>
            </div>
            <!-- END messages and activity-->

            <div class="row">
                <div class="col-md-4">
                    <div class="panel panel-default" style="height: 360px;">
                        <div class="panel-heading">
                            <div class="panel-title">Orders</div>
                        </div>

                        <div id="orders_chart_div"></div>

                    </div>
                </div>
                <div class="col-md-4">
                    <div class="panel panel-default" style="height: 360px;">
                        <div class="panel-heading">
                            <div class="panel-title">Shipments</div>
                        </div>

                        <div id="shipments_chart_div"></div>

                    </div>
                </div>


                <div class="col-md-4">
                    <div class="panel panel-default" style="height: 360px;">
                        <div class="panel-heading">
                            <div class="panel-title">Picks</div>
                        </div>

                        <div class="panel-body">
                            Picks have been performed today: {{picksPerformedToday}}
                        </div>

                        <div google-chart chart="pickChart" style="padding: 10px 0px;">
                        </div>

                        <!-- END list group-->
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="panel panel-default" style="height: 360px;">
                        <div class="panel-heading">
                            <div class="panel-title">Picks By User</div>
                        </div>

                        <div style="padding: 10px 100px;">
                            <select  id="userPicksDuration" name="userPicksDuration" ng-model="$scope.userPicksDuration" class="form-control" ng-change="filterUserPicks($scope.userPicksDuration)">
                                <option  disabled hidden style='display: none' value=''></option>
                                <option selected value="0">Today</option>
                                <option value="3">3 Days</option>
                                <option value="7">7 Days</option>
                                <option value="30">30 Days</option>
                            </select>
                        </div>

                        <div class="panel-body" ng-if="!showEmptyUserPicksResults" style="margin-bottom: -10px;">
                            Average picks by user: {{averagePicksByUser}}
                        </div>

                        <div google-chart chart="userPicksChart" style="padding: 10px;" ng-if="!showEmptyUserPicksResults">
                        </div>
                        <div class="alert  message-animation" role="alert" ng-if="showEmptyUserPicksResults" style="text-align: center;">
                            0 picks performed {{userPicksSelectedText | lowercase}}
                        </div>

                        <!-- END list group-->
                    </div>
                </div>


                <div class="col-md-4">
                    <div class="panel panel-default" style="height: 360px;">
                        <div class="panel-heading">
                            <div class="panel-title">Inventory Status</div>
                        </div>

                        <div google-chart chart="inventoryStatusChart" style="padding: 10px 0px;">
                        </div>

                        <!-- END list group-->
                    </div>
                </div>

            </div>



            %{--<div class="row">--}%

                %{--<div class="col-md-4">--}%
                    %{--<div class="panel panel-default">--}%
                        %{--<div class="panel-heading">--}%
                            %{--<div class="pull-right label label-danger">5</div>--}%
                            %{--<div class="pull-right label label-success">12</div>--}%
                            %{--<div class="panel-title">Messages</div>--}%
                        %{--</div>--}%
                        %{--<!-- START list group-->--}%
                        %{--<div class="list-group">--}%
                            %{--<!-- START list group item-->--}%
                            %{--<a href="#" class="list-group-item">--}%
                                %{--<div class="media">--}%
                                    %{--<div class="pull-left">--}%
                                        %{--<img src="${request.contextPath}/foysonis2016/app/img/user/01.jpg" alt="Image" class="media-object img-circle thumb48">--}%
                                    %{--</div>--}%
                                    %{--<div class="media-body clearfix">--}%
                                        %{--<small class="pull-right">2h</small>--}%
                                        %{--<strong class="media-heading text-primary">--}%
                                            %{--<span class="circle circle-success circle-lg text-left"></span>Jean Daniels</strong>--}%
                                        %{--<p class="mb-sm">--}%
                                            %{--<small>Cras sit amet nibh libero, in gravida nulla. Nulla...</small>--}%
                                        %{--</p>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</a>--}%
                            %{--<!-- END list group item-->--}%
                            %{--<!-- START list group item-->--}%
                            %{--<a href="#" class="list-group-item">--}%
                                %{--<div class="media">--}%
                                    %{--<div class="pull-left">--}%
                                        %{--<img src="${request.contextPath}/foysonis2016/app/img/user/04.jpg" alt="Image" class="media-object img-circle thumb48">--}%
                                    %{--</div>--}%
                                    %{--<div class="media-body clearfix">--}%
                                        %{--<small class="pull-right">3h</small>--}%
                                        %{--<strong class="media-heading text-primary">--}%
                                            %{--<span class="circle circle-success circle-lg text-left"></span>Alexis Wright</strong>--}%
                                        %{--<p class="mb-sm">--}%
                                            %{--<small>Cras sit amet nibh libero, in gravida nulla. Nulla facilisi.</small>--}%
                                        %{--</p>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</a>--}%
                            %{--<!-- END list group item-->--}%
                            %{--<!-- START list group item-->--}%
                            %{--<a href="#" class="list-group-item">--}%
                                %{--<div class="media">--}%
                                    %{--<div class="pull-left">--}%
                                        %{--<img src="${request.contextPath}/foysonis2016/app/img/user/03.jpg" alt="Image" class="media-object img-circle thumb48">--}%
                                    %{--</div>--}%
                                    %{--<div class="media-body clearfix">--}%
                                        %{--<small class="pull-right">4h</small>--}%
                                        %{--<strong class="media-heading text-primary">--}%
                                            %{--<span class="circle circle-danger circle-lg text-left"></span>Lance Simpson</strong>--}%
                                        %{--<p class="mb-sm">--}%
                                            %{--<small>Cras sit amet nibh libero, in gravida nulla. Nulla...</small>--}%
                                        %{--</p>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</a>--}%
                            %{--<!-- END list group item-->--}%
                            %{--<!-- START list group item-->--}%
                            %{--<a href="#" class="list-group-item">--}%
                                %{--<div class="media">--}%
                                    %{--<div class="pull-left">--}%
                                        %{--<img src="${request.contextPath}/foysonis2016/app/img/user/06.jpg" alt="Image" class="media-object img-circle thumb48">--}%
                                    %{--</div>--}%
                                    %{--<div class="media-body clearfix">--}%
                                        %{--<small class="pull-right">4h</small>--}%
                                        %{--<strong class="media-heading text-primary">--}%
                                            %{--<span class="circle circle-danger circle-lg text-left"></span>Krin Price</strong>--}%
                                        %{--<p class="mb-sm">--}%
                                            %{--<small>Vestibulum pretium aliquam scelerisque.</small>--}%
                                        %{--</p>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</a>--}%
                            %{--<!-- END list group item-->--}%
                            %{--<!-- START list group item-->--}%
                            %{--<a href="#" class="list-group-item">--}%
                                %{--<div class="media">--}%
                                    %{--<div class="pull-left">--}%
                                        %{--<img src="${request.contextPath}/foysonis2016/app/img/user/06.jpg" alt="Image" class="media-object img-circle thumb48">--}%
                                    %{--</div>--}%
                                    %{--<div class="media-body clearfix">--}%
                                        %{--<small class="pull-right">4h</small>--}%
                                        %{--<strong class="media-heading text-primary">--}%
                                            %{--<span class="circle circle-lg text-left"></span>Johnny Gilbert</strong>--}%
                                        %{--<p class="mb-sm">--}%
                                            %{--<small>Sed egestas, augue vitae blandit imperdiet, justo neque tincidunt sapien...</small>--}%
                                        %{--</p>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</a>--}%
                            %{--<!-- END list group item-->--}%
                        %{--</div>--}%
                        %{--<!-- END list group-->--}%
                        %{--<!-- START panel footer-->--}%
                        %{--<div class="panel-footer clearfix">--}%
                            %{--<div class="input-group">--}%
                                %{--<input type="text" placeholder="Search message .." class="form-control input-sm">--}%
                                %{--<span class="input-group-btn">--}%
                                    %{--<button type="submit" class="btn btn-default btn-sm"><i class="fa fa-search"></i>--}%
                                    %{--</button>--}%
                                %{--</span>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                        %{--<!-- END panel-footer-->--}%
                    %{--</div>--}%
                %{--</div>--}%

                %{--<div class="col-md-4">--}%
                    %{--<div class="panel panel-default">--}%
                        %{--<div class="panel-heading">--}%
                            %{--<div class="panel-title">News feed</div>--}%
                        %{--</div>--}%
                        %{--<!-- START list group-->--}%
                        %{--<div class="list-group">--}%
                            %{--<!-- START list group item-->--}%
                            %{--<div class="list-group-item">--}%
                                %{--<div class="media">--}%
                                    %{--<div class="pull-left">--}%
                                        %{--<span class="fa-stack fa-lg">--}%
                                            %{--<em class="fa fa-circle fa-stack-2x text-purple"></em>--}%
                                            %{--<em class="fa fa-cloud-upload fa-stack-1x fa-inverse text-white"></em>--}%
                                        %{--</span>--}%
                                    %{--</div>--}%
                                    %{--<div class="media-body clearfix">--}%
                                        %{--<div class="media-heading text-purple m0">NEW FILE</div>--}%
                                        %{--<small class="text-muted pull-right">15 minutes ago</small>--}%
                                        %{--<p class="m0">--}%
                                            %{--<small>A new uploaded file <a href="#">Bootstrap.xls </a> is now on the cloud</small>--}%
                                        %{--</p>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                            %{--<!-- END list group item-->--}%
                            %{--<!-- START list group item-->--}%
                            %{--<div class="list-group-item">--}%
                                %{--<div class="media">--}%
                                    %{--<div class="pull-left">--}%
                                        %{--<span class="fa-stack fa-lg">--}%
                                            %{--<em class="fa fa-circle fa-stack-2x text-info"></em>--}%
                                            %{--<em class="fa fa-file-text-o fa-stack-1x fa-inverse text-white"></em>--}%
                                        %{--</span>--}%
                                    %{--</div>--}%
                                    %{--<div class="media-body clearfix">--}%
                                        %{--<div class="media-heading text-info m0">NEW DOCUMENT</div>--}%
                                        %{--<small class="text-muted pull-right">2 hours ago</small>--}%
                                        %{--<p class="m0">--}%
                                            %{--<small>New document <a href="#">Bootstrap.doc </a> created</small>--}%
                                        %{--</p>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                            %{--<!-- END list group item-->--}%
                            %{--<!-- START list group item-->--}%
                            %{--<div class="list-group-item">--}%
                                %{--<div class="media">--}%
                                    %{--<div class="pull-left">--}%
                                        %{--<span class="fa-stack fa-lg">--}%
                                            %{--<em class="fa fa-circle fa-stack-2x text-danger"></em>--}%
                                            %{--<em class="fa fa-exclamation fa-stack-1x fa-inverse text-white"></em>--}%
                                        %{--</span>--}%
                                    %{--</div>--}%
                                    %{--<div class="media-body clearfix">--}%
                                        %{--<div class="media-heading text-danger m0">IMPORTANT MESSAGE</div>--}%
                                        %{--<small class="text-muted pull-right">5 hours ago</small>--}%
                                        %{--<p class="m0">--}%
                                            %{--<small>Todd Walker sent you an important messsage. <a href="#">Open</a>--}%
                                            %{--</small>--}%
                                        %{--</p>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                            %{--<!-- END list group item-->--}%
                            %{--<!-- START list group item-->--}%
                            %{--<div class="list-group-item">--}%
                                %{--<div class="media">--}%
                                    %{--<div class="pull-left">--}%
                                        %{--<span class="fa-stack fa-lg">--}%
                                            %{--<em class="fa fa-circle fa-stack-2x text-success"></em>--}%
                                            %{--<em class="fa fa-clock-o fa-stack-1x fa-inverse text-white"></em>--}%
                                        %{--</span>--}%
                                    %{--</div>--}%
                                    %{--<div class="media-body clearfix">--}%
                                        %{--<div class="media-heading text-success m0">NEW MEETING</div>--}%
                                        %{--<small class="text-muted pull-right">15 hours ago</small>--}%
                                        %{--<p class="m0">--}%
                                            %{--<small>Roberta Lane added a new meeting.--}%
                                                %{--<em>Hey Guys! Want to see there tomorrow. We have good new to share with you. Cheers!</em>--}%
                                            %{--</small>--}%
                                        %{--</p>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                            %{--<!-- END list group item-->--}%
                            %{--<!-- START list group item-->--}%
                            %{--<div class="list-group-item">--}%
                                %{--<div class="media">--}%
                                    %{--<div class="pull-left">--}%
                                        %{--<span class="fa-stack fa-lg">--}%
                                            %{--<em class="fa fa-circle fa-stack-2x text-warning"></em>--}%
                                            %{--<em class="fa fa-envelope-o fa-stack-1x fa-inverse text-white"></em>--}%
                                        %{--</span>--}%
                                    %{--</div>--}%
                                    %{--<div class="media-body clearfix">--}%
                                        %{--<div class="media-heading text-warning m0">ANOTHER MESSAGE</div>--}%
                                        %{--<small class="text-muted pull-right">last week</small>--}%
                                        %{--<p class="m0">--}%
                                            %{--<small>Estela Soccer sent you a messsage. Quisque viverra faucibus neque, quis elementum velit vulputate et.</small>--}%
                                        %{--</p>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                            %{--<!-- END list group item-->--}%
                        %{--</div>--}%
                        %{--<!-- END list group-->--}%
                        %{--<!-- START panel footer-->--}%
                        %{--<div class="panel-footer clearfix">--}%
                            %{--<a href="#" class="pull-left">--}%
                                %{--<small>Load more</small>--}%
                            %{--</a>--}%
                        %{--</div>--}%
                        %{--<!-- END panel-footer-->--}%
                    %{--</div>--}%
                %{--</div>--}%
            %{--</div>--}%



        </div>





        %{--<g:each var="alert" in="${alerts}" status="counter">--}%

            %{--<g:form controller='alert' action='confirmAlert'>--}%

                %{--<!-- START panel-->--}%
                %{--<div class="panel panel-default">--}%
                 %{--<div class="panel-body">--}%
                    %{--<b> From  :</b> ${alert.senderId}<br/>--}%
                     %{--${alert.message}--}%
                     %{--<input type = 'hidden' name="alertId" value ='${alert.id}'/>--}%
                    %{--<div align = 'right'>--}%
                       %{--<input type = 'submit' value = 'OK' class="btn btn-info"/>--}%
                    %{--</div>--}%
                 %{--</div>--}%
                %{--</div>--}%
                %{--<!-- END panel-->--}%

            %{--</g:form>--}%

        %{--</g:each>--}%
    </div>


    %{--<div class="col-lg-3">--}%

        %{--<g:if test="${flash.success}">--}%
            %{--<div class="alert alert-success alert-dismissable">--}%
                %{--<button type="button" data-dismiss="alert" aria-hidden="true" class="close">×</button>${flash.success}--}%
            %{--</div>--}%
        %{--</g:if>--}%

        %{--<div class="panel panel-primary" id="dvNewAlert" ng-controller="MyCtrl">--}%
        %{--<div class="panel-heading">Create Alert</div>--}%
        %{--<g:form name="alertForm" controller="alert" action="send" method="post" ng-submit="submitForm()">--}%

            %{--<div class="panel-body">--}%
                %{--<div class="form-group has-feedback">--}%
                    %{--<label class="control-label">To</label>--}%
                    %{--<g:if test="${session.user.adminActiveStatus == true }">--}%
                        %{--<div auto-complete-multi--}%
                             %{--placeholder="Enter Username"--}%
                             %{--xxxx-list-formatter="customListFormatter"--}%
                             %{--prefill-func="prefillFunc('prefill2.json?ids='+foo_ids)"--}%
                             %{--source="source3"--}%
                             %{--value-changed="callback(value)">--}%
                            %{--<select username='sp' ng-disabled="disabled" ng-model="foo"></select>--}%
                            %{--<input type="hidden" name="username" ng-model="foo_ids" value="{{ foo_ids }}" required class="form-control" required>--}%
                        %{--</div>--}%
                    %{--</g:if>--}%

                    %{--<g:else>--}%
                        %{--<div auto-complete-multi--}%
                             %{--placeholder="Enter Username"--}%
                             %{--xxxx-list-formatter="customListFormatter"--}%
                             %{--prefill-func="prefillFunc('prefill2.json?ids='+foo_ids)"--}%
                             %{--source="source2"--}%
                             %{--value-changed="callback(value)">--}%
                            %{--<select username='sp' ng-disabled="disabled" ng-model="foo"></select>--}%
                            %{--<input type="hidden" name="username" ng-model="foo_ids" value="{{ foo_ids }}" required class="form-control" required>--}%
                        %{--</div>--}%
                    %{--</g:else>--}%
                %{--</div>--}%


                %{--<div class="form-group has-feedback">--}%
                    %{--<label class="control-label">Message</label>--}%
                    %{--<textarea name="message"></textarea>--}%
                %{--</div>--}%

                %{--<div class="form-group">--}%
                    %{--<label for="message">Message</label>--}%
                    %{--<div class="controls">--}%
                        %{--<textarea id="message" name="message" class="form-control"></textarea>--}%
                    %{--</div>--}%
                %{--</div>--}%

            %{--</div>--}%
        %{--<div class="panel-footer">--}%
            %{--<div class="clearfix">--}%
                %{--<div class="pull-right">--}%
                    %{--<button type="submit" class="btn btn-primary" ng-disabled="alertForm.$invalid">Send</button>--}%
                %{--</div>--}%
            %{--</div>--}%
        %{--</div>--}%
%{--</g:form>--}%
    %{--</div>--}%
        <!--create alert-->

        %{--<div  class="panel panel-primary">--}%
            %{--<div class="panel-heading">Recent Alerts</div>--}%
            %{--<div class="panel-body" style="height: 300px; overflow: scroll;">--}%

                %{--<div ng-cloak id="dvAlert" ng-controller="alertContoller" ng-init="showData()">--}%

                    %{--<table class="table table-striped table-bordered table-hover">--}%
                        %{--<tbody>--}%
                        %{--<tr ng-repeat="datalist in datalists | limitTo: paginationLimit()">--}%
                            %{--<td>--}%
                                %{--<div class="media">--}%
                                    %{--<div class="media-body">--}%
                                        %{--<h4 class="media-heading">{{ datalist.senderId }}</h4>--}%
                                        %{--<p>{{ datalist.message }}</p>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</td>--}%
                        %{--</tr>--}%
                        %{--</tbody>--}%
                    %{--</table>--}%
                    %{--<div class="p-lg text-center">--}%
                        %{--<!-- Optional link to list more alerts-->--}%
                        %{--<button ng-show="hasMoreItemsToShow()" ng-click="showMoreItems()" class="btn btn-purple btn-sm">Load more..</button>--}%
                    %{--</div>--}%

                    %{--</div>--}%

            %{--</div>--}%
        %{--</div>--}%

    </div>
</div>


%{--<script type="text/javascript">
    document.getElementById("alert_toggle").attributes.removeNamedItem('data-toggle-state');
    var dvAlert = document.getElementById('dvAlert');
    angular.element(document).ready(function() {
        angular.bootstrap(dvAlert, ['alertapp']);
    });
</script>--}%


%{--<asset:javascript src="autocomplete/angular-auto.js"/>--}%
<asset:javascript src="autocomplete/angular-sanitize.js"/>
<asset:javascript src="autocomplete/auto-complete.js"/>
<asset:javascript src="autocomplete/auto-complete-multi.js"/>
<asset:javascript src="autocomplete/auto-complete-div.js"/>
<asset:javascript src="autocomplete/auto-complete-textbox.js"/>
<asset:javascript src="autocomplete/angularjs-autocomplete.js"/>

<script type="text/javascript">
    var dvNewAlert = document.getElementById('dvNewAlert');
    angular.element(document).ready(function() {
        angular.bootstrap(dvNewAlert, ['autoCompleteApp']);
    });
</script>

<asset:javascript src="datagrid/dashboard.js"/>

<script type="text/javascript">
    var dvDashboard = document.getElementById('dvDashboard');
    angular.element(document).ready(function() {
        angular.bootstrap(dvDashboard, ['dashboard']);
    });
</script>



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


<!--  Flot Charts-->
<script src="${request.contextPath}/foysonis2016/vendor/jquery/jquery.min.js"></script>
<script src="${request.contextPath}/foysonis2016/vendor/flot/jquery.flot.min.js"></script>
<script src="${request.contextPath}/foysonis2016/vendor/flot/jquery.flot.tooltip.min.js"></script>
<script src="${request.contextPath}/foysonis2016/vendor/flot/jquery.flot.resize.min.js"></script>
<script src="${request.contextPath}/foysonis2016/vendor/flot/jquery.flot.pie.min.js"></script>
<script src="${request.contextPath}/foysonis2016/vendor/flot/jquery.flot.time.min.js"></script>
<script src="${request.contextPath}/foysonis2016/vendor/flot/jquery.flot.categories.min.js"></script>

</body>
</html>
