/**
 * Created by home on 9/10/15.
 */

var app = angular.module('adminUserBilling', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.grid.resizeColumns', 'ui.bootstrap', 'ngLocale']);

app.controller('MainCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', '$locale', function ($scope, $http, $interval, $q, $timeout, $locale) {

    var fakeI18n = function (title) {
        var deferred = $q.defer();
        $interval(function () {
            deferred.resolve('col: ' + title);
        }, 1000, 1);
        return deferred.promise;
    };

    var myEl = angular.element(document.querySelector('#liAdmin'));
    myEl.addClass('active');
    var subMenu = angular.element(document.querySelector('#ulAdmin'));
    subMenu.removeClass('out');
    subMenu.addClass('in');


    $http.get('/user/getCompanyUsersWithFullName')
        .success(function (data) {
            ctrl.activeUsersCount = data.length;

        });





    var ctrl = this,
        newCustomer = {firstName: '', lastName: '', email: '', username: '', password: ''};

    ctrl.showEmailPrompt = false;
    ctrl.showUsernamePrompt = false;
    ctrl.showFirstNamePrompt = false;
    ctrl.showLastNamePrompt = false;
    ctrl.showSubmittedPrompt = false;
    ctrl.showDeletedPrompt = false;
    ctrl.newCustomer = newCustomer;

    //Active User Count
    $http({
        method: 'GET',
        url: '/company/getCurrentUserCompany'
    })
        .success(function (data, status, headers, config) {
            ctrl.licensedUser = data.noOfLicensedUsers;
        })



///********* Billing*******


        var openBilling = function () {
            getCompanyBillingDetails();
            // $('#billing').appendTo("body").modal('show');
        };
        ctrl.openBilling = openBilling;

        var openBuyMoreUsers = function () {

            $http({
                method: 'GET',
                url: '/billing/getCompanyCreditCard'
            })

                .success(function (data, status, headers, config) {

                    if(data){
                        ctrl.NoOfUsers = ctrl.licensedUser + 1;
                        ctrl.paymentProcessMessage = false;
                        ctrl.paymentErrorMessage = null;
                        $('#manageCurrentPlanPremium').appendTo("body").modal('show');
                    }
                    else{
                        $('#noCreditCard').appendTo("body").modal('show');

                    }

                })
                .error(function (data, status, headers, config) {

                    $('#noCreditCard').appendTo("body").modal('show');
                });


        };

        ctrl.openBuyMoreUsers = openBuyMoreUsers;


    var upgrade = function () {
        $('#upgrade').appendTo("body").modal('show');

        // $('#billing').appendTo("body").modal('hide');
        

    };
    ctrl.upgrade = upgrade;


    var getNoOfUsers = function () {

        $http({
            method: 'GET',
            url: '/company/getCurrentUserCompany'
        })

            .success(function (data, status, headers, config) {
                ctrl.noOfUsers = data.noOfLicensedUsers;

                //if(ctrl.noOfUsers < 2) {
                //    ctrl.NoOfUsers = 2;
                //}
                //
                //else{
                //    ctrl.NoOfUsers = data.noOfLicensedUsers;
                //}

                ctrl.NoOfUsers = data.noOfLicensedUsers;
            })



    };

    getNoOfUsers();

    var edit = function () {

        getNoOfUsers();

        ctrl.paymentProcessMessage = false;
        ctrl.paymentErrorMessage = null;

        $('#editPayment').appendTo("body").modal('show');

        $http({
            method: 'GET',
            url: '/billing/getCompanyCreditCard'
        })

            .success(function (data, status, headers, config) {
                ctrl.nameOnCard = data.nameOnCard;

                var num = data.cardNumber;
                ctrl.cardNumber = "xxxxxxxxxxxx" + num;

                ctrl.billingAddress = data.billingAddress;
                ctrl.city = data.city;
                ctrl.state = data.state;
                ctrl.zip = data.zip;
                ctrl.expirationMonth = data.expirationMonth;
                ctrl.expirationYear = data.expirationYear;
                ctrl.customerId = data.customerId;


            })


    };
    ctrl.edit = edit;


    var payment = function () {
        getCompanyPaymentHistory();
        $('#paymentHistory').appendTo("body").modal('show');
    };
    ctrl.payment = payment;


    $("#closeButton").click(function () { //function to delete.
        $('#editPayment').appendTo("body").modal('hide');
    });


    function addDays(theDate, days) {
        return new Date(theDate.getTime() + days*24*60*60*1000);
    }

        //SRIKARAN
    var getCompanyBillingDetails = function () {

        $http({
            method: 'GET',
            url: '/billing/getCompanyBilling'
        })

            .success(function (data, status, headers, config) {
                ctrl.billingCompanyId = data.companyId;
                ctrl.planDetails = data.currentPlanDetail;
                ctrl.paymentMethod = data.paymentMethod;
                ctrl.nextPayment = data.nextPaymentDate;
                ctrl.isTrialPeriod = data.isTrial;
                ctrl.couponId = data.couponId;

                ctrl.showBillingButton = true;
                if(data.isTrial == true && addDays(new Date(data.trialDate), 5) < new Date()){
                    $('#upgradeFromTrial').appendTo("body").modal('show');
                }
                else if(data.isTrial == true && new Date(data.trialDate) < new Date()){
                    $('#warningTrialEndMessage').appendTo("body").modal('show');
                }

                if(data.isTrial == true){
                    ctrl.remainingDaysOnTrial = Math.round((new Date(data.trialDate)-new Date())/(1000*60*60*24));
                }
                ctrl.trialDateTimeStamp =  new Date(data.trialDate).getTime()/1000;
                ctrl.currentTimeStamp = new Date().getTime()/1000;

                ctrl.subscriptionStatus = 'Subscribed';
                if (ctrl.planDetails == 'Individual') {
                    ctrl.viewPlan = 'Individual';
                }

                else if (ctrl.planDetails == 'Standard') {
                    ctrl.viewPlan = 'Standard';
                }

                else if (ctrl.planDetails == 'Premium') {
                    ctrl.viewPlan = 'Premium';
                }

                else if (ctrl.planDetails == 'Premium-V2') {
                    ctrl.viewPlan = 'Premium-V2';
                }

                else if (ctrl.planDetails == 'Enterprise') {
                    ctrl.viewPlan = 'Enterprise';
                }


                 getPlanAmount(ctrl.planDetails);


            })
    };

    //SRIKARAN
    var getPlanAmount = function (plan) {
        getNoOfUsers();

        $http({
            method: 'POST',
            url: '/billing/getPlanAmount',
            data: {planDetails: plan},
            dataType: 'json',
            headers: {'Content-Type': 'application/json; charset=utf-8'}
        })

            .success(function (data, status, headers, config) {
                ctrl.currentCost = (data.amount / 100);
                ctrl.period = data.interval;

                if(data.name == 'Standard'){
                    ctrl.viewTotalAmount = ctrl.currentCost + (15 * (ctrl.noOfUsers - 2))
                }
                else if(data.name == 'Premium'){
                    ctrl.viewTotalAmount = ctrl.currentCost + (20 * (ctrl.noOfUsers - 5))
                }
                else if(data.name == 'Premium-V2'){
                    ctrl.viewTotalAmount = ctrl.currentCost + (49 * (ctrl.noOfUsers - 5))
                }
                else{
                    ctrl.viewTotalAmount = ctrl.currentCost
                }

            })
    };


    getCompanyBillingDetails();


// currrent user company
    var getCurrentUserInfo = function () {

        $http({
            method: 'GET',
            url: '/userAccount/getUser'
        })
            .success(function (data, status, headers, config) {
                ctrl.billingCompanyId = data.companyId;
            })

    };

    getCurrentUserInfo();


    //view history grid
    var headerTitle1 = 'Payment History';

    $scope.gridHistory = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        gridMenuTitleFilter: fakeI18n,

        exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
        exporterPdfHeader: {text: headerTitle1, style: 'headerStyle'},
        exporterPdfFooter: function (currentPage, pageCount) {
            return {text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle'};
        },
        exporterPdfCustomFormatter: function (docDefinition) {
            docDefinition.styles.headerStyle = {fontSize: 15, bold: true, margin: 20};
            //docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
            return docDefinition;
        },
        exporterPdfOrientation: 'portrait',
        exporterPdfPageSize: 'LETTER',
        exporterPdfMaxGridWidth: 500,

        columnDefs: [
            {name: 'Date', field: 'date', type: 'date', cellFilter: 'date:"MM/dd/yyyy"'},
            {name: 'Amount', field: 'amountDue', type: 'currency', cellFilter: 'currency'},
            {name: 'Paid', field: 'paid'}

        ],
        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;

            // interval of zero just to allow the directive to have initialized
            $interval(function () {
                gridApi.core.addToGridMenu(gridApi.grid, [{title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged($scope, function (changedColumn) {
                $scope.columnChanged = {name: changedColumn.colDef.name, visible: changedColumn.colDef.visible};
            });
        }
    };


    var getCompanyPaymentHistory = function (row) {


        $http({
            method: 'GET',
            url: '/billing/getCompanyPaymentStripeHistory'
        })

            .success(function (response, status, headers, config) {


                for (i = 0; i < response.data.length; i++) {
                    response.data[i].amountDue = response.data[i].amountDue / 100;
                    response.data[i].date = response.data[i].date * 1000;

                }

                $scope.gridHistory.data = response.data;


            })
    };



    function stripeResponseHandler(code, token) {


        if(token.error) {
            //alert(token.error.message);
            ctrl.paymentProcessMessage = false;
            ctrl.paymentErrorMessage = token.error.message;
            $timeout(function () {
                ctrl.showPaymentErrorPrompt = false;
            }, 5000);

        }
        else if(ctrl.plan){

            console.info("retrieved token : ", token)


            //set hidden stripe token input
            ctrl.stripeToken = token.id;

            ctrl.cardType = cardType(ctrl.cardNumber);
            var planDetail = ctrl.plan;


            $http({
                method: 'POST',
                url: '/billing/upgrade',
                data: {
                    NoOfUsers: ctrl.NoOfUsers,
                    currentPlanDetail: planDetail,
                    paymentMethod: ctrl.cardType,
                    nameOnCard: ctrl.nameOnCard,
                    cardNumber: ctrl.cardNumber,
                    expirationMonth: ctrl.expirationMonth,
                    expirationYear: ctrl.expirationYear,
                    billingAddress: ctrl.billingAddress,
                    city: ctrl.city,
                    state: ctrl.state,
                    zip: ctrl.zip,
                    plan: ctrl.planDetails,
                    card: token.id,
                    couponId: ctrl.couponId
                },
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}
            })
                .success(function (data, status, headers, config) {

                    getCompanyBillingDetails();

                    $('#upgradeStandard').appendTo("body").modal('hide');
                    $('#upgradePremium').appendTo("body").modal('hide');
                    $('#upgrade').appendTo("body").modal('hide');
                    // $('#billing').appendTo("body").modal('show');
                    $('#editPayment').appendTo("body").modal('hide');
                    $('#upgradeFromTrial').appendTo("body").modal('hide');

                    ctrl.licensedUser = ctrl.NoOfUsers;
                    ctrl.paymentProcessMessage = false;
                    ctrl.showPaymentUpdatedPrompt = true;
                    $timeout(function () {
                        ctrl.showPaymentUpdatedPrompt = false;
                    }, 5000);

                });

        }
        else{
            $http({
                method: 'POST',
                url: '/billing/updateCreditCard',
                data: {
                    NoOfUsers: ctrl.NoOfUsers,
                    currentPlanDetail: ctrl.viewPlan,
                    paymentMethod: ctrl.cardType,
                    nameOnCard: ctrl.nameOnCard,
                    cardNumber: ctrl.cardNumber,
                    expirationMonth: ctrl.expirationMonth,
                    expirationYear: ctrl.expirationYear,
                    billingAddress: ctrl.billingAddress,
                    city: ctrl.city,
                    state: ctrl.state,
                    zip: ctrl.zip,
                    card: token.id,
                    currentTimeStamp: ctrl.currentTimeStamp,
                    trialDateTimeStamp: ctrl.trialDateTimeStamp,
                    couponId: ctrl.couponId
                },
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}
            })
                .success(function (data, status, headers, config) {

                    $('#editPayment').appendTo("body").modal('hide');
                    ctrl.paymentProcessMessage = false;
                    ctrl.paymentErrorMessage = null;
                    ctrl.showPaymentUpdatedPrompt = true;
                    $timeout(function () {
                        ctrl.showPaymentUpdatedPrompt = false;
                    }, 5000);

                });


        }

    }

    //ctrl.showPaymentErrorPrompt = true;

    var createToken = function () {

       var token = Stripe.card.createToken({
            number: ctrl.cardNumber,
            cvc: ctrl.cvc,
            exp_month: ctrl.expirationMonth,
            exp_year: ctrl.expirationYear,
            address_line1: ctrl.billingAddress,
            address_city: ctrl.city,
            address_state: ctrl.state,
            address_zip: ctrl.zip,
            object: 'card'
        }, stripeResponseHandler);
    };


    //createToken();

    var updateBilling = function () {

        ctrl.paymentProcessMessage = true;
        ctrl.paymentErrorMessage = null;

        ctrl.viewResult = false;
        var viewCardNo = ctrl.cardNumber;

        if(isNaN(parseInt(viewCardNo))){
            ctrl.viewResult = true;
            ctrl.billingEditForm.$valid = false;
            ctrl.paymentProcessMessage = false;
        }

       if (ctrl.billingEditForm.$valid) {
           createToken();
        }

    }


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
    $scope.ccinfo = {type: undefined}
    $scope.save = function (data) {
        if ($scope.billingEditForm.$valid) {
            console.log(data) // valid data saving stuff here
        }
    }

    var cardType = function (value) {
        var cardTest =
            (/^5[1-5]/.test(value)) ? "Mastercard"
                : (/^4/.test(value)) ? "Visa"
                : (/^3[47]/.test(value)) ? 'Amex'
                : (/^6011|65|64[4-9]|622(1(2[6-9]|[3-9]\d)|[2-8]\d{2}|9([01]\d|2[0-5]))/.test(value)) ? 'Discover'
                : undefined
        return cardTest;
        //alert(cardTest);

    };
    //cardType();


    var upgradeStandard = function () {
        ctrl.paymentProcessMessage = false;
        ctrl.paymentErrorMessage = null;
        $('#upgradeStandard').appendTo("body").modal('show');
        $http({
            method: 'GET',
            url: '/billing/getCompanyCreditCard'
        })

            .success(function (data, status, headers, config) {

                if(data.cardNumber){
                    ctrl.nameOnCard = data.nameOnCard;

                    var num = data.cardNumber;
                    ctrl.cardNumber = "xxxxxxxxxxxx" + num;

                    ctrl.billingAddress = data.billingAddress;
                    ctrl.city = data.city;
                    ctrl.state = data.state;
                    ctrl.zip = data.zip;
                    ctrl.expirationMonth = data.expirationMonth;
                    ctrl.expirationYear = data.expirationYear;
                    ctrl.customerId = data.customerId;
                }

            })
    };

    var upgradeStandardSaveAction = function () {

        if (ctrl.upgradeStandardForm.$valid) {

            ctrl.paymentProcessMessage = true;
            ctrl.paymentErrorMessage = null;
            ctrl.plan = "Standard";
            createToken();

        }

    };

    ctrl.upgradeStandardSaveAction = upgradeStandardSaveAction;


    var upgradeFromTrial = function () {
        ctrl.paymentProcessMessage = false;
        ctrl.paymentErrorMessage = null;
        $('#upgradeFromTrial').appendTo("body").modal('show');

        $http({
            method: 'GET',
            url: '/billing/getCompanyCreditCard'
        })

            .success(function (data, status, headers, config) {

                if(data.cardNumber){
                    ctrl.nameOnCard = data.nameOnCard;

                    var num = data.cardNumber;
                    ctrl.cardNumber = "xxxxxxxxxxxx" + num;

                    ctrl.billingAddress = data.billingAddress;
                    ctrl.city = data.city;
                    ctrl.state = data.state;
                    ctrl.zip = data.zip;
                    ctrl.expirationMonth = data.expirationMonth;
                    ctrl.expirationYear = data.expirationYear;
                    ctrl.customerId = data.customerId;
                }

            })
    };


    var upgradeFromTrialSaveAction = function () {

        if (ctrl.upgradeFromTrialForm.$valid) {

            ctrl.NoOfUsers = ctrl.licensedUser;

            $http({
                method: 'GET',
                url: '/billing/getCompanyBilling'
            })

                .success(function (data, status, headers, config) {
                    ctrl.couponId = data.couponId

                    if(data.currentPlanDetail == 'Individual'){
                        ctrl.paymentProcessMessage = true;
                        ctrl.plan = 'Individual';
                        createToken();
                    }
                    else if(data.currentPlanDetail == 'Standard'){
                        //ctrl.manageCurrentPlanForm.$valid = true;
                        //upgradeCurrentPlanStandardSave();
                        //ctrl.manageCurrentPlanForm.$valid = false;
                        ctrl.paymentProcessMessage = true;
                        ctrl.plan = 'Standard';
                        createToken();
                    }
                    else if (data.currentPlanDetail == 'Premium') {
                        //ctrl.manageCurrentPlanForm.$valid = true;
                        //upgradeCurrentPlanPremiumSave();
                        //ctrl.manageCurrentPlanForm.$valid = false;

                        ctrl.paymentProcessMessage = true;
                        ctrl.plan = 'Premium';
                        createToken();
                    }
                    else if (data.currentPlanDetail == 'Premium-V2') {
                        //ctrl.manageCurrentPlanForm.$valid = true;
                        //upgradeCurrentPlanPremiumSave();
                        //ctrl.manageCurrentPlanForm.$valid = false;

                        ctrl.paymentProcessMessage = true;
                        ctrl.plan = 'Premium-V2';
                        createToken();
                    }
                    else if (data.currentPlanDetail == 'Enterprise') {
                        //ctrl.manageCurrentPlanForm.$valid = true;
                        //upgradeCurrentPlanPremiumSave();
                        //ctrl.manageCurrentPlanForm.$valid = false;

                        ctrl.paymentProcessMessage = true;
                        ctrl.plan = 'Enterprise';
                        createToken();
                    }


                    //window.location.href = '';
                    //$('#upgradeFromTrial').appendTo("body").modal('hide');

                })

        }

    };

    ctrl.upgradeFromTrialSaveAction = upgradeFromTrialSaveAction;

    ctrl.upgradeStandard = upgradeStandard;


    var upgradePremium = function () {

        ctrl.paymentProcessMessage = false;
        ctrl.paymentErrorMessage = null;

        ctrl.plan = 'Premium';
        if(ctrl.NoOfUsers < 5) {
            ctrl.NoOfUsers = 5;
        }



        $('#upgradePremium').appendTo("body").modal('show');

        $http({
            method: 'GET',
            url: '/billing/getCompanyCreditCard'
        })

            .success(function (data, status, headers, config) {
                ctrl.nameOnCard = data.nameOnCard;

                var num = data.cardNumber;
                ctrl.cardNumber = "xxxxxxxxxxxx" + num;

                ctrl.billingAddress = data.billingAddress;
                ctrl.city = data.city;
                ctrl.state = data.state;
                ctrl.zip = data.zip;
                ctrl.expirationMonth = data.expirationMonth;
                ctrl.expirationYear = data.expirationYear;
                ctrl.customerId = data.customerId;

            })



    };
    ctrl.upgradePremium = upgradePremium;

    var upgradePremiumSaveAction = function () {

        if (ctrl.upgradePremiumForm.$valid) {

            ctrl.paymentProcessMessage = true;
            ctrl.paymentErrorMessage = null;
            ctrl.plan = "Premium";
            createToken();

        }
        //ctrl.cardType = cardType(ctrl.cardNumber);
        //
        //if(ctrl.planDetails == 'Individual'){
        //    if(ctrl.plan == null){
        //        ctrl.plan = 'Premium-monthly';
        //    }
        //}
        //
        //if(ctrl.planDetails == 'Standard-monthly'){
        //    if(ctrl.plan == null){
        //        ctrl.plan = 'Premium-monthly';
        //    }
        //}
        //
        //if(ctrl.planDetails == 'Standard-yearly'){
        //    ctrl.plan = 'Premium-yearly';
        //}
        //
        //$http({
        //    method: 'POST',
        //    url: '/billing/upgradePremium',
        //    data: {NoOfUsers: ctrl.NoOfUsers, currentPlanDetail: ctrl.plan, paymentMethod: ctrl.cardType},
        //    dataType: 'json',
        //    headers: {'Content-Type': 'application/json; charset=utf-8'}
        //})
        //    .success(function (data, status, headers, config) {
        //
        //        getPlanAmount(ctrl.plan);
        //
        //        updateBilling();
        //
        //        $('#upgradePremium').appendTo("body").modal('hide');
        //
        //        $('#upgrade').appendTo("body").modal('hide');
        //
        //        getCompanyBillingDetails();
        //        $('#billing').appendTo("body").modal('show');
        //
        //    });

    };


    ctrl.upgradePremiumSaveAction = upgradePremiumSaveAction;


    var upgradeCurrentPlanStandard = function () {

        $http({
            method: 'GET',
            url: '/billing/getCompanyCreditCard'
        })

            .success(function (data, status, headers, config) {

                if(data){
                    ctrl.NoOfUsers = ctrl.licensedUser + 1;
                    $('#manageCurrentPlanStandard').appendTo("body").modal('show');
                    ctrl.paymentProcessMessage = false;
                    ctrl.paymentErrorMessage = null;
                }
                else{
                    $('#noCreditCard').appendTo("body").modal('show');

                }

            })
            .error(function (data, status, headers, config) {

                $('#noCreditCard').appendTo("body").modal('show');
            });



    };
    ctrl.upgradeCurrentPlanStandard = upgradeCurrentPlanStandard;

    var upgradeCurrentPlanStandardSave = function () {

        if (ctrl.manageCurrentPlanForm.$valid) {

            ctrl.paymentProcessMessage = true;

            ctrl.plan = "Standard";

            $http({
                method: 'POST',
                url: '/billing/upgradeCurrentPlan',
                data: {NoOfUsers: ctrl.NoOfUsers, currentPlanDetail: ctrl.plan},
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}
            })

                .success(function (data, status, headers, config) {

                    $('#manageCurrentPlanStandard').appendTo("body").modal('hide');
                    ctrl.licensedUser = ctrl.NoOfUsers;

                    getCompanyBillingDetails();
                    ctrl.paymentProcessMessage = false;
                    $('#upgradeFromTrial').appendTo("body").modal('hide');

                })

        }

    };
    ctrl.upgradeCurrentPlanStandardSave = upgradeCurrentPlanStandardSave;

    var upgradeCurrentPlanIndividualSave = function () {

        if (ctrl.manageCurrentPlanForm.$valid) {

            ctrl.paymentProcessMessage = true;

            ctrl.plan = "Individual";
            ctrl.NoOfUsers = 1;

            $http({
                method: 'POST',
                url: '/billing/upgradeCurrentPlan',
                data: {NoOfUsers: ctrl.NoOfUsers, currentPlanDetail: ctrl.plan},
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}
            })

                .success(function (data, status, headers, config) {

                    $('#manageCurrentPlanStandard').appendTo("body").modal('hide');
                    ctrl.licensedUser = ctrl.NoOfUsers;

                    getCompanyBillingDetails();
                    ctrl.paymentProcessMessage = false;

                })

        }

    };
    ctrl.upgradeCurrentPlanIndividualSave = upgradeCurrentPlanIndividualSave;


    var upgradeCurrentPlanPremium = function () {
        ctrl.NoOfUsers = ctrl.licensedUser + 1;
        ctrl.paymentProcessMessage = false;
        ctrl.paymentErrorMessage = null;
        $('#manageCurrentPlanPremium').appendTo("body").modal('show');


    };
    ctrl.upgradeCurrentPlanPremium = upgradeCurrentPlanPremium;


    var upgradeCurrentPlanPremiumSave = function () {

        if (ctrl.manageCurrentPlanForm.$valid) {

            ctrl.paymentProcessMessage = true;
            ctrl.plan = "Premium";

            $http({
                method: 'POST',
                url: '/billing/upgradeCurrentPlan',
                data: {NoOfUsers: ctrl.NoOfUsers, currentPlanDetail: ctrl.plan},
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}
            })

                .success(function (data, status, headers, config) {

                    $('#manageCurrentPlanPremium').appendTo("body").modal('hide');
                    ctrl.licensedUser = ctrl.NoOfUsers;

                    getCompanyBillingDetails();

                    ctrl.paymentProcessMessage = false;
                    $('#upgradeFromTrial').appendTo("body").modal('hide');

                })

        }


    };
    ctrl.upgradeCurrentPlanPremiumSave = upgradeCurrentPlanPremiumSave;


    var hasErrorClassEdit3 = function (field) {
        return ctrl.upgradeStandardForm[field].$touched && ctrl.upgradeStandardForm[field].$invalid;
    };

    var showMessagesEdit3 = function (field) {
        return ctrl.upgradeStandardForm[field].$touched || ctrl.upgradeStandardForm.$submitted;
    };

    ctrl.hasErrorClassEdit3 = hasErrorClassEdit3;
    ctrl.showMessagesEdit3 = showMessagesEdit3;


    var hasErrorClassEdit1 = function (field) {
        return ctrl.upgradePremiumForm[field].$touched && ctrl.upgradePremiumForm[field].$invalid;
    };

    var showMessagesEdit1 = function (field) {
        return ctrl.upgradePremiumForm[field].$touched || ctrl.upgradePremiumForm.$submitted;
    };

    ctrl.hasErrorClassEdit1 = hasErrorClassEdit1;
    ctrl.showMessagesEdit1 = showMessagesEdit1;


    var hasErrorClassEdit2 = function (field) {
        return ctrl.manageCurrentPlanForm[field].$touched && ctrl.manageCurrentPlanForm[field].$invalid;
    };

    var showMessagesEdit2 = function (field) {
        return ctrl.manageCurrentPlanForm[field].$touched || ctrl.manageCurrentPlanForm.$submitted;
    };

    ctrl.hasErrorClassEdit2 = hasErrorClassEdit2;
    ctrl.showMessagesEdit2 = showMessagesEdit2;


    $("#closeButton1").click(function () {
        $('#upgradeStandard').appendTo("body").modal('hide');
    });

    $("#closeButton2").click(function () {
        $('#upgradePremium').appendTo("body").modal('hide');
    });

    $("#closeButton3").click(function () {
        $('#manageCurrentPlan').appendTo("body").modal('hide');
    });

    $("#closeButton4").click(function () {
        $('#manageCurrentPlanStandard').appendTo("body").modal('hide');
    });

    $("#closeButton5").click(function () {
        $('#manageCurrentPlanPremium').appendTo("body").modal('hide');
    });


    ///********* Billing*******

}])



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

    .directive
('creditCardType'
    , function () {
        var directive =
        {
            require: 'ngModel'
            , link: function (scope, elm, attrs, ctrl) {
            ctrl.$parsers.unshift(function (value) {
                scope.ccinfo.type =
                    (/^5[1-5]/.test(value)) ? "mastercard"
                        : (/^4/.test(value)) ? "visa"
                        : (/^3[47]/.test(value)) ? 'amex'
                        : (/^6011|65|64[4-9]|622(1(2[6-9]|[3-9]\d)|[2-8]\d{2}|9([01]\d|2[0-5]))/.test(value)) ? 'discover'
                        : (/^1/.test(value)) ? "Invalid card number"
                        : (/^2/.test(value)) ? "Invalid card number"
                        : (/^7/.test(value)) ? "Invalid card number"
                        : (/^8/.test(value)) ? "Invalid card number"
                        : (/^9/.test(value)) ? "Invalid card number"
                        : undefined
                ctrl.$setValidity('invalid', !!scope.ccinfo.type)
                return value
            })
        }
        }
        return directive
    }
)

;
