/**
 * Created by home on 9/10/15.
 */

var app = angular.module('dashboard', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ui.grid.autoResize', 'googlechart']);

app.controller('dashboardCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', function ($scope, $http, $interval, $q, $timeout) {

    var myEl = angular.element( document.querySelector( '#liDashBoard' ) );
    myEl.addClass('active');


    $scope.receiptSelectedValue = 0;
    $scope.userPicksSelectedValue = 0;
    $scope.showEmptyResults = false;
    $scope.showEmptyUserPicksResults = false;
    $scope.receiptSelectedText = $("#receiptDuration option:selected").html();
    $scope.userPicksSelectedText = $("#userPicksDuration option:selected").html();

    var getReceiptsForGoogleData = function(){

        $http({
            method: 'GET',
            url: '/receiving/getReceiptsForGoogleData',
            params: {receiptDuration: $scope.receiptSelectedValue}
        })
            .success(function (response) {

                if(response[0].completed > 0 || response[0].opened > 0){

                    $scope.showEmptyResults = false;

                    var chart1 = {};
                    chart1.type = "PieChart";
                    chart1.data = [
                        ['Component', 'count']
                    ];


                    chart1.data.push(['Close - '+response[0].completed,response[0].completed]);
                    chart1.data.push(['Open - '+response[0].opened,response[0].opened]);

                    chart1.options = {
                        displayExactValues: true,
                        width: 380,
                        height: 200,
                        chartArea: {left:10,top:10,bottom:0,height:"100%"},
                        colors: ['#23527D', '#23C6C8'],
                        pieHole: 0.5

                    };

                    chart1.formatters = {
                        number : [{
                            columnNum: 1,
                            pattern: "#,##0"
                        }]
                    };

                    $scope.chart = chart1;

                    $scope.aa=1*$scope.chart.data[1][1];
                    $scope.bb=1*$scope.chart.data[2][1];
                }

                else{
                    $scope.showEmptyResults = true;

                }

            });

    };

    var receiptLinesBarChart = function(){
        google.charts.load("visualization", "1", {packages:["corechart"]});
        google.charts.setOnLoadCallback(drawReceiptLineChart);
    };

    var receiptLineCasesBarChart = function(){
        google.charts.setOnLoadCallback(drawReceiptLineCaseChart);
    };

    var ordersBarChart = function(){
        google.charts.setOnLoadCallback(drawOrderChart);
    };

    var shipmentsBarChart = function(){
        google.charts.setOnLoadCallback(drawShipmentChart);
    };

    var picksPieChart = function(){

        $http({
            method: 'GET',
            url: '/picking/getPickStatusCount'
        })
            .success(function (response) {

                var chart1 = {};
                chart1.type = "PieChart";
                chart1.data = [
                    ['Component', 'Count']
                ];

                chart1.data.push(['Completed - ' + response[0].completed, response[0].completed]);
                chart1.data.push(['Partially Picked - ' + response[0].partially_picked, response[0].partially_picked]);
                chart1.data.push(['Pending Replen - ' + response[0].pending_replen, response[0].pending_replen]);
                chart1.data.push(['Ready to Pick - ' + response[0].ready_to_pick, response[0].ready_to_pick]);

                chart1.options = {
                    displayExactValues: true,
                    width: 400,
                    height: 200,
                    chartArea: {left:10,top:10,bottom:0,height:"100%"},
                    colors: ['#23527D', '#3CC5C4', '#EFDF89', '#F09134', '#B7DD70', '#F9D706', '#B3B3B3']
                };

                chart1.formatters = {
                    number : [{
                        columnNum: 1,
                        pattern: "#,##0"
                    }]
                };

                $scope.pickChart = chart1;

                $scope.aa=1*$scope.pickChart.data[1][1];
                $scope.bb=1*$scope.pickChart.data[2][1];
                $scope.aa=1*$scope.pickChart.data[3][1];
                $scope.bb=1*$scope.pickChart.data[4][1];

            });

        //Picks Performed Today
        $http({
            method: 'GET',
            url: '/picking/getTodayPerformedPicks'
        })
            .success(function (response) {

                $scope.picksPerformedToday = response[0].total_pick;

            });

    };

    var userPicksPieChart = function(){

        $scope.averagePicksByUser = 0;

        $http({
            method: 'GET',
            url: '/picking/getUserPicks',
            params: {userPicksDuration: $scope.userPicksSelectedValue}
        })
            .success(function (response) {

                if(response.length > 0){

                    $scope.showEmptyUserPicksResults = false;

                    var chart1 = {};
                    chart1.type = "PieChart";
                    chart1.data = [
                        ['Component', 'count']
                    ];

                    var totalPicks = 0;

                    for (i = 0; i < response.length; i++) {

                        chart1.data.push([response[i].last_update_username.charAt(0).toUpperCase() + response[i].last_update_username.slice(1) + " - " + response[i].total_count, response[i].total_count]);
                        totalPicks += response[i].total_count;
                    }

                    $scope.averagePicksByUser = (totalPicks / response.length).toFixed(2);

                    chart1.options = {
                        displayExactValues: true,
                        width: 380,
                        height: 200,
                        chartArea: {left:10,top:10,bottom:0,height:"100%"},
                        colors: ['#3CC5C4', '#B7DD70', '#F09134', '#EFDF89', '#23527D', '#F9D706', '#B3B3B3']
                    };

                    chart1.formatters = {
                        number : [{
                            columnNum: 1,
                            pattern: "#,##0"
                        }]
                    };

                    $scope.userPicksChart = chart1;

                }

                else{
                    $scope.showEmptyUserPicksResults = true;

                }

            });

    };

    var inventoryStatusPieChart = function(){
        
        $http({
            method: 'GET',
            url: '/inventory/getInventoryStatusReport'
        })
            .success(function (response) {


                var chart1 = {};
                chart1.type = "PieChart";
                chart1.data = [
                    ['Component', 'Count']
                ];

                for (i = 0; i < response.length; i++) {
                    chart1.data.push([response[i].description + " - " + response[i].total_inventories, response[i].total_inventories]);
                }

                chart1.options = {
                    displayExactValues: true,
                    width: 400,
                    height: 200,
                    chartArea: {left:10,top:10,bottom:0,height:"100%"},
                    colors: ['#23527D', '#3CC5C4', '#EFDF89', '#B7DD70', '#F09134', '#39B549', '#f6c7b6']
                };

                chart1.formatters = {
                    number : [{
                        columnNum: 1,
                        pattern: "#,##0"
                    }]
                };

                $scope.inventoryStatusChart = chart1;

            });

        //Picks Performed Today
        $http({
            method: 'GET',
            url: '/picking/getTodayPerformedPicks'
        })
            .success(function (response) {

                $scope.picksPerformedToday = response[0].total_pick;

            });

    };

    var pendingPutAwayInfo = function(){

        $http({
            method: 'GET',
            url: '/receiving/getPendingPallets'
        })
            .success(function (response) {
                $scope.pendingPallets = response[0].total_pending_pallet;
            });

        $http({
            method: 'GET',
            url: '/receiving/getPendingCases'
        })
            .success(function (response) {
                $scope.pendingCases = response[0].total_pending_case;
            });

        $http({
            method: 'GET',
            url: '/receiving/getPendingCasesTotalCount'
        })
            .success(function (response) {
                $scope.pendingCasesTotalCount = response[0].total_case;
            });


        $http({
            method: 'GET',
            url: '/receiving/getPendingEachesTotalCount'
        })
            .success(function (response) {
                $scope.pendingEachesTotalCount = response[0].total_each;
            });

    };


    $scope.filterReceipt = function(value1){

        $scope.receiptSelectedValue = value1;
        $scope.receiptSelectedText = $("#receiptDuration option:selected").html();
        getReceiptsForGoogleData();

    };

    $scope.filterUserPicks = function(value1){

        $scope.userPicksSelectedValue = value1;
        $scope.userPicksSelectedText = $("#userPicksDuration option:selected").html();
        userPicksPieChart();

    };


    getReceiptsForGoogleData();
    receiptLinesBarChart();
    receiptLineCasesBarChart();
    ordersBarChart();
    shipmentsBarChart();
    picksPieChart();
    userPicksPieChart();
    inventoryStatusPieChart();
    pendingPutAwayInfo();


    function drawReceiptLineChart() {

        $http({
            method: 'GET',
            url: '/receiving/getReceivedOpenedLinesCount'
        })
            .success(function (response) {

                var totalLines = response[0].open_for_receive + response[0].received_lines;

                var data = google.visualization.arrayToDataTable([
                    ['', 'Open for Receiving - ' + response[0].open_for_receive + ' of '+ totalLines,  { role: 'tooltip' },
                        'Received - ' + response[0].received_lines + ' of '+ totalLines,  { role: 'tooltip' } ],
                    ['', response[0].open_for_receive, '', response[0].received_lines, '']
                ]);

                var options = {
                    width: 400,
                    height: 150,
                    legend: { position: 'top', maxLines: 1 },
                    bar: { groupWidth: '50%' },
                    isStacked: true,
                    hAxis: { textPosition: 'none', baselineColor: "#fff", gridlines: {color: "#fff"}},
                    colors: ['#EFDF89', '#B7DD70']
                };

                var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
                chart.draw(data, options);

            });
    }

    function drawReceiptLineCaseChart() {


        $http({
            method: 'GET',
            url: '/receiving/getReceiptLineCaseQuantity'
        })
            .success(function (response) {

                var data = google.visualization.arrayToDataTable([
                    ['', 'Received cases', 'Yet to be received cases',  { role: 'annotation' } ],
                    ['', response["receivedCases"], response["yetToBeReceivedCases"], '']
                ]);

                var options = {
                    width: 400,
                    height: 150,
                    legend: { position: 'top', maxLines: 1 },
                    bar: { groupWidth: '50%' },
                    isStacked: true,
                    hAxis: { textPosition: 'none', baselineColor: "#fff", gridlines: {color: "#fff"}},
                    colors: ['#23527D', '#3CC5C4']
                };

                var chart = new google.visualization.BarChart(document.getElementById('receipt_case_chart_div'));
                chart.draw(data, options);

            });

    }

    function drawOrderChart() {

        $http({
            method: 'GET',
            url: '/order/getOrderStatusCount'
        })
            .success(function (response) {

                if(response[0].closed || response[0].partially_planned || response[0].planned || response[0].unplanned){
                    var data = google.visualization.arrayToDataTable([
                        ['Element', '', { role: 'style' }],
                        ['Closed', response[0].closed, '#23527D'],
                        ['Partially Planned', response[0].partially_planned, '#3CC5C4'],
                        ['Planned', response[0].planned, '#B7DD70'],
                        ['Unplanned', response[0].unplanned, '#F09134']
                    ]);


                    var options = {
                        width: 400,
                        height: 300,
                        legend: { position: 'top', maxLines: 3 },
                        bar: { groupWidth: '50%' },
                        colors: ['#fff']
                    };

                    var chart = new google.visualization.BarChart(document.getElementById('orders_chart_div'));
                    chart.draw(data, options);
                }

            });

    }

    function drawShipmentChart() {

        $http({
            method: 'GET',
            url: '/shipment/getShipmentStatusCount'
        })
            .success(function (response) {

                if(response[0].planned || response[0].allocated || response[0].staged || response[0].completed){

                    var data = google.visualization.arrayToDataTable([
                        ['Element', '', { role: 'style' }],
                        ['Planned', response[0].planned, '#23527D'],
                        ['Allocated', response[0].allocated, '#3CC5C4'],
                        ['Staged', response[0].staged, '#F8D506'],
                        ['Completed', response[0].completed, 'F09134']
                    ]);

                    var options = {
                        width: 400,
                        height: 300,
                        legend: { position: 'top', maxLines: 3 },
                        bar: { groupWidth: '50%' },
                        colors: ['#fff']
                    };

                    var chart = new google.visualization.BarChart(document.getElementById('shipments_chart_div'));
                    chart.draw(data, options);

                }

            });
    }



}])



