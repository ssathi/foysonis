(function(){
    'use strict';
    var $timeout, $filter, AutoComplete;

    var showLoading = function(ulEl, show) {
        if (show) {
            ulEl.innerHTML = '<li class="loading"> Loading </li>';
        } else {
            ulEl.querySelector('li.loading') &&
            ulEl.querySelector('li.loading').remove();
        }
    };

    
    var defaultListFormatter = function(obj, scope) {

        if (obj[scope.companyNameProperty] == undefined && obj[scope.shippingStreetAddressProperty] == undefined  && obj[scope.shippingCityProperty] == undefined && obj[scope.shippingStateProperty] == undefined && obj[scope.shippingPostCodeProperty] == undefined && obj[scope.shippingCountryProperty] == undefined) {
            return obj[scope.customerNameProperty]
        }
        else if (obj[scope.companyNameProperty] == undefined && obj[scope.shippingStreetAddressProperty] != undefined  && obj[scope.shippingCityProperty] == undefined && obj[scope.shippingStateProperty] == undefined && obj[scope.shippingPostCodeProperty] == undefined && obj[scope.shippingCountryProperty] == undefined) {
            return "<span style='font-size: 15px;'>"+ obj[scope.customerNameProperty] + "</span>"+"<br/><span style='font-weight: normal; font-size: 11px;'>"+obj[scope.shippingStreetAddressProperty]+"</span>";
        }
        else{

            if (obj[scope.shippingStreetAddressProperty] == null ) {
                obj[scope.shippingStreetAddressProperty] = '';
            }
            if (obj[scope.shippingCityProperty] == null ) {
                obj[scope.shippingCityProperty] = '';
            }
            if (obj[scope.shippingStateProperty] == null ) {
                obj[scope.shippingStateProperty] = '';
            }
            if (obj[scope.shippingPostCodeProperty] == null ) {
                obj[scope.shippingPostCodeProperty] = '';
            }
            if (obj[scope.shippingCountryProperty] == null ) {
                obj[scope.shippingCountryProperty] = '';
            }


            return "<span style='font-size: 15px;'><b>"+ obj[scope.customerNameProperty] + "</b></span>"+"&nbsp;-&nbsp;<span style='font-weight: normal; font-size: 11px;'>"+obj[scope.companyNameProperty]+
            "<br/>"+obj[scope.shippingStreetAddressProperty]+",&nbsp;"+obj[scope.shippingCityProperty]+
            ",&nbsp;"+obj[scope.shippingStateProperty]+","+obj[scope.shippingPostCodeProperty]+
            "<br/>"+obj[scope.shippingCountryProperty]+"</span>";  
        }                                
        

    };

    var addListElements = function(scope, data) {
        var ulEl = scope.ulEl;
        var getLiEl = function(el) {
            if (el[scope.companyNameProperty] != undefined ) {
                var viewValue = typeof el == 'object' ? el[scope.customerNameProperty]+' - '+el[scope.companyNameProperty] : el;
            }
            else{
                var viewValue = typeof el == 'object' ? el[scope.customerNameProperty] : el;
            }
            
            //var viewValue2 = typeof el == 'object' ? el[scope.companyNameProperty] : el;
            var modelValue = typeof el == 'object' ? el[scope.companyNameProperty] : el;
            var liEl = document.createElement('li');
            if (scope.listFormatter && typeof el == 'object') {
                liEl.innerHTML = scope.listFormatter(el);
            } else if (typeof el == 'object') {
                liEl.innerHTML = defaultListFormatter(el, scope);
            } else {
                liEl.innerHTML = viewValue;
                liEl.innerHTML = viewValue1;
                //liEl.innerHTML = viewValue2;
            }
            liEl.model = el;
            liEl.modelValue = modelValue;
            liEl.viewValue = viewValue;
            return liEl;
        };
        if (scope.placeholder &&
            !scope.multiple &&
            scope.controlEl.tagName == 'SELECT') {
            ulEl.appendChild(getLiEl(scope.placeholder));
        }
        data.forEach(function(el) {
            ulEl.appendChild(getLiEl(el));
        });
    };

    var delay = (function(){
        var timer = 0;
        return function(callback, ms){
            $timeout.cancel(timer);
            timer = $timeout(callback, ms);
        };
    })();

    var loadList = function(scope) {
        var inputEl = scope.inputEl, ulEl = scope.ulEl;
        while(ulEl.firstChild) {
            ulEl.removeChild(ulEl.firstChild);
        }
        if (scope.source.constructor.name == 'Array') { // local source
            var filteredData = $filter('filter')(scope.source, inputEl.value);
            ulEl.style.display = 'block';
            addListElements(scope, filteredData);
        } else { // remote source
            ulEl.style.display = 'none';
            if (inputEl.value.length >= (scope.minChars||0)) {
                ulEl.style.display = 'block';
                showLoading(ulEl, true);
                AutoComplete.getRemoteData(
                    scope.source, {keyword: inputEl.value}, scope.pathToData).then(
                    function(data) {
                        showLoading(ulEl, false);
                        addListElements(scope, data);
                        var selected = scope.ulEl.querySelector('.selected');
                        scope.ulEl.style.display = 'block';
                        if (selected && selected.nextSibling) {
                            selected.className = '';
                            selected.nextSibling.className = 'selected';
                        } else if (!selected) {
                            scope.ulEl.firstChild.className = 'selected';
                        }
                    }, function(){
                        showLoading(ulEl, false);
                    });
            } // if
        } // else remote source
    };

    var hideAutoselect = function(scope) {
        var elToHide = scope.multiple ? scope.ulEl : scope.containerEl;
        elToHide.style.display = 'none';
    };

    var focusInputEl = function(scope) {
        scope.ulEl.style.display = 'block';
        scope.inputEl.focus();
        scope.inputEl.value = '';
        loadList(scope);
    };

    var inputElKeyHandler = function(scope, keyCode, eventParam) {
        var selected = scope.ulEl.querySelector('.selected');
        switch(keyCode) {
            case 27: // ESC
                selected.className = '';
                hideAutoselect(scope);
                break;
            case 38: // UP
                if (selected.previousSibling) {
                    selected.className = '';
                    selected.previousSibling.className = 'selected';
                }
                break;
            case 40: // DOWN
                scope.ulEl.style.display = 'block';
                if (selected && selected.nextSibling) {
                    selected.className = '';
                    selected.nextSibling.className = 'selected';
                } else if (!selected) {
                    scope.ulEl.firstChild.className = 'selected';
                }
                break;
            case 13: // ENTER
                eventParam.preventDefault();
                var isItemField = scope.containerEl.parentElement.children[0].id;
                if (isItemField.indexOf('itemId') >= 0 ) {
                    setTimeout(function() { 
                        var childrenElements = scope.ulEl.children;
                        if (childrenElements.length == 1) {
                            selected = scope.ulEl.querySelector('.selected');
                            selected && scope.select(selected);                        
                        }
                    }, 1500);

                }
                else{
                    setTimeout(function() { 
                        selected = scope.ulEl.querySelector('.selected');
                        selected && scope.select(selected);              
                    }, 1500);
                }
                break;
            case 8: // BACKSPACE
                    // remove the last element for multiple and empty input
                if (scope.multiple && scope.inputEl.value === '') {
                    $timeout(function() {
                        scope.ngModel.pop();
                    });
                }
                break;
            case 9: // ENTER
                selected && scope.select(selected);
                break;
        }
    };

    var linkFunc = function(scope, element, attrs) {
        var inputEl, ulEl, containerEl;

        scope.containerEl = containerEl = element[0];
        scope.inputEl = inputEl = element[0].querySelector('input');
        scope.ulEl = ulEl = element[0].querySelector('ul');
        inputEl.setAttribute("tabindex", "-1");

        var parentEl, controlEl, placeholderEl;
        if (scope.multiple) {
            parentEl = element[0].parentElement.parentElement; //acDiv->wrapper->acMulti
            scope.controlEl = controlEl = parentEl.querySelector('select');
        } else {
            parentEl = element[0].parentElement;
            scope.controlEl = controlEl = parentEl.querySelector('input, select');
            placeholderEl = parentEl.querySelector('.select-placeholder');
        }

        if (controlEl && !scope.multiple) {
            controlEl.readOnly = true;

            if (controlEl.tagName == 'SELECT') {

                var controlBCR = controlEl.getBoundingClientRect();
                placeholderEl.style.lineHeight = controlBCR.height + 'px';

                if (scope.prefillFunc) {
                    scope.prefillFunc().then(function(html) {
                        placeholderEl.innerHTML = html;
                    });
                }

                if (attrs.ngModel) {
                    scope.$parent.$watch(attrs.ngModel, function(val) {
                        !val && (placeholderEl.innerHTML = attrs.placeholder);
                    });

                }

                controlEl.addEventListener('mouseover', function() {
                    for (var i=0; i<controlEl.children.length; i++) {
                        controlEl.children[i].style.display = 'none';
                    }
                });
                controlEl.addEventListener('mouseout', function() {
                    for (var i=0; i<controlEl.children.length; i++) {
                        controlEl.children[i].style.display = '';
                    }
                });

            }

            controlEl.addEventListener('focus', function() {
                if (!controlEl.disabled) {
                    containerEl.style.display = 'block';
                    var controlBCR = controlEl.getBoundingClientRect();
                    containerEl.style.width = controlBCR.width + 'px';
                    inputEl.style.width = (controlBCR.width - 30) + 'px';
                    inputEl.style.height = controlBCR.height + 'px';
                    inputEl.focus();
                }
            });

        } else if (scope.multiple) {

            scope.prefillFunc && scope.prefillFunc();

            parentEl.addEventListener('click', function() {
                if (controlEl) {
                    inputEl.disabled = controlEl.disabled;
                    if (!controlEl.disabled) {
                        containerEl.style.display = 'inline-block';
                        inputEl.focus();
                    }
                }
            });
        }

        // add default class css to head tag
        if (scope.defaultStyle !== false) {
            containerEl.className += ' default-style';
            AutoComplete.injectDefaultStyle();
        }

        scope.select = function(liEl) {
            liEl.className = '';
            hideAutoselect(scope);
            $timeout(function() {
                if (attrs.ngModel) {
                    if (scope.multiple) {
                        if (!scope.ngModel) {
                            scope.ngModel = [];
                        }
                        scope.ngModel.push(liEl.model);
                    } else if (controlEl) {
                        if (controlEl.tagName == 'INPUT') {
                            //scope.ngModel = liEl.innerHTML ;
                            scope.ngModel = liEl.viewValue ;
                        } else if (controlEl.tagName == 'SELECT') {
                            scope.ngModel = liEl.modelValue;

                            if (scope.listFormatter && typeof liEl.model == 'object') {
                                placeholderEl.innerHTML = scope.listFormatter(liEl.model);
                            } else {
                                placeholderEl.innerHTML = liEl.viewValue;
                            }
                        }
                    } else {
                        scope.ngModel = liEl.modelValue;
                    }
                }
                inputEl.value = '';
                scope.valueChanged({value: liEl.model}); //user scope
            });
        };

        inputEl.addEventListener('focus', function() {
            if (controlEl) {
                !controlEl.disabled && focusInputEl(scope);
            } else {
                focusInputEl(scope);
            }
        });

        inputEl.addEventListener('blur', function() {
            hideAutoselect(scope);
        }); // hide list

        inputEl.addEventListener('keydown', function(evt) {
            inputElKeyHandler(scope, evt.keyCode, evt);
        });

        ulEl.addEventListener('mousedown', function(evt) {
            if (evt.target !== ulEl) {
                var liTag = evt.target;
                while(liTag.tagName !== 'LI') {
                    liTag = liTag.parentElement;
                }

                // Select only if it is a <li></li> and the class is not 'loading'
                if(liTag.tagName == 'LI' && liTag.className != "loading"){
                    scope.select(liTag);
                }
            }
        });

        /** when enters text to search, reload the list */
        inputEl.addEventListener('input', function() {
            var delayMs = scope.source.constructor.name == 'Array' ? 10 : 500;
            delay(function() { //executing after user stopped typing
                loadList(scope);
            }, delayMs);

            if (scope.multiple) {
                inputEl.setAttribute('size', inputEl.value.length+1);
            }
        });

    };

    var autoCompleteDiv =
        function(_$timeout_, _$filter_, _AutoComplete_) {
            $timeout = _$timeout_;
            $filter = _$filter_;
            AutoComplete = _AutoComplete_;

            return {
                restrict: 'E',
                scope: {
                    ngModel: '=',
                    source: '=',
                    minChars: '=',
                    multiple: '=',
                    defaultStyle: '=',
                    listFormatter: '=',
                    pathToData: '@',
                    customerNameProperty: '@',
                    companyNameProperty:'@',
                    shippingStreetAddressProperty:'@',
                    shippingCityProperty:'@',
                    shippingStateProperty:'@',
                    shippingPostCodeProperty:'@',
                    shippingCountryProperty:'@',
                    placeholder: '@',
                    prefillFunc: '&',
                    valueChanged: '&'
                },
                link: linkFunc
            };
        };
    autoCompleteDiv.$inject = ['$timeout', '$filter', 'AutoComplete'];

    angular.module('inventory-autocomplete').
        directive('autoCompleteDiv', autoCompleteDiv);
})();
