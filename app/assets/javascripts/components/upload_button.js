// auto submission of avatar images after selecting a file

$(document).on('turbolinks:load', function() {
  $('#loading-text').hide();
  $('.upload-btn').hide();

  $('.upload-btn').change(function() {
    $('#loading-text').show();
    $('#avatar-form').submit();
    $('#loading-text').show();
  });
});
