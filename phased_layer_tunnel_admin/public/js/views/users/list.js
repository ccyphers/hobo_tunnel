// Filename: views/projects/list
define([
  'jquery',
  'underscore',
  'backbone',
  'collections/users',
  'collections/groups',
  'multi_d_and_d',
  'views/component_relations/users_perspective',
  'text!templates/users/list.html',
  'delete_users'
//  'views/users/new'
], function($, _, Backbone, Users, Groups, ph1, users_perspective_view, userListTemplate, ph2){
//], function($, _, Backbone, Users, userListTemplate, new_user_view, ph1){
  var userListView = Backbone.View.extend({
    el: $("#users_list"),
    initialize: function(){
//    Users.model.bind('change', this.render);
//    Users.model.view = this;
//    Users.fetch();
      $('#submit_new_user').click(function() {
        $.ajax({ url: '/user/new', dataType: 'json', type: 'post', data: $('#new_user_form').serializeArray(),
          success: function(res) {
            console.log(res);
            //if(res.results) {
            //  alert('blah');
            //}
          }
        });
      });

      $('input#new_user_button').click(function() {
        $('#new_user').dialog({modal: true, width: 800, height: 200});
      });

    },
    render: function(){
      list_view = this;
      Users.fetch({
        success: function(users) {
          list_view.el.empty();
          for(i in users.models) {
            data = {name: users.models[i].attributes.email}
            var compiledTemplate = _.template( userListTemplate, data );
            list_view.el.append( compiledTemplate );
          }
          Groups.fetch({ 
            success: function(groups) {
              users_perspective_view.render({users: users, groups: groups});
            }
          });
          multi_d_and_d();
          setup_delete_users();
        }
      });
    }
  });
  return new userListView;
});
