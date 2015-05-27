$(document).ready(function() {
    $('div.images-container img').click(function() {
        var url = $(this).attr("src");
        $.get('/details', {url: url}, function( data ) {
          $('p#detail' ).html( data );

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

    $(document).click(function(e){
        var posX = e.clientX - 12.5,
          posY = e.clientY - 12.5;
        document.getElementById('image').style.top = posY + "px";
        document.getElementById('image').style.left = posX + "px";

        $("img#image").hide().fadeIn(1000);
    });
});
