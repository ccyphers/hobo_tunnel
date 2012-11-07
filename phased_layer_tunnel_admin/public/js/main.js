require.config({
  paths: {
    jquery: 'libs/jquery/jquery-min',
    underscore: 'libs/underscore/underscore-min',
    backbone: 'libs/backbone/backbone-optamd3-min',
    text: 'libs/require/text',
    templates: '/../templates',
    multi_d_and_d: 'common/multi_d_and_d',
    delete_users: 'common/delete_users'
  }
});

require(['app'], function(App){
  App.initialize();

  // Default to users view.  It would be good and add a feature which
  // preserve's the state if the user refreses the browser; they would expect
  // to refresh the data for which the tab they are currently on when refreshing.
  window.location.href='#users'
  var $tabs = $( "#tabs" ).tabs({
    beforeActivate: function(event, ui) {
      window.location.href='#' + ui.newTab.find('a')[0].innerText.toLowerCase();
    }
  });

  $('#tab-1').attr('class', "ui-widget-content ui-corner-bottom")
  $('#tab-2').attr('class', "ui-widget-content ui-corner-bottom")
  $('#tab-3').attr('class', "ui-widget-content ui-corner-bottom")

  /*
  var $tab_items = $( "ul:first li", $tabs ).droppable({
      accept: ".connectedSortable li",
      hoverClass: "ui-state-hover",
      drop: function( event, ui ) {
        console.log(ui);
        var $item = $( this );
        var $list = $( $item.find( "a" ).attr( "href" ) ).find( ".connectedSortable" );
        ui.draggable.hide( "slow", function() {
          $(this).appendTo( $list ).show( "slow" );
          ui.draggable.show();
        });
      }
  });
  */
});
