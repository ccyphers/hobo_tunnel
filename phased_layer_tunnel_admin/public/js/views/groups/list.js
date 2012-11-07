// Filename: views/projects/list
define([
  'jquery',
  'underscore',
  'backbone',
  'collections/groups',
  'text!templates/groups/list.html'
], function($, _, Backbone, Groups, groupListTemplate){
  var groupListView = Backbone.View.extend({
    el: $("#groups_list"),
    initialize: function(){
      $('#submit_new_group').click(function() {
        $.ajax({ url: '/group/new', dataType: 'json', type: 'post', data: $('#new_group_form').serializeArray(),
          success: function(res) {
            if(res.results)
              alert('blah')
          }
        });
      });

      $('input#new_group_button').click(function() {
        $('#new_group_form').dialog({modal: true, width: 800, height: 200});
      });


    },
    render: function(){
      list_view = this;
      Groups.fetch({
      success: function(groups) {
        list_view.el.empty();

        for(i in groups.models) {
          //processed = (i / groups.models.length) * 100;
          //$( "#progressbar" ).progressbar({ value: processed });
          data = {name: groups.models[i].attributes.name}
          var compiledTemplate = _.template( groupListTemplate, data );
          list_view.el.append( compiledTemplate );
        }
      }

      });

}
  });
  return new groupListView;
});
