/**
 * Created by home on 9/10/15.
 */

var app = angular.module('adminClientBilling', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.grid.pagination', 'ui.grid.expandable','dndLists', 'ui.grid.resizeColumns', 'ngLocale', 'ui.bootstrap',]);

app.controller('clientBillingCtrl', ['$scope', '$http', '$interval', '$q', '$timeout','$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

    var myEl = angular.element( document.querySelector( '#liClientBilling' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulClientBilling' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'Configuration';


    //Date Control

    //alert($locale.DATETIME_FORMATS.mediumDate);


    $scope.inlineOptions = {
        customClass: getDayClass,
        minDate: new Date()
    };

    $scope.dateOptions = {
        //dateDisabled: disabled,
        formatYear: 'yy',
        maxDate: new Date(2020, 5, 22),
        minDate: new Date(),
        startingDay: 1,
        showWeeks: false
    };

    // Disable weekend selection
    function disabled(data) {
        var date = data.date,
            mode = data.mode;
        return mode === 'day' && (date.getDay() === 0 || date.getDay() === 6);
    }

    $scope.toggleMin = function() {
        $scope.inlineOptions.minDate = $scope.inlineOptions.minDate ? null : new Date();
        $scope.dateOptions.minDate = $scope.inlineOptions.minDate;
    };

    $scope.toggleMin();

    $scope.openFromDate = function() {
        $scope.popupFromDate.opened = true;
    };


    $scope.openToDate = function() {
        $scope.popupToDate.opened = true;
    };


    //$scope.formats = ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'MM/dd/yyyy', 'shortDate'];
    //$scope.format = $scope.formats[3];
    $scope.format = $locale.DATETIME_FORMATS.shortDate;
    $scope.altInputFormats = ['M!/d!/yyyy'];

    $scope.popupFromDate = {
        opened: false
    };

    $scope.popupEarlyShipDateFrom = {
        opened: false
    };

    $scope.popupEarlyShipDateTo = {
        opened: false
    };

    $scope.popupToDate = {
        opened: false
    };

    $scope.popupToFrom = {
        opened: false
    };

    $scope.popupToDateTo = {
        opened: false
    };

    //var tomorrow = new Date();
    //tomorrow.setDate(tomorrow.getDate() + 1);
    //var afterTomorrow = new Date();
    //afterTomorrow.setDate(tomorrow.getDate() + 1);
    //$scope.events = [
    //    {
    //        date: tomorrow,
    //        status: 'full'
    //    },
    //    {
    //        date: afterTomorrow,
    //        status: 'partially'
    //    }
    //];

    function getDayClass(data) {
        var date = data.date,
            mode = data.mode;
        if (mode === 'day') {
            var dayToCheck = new Date(date).setHours(0,0,0,0);

            for (var i = 0; i < $scope.events.length; i++) {
                var currentDay = new Date($scope.events[i].date).setHours(0,0,0,0);

                if (dayToCheck === currentDay) {
                    return $scope.events[i].status;
                }
            }
        }

        return '';
    }

    //Date Control


    var ctrl = this;

    $scope.billingItemData = [];
    $scope.billingItemDataForReport = [];
    var getAllBillingItemData = function () {
        $http({
            method: 'GET',
            url: '/clientBilling/getAllBillingItem',
        })
        .success(function (data, status, headers, config) {
            $scope.billingItemData = data;
            $scope.billingItemDataForReport = data;
            // for (var i = 0; i < $scope.billingItemData.length; i++) {
            //     $http({
            //         method: 'GET',
            //         url: '/clientBilling/getAllSubBillingItem',
            //         params:{headingId:$scope.billingItemData[i].id}
            //     })
            //     .success(function (data, status, headers, config) {
            //         $scope.billingItemData[i]['subBilling'] = data;
            //     })                
            // }

        })
    };

    $scope.subBillingItemData = [];
    $scope.subBillingItemDataForReport = [];
    $scope.disableTextBox = [];
    $scope.customBillingItem = [];

    ctrl.getSubBillingItemData = function (headingId, index) {
        $http({
            method: 'GET',
            url: '/clientBilling/getAllSubBillingItem',
            params:{headingId:headingId}
        })
        .success(function (data, status, headers, config) {
            $scope.subBillingItemData[index] = data;
            $scope.subBillingItemDataForReport[index] = data;
            if (data.length > 0) {
                $scope.disableTextBox[index] = true;
                $scope.billingItemData[index].has_sub_item = true;
            }
        })
    };
    getAllBillingItemData();

    ctrl.billingItemSaveBtnText = 'Save';
    ctrl.saveBillingItem = function () {
            ctrl.disableBillingItemSave = true;
            ctrl.billingItemSaveBtnText = 'Saving........';
            $http({
                method  : 'POST',
                url     : '/clientBilling/saveBillingItem',
                data    :  {billingItem:$scope.billingItemData, subBillingItem:$scope.subBillingItemData},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.setupRateSavedPrompt = true;
                    location.href = "#";
                    location.href = "#setupRateSaved";
                    $timeout(function(){
                        ctrl.setupRateSavedPrompt = false;    
                    }, 5000);
            })
            .finally(function () {
              ctrl.disableBillingItemSave = false;
              ctrl.billingItemSaveBtnText = 'Save';
            });       
    };

    ctrl.saveBillingInvoice = function () {

        if(ctrl.generateInvoiceForm.$valid) {

            ctrl.invoiceData.fromDate.setDate(ctrl.invoiceData.fromDate.getDate() + 1);
            ctrl.invoiceData.toDate.setDate(ctrl.invoiceData.toDate.getDate() + 1);

            $http({
                method  : 'POST',
                url     : '/clientBilling/saveBillingInvoice',
                data    :  {billingItem:$scope.billingItemDataForReport, subBillingItem:$scope.subBillingItemDataForReport, customBillingItem:$scope.customBillingItem, invoiceData:ctrl.invoiceData},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
            .success(function(data) {
                    getGeneratedInvoiceNumber();
                    getAllBillingItemData();
                    ctrl.invoiceData.fromDate = '';
                    ctrl.invoiceData.toDate = '';

                    var format = 'PDF';
                    var file = 'clientBillingInvoice';
                    var accessType = 'inline';
                    var invoiceNumber = ctrl.invoiceData.invoiceNumber ;
                    ctrl.clientBillingInvoiceSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType+"&invoiceNumber="+invoiceNumber;
                    $('#clientBillingReport').appendTo("body").modal('show');
            })
        }
    };    

    //Get all invoice data

    ctrl.invoiceData = {}

    var getGeneratedInvoiceNumber = function(){
        $http({
            method: 'GET',
            url: '/clientBilling/generateInvoiceNumber',
        })
        .success(function (data, status, headers, config) {
            ctrl.invoiceData.invoiceNumber = data.invoiceNumber;
        })        
    }
    getGeneratedInvoiceNumber();

    var getAllListValues = function (selectedGroup) {
        $http({
            method: 'GET',
            url: '/settings/getAllValuesByCompanyIdAndGroup',
            params:{group:selectedGroup}
        })
        .success(function (data, status, headers, config) {
            $scope.gridListValue.data = data;
            ctrl.newListValue.optionGroup = selectedGroup;
            ctrl.selectedOptionGroup = selectedGroup;

        })
    };



    var hasErrorClass = function (field) {
        return ctrl.generateInvoiceForm[field].$touched && ctrl.generateInvoiceForm[field].$invalid;
    };

    var showMessages = function (field) {
        return ctrl.generateInvoiceForm[field].$touched || ctrl.generateInvoiceForm.$submitted;
    };

    var getNumberLoop = function(number){
        return new Array(number);
    }

    ctrl.hasErrorClass = hasErrorClass;
    ctrl.showMessages = showMessages;
    ctrl.getNumberLoop = getNumberLoop;

    $scope.printReport = function(url){

        var w = window.open(url);
        w.print();
    }; 

    ctrl.validateCommercialInvNumber = function(viewValue){
        $http({
            method : 'GET',
            url : '/clientBilling/getCommercialInvoiceData',
            params: {commercialInvoiceNumber:viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.invoiceExist == true){
                    ctrl.generateInvoiceForm.invoiceNumber.$setValidity('commercialNumberExists', false);
                }
                else
                {
                    ctrl.generateInvoiceForm.invoiceNumber.$setValidity('commercialNumberExists', true);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.generateInvoiceForm.invoiceNumber.$setValidity('commercialNumberExists', false);
            });
    };

    ctrl.validateDescription = function(viewValue){

        if (ctrl.previousDescriptionValue.toUpperCase() == viewValue.toUpperCase()) {
            ctrl.createListValueForm.description.$setValidity('descriptionExists', true);
        }
        else{

            $http({
                method : 'GET',
                url : '/listValue/getAllListValueByDescription',
                params: {optionGroup:ctrl.newListValue.optionGroup, description: viewValue}
            })
                .success(function (data, status, headers, config) {

                    if(data.length == 0){
                        ctrl.createListValueForm.description.$setValidity('descriptionExists', true);
                    }
                    else
                    {
                        ctrl.createListValueForm.description.$setValidity('descriptionExists', false);
                    }

                })
                .error(function (data, status, headers, config) {
                    ctrl.createListValueForm.description.$setValidity('descriptionExists', false);
                });

        }
    };


    $scope.commercialBillingItemData = [];
    var getAllCommercialBillingItemData = function () {
        $http({
            method: 'GET',
            url: '/clientBilling/getAllCommercialBillingItem',
        })
        .success(function (data, status, headers, config) {
            $scope.commercialBillingItemData = data;
        })
    };
    getAllCommercialBillingItemData();

    ctrl.commercialInvoiceData = {};

    var generateInvoiceNumberForCustomReport = function(){
        $http({
            method: 'GET',
            url: '/clientBilling/generateInvoiceNumberForCustomReport',
        })
        .success(function (data, status, headers, config) {
            ctrl.commercialInvoiceData.invoiceNumber = data.invoiceNumber;
        })        
    }
    generateInvoiceNumberForCustomReport();
    ctrl.disableInvoiceSave = false;
    ctrl.invoiceSaveBtnText = 'Generate';
    ctrl.saveCommercialInvoice = function () {

        if(ctrl.generateInvoiceForm.$valid) {

            ctrl.disableInvoiceSave = true;
            ctrl.invoiceSaveBtnText = 'Generating....';

            //ctrl.commercialInvoiceData.fromDate.setDate(ctrl.commercialInvoiceData.fromDate.getDate() + 1);
            //ctrl.commercialInvoiceData.toDate.setDate(ctrl.commercialInvoiceData.toDate.getDate() + 1);

            $http({
                method  : 'POST',
                url     : '/clientBilling/saveCommercialInvoice',
                data    :  {billingItem:$scope.commercialBillingItemData, customBillingItem:$scope.customBillingItem, invoiceData:ctrl.commercialInvoiceData},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
            .success(function(data) {
                    generateInvoiceNumberForCustomReport();
                    //getAllCommercialBillingItemData();
                    var format = 'PDF';
                    var file = 'commercialBillingInvoice';
                    var accessType = 'inline';
                    var invoiceNumber = ctrl.commercialInvoiceData.invoiceNumber ;
                    ctrl.clientBillingInvoiceSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType+"&invoiceNumber="+invoiceNumber;
                    $('#clientBillingReport').appendTo("body").modal('show');
            })
             .finally(function () {
              ctrl.disableInvoiceSave = false;
              ctrl.invoiceSaveBtnText = 'Generate';
            });             
        }
    };      

    ctrl.commercialInvoiceSearch = function(){
        ctrl.commercialInvNumErrorMsg = false;

        $http({
            method : 'GET',
            url : '/clientBilling/getCommercialInvoiceData',
            params: {commercialInvoiceNumber:ctrl.findCommercialInvNum}
        })
        .success(function (data, status, headers, config) {

            if(data.invoiceExist){
                var format = 'PDF';
                var file = 'commercialBillingInvoice';
                var accessType = 'inline';
                var invoiceNumber = ctrl.findCommercialInvNum ;
                ctrl.clientBillingInvoiceSrcStrg = "/report?format=PDF&file="+file+"&fileFormat="+format+"&accessType="+accessType+"&invoiceNumber="+invoiceNumber;
                $('#clientBillingReport').appendTo("body").modal('show');                
            }
            else {
                ctrl.commercialInvNumErrorMsg = true;
            }

        })
    };


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




