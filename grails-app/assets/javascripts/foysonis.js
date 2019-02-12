/**
 * Created by home on 8/27/15.
 */


// create angular app
var validationApp = angular.module('validationApp', []);

// create angular controller
validationApp.controller('mainController', ['$scope', '$http',  function($scope) {

    // function to submit the form after all validation has occurred
    $scope.submitForm = function() {

        // check to make sure the form is completely valid
        if ($scope.userForm.$valid) {

        }

    };

}]);


validationApp.directive('companyIdValidator', function ($http, $timeout) { // available
    return {
        require: 'ngModel',
        link: function (scope, elem, attr, ctrl) {

            ctrl.$parsers.push(function (viewValue) {
                // set it to true here, otherwise it will not
                // clear out when previous validators fail.
                ctrl.$setValidity('companyIdValidator', true);
                if (ctrl.$valid) {
                    // set it to false here, because if we need to check
                    // the validity of the email, it's invalid until the
                    // AJAX responds.
                    //ctrl.$setValidity('checkingRepo', false);

                    // now do your thing, chicken wing.
                    if (viewValue !== "" && typeof viewValue !== "undefined") {
                        $http({
                    method : 'GET',
                    url : '/rest/user/company_list',
                    params: {company_id: viewValue}
                })
                            .success(function (data, status, headers, config) {

                                if(angular.isObject(data)){
                                    ctrl.$setValidity('companyIdValidator', true);
                                }
                                else
                                {
                                    ctrl.$setValidity('companyIdValidator', false);
                                }

                            })
                            .error(function (data, status, headers, config) {
                                ctrl.$setValidity('companyIdValidator', false);
                            });
                    } else {
                        ctrl.$setValidity('companyIdValidator', false);
                    }
                }
                else {
                    ctrl.$setValidity('companyIdValidator', false);
                }
                return viewValue;
            });

        }
    };
})
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