/**
 * Created by home on 8/2/16.
 */

var app = angular.module('locationImport', ['locationImportService','ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ui.grid.expandable', 'ngAria', 'ngMessages', 'ngAnimate', 'inventory-autocomplete', 'ngSanitize','ui.grid.pagination', 'ui.grid.autoResize']);

app.controller('LocationImportCtrl', ['$scope', '$http', '$interval', '$q', '$timeout', 'locationImpService', function ($scope, $http, $interval, $q, $timeout, locationImpService) {

    var myEl = angular.element( document.querySelector( '#liReport' ) );
    myEl.addClass('active');

    var fakeI18n = function( title ){
        var deferred = $q.defer();
        $interval( function() {
            deferred.resolve( 'col: ' + title );
        }, 1000, 1);
        return deferred.promise;
    };


    $scope.gridOptions = {
        rowHeight:75,
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
                    var message = $scope.gridOptions.columnDefs[2].name + " : " + gridRows[i][2] + " is already exists";
                    gridRows[i][errorMessageColumn] = gridRows[i][errorMessageColumn]  ? gridRows[i][errorMessageColumn] + ", " + message : message;

                    var message = $scope.gridOptions.columnDefs[0].name + " : " + gridRows[i][0] + " used in barcode";
                    gridRows[i][errorMessageColumn] = gridRows[i][errorMessageColumn]  ? gridRows[i][errorMessageColumn] + ", " + message : message;
                }
            }

        });



        return gridRows;

    }



    var handleFileSelect=function(changeEvent) {

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

                    //$http.get('/user/getCompanyUsersWithFullName')
                    //    .success(function(data) {
                    //        $scope.gridOptions.data = gridData;
                    //    });
                }

            };

            r.readAsText(files[0]);

        }
    };

    angular.element(document.querySelector('#csvImport')).on('change',handleFileSelect);

}]);


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

