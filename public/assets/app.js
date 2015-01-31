$(document).ready(function() {
    $('div.images-container img').click(function() {
        var url = $(this).attr("src");
        $.get('/details', {url: url}, function( data ) {
          $('div#detail' ).html( data );

          $('#delete_img').on('click', function(e) {
            var filename = url.split("brnzk")[1];
            e.stopPropagation();

            $("img[src*='" + filename + "']").remove();
            $.post('/delete', {filename: filename}, function(){
              console.log(url);
            });
          });
        });
    });

    $(this).click(function(e) {
      $('div#detail').empty()
    });
});
