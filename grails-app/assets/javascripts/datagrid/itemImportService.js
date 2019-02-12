/**
 * Created by User on 12-Aug-16.
 */

angular.module('itemImportService', [])
    .factory('itemImpService', ['$http', '$timeout','$q', function($http, $timeout, $q) {


        var checkItemExist = function(itemId){
            var defer = $q.defer();

            $http({
                method: 'GET',
                url : '/item/checkItemIdExist',
                params: {itemId: itemId}
            })
                .success(function (data) {
                    defer.resolve(data);
                });

            return defer.promise;
        };


        return {
            checkItemExist: checkItemExist
        };


    }]);
