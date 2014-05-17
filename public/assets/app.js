$(document).ready(function() {
  $('div.container img').click(function() { 
    var url = $(this).attr("src")
    $.get('/details', {url: url}, function( data ) {
      $("div#detail" ).html( data );
});
 });
});
