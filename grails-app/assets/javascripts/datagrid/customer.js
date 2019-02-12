/**
 * Created by User on 2015-12-10.
 */

var app = angular.module('customer', ['customerService', 'ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ui.grid.expandable', 'ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ngSanitize','ui.grid.pagination', 'ui.grid.autoResize', 'ui.grid.resizeColumns']);

app.controller('CustomerCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', 'cusService',  function ($scope, $http, $interval, $q, $timeout, cusService) {


    var myEl = angular.element( document.querySelector( '#liShipping' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulShipping' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'Customers';

//***********start Customer create****************************

    $scope.ShowHide = function () {
        $('#addCustomer').appendTo("body").modal('show');
        clearForm();
    };

    $scope.IsVisibleAddressForm = false;
    $scope.ShowHideAddressForm = function () {
        clearAddressForm();
        $scope.IsVisibleAddressForm = $scope.IsVisibleAddressForm ? false : true;
        ctrl.addressFormLabel = "Add New Shipping Address";
        $scope.IsVisibleAddressFormEdit = false;
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

    //same as shipping address checkbox
    var checkShippingAddress = function () {
        if(ctrl.shippingAddress){
            ctrl.newCustomer.shippingStreetAddress = '';
            ctrl.newCustomer.shippingCity = '';
            ctrl.newCustomer.shippingState = '';
            ctrl.newCustomer.shippingPostCode = '';
            ctrl.newCustomer.shippingCountry = '';
        }

    };

    var checkEditShippingAddress = function () {
        if(ctrl.editShippingAddress){
            ctrl.editCustomer.shippingStreetAddress = '';
            ctrl.editCustomer.shippingCity = '';
            ctrl.editCustomer.shippingState = '';
            ctrl.editCustomer.shippingPostCode = '';
            ctrl.editCustomer.shippingCountry = '';
        }

    };



    var ctrl = this,
        newCustomer = {contactName:'', companyName:'', phonePrimary:'',phoneAlternate:'', email:'', fax:'', isCustomerHold:'', notes:'', billingStreetAddress:'', billingCity:'',billingState:'', billingPostCode:'', billingCountry:'',shippingStreetAddress:'', shippingCity:'', shippingState:'', shippingPostCode:'', shippingCountry:''};

    var createCustomer = function () {

        if(ctrl.createCustomerForm.$valid) {

            if (ctrl.shippingAddress == true) {
                ctrl.newCustomer.sameAsBilling = true;
            }
            else{
                ctrl.newCustomer.sameAsBilling = false;
            }

            $http({
                method  : 'POST',
                url     : '/customer/customerSave',
                data    :  $scope.ctrl.newCustomer,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {

                    displayNewRecordAddedSuccessMessage();

                    $http.get('/customer/getCustomerByGrid')
                        .success(function(data) {

                            $scope.gridItem.data = data;
                            $('#addCustomer').appendTo("body").modal('hide');

                        });

                    ctrl.newCustomerForMessage = ctrl.newCustomer.contactName;

                    clearForm();
                })

        }
    };

    var clearForm = function () {
        ctrl.newCustomer = null;
        ctrl.createCustomerForm.$setUntouched();
        ctrl.createCustomerForm.$setPristine();

    };

    var clearAddressForm = function () {
        ctrl.newCustomerAddress = null;
    };

    var displayNewRecordAddedSuccessMessage = function () {
        ctrl.showSubmittedPrompt = true;
        $timeout(function(){
            ctrl.showSubmittedPrompt = false;
        }, 2000);
    };

    var displayRecordDeletedSuccessMessage = function () {
        ctrl.showDeletedPrompt = true;
        $timeout(function(){
            ctrl.showDeletedPrompt = false;
        }, 2000);
    };

    var displayRecordUpdatedSuccessMessage = function () {
        ctrl.showUpdatedPrompt = true;
        $timeout(function(){
            ctrl.showUpdatedPrompt = false;
        }, 2000);
    };

    var hasErrorClass = function (field) {
        return ctrl.createCustomerForm[field].$touched && ctrl.createCustomerForm[field].$invalid;
    };

    var showMessages = function (field) {
        return ctrl.createCustomerForm[field].$touched || ctrl.createCustomerForm.$submitted;
    };

    ctrl.hasErrorClass = hasErrorClass;
    ctrl.showMessages = showMessages;
    ctrl.newCustomer = newCustomer;
    ctrl.createCustomer = createCustomer;
    ctrl.clearForm = clearForm;
    ctrl.checkShippingAddress = checkShippingAddress;
    ctrl.shippingAddress = true;

    ctrl.checkEditShippingAddress = checkEditShippingAddress;
    ctrl.editShippingAddress = true;

//***************end Customer create*************************************

    //*************** Start of Find Customer ****************************

    //visible delete action button for admin
    var enableDelete = null;
    var checkAdminUserLoggedIn = function(){
        cusService.checkAdminUserLoggedIn().then(function(response) {
            enableDelete = response.adminActiveStatus;
        });
    };

    checkAdminUserLoggedIn();

    $scope.checkAdminActive = function(){
        if(enableDelete == null){
            checkAdminUserLoggedIn();
        }
        return enableDelete;
    };

    //Enable Find Button
    ctrl.disabledFind = true;
    var disableFindButton = function () {
        ctrl.disabledFind = ctrl.customerId ? false : true;
    };
    ctrl.disableFindButton = disableFindButton;


    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };

    //Find Customer
    var search = function () {
        if (ctrl.searchForm.$valid) {

            $http({
                method: 'POST',
                url: '/customer/customerSearch',
                params: {customerId:ctrl.customerId},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    $scope.gridItem.data = data;

                })
        }
    };
    ctrl.search = search;

    var loadGridData = function (){
        $http({
            method: 'POST',
            url: '/customer/customerSearch',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridItem.data = data.splice(0,10000);

            })
    };
    loadGridData();

    //Start Customer grid
    $scope.gridItem = {
        rowHeight: 120,
        enableRowSelection: true,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
        exporterPdfHeader: { text: headerTitle, style: 'headerStyle' },
        exporterPdfFooter: function ( currentPage, pageCount ) {
            return { text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle' };
        },
        exporterPdfCustomFormatter: function ( docDefinition ) {
            docDefinition.styles.headerStyle = { fontSize: 15, bold: true, margin: 20};
            //docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
            return docDefinition;
        },
        //exporterPdfOrientation: 'portrait',
        //exporterPdfPageSize: 'LETTER',
        //exporterPdfMaxGridWidth: 500,

        columnDefs: [
            {name:'Customer',
                cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto;"><b>{{row.entity.contact_name}}</b></br>{{row.entity.company_name}}</div class>'},
            {name:'Contact Details',
                cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto;">' +
                '<span ng-if="row.entity.phone_primary"><em class="fa fa-mobile"></em>   : {{row.entity.phone_primary}}</span></br>' +
                '<span ng-if="row.entity.phone_alternate"><em class="fa fa-phone"></em> : {{row.entity.phone_alternate}}</span></br>' +
                '<span ng-if="row.entity.fax"><em class="fa fa-fax"></em> : {{row.entity.fax}}</span></br>' +
                '<span ng-if="row.entity.email"><em class="fa fa-envelope"></em> : {{row.entity.email}}</span>' +
                '</div class>'},
            {name:'Billing Address',
                cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto;"><span ng-if="row.entity.billing_street_address">{{row.entity.billing_street_address}},</span></br><span ng-if="row.entity.billing_city">{{row.entity.billing_city}},</span></br><span ng-if="row.entity.billing_state">{{row.entity.billing_state}},</span></br><span ng-if="row.entity.billing_post_code">{{row.entity.billing_post_code}},</span></br><span ng-if="row.entity.billing_country">{{row.entity.billing_country}}.</span></div class>'},
            {name:'Shipping Address',
                cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto;"><span ng-if="row.entity.street_address">{{row.entity.street_address}},</span></br><span ng-if="row.entity.city">{{row.entity.city}},</span></br><span ng-if="row.entity.state">{{row.entity.state}},</span></br><span ng-if="row.entity.post_code">{{row.entity.post_code}},</span></br><span ng-if="row.entity.country">{{row.entity.country}}.</span></div class>'},
            {name:'Note', field: 'notes'},

            {name:'Hold', field: 'is_customer_hold', type: 'boolean',width:60,
                cellClass: 'grid-align',cellTemplate: '<div class="gridCheckbox c-checkbox"><input type="checkbox"  ng-model="row.entity.is_customer_hold" disabled><span class="fa fa-check"></span></div class>'},

            {name:'Actions', enableSorting: false,width:100,
                 cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li><li ng-if = "grid.appScope.checkAdminActive()" ><a href="javascript:void(0);" ng-click="grid.appScope.Delete(row)">Delete</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.showShippingAddress(row)">Shipping Address</a></li></ul></div class>'}

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
//End Customer grid


    //Start Customer Shipping Address grid
    $scope.gridShippingAddress = {
        enableRowSelection: true,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,

        exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
        exporterPdfHeader: { text: headerTitle, style: 'headerStyle' },
        exporterPdfFooter: function ( currentPage, pageCount ) {
            return { text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle' };
        },
        exporterPdfCustomFormatter: function ( docDefinition ) {
            docDefinition.styles.headerStyle = { fontSize: 15, bold: true, margin: 20};
            //docDefinition.styles.footerStyle = { fontSize: 10, bold: true };
            return docDefinition;
        },
        //exporterPdfOrientation: 'portrait',
        //exporterPdfPageSize: 'LETTER',
        //exporterPdfMaxGridWidth: 500,

        columnDefs: [
            {name:'Street Address', field: 'street_address'},
            {name:'City', field: 'city'},
            {name:'State', field: 'state'},
            {name:'Post Code', field: 'post_code'},
            {name:'Country', field: 'country'},
            {name:'Default', field: 'is_default', type: 'boolean',width:60,
                cellClass: 'grid-align',cellTemplate: '<div class="gridCheckbox c-checkbox"><input type="checkbox"  ng-model="row.entity.is_default" disabled><span class="fa fa-check"></span></div class>'},
            {name: 'Action', enableSorting: false, cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.shippingAddressEdit(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.shippingAddressDelete(row)">Delete</a></li><li ng-if="grid.appScope.checkDefaultShippingAddress(row)"><a href="javascript:void(0);" ng-click="grid.appScope.makeDefaultShippingAddress(row)">Make Default</a></li></div>'}

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

    //End Customer Shipping Address  grid

    //grid auto resize
    $scope.getTableHeight = function() {
        var rowHeight = 120; // your row height
        var headerHeight = 30; // your header height
        return {
            height: ($scope.gridItem.data.length * rowHeight + headerHeight) + "px"
        };

    };




    //*************** End of Find Customer ***************

    //*************start customer Delete function******************

    var rows;
    $scope.Delete = function(row) { //calling bootstrap confirm box.

        ctrl.deleteCustomerForMessage = row.entity.contact_name;

        $http({
            method: 'GET',
            url: '/customer/checkOrderExistForCustomer',
            params : {customerId:row.entity.customer_id}
        })
            .success(function (data, status, headers, config) {

                if (data.length > 0) {
                    $('#DeleteCustomerWarning').appendTo("body").modal('show');
                }
                else {
                    $('#DeleteCustomer').appendTo("body").modal('show');
                }

            });


        rows = row;
    };


    $("#deleteButton").click(function(){ //function to delete.
        $http({
            method: 'POST',
            url: '/customer/deleteCustomer',
            data: {customerId:rows.entity.customer_id},
            dataType: 'json',
            headers: {'Content-Type': 'application/json; charset=utf-8'}
        })
            .success(function (data, status, headers, config) {

                displayRecordDeletedSuccessMessage();

                var index = $scope.gridItem.data.indexOf(rows.entity);
                $scope.gridItem.data.splice(index, 1);
                $('#DeleteCustomer').modal('hide');

            });


    });

    //*************End customer Delete function******************

    //*************start customer shipping address function******************


    $scope.showShippingAddress = function(row) { //calling bootstrap confirm box.

        ctrl.viewShippingAddressGrid = true;
        clearAddressForm();
        ctrl.clearAddressFormEdit();
        $scope.IsVisibleAddressForm = false;

        $http({
            method  : 'GET',
            url     : '/customer/getCustomerShippingAddressWithShipment',
            params    :  {customerId: row.entity.customer_id}
        })
            .success(function (data, status, headers, config) {
                $('#CustomerShippingAddress').appendTo("body").modal('show');
                $scope.gridShippingAddress.data = data;
            })

        rows = row;
        ctrl.customerIdForShipping = row.entity.customer_id
    };


    $scope.createShippingAddress = function (){
        if( ctrl.addressForm.$valid) {
            $http({
                method  : 'POST',
                url     : '/customer/createCustomerShippingAddress',
                data    :  {customerId:ctrl.customerIdForShipping, streetAddress:ctrl.customerShippingStreetAddress, city:ctrl.customerShippingCity, state:ctrl.customerShippingState, postCode:ctrl.customerShippingPostCode, country:ctrl.customerShippingCountry},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
            .success(function(data) {
                $http({
                    method  : 'GET',
                    url     : '/customer/getCustomerShippingAddressWithShipment',
                    params    :  {customerId: ctrl.customerIdForShipping}
                })
                .success(function (data, status, headers, config) {
                    $('#CustomerShippingAddress').appendTo("body").modal('show');
                    $scope.gridShippingAddress.data = data;
                })
                $scope.IsVisibleAddressForm = false;
                ctrl.showShippingAddSavePrompt = true;
                $timeout(function(){
                    ctrl.showShippingAddSavePrompt = false;
                }, 3000);                
            });            
        }
    };


    $scope.IsVisibleAddressFormEdit = false;
    $scope.shippingAddressEdit = function(row){
        $scope.IsVisibleAddressForm = false;
        $http({
            method : 'GET',
            url : '/customer/checkIsCustomerAddressInUse',
            params : {shippingId: row.entity.id}
        })
        .success(function (data, status, headers, config) {
            if (data.length > 0) {
                $('#dvDeleteshippingAddWarning').appendTo("body").modal('show');
            }
            else{
                $scope.IsVisibleAddressFormEdit = true;
                ctrl.customerIdForShippingEdit = ctrl.customerIdForShipping;
                ctrl.customerShippingStreetAddressEdit = row.entity.street_address;
                ctrl.customerShippingCityEdit = row.entity.city;
                ctrl.customerShippingStateEdit = row.entity.state;
                ctrl.customerShippingPostCodeEdit = row.entity.post_code;
                ctrl.customerShippingCountryEdit = row.entity.country;
                ctrl.shippingIdEdit = row.entity.id;
            }
        })
    }


    $scope.makeDefaultShippingAddress = function(row){
        $scope.IsVisibleAddressForm = false;
        $scope.IsVisibleAddressFormEdit = false;
        $http({
            method : 'GET',
            url : '/customer/makeDefaultShippingAddress',
            params  :  {customerId:row.entity.customer_id, addressId:row.entity.id}
        })
            .success(function (data, status, headers, config) {
                $http({
                    method  : 'GET',
                    url     : '/customer/getCustomerShippingAddressWithShipment',
                    params    :  {customerId: row.entity.customer_id}
                })
                    .success(function (data, status, headers, config) {
                        $('#CustomerShippingAddress').appendTo("body").modal('show');
                        $scope.gridShippingAddress.data = data;
                    })
                ctrl.showMakeDefaultPrompt = true;
                $timeout(function(){
                    ctrl.showMakeDefaultPrompt = false;
                }, 3000);
            })
    }

    $scope.checkDefaultShippingAddress = function(row){
        if(row.entity.is_default == true){
            return false;
        }
        else{
            return true;
        }
    }

        $scope.updateShippingAddress = function(){
        if( ctrl.addressFormEdit.$valid) {
            $http({
                method  : 'POST',
                url     : '/customer/updateShippingAddress',
                data    :  {customerId:ctrl.customerIdForShippingEdit, streetAddress:ctrl.customerShippingStreetAddressEdit, city:ctrl.customerShippingCityEdit, state:ctrl.customerShippingStateEdit, postCode:ctrl.customerShippingPostCodeEdit, country:ctrl.customerShippingCountryEdit, shippingId:ctrl.shippingIdEdit},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
            .success(function(data) {
                $http({
                    method  : 'GET',
                    url     : '/customer/getCustomerShippingAddressWithShipment',
                    params    :  {customerId: ctrl.customerIdForShipping}
                })
                .success(function (data, status, headers, config) {
                    $('#CustomerShippingAddress').appendTo("body").modal('show');
                    $scope.gridShippingAddress.data = data;
                })
                $scope.IsVisibleAddressFormEdit = false;
                ctrl.showShippingAddUpdatePrompt = true;
                $timeout(function(){
                    ctrl.showShippingAddUpdatePrompt = false;
                }, 3000);                
            });   
        }       
    }

    $scope.shippingAddressDelete = function(row){

        if(row.entity.is_default == true){
            $('#dvDeleteDefaultAddressWarning').appendTo("body").modal('show');
        }
        else{

            $http({
                method : 'GET',
                url : '/customer/checkIsCustomerAddressInUse',
                params : {shippingId: row.entity.id}
            })
                .success(function (data, status, headers, config) {
                    if (data.length > 0) {
                        $('#dvDeleteshippingAddWarning').appendTo("body").modal('show');
                    }
                    else{
                        $('#dvDeleteShippingAdd').appendTo("body").modal('show');
                        ctrl.customerIdForShippingDelete = ctrl.customerIdForShipping;
                        ctrl.shippingIdForDelete = row.entity.id;
                    }
                });

        }
    };    

    $("#shippingAddDeleteButton").click(function(){
        $http({
            method  : 'GET',
            url     : '/customer/deleteShippingAddress',
            params  :  {customerId:ctrl.customerIdForShippingDelete, shippingId:ctrl.shippingIdForDelete}
        })
        .success(function(data) {
            $http({
                method  : 'GET',
                url     : '/customer/getCustomerShippingAddressWithShipment',
                params    :  {customerId: ctrl.customerIdForShipping}
            })
            .success(function (data, status, headers, config) {
                $('#CustomerShippingAddress').appendTo("body").modal('show');
                $scope.gridShippingAddress.data = data;
            })
            $('#dvDeleteShippingAdd').modal('hide'); 
            ctrl.showShippingAddDeletePrompt = true;
            $timeout(function(){
                ctrl.showShippingAddDeletePrompt = false;
            }, 3000);                
        }); 
    });

    ctrl.hasErrorClassShipping = function (field) {
        return ctrl.addressForm[field].$touched && ctrl.addressForm[field].$invalid;
    };

    ctrl.showMessagesShipping = function (field) {
        return ctrl.addressForm[field].$touched || ctrl.addressForm.$submitted;
    };

    ctrl.hasErrorClassShippingEdit = function (field) {
        return ctrl.addressFormEdit[field].$touched && ctrl.addressFormEdit[field].$invalid;
    };

    ctrl.showMessagesShippingEdit = function (field) {
        return ctrl.addressFormEdit[field].$touched || ctrl.addressFormEdit.$submitted;
    };

    ctrl.clearAddressFormEdit = function(){
        $scope.IsVisibleAddressFormEdit = false;
        ctrl.customerShippingStreetAddressEdit = "";
        ctrl.customerShippingCityEdit = "";
        ctrl.customerShippingStateEdit = "";
        ctrl.customerShippingPostCodeEdit = "";
        ctrl.customerShippingCountryEdit = "";
        ctrl.shippingIdEdit = "";        
    }


    //*************end customer shipping address function******************


    //*************start Customer edit function******************



    var ctrl = this,
        editCustomer = {contactName:'', companyName:'', phonePrimary:'',phoneAlternate:'', email:'', fax:'', isCustomerHold:'', notes:'', billingStreetAddress:'', billingCity:'',billingState:'', billingPostCode:'', billingCountry:'',shippingStreetAddress:'', shippingCity:'', shippingState:'', shippingPostCode:'', shippingCountry:''};

    $scope.Edit = function(row) {
        //Check Current User
        //$http.get('/user/getCurrentUser')
        //    .success(function(data) {

                $('#editCustomer').appendTo("body").modal('show');
                clearForm();
               // checkShippingAddress();

                ctrl.editCustomer.contactName = row.entity.contact_name;
                ctrl.editCustomer.companyName = row.entity.company_name;
                ctrl.editCustomer.phonePrimary = row.entity.phone_primary;
                ctrl.editCustomer.phoneAlternate = row.entity.phone_alternate;
                ctrl.editCustomer.email = row.entity.email;
                ctrl.editCustomer.fax = row.entity.fax;
                ctrl.editCustomer.isCustomerHold = row.entity.is_customer_hold;
                ctrl.editCustomer.notes = row.entity.notes;
                ctrl.editCustomer.billingStreetAddress = row.entity.billing_street_address;
                ctrl.editCustomer.billingCity = row.entity.billing_city;
                ctrl.editCustomer.billingState = row.entity.billing_state;
                ctrl.editCustomer.billingPostCode = row.entity.billing_post_code;
                ctrl.editCustomer.billingCountry = row.entity.billing_country;
                ctrl.editCustomer.shippingStreetAddress = row.entity.street_address;
                ctrl.editCustomer.shippingCity = row.entity.city;
                ctrl.editCustomer.shippingState = row.entity.state;
                ctrl.editCustomer.shippingPostCode = row.entity.post_code;
                ctrl.editCustomer.shippingCountry = row.entity.country;
                ctrl.editCustomer.customerId = row.entity.customer_id;

                ctrl.updateCustomerForMessage = row.entity.contact_name;


                if(ctrl.editCustomer.billingStreetAddress == ctrl.editCustomer.shippingStreetAddress &&
                    ctrl.editCustomer.billingCity == ctrl.editCustomer.shippingCity &&
                    ctrl.editCustomer.billingState == ctrl.editCustomer.shippingState &&
                    ctrl.editCustomer.billingPostCode == ctrl.editCustomer.shippingPostCode &&
                    ctrl.editCustomer.billingCountry == ctrl.editCustomer.shippingCountry)
                {
                    ctrl.editShippingAddress = true;
                    ctrl.editCustomer.shippingStreetAddress = '';
                    ctrl.editCustomer.shippingCity = '';
                    ctrl.editCustomer.shippingState = '';
                    ctrl.editCustomer.shippingPostCode = '';
                    ctrl.editCustomer.shippingCountry = '';
                }
                else{
                    ctrl.editShippingAddress = false
                }

            //});


    };


    var updateCustomer = function () {

        if (ctrl.editCustomer.isCustomerHold == '') {
            ctrl.editCustomer.isCustomerHold == false;
        }

        if (ctrl.editShippingAddress == true) {
            ctrl.editCustomer.sameAsBilling = true;
        }
        else{
            ctrl.editCustomer.sameAsBilling = false;
        }

        if( ctrl.editCustomerForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/customer/updateCustomer',
                data    :  $scope.ctrl.editCustomer,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }

            })
                .success(function (data, status, headers, config) {

                    $('#editCustomer').appendTo("body").modal('hide');

                    displayRecordUpdatedSuccessMessage();

                    search();

                });

        }
    };


    var hasErrorClassEdit = function (field) {
        return ctrl.editCustomerForm[field].$touched && ctrl.editCustomerForm[field].$invalid;
    };

    var showMessagesEdit = function (field) {
        return ctrl.editCustomerForm[field].$touched || ctrl.editCustomerForm.$submitted;
    };

    ctrl.updateCustomer = updateCustomer;
    ctrl.editCustomer = editCustomer;
    ctrl.hasErrorClassEdit = hasErrorClassEdit;
    ctrl.showMessagesEdit = showMessagesEdit;
    ctrl.editShippingAddress = true;

    //**********end customer edit***************************************

}])

    //*****************start item validation******************************

// phone no validation(numbers and special characters)
    .directive('phoneNumbers', function () {
        return {
            require: 'ngModel',
            link: function (scope, element, attr, ngModelCtrl) {
                function fromUser(text) {
                    if (text) {
                        var transformedInput = text.replace(/[^0-9,(,),+,-]/g, '');

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

//*****************end item validation*****************************

;
