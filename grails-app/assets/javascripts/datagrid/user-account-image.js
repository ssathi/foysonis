/**
 * Created by User on 2016-07-28.
 */

var app = angular.module('userAccountImage', ['ngTouch', 'ngAria', 'ngMessages', 'ngAnimate']);

app.controller('userImageCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', function ($scope, $http, $interval, $q, $timeout) {
//var userAccountImage = angular.module('userAccountImage', []);
//
//userAccountImage.controller('userImageCtrl', ['$scope', '$http', function ($scope, $http) {

//alert("hii");
    var ctrl = this;

    var userInfo = {};

    function bin2String(array) {
        var result = "";
        if (array) {
            for (var i = 0; i < array.length; i++) {
                result += String.fromCharCode(parseInt(array[i]));
            }
        }
        return result;
    }


    var getCurrentUserImage = function () {

        $http({
            method: 'GET',
            url: '/userAccount/getUser'
        })
            .success(function (data, status, headers, config) {
                $scope.myImage = bin2String(data.userImage);

            })

    };

    getCurrentUserImage();

}])

;






