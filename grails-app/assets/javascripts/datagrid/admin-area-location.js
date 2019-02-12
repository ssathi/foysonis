/**
 * Created by home on 9/10/15.
 */

var app = angular.module('adminArea', ['locationImportService', 'ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.grid.pagination', 'ui.grid.resizeColumns']);

app.controller('AreaCtrl', ['$scope', '$http', '$interval', '$q', '$timeout','locationImpService', function ($scope, $http, $interval, $q, $timeout, locationImpService) {

    var importLoc = null;

    var myEl = angular.element( document.querySelector( '#liAdmin' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulAdmin' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'Locations & Areas';

    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };


    //Get all area list
    var getAllAreas = function () {
        $http({
            method: 'GET',
            url: '/area/getAllAreas'
        })
            .success(function (data, status, headers, config) {
                var defaultArea = [{areaId: 'DEFAULT'}];
                ctrl.areaList = defaultArea.concat(data);
                ctrl.allAreas = defaultArea.concat(data);
            })
    };

    var getLocationBySelectedArea = function () {
        var selectedArea;
        $scope.IsVisibleArea = false;

        if(ctrl.selectedAreaId == "DEFAULT")
            selectedArea = null;
        else
            selectedArea = ctrl.selectedAreaId;

        $http({
            method: 'GET',
            url: '/location/getAllLocationsByArea',
            params: {areaId: selectedArea}
        })
            .success(function(data) {
                $scope.gridLocation.data = data;

            });
    };

    var getAreaDetails = function (){

        if(ctrl.selectedAreaId == "DEFAULT"){
            ctrl.selectedArea = null;
            ctrl.isShowDefaultAreaDetails = true;
            ctrl.isShowAreaDetails = false;
        }
        else{
            ctrl.isShowDefaultAreaDetails = false;
            ctrl.isShowAreaDetails = true;
        }


        $http({
            method: 'GET',
            url: '/area/getArea',
            params: {areaId: ctrl.selectedAreaId}
        })
            .success(function(data) {
                ctrl.selectedArea = data;

                if (ctrl.selectedArea.isStorage || ctrl.selectedArea.isProcessing){

                    $http({
                        method: 'GET',
                        url: '/area/getEntityAttributesByAreaId',
                        params: {areaId: ctrl.selectedAreaId}
                    })
                        .success(function(data) {
                            ctrl.selectedAreaEntityAttributes = data;
                        });
                }


            });

    };

    //Get all processing area list
    var getAllProcessingAreas = function () {
        $http({
            method: 'GET',
            url: '/area/getProcessingAreas'
        })
            .success(function (data, status, headers, config) {
                ctrl.processingAreas = data;
            })
    };

    var getAllProcessingAreasForEdit = function () {
        $http({
            method: 'GET',
            url: '/area/getProcessingAreas'
        })
            .success(function (data, status, headers, config) {
                ctrl.processingAreas = data;

                if(ctrl.editArea.selectedProcessingAreas.length > 0){
                    for (i = 0; i < ctrl.processingAreas.length; i++){
                        if (ctrl.processingAreas[i].areaId == ctrl.editArea.selectedProcessingAreas[0].configValue){

                            ctrl.editArea.nextProcessingArea = ctrl.processingAreas[i];
                            break;
                        }

                    }
                }


            })
    };

    //Get all Replenishment AreaId lists
    var getAllReplenishmentAreaIds = function () {
        $http({
            method: 'GET',
            url: '/area/getReplenishmentAreaIds',
            params: {pickedLevels: ctrl.newArea.pickedLevels}
        })
            .success(function (data, status, headers, config) {
                ctrl.replenishmentAreaValues = []
                for (i = 0; i < data.length; i++) {
                    ctrl.replenishmentAreaValues.push(data[i].areaId);
                }
            })
        if (ctrl.newArea.selectedReplenishmentAreas.length > 0){
            ctrl.resetReplenishmentArea = true;
            $timeout(function(){
                ctrl.resetReplenishmentArea = false;
            }, 1000);
        }

        ctrl.newArea.selectedReplenishmentAreas = [];

    };
    var getAllReplenishmentAreaIdsForEdit = function () {

        $http({
            method: 'GET',
            url: '/area/getReplenishmentAreaIds',
            params: {pickedLevels: ctrl.editArea.pickedLevels}
        })
            .success(function (data, status, headers, config) {

                ctrl.replenishmentAreaValuesEdit = []
                for (i = 0; i < data.length; i++) {
                    if(data[i].areaId != ctrl.selectedArea.areaId)
                        ctrl.replenishmentAreaValuesEdit.push(data[i].areaId);

                }

                for (i = 0; i < ctrl.editArea.selectedReplenishmentAreas.length; i++) {

                    for (j = 0; j < ctrl.replenishmentAreaValuesEdit.length; j++) {
                        if(ctrl.editArea.selectedReplenishmentAreas[i].configValue == ctrl.replenishmentAreaValuesEdit[j]){
                            ctrl.replenishmentAreaValuesEdit.splice(j, 1);
                        }
                    }

                }

            })

    };

    var resetReplenArea = function () {
        if (ctrl.editArea.selectedReplenishmentAreas.length > 0){
            ctrl.resetReplenishmentAreaEdit = true;
            $timeout(function(){
                ctrl.resetReplenishmentAreaEdit = false;
            }, 5000);
        }

        ctrl.editArea.selectedReplenishmentAreas = [];
    };

    //Get all Storage Restriction Option lists
    var getStorageRestrictionOptions = function () {
        $http({
            method: 'GET',
            url: '/listValue/getAllValuesByCompanyIdAndGroup',
            params: {group: 'STRG'}
        })
            .success(function (data, status, headers, config) {
                var addOption = [{optionValue: '+ Add New Attribute'}];
                ctrl.storageRestrictionOptions = data.concat(addOption);
            })
    };
    var getStorageRestrictionOptionsForEdit = function () {
        $http({
            method: 'GET',
            url: '/listValue/getAllValuesByCompanyIdAndGroup',
            params: {group: 'STRG'}
        })
            .success(function (data, status, headers, config) {
                var addOption = [{optionValue: '+ Add New Attribute'}];
                ctrl.storageRestrictionOptionsEdit = data.concat(addOption);
                //ctrl.storageRestrictionOptionsEdit = data;

                for (i = 0; i < ctrl.editArea.selectedStorageRestrictionOptions.length; i++) {

                    for (j = 0; j < ctrl.storageRestrictionOptionsEdit.length; j++) {
                        if(ctrl.editArea.selectedStorageRestrictionOptions[i].configValue == ctrl.storageRestrictionOptionsEdit[j].optionValue){
                            ctrl.storageRestrictionOptionsEdit.splice(j, 1);
                        }
                    }

                }

            })
    };
    var getPickingLevelsForEdit = function () {

        if (ctrl.selectedArea.isBin) {
            ctrl.pickingLevelOptionsEdit = ['EACH'];
        }
        else{
            ctrl.pickingLevelOptionsEdit = ['EACH', 'CASE', 'PALLET'];            
        }

        for (i = 0; i < ctrl.editArea.pickedLevels.length; i++) {

            for (j = 0; j < ctrl.pickingLevelOptionsEdit.length; j++) {
                if(ctrl.editArea.pickedLevels[i].configValue == ctrl.pickingLevelOptionsEdit[j]){
                    ctrl.pickingLevelOptionsEdit.splice(j, 1);
                }
            }

        }

        if(ctrl.editArea.pickedLevels.length == 0)
            ctrl.pickedLevelAlertTextEdit = true;
    };


    //Show Area Create Box
    $scope.IsVisibleArea = false;
    $scope.showCreateAreaForm = function () {
        $scope.IsVisibleArea = true;
        ctrl.showAreaSubmittedPrompt = false;
        ctrl.showAreaUpdatedPrompt = false;
        ctrl.showAreaDeletedPrompt = false;
        document.getElementById('locations').className = "tab-pane fade";
        document.getElementById('areas').className = "tab-pane fade in active";
        document.getElementById('lilocations').className = "";
        document.getElementById('liareas').className = "active";
        ctrl.selectedAreaId = null;
        ctrl.isShowAreaDetails = false;
        ctrl.isShowDefaultAreaDetails = false;
        ctrl.isShowEditAreaForm = false;

        ctrl.newArea.isStorage = false;
        ctrl.newArea.isPickable = false;
        ctrl.newArea.isProcessing = false;
        ctrl.newArea.isStaging = false;
        ctrl.newArea.isKitting = false;
        ctrl.newArea.isPnd = false;
        ctrl.newArea.isBin = false;
    }


    $scope.deleteArea = function () {

        if($scope.gridLocation.data.length > 0){
            $('#dvDeleteAreaWarning').appendTo("body").modal('show');
        }
        else{
            $('#dvDeleteArea').appendTo("body").modal('show');
        }
    }

    $("#areaDeleteButton").click(function(){ //function to delete.

        ctrl.selectedAreaForDelete = ctrl.selectedArea.areaId

        $http({
            method  : 'POST',
            url     : '/area/deleteArea',
            data    :  ctrl.selectedArea,
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }

        })
            .success(function (data, status, headers, config) {
                getAllAreas();
                ctrl.selectedArea = null;
                ctrl.selectedAreaId = 'DEFAULT';
                ctrl.isShowDefaultAreaDetails = true;
                ctrl.isShowAreaDetails = false;

                ctrl.showAreaDeletedPrompt = true;
                $timeout(function(){
                    ctrl.showAreaDeletedPrompt = false;
                }, 5000);
            });


        $('#dvDeleteArea').modal('hide');

    });


    $scope.showEditAreaForm = function () {
        ctrl.isShowAreaDetails = false;
        ctrl.showAreaSubmittedPrompt = false;
        ctrl.showAreaUpdatedPrompt = false;
        ctrl.showAreaDeletedPrompt = false;
        ctrl.isShowEditAreaForm = true;
        if (ctrl.selectedArea.isStorage){
            ctrl.editArea.selectedStorageRestrictionOptions = ctrl.selectedAreaEntityAttributes.filter(
                function (value) {
                    return (value['configGroup']=='STRG');
                }
            );
            getStorageRestrictionOptionsForEdit();

            ctrl.editArea.enteredMaxLoad = ctrl.selectedAreaEntityAttributes.filter(
                function (value) {
                    return (value['configGroup']=='MAXLOAD');
                }
            );
            if(ctrl.editArea.enteredMaxLoad!=""){
                ctrl.selectedArea.maximumLoad = ctrl.editArea.enteredMaxLoad[0].configValue;
            }
        }else {
            ctrl.editArea.selectedStorageRestrictionOptions = [];
        }
        if (ctrl.selectedArea.isPickable){
            ctrl.editArea.pickedLevels = ctrl.selectedAreaEntityAttributes.filter(
                function (value) {
                    return (value['configGroup']=='PICKLEVEL');
                }
            );
            getPickingLevelsForEdit();


            ctrl.editArea.selectedReplenishmentAreas = ctrl.selectedAreaEntityAttributes.filter(
                function (value) {
                    return (value['configGroup']=='RESERVEDAREA');
                }
            );

            getAllReplenishmentAreaIdsForEdit();

        }else{
            ctrl.editArea.pickedLevels = [];
            ctrl.editArea.selectedReplenishmentAreas = [];
        }


        if(ctrl.selectedArea.isProcessing && !ctrl.selectedArea.isStaging){

            ctrl.editArea.selectedProcessingAreas = ctrl.selectedAreaEntityAttributes.filter(
                function (value) {
                    return (value['configGroup']=='NXTPROCESSAREA');
                }
            );


            getAllProcessingAreasForEdit();

        }
        else{
            ctrl.editArea.selectedProcessingAreas = [];
        }


    }

    var clearAreaForm = function () {
        ctrl.newArea = { areaId:''}
        ctrl.createAreaForm.$setUntouched();
        ctrl.createAreaForm.$setPristine();
        ctrl.pickingLevelOptions = ['EACH', 'CASE', 'PALLET'];
        ctrl.newArea.pickedLevels = [];
        ctrl.newArea.selectedStorageRestrictionOptions = [];

        getStorageRestrictionOptions();

        getAllProcessingAreas();

        getAllReplenishmentAreaIds();

        ctrl.newArea.maximumLoad = 100;
    };

    var toggleAreaIdPrompt = function (value) {
        ctrl.showAreaIdPrompt = value;
    };

    var toggleAreaNamePrompt = function (value) {
        ctrl.showAreaNamePrompt = value;
    };

    var hasAreaErrorClass = function (field) {
        return ctrl.createAreaForm[field].$touched && ctrl.createAreaForm[field].$invalid;
    };
    var showAreaMessages = function (field) {
        return ctrl.createAreaForm[field].$touched || ctrl.createAreaForm.$submitted
    };
    var hasEditAreaErrorClass = function (field) {
        return ctrl.editAreaForm[field].$touched && ctrl.editAreaForm[field].$invalid;
    };
    var showEditAreaMessages = function (field) {
        return ctrl.editAreaForm[field].$touched || ctrl.editAreaForm.$submitted
    };
    var createArea = function () {
        if(ctrl.newArea.isPickable && ctrl.newArea.pickedLevels.length == 0)
            ctrl.createAreaForm.$valid = false;

        if( ctrl.createAreaForm.$valid) {

            $http({
                method  : 'POST',
                url     : '/area/saveArea',
                data    :  $scope.ctrl.newArea,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
            })
                .success(function(data) {


                    ctrl.showAreaSubmittedPrompt = true;

                    $scope.IsVisibleArea = false;
                    ctrl.isShowAreaDetails = true;
                    ctrl.selectedAreaId = ctrl.newArea.areaId;
                    getLocationBySelectedArea();
                    getAreaDetails();
                    getAllAreas();

                    $timeout(function(){
                        ctrl.showAreaSubmittedPrompt = false;
                    }, 5000);

                    clearAreaForm();



                })

        }
    };

    $scope.cancelCreateNewArea = function(){
        ctrl.newArea = { areaId:''}
        ctrl.createAreaForm.$setUntouched();
        ctrl.createAreaForm.$setPristine();
        ctrl.pickingLevelOptions = ['EACH', 'CASE', 'PALLET'];
        ctrl.newArea.pickedLevels = [];
        ctrl.newArea.selectedStorageRestrictionOptions = [];

        getStorageRestrictionOptions();

        getAllProcessingAreas();

        //getAllReplenishmentAreaIds();

        ctrl.newArea.maximumLoad = 100;

        $scope.IsVisibleArea = false;
        ctrl.isShowDefaultAreaDetails = true;
        ctrl.selectedAreaId = 'DEFAULT';
        getLocationBySelectedArea();
    };

    var updateArea = function () {

        if(ctrl.selectedArea.isPickable && ctrl.editArea.pickedLevels.length == 0)
            ctrl.editAreaForm.$valid = false;


        if(ctrl.editAreaForm.$valid) {

            $scope.ctrl.editArea.areaId = ctrl.selectedArea.areaId;
            $scope.ctrl.editArea.companyId = ctrl.selectedArea.companyId;
            $scope.ctrl.editArea.areaName = ctrl.selectedArea.areaName;
            $scope.ctrl.editArea.isStorage = ctrl.selectedArea.isStorage;
            $scope.ctrl.editArea.isPickable = ctrl.selectedArea.isPickable;
            $scope.ctrl.editArea.isProcessing = ctrl.selectedArea.isProcessing;
            $scope.ctrl.editArea.isKitting = ctrl.selectedArea.isKitting;
            $scope.ctrl.editArea.isStaging = ctrl.selectedArea.isStaging;
            $scope.ctrl.editArea.isPnd = ctrl.selectedArea.isPnd;
            $scope.ctrl.editArea.isBin = ctrl.selectedArea.isBin;
            $scope.ctrl.editArea.maximumLoad = ctrl.selectedArea.maximumLoad;            

            if (ctrl.selectedArea.isBin) {

                $http({
                    method: 'GET',
                    url: '/area/checkLowestUOMCaseExistForArea',
                    params: {areaId: ctrl.selectedArea.areaId}
                })
                .success(function (data, status, headers, config) {
                    if (data.length > 0) {
                        $('#itemLowestUOMInCase').appendTo('body').modal('show');
                        ctrl.editArea.isBin = false;
                        ctrl.selectedArea.isBin = false;
                    }
                    else{
                        $http({
                            method: 'GET',
                            url: '/area/checkPalletAndCaseExistForArea',
                            params: {areaId: ctrl.selectedArea.areaId}
                        })
                        .success(function (data, status, headers, config) {
                            if (data.length > 0 ) {
                                $('#binAreaWarning').appendTo('body').modal('show');
                                ctrl.disableConfirmBinArea = false;
                                ctrl.confirmBinAreaBtnText = 'Confirm';
                            }
                            else{

                                $http({
                                    method  : 'POST',
                                    url     : '/area/updateArea',
                                    data    :  $scope.ctrl.editArea,
                                    dataType: 'json',
                                    headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                                })
                                    .success(function(data) {
                                        ctrl.showAreaUpdatedPrompt = true;

                                        $scope.IsVisibleArea = false;
                                        ctrl.isShowAreaDetails = true;
                                        ctrl.isShowEditAreaForm = false;
                                        getLocationBySelectedArea();
                                        getAreaDetails();
                                        getAllAreas();

                                        $timeout(function(){
                                            ctrl.showAreaUpdatedPrompt = false;
                                        }, 5000);

                                        clearAreaForm();

                                    })
                            }
                        })
                    }

                })               
            }
            else{
                $http({
                    method  : 'POST',
                    url     : '/area/updateArea',
                    data    :  $scope.ctrl.editArea,
                    dataType: 'json',
                    headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
                })
                    .success(function(data) {
                        ctrl.showAreaUpdatedPrompt = true;

                        $scope.IsVisibleArea = false;
                        ctrl.isShowAreaDetails = true;
                        ctrl.isShowEditAreaForm = false;
                        getLocationBySelectedArea();
                        getAreaDetails();
                        getAllAreas();

                        $timeout(function(){
                            ctrl.showAreaUpdatedPrompt = false;
                        }, 5000);

                        clearAreaForm();

                    })                
            }

        }

    };

    var changeAreaToBin = function(){

        ctrl.disableConfirmBinArea = true;
        ctrl.confirmBinAreaBtnText = 'Confirming....';

        $http({
            method  : 'POST',
            url     : '/area/updateBinArea',
            data    :  $scope.ctrl.editArea,
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }  // set the headers so angular passing info as form data (not request payload)
        })
            .success(function(data) {
                ctrl.showAreaUpdatedPrompt = true;

                $scope.IsVisibleArea = false;
                ctrl.isShowAreaDetails = true;
                ctrl.isShowEditAreaForm = false;
                getLocationBySelectedArea();
                getAreaDetails();
                getAllAreas();

                $timeout(function(){
                    ctrl.showAreaUpdatedPrompt = false;
                }, 5000);

                clearAreaForm();

            })
            .finally(function () {
                ctrl.disableConfirmBinArea = false;
                ctrl.confirmBinAreaBtnText = 'Confirm';
                $('#binAreaWarning').appendTo('body').modal('hide');
            });
    };

    var ctrl = this,
        newCustomer = { firstName:'', lastName:'', email:'', username:'', password:''},
        newArea = { areaId:'', areaName:'', isStorage:false, isPickable:false, isProcessing:false, isStaging:false, isPnd:false, isBin:false, nextProcessingArea:'', maximumLoad:'', pickedLevels:[], selectedStorageRestrictionOptions:[], selectedReplenishmentAreas:[]},
        editArea = {areaName:'', isStorage:false, isPickable:false, isProcessing:false, isStaging:false, isPnd:false, selectedStorageRestrictionOptions:[]};

    getAllAreas();
    ctrl.showAreaIdPrompt = false;
    ctrl.toggleAreaIdPrompt = toggleAreaIdPrompt;
    ctrl.toggleAreaNamePrompt = toggleAreaNamePrompt;
    ctrl.hasAreaErrorClass = hasAreaErrorClass;
    ctrl.showAreaMessages = showAreaMessages;
    ctrl.newArea = newArea;
    ctrl.createArea = createArea;
    ctrl.clearAreaForm = clearAreaForm;
    ctrl.newArea.maximumLoad = 100;
    ctrl.pickingLevelOptions = ['EACH', 'CASE', 'PALLET'];
    ctrl.newArea.pickedLevels = [];
    ctrl.editArea = editArea;
    ctrl.updateArea = updateArea;
    ctrl.hasEditAreaErrorClass = hasEditAreaErrorClass;
    ctrl.showEditAreaMessages = showEditAreaMessages;
    ctrl.changeAreaToBin = changeAreaToBin;



    ctrl.toCapitalLetter = function(){
        ctrl.newArea.areaId = ctrl.newArea.areaId.toUpperCase().replace(/[^0-9A-Z-_ ]/g, "").replace(/ /gi, "");
    };

    ctrl.storageCheckBoxChange = function () {
        if(ctrl.newArea.isStorage){
            ctrl.newArea.isPnd = false;
            ctrl.newArea.isProcessing = false;
            ctrl.newArea.isStaging = false;
            ctrl.newArea.isKitting = false;
            ctrl.newArea.isPickable = false;
            ctrl.pickedLevelAlertText = true;
            getStorageRestrictionOptions();
            getAllReplenishmentAreaIds();
            if(ctrl.newArea.pickedLevels.length == 0)
                ctrl.pickedLevelAlertText = true;
            else
                ctrl.pickedLevelAlertText = false;
        }
        else{
            ctrl.newArea.isPickable = false;
            ctrl.newArea.isBin = false;
        }

    }

    ctrl.processingCheckBoxChange = function () {
        if(ctrl.newArea.isProcessing){
            ctrl.newArea.isPnd = false;
            ctrl.newArea.isStorage = false;
            ctrl.newArea.isStaging = false;
            ctrl.newArea.isKitting = false;
            ctrl.newArea.isPickable = false;
            ctrl.newArea.isBin = false;
            getAllProcessingAreas();
        }
        else{
            ctrl.newArea.isStaging = false;
            ctrl.newArea.isKitting = false;
        }

    }  

    ctrl.pndCheckBoxChange = function () {
        if(ctrl.newArea.isPnd){
            ctrl.newArea.isStorage = false;
            ctrl.newArea.isPickable = false;
            ctrl.newArea.isProcessing = false;
            ctrl.newArea.isStaging = false;
            ctrl.newArea.isKitting = false;
            ctrl.newArea.isBin = false;
        }

    }

    ctrl.binCheckBoxChange = function(){
        if(ctrl.newArea.isBin){
            ctrl.removePickedLevel('CASE');
            ctrl.removePickedLevel('PALLET');
            var index = ctrl.newArea.pickedLevels.indexOf('EACH');
            if (index === -1) {
              ctrl.pickingLevelOptions = ['EACH'];  
            }
            else{
              ctrl.pickingLevelOptions = [];
            }
            
        }
        else{
            var index = ctrl.newArea.pickedLevels.indexOf('EACH');
            if (index === -1) {
                ctrl.pickingLevelOptions = ['EACH', 'CASE', 'PALLET'];
            }
            else{
                ctrl.pickingLevelOptions = ['CASE', 'PALLET'];
            }
            
        }
    }

    ctrl.selectPickingLevel = function(){
        var index = ctrl.pickingLevelOptions.indexOf(ctrl.newArea.pickingLevel);
        if(index >= 0){
            ctrl.newArea.pickedLevels.push(ctrl.newArea.pickingLevel);
            ctrl.pickingLevelOptions.splice(index, 1);
            ctrl.pickedLevelAlertText = false;
        }
        getAllReplenishmentAreaIds();
    };
    ctrl.removePickedLevel = function(item){
        var index = ctrl.newArea.pickedLevels.indexOf(item);
        if(index >= 0){
            ctrl.pickingLevelOptions.push(item);
            ctrl.newArea.pickedLevels.splice(index, 1);
        }
        if(ctrl.newArea.pickedLevels.length == 0)
            ctrl.pickedLevelAlertText = true;
        getAllReplenishmentAreaIds();
    };

    var findIndexOfArray = function(array, attr, value) {
        for(var i = 0; i < array.length; i += 1) {
            if(array[i][attr] === value) {
                return i;
            }
        }
        return -1;
    }

    ctrl.selectStorageRestrictionOptions = function(){

        if (ctrl.newArea.storageRestriction.optionValue != '+ Add New Attribute') {
            //var index = ctrl.storageRestrictionOptions.indexOf(ctrl.newArea.storageRestriction);
            var index = findIndexOfArray(ctrl.storageRestrictionOptions,'optionValue',ctrl.newArea.storageRestriction.optionValue);
            if(index >= 0){
                ctrl.newArea.selectedStorageRestrictionOptions.push(ctrl.newArea.storageRestriction);
                ctrl.storageRestrictionOptions.splice(index, 1);
                ctrl.selectedStorageRestrictionOptions = false;
            }
        }
    };
    ctrl.removeStorageRestrictionOptions = function(item){
        var index = ctrl.newArea.selectedStorageRestrictionOptions.indexOf(item);
        if(index >= 0){
            ctrl.storageRestrictionOptions.push(item);
            ctrl.newArea.selectedStorageRestrictionOptions.splice(index, 1);
        }
    };

    ctrl.selectReplenishmentArea = function(){
        var index = ctrl.replenishmentAreaValues.indexOf(ctrl.newArea.replenishmentArea);
        if(index >= 0){
            ctrl.newArea.selectedReplenishmentAreas.push(ctrl.newArea.replenishmentArea);
            ctrl.replenishmentAreaValues.splice(index, 1);
        }
    };
    ctrl.removeReplenishmentArea = function(item){
        var index = ctrl.newArea.selectedReplenishmentAreas.indexOf(item);
        if(index >= 0){
            ctrl.replenishmentAreaValues.push(item);
            ctrl.newArea.selectedReplenishmentAreas.splice(index, 1);
        }
    };

    ctrl.editStorageCheckBoxChange = function () {
        if(ctrl.selectedArea.isStorage){
            ctrl.selectedArea.isPnd = false;
            ctrl.selectedArea.isProcessing = false;
            ctrl.selectedArea.isStaging = false;
            ctrl.selectedArea.isKitting = false;

            getStorageRestrictionOptionsForEdit();
            getPickingLevelsForEdit();
            getAllReplenishmentAreaIdsForEdit();
            resetReplenArea();

            //ctrl.pickedLevelAlertText = true;
            //getStorageRestrictionOptions();
            //getAllReplenishmentAreaIds();
            //if(ctrl.newArea.pickedLevels.length == 0)
            //    ctrl.pickedLevelAlertText = true;
            //else
            //    ctrl.pickedLevelAlertText = false;

            //for (option in ctrl.selectedAreaEntityAttributes.)
            //ctrl.editArea.selectedStorageRestrictionOptions = ctrl.selectedAreaEntityAttributes.filter('configGroup'=='STRG');

        }
        else
            ctrl.selectedArea.isPickable = false;
            ctrl.selectedArea.isBin = false;
    }

    ctrl.editPickableCheckBoxChange = function () {
        if(ctrl.selectedArea.isPickable){

            getPickingLevelsForEdit();
            getAllReplenishmentAreaIdsForEdit();
            resetReplenArea();
        }
    }

    ctrl.editProcessingCheckBoxChange = function () {
        if(ctrl.selectedArea.isProcessing){
            ctrl.selectedArea.isPnd = false
            ctrl.selectedArea.isStorage = false
            ctrl.selectedArea.isPickable = false;
            ctrl.selectedArea.isBin = false;
            getAllProcessingAreasForEdit();
        }
        else{
            ctrl.selectedArea.isStaging = false;
            ctrl.selectedArea.isKitting = false;
        }

    }

    ctrl.editPndCheckBoxChange = function () {
        if(ctrl.selectedArea.isPnd){
            ctrl.selectedArea.isStorage = false;
            ctrl.selectedArea.isPickable = false;
            ctrl.selectedArea.isProcessing = false;
            ctrl.selectedArea.isStaging = false;
            ctrl.selectedArea.isKitting = false;
            ctrl.selectedArea.isBin = false;
        }

    }

    ctrl.editBinCheckBoxChange = function(){
        if(ctrl.selectedArea.isBin){
            // ctrl.removePickedLevelEdit('CASE');
            // ctrl.removePickedLevelEdit('PALLET');

            var index = findIndexOfArray(ctrl.editArea.pickedLevels, 'configValue', 'CASE'); 
            if(index >= 0){
                //ctrl.pickingLevelOptionsEdit.push(item.configValue);
                ctrl.editArea.pickedLevels.splice(index, 1);
            }
            var index2 = findIndexOfArray(ctrl.editArea.pickedLevels, 'configValue', 'PALLET');            
            if(index2 >= 0){
                //ctrl.pickingLevelOptionsEdit.push(item.configValue);
                ctrl.editArea.pickedLevels.splice(index2, 1);
            }

            if(ctrl.editArea.pickedLevels.length == 0)
                ctrl.pickedLevelAlertTextEdit = true;
            getAllReplenishmentAreaIdsForEdit();
            resetReplenArea();


            var index = findIndexOfArray(ctrl.editArea.pickedLevels, 'configValue', 'EACH');
            if (index === -1) {
                
              ctrl.pickingLevelOptionsEdit = ['EACH'];  
            }
            else{
              ctrl.pickingLevelOptionsEdit = [];
            }
            
        }
        else{
            var index = findIndexOfArray(ctrl.editArea.pickedLevels, 'configValue', 'EACH');
            if (index === -1) {
                ctrl.pickingLevelOptionsEdit = ['EACH', 'CASE', 'PALLET'];
            }
            else{
                ctrl.pickingLevelOptionsEdit = ['CASE', 'PALLET'];
            }
            
        }
    }    

    ctrl.removeStorageRestrictionOptionsEdit = function(item){
        var index = ctrl.editArea.selectedStorageRestrictionOptions.indexOf(item);
        if(index >= 0){
            ctrl.storageRestrictionOptionsEdit.push({optionValue: item.configValue});
            ctrl.editArea.selectedStorageRestrictionOptions.splice(index, 1);
        }
    };
    ctrl.selectStorageRestrictionOptionsEdit = function(){

        if (ctrl.editArea.storageRestriction.optionValue != '+ Add New Attribute') {

            //var index = ctrl.storageRestrictionOptionsEdit.indexOf(ctrl.editArea.storageRestriction);
            var index = findIndexOfArray(ctrl.storageRestrictionOptionsEdit,'optionValue',ctrl.editArea.storageRestriction.optionValue);

            if(index >= 0){
                ctrl.editArea.selectedStorageRestrictionOptions.push({configValue: ctrl.editArea.storageRestriction.optionValue});
                ctrl.storageRestrictionOptionsEdit.splice(index, 1);
            }
        }
    };

    ctrl.removePickedLevelEdit = function(item){
        var index = ctrl.editArea.pickedLevels.indexOf(item);
        if(index >= 0){
            ctrl.pickingLevelOptionsEdit.push(item.configValue);
            ctrl.editArea.pickedLevels.splice(index, 1);
        }
        if(ctrl.editArea.pickedLevels.length == 0)
            ctrl.pickedLevelAlertTextEdit = true;
        getAllReplenishmentAreaIdsForEdit();
        resetReplenArea();

    };

    ctrl.selectPickingLevelEdit = function(){
        var index = ctrl.pickingLevelOptionsEdit.indexOf(ctrl.editArea.pickingLevel);
        if(index >= 0){
            ctrl.editArea.pickedLevels.push({configValue: ctrl.editArea.pickingLevel});
            ctrl.pickingLevelOptionsEdit.splice(index, 1);
            ctrl.pickedLevelAlertTextEdit = false;
        }
        getAllReplenishmentAreaIdsForEdit();
        resetReplenArea();

    };

    ctrl.removeReplenishmentAreaEdit = function(item){
        var index = ctrl.editArea.selectedReplenishmentAreas.indexOf(item);
        if(index >= 0){
            ctrl.replenishmentAreaValuesEdit.push(item.configValue);
            ctrl.editArea.selectedReplenishmentAreas.splice(index, 1);
        }
    };

    ctrl.selectReplenishmentAreaEdit = function(){
        var index = ctrl.replenishmentAreaValuesEdit.indexOf(ctrl.editArea.replenishmentArea);
        if(index >= 0){
            ctrl.editArea.selectedReplenishmentAreas.push({configValue:ctrl.editArea.replenishmentArea});
            ctrl.replenishmentAreaValuesEdit.splice(index, 1);
        }
    };





// function to create new Storage attribute

    ctrl.addNewAttribute = function(){ // dispalys the model

        if (ctrl.newArea.storageRestriction.optionValue == '+ Add New Attribute') {
            $('#addNewAttribute').appendTo("body").modal('show');
        }
        ctrl.newArea.storageRestriction = '';

    };

    ctrl.addNewAttributeEdit = function(){ // dispalys the model

        if (ctrl.editArea.storageRestriction.optionValue == '+ Add New Attribute') {
            $('#addNewAttributeEdit').appendTo("body").modal('show');
        }

    };


// function to save new item category
    $("#strgAttributeSave").click(function(){

        if (ctrl.addNewStrgAttribute) {
            $http({
                method  : 'POST',
                url     : '/area/addAttributeValue',
                data    :  {optionGroup:'STRG', optionValue:ctrl.addNewStrgAttribute},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.newArea.selectedStorageRestrictionOptions.push({optionValue: data.optionValue});
                    ctrl.addNewStrgAttribute ="";
                    ctrl.newArea.storageRestriction = '';
                    $('#addNewAttribute').modal('hide');

                })
        };
    });
    $("#strgAttributeSaveEdit").click(function(){

        if (ctrl.addNewStrgAttributeEdit) {
            $http({
                method  : 'POST',
                url     : '/area/addAttributeValue',
                data    :  {optionGroup:'STRG', optionValue:ctrl.addNewStrgAttributeEdit},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    ctrl.editArea.selectedStorageRestrictionOptions.push({configValue: data.optionValue});
                    ctrl.addNewStrgAttributeEdit ="";
                    ctrl.editArea.storageRestriction = '';
                    $('#addNewAttributeEdit').modal('hide');

                })
        };
    });




    $("#strgAttributeCancelSave").click(function(){
        ctrl.newArea.storageRestriction = '';
        ctrl.addNewStrgAttribute = '';
    });
// end of function to create new Storage attribute

//************start area search**************************

ctrl.searchArea = {}; 

var showHideSearch = function () {
    //clearFormOrder();
    ctrl.isAreaSearchVisible = ctrl.isAreaSearchVisible ? false : true;
};   

var areaSearch = function () {
    $http({
        method: 'GET',
        url: '/area/searchArea',
        params: {areaId:ctrl.searchArea.areaId, locationId:ctrl.searchArea.locationId}
    })
        .success(function (data) {

            if (data.length > 0) {

                if (!ctrl.searchArea.areaId && !ctrl.searchArea.locationId) {
                    var defaultArea = [{areaId: 'DEFAULT'}];
                    ctrl.areaList = defaultArea.concat(data);
                }
                else{
                    ctrl.areaList = data;
                }
                ctrl.isAreaSearchVisible = false;
                ctrl.selectedAreaId = ctrl.areaList[0].areaId;
                getLocationBySelectedArea();
                getAreaDetails();
                ctrl.isShowEditAreaForm = false;
                ctrl.showAreaSubmittedPrompt = false;
                ctrl.showAreaUpdatedPrompt = false;
                ctrl.showAreaDeletedPrompt = false;
                $scope.IsVisible = false;

            }
            else{
                ctrl.areaList = [];
                $scope.gridLocation.data = [];
            }



            // ctrl.selectedOrderLineCount = []

            // if (ctrl.orderList.length == 0) {
            //     $scope.gridOrderLines.data = [];
            //     ctrl.shipmentLineDataByOrder = [];
            //     ctrl.orderData = null;
            //     ctrl.customerData = null;
            // }

            // else{

            //     ctrl.selectedOrderNumber = data[0].order_number
            //     getOrderLinesBySelectedOrderNum(ctrl.selectedOrderNumber);
            //     getCustomerBySelectedOrderNum(ctrl.selectedOrderNumber);
            //     getSelectedOrderDetails(ctrl.selectedOrderNumber);
            //     getAllShipmentsByOrder(ctrl.selectedOrderNumber);

            // }

        })

};
ctrl.showHideSearch = showHideSearch;
ctrl.areaSearch = areaSearch;

    var loadGridData = function (){
        $http({
            method: 'POST',
            url: '/area/searchArea',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridLocation.data = data.splice(0,10000);

            })
    };
    loadGridData();


// end of area search

    //************Location displaying and delete**************************

    $scope.checkLocationBlockStatus = function(row){
        if (row.entity.isBlocked == true) {
            return true
        }
        else{
            return false
        }

    };

    var getRows;
    $scope.BlockLocation = function(row){
        getRows = row;
        ctrl.blockForLocation = getRows.entity.locationId;
        if (row.entity.isBlocked == true) {
            $('#locationUnBlock').appendTo("body").modal('show');

        }
        else{
            $('#locationBlock').appendTo("body").modal('show');
        }


    };

    $("#locationBlockButton").click(function(){

        $http({
            method  : 'POST',
            url     : '/location/blockLocation',
            data    :  {locationId: getRows.entity.locationId},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                $('#locationBlock').modal('hide');
                getLocationBySelectedArea();

                ctrl.showLocationBlockedPrompt = true;
                $timeout(function(){
                    ctrl.showLocationBlockedPrompt = false;
                }, 5000);
            })
    });


    $("#locationUnBlockButton").click(function(){
        $http({
            method  : 'POST',
            url     : '/location/unBlockLocation',
            data    :  {locationId: getRows.entity.locationId},
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                $('#locationUnBlock').modal('hide');
                getLocationBySelectedArea();

                ctrl.showLocationUnBlockedPrompt = true;
                $timeout(function(){
                    ctrl.showLocationUnBlockedPrompt = false;
                }, 5000);

            })
    });


    //get location by area
    ctrl.selectedAreaId = 'DEFAULT';
    getLocationBySelectedArea();
    ctrl.isShowDefaultAreaDetails = true;
    $scope.getClickedAreaId = function(clickedId){
        ctrl.selectedAreaId = clickedId;
        getLocationBySelectedArea();
        getAreaDetails();
        ctrl.isShowEditAreaForm = false;
        ctrl.showAreaSubmittedPrompt = false;
        ctrl.showAreaUpdatedPrompt = false;
        ctrl.showAreaDeletedPrompt = false;
        $scope.IsVisible = false;
    };




    //end of getLocation method



    //get all locations to the grid

    $scope.gridLocation = {
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: true,
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
        exporterPdfOrientation: 'portrait',
        exporterPdfPageSize: 'LETTER',
        exporterPdfMaxGridWidth: 500,

        columnDefs: [
            {name:'Id', field: 'locationId'},
            {name:'Barcode' , field: 'locationBarcode'},
            {name:'Travel Seq',field: 'travelSequence', cellClass: 'grid-align'},
            {name:'Is Blocked?',field: 'isBlocked', type: 'boolean', cellClass: 'grid-align', cellTemplate: '<div class="gridCheckbox c-checkbox"><input type="checkbox"  ng-model="row.entity.isBlocked" disabled ><span class="fa fa-check"></span></div class>', enableFiltering: false },
            { name: 'Actions', enableSorting: false, enableFiltering: false,  cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.Delete(row)">Delete</a></li>' +
            '<li ng-if="!grid.appScope.checkLocationBlockStatus(row)"><a href="javascript:void(0);" ng-click="grid.appScope.BlockLocation(row)">Block</a></li>' +
            '<li ng-if="grid.appScope.checkLocationBlockStatus(row)"><a href="javascript:void(0);" ng-click="grid.appScope.BlockLocation(row)">UnBlock</a></li></ul></div>'}

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
    };//end of the grid


    //The delete function of location
    var rows;
    $scope.Delete = function(row) { //calling bootstrap confirm box. 
        $http({
            method : 'GET',
            url : '/location/checkInventoryForLocation',
            params: {locationId: row.entity.locationId}
        })
        .success(function (data, status, headers, config) {
            if (data.length > 0) {
                $('#deleteLocationWarning').appendTo("body").modal('show');
            }
            else{
                $('#myModal').appendTo("body").modal('show');
            }

        });




        rows = row;

        //if (confirm("Are you sure want to delete this location?")) {

        // $http({
        //  method: 'POST',
        //  url: '/area/deleteLocation',
        //  data: {companyId: row.entity.companyId, locationId: row.entity.locationId},
        //  dataType: 'json',
        //  headers: {'Content-Type': 'application/json; charset=utf-8'}  // set the headers so angular passing //info as form data (not request payload)
        // })
        //     .success(function (data, status, headers, config) {
        //     });
        //  var index = $scope.gridLocation.data.indexOf(row.entity);
        //  $scope.gridLocation.data.splice(index, 1);
        // }

    };//end of calling bootstrap confirm box.


    $("#deleteButton").click(function(){ //function to delete.
        ctrl.deleteForLocation = rows.entity.locationId;
        $http({
            method: 'POST',
            url: '/location/deleteLocation',
            data: {companyId: rows.entity.companyId, locationId: rows.entity.locationId},
            dataType: 'json',
            headers: {'Content-Type': 'application/json; charset=utf-8'}  // set the headers so angular passing //info as form data (not request payload)
        })
            .success(function (data, status, headers, config) {
            });
        var index = $scope.gridLocation.data.indexOf(rows.entity);
        $scope.gridLocation.data.splice(index, 1);

        ctrl.showLocationDeletedPrompt = true;
        $timeout(function(){
            ctrl.showLocationDeletedPrompt = false;
        }, 5000);


        $('#myModal').modal('hide');

    });//end of the delete function

    //************END OF Location displaying and delete**********************************

    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };




  //********************start import location*********************
    ctrl.uploadCSV = false;

    $scope.gridOptions = {
        rowHeight:65,
        exporterMenuCsv: true,
        enableGridMenu: true,
        enableFiltering: false,
        gridMenuTitleFilter: fakeI18n,
        paginationPageSizes: [10, 50, 75],
        paginationPageSize: 10,
        columnDefs: [
            { name: 'Location Id', field: '0' },
            { name: 'Area Id', field: '1' },
            { name: 'Barcode', field: '2' },
            { name: 'Travel Sequence', field: '3' },
            { name: 'Block Status', field: '4' },
            { name: 'Error Message', field: '5', cellClass: 'grid-warning',cellTemplate:'<span style="color: red;">{{COL_FIELD}}</span>'}
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


    $scope.importLocation = function () {
        $('#importLocation').appendTo("body").modal('show');
        $scope.gridOptions.columnDefs;
        clearGrid();
    };


    function CSVToArray(strData, strDelimiter) {
        // Check to see if the delimiter is defined. If not,
        // then default to comma.
        strDelimiter = (strDelimiter || ",");
        // Create a regular expression to parse the CSV values.
        var objPattern = new RegExp((
            // Delimiters.
        "(\\" + strDelimiter + "|\\r?\\n|\\r|^)" +
            // Quoted fields.
        "(?:\"([^\"]*(?:\"\"[^\"]*)*)\"|" +
            // Standard fields.
        "([^\"\\" + strDelimiter + "\\r\\n]*))"), "gi");
        // Create an array to hold our data. Give the array
        // a default empty first row.
        var arrData = [[]];
        // Create an array to hold our individual pattern
        // matching groups.
        var arrMatches = null;
        // Keep looping over the regular expression matches
        // until we can no longer find a match.
        while (arrMatches = objPattern.exec(strData)) {
            // Get the delimiter that was found.
            var strMatchedDelimiter = arrMatches[1];
            // Check to see if the given delimiter has a length
            // (is not the start of string) and if it matches
            // field delimiter. If id does not, then we know
            // that this delimiter is a row delimiter.
            if (strMatchedDelimiter.length && (strMatchedDelimiter != strDelimiter)) {
                // Since we have reached a new row of data,
                // add an empty row to our data array.
                arrData.push([]);
            }
            // Now that we have our delimiter out of the way,
            // let's check to see which kind of value we
            // captured (quoted or unquoted).
            if (arrMatches[2]) {
                // We found a quoted value. When we capture
                // this value, unescape any double quotes.
                var strMatchedValue = arrMatches[2].replace(
                    new RegExp("\"\"", "g"), "\"");
            } else {
                // We found a non-quoted value.
                var strMatchedValue = arrMatches[3];
            }
            // Now that we have our value string, let's add
            // it to the data array.
            arrData[arrData.length - 1].push(strMatchedValue);
        }
        // Return the parsed data.

        return (arrData);
    }


    function CSV2JSON(csv) {
        // var array = CSVToArray(csv);

        var array = csv;
        //array.splice(0,1);

        var json = JSON.stringify(array);

        var str = json.replace(/},/g, "},\r\n");

        return str;
    }


    function validateHeader(csv){

        var errorMessage = "";

        //Remove header row
        var headerInfo = csv.splice(0,1);
        var headerColumns = JSON.stringify(headerInfo).replace(/},/g, "},\r\n").replace('[[','').replace(']]','').split('"').join('').split(",");
        var gridColumns = $scope.gridOptions.columnDefs;

        for (i = 0; i < (gridColumns.length-1); i++) {

            if(headerColumns[i] != gridColumns[i].name){
                errorMessage = errorMessage + "Header Column " + (i+1) + " : Name should be " + gridColumns[i].name + "\n" ;
            }
        }

        return errorMessage;
    }

    function processFile(jsonData){

        var gridRows = JSON.parse(jsonData);
        var errorMessageColumn = ($scope.gridOptions.columnDefs.length - 1);


        //Validate Uniqueness of Column
        for (i = 0; i < gridRows.length; i++) {

            for (j=0; j<i; j++){
                if (gridRows[i][0] == gridRows[j][0]){
                    gridRows[i][errorMessageColumn] = $scope.gridOptions.columnDefs[0].name + " is duplicated";
                    gridRows[j][errorMessageColumn] = $scope.gridOptions.columnDefs[0].name + " is duplicated";
                }

                if (gridRows[i][0] == gridRows[j][2] || gridRows[j][0] == gridRows[i][2] ){
                    gridRows[i][errorMessageColumn] = $scope.gridOptions.columnDefs[2].name + " is undefined";
                    //gridRows[j][errorMessageColumn] = $scope.gridOptions.columnDefs[2].name + " is undefined";
                }
            }

        }

        return gridRows;

    }

    function validateRows(gridRows){

        var errorMessageColumn = ($scope.gridOptions.columnDefs.length - 1);

        //Validate Area

        var arr = [];
        for (i = 0; i < gridRows.length; i++) {
            arr.push(locationImpService.checkAreaIdExist(gridRows[i][1]));
        }
        $q.all(arr).then(function (response) {

            for (i = 0; i < gridRows.length; i++) {
                if(response[i].length == 0){

                    var message = $scope.gridOptions.columnDefs[1].name + " : " + gridRows[i][1] + " does not exist for your company";
                    gridRows[i][errorMessageColumn] = gridRows[i][errorMessageColumn]  ? gridRows[i][errorMessageColumn] + ", " + message : message;

                    ctrl.uploadCSV = false;
                }

            }


        });


        //Validate Location
        var arr = [];
        for (i = 0; i < gridRows.length; i++) {
            arr.push(locationImpService.checkLocationIdExist(gridRows[i][0]));
        }
        $q.all(arr).then(function (response) {

            for (i = 0; i < gridRows.length; i++) {
                if(response[i].length > 0){
                    var message = $scope.gridOptions.columnDefs[0].name + " : " + gridRows[i][0] + " is already exists";
                    gridRows[i][errorMessageColumn] = gridRows[i][errorMessageColumn]  ? gridRows[i][errorMessageColumn] + ", " + message : message;

                    ctrl.uploadCSV = false;
                }
            }

        });



        //Validate barcode
        var arr = [];
        for (i = 0; i < gridRows.length; i++) {
            arr.push(locationImpService.checkBarcodeExist(gridRows[i][2]));
        }
        $q.all(arr).then(function (response) {

            for (i = 0; i < gridRows.length; i++) {
                if(response[i].length > 0){
                    //var message = $scope.gridOptions.columnDefs[0].name + " : " + gridRows[i][0] + " is already exists";
                    //gridRows[i][errorMessageColumn] = gridRows[i][errorMessageColumn]  ? gridRows[i][errorMessageColumn] + ", " + message : message;

                    var message = $scope.gridOptions.columnDefs[2].name + " : " + gridRows[i][2] + " is already exists";
                    gridRows[i][errorMessageColumn] = gridRows[i][errorMessageColumn]  ? gridRows[i][errorMessageColumn] + ", " + message : message;

                    ctrl.uploadCSV = false;
                }
            }

        });

        return gridRows;

    }



    var handleFileSelect=function(changeEvent) {
        importLoc = null;
        var files = changeEvent.target.files;
        if (files.length) {

            var r = new FileReader();
            r.onload = function(e) {

                var contents = e.target.result;

                var array = CSVToArray(contents);

                var headerValidationError = validateHeader(array);

                if(headerValidationError != ""){
                    alert(headerValidationError);
                }
                else
                {

                    var jsonData = CSV2JSON(array);

                    var gridData = processFile(jsonData);

                    gridData = validateRows(gridData);

                    $scope.gridOptions.data = gridData;

                    importLoc = gridData;

                    ctrl.uploadCSV = true;

                    //$http.get('/user/getCompanyUsersWithFullName')
                    //    .success(function(data) {
                    //        //$scope.gridOptions.data = JSON.parse(jsonData);
                    //        $scope.gridOptions.data = gridData;
                    //    });
                }

            };

            r.readAsText(files[0]);

        }
    };

    angular.element(document.querySelector('#csvImport')).on('change',handleFileSelect);


    //import csv
    $("#importCSVButton").click(function(){
        //alert(importLoc);
        $scope.loadAnimPickListSearch = true;

        $http({
            method  : 'POST',
            url     : '/location/importLocation',
            data: importLoc,
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                if (data.status == 'error') {
                    // $('#importLocation').modal('hide');
                    // ctrl.uploadCSV = false; 
                    ctrl.errorMsgForLocationCreate = data.message;
                    $('#dvPreventAddLocation').appendTo("body").modal('show');                   
                }
                else{
                    $('#importLocation').modal('hide');
                    ctrl.uploadCSV = false;

                    ctrl.showImportLocationSubmittedPrompt = true;
                    $timeout(function () {
                        ctrl.showImportLocationSubmittedPrompt = false;
                    }, 5000);
                }
            })

            .finally(function () {
                $scope.loadAnimPickListSearch = false;
            });

    });

    //


    //*************end import location*******************************


//***********start location create****************************

    $scope.IsVisible = false;
    $scope.ShowHide = function () {
        clearForm();
        $scope.IsVisible = $scope.IsVisible ? false : true;
        ctrl.editViewMessage = false;
    };

    $scope.cancelEditArea = function () {
        ctrl.isShowEditAreaForm = false;
        ctrl.isShowAreaDetails = true;
        $scope.getClickedAreaId(ctrl.selectedAreaId);
    };

    var ctrl = this,
        newLocation = { locationId:'', locationBarcode:'', travelSequence:'', isBlocked:'' };

    var createLocation = function () {
        ctrl.createForLocation = ctrl.newLocation.locationId;

        if( ctrl.createLocationForm.$valid) {

            var choosenAreaId = ctrl.selectedAreaId;
            if (ctrl.selectedAreaId =='DEFAULT') {
                choosenAreaId = null;
            };



           $http({
                method : 'GET',
                url : '/location/checkLocationBarcodeExist',
                params: {locationBarcode: ctrl.newLocation.locationBarcode, locationId:ctrl.newLocation.locationId}
                //params: {locationBarcode: viewValue, locationId:locationBarcodecheck }
            })
                .success(function (data, status, headers, config) {

                    if(data.length == 0){

                        $http({
                            method  : 'POST',
                            url     : '/location/save',
                            data    :  {locationId:ctrl.newLocation.locationId, areaId:ctrl.selectedAreaId, locationBarcode:ctrl.newLocation.locationBarcode, travelSequence:ctrl.newLocation.travelSequence,isBlocked:ctrl.newLocation.isBlocked},
                            dataType: 'json',
                            headers : { 'Content-Type': 'application/json; charset=utf-8' }
                        })
                            .success(function(data) {
                                if (data.status == 'error') {
                                    clearForm();
                                    ctrl.errorMsgForLocationCreate = data.message;
                                    $('#dvPreventAddLocation').appendTo("body").modal('show');
                                    $scope.IsVisible = false;
                                }
                                else{
                                    $scope.IsVisible = false;
                                    $http({
                                        method: 'GET',
                                        url: '/location/getAllLocationsByArea',
                                        params: {areaId: choosenAreaId}
                                    })
                                        .success(function(data) {
                                            //ctrl.selectedAreaId = choosenAreaId;

                                            if(ctrl.editViewMessage != true) {
                                                ctrl.showLocationSubmittedPrompt = true;
                                                $timeout(function () {
                                                    ctrl.showLocationSubmittedPrompt = false;
                                                }, 5000);

                                            }

                                            if(ctrl.editViewMessage == true) {
                                                ctrl.showLocationUpdatedPrompt = true;
                                                $timeout(function(){
                                                    ctrl.showLocationUpdatedPrompt = false;
                                                }, 5000);
                                            }

                                            $scope.gridLocation.data = data;
                                        });

                                    clearForm();
                                    getAllAreas();

                                }
                            })

                    }
                    else
                    {
                        ctrl.createLocationForm.locationBarcode.$setValidity('locationBarcodeExists', false);
                    }

                })
                .error(function (data, status, headers, config) {
                    ctrl.createLocationForm.locationBarcode.$setValidity('locationBarcodeExists', false);
                });
        }
    };


    var clearForm = function () {
        ctrl.newLocation = { locationId:'', locationBarcode:'', travelSequence:'', isBlocked:'' };
        ctrl.createLocationForm.$setUntouched();
        ctrl.createLocationForm.$setPristine();
    };

    var clearGrid = function () {
        angular.element(document.querySelector('#csvImport')).val(null);
        $scope.gridOptions.data = [];
        ctrl.uploadCSV = false;
    };


    var hasErrorClass = function (field) {
        return ctrl.createLocationForm[field].$touched && ctrl.createLocationForm[field].$invalid;
    };

    var showMessages = function (field) {
        return ctrl.createLocationForm[field].$touched || ctrl.createLocationForm.$submitted
    };

    var toggleLocationIdPrompt = function (value) {
        ctrl.showLocationIdPrompt = value;
    };
    var toggleAreaIdPrompt = function (value) {
        ctrl.showAreaIdPrompt = value;
    };
    var toggleLocationBarcodePrompt = function (value) {
        ctrl.showLocationBarcodePrompt = value;
    };
    var toggleTravelSequencePrompt = function (value) {
        ctrl.showTravelSequencePrompt = value;
    };
    var toggleIsBlockedPrompt = function (value) {
        ctrl.showIsBlockedPrompt = value;
    };

    ctrl.showLocationIdPrompt = false;
    ctrl.showAreaIdPrompt = false;
    ctrl.showLocationBarcodePrompt = false;
    ctrl.showTravelSequencePrompt = false;
    ctrl.showIsBlockedPrompt = false;

    ctrl.toggleLocationIdPrompt = toggleLocationIdPrompt;
    ctrl.toggleAreaIdPrompt = toggleAreaIdPrompt;
    ctrl.toggleLocationBarcodePrompt = toggleLocationBarcodePrompt;
    ctrl.toggleTravelSequencePrompt = toggleTravelSequencePrompt;
    ctrl.toggleIsBlockedPrompt = toggleIsBlockedPrompt;

    ctrl.showLocationSubmittedPrompt = false;
    ctrl.hasErrorClass = hasErrorClass;
    ctrl.showMessages = showMessages;
    ctrl.newLocation = newLocation;
    ctrl.createLocation = createLocation;
    ctrl.clearForm = clearForm;
    ctrl.clearGrid = clearGrid;

//***************end location create*************************************



    //*************start location edit function******************

    $scope.Edit = function(row) {
        //Check Current User
        $http.get('/user/getCurrentUser')
            .success(function(data) {

                $scope.IsVisible = true;
                ctrl.newLocation.locationId = row.entity.locationId;
                ctrl.newLocation.areaId = row.entity.areaId;
                ctrl.newLocation.locationBarcode = row.entity.locationBarcode;
                ctrl.newLocation.travelSequence = row.entity.travelSequence;
                ctrl.newLocation.isBlocked = row.entity.isBlocked;
                ctrl.newLocation.hiddenlocationId = row.entity.locationId;
                locationBarcodecheck = row.entity.locationId;

                ctrl.editViewMessage = true;


            });

    };
    //**********end location edit****************************
    ctrl.locationIdValidation = function(viewValue){
        $http({
            method : 'GET',
            url : '/location/checkLocationIdExist',
            params: {locationId: viewValue}
        })
        .success(function (data, status, headers, config) {

            if(data.length == 0){
                ctrl.createLocationForm.locationId.$setValidity('locationIdExists', true);
            }
            else
            {
                ctrl.createLocationForm.locationId.$setValidity('locationIdExists', false);
            }

        })
        .error(function (data, status, headers, config) {
            ctrl.createLocationForm.locationId.$setValidity('locationIdExists', false);
        });

        //ctrl.createLocationForm.locationId.$setValidity("locationIdExists", false);
    };

    ctrl.areaIdValidation = function(viewValue){
        $http({
            method : 'GET',
            url : '/area/checkAreaIdExist',
            params: {areaId: viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    ctrl.createAreaForm.areaId.$setValidity('areaIdExists', true);
                }
                else
                {
                    ctrl.createAreaForm.areaId.$setValidity('areaIdExists', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.createAreaForm.areaId.$setValidity('areaIdExists', false);
            });
    };

    ctrl.locationBarcodeValidation = function(viewValue, locationIdval){
        $http({
            method : 'GET',
            url : '/location/checkLocationBarcodeExist',
            params: {locationBarcode: viewValue, locationId:locationIdval}
            //params: {locationBarcode: viewValue, locationId:locationBarcodecheck }
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    ctrl.createLocationForm.locationBarcode.$setValidity('locationBarcodeExists', true);
                }
                else
                {
                    ctrl.createLocationForm.locationBarcode.$setValidity('locationBarcodeExists', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.createLocationForm.locationBarcode.$setValidity('locationBarcodeExists', false);
            });
    };

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

    .directive('areaIdAvailable', function ($http, $timeout) { // available
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
                        method : 'GET',
                        url : '/area/checkAreaIdExist',
                        params: {areaId: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('areaIdExists', true);
                            }
                            else
                            {
                                ctrl.$setValidity('areaIdExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('areaIdExists', false);
                        });

                    return viewValue;
                });

            }
        };
    })

    //.directive('upperCaseAndNumberOnly', function () {
    //    return {
    //        restrict: 'A',
    //        require: 'ngModel',
    //        link: function (scope, element, attr, ctrl) {
    //            function customValidator(ngModelValue) {
    //
    //                if (/[a-z\W+]/.test(ngModelValue)) {
    //                    ctrl.$setValidity('upperCaseNumberValidator', false);
    //                } else {
    //                    ctrl.$setValidity('upperCaseNumberValidator', true);
    //                }
    //                //
    //                //if (/[A-Z]/.test(ngModelValue)) {
    //                //    ctrl.$setValidity('uppercaseValidator', true);
    //                //} else {
    //                //    ctrl.$setValidity('uppercaseValidator', false);
    //                //}
    //                //if (/[0-9]/.test(ngModelValue)) {
    //                //    ctrl.$setValidity('numberValidator', true);
    //                //} else {
    //                //    ctrl.$setValidity('numberValidator', false);
    //                //}
    //                //if (ngModelValue.length === 6) {
    //                //    ctrl.$setValidity('sixCharactersValidator', true);
    //                //} else {
    //                //    ctrl.$setValidity('sixCharactersValidator', false);
    //                //}
    //                return ngModelValue;
    //            }
    //            ctrl.$parsers.push(customValidator);
    //        }
    //    };
    //})

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
//*****************start location validation******************************

    //location id validation(uppercase,numbers)
    .directive('validateLocationId', function () {
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
    .directive('validateLocationIdUnique', function ($http, $timeout) { // available
        return {
            require: 'ngModel',
            link: function (scope, elem, attr, ctrl) {




                ctrl.$parsers.push(function (viewValue) {
                    $http({
                        method : 'GET',
                        url : '/location/checkLocationIdExist',
                        params: {locationId: viewValue}
                    })
                        .success(function (data, status, headers, config) {

                            if(data.length == 0){
                                ctrl.$setValidity('locationIdExists', true);
                            }
                            else
                            {
                                ctrl.$setValidity('locationIdExists', false);
                            }

                        })
                        .error(function (data, status, headers, config) {
                            ctrl.$setValidity('locationIdExists', false);
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
                        params: {locationBarcode: viewValue}
                        //params: {locationBarcode: viewValue, locationId:locationBarcodecheck }
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


//location barcode unique(check to database)
    // .directive('validateLocationBarcodeWhenEdit', function ($http, $timeout) { // available
    //     return {
    //         require: 'ngModel',
    //         link: function (scope, elem, attr, ctrl) {

    //             ctrl.$parsers.push(function (viewValue) {

    //                 $http({
    //                     method : 'GET',
    //                     url : '/location/checkLocationBarcodeExistWhenEdit',
    //                     params: {locationBarcode: viewValue}
    //                 })
    //                     .success(function (data, status, headers, config) {

    //                         if(data.length == 0){
    //                             ctrl.$setValidity('locationBarcodeExists', true);
    //                         }

    //                         else if(data.locationBarcode == viewValue ){
    //                              ctrl.$setValidity('locationBarcodeExists', true);
    //                         }

    //                         else
    //                         {
    //                             ctrl.$setValidity('locationBarcodeExists', false);
    //                         }

    //                     })
    //                     .error(function (data, status, headers, config) {
    //                         ctrl.$setValidity('locationBarcodeExists', false);
    //                     });

    //                 return viewValue;
    //             });

    //         }
    //     };
    // })






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
;

//*****************end location validation*****************************

//app.directive('fileReader', function() {
//    return {
//        scope: {
//            fileReader:"="
//        },
//        link: function(scope, element) {
//            $(element).on('change', function(changeEvent) {
//                var files = changeEvent.target.files;
//                if (files.length) {
//                    var r = new FileReader();
//                    r.onload = function(e) {
//                        var contents = e.target.result;
//
//                        scope.$apply(function () {
//                            scope.fileReader = contents;
//                        });
//                    };
//
//                    r.readAsText(files[0]);
//
//                }
//            });
//        }
//    };
//});
