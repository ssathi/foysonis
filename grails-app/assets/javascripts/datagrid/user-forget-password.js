var app = angular.module('resetPassword', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.grid.pagination', 'ui.grid.expandable', 'dndLists', 'ngImgCrop']);

app.controller('resetPasswordCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$location', function ($scope, $http, $interval, $q, $timeout, $location) {

    var ctrl = this;

    ctrl.getPasswordType = function () {
        return ctrl.showPassword ? 'text' : 'password';
    };


    ctrl.showUpdatedPrompt = false;

    ctrl.updatePassword = function () {

        var urlParams = $location.search();

        if (ctrl.updatePasswordForm.$valid) {

            $http({
                method: 'POST',
                url: '/user/resetPasswordAction',
                data: {emailid: urlParams.emailid, newpassword: ctrl.userInfo.newPassword},
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}
            })
                .success(function (data) {

                    ctrl.showUpdatedPrompt = true;

                    $timeout(function(){
                        document.location = "/"
                    }, 3200);
                })
        }
    };


}])

//*****************start  validation******************************

    .directive('passwordAvailable', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {

                ctrl.$parsers.push(function (viewValue) {

                    $http({
                        method: 'GET',
                        url: '/userAccount/checkPasswordExist',
                        params: {username: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if (data.length == 0) {
                                ctrl.$setValidity('passwordExists', true);
                            }
                            else {
                                ctrl.$setValidity('passwordExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('passwordExists', false);
                        });

                    return viewValue;
                });

            }
        };
    })


    .directive('validatePasswordCharacters', function () {
        return {
            require: 'ngModel',
            link: function ($scope, element, attrs, ngModel) {
                ngModel.$validators.lowerCase = function (value) {
                    var pattern = /[a-z]+/;
                    return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.upperCase = function (value) {
                    var pattern = /[A-Z]+/;
                    return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.number = function (value) {
                    var pattern = /\d+/;
                    return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.specialCharacter = function (value) {
                    var pattern = /\W+/;
                    return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.eightCharacters = function (value) {
                    return (typeof value !== 'undefined') && value.length >= 8;
                };
            }
        }
    })

    .directive('validatePasswordCharactersForEdit', function () {
        return {
            require: 'ngModel',
            link: function ($scope, element, attrs, ngModel) {
                ngModel.$validators.lowerCase = function (value) {
                    var pattern = /[a-z]+/;
                    if (value == "")
                        return true;
                    else
                        return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.upperCase = function (value) {
                    var pattern = /[A-Z]+/;
                    if (value == "")
                        return true;
                    else
                        return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.number = function (value) {
                    var pattern = /\d+/;
                    if (value == "")
                        return true;
                    else
                        return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.specialCharacter = function (value) {
                    var pattern = /\W+/;
                    if (value == "")
                        return true;
                    else
                        return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.eightCharacters = function (value) {
                    if (value == "")
                        return true;
                    else
                        return (typeof value !== 'undefined') && value.length >= 8;
                };
            }
        }
    })



//*****************end validation*****************************
;





