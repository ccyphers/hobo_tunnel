define([
  'jquery',
  'underscore',
  'backbone',
  'views/users/list',
  'views/groups/list',
  'views/instances/list'
], function($, _, Backbone, userListView, groupListView, instanceListView ){
     var AppRouter = Backbone.Router.extend({
           routes: { 'users': 'users_list', 'groups': 'groups_list',
                     'instances': 'instances_list', 'new_user': 'new_user' },
           groups_list: function(){ groupListView.render(); },
           users_list: function(){ userListView.render(); },
           instances_list: function(){ instanceListView.render(); },
           defaultAction: function(actions){
             //mainHomeView.render();
           }
     });

    var initialize = function(){
      var app_router = new AppRouter;
      Backbone.history.start();
    };
    return { initialize: initialize };
});
