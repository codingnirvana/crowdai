$(document).on('turbolinks:load', function() {
  /* --------------------------------- articles  ---------------------------------------- */
  if (!_.isEmpty(gon) && gon.rails.controller == 'articles') {
    expandSidebar();
  }
});
