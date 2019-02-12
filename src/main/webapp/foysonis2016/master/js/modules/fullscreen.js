/**=========================================================
 * Module: fullscreen.js
 * Removes a key from the browser storage via element click
 =========================================================*/

(function($, window, document){
  'use strict';

  if( !screenfull ) return;

  var Selector = '[data-toggle="fullscreen"]';

  $(document).on('click', Selector, function (e) {
      e.preventDefault();

      if (screenfull.enabled) {
        
        screenfull.toggle();
        
        // Switch icon indicator
        if(screenfull.isFullscreen)
          $(this).children('em').removeClass('fa-expand').addClass('fa-compress');
        else
          $(this).children('em').removeClass('fa-compress').addClass('fa-expand');

      } else { /*Ignore or do something else*/ }

  });

}(jQuery, window, document));
