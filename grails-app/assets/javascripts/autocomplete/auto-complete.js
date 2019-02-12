(function(){
  'use strict';

  // return dasherized from  underscored/camelcased string
  var dasherize = function(string) {
    return string.replace(/_/g, '-').
      replace(/([a-z])([A-Z])/g, function(_,$1, $2) {
        return $1+'-'+$2.toLowerCase();
      });
  };

  // accepted attributes
  var autoCompleteAttrs = [
    'placeholder', 'multiple', 'listFormatter', 'prefillFunc',
    'ngModel', 'valueChanged', 'source', 'pathToData', 'minChars',
    'defaultStyle', 'usernameProperty', 'firstNameProperty','lastNameProperty', 'locationIdProperty','customerNameProperty','companyNameProperty','shippingStreetAddressProperty','shippingCityProperty','shippingStateProperty','shippingPostCode','shippingPostCodeProperty','shippingCountryProperty'
  ];  

  // build autocomplet-div tag with input and select
  var buildACDiv = function(attrs) {
    var acDiv = document.createElement('auto-complete-div');

    var inputEl = document.createElement('input');
    attrs.ngDisabled &&
      inputEl.setAttribute('ng-disabled', attrs.ngDisabled);
    acDiv.appendChild(inputEl);

    var ulEl = document.createElement('ul');
    acDiv.appendChild(ulEl);

    autoCompleteAttrs.map(function(attr) {
      attrs[attr] && acDiv.setAttribute(dasherize(attr), attrs[attr]);
    });
    acDiv.style.position = 'absolute';
    acDiv.style.top = 0;
    acDiv.style.left = 0;
    acDiv.style.display = 'none';
    return acDiv;
  };

  var compileFunc = function(element, attrs)  {
    element[0].style.position = 'relative';

    var controlEl = element[0].querySelector('input, select');

    attrs.usernameProperty = attrs.usernameProperty || 'username';
    attrs.firstNameProperty = attrs.firstNameProperty || 'firstName';
    attrs.lastNameProperty = attrs.lastNameProperty || 'lastName';
    attrs.ngModel = controlEl.getAttribute('ng-model');

    if (controlEl.tagName == 'SELECT') {
      var placeholderEl = document.createElement('div');
      placeholderEl.className = 'select-placeholder';
      element[0].appendChild(placeholderEl);
    }

    var acDiv = buildACDiv(attrs);
    element[0].appendChild(acDiv);
  }; // compileFunc

  var compileInventoryFunc = function(element, attrs)  {
    element[0].style.position = 'relative';

    var controlEl = element[0].querySelector('input, select');

    attrs.locationIdProperty = attrs.locationIdProperty || 'locationId';
    attrs.customerNameProperty = attrs.customerNameProperty || 'contactName';
    attrs.companyNameProperty = attrs.companyNameProperty || 'companyName';
    attrs.shippingStreetAddressProperty = attrs.shippingStreetAddressProperty || 'shippingStreetAddress';
    attrs.shippingCityProperty = attrs.shippingCityProperty || 'shippingCity';
    attrs.shippingStateProperty = attrs.shippingStateProperty || 'shippingState';
    attrs.shippingPostCodeProperty = attrs.shippingPostCodeProperty || 'shippingPostCode';
    attrs.shippingCountryProperty = attrs.shippingCountryProperty || 'shippingCountry';
    attrs.ngModel = controlEl.getAttribute('ng-model');

    if (controlEl.tagName == 'SELECT') {
      var placeholderEl = document.createElement('div');
      placeholderEl.className = 'select-placeholder';
      element[0].appendChild(placeholderEl);
    }

    var acDiv = buildACDiv(attrs);
    element[0].appendChild(acDiv);
  }; // InventorycompileFunc

  angular.module('angularjs-autocomplete',['ngSanitize']);
  angular.module('angularjs-autocomplete').
      directive('autoComplete', function() {
        return {
          compile: compileFunc,
        };
      });
  angular.module('inventory-autocomplete',['ngSanitize']);
  angular.module('inventory-autocomplete').
      directive('autoComplete', function() {
        return {
          compile: compileInventoryFunc,
        };
      });
})();

