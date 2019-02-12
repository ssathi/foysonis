
$(document).ready(function () {
  $(document).on("scroll", scrollToId);

  $('.sidebar .nav > li > a').on('click', function(event) {
      event.preventDefault();
      $(document).off("scroll");

      $('.sidebar .nav > li > a').removeClass('active');
      $('.sidebar .nav > li > a').children('img.imgDefault').removeClass('hide');
      $('.sidebar .nav > li > a').children('img.imgAcive').addClass('hide');
      $('.sidebar .nav > li > a').children('img.imgAcive.hide').removeClass('imgAcive');    
      $(this).addClass('active');

      $(this).children('img.hide').addClass('imgAcive');
      $(this).children('img.hide.imgAcive').removeClass('hide');
      $(this).children('img.imgDefault').addClass('hide');

      var scrollId = $(this)[0].getAttribute("href");
      var offsets = $(scrollId).offset();
      var position = offsets.top;
      window.scrollTo(0, position - 130);

  });
});

// $(window).on('scroll', function() {
//     $('.guide-content').each(function() {
//         if($(window).scrollTop() >= $(this).offset().top) {
//             // var id = $(this).attr('id');
//             // $('.sidebar .nav > li > a').removeClass('active');
//             // $('.sidebar .nav > li > a').children('img.imgDefault').removeClass('hide');
//             // $('.sidebar .nav > li > a').children('img.imgAcive').addClass('hide');
//             // $('.sidebar .nav > li > a').children('img.imgAcive.hide').removeClass('imgAcive');
//             // $('.sidebar .nav > li > a[href=#'+ id +']').addClass('active');
//             // $('.sidebar .nav > li > a[href=#'+ id +']').children('img.hide').addClass('imgAcive');
//             // $('.sidebar .nav > li > a[href=#'+ id +']').children('img.hide.imgAcive').removeClass('hide');
//             // $('.sidebar .nav > li > a[href=#'+ id +']').children('img.imgDefault').addClass('hide');

//             //console.log($('.sidebar .nav > li > a[href=#'+ id +']').parent().prev().children('a'));
//             //var idTarget = $('.sidebar .nav > li > a[href=#'+ id +']').attr('data-target');
//             //$(idTarget).collapse('show');
//             // if ($('.sidebar .nav > li > a[href=#'+ id +']').parent().find('ul').length == 1) {
//             //   $('.sidebar .nav > li > a[href=#'+ id +']').parent().find('ul').addClass('in');
//             // } 
                     
//         }
//     });
// });

function scrollToId (){
    $('.guide-content').each(function() {
        if($(window).scrollTop() >= $(this).offset().top) {
            var id = $(this).attr('id');
            $('.sidebar .nav > li > a').removeClass('active');
            $('.sidebar .nav > li > a').children('img.imgDefault').removeClass('hide');
            $('.sidebar .nav > li > a').children('img.imgAcive').addClass('hide');
            $('.sidebar .nav > li > a').children('img.imgAcive.hide').removeClass('imgAcive');
            $('.sidebar .nav > li > a[href=#'+ id +']').addClass('active');
            $('.sidebar .nav > li > a[href=#'+ id +']').children('img.hide').addClass('imgAcive');
            $('.sidebar .nav > li > a[href=#'+ id +']').children('img.hide.imgAcive').removeClass('hide');
            $('.sidebar .nav > li > a[href=#'+ id +']').children('img.imgDefault').addClass('hide');

            var idTarget = $('.sidebar .nav > li > a[href=#'+ id +']').attr('data-target');
            $(idTarget).collapse('show');
        }
    });
}

  $('#navToggleBtn').on('click', function(event) {
      //$(this).parent().find('a').removeClass('active');
      if ($('#foyNav').hasClass("bar-collapse")) {
        $('#foyNav').removeClass('bar-collapse');
      }
      else{
        $('#foyNav').addClass('bar-collapse');
      }
  });


$(function() {

  // the input field
  var $input = $("input[id='findGuide']"),
    // clear button
    //$clearBtn = $("button[data-search='clear']"),
    //prev button
    $prevBtn = $("#prevBtnSearch"),
    //next button
    $nextBtn = $("#nextBtnSearch"),
    // the context where to search
    $content = $(".content-container"),
    // jQuery object to save <mark> elements
    $results,
    // the class that will be appended to the current
    // focused element
    currentClass = "current",
    // top offset for the jump (the search bar)
    offsetTop = 50,
    // the current index of the focused element
    currentIndex = 0;

  /**
   * Jumps to the element matching the currentIndex
   */
  function jumpTo() {
    if ($results.length) {
      var position,
        $current = $results.eq(currentIndex);
      $results.removeClass(currentClass);
      if ($current.length) {
        $current.addClass(currentClass);
        position = $current.offset().top - offsetTop;
        window.scrollTo(0, position-200);
      }
    }
  }

  /**
   * Searches for the entered keyword in the
   * specified context on input
   */
  // $input.on("input", function() {
  //   $(document).off("scroll");
  //   var searchVal = this.value;
  //   setTimeout(function(){
  //     $content.unmark({
  //       done: function() {
  //         $content.mark(searchVal, {
  //           separateWordSearch: false,
  //           done: function() {
  //             $results = $content.find("mark");
  //             currentIndex = 0;
  //             jumpTo();
  //           }
  //         });
  //       }
  //     });
  //   }, 2000)
  // });

$("input[id='findGuide']").on("keydown", function(event) {
  $(document).off("scroll");
  if (event.keyCode === 13) {
    var searchVal = $("#findGuide").val();
      $content.unmark({
        done: function() {
          $content.mark(searchVal, {
            separateWordSearch: false,
            done: function() {
              $results = $content.find("mark");
              currentIndex = 0;
              jumpTo();
            }
          });
        }
      });
  }

});

  /**
   * Clears the search
   */
  $('#clearSearch').on("click", function() {
    $content.unmark();
    $input.val("").focus();
  });

  /**
   * Next and previous search jump to
   */
  $nextBtn.add($prevBtn).on("click", function() {
    if ($results && $results.length) {
      currentIndex += $(this).is($prevBtn) ? -1 : 1;
      if (currentIndex < 0) {
        currentIndex = $results.length - 1;
      }
      if (currentIndex > $results.length - 1) {
        currentIndex = 0;
      }
      jumpTo();
    }
  });
});