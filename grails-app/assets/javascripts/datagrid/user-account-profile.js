/**
 * Created by User on 2016-07-21.
 */

var app = angular.module('userAccountProfile', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.grid.pagination', 'ui.grid.expandable','dndLists', 'ngImgCrop']);

app.controller('userProfileCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', function ($scope, $http, $interval, $q, $timeout) {


    var myEl = angular.element( document.querySelector( '#liUserAccount' ) );
    myEl.addClass('active');

    var ctrl = this;

    var userInfo = {};

    function bin2String(array) {
        var result = "";
        for (var i = 0; i < array.length; i++) {
            result += String.fromCharCode(parseInt(array[i]));
        }
        return result;
    }

    function addDays(theDate, days) {
        return new Date(theDate.getTime() + days*24*60*60*1000);
    }

    var getAllDefaultPrintersData = function () {

        $http({
            method: 'GET',
            url: '/printer/getAllDefaultPrinters'
        })
        .success(function (data, status, headers, config) {
            var noneOption = [{id: '',displayName:''}];
            ctrl.defaultPrinterOptions = noneOption.concat(data);
        })
    };

    var getAllLabelPrintersData = function () {

        $http({
            method: 'GET',
            url: '/printer/getAllLabelPrinters'
        })
        .success(function (data, status, headers, config) {
            var noneOption = [{id: '',displayName:''}];
            ctrl.defaultLabelOptions = noneOption.concat(data);
        })
    };
    getAllDefaultPrintersData();
    getAllLabelPrintersData();

    var findIndexOfArray = function(array, attr, value) {
        for(var i = 0; i < array.length; i += 1) {
            if(array[i][attr] === value) {
                return i;
            }
        }
        return -1;
    }


    var getCurrentUserInfo = function () {

        $http({
            method: 'GET',
            url: '/userAccount/getUser'
        })
            .success(function (data, status, headers, config) {


                ctrl.userInfo.username = data.username;
                ctrl.userInfo.firstName = data.firstName;
                ctrl.userInfo.lastName = data.lastName;
                ctrl.userInfo.email = data.email;
                ctrl.userInfo.password = data.password;
                ctrl.userInfo.adminActiveStatus = data.adminActiveStatus;

                if(data.isTermAccepted != true){
                    $('#termsAndConditions').appendTo("body").modal('show');
                }
                getCompanyBillingDetails();
                ctrl.userInfo.defaultPrinter = ctrl.defaultPrinterOptions[findIndexOfArray(ctrl.defaultPrinterOptions,'id', data.defaultPrinterId)]
                ctrl.userInfo.labelPrinter = ctrl.defaultLabelOptions[findIndexOfArray(ctrl.defaultLabelOptions,'id', data.labelPrinterId)]

                $scope.myCroppedImage = bin2String(data.userImage);


                //alert(ctrl.userInfo.password);

            })

    };

    var getCompanyBillingDetails = function () {

        $http({
            method: 'GET',
            url: '/billing/getCompanyBilling'
        })

            .success(function (data, status, headers, config) {
                if(data.isTrial == true && addDays(new Date(data.trialDate), 5) < new Date()){

                    if(ctrl.userInfo.adminActiveStatus == true){
                        window.location.href = '/billing/index';
                    }
                    else{
                        $('#trialEndWarning').appendTo("body").modal('show');
                    }
                }


            })
    };


    getCurrentUserInfo();
    getCompanyBillingDetails();

    $scope.acceptTerms = function(){
        $http({
            method  : 'POST',
            url     : '/userAccount/updateTermAccepted',
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                $('#termsAndConditions').appendTo("body").modal('hide');
                getCurrentUserInfo();
                ctrl.showTermsAcceptedPrompt = true;
                $timeout(function(){
                    ctrl.showTermsAcceptedPrompt = false;
                }, 5000);
            })

    };

    $scope.denyTerms = function(){
        window.location.href = '/logout';

    };

    ctrl.profileEditable = false;
    ctrl.changePassword = false;

    var editUser = function(){
        ctrl.profileEditable = true;
        ctrl.changePassword = false;
        getAllDefaultPrintersData();
        getAllLabelPrintersData();
    };

    var editPassword = function(){
        //alert("vvv");
        ctrl.changePassword = true;
        ctrl.profileEditable = false;
    };

    var updateUser = function () {
        ctrl.userInfo.userImage = $scope.myCroppedImage;

        if( ctrl.updateUserInfoForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/userAccount/updateUserProfile',
                data    :  $scope.ctrl.userInfo,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.showUpdatedPrompt = true;
                    clearForm();
                    $timeout(function(){
                        ctrl.showUpdatedPrompt = false;
                    }, 3200);
                    ctrl.profileEditable = false;

                })

        }
    };


    var updatePassword = function () {

        if(ctrl.userInfo.newPassword != ctrl.userInfo.confirmPassword){
            ctrl.updatePasswordForm.$valid = false;
        }


        ctrl.userInfo.password = ctrl.userInfo.newPassword;
        //alert(ctrl.userInfo.currentPassword);
        //alert(ctrl.userInfo.password);

        if( ctrl.updatePasswordForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/userAccount/updateUserPassword',
                data    :  $scope.ctrl.userInfo,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {

                    ctrl.showPasswordUpdatedPrompt = true;
                    $timeout(function(){
                        ctrl.showPasswordUpdatedPrompt = false;
                    }, 3200);

                    ctrl.changePassword = false;

                })

        }
    };


    var clearForm = function () {
        ctrl.updateUserInfoForm.$setUntouched();
        ctrl.updateUserInfoForm.$setPristine();
    };

    var hasErrorClass = function (field) {
        return ctrl.updateUserInfoForm[field].$touched && ctrl.updateUserInfoForm[field].$invalid;
    };

    var showMessages = function (field) {
        return ctrl.updateUserInfoForm[field].$touched || ctrl.updateUserInfoForm.$submitted;
    };



    var clearForm1 = function () {
        ctrl.updatePasswordForm.$setUntouched();
        ctrl.updatePasswordForm.$setPristine();
    };

    var hasErrorClass1 = function (field) {
        return ctrl.updatePasswordForm[field].$touched && ctrl.updatePasswordForm[field].$invalid;
    };

    var showMessages1 = function (field) {
        return ctrl.updatePasswordForm[field].$touched || ctrl.updatePasswordForm.$submitted;
    };

    var cancelUpdateCompany = function(){
        getCurrentUserInfo();
        ctrl.profileEditable = false;
        ctrl.changePassword = false;
        clearForm();
        clearForm1();
    };

    var getPasswordType = function () {
        return ctrl.updatePasswordForm.showPassword ? 'text' : 'password';
    };

    ctrl.userInfo = userInfo;
    ctrl.updateUser = updateUser;
    ctrl.clearForm = clearForm;
    ctrl.editUser = editUser;
    ctrl.editPassword = editPassword;
    ctrl.hasErrorClass = hasErrorClass;
    ctrl.showMessages = showMessages;
    ctrl.cancelUpdateCompany = cancelUpdateCompany;


    ctrl.updatePassword = updatePassword;
    ctrl.clearForm1 = clearForm1;
    ctrl.hasErrorClass1 = hasErrorClass1;
    ctrl.showMessages1 = showMessages1;
    ctrl.getPasswordType = getPasswordType;

    // choose user profile image function
    $scope.myImage='';
    $scope.myCroppedImage='';

    var uploadFileTypes = ['image/jpeg', 'image/png'];
    $scope.invalidFileSize = false;
    $scope.invalidFileType = false;
    var handleFileSelect=function(evt) {
        var file=evt.currentTarget.files[0];
        if (uploadFileTypes.indexOf(file.type) != -1) {
            $scope.$apply(function($scope){
                $scope.invalidFileType=false;
            });
            if (file.size < 1258291) {
                var reader = new FileReader();
                reader.onload = function (evt) {
                    $('#cropImageModel').appendTo("body").modal('show');
                    $scope.$apply(function($scope){
                        $scope.myImage=evt.target.result;
                        $scope.invalidFileSize = false;
                    });
                };
                reader.readAsDataURL(file);
            }
            else{
                $scope.$apply(function($scope){
                    $scope.invalidFileSize=true;
                });
            }
        }
        else{
            $scope.$apply(function($scope){
                $scope.invalidFileType=true;
            });
        }


    };
    angular.element(document.querySelector('#fileInput')).on('change',handleFileSelect);


    //password validation

    ctrl.passwordUniqueValidation = function(viewValue){
        // alert(ctrl.userInfo.currentPassword);

        if(ctrl.userInfo.currentPassword){
            $http({
                method : 'GET',
                url : '/userAccount/checkPasswordExist',
                params: {username: viewValue, password: ctrl.userInfo.currentPassword}
            })
                .success(function (data, status, headers, config) {
                    //alert(data.result);

                    if(data.result == false){
                        ctrl.updatePasswordForm.currentPassword.$setValidity('passwordExists', false);
                    }
                    else {
                        ctrl.updatePasswordForm.currentPassword.$setValidity('passwordExists', true);
                    }

                })
                .error(function (data, status, headers, config) {
                    ctrl.updatePasswordForm.currentPassword.$setValidity('passwordExists', false);
                });
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
                        method : 'GET',
                        url : '/userAccount/checkPasswordExist',
                        params: {username: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('passwordExists', true);
                            }
                            else
                            {
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
                    if (value=="")
                        return true;
                    else
                        return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.upperCase = function (value) {
                    var pattern = /[A-Z]+/;
                    if (value=="")
                        return true;
                    else
                        return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.number = function (value) {
                    var pattern = /\d+/;
                    if (value=="")
                        return true;
                    else
                        return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.specialCharacter = function (value) {
                    var pattern = /\W+/;
                    if (value=="")
                        return true;
                    else
                        return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.eightCharacters = function (value) {
                    if (value=="")
                        return true;
                    else
                        return (typeof value !== 'undefined') && value.length >= 8;
                };
            }
        }
    })



//*****************end validation*****************************
;





