/**=========================================================
 * Module: toggle-state.js
 * Toggle a classname from the BODY Useful to change a state that 
 * affects globally the entire layout or more than one item 
 * Targeted elements must have [data-toggle="CLASS-NAME-TO-TOGGLE"]
 =========================================================*/

(function($, window, document){
  'use strict';

  var SelectorToggle  = '[data-toggle-state]',
  	  SelectorToggleClass = '[data-toggle-class]',
      $body = $('body');

  /* Toggle State */
  $(document).on('click', SelectorToggle, function (e) {
      e.preventDefault();
      var classname = $(this).data('toggleState');
      
      if(classname)
        $body.toggleClass(classname);

  });

  /* Toggle Class */
  $(document).on('click', SelectorToggleClass, function (e) {
      e.preventDefault();
      var classname = $(this).data('toggleClass');
      
      if($(this).hasClass(classname)){
      	$(this).removeClass(classname);
      }
      else{
      	$(this).addClass(classname);
      }
  });



}(jQuery, window, document));
