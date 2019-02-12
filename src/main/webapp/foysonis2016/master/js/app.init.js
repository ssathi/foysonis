/**
 * 
 * BeAdmin - Bootstrap Admin Theme - App Javascript
 * 
 * Author: @themicon_co
 * Website: http://themicon.co
 * License: http://support.wrapbootstrap.com/knowledge_base/topics/usage-licenses
 * 
 */

/**
 * Provides a start point to run plugins and other scripts
 */

  //Angular UI GRID
  /*
  var app = angular.module('app', ['ngTouch', 'ui.grid','ui.grid.exporter', 'ui.grid.selection']);
 
  app.controller('mainCtrl', ['$scope', '$http', '$interval', '$q', function ($scope, $http, $interval, $q) {
  var fakeI18n = function( title ){
    var deferred = $q.defer();
    $interval( function() {
      deferred.resolve( 'col: ' + title );
    }, 1000, 1);
    return deferred.promise;
  };

  $scope.myData = {
    exporterMenuCsv: false,
    enableGridMenu: true,
    enableSorting: false,
    enableRowSelection: true,
    enableSelectAll: true,
    selectionRowHeaderWidth: 35,
    rowHeight: 35,
    gridMenuTitleFilter: fakeI18n,
    columnDefs: [
      { name: 'name' },
      { name: 'gender', enableHiding: false },
      { name: 'company' }
    ],
    gridMenuCustomItems: [
      {
        title: 'Rotate Grid',
        action: function ($event) {
          this.grid.element.toggleClass('rotated');
        },
        order: 210
      }
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

  $http.get('http://ui-grid.info/data/100.json')
    .success(function(data) {
      $scope.myData.data = data;
    });

  }]);*/
/*
var app = angular.module('app', ['ngTouch', 'ui.grid', 'ui.grid.selection']);
app.controller('mainCtrl', ['$scope', '$http', '$log', '$timeout', 'uiGridConstants', function ($scope, $http, $log, $timeout, uiGridConstants) {
  $scope.gridOptions = {
    enableRowSelection: true,
    enableSelectAll: true,
    selectionRowHeaderWidth: 35,
    enableGridMenu: true,
    rowHeight: 35,
    showGridFooter:true
  };
 
  $scope.gridOptions.columnDefs = [
    { name: 'id' },
    { name: 'name'},
    { name: 'age', displayName: 'Age (not focusable)', allowCellFocus : false },
    { name: 'address.city' }
  ];
 
  $scope.gridOptions.multiSelect = true;
 
  $http.get('http://ui-grid.info/data/100.json')
    .success(function(data) {
      $scope.gridOptions.data = data;
      $timeout(function() {
        if($scope.gridApi.selection.selectRow){
          $scope.gridApi.selection.selectRow($scope.gridOptions.data[0]);
        }
      });
    });
 
    $scope.info = {};
 
    $scope.toggleMultiSelect = function() {
      $scope.gridApi.selection.setMultiSelect(!$scope.gridApi.grid.options.multiSelect);
    };
 
    $scope.toggleModifierKeysToMultiSelect = function() {
      $scope.gridApi.selection.setModifierKeysToMultiSelect(!$scope.gridApi.grid.options.modifierKeysToMultiSelect);
    };
 
    $scope.selectAll = function() {
      $scope.gridApi.selection.selectAllRows();
    };
 
    $scope.clearAll = function() {
      $scope.gridApi.selection.clearSelectedRows();
    };
 
    $scope.toggleRow1 = function() {
      $scope.gridApi.selection.toggleRowSelection($scope.gridOptions.data[0]);
    };
 
    $scope.toggleFullRowSelection = function() {
      $scope.gridOptions.enableFullRowSelection = !$scope.gridOptions.enableFullRowSelection;
      $scope.gridApi.core.notifyDataChange( uiGridConstants.dataChange.OPTIONS);
    };
 
    $scope.setSelectable = function() {
      $scope.gridApi.selection.clearSelectedRows();
 
      $scope.gridOptions.isRowSelectable = function(row){
        if(row.entity.age > 30){
          return false;
        } else {
          return true;
        }
      };
      $scope.gridApi.core.notifyDataChange(uiGridConstants.dataChange.OPTIONS);
 
      $scope.gridOptions.data[0].age = 31;
      $scope.gridApi.core.notifyDataChange(uiGridConstants.dataChange.EDIT);
    };
 
    $scope.gridOptions.onRegisterApi = function(gridApi){
      //set gridApi on scope
      $scope.gridApi = gridApi;
      gridApi.selection.on.rowSelectionChanged($scope,function(row){
        var msg = 'row selected ' + row.isSelected;
        $log.log(msg);
      });
 
      gridApi.selection.on.rowSelectionChangedBatch($scope,function(rows){
        var msg = 'rows changed ' + rows.length;
        $log.log(msg);
      });
    };
}]);*/

var app = angular.module('app', ['ngTouch', 'ui.grid', 'ui.grid.exporter', 'ui.grid.selection', 'ui.grid.pagination']);
 
app.controller('mainCtrl', ['$scope', '$http', '$interval', '$q', function ($scope, $http, $interval, $q) {
  var fakeI18n = function( title ){
    var deferred = $q.defer();
    $interval( function() {
      deferred.resolve( 'col: ' + title );
    }, 1000, 1);
    return deferred.promise;
  };

  $scope.gridOptions = {
    exporterMenuCsv: false,
    enableGridMenu: true,
    minRowsToShow: 10,
    rowHeight: 47,
    enableVerticalScrollbar: 0,
    enableHorizontalScrollbar: 0,
    selectionRowHeaderWidth: 70,
    paginationPageSizes: [10, 50, 75],
    paginationPageSize: 10,  
    gridMenuTitleFilter: fakeI18n,
    columnDefs: [
      { name: 'Id', width: 100},
      { name: 'Barcode'},
      { name: 'Travel Seq'},
      { name: 'Is Blocked?'},
      { name: 'Settings', enableColumnMenu: false, cellTemplate:'<div class="ui-grid-cell-contents ng-binding ng-scope">{{ row.entity[col.field] | limitTo:25 }} <i data-toggle="tooltip" data-placement="bottom" title="Tooltip on bottom" class="icon icon-settings"></i></div>' }
    ],
    gridMenuCustomItems: [
      {
        title: 'Rotate Grid',
        action: function ($event) {
          this.grid.element.toggleClass('rotated');
        },
        order: 210
      }
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
 
  $http.get('/app/json/100.json')
    .success(function(data) {
      $scope.gridOptions.data = data;
    });
}]);
$(function () {
  $('[data-toggle="tooltip"]').tooltip();
})
(function($, window, document){
  'use strict';
 
  if (typeof $ === 'undefined') { throw new Error('This application\'s JavaScript requires jQuery'); }

  $(window).load(function() {

    $('.scroll-content').slimScroll({
        height: '250px'
    });

    adjustLayout();

  }).resize(adjustLayout);


  $(function() {

    $('.tooltip').tooltip();//tooltip init
    // Init Fast click for mobiles
    FastClick.attach(document.body);

    // inhibits null links
    $('a[href="#"]').each(function(){
      this.href = 'javascript:void(0);';
    });

    // abort dropdown autoclose when exist inputs inside
    $(document).on('click', '.dropdown-menu input', function(e){
      e.stopPropagation();
    });

    // popover init
    $('[data-toggle=popover]').popover();

    // Bootstrap slider
    $('.slider').slider();

    // Chosen
    $('.chosen-select').chosen();

    // Filestyle
    $('.filestyle').filestyle();

    // Masked inputs initialization
    $.fn.inputmask && $('[data-toggle="masked"]').inputmask();

    var SelectorToggleClass  = '.nav-wrapper .nav .back-item';

    $('aside.aside ul.nav').mouseenter(function(){
      if(!$(this).hasClass("prevent-hover")){
        $('body').removeClass('aside-collapsed');
      }
    }).mouseleave(function(){
      if(!$(this).hasClass("prevent-hover")){
        $('body').addClass('aside-collapsed');
      } 
    });

    //Toggle icon menu
    $(document).on('click', '.nav-wrapper .nav .back-item', function (e) {
      e.preventDefault();

      if($(this).find('em').hasClass('icon-right')){
        $('aside.aside ul.nav').addClass('prevent-hover');
        $(this).find('em').removeClass('icon-right').addClass('icon-left');
      }
      else{
        $('aside.aside ul.nav').removeClass('prevent-hover');
        $(this).find('em').removeClass('icon-left').addClass('icon-right');
      }
   });

  });

  // keeps the wrapper covering always the entire body
  // necessary when main content doesn't fill the viewport
  function adjustLayout() {
    $('.wrapper > section').css('min-height', $(window).height());
  }

}(jQuery, window, document));
