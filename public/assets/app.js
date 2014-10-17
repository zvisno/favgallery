$(document).ready(function() {
  $('div.images-container img').click(function() {
    var url = $(this).attr("src")
    $.get('/details', {url: url}, function( data ) {
      $('div#detail' ).html( data );
    });
  });
  $(this).click(function() {
  $('div#detail').empty()
 });
});
