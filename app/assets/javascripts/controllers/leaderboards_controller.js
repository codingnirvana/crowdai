$(document).on('turbolinks:load', function() {
  /* --------------------------------- leaderboards / index --------------------------------------- */
  if (!_.isEmpty(gon) && gon.rails.controller == 'leaderboards' && gon.rails.action == 'index') {
    expandSidebar();
    adjustProgress(gon.percent_progress);
    adjustText(gon.percent_progress);
  } /* leaderboards / index */
});
