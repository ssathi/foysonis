/**=========================================================
 * Module: toggle-state.js
 * Toggle a classname from the BODY Useful to change a state that 
 * affects globally the entire layout or more than one item 
 * Targeted elements must have [data-toggle="CLASS-NAME-TO-TOGGLE"]
 =========================================================*/

(function($, window, document){
  'use strict';

  var SelectorToggle  = '[data-toggle-state]',
      $body = $('body');

  $(document).on('click', SelectorToggle, function (e) {
      e.preventDefault();
      var classname = $(this).data('toggleState');
      
      if(classname)
        $body.toggleClass(classname);

  });



}(jQuery, window, document));
