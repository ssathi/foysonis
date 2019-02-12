/**
 * Created by home on 9/10/15.
 */

var app = angular.module('adminItem', ['itemImportService', 'ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ngAria', 'ngMessages', 'ngAnimate', 'ui.grid.pagination', 'ui.grid.expandable', 'ui.grid.resizeColumns', 'ui.bootstrap','ngImgCrop']);

app.controller('ItemCtrl', ['$scope', '$http', '$interval', '$q', '$timeout','itemImpService', '$sce', function ($scope, $http, $interval, $q, $timeout, itemImpService ,$sce) {

    var importItems = null;

    var myEl = angular.element( document.querySelector( '#liAdmin' ) );
    myEl.addClass('active');
    var subMenu = angular.element( document.querySelector( '#ulAdmin' ));
    subMenu.removeClass('out');
    subMenu.addClass('in');

    var headerTitle = 'Items';

    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };


    //Get all list valuES
    var getAllListValues = function () {
        $http({
            method: 'GET',
            url: '/item/getAllValuesByCompanyIdAndGroup',
            params : {group: 'ITEMCAT'}
        })
            .success(function (data, status, headers, config) {
                var noneOption = [{optionValue: ''}];
                ctrl.listValue = noneOption.concat(data);
            })
    };

    var getOriginCodes = function () {
        $http({
            method: 'GET',
            url: '/item/getOriginCodeForCountries',
        })
            .success(function (data, status, headers, config) {
                //var noneOption = [''];
                //ctrl.originCode = noneOption.concat(data);
                ctrl.originCode = data;
                ctrl.originCodesListOfCodes = [];
                for (var i=0; i < ctrl.originCode.length ; ++i) {
                    ctrl.originCodesListOfCodes.push(ctrl.originCode[i]['code']);
                }
            })
    };

    var getListValueStorageAttribute = function () {
        $http({
            method: 'GET',
            url: '/item/getAllValuesByCompanyIdAndGroup',
            params : {group: 'STRG'}
        })
            .success(function (data, status, headers, config) {

                var addOption = [{optionValue: '+ Add New Attribute'}];
                ctrl.storageOptions = data.concat(addOption);
                ctrl.storageAttrOptionValues = [];
                for (var i=0; i < ctrl.storageOptions.length ; ++i) {
                    ctrl.storageAttrOptionValues.push(ctrl.storageOptions[i]['optionValue']);
                }
                //ctrl.storageOptions = data;

                // for (i = 0; i < ctrl.newItem.storageAttributes.length; i++) {

                //     for (j = 0; j < ctrl.storageOptions.length; j++) {
                //         if(ctrl.newItem.storageAttributes[j] == ctrl.storageOptions[j]){
                //             ctrl.storageOptions.splice(j, 1);
                //         }
                //     }

                // }


            })
    };



//***********start Item create****************************

    $scope.IsVisible = false;
    $scope.ShowHide = function () {
        clearForm();
        clearFormEdit();
        $scope.IsVisible = $scope.IsVisible ? false : true;
        ctrl.editItemState = false;
        ctrl.showSubmittedPrompt = false;
        ctrl.showUpdatedPrompt = false;
        ctrl.itemSaveBtnText = 'Save';
        ctrl.selectedStorageAttr = [];
        ctrl.isStorageAtrributeExist = true;
    };

    var ctrl = this,
        newItem = { itemId:'', itemDescription:'', lowestUom:'each', isLotTracked:'',isExpired:'', isCaseTracked:'', originCode:'', eachesPerCase:'', casesPerPallet:'', upcCode:'', eanCode:'', itemCategory:'', itemImage:'',storageAttributes:[] };
    getAllListValues();
    getOriginCodes();
    ctrl.errorMsgForItemSave = null;

    var createItem = function () {


        ctrl.newItem.itemCategory = ctrl.newItemCategory;

        if (ctrl.newItem.itemCategory == '') {
            ctrl.newItem.itemCategory = null;
        }


        if (ctrl.newItem.originCode == '') {
            ctrl.newItem.originCode = null;
        }

        if( ctrl.createItemForm.$valid) {
            ctrl.disableItemSave = true;
            ctrl.itemSaveBtnText = 'Saving..';
            ctrl.newItem.itemImage = $scope.itemCroppedImage;

            $http({
                method  : 'POST',
                url     : '/item/save',
                data    :  $scope.ctrl.newItem,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    if (data.status == 'error') {
                        $scope.IsVisible = false;
                        clearForm();
                        ctrl.errorMsgForItemSave = data.message;
                        $('#dvPreventAddItem').appendTo("body").modal('show');
                    }
                    else{
                        $scope.gridItem.data = data.data;

                        ctrl.newItemForMessage = ctrl.newItem.itemId;

                        $scope.IsVisible = false;
                        ctrl.showSubmittedPrompt = true;
                        clearForm();

                        $timeout(function(){
                            ctrl.showSubmittedPrompt = false;
                        }, 5200);
                    }
                })
                 .finally(function () {
                  ctrl.disableItemSave = false;
                  ctrl.itemSaveBtnText = 'Save';
                }); 
        }
    };


    var clearForm = function () {
        $scope.itemImage = '';
        $scope.itemCroppedImage = '';
        ctrl.newItem = { itemId:'', itemDescription:'', lowestUom:'EACH', isLotTracked:'',isExpired:'', isCaseTracked:'', originCode:'', eachesPerCase:'', casesPerPallet:'', upcCode:'', eanCode:'', itemCategory:'', itemImage:''};
        ctrl.createItemForm.$setUntouched();
        ctrl.createItemForm.$setPristine();
        ctrl.newItem.storageAttributes = [];
        ctrl.newItemCategory = '';
        //ctrl.storageOptions = ['FROZEN', 'REFRIGERATED', 'CAGED','BULK','REGULAR']; 
        getListValueStorageAttribute();

    };

    var hasErrorClass = function (field) {
        return ctrl.createItemForm[field].$touched && ctrl.createItemForm[field].$invalid;
    };

    var showMessages = function (field) {
        return ctrl.createItemForm[field].$touched || ctrl.createItemForm.$submitted;
    };

    var toggleItemIdPrompt = function (value) {
        ctrl.showItemIdPrompt = value;
    };
    var toggleItemDescriptionPrompt = function (value) {
        ctrl.showItemDescriptionPrompt = value;
    };
    var toggleLowestUomPrompt = function (value) {
        ctrl.showLowestUomPrompt = value;
    };
    var toggleIsLotTrackedPrompt = function (value) {
        ctrl.showIsLotTrackedPrompt = value;
    };
    var toggleIsExpiredPrompt = function (value) {
        ctrl.showIsExpiredPrompt = value;
    };
    var toggleOriginCodePrompt = function (value) {
        ctrl.showOriginCodePrompt = value;
    };
    var toggleEachesPerCasePrompt = function (value) {
        ctrl.showEachesPerCasePrompt = value;
    };
    var toggleCasesPerPalletPrompt = function (value) {
        ctrl.showCasesPerPalletPrompt = value;
    };
    var toggleUpcCodePrompt = function (value) {
        ctrl.showUpcCodePrompt = value;
    };
    var toggleEanCodePrompt = function (value) {
        ctrl.showEanCodePrompt = value;
    };
    var toggleItemCategoryPrompt = function (value) {
        ctrl.showItemCategoryPrompt = value;
    };


    ctrl.showItemIdPrompt = false;
    ctrl.showItemDescriptionPrompt = false;
    ctrl.showLowestUomPrompt = false;
    ctrl.showIsLotTrackedPrompt = false;
    ctrl.showIsExpiredPrompt = false;
    ctrl.showOriginCodePrompt = false;
    ctrl.showEachesPerCasePrompt = false;
    ctrl.showCasesPerPalletPrompt = false;
    ctrl.showUpcCodePrompt = false;
    ctrl.showEanCodePrompt = false;
    ctrl.showItemCategoryPrompt = false;
    ctrl.showSubmittedPrompt = false;




    ctrl.toggleItemIdPrompt = toggleItemIdPrompt;
    ctrl.toggleItemDescriptionPrompt = toggleItemDescriptionPrompt;
    ctrl.toggleLowestUomPrompt = toggleLowestUomPrompt;
    ctrl.toggleIsLotTrackedPrompt = toggleIsLotTrackedPrompt;
    ctrl.toggleIsExpiredPrompt = toggleIsExpiredPrompt;
    ctrl.toggleOriginCodePrompt = toggleOriginCodePrompt;
    ctrl.toggleEachesPerCasePrompt = toggleEachesPerCasePrompt;
    ctrl.toggleCasesPerPalletPrompt = toggleCasesPerPalletPrompt;
    ctrl.toggleUpcCodePrompt = toggleUpcCodePrompt;
    ctrl.toggleEanCodePrompt = toggleEanCodePrompt;
    ctrl.toggleItemCategoryPrompt = toggleItemCategoryPrompt;


    ctrl.hasErrorClass = hasErrorClass;
    ctrl.showMessages = showMessages;
    ctrl.newItem = newItem;
    ctrl.createItem = createItem;
    ctrl.clearForm = clearForm;


    ctrl.selectedStorageAttr = [];
    ctrl.isStorageAtrributeExist = true
    var checkStorageAttributesOfAreas = function (getStorageAttribute) {
        ctrl.selectedStorageAttr.push(getStorageAttribute);
        $http({
            method: 'GET',
            url: '/item/checkStorageAttributesOfAreas',
            params : {storageAttrList: ctrl.selectedStorageAttr}
        })
            .success(function (data, status, headers, config) {
                if (data.length == 0) {
                    ctrl.isStorageAtrributeExist = false;
                }
                else{
                    ctrl.isStorageAtrributeExist = true;
                }

            })
    };


    var checkStorageAttributesOfAreasWhenRemove = function (getPrevStorageAttribute) {

        var index = ctrl.selectedStorageAttr.indexOf(getPrevStorageAttribute);
        ctrl.selectedStorageAttr.splice(index, 1);
        if (ctrl.selectedStorageAttr.length > 0) {
            $http({
                method: 'GET',
                url: '/item/checkStorageAttributesOfAreas',
                params : {storageAttrList: ctrl.selectedStorageAttr}
            })
                .success(function (data, status, headers, config) {
                    if (data.length == 0) {
                        ctrl.isStorageAtrributeExist = false;
                    }
                    else{
                        ctrl.isStorageAtrributeExist = true;
                    }
                })            
        }

    };



    ctrl.newItem.storageAttributes = [];

    getListValueStorageAttribute();

    var findIndexOfArray = function(array, attr, value) {
        for(var i = 0; i < array.length; i += 1) {
            if(array[i][attr] === value) {
                return i;
            }
        }
        return -1;
    }

    ctrl.selectStorageAttributes = function(selectedAttr){

        if (ctrl.getStorageAttributes.optionValue != '+ Add New Attribute') {
            
            //var index = ctrl.storageOptions.indexOf(ctrl.getStorageAttributes);
            var index = findIndexOfArray(ctrl.storageOptions,'optionValue',ctrl.getStorageAttributes.optionValue);
            if(index >= 0){
                ctrl.newItem.storageAttributes.push(ctrl.getStorageAttributes);
                ctrl.storageOptions.splice(index, 1);
                checkStorageAttributesOfAreas(ctrl.getStorageAttributes.optionValue);

            }
        }
    };

    ctrl.removeStorageAttributes = function(item){

        var index = ctrl.newItem.storageAttributes.indexOf(item);
        if(index >= 0){
            ctrl.storageOptions.push(item);
            ctrl.newItem.storageAttributes.splice(index, 1);
            checkStorageAttributesOfAreasWhenRemove(item.optionValue);
            ctrl.isStorageAtrributeExist = true;
        }

    };


//***************end Item create*************************************

    //********************start import location*********************
    ctrl.uploadCSV = false;

    $scope.gridOptions = {
        rowHeight:100,
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
        exporterPdfOrientation: 'portrait',
        exporterPdfPageSize: 'LETTER',
        exporterPdfMaxGridWidth: 500,

        columnDefs: [
            {name:'Item', field: '0'},
            {name:'Description' , field: '1'},
            {name:'Category', field: '2'},
            {name:'Is Lot Tracked', field: '3'},
            {name:'Is Expired', field: '4'},
            {name:'Is Case Tracked', field: '5'},
            {name:'Lowest UOM', field: '6'},
            {name:'Origin Code', field: '7'},
            {name:'Each Per Case', field: '8'},
            {name:'Case Per Pallet', field: '9'},
            {name:'UPC Code', field: '10'},
            {name:'EAN Code', field: '11'},
            {name:'Storage Attribute', field: '12'},
            {name:'Error Message', field: '13', cellClass: 'grid-warning',cellTemplate:'<span style="color: red;">{{COL_FIELD}}</span>'}
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


    $scope.importItem = function () {
        $('#importItem').appendTo("body").modal('show');
        //$scope.gridOptions.columnDefs;
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
                    ctrl.uploadCSV = false;
                }
            }

            var pattern = gridRows[i][0].replace(/[^!_@;#='>+(/$:%<.&,*)"?]/g, '');

            if (gridRows[i][0] != gridRows[i][0].toUpperCase()){
                gridRows[i][errorMessageColumn] = $scope.gridOptions.columnDefs[0].name + " should be a uppercase letters";
                ctrl.uploadCSV = false;
            }


            else if (pattern){
                gridRows[i][errorMessageColumn] = $scope.gridOptions.columnDefs[0].name + " has undefined characters";
                ctrl.uploadCSV = false;
            }


            else if (gridRows[i][8] != parseInt(gridRows[i][8])){
                gridRows[i][errorMessageColumn] = $scope.gridOptions.columnDefs[8].name + " should be an integer";
                ctrl.uploadCSV = false;
            }

            else if (gridRows[i][9] != parseInt(gridRows[i][9])){
                gridRows[i][errorMessageColumn] = $scope.gridOptions.columnDefs[9].name + " should be an integer";
                ctrl.uploadCSV = false;
            }

            else if (gridRows[i][3] == 'EACH' && parseInt(gridRows[i][8]) == ''){
                gridRows[i][errorMessageColumn] = $scope.gridOptions.columnDefs[8].name + " should be a value";
                ctrl.uploadCSV = false;
            }

            else if (gridRows[i][3] == 'EACH' && gridRows[i][9] == ''){
                gridRows[i][errorMessageColumn] = $scope.gridOptions.columnDefs[9].name + " should be a value";
                ctrl.uploadCSV = false;
            }

            else if (gridRows[i][3] == 'CASE' && gridRows[i][9] == ''){
                gridRows[i][errorMessageColumn] = $scope.gridOptions.columnDefs[9].name + " should be a value1";
                ctrl.uploadCSV = false;
            }

            else if (gridRows[i][7] && ctrl.originCodesListOfCodes.indexOf(gridRows[i][7]) == -1){
                gridRows[i][errorMessageColumn] = $scope.gridOptions.columnDefs[7].name + " is invalid";
                ctrl.uploadCSV = false;
            }

            else if (gridRows[i][12]){              
                var attrToList = gridRows[i][12].split(',');
                    if (isStrgAttributeInvalid(attrToList)) {
                        gridRows[i][errorMessageColumn] = "One of the " + $scope.gridOptions.columnDefs[12].name + " is invalid";
                        ctrl.uploadCSV = false;
                    }                                  
            }

        }

        return gridRows;

    }

    var isStrgAttributeInvalid = function(list){
        for (var i = 0; i < list.length; i++) {
            if (ctrl.storageAttrOptionValues.indexOf(list[i]) == -1) {
                return true
                break;
            }                  
        }        
    }

    function validateRows(gridRows){
        //alert(gridRows.length);
        var errorMessageColumn = ($scope.gridOptions.columnDefs.length - 1);

        //Validate Item
        var arr = [];
        for (i = 0; i < gridRows.length; i++) {
            arr.push(itemImpService.checkItemExist(gridRows[i][0]));
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

        //Validate Item category
        //var arr = [];
        //for (i = 0; i < gridRows.length; i++) {
        //    arr.push(itemImpService.checkItemCategory(gridRows[i][2]));
        //}
        //$q.all(arr).then(function (response) {
        //
        //    for (i = 0; i < gridRows.length; i++) {
        //        if(response[i].length == 0){
        //            var message = $scope.gridOptions.columnDefs[2].name + " : " + gridRows[i][2] + " does not exist for your company";
        //            gridRows[i][errorMessageColumn] = gridRows[i][errorMessageColumn]  ? gridRows[i][errorMessageColumn] + ", " + message : message;
        //
        //            ctrl.uploadCSV = false;
        //        }
        //    }
        //
        //});

        return gridRows;

    }



    var handleFileSelect=function(changeEvent) {
        importItems = null;
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
                    ctrl.uploadCSV = true;
                    var gridData = processFile(jsonData);

                    gridData = validateRows(gridData);

                    $scope.gridOptions.data = gridData;

                    importItems = gridData;

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
        //alert(importItems);
        $scope.loadAnimPickListSearch = true;
        $http({
            method  : 'POST',
            url     : '/item/importItem',
            data: importItems,
            dataType: 'json',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function(data) {
                if (data.status == 'error') {
                    $('#importItem').modal('hide');
                    ctrl.uploadCSV = false;
                    ctrl.errorMsgForItemSave = data.message;
                    $('#dvPreventAddItem').appendTo("body").modal('show');                    
                }
                else{
                    $('#importItem').modal('hide');
                    ctrl.uploadCSV = false;

                    ctrl.showImportItemSubmittedPrompt = true;
                    $timeout(function () {
                        ctrl.showImportItemSubmittedPrompt = false;
                    }, 5000);                    
                }

            })

            .finally(function () {
                $scope.loadAnimPickListSearch = false;
            });
    });

    //

    var clearGrid = function () {
        angular.element(document.querySelector('#csvImport')).val(null);
        $scope.gridOptions.data = [];
        ctrl.uploadCSV = false;
    };

    ctrl.clearGrid = clearGrid;

    //*************end import location*******************************



// function to create new item category

    ctrl.addNewValue = function(){ // dispalys the model

        if (ctrl.newItemCategory == 'newItemCategory') {
            $('#AddNewItemCategory').appendTo("body").modal('show');
        }

    };


// function to save new item category
    $("#itemCategorySave").click(function(){

        if (ctrl.addItemCategory) {
            $http({
                method  : 'POST',
                url     : '/item/addItemCategoryValues',
                data    :  {optionGroup:'ITEMCAT', description:ctrl.addItemCategory},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    getAllListValues();
                    ctrl.newItemCategory = ctrl.addItemCategory ;
                    ctrl.addItemCategory ="";
                    $('#AddNewItemCategory').modal('hide');

                })
        };
    });


// function to create new Storage attribute

    ctrl.addNewAttribute = function(){ // dispalys the model

        if (ctrl.getStorageAttributes.optionValue == '+ Add New Attribute') {
            $('#addNewAttribute').appendTo("body").modal('show');
            ctrl.attrSaveOpt = 'createNew';
        }

    };

    $("#strgAttributeSave").click(function(saveOpt){

        if (ctrl.addNewStrgAttribute) {
            $http({
                method  : 'POST',
                url     : '/area/addAttributeValue',
                data    :  {optionGroup:'STRG', optionValue:ctrl.addNewStrgAttribute},
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    if (ctrl.attrSaveOpt == 'createNew') {
                        ctrl.newItem.storageAttributes.push({optionValue: data.optionValue});                     
                    }
                    else{
                        ctrl.editItem.storageAttributes.push({configValue: ctrl.addNewStrgAttribute});
                    }
                    ctrl.addNewStrgAttribute ="";
                    ctrl.getStorageAttributes = '';
                    $('#addNewAttribute').modal('hide');  
                    ctrl.attrSaveOpt ="";                     
                })
        };
    });


    $("#strgAttributeCancelSave").click(function(){
        ctrl.addNewStrgAttribute ="";
        ctrl.getStorageAttributes = '';
        ctrl.attrSaveOpt ="";
        //$('#AddNewItemCategory').modal('hide');
    });


    $("#itemCategorycancelSave").click(function(){
        ctrl.newItemCategory = '';
        ctrl.addItemCategory ="";
        ctrl.itemCategoryDescription = "";
        //$('#AddNewItemCategory').modal('hide');
    });

    var clearEach = function(uom){
        if (uom =='CASE') {
            ctrl.newItem.eachesPerCase = '';
        }
        if (uom =='PALLET') {
            ctrl.newItem.eachesPerCase = '';
            ctrl.newItem.casesPerPallet = '';
            ctrl.newItem.isCaseTracked = false;
            ctrl.newItem.isCaseTracked = disabled;
        }

    };
    ctrl.clearEach = clearEach;

    //*************start item edit function******************

    $scope.HideEditForm = function () {
        clearFormEdit();
        ctrl.editItemState = false;
        ctrl.showUpdatedPrompt = false;
        ctrl.selectedStorageAttr = [];
        ctrl.isStorageAtrributeExist = true;
    };




    var getAllStorageAttributeOfItemEdit = function (itemIds) {
        ctrl.selectedStorageAttr = [];
        $http({
            method: 'GET',
            url: '/item/getAllStorageAttributeOfItem',
            params : {itemId: itemIds}
        })
            .success(function (data, status, headers, config) {
                ctrl.editItem.storageAttributes = data;

                for (i = 0; i < ctrl.editItem.storageAttributes.length; i++) {

                    for (j = 0; j < ctrl.storageOptions.length; j++) {
                        if(ctrl.editItem.storageAttributes[i].configValue == ctrl.storageOptions[j].optionValue){
                            ctrl.storageOptions.splice(j, 1);
                            ctrl.selectedStorageAttr.push(ctrl.editItem.storageAttributes[i].configValue);
                        }
                    }

                }


            })
    };



    ctrl.selectStorageAttributesForEdit = function(selectedAttr){
        if (ctrl.getStorageAttributes.optionValue === "+ Add New Attribute") {
            $('#addNewAttribute').appendTo("body").modal('show');
            ctrl.attrSaveOpt = "editAttr";
        }
        else{
            //var index = ctrl.storageOptions.indexOf(ctrl.getStorageAttributes);
            var index = findIndexOfArray(ctrl.storageOptions,'optionValue',ctrl.getStorageAttributes.optionValue);

            if(index >= 0){
                ctrl.editItem.storageAttributes.push({configValue: ctrl.getStorageAttributes.optionValue});
                ctrl.storageOptions.splice(index, 1);
                checkStorageAttributesOfAreas(ctrl.getStorageAttributes.optionValue)
            }            
        }

    };



    ctrl.removeStorageAttributesForEdit = function(item){
        var index = ctrl.editItem.storageAttributes.indexOf(item);
        if(index >= 0){
            ctrl.storageOptions.push({optionValue: item.configValue});
            ctrl.editItem.storageAttributes.splice(index, 1);
            checkStorageAttributesOfAreasWhenRemove(item.configValue);
            ctrl.isStorageAtrributeExist = true;

        }
    };


    var ctrl = this,
        editItem = { itemId:'', itemDescription:'', lowestUom:'each', isLotTracked:'',isExpired:'', isCaseTracked:'', originCode:'', eachesPerCase:'', casesPerPallet:'', upcCode:'', eanCode:'', itemCategory:'', storageAttributes:[] };
    getAllListValues();
    getOriginCodes();


    $scope.Edit = function(row) {

        //Check Current User
        $http.get('/user/getCurrentUser')
            .success(function(data) {
                $scope.itemCroppedImage = '';
                ctrl.showSubmittedPrompt = false;
                ctrl.showUpdatedPrompt = false;

                getAllStorageAttributeOfItemEdit(row.entity.item_id);

                if (row.entity.lowest_uom == 'PALLET') {
                    ctrl.editItem.isCaseTracked = false;
                    ctrl.disableIsCaseTracked = true;
                }

                ctrl.editItemState = true;
                //$scope.IsVisible = true;
                ctrl.editItem.itemId = row.entity.item_id;
                ctrl.editItem.itemDescription = row.entity.item_description;
                ctrl.editItem.lowestUom = row.entity.lowest_uom;
                ctrl.editItem.isLotTracked = row.entity.is_lot_tracked;
                ctrl.editItem.isExpired = row.entity.is_expired;
                ctrl.editItem.isCaseTracked = row.entity.is_case_tracked;
                ctrl.editItem.originCode = row.entity.origin_code;
                ctrl.editItem.eachesPerCase = row.entity.eaches_per_case;
                ctrl.editItem.casesPerPallet = row.entity.cases_per_pallet;
                ctrl.editItem.upcCode = row.entity.upc_code;
                ctrl.editItem.eanCode = row.entity.ean_code;
                ctrl.newItemCategory = row.entity.description;
                ctrl.editItem.reorderLevelQty = row.entity.reorder_level_quantity;

                ctrl.updateItemForMessage = row.entity.item_id;
                ctrl.itemEditBtnText = 'Update';
                if (row.entity.image_path) {
                    $scope.itemCroppedImage ='/'+row.entity.image_path; 
                }
                


                $http({
                    method: 'GET',
                    url: '/item/findInventoryOfItemId',
                    params : {itemId: row.entity.item_id}
                })

                    .success(function (data, status, headers, config) {
                        ctrl.checkInventoryOfItem = data;

                        if (ctrl.checkInventoryOfItem.length > 0) {
                            ctrl.inventoryExist = true;
                            ctrl.fixedLowestUom = row.entity.lowest_uom;
                            ctrl.fixedEachesPerCase = row.entity.eaches_per_case;
                            ctrl.fixedCasesPerPallet = row.entity.cases_per_pallet;

                        }
                        else{
                            ctrl.inventoryExist = false;
                            ctrl.editItem.lowestUom = row.entity.lowest_uom;
                            ctrl.editItem.eachesPerCase = row.entity.eaches_per_case;
                            ctrl.editItem.casesPerPallet = row.entity.cases_per_pallet;

                        }


                    })




            });
    };


    var editItemFunction = function () {


        ctrl.editItem.itemCategory = ctrl.newItemCategory;

        if (ctrl.editItem.itemCategory == '') {
            ctrl.editItem.itemCategory = null;
        };

        if (ctrl.editItem.originCode == '') {
            ctrl.editItem.originCode = null;
        };



        if( ctrl.editItemForm.$valid) {

            ctrl.disableItemEdit = true;
            ctrl.itemEditBtnText = 'Updating..';  
            ctrl.editItem.itemImage = $scope.itemCroppedImage;

            $http({
                method  : 'POST',
                url     : '/item/updateItem',
                data    :  $scope.ctrl.editItem, 
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }

            })
                .success(function (data, status, headers, config) {
                    search();
                    ctrl.editItemState = false;
                    clearFormEdit();
                    ctrl.showUpdatedPrompt = true;

                    $timeout(function(){
                        ctrl.showUpdatedPrompt = false;
                    }, 5200);


                })
                .finally(function () {
                    ctrl.disableItemEdit = false;
                    ctrl.itemEditBtnText = 'Update';
                });                

        }
    };

    ctrl.editItem = editItem;


    var clearFormEdit = function () {
        $scope.itemImage = '';
        $scope.itemCroppedImage = '';
        ctrl.editItem = { itemId:'', itemDescription:'', lowestUom:'each', isLotTracked:'',isExpired:'', originCode:'', eachesPerCase:'', casesPerPallet:'', upcCode:'', eanCode:'', itemCategory:'', itemImage:''};
        ctrl.editItem.storageAttributes = [];
        //ctrl.storageOptions = ['FROZEN', 'REFRIGERATED', 'CAGED','BULK','REGULAR']; 
        getListValueStorageAttribute();
        ctrl.editItemForm.$setUntouched();
        ctrl.editItemForm.$setPristine();
        ctrl.newItemCategory = '';
        ctrl.disableIsCaseTracked = false;
    };



    var hasErrorClassEdit = function (field) {
        return ctrl.editItemForm[field].$touched && ctrl.editItemForm[field].$invalid;
    };

    var showMessagesEdit = function (field) {
        return ctrl.editItemForm[field].$touched || ctrl.editItemForm.$submitted;
    };

    var toggleEditItemIdPrompt = function (value) {
        ctrl.showEditItemIdPrompt = value;
    };
    var toggleEditItemDescriptionPrompt = function (value) {
        ctrl.showEditItemDescriptionPrompt = value;
    };
    var toggleEditLowestUomPrompt = function (value) {
        ctrl.showEditLowestUomPrompt = value;
    };
    var toggleEditIsLotTrackedPrompt = function (value) {
        ctrl.showEditIsLotTrackedPrompt = value;
    };
    var toggleEditIsExpiredPrompt = function (value) {
        ctrl.showEditIsExpiredPrompt = value;
    };
    var toggleEditOriginCodePrompt = function (value) {
        ctrl.showEditOriginCodePrompt = value;
    };
    var toggleEditEachesPerCasePrompt = function (value) {
        ctrl.showEditEachesPerCasePrompt = value;
    };
    var toggleEditCasesPerPalletPrompt = function (value) {
        ctrl.showEditCasesPerPalletPrompt = value;
    };
    var toggleEditUpcCodePrompt = function (value) {
        ctrl.showEditUpcCodePrompt = value;
    };
    var toggleEditEanCodePrompt = function (value) {
        ctrl.showEditEanCodePrompt = value;
    };
    var toggleEditItemCategoryPrompt = function (value) {
        ctrl.showEditItemCategoryPrompt = value;
    };


    ctrl.showEditItemIdPrompt = false;
    ctrl.showEditItemDescriptionPrompt = false;
    ctrl.showEditLowestUomPrompt = false;
    ctrl.showEditIsLotTrackedPrompt = false;
    ctrl.showEditIsExpiredPrompt = false;
    ctrl.showEditOriginCodePrompt = false;
    ctrl.showEditEachesPerCasePrompt = false;
    ctrl.showEditCasesPerPalletPrompt = false;
    ctrl.showEditUpcCodePrompt = false;
    ctrl.showEditEanCodePrompt = false;
    ctrl.showEditItemCategoryPrompt = false;

    ctrl.showUpdatedPrompt = false;




    ctrl.toggleEditItemIdPrompt = toggleEditItemIdPrompt;
    ctrl.toggleEditItemDescriptionPrompt = toggleEditItemDescriptionPrompt;
    ctrl.toggleEditLowestUomPrompt = toggleEditLowestUomPrompt;
    ctrl.toggleEditIsLotTrackedPrompt = toggleEditIsLotTrackedPrompt;
    ctrl.toggleEditIsExpiredPrompt = toggleEditIsExpiredPrompt;
    ctrl.toggleEditOriginCodePrompt = toggleEditOriginCodePrompt;
    ctrl.toggleEditEachesPerCasePrompt = toggleEditEachesPerCasePrompt;
    ctrl.toggleEditCasesPerPalletPrompt = toggleEditCasesPerPalletPrompt;
    ctrl.toggleEditUpcCodePrompt = toggleEditUpcCodePrompt;
    ctrl.toggleEditEanCodePrompt = toggleEditEanCodePrompt;
    ctrl.toggleEditItemCategoryPrompt = toggleEditItemCategoryPrompt;


    ctrl.hasErrorClassEdit = hasErrorClassEdit;
    ctrl.showMessagesEdit = showMessagesEdit;
    ctrl.editItemFunction = editItemFunction;
    ctrl.clearFormEdit = clearFormEdit;


    var clearEachEdit = function(uom){
        if (uom =='CASE') {
            ctrl.editItem.eachesPerCase = '';
            ctrl.disableIsCaseTracked = false;
        }
        else if (uom == 'PALLET') {
            ctrl.disableIsCaseTracked = true;
            ctrl.editItem.isCaseTracked = false;
        }
        else{
            ctrl.disableIsCaseTracked = false;
        }

    };
    ctrl.clearEachEdit = clearEachEdit;




    //**********end item edit****************************

    //**********START ITEM DELETE**************


    ctrl.showDeletedPrompt = false;
    var rows;
    $scope.Delete = function(row) {  //calling bootstrap confirm box.

        //$('#itemDelete').appendTo("body").modal('show');
        //checkInventoryExist(row.entity.item_id);

        //alert(row.entity.item_id);
        $http({
            method: 'GET',
            url: '/item/findInventoryOfItemId',
            params : {itemId: row.entity.item_id}
        })
            .success(function (data, status, headers, config) {
                ctrl.checkInventoryOfItem = data;

                ctrl.deleteItemForMessage = row.entity.item_id;

                if (ctrl.checkInventoryOfItem.length > 0) {
                    $('#itemDeleteWarning').appendTo("body").modal('show');
                    ctrl.deleteItemForMessage = row.entity.item_id;

                }
                else{
                    $('#itemDelete').appendTo("body").modal('show');
                    ctrl.deleteItemForMessage = row.entity.item_id;

                }


            })



        rows = row;

    };





    $("#deleteItemButton").click(function(){ //finction to delete after validation.

        $http({
            method: 'POST',
            url: '/item/deleteItem',
            data: {itemId: rows.entity.item_id},
            dataType: 'json',
            headers: {'Content-Type': 'application/json; charset=utf-8'}  // set the headers so angular passing //info as form data (not request payload)
        })
            .success(function (data, status, headers, config) {
                $('#itemDelete').modal('hide');
                ctrl.showDeletedPrompt = true;
                var index = $scope.gridItem.data.indexOf(rows.entity);
                $scope.gridItem.data.splice(index, 1);

                $timeout(function(){
                    ctrl.showDeletedPrompt = false;
                }, 5200);

            });




    });




    //**********END OF ITEM DELETE**************

//**********START ITEM COPY**************

    var getAllStorageAttributeOfCopyItem = function (itemId) {
        ctrl.selectedStorageAttr = [];
        $http({
            method: 'GET',
            url: '/item/getAllStorageAttributeOfItem',
            params : {itemId: itemId}
        })
            .success(function (data, status, headers, config) {
                if (data.length > 0) {
                    for (var i = 0; i < data.length; i++) {
                        console.log(data[i].configValue);
                        ctrl.copyItemData.storageAttributes.push({optionValue: data[i].configValue});
                    }    
                }
            })
    };


    ctrl.showDeletedPrompt = false;
    var rows;
    $scope.Copy = function(row) { console.log("i am trying to copy")
     $('#itemCopy').appendTo("body").modal('show'); //calling bootstrap confirm box.
            ctrl.copyItemData = {};
            ctrl.copyItemData.storageAttributes = [];
            ctrl.copyItemData.lowestUom = row.entity.lowest_uom;
            ctrl.copyItemData.isLotTracked = row.entity.is_lot_tracked;
            ctrl.copyItemData.isExpired = row.entity.is_expired;
            ctrl.copyItemData.isCaseTracked = row.entity.is_case_tracked;
            ctrl.copyItemData.originCode = row.entity.origin_code;
            ctrl.copyItemData.eachesPerCase = row.entity.eaches_per_case;
            ctrl.copyItemData.casesPerPallet = row.entity.cases_per_pallet;
            ctrl.copyItemData.upcCode = row.entity.upc_code;
            ctrl.copyItemData.eanCode = row.entity.ean_code;
            ctrl.copyItemData.reorderLevelQty = row.entity.reorder_level_quantity;
            //ctrl.updateItemForMessage = row.entity.item_id;
            // ctrl.fixedLowestUom = row.entity.lowest_uom;
            // ctrl.fixedEachesPerCase = row.entity.eaches_per_case;
            // ctrl.fixedCasesPerPallet = row.entity.cases_per_pallet;
            ctrl.copyItemData.lowestUom = row.entity.lowest_uom;
            ctrl.copyItemData.eachesPerCase = row.entity.eaches_per_case;
            ctrl.copyItemData.casesPerPallet = row.entity.cases_per_pallet;
            ctrl.copyItemData.imagePath = row.entity.image_path;
            ctrl.copyItemData.itemCategory = row.entity.description;
            getAllStorageAttributeOfCopyItem(row.entity.item_id);


            // if (row.entity.image_path) {
            //     $scope.itemCroppedImage ='https://s3-us-west-2.amazonaws.com/foysonis-item-image/'+row.entity.image_path; 
            // }
    };


    $("#copyItemBtn").click(function(){ //finction to delete after validation.

            $http({
                method  : 'POST',
                url     : '/item/save',
                data    :  $scope.ctrl.copyItemData,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function(data) {
                    $('#itemCopy').modal('hide');
                        $scope.gridItem.data = data.data;
                        ctrl.newItemForMessage = ctrl.newItem.itemId;
                        //$scope.IsVisible = false;
                        ctrl.showSubmittedPrompt = true;
                        ctrl.copyItemData = {};
                        //clearForm();
                        $timeout(function(){
                            ctrl.showSubmittedPrompt = false;
                        }, 5200);
                })
                //  .finally(function () {
                //   ctrl.disableItemSave = false;
                //   ctrl.itemSaveBtnText = 'Save';
                // });
    });



    //**********END OF ITEM COPY**************

//start search

    $scope.callback = function(selected) {
        ctrl.disabledFind = ctrl.itemId || ctrl.itemDescription ? false : true;

    };

    var disableFindButton = function () {
        ctrl.disabledFind = ctrl.itemId || ctrl.itemDescription ? false : true;
        if (ctrl.configValue.length > 0) {
            ctrl.disabledFind = false;
        }
        if (ctrl.isLotTracked) {
            ctrl.disabledFind = false;
        }
        if (ctrl.isExpired) {
            ctrl.disabledFind = false;
        }
        if (ctrl.itemCategory) {
            ctrl.disabledFind = false;
        }
    };

    ctrl.disabledFind = true;
    ctrl.disableFindButton = disableFindButton;



    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };

//start grid
    $scope.gridItem = {
        //This is the template that will be used to render subgrid.
        expandableRowTemplate: "<div ui-grid='row.entity.subGridOptions' style='height:150px;'></div>",
        //This will be the height of the subgrid
        expandableRowHeight: 150,

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
        exporterPdfOrientation: 'portrait',
        exporterPdfPageSize: 'LETTER',
        exporterPdfMaxGridWidth: 500,


        columnDefs: [
            {name:'Item', cellTemplate: '<span ng-if="row.entity.image_path"><a href="javascript:void(0)" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;" uib-popover-html="grid.appScope.htmlPopover(row)" popover-append-to-body="true" popover-trigger="mouseenter" popover-placement="right">{{row.entity.item_id}}</a></span><span ng-if="!row.entity.image_path" style="padding: 2px 2px !important; margin: 5px 10px 0px 10px; line-height: 34px;     color: #9b9b9b;">{{row.entity.item_id}}</span>'},
            {name:'Description' , field: 'item_description'},
            {name:'Category', field: 'description'},
            {name:'is LotTracked', field: 'is_lot_tracked', type: 'boolean', cellClass: 'grid-align',cellTemplate: '<div class="gridCheckbox c-checkbox"><input type="checkbox"  ng-model="row.entity.is_lot_tracked"><span class="fa fa-check"></span></div class>', enableFiltering: false},
            {name:'is Expired', field: 'is_expired', type: 'boolean', cellClass: 'grid-align',cellTemplate: '<div class="gridCheckbox c-checkbox"><input type="checkbox"  ng-model="row.entity.is_expired"><span class="fa fa-check"></span></div class>', enableFiltering: false},
            {name:'is CaseTracked', field: 'is_case_tracked', type: 'boolean', cellClass: 'grid-align',cellTemplate: '<div class="gridCheckbox c-checkbox"><input type="checkbox"  ng-model="row.entity.is_case_tracked"><span class="fa fa-check"></span></div class>', enableFiltering: false},
            {name: 'Actions', enableSorting: false, cellTemplate: '<div class="btn-group mb-sm" style="position: absolute; z-index: auto; margin-left: 5px; margin-top: 2px;"><button class="actionBtnGrid" data-toggle="dropdown" type="button"><span><em class="fa  fa-fw mr-sm" ><img src="/foysonis2016/app/img/grid_action_button.svg" width="18px"></em></span>&emsp;<span class="glyphicon glyphicon-chevron-down" style="color:#ffffff; font-size: 10px;"></span></button><ul class="dropdown-menu" role="menu"><li><a href="javascript:void(0);" ng-click="grid.appScope.Edit(row)">Edit</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.Delete(row)">Delete</a></li><li><a href="javascript:void(0);" ng-click="grid.appScope.Copy(row)">Copy</a></li></ul></div>'}

        ],

        onRegisterApi: function( gridApi ){

            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {
                if (row.isExpanded) {

                    row.entity.subGridOptions = {
                        columnDefs: [
                            {name:'Storage Attribute', field: 'strg'},
                            {name:'Eaches Per Case', field: 'eaches_per_case'},
                            {name:'Cases Per Pallet', field: 'cases_per_pallet'},
                            {name:'Re-order Level Qty', field: 'reorder_level_quantity'},
                            {name:'Lowest UOM', field: 'lowest_uom', cellClass: 'grid-align', visible:true},
                            {name:'Origin Code', field: 'origin_code', cellClass: 'grid-align', visible:true},
                            {name:'Eaches Per Case', field: 'eaches_per_case', cellClass: 'grid-align', visible:true},
                            {name:'Cases Per Pallet', field: 'cases_per_pallet', cellClass: 'grid-align', visible:true},
                            {name:'UPC Code', field: 'upc_code', cellClass: 'grid-align', visible:true},
                            {name:'EAN Code', field: 'ean_code', cellClass: 'grid-align', visible:true},
                        ]};


                    $http({
                        method: 'GET',
                        url: '/item/getItemEntityAttributeForSearchRow',
                        params : {selectedRowItem: row.entity.item_id}
                    })
                        .success(function(data) {
                            row.entity.subGridOptions.data = data;
                        });

                }
            });

            // interval of zero just to allow the directive to have initialized
            $interval( function() {
                gridApi.core.addToGridMenu( gridApi.grid, [{ title: 'Dynamic item', order: 100}]);
            }, 0, 1);

            gridApi.core.on.columnVisibilityChanged( $scope, function( changedColumn ){
                $scope.columnChanged = { name: changedColumn.colDef.name, visible: changedColumn.colDef.visible };
            });
        }
    };


    $scope.htmlPopover = function(row){
        if (row.entity.image_path) {
            return $sce.trustAsHtml('<div style="height:250px;"><img width="250px" src=/'+row.entity.image_path+'/><div/>');  
        }
        
    }

    var search = function () {
        var values = [];
        for (i=0;i<ctrl.configValue.length;i++) {
            values.push("'"+ctrl.configValue[i].configValue+"'")
        }
        selectedValues = values.join();

        if (ctrl.searchForm.$valid) {
            $http({
                method: 'POST',
                url: '/item/searchResults',
                params: {itemId:ctrl.itemId, itemDescription:ctrl.itemDescription, itemCategory:ctrl.itemCategory,
                    isLotTracked:ctrl.isLotTracked, isExpired:ctrl.isExpired, isCaseTracked:ctrl.isCaseTracked, configValue:selectedValues},
                data    :  $scope.ctrl,
                dataType: 'json',
                headers : { 'Content-Type': 'application/json; charset=utf-8' }
            })
                .success(function (data) {
                    //$scope.gridItem.data = data;
                    ctrl.show = false;
                    $scope.gridItem.data = data.splice(0,10000);

                })
        }

        $scope.IsVisible = false;
    };

    ctrl.search = search;

    var loadGridData = function (){
        $http({
            method: 'POST',
            url: '/item/searchResults',
            headers : { 'Content-Type': 'application/json; charset=utf-8' }
        })
            .success(function (data) {
                $scope.gridItem.data = data.splice(0,10000);

            })
    };
    loadGridData();

//end of the grid

    //Get all list values for item category
    var getAllListValues1 = function () {
        $http({
            method: 'GET',
            url: '/item/getAllValuesByCompanyIdAndGroup',
            params : {group: 'ITEMCAT'}
        })
            .success(function (data) {
                ctrl.listValue1 = data;
            })
    };
    getAllListValues1();

//multi combo box list items

    $http({
        method: 'GET',
        url: '/item/getAllValuesByCompanyIdAndGroup',
        params : {group: 'STRG'}
    })
        .success(function (data) {
            $scope.multiComboData = data;
            //alert(data);
        });


    ctrl.configValue = [];

    $scope.multiCombo






    s = {
        scrollableHeight: '165px',
        scrollable: true,
        enableSearch: false
    };

    //end multi combo box list items

    //end search


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
                        $scope.itemImage=evt.target.result;
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
    angular.element(document.querySelector('.itemImageInput')).on('change',handleFileSelect);


    ctrl.deleteImageFile = function(){
        $http({
            method : 'GET',
            url : '/item/deleteImageFile',
            params: {itemId: ctrl.editItem.itemId}
        })
        .success(function (data, status, headers, config) {
            if(data.status == 'success'){
                $scope.itemCroppedImage = '';
                search();
            }
        })
    };

    ctrl.clearLoadedItmImage = function(){
        $scope.itemImage='';
        $scope.itemCroppedImage = '';
        angular.element(document.querySelector('.itemImageInput')).val(null);

    };

    ctrl.itemIdUniqueValidation = function(viewValue){
        $http({
            method : 'GET',
            url : '/item/checkItemIdExist',
            params: {itemId: viewValue}
        })
            .success(function (data, status, headers, config) {

                if(data.length == 0){
                    ctrl.createItemForm.itemId.$setValidity('itemIdExists', true);
                }
                else
                {
                    ctrl.createItemForm.itemId.$setValidity('itemIdExists', false);
                }

            })
            .error(function (data, status, headers, config) {
                ctrl.createItemForm.itemId.$setValidity('itemIdExists', false);
            });
    };

    ctrl.casesPerPalletZeroValidation = function(viewValue, field){
                if(parseInt(viewValue) == 0){
                    ctrl.createItemForm['casesPerPallet'].$setValidity('isZeroCasesPerPallet', false);
                }
                else
                {
                    ctrl.createItemForm['casesPerPallet'].$setValidity('isZeroCasesPerPallet', true);
                }
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


// start multi combo box

    .directive('ngDropdownMultiselect', ['$filter', '$document', '$compile', '$parse',

        function ($filter, $document, $compile, $parse) {

            return {
                restrict: 'AE',
                scope: {
                    selectedModel: '=',
                    options: '=',
                    extraSettings: '=',
                    events: '=',
                    searchFilter: '=?',
                    translationTexts: '=',
                    groupBy: '@'
                },
                template: function (element, attrs) {
                    var checkboxes = attrs.checkboxes ? true : false;
                    var groups = attrs.groupBy ? true : false;

                    var template = '<div class="multiselect-parent btn-group dropdown-multiselect" style="margin-bottom: 0px; margin-top: 0px;">';
                    template += '<button type="button" class="dropdown-toggle" ng-class="settings.buttonClasses" ng-click="toggleDropdown()" style="width: 485.41px; height: 37px; margin-bottom: 0px;font-size: 14px;">{{getButtonText()}}&nbsp;<span class="caret" ></span></button>';
                    template += '<ul class="dropdown-menu dropdown-menu-form" ng-style="{display: open ? \'block\' : \'none\', height : settings.scrollable ? settings.scrollableHeight : \'auto\' }" style="overflow: scroll; width:300px;" >';
                    template += '<li ng-hide="!settings.showCheckAll || settings.selectionLimit > 0"><a data-ng-click="selectAll()"><span class="glyphicon glyphicon-ok"></span>  {{texts.checkAll}}</a>';
                    template += '<li ng-show="settings.showUncheckAll"><a data-ng-click="deselectAll();"><span class="glyphicon glyphicon-remove"></span>   {{texts.uncheckAll}}</a></li>';
                    template += '<li ng-hide="(!settings.showCheckAll || settings.selectionLimit > 0) && !settings.showUncheckAll" class="divider"></li>';
                    template += '<li ng-show="settings.enableSearch"><div class="dropdown-header"><input type="text" class="form-control" style="width: 100%; margin-bottom: 0px; margin-top: 0px;" ng-model="searchFilter" placeholder="{{texts.searchPlaceholder}}" /></li>';
                    template += '<li ng-show="settings.enableSearch" class="divider"></li>';

                    if (groups) {
                        template += '<li ng-repeat-start="option in orderedItems | filter: searchFilter" ng-show="getPropertyForObject(option, settings.groupBy) !== getPropertyForObject(orderedItems[$index - 1], settings.groupBy)" role="presentation" class="dropdown-header">{{ getGroupTitle(getPropertyForObject(option, settings.groupBy)) }}</li>';
                        template += '<li ng-repeat-end role="presentation">';
                    } else {
                        template += '<li role="presentation" ng-repeat="option in options | filter: searchFilter">';
                    }

                    template += '<a role="menuitem" tabindex="-1" ng-click="setSelectedItem(getPropertyForObject(option,settings.idProp))">';

                    if (checkboxes) {
                        template += '<div class="checkbox" style="margin-bottom: 0px; margin-top: 0px;"><label><input class="checkboxInput" type="checkbox" ng-click="checkboxClick($event, getPropertyForObject(option,settings.idProp))" ng-checked="isChecked(getPropertyForObject(option,settings.idProp))" /> {{getPropertyForObject(option, settings.displayProp)}}</label></div></a>';
                    } else {
                        template += '<span data-ng-class="{\'glyphicon glyphicon-ok\': isChecked(getPropertyForObject(option,settings.idProp))}"></span> {{getPropertyForObject(option, settings.displayProp)}}</a>';
                    }

                    template += '</li>';

                    template += '<li class="divider" ng-show="settings.selectionLimit > 1"></li>';
                    template += '<li role="presentation" ng-show="settings.selectionLimit > 1"><a role="menuitem">{{selectedModel.length}} {{texts.selectionOf}} {{settings.selectionLimit}} {{texts.selectionCount}}</a></li>';

                    template += '</ul>';
                    template += '</div>';

                    element.html(template);
                },
                link: function ($scope, $element, $attrs) {
                    var $dropdownTrigger = $element.children()[0];

                    $scope.toggleDropdown = function () {
                        $scope.open = !$scope.open;
                    };

                    $scope.checkboxClick = function ($event, configValue) {
                        $scope.setSelectedItem(configValue);
                        $event.stopImmediatePropagation();
                    };

                    $scope.externalEvents = {
                        onItemSelect: angular.noop,
                        onItemDeselect: angular.noop,
                        onSelectAll: angular.noop,
                        onDeselectAll: angular.noop,
                        onInitDone: angular.noop,
                        onMaxSelectionReached: angular.noop
                    };

                    $scope.settings = {
                        dynamicTitle: true,
                        scrollable: false,
                        scrollableHeight: '300px',
                        closeOnBlur: true,
                        displayProp: 'optionValue',
                        idProp: 'optionValue',
                        externalIdProp: 'configValue',
                        enableSearch: false,
                        selectionLimit: 0,
                        showCheckAll: true,
                        showUncheckAll: true,
                        closeOnSelect: false,
                        buttonClasses: 'btn btn-default',
                        closeOnDeselect: false,
                        groupBy: $attrs.groupBy || undefined,
                        groupByTextProvider: null,
                        smartButtonMaxItems: 0,
                        smartButtonTextConverter: angular.noop
                    };

                    $scope.texts = {
                        checkAll: 'Check All',
                        uncheckAll: 'Uncheck All',
                        selectionCount: 'checked',
                        selectionOf: '/',
                        searchPlaceholder: 'Search...',
                        buttonDefaultText: 'Select Storage Attributes',
                        dynamicButtonTextSuffix: 'checked'
                    };

                    $scope.searchFilter = $scope.searchFilter || '';

                    if (angular.isDefined($scope.settings.groupBy)) {
                        $scope.$watch('options', function (newValue) {
                            if (angular.isDefined(newValue)) {
                                $scope.orderedItems = $filter('orderBy')(newValue, $scope.settings.groupBy);
                            }
                        });
                    }

                    angular.extend($scope.settings, $scope.extraSettings || []);
                    angular.extend($scope.externalEvents, $scope.events || []);
                    angular.extend($scope.texts, $scope.translationTexts);

                    $scope.singleSelection = $scope.settings.selectionLimit === 1;

                    function getFindObj(configValue) {
                        var findObj = {};

                        if ($scope.settings.externalIdProp === '') {
                            findObj[$scope.settings.idProp] = configValue;
                        } else {
                            findObj[$scope.settings.externalIdProp] = configValue;
                        }

                        return findObj;
                    }

                    function clearObject(object) {
                        for (var prop in object) {
                            delete object[prop];
                        }
                    }

                    if ($scope.singleSelection) {
                        if (angular.isArray($scope.selectedModel) && $scope.selectedModel.length === 0) {
                            clearObject($scope.selectedModel);
                        }
                    }

                    if ($scope.settings.closeOnBlur) {
                        $document.on('click', function (e) {
                            var target = e.target.parentElement;
                            var parentFound = false;

                            while (angular.isDefined(target) && target !== null && !parentFound) {
                                if (_.contains(target.className.split(' '), 'multiselect-parent') && !parentFound) {
                                    if (target === $dropdownTrigger) {
                                        parentFound = true;
                                    }
                                }
                                target = target.parentElement;
                            }

                            if (!parentFound) {
                                $scope.$apply(function () {
                                    $scope.open = false;
                                });
                            }
                        });
                    }

                    $scope.getGroupTitle = function (groupValue) {
                        if ($scope.settings.groupByTextProvider !== null) {
                            return $scope.settings.groupByTextProvider(groupValue);
                        }

                        return groupValue;
                    };

                    $scope.getButtonText = function () {
                        if ($scope.settings.dynamicTitle && ($scope.selectedModel.length > 0 || (angular.isObject($scope.selectedModel) && _.keys($scope.selectedModel).length > 0))) {
                            if ($scope.settings.smartButtonMaxItems > 0) {
                                var itemsText = [];

                                angular.forEach($scope.options, function (optionItem) {
                                    if ($scope.isChecked($scope.getPropertyForObject(optionItem, $scope.settings.idProp))) {
                                        var displayText = $scope.getPropertyForObject(optionItem, $scope.settings.displayProp);
                                        var converterResponse = $scope.settings.smartButtonTextConverter(displayText, optionItem);

                                        itemsText.push(converterResponse ? converterResponse : displayText);
                                    }
                                });

                                if ($scope.selectedModel.length > $scope.settings.smartButtonMaxItems) {
                                    itemsText = itemsText.slice(0, $scope.settings.smartButtonMaxItems);
                                    itemsText.push('...');
                                }

                                return itemsText.join(', ');
                            } else {
                                var totalSelected;

                                if ($scope.singleSelection) {
                                    totalSelected = ($scope.selectedModel !== null && angular.isDefined($scope.selectedModel[$scope.settings.idProp])) ? 1 : 0;
                                } else {
                                    totalSelected = angular.isDefined($scope.selectedModel) ? $scope.selectedModel.length : 0;
                                }

                                if (totalSelected === 0) {
                                    return $scope.texts.buttonDefaultText;
                                } else {
                                    return totalSelected + ' ' + $scope.texts.dynamicButtonTextSuffix;
                                }
                            }
                        } else {
                            return $scope.texts.buttonDefaultText;
                        }
                    };

                    $scope.getPropertyForObject = function (object, property) {
                        if (angular.isDefined(object) && object.hasOwnProperty(property)) {
                            return object[property];
                        }

                        return '';
                    };

                    $scope.selectAll = function () {
                        $scope.deselectAll(false);
                        $scope.externalEvents.onSelectAll();

                        angular.forEach($scope.options, function (value) {
                            $scope.setSelectedItem(value[$scope.settings.idProp], true);
                        });
                    };

                    $scope.deselectAll = function (sendEvent) {
                        sendEvent = sendEvent || true;

                        if (sendEvent) {
                            $scope.externalEvents.onDeselectAll();
                        }

                        if ($scope.singleSelection) {
                            clearObject($scope.selectedModel);
                        } else {
                            $scope.selectedModel.splice(0, $scope.selectedModel.length);
                        }
                    };

                    $scope.setSelectedItem = function (configValue, dontRemove) {
                        var findObj = getFindObj(configValue);
                        var finalObj = null;

                        if ($scope.settings.externalIdProp === '') {
                            finalObj = _.find($scope.options, findObj);
                        } else {
                            finalObj = findObj;
                        }

                        if ($scope.singleSelection) {
                            clearObject($scope.selectedModel);
                            angular.extend($scope.selectedModel, finalObj);
                            $scope.externalEvents.onItemSelect(finalObj);
                            if ($scope.settings.closeOnSelect) $scope.open = false;

                            return;
                        }

                        dontRemove = dontRemove || false;

                        var exists = _.findIndex($scope.selectedModel, findObj) !== -1;

                        if (!dontRemove && exists) {
                            $scope.selectedModel.splice(_.findIndex($scope.selectedModel, findObj), 1);
                            $scope.externalEvents.onItemDeselect(findObj);
                        } else if (!exists && ($scope.settings.selectionLimit === 0 || $scope.selectedModel.length < $scope.settings.selectionLimit)) {
                            $scope.selectedModel.push(finalObj);
                            $scope.externalEvents.onItemSelect(finalObj);
                        }
                        if ($scope.settings.closeOnSelect) $scope.open = false;
                    };

                    $scope.isChecked = function (configValue) {
                        if ($scope.singleSelection) {
                            return $scope.selectedModel !== null && angular.isDefined($scope.selectedModel[$scope.settings.idProp]) && $scope.selectedModel[$scope.settings.idProp] === getFindObj(configValue)[$scope.settings.idProp];
                        }

                        return _.findIndex($scope.selectedModel, getFindObj(configValue)) !== -1;
                    };

                    $scope.externalEvents.onInitDone();
                }
            };
        }])


// end multi combo box


//
    .filter('phoneListFilter', function () {
        return function (viewValue) {

            $http({
                method: 'GET',
                url: '/item/getItemEntityAttributeForSearchRow',
                params : {selectedRowItem: viewValue}
            })
                .success(function(data) {

                    //var info = [];
                    //if(data.length > 0){
                    //
                    //    for (i = 0; i < data.length; i++) {
                    //        info.push(data[i].config_value);
                    //
                    //    }
                    //}
                    ////ctrl.configValue = info;
                    //return info;


                    var telePhoneArray = [];

                    for (var i in config_value) {
                        telePhoneArray.push(data[i].config_value);
                    }
                    return telePhoneArray.join(',');
                    return viewValue

                });

        };
    })
//


;




