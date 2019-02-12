/**
 * Created by User on 2016-07-28.
 */

var app = angular.module('companyBilling', ['ngTouch', 'ngAria', 'ngMessages', 'ngAnimate', 'ngLocale', 'ui.grid.autoResize']);

app.controller('billingCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

    var ctrl = this;

///********* Billing*******
    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };

    var openBilling = function(){
        //alert("aaaa");
        getCompanyBillingDetails();
        $('#billing').appendTo("body").modal('show');

    };

    ctrl.openBilling = openBilling;


    var upgrade = function(){
        $('#upgrade').appendTo("body").modal('show');
    };
    ctrl.upgrade = upgrade;


    var edit = function(){
        $('#editPayment').appendTo("body").modal('show');

        $http({
            method: 'GET',
            url: '/billing/getCompanyCreditCard'
        })

            .success(function (data, status, headers, config) {
                ctrl.nameOnCard = data[0].name_on_card;

                var num = data[0].card_number;
                ctrl.cardNumber = "xxxxxxxxxxxx" + num;
                //ctrl.cardNumber = "xxxxxxxxxxxx" + (x.toString()).substring(12,16);

                //ctrl.cardNumber = data[0].card_number;
                ctrl.expirationDate = new Date(data[0].expiration_date);
                ctrl.billingAddress = data[0].billing_address;
                ctrl.city = data[0].city;
                ctrl.state = data[0].state;
                ctrl.zip = data[0].zip;

            })


    };
    ctrl.edit = edit;


    var payment = function(){
        $('#paymentHistory').appendTo("body").modal('show');
        getCompanyPaymentHistory();
        
    };
    ctrl.payment = payment;


    $("#closeButton").click(function(){ //function to delete.
        $('#editPayment').appendTo("body").modal('hide');
    });


    //Date Control

    $scope.inlineOptions = {
        customClass: getDayClass,
        minDate: new Date()
    };

    $scope.dateOptions = {
        formatYear: 'yy',
        maxDate: new Date(2020, 5, 22),
        minDate: new Date(),
        startingDay: 1,
        showWeeks: false
    };


    $scope.toggleMin = function() {
        $scope.inlineOptions.minDate = $scope.inlineOptions.minDate ? null : new Date();
        $scope.dateOptions.minDate = $scope.inlineOptions.minDate;
    };

    $scope.toggleMin();

    $scope.openReceiptDate = function() {
        $scope.popupReceiptDate.opened = true;
    };

    $scope.format = $locale.DATETIME_FORMATS.shortDate;
    $scope.altInputFormats = ['M!/d!/yyyy'];

    $scope.popupReceiptDate = {
        opened: false
    };



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

    var getCompanyBillingDetails = function(){

        $http({
            method: 'GET',
            url: '/billing/getCompanyBilling'
        })

            .success(function (data, status, headers, config) {
                ctrl.billingCompanyId = data[0].company_id;
                ctrl.planDetails = data[0].current_plan_detail;
                ctrl.currentCost = data[0].current_cost;
                ctrl.paymentMethod = data[0].payment_method;
                ctrl.nextPayment = data[0].next_payment_date;

                //alert(ctrl.planDetails);

                if(ctrl.planDetails == 'Individual'){
                    ctrl.subscriptionStatus = 'Free';
                }

            })
    };



    //view history grid
    var headerTitle1 = 'Payment History';

    $scope.gridHistory = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        gridMenuTitleFilter: fakeI18n,

        exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
        exporterPdfHeader: { text: headerTitle1, style: 'headerStyle' },
        exporterPdfFooter: function ( currentPage, pageCount ) {
            return { text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle' };
        },
        exporterPdfCustomFormatter: function ( docDefinition ) {
            docDefinition.styles.headerStyle = { fontSize: 15, bold: true, margin: 20};
            //docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
            return docDefinition;
        },
        exporterPdfOrientation: 'portrait',
        exporterPdfPageSize: 'LETTER',
        exporterPdfMaxGridWidth: 500,

        columnDefs: [
            { name: 'Date', field: 'payment_date',type: 'date',cellFilter: 'date:"MM/dd/yyyy"'},
            { name: 'Action', field: 'action' },
            { name: 'Description', field: 'description' },
            { name: 'Amount', field: 'amount',type: 'currency', cellFilter: 'currency'}

        ],
        onRegisterApi: function( gridApi ){
            $scope.gridApi = gridApi;

            // interval of zero just to allow the directive to have initialized
            $interval( function() {
                gridApi.core.addToGridMenu( gridApi.grid, [{ title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged( $scope, function( changedColumn ){
                $scope.columnChanged = { name: changedColumn.colDef.name, visible: changedColumn.colDef.visible };
            });
        }
    };


    var getCompanyPaymentHistory = function(row){


        $http({
            method: 'GET',
            url: '/billing/getCompanyPaymentHistory'
        })

            .success(function (data, status, headers, config) {
                //ctrl.viewAmount = data[0].amount;
                //if(ctrl.viewAmount == ''){
                //    row.entity.amount = '--' ;
                //}

                $scope.gridHistory.data = data;
            })
    };



    var updateBilling = function () {
//alert(ctrl.cardNumber);
        if( ctrl.billingEditForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/billing/updateBilling',
                data    :  {nameOnCard:ctrl.nameOnCard,
                    cardNumber:ctrl.cardNumber,
                    expirationDate:ctrl.expirationDate,
                    billingAddress:ctrl.billingAddress,
                    city:ctrl.city,
                    state:ctrl.state,
                    zip:ctrl.zip},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }

            })
                .success(function (data, status, headers, config) {
                    $('#editPayment').appendTo("body").modal('hide');

                    ctrl.showPaymentUpdatedPrompt = true;
                    $timeout(function(){
                        ctrl.showPaymentUpdatedPrompt = false;
                    }, 5000);
                });

        }
    };


    ctrl.updateBilling = updateBilling;

    var hasErrorClassEdit = function (field) {
        return ctrl.billingEditForm[field].$touched && ctrl.billingEditForm[field].$invalid;
    };

    var showMessagesEdit = function (field) {
        return ctrl.billingEditForm[field].$touched || ctrl.billingEditForm.$submitted;
    };

    ctrl.hasErrorClassEdit = hasErrorClassEdit;
    ctrl.showMessagesEdit = showMessagesEdit;


    //start credit card
    $scope.ccinfo = {type:undefined}
    $scope.save = function(data){
        if ($scope.billingEditForm.$valid){
            console.log(data) // valid data saving stuff here
        }
    }

    ///********* Billing*******


    ///***********strip***********

    $(document).ready(function(){

        var $tokenInput = $('#stripeToken'),
            $cardNumberInput = $('#cc_number'),
            $cardCvcInput = $('#cvc'),
            $cardExpMonth = $('#exp_month'),
            $cardExpYear = $('#exp_year'),
            $checkoutForm = $('#checkout_form');

        //Stripe.setPublishableKey("pk_test_VukkoSDQFtWsdcc5CTd8i6bK");

        $('#submit').click(checkCreditCardValues);

        function checkout(){
            console.info('submit form, process payment, create transaction', $checkoutForm);
            $checkoutForm.submit();
        }

        function setStripeTokenInput(code, token){
            console.info("retrieved token : ", token)
            //set hidden stripe token input
            $tokenInput.val(token.id)
            checkout();
        }

        function getStripeToken(){
            console.info('get stripe token')
            Stripe.card.createToken({
                number    : $cardNumberInput.val(),
                cvc       : $cardCvcInput.val(),
                exp_month : $cardExpMonth.val(),
                exp_year  : $cardExpYear.val()
            }, setStripeTokenInput);
        }


        function checkCreditCardValues(){
            if($cardNumberInput.val() != "" &&
                $cardCvcInput.val() != "" &&
                $cardExpMonth.val() != "" &&
                $cardExpYear.val() != ""){
                getStripeToken();
            }else{
                alert('Please make sure all credit card information is provided')
            }
        }

    })

}])

;






