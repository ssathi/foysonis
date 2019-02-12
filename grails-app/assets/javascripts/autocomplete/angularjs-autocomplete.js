/**
 * Created by User on 9/18/2015.
 */

var autoCompleteApp = angular.module('autoCompleteApp', ['angularjs-autocomplete', 'ngSanitize']);
autoCompleteApp.controller('MyCtrl', function($scope, $http) {
    $http.get('/user/getCompanyActiveUsers')
        .success(function(data) {
            $scope.source2 = data;
            $scope.source3 = data.concat({firstName:'All', lastName:'', username:'all users'}) ;
        });

    $scope.callback = function(selected) {
        $scope.foo_ids = $scope.foo.map(function(el) {return el.username || el;}).join(',');
        $scope.selected = selected;
    };



    $scope.foo = [];
    $scope.foo_ids = [];
    $scope.disabled = false;
    $scope.customListFormatter = function(data) {
        return '<b>'+data.firstName+'</b>' +'&nbsp;' +
            '<b>'+data.lastName+'</b>' +
            '<br><span>'+data.username+'</span>';

    };
    
});



