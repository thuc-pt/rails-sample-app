setTimeout(function() {
  $('.alert').fadeOut(500);
}, 5000);

window.onload = function() {
  $('.custom-file-input').on('change', function() {
    var file = $(this).val().split('\\').pop();
    $(this).siblings('.custom-file-label').addClass('selected').html(file);
  });
}
