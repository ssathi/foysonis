/**=========================================================
 * Module: load-css.js
 * Request and load into the current page a css file
 =========================================================*/

(function($, window, document){
  'use strict';

  var Selector = '[data-toggle="load-css"]';

  $(document).on('click', Selector, function (e) {
      e.preventDefault();
      var uri = $(this).data('uri'),
          link;

      if(uri) {
        link = createLink();
        if(link) {
          injectStylesheet(link, uri);
        }
        else {
          $.error('Error creating new stylsheet link element.');
        }
      }
      else {
        $.error('No stylesheet location defined.');
      }

  });

  function createLink() {
    var linkId = 'autoloaded-stylesheet',
        link = $('#'+linkId);

    if( ! link.length ) {
      var newLink = $('<link rel="stylesheet">').attr('id', linkId);
      $('head').append(newLink);
      link = $('#'+linkId);
    }
    return link;
  }

  function injectStylesheet(element, uri) {
    var v = '?id='+Math.round(Math.random()*10000); // forces to jump cache
    if(element.length) {
      element.attr('href', uri + v);
    }
  }

}(jQuery, window, document));
