$(document).ready(function() {
  var limit = 300;
  var more = " &hellip; ";
  var less = " &larr; ";

  $('.blog-entry').each(function(){
    var content = $(this).html();
    if (content.length > limit){
      var c = content.substr(0,limit);
      var h = content.substr(limit - 1, content.length - limit);

      var html = c + '<span class="more-content"> <span>' + h + '</span> <a href="#" class="more-link">' + more + '</a></span>';

      $(this).html(html);
    }

  });

  $(".more-link").click(function() {
    if($(this).hasClass("less")) {
      $(this).removeClass("less");
      $(this).html(more);
    } else {
      $(this).addClass("less");
      $(this).html(less);
    }

    $(this).prev().toggle();
    return false;
  });

  $('p#upload').click(function(){
    $.get('/upload')
  })

});