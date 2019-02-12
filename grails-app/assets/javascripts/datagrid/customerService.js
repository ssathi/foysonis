/**
 * Created by home on 1/11/16.
 */
angular.module('customerService', [])
    .factory('cusService', ['$http', '$timeout','$q', function($http, $timeout, $q) {

        var checkAdminUserLoggedIn = function(){
            var defer = $q.defer();

            $http({
                method: 'GET',
                url: '/user/getCurrentUser'
            })
                .success(function (data) {
                    defer.resolve(data);
                });

            return defer.promise;
        };

        return {
            checkAdminUserLoggedIn: checkAdminUserLoggedIn
        };


    }]);