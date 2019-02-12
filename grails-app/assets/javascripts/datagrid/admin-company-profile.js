/**
 * Created by home on 9/10/15.
 */

var app = angular.module('adminCompanyProfile', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.grid.pagination', 'ui.grid.expandable','dndLists', 'ngImgCrop']);

app.controller('companyProfileCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', function ($scope, $http, $interval, $q, $timeout) {

    var myEl = angular.element( document.querySelector( '#liAdmin' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulAdmin' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var ctrl = this;

    var companyInfo = {};


    function bin2String(array) {
      var result = "";
      for (var i = 0; i < array.length; i++) {
        result += String.fromCharCode(parseInt(array[i]));
      }
      return "data:image/png;base64,"+result;
    }


    //load billing and shipping country
    var getCountries = function () {
        $http({
            method: 'GET',
            url: '/customer/getCountries'
        })
            .success(function (data, status, headers, config) {
                $scope.countryList = data;
            })
    };
    getCountries();
    
    ctrl.companyAddress = {};
    ctrl.companyInfoApi = {};
    ctrl.companyQuickbooksInfo = {};
    ctrl.companyDisplayAddress = {};

    var getCurrentCompanyinfo = function () {

        $http({
            method: 'GET',
            url: '/company/getCurrentUserCompany',
        })
        .success(function (data, status, headers, config) {
            //$scope.areaList = data;
            ctrl.companyInfo.companyId = data.companyId;
            ctrl.companyInfo.gsiCompPrefix = data.gsiCompanyPrefix;
            ctrl.companyInfo.companyName = data.name;
            ctrl.companyInfo.noOfUsers = data.noOfLicensedUsers;
            ctrl.companyInfo.isQuickbooksEnabled = data.isQuickbooksEnabled;
            ctrl.companyInfoApi.easyPostProdApiKey = data.easyPostProdApiKey;
            ctrl.companyInfoApi.isEasyPostEnabled = data.isEasyPostEnabled;
            ctrl.companyInfoApi.activeEasyPostApiKey = data.activeEasyPostApiKey;
            ctrl.companyInfoApi.autoLoadPalletId = data.autoLoadPalletId;
            ctrl.companyAddress.companyBillingStreetAddress = data.companyBillingStreetAddress;
            ctrl.companyAddress.companyBillingCity = data.companyBillingCity;
            ctrl.companyAddress.companyBillingState = data.companyBillingState;
            ctrl.companyAddress.companyBillingPostCode = data.companyBillingPostCode;
            ctrl.companyAddress.companyBillingCountry = data.companyBillingCountry;
            ctrl.companyAddress.companyShippingStreetAddress = data.companyShippingStreetAddress;
            ctrl.companyAddress.companyShippingCity = data.companyShippingCity;
            ctrl.companyAddress.companyShippingState = data.companyShippingState;
            ctrl.companyAddress.companyShippingPostCode = data.companyShippingPostCode;
            ctrl.companyAddress.companyShippingCountry = data.companyShippingCountry;  
            //ctrl.companyShippingAddressString = data.companyShippingStreetAddress+" "+data.companyShippingState+" "+data.companyShippingPostCode+" "+data.companyShippingCity+" "+data.companyShippingCountry;
            //ctrl.companyBillingAddressString = data.companyBillingStreetAddress+" "+data.companyBillingState+" "+data.companyBillingPostCode+" "+data.companyBillingCity+" "+data.companyBillingCountry;
            ctrl.companyDisplayAddress.billingStreetAddress = data.companyBillingStreetAddress && data.companyBillingStreetAddress+"," ;
            ctrl.companyDisplayAddress.billingCity = data.companyBillingCity && data.companyBillingCity+",";
            ctrl.companyDisplayAddress.billingState = data.companyBillingState && data.companyBillingState+",";
            ctrl.companyDisplayAddress.billingPostCode = data.companyBillingPostCode && data.companyBillingPostCode+",";
            ctrl.companyDisplayAddress.billingCountry = data.companyBillingCountry;
            ctrl.companyDisplayAddress.shippingStreetAddress = data.companyShippingStreetAddress && data.companyShippingStreetAddress+",";
            ctrl.companyDisplayAddress.shippingCity = data.companyShippingCity && data.companyShippingCity+",";
            ctrl.companyDisplayAddress.shippingState = data.companyShippingState && data.companyShippingState+",";
            ctrl.companyDisplayAddress.shippingPostCode = data.companyShippingPostCode && data.companyShippingPostCode+",";
            ctrl.companyDisplayAddress.shippingCountry = data.companyShippingCountry;

            $scope.myCroppedImage = bin2String(data.companyLogo);
        })
    };


    var getAllListValueInventoryStatus = function () {
        $http({
            method: 'GET',
            url: '/order/getAllValuesByCompanyIdAndGroup',
            params : {group: 'INVSTATUS'}
        })
            .success(function (data, status, headers, config) {
                ctrl.inventoryStatusOptions = data;
            })
    };    
    getAllListValueInventoryStatus();

    function getQuickBooksInfo() {

            $http({
                method: 'GET',
                url: '/company/getQuickbooksInfo'
            })
                .success(function (data, status, headers, config) {
                    ctrl.companyQuickbooksInfo.companyId = data.companyId;
                    ctrl.companyQuickbooksInfo.username = data.username;
                    ctrl.companyQuickbooksInfo.password = data.password;
                    ctrl.companyQuickbooksInfo.inventoryStatus = {optionValue : data.defaultInventoryStatus};
                    if (ctrl.companyQuickbooksInfo.password) {
                        ctrl.showQuickbooksQWCLink = true;
                    }
                })

    }

    getCurrentCompanyinfo();
    getQuickBooksInfo();

    // var getTimeZone = function () {

    //     $http({
    //         method: 'GET',
    //         url: '/company/getTimeZoneData',
    //     })
    //     .success(function (data, status, headers, config) {
    //         ctrl.timeZoneData = data;
    //     })
    // };  
    // getTimeZone();  

    ctrl.profileEditable = false;
    var editCompany = function(){
        ctrl.profileEditable = true;
    };

    var updateCompany = function () {      

        ctrl.companyInfo.companyLogo = $scope.myCroppedImage;

        if( ctrl.updateCompanyInfoForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/company/updateCompanyProfile',
                data    :  $scope.ctrl.companyInfo,
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


    var clearForm = function () {
        //ctrl.companyInfo = { optionGroup:'', description:'', displayOrder:'', optionValue:'' };
        ctrl.updateCompanyInfoForm.$setUntouched();
        ctrl.updateCompanyInfoForm.$setPristine();          
    };

    var hasErrorClass = function (field) {
        if (ctrl.updateCompanyInfoForm[field]) {
            return ctrl.updateCompanyInfoForm[field].$touched && ctrl.updateCompanyInfoForm[field].$invalid;
        }
       
    };

    var showMessages = function (field) {
        if (ctrl.updateCompanyInfoForm[field]) {
            return ctrl.updateCompanyInfoForm[field].$touched || ctrl.updateCompanyInfoForm.$submitted;
        }
        
    };    

    var cancelUpdateCompany = function(){
        getCurrentCompanyinfo();
        ctrl.profileEditable = false;
        clearForm();
    };

    //Easypost
    ctrl.prodApiKeyInvalid = false;
    ctrl.updateApiBtnText = "Update";
    ctrl.validateKeys = function () {
        ctrl.updateApiBtnText = "Updating...";
        ctrl.disableApiBtn = true;

        $http({
            method: 'GET',
            url: '/easyPost/isValidProdKey',
            params: {key: ctrl.companyInfoApi.easyPostProdApiKey}
        })
            .success(function (data) {
                if (data.isValid == true) {
                    ctrl.updateCompanyApi();
                    ctrl.prodApiKeyInvalid = false;
                }
                else {
                    ctrl.prodApiKeyInvalid = true;
                }

            })
            .finally(function () {
                ctrl.updateApiBtnText = "Update";
                ctrl.disableApiBtn = false;
            })
    };

    ctrl.updateCompanyApi = function(){

        if( ctrl.updateCompanyApiForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/company/updateCompanyEasyPostApi',
                data    :  {easyPostTestApiKey:ctrl.companyInfoApi.easyPostTestApiKey, easyPostProdApiKey:ctrl.companyInfoApi.easyPostProdApiKey, isEasyPostEnabled:ctrl.companyInfoApi.isEasyPostEnabled, activeEasyPostApiKey:ctrl.companyInfoApi.activeEasyPostApiKey, autoLoadPalletId:ctrl.companyInfoApi.autoLoadPalletId},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.showApiUpdatedPrompt = true;
                    clearForm();
                    $timeout(function(){
                    ctrl.showApiUpdatedPrompt = false;
                    }, 3200);
                })

        }
    };

    ctrl.updateQuickbooksConfig = function(){

        if( ctrl.updateQuickbooksForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/company/updateQuickbooksInfo',
                data    :  {companyId:ctrl.companyInfo.companyId, username:ctrl.companyInfo.companyId, password:ctrl.companyQuickbooksInfo.password, isQuickbooksEnabled:ctrl.companyInfo.isQuickbooksEnabled, inventoryStatus:ctrl.companyQuickbooksInfo.inventoryStatus.optionValue},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.showQuickBooksUpdatedPrompt = true;
                    if (data.password) {
                        ctrl.showQuickbooksQWCLink = true;
                    }
                    // clearForm();
                    $timeout(function(){
                        ctrl.showQuickBooksUpdatedPrompt = false;
                    }, 3200);
                })

        }
    };

    ctrl.switchIsQuickbooksEnabled = function(){
        if (ctrl.companyInfo.isQuickbooksEnabled == true) {

        }
    };

    ctrl.switchEasyPostBtn = function(){
        if (ctrl.companyInfoApi.isEasyPostEnabled == false) {
            ctrl.companyInfoApi.isEasyPostEnabled = true;
            $('#easyPostDisable').appendTo("body").modal('show'); 

        }
    };

    $("#easyPostDisableBtn").click(function(){
        ctrl.companyInfoApi.isEasyPostEnabled = false;
        $("#isEasyPostEnabled").prop("checked", false);
        $('#easyPostDisable').modal('hide');
    });    

    ctrl.showCompanyAddressEditForm = function() { //calling bootstrap confirm box.
        $('#companyAddress').appendTo("body").modal('show');
    };



    // Quickbooks integration configurations..
    ctrl.updateQuickBooksConfiguration = function() {
        if( ctrl.updateQuickbooksForm.$valid) {
            ctrl.updateQuickbooksConfig();
        }
    }


    ctrl.updateCompanyAddress = function(){

        if( ctrl.updateCompanyApiForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/company/updateCompanyAddress',
                data    :  $scope.ctrl.companyAddress,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.showAddressUpdatedPrompt = true;
                    getCurrentCompanyinfo();
                    $('#companyAddress').modal('hide');
                    $timeout(function(){
                    ctrl.showAddressUpdatedPrompt = false;
                    }, 3200);
                })

        }
    };

    ctrl.checkShippingAddressCopy = function () {
        if(ctrl.companyAddress.billingAddressCopy){
            ctrl.companyAddress.companyShippingStreetAddress = '';
            ctrl.companyAddress.companyShippingCity = '';
            ctrl.companyAddress.companyShippingState = '';
            ctrl.companyAddress.companyShippingPostCode = '';
            ctrl.companyAddress.companyShippingCountry = '';
        }

    };

    ctrl.companyInfo = companyInfo;
    ctrl.updateCompany = updateCompany;
    ctrl.clearForm = clearForm;
    ctrl.editCompany = editCompany;
    ctrl.hasErrorClass = hasErrorClass;
    ctrl.showMessages = showMessages;
    ctrl.cancelUpdateCompany = cancelUpdateCompany;

    // choose company profile logo functon
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


}])

    //*****************start item validation******************************

    .directive('numbersOnly', function () {
        return {
            require: 'ngModel',
            link: function (scope, element, attr, ngModelCtrl) {
                function fromUser(text) {
                    if (text) {
                        var transformedInput = text.replace(/[^0-9]/g, '');

                        if (transformedInput !== text) {
                            ngModelCtrl.$setViewValue(transformedInput);
                            ngModelCtrl.$render();
                        }
                        return transformedInput;
                    }
                    return undefined;
                }
                ngModelCtrl.$parsers.push(fromUser);
            }
        };
    })


    //location id validation(uppercase,numbers)
    .directive('validateItemId', function () {
        return {
            require: 'ngModel',
            link: function ($scope, element, attrs, ngModel) {

                ngModel.$validators.upperCase = function (value) {
                    var pattern = /[A-Z]+/;
                    return (typeof value !== 'undefined') && pattern.test(value);
                };
                ngModel.$validators.number = function (value) {
                    var pattern = /\d+/;
                    return (typeof value !== 'undefined') && pattern.test(value);
                };

            }
        }
    })
//location id unique(check to database)
    .directive('uniqueItemIdValidation', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {




                ctrl.$parsers.push(function (viewValue) {
                    $http({
                        method : 'GET',
                        url : '/item/checkItemIdExist',
                        params: {itemId: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('itemIdExists', true);
                            }
                            else
                           {
                                ctrl.$setValidity('itemIdExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('itemIdExists', false);
                        });

                    return viewValue;
                });

            }
        };
    })

//location barcode unique(check to database)
    .directive('validateLocationBarcode', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {

                ctrl.$parsers.push(function (viewValue) {

                    $http({
                        method : 'GET',
                        url : '/location/checkLocationBarcodeExist',
                        params: {locationBarcode: viewValue, locationId:locationBarcodecheck }
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('locationBarcodeExists', true);
                            }
                            else
                            {
                                ctrl.$setValidity('locationBarcodeExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('locationBarcodeExists', false);
                        });

                    return viewValue;
                });

            }
        };
    })

    

//uppercase from barcode
.directive('capitalize', function() {
    return {
        require: 'ngModel',
        link: function(scope, element, attrs, modelCtrl) {
            var capitalize = function(inputValue) {
                if(inputValue == undefined) inputValue = '';
                var capitalized = inputValue.toUpperCase();
                if(capitalized !== inputValue) {
                    modelCtrl.$setViewValue(capitalized);
                    modelCtrl.$render();
                }
                return capitalized;
            }
            modelCtrl.$parsers.push(capitalize);
            capitalize(scope[attrs.ngModel]);  // capitalize initial value
        }
    };
})
//*****************end item validation*****************************
;




