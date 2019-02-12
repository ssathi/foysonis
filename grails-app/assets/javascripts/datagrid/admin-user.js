/**
 * Created by home on 9/10/15.
 */

var app = angular.module('adminUser', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.grid.resizeColumns', 'ui.bootstrap', 'ngLocale']);

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

    $scope.removeAClass = function(){
        var myEl = angular.element(document.querySelector('#liAdmin'));
        myEl.removeClass('active');
        var subMenu = angular.element(document.querySelector('#ulAdmin'));
        subMenu.removeClass('in');
        subMenu.addClass('out');        
    };

    var headerTitle = 'Users';

    var rows = null;
    $scope.Delete = function (row) {
        //Check Current User
        $http.get('/user/getCurrentUser')
            .success(function (data) {
                var currentUserUsername = data.username;
                var currentUserCompanyId = data.companyId;

                ctrl.DeleteForFirstName = row.entity[1];
                ctrl.DeleteForLastName = row.entity[2];

                ctrl.billingCompanyId = row.entity[7];

                if (currentUserCompanyId != row.entity[7] || currentUserUsername == row.entity[3]) {
                    $('#userCannotBeDeletedWarning').appendTo('body').modal('show');
                }
                else {
                    $('#userDeleteWarning').appendTo('body').modal('show');
                    rows = row;
                }


            });

    };

    $("#deleteUserButtonFromPopUp").click(function () {

        $http({
            method: 'POST',
            url: '/user/deleteUser',
            data: {username: rows.entity[3], companyId: rows.entity[7]},
            dataType: 'json',
            headers: {'Content-Type': 'application/json; charset=utf-8'}  // set the headers so angular passing info as form data (not request payload)
        })
            .success(function (data, status, headers, config) {
                var index = $scope.gridOptions.data.indexOf(rows.entity);
                $scope.gridOptions.data.splice(index, 1);
                ctrl.activeUsersCount = ctrl.activeUsersCount - 1;

                ctrl.showDeletedPrompt = true;
                $timeout(function () {
                    ctrl.showDeletedPrompt = false;
                }, 5000);

            });

        $('#userDeleteWarning').appendTo('body').modal('hide');

    });

    $scope.Edit = function (row) {
        //Check Current User
        $http.get('/user/getCurrentUser')
            .success(function (data) {
                var currentUserUsername = data.username;
                var currentUserCompanyId = data.companyId;

                if (currentUserCompanyId != row.entity[7] || currentUserUsername == row.entity[3]) {
                    $('#userCannotBeEditedWarning').appendTo('body').modal('show');
                }
                else {
                    $('#userEditWarning').appendTo('body').modal('show');
                    ctrl.rows = row;
                }


            });

    };

    $scope.openEdit = function () {

        $('#userEditWarning').appendTo('body').modal('hide');
        $scope.IsVisible = true;
        ctrl.newCustomer.firstName = ctrl.rows.entity[1];
        ctrl.newCustomer.lastName = ctrl.rows.entity[2];
        ctrl.newCustomer.email = ctrl.rows.entity[4];
        ctrl.emailForEdit = ctrl.rows.entity[4];
        ctrl.newCustomer.username = ctrl.rows.entity[3];
        ctrl.newCustomer.password = "";
        ctrl.newCustomer.activeStatus = ctrl.rows.entity[6];
        ctrl.newCustomer.adminActiveStatus = ctrl.rows.entity[5];
        ctrl.newCustomer.portalOnlyUser = ctrl.rows.entity[8];
        ctrl.newCustomer.hiddenUsername = ctrl.rows.entity[3];
        ctrl.userFormLabel = "Edit User";

    };


    $scope.gridOptions = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: true,
        gridMenuTitleFilter: fakeI18n,

        exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
        exporterPdfHeader: {text: headerTitle, style: 'headerStyle'},
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
            {name: 'username', field: '3', enableHiding: false},
            {name: 'Name', field: '0'},
            {
                name: 'Active',
                field: '6',
                type: 'boolean',
                cellClass: 'grid-align',
                cellTemplate: '<div class="gridCheckbox c-checkbox"><input type="checkbox"  ng-model="row.entity[6]" disabled><span class="fa fa-check"></span></div class>',
                enableFiltering: false
            },
            {
                name: 'Admin',
                field: '5',
                type: 'boolean',
                cellClass: 'grid-align',
                cellTemplate: '<div class="gridCheckbox c-checkbox"><input type="checkbox"  ng-model="row.entity[5]" disabled><span class="fa fa-check"></span></div class>',
                enableFiltering: false
            },
            {
                name: 'Portal Only User',
                field: '8',
                type: 'boolean',
                cellClass: 'grid-align',
                cellTemplate: '<div class="gridCheckbox c-checkbox"><input type="checkbox"  ng-model="row.entity[8]" disabled><span class="fa fa-check"></span></div class>',
                enableFiltering: false
            },
            //{ name: 'Actions', enableSorting: false, enableFiltering: false, cellTemplate: ' <button class="btn btn-labeled btn-info" ng-click="grid.appScope.Edit(row)"><i class="fa fa-edit"></i></button> <button class="btn btn-labeled btn-danger" ng-click="grid.appScope.Delete(row)"><i class="fa fa-times"></i></button>'},
            {
                name: 'Actions',
                cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.Delete(row)">Delete</a></li></ul></div>',
                enableFiltering: false
            }
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

    var findWithAttribute = function(array, attr, value) {
        for(var i = 0; i < array.length; i += 1) {
            if(array[i][attr] === value) {
                return i;
            }
        }
        return -1;
    }

    var removeColumnFromGrid = function(){
        $http.get('/company/getCurrentUserCompany')
            .success(function (data) {
                if (data && data.companyId.toUpperCase() === "WARRENINST") {
                    //'gridOptions' is the name of the grid
                    var indx = findWithAttribute($scope.gridOptions.columnDefs, "name", "Portal Only User");
                    if (indx > -1) {
                        //remove the element from the grid list
                       $scope.gridOptions.columnDefs.splice(indx, 1);
                    }
                }
            });
        
    }
    removeColumnFromGrid();


    $http.get('/user/getCompanyUsersWithFullName')
        .success(function (data) {
            $scope.gridOptions.data = data;
            ctrl.activeUsersCount = data.length;

        });

    $scope.IsVisible = false;
    $scope.ShowHide = function () {
        //If DIV is visible it will be hidden and vice versa.
        clearForm();
        $scope.IsVisible = $scope.IsVisible ? false : true;
        ctrl.userFormLabel = "Add New User";
    }

    $scope.portalOnlyUserCheckBoxChange = function () {
        if(ctrl.newCustomer.portalOnlyUser){
            ctrl.newCustomer.adminActiveStatus = false;
        }
    }

    $scope.adminActiveStatusCheckBoxChange = function () {
        if(ctrl.newCustomer.adminActiveStatus){
            ctrl.newCustomer.portalOnlyUser = false;
        }
    }


    var ctrl = this,
        newCustomer = {firstName: '', lastName: '', email: '', username: '', password: ''};

        var signup = function () {
        if (ctrl.signupForm.$valid) {

            $http({
                method: 'POST',
                url: '/user/saveUser',
                data: $scope.ctrl.newCustomer,
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function (data) {

                    if (ctrl.newCustomer.hiddenUsername) {
                        ctrl.showUpdatedPrompt = true;
                        $timeout(function () {
                            ctrl.showUpdatedPrompt = false;
                        }, 5000);
                    } else {
                        ctrl.showSubmittedPrompt = true;
                        $timeout(function () {
                            ctrl.showSubmittedPrompt = false;
                        }, 5000);
                    }

                    ctrl.EditForFirstName = ctrl.newCustomer.firstName;
                    ctrl.EditForLastName = ctrl.newCustomer.lastName;

                    $scope.IsVisible = false;
                    $http.get('/user/getCompanyUsersWithFullName')
                        .success(function (data) {
                            $scope.gridOptions.data = data;
                            ctrl.activeUsersCount = data.length;

                        });

                    clearForm();
                })

        }
    };

    var clearForm = function () {
        ctrl.newCustomer = {firstName: '', lastName: '', email: '', username: '', password: ''}
        ctrl.emailForEdit = '';
        ctrl.signupForm.$setUntouched();
        ctrl.signupForm.$setPristine();
        ctrl.userFormLabel = "";
    };

    var getPasswordType = function () {
        return ctrl.signupForm.showPassword ? 'text' : 'password';
    };

    var toggleEmailPrompt = function (value) {
        ctrl.showEmailPrompt = value;
    };

    var toggleUsernamePrompt = function (value) {
        ctrl.showUsernamePrompt = value;
    };

    var toggleFirstNamePrompt = function (value) {
        ctrl.showFirstNamePrompt = value;
    };

    var toggleLastNamePrompt = function (value) {
        ctrl.showLastNamePrompt = value;
    };

    var hasErrorClass = function (field) {
        return ctrl.signupForm[field].$touched && ctrl.signupForm[field].$invalid;
    };

    var showMessages = function (field) {
        return ctrl.signupForm[field].$touched || ctrl.signupForm.$submitted
    };



    ctrl.showEmailPrompt = false;
    ctrl.showUsernamePrompt = false;
    ctrl.showFirstNamePrompt = false;
    ctrl.showLastNamePrompt = false;
    ctrl.showSubmittedPrompt = false;
    ctrl.showDeletedPrompt = false;
    ctrl.toggleEmailPrompt = toggleEmailPrompt;
    ctrl.toggleUsernamePrompt = toggleUsernamePrompt;
    ctrl.toggleFirstNamePrompt = toggleFirstNamePrompt;
    ctrl.toggleLastNamePrompt = toggleLastNamePrompt;
    ctrl.getPasswordType = getPasswordType;
    ctrl.hasErrorClass = hasErrorClass;
    ctrl.showMessages = showMessages;
    ctrl.newCustomer = newCustomer;
    ctrl.signup = signup;
    ctrl.clearForm = clearForm;

    //Active User Count
    $http({
        method: 'GET',
        url: '/company/getCurrentUserCompany'
    })
        .success(function (data, status, headers, config) {
            ctrl.licensedUser = data.noOfLicensedUsers;
        })

    ctrl.usernameUniqueValidation = function (viewValue) {
        $http({
            method: 'GET',
            url: '/user/checkUsernameExist',
            params: {username: viewValue}
        })
            .success(function (data, status, headers, config) {

                if (data.length == 0) {
                    ctrl.signupForm.username.$setValidity('usernameExists', true);
                }
                else {
                    ctrl.signupForm.username.$setValidity('usernameExists', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.signupForm.username.$setValidity('usernameExists', false);
            });
    };

    ctrl.emailUniqueValidation = function (viewValue) {
        if (viewValue) {
            if(ctrl.newCustomer.email != ctrl.emailForEdit){
                $http({
                    method: 'GET',
                    url: '/user/checkEmailExist',
                    params: {email: viewValue}
                })
                    .success(function (data, status, headers, config) {

                        if (data.length == 0) {
                            ctrl.signupForm.email.$setValidity('emailExists', true);
                        }
                        else {
                            ctrl.signupForm.email.$setValidity('emailExists', false);
                        }

                    })
                    .error(function (data, status, headers, config) {
                        ctrl.signupForm.email.$setValidity('emailExists', false);
                    });
            }else{
                ctrl.signupForm.email.$setValidity('emailExists', true);
            }
        }
    };

///********* Billing*******


        var openBilling = function () {
            getCompanyBillingDetails();
            $('#billing').appendTo("body").modal('show');
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

        $('#billing').appendTo("body").modal('hide');
        

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

                //if(data.isTrial == false){
                //    ctrl.showBillingButton = true;
                //}
                //else{
                //    ctrl.showBillingButton = false;
                //}
                ctrl.showBillingButton = true;
                if(data.isTrial == true && addDays(new Date(data.trialDate), 5) < new Date()){
                    window.location.href = '/billing/index';
                }
                else if(data.isTrial == true && new Date(data.trialDate) < new Date()){
                    $('#warningTrialEndMessage').appendTo("body").modal('show');
                }


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
                else{
                    ctrl.viewTotalAmount = ctrl.currentCost + (20 * (ctrl.noOfUsers - 5))
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
            {name: 'Date', field: 'paymentDate', type: 'date', cellFilter: 'date:"MM/dd/yyyy"'},
            {name: 'Action', field: 'action'},
            {name: 'Description', field: 'description'},
            {name: 'Amount', field: 'amount', type: 'currency', cellFilter: 'currency'}

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
            url: '/billing/getCompanyPaymentHistory'
        })

            .success(function (data, status, headers, config) {
                $scope.gridHistory.data = data;
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
                    card: token.id
                },
                dataType: 'json',
                headers: {'Content-Type': 'application/json; charset=utf-8'}
            })
                .success(function (data, status, headers, config) {

                    getCompanyBillingDetails();

                    $('#upgradeStandard').appendTo("body").modal('hide');
                    $('#upgradePremium').appendTo("body").modal('hide');
                    $('#upgrade').appendTo("body").modal('hide');
                    $('#billing').appendTo("body").modal('show');
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
                    card: token.id
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

        //alert(ctrl.planDetails);
        //alert(ctrl.viewTotalAmount);
        //alert(ctrl.nextPayment);
        //alert("ctrl.noOfUsers:" + ctrl.noOfUsers);
        //alert("ctrl.NoOfUsers:" + ctrl.NoOfUsers);


        //$http({
        //    method: 'GET',
        //    url: '/billing/getPreviousDetails',
        //    data: {plan: ctrl.planDetails, nexChargeAmount: ctrl.viewTotalAmount, nexChargeDate: ctrl.nextPayment},
        //    dataType: 'json',
        //    headers: {'Content-Type': 'application/json; charset=utf-8'}
        //})
        //
        //    .success(function (data, status, headers, config) {
        //
        //    })


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

    var redirectToBillingPage = function () {

        window.location.href = '/billing/index';
    };

    ctrl.upgradeCurrentPlanStandard = upgradeCurrentPlanStandard;
    ctrl.redirectToBillingPage = redirectToBillingPage;

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

    ///********* Support ******
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


}])

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

    .directive('usernameAvailable', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {

                ctrl.$parsers.push(function (viewValue) {
                    // set it to true here, otherwise it will not
                    // clear out when previous validators fail.

                    // set it to false here, because if we need to check
                    // the validity of the email, it's invalid until the
                    // AJAX responds.

                    $http({
                        method: 'GET',
                        url: '/user/checkUsernameExist',
                        params: {username: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if (data.length == 0) {
                                ctrl.$setValidity('usernameExists', true);
                            }
                            else {
                                ctrl.$setValidity('usernameExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('usernameExists', false);
                        });

                    return viewValue;
                });

            }
        };
    })

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
