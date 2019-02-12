/**
 * Created by home on 9/10/15.
 */

var app = angular.module('supportLink', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.grid.resizeColumns', 'ui.bootstrap', 'ngLocale']);

app.controller('MainCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {


   ///********* Support ******
    var ctrl = this;

    $scope.supportMail = {};

    $scope.supportMailBox = function(){
        $http({
            method: 'GET',
            url: '/billing/getCompanyBillingForSupport',
        })

        .success(function (data, status, headers, config) {
            if (data.length > 0) {
                $scope.companyBillingData = data[0].currentPlanDetail;
                $scope.supportMail.sendACopy = true;
                $('#supportMailModel').appendTo("body").modal('show');  
            }      
        });                 
    };
    $scope.sendSupportMailBtn = 'Send';
    $scope.sendSupportMail = function(){
        if (ctrl.sendSupportMailForm.$valid) {
            $('#supportMailModel').modal('hide');  
            $('#sendingMailModal').appendTo("body").modal('show');  
            $scope.disableSendMail = true;
            $scope.sendSupportMailBtn = 'Sending...';
            $http({
                method: 'POST',
                url: '/user/sendSupportMail',
                data: {mailSubject:$scope.supportMail.subject, mailBody:$scope.supportMail.description, sendACopy:$scope.supportMail.sendACopy},
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}
            })

            .success(function (data, status, headers, config) {
                $('#supportMailModel').modal('hide');
                $('#sendMailSuccessModel').appendTo("body").modal('show');
                $timeout(function () {
                    $('#sendMailSuccessModel').modal('hide');
                }, 5000);            
            })
            .finally(function () {
                $('#sendingMailModal').modal('hide'); 
                $scope.disableSendMail = false;
                $scope.sendSupportMailBtn = 'Send';
            });  

        }               
    }


}])

;
