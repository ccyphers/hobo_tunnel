// Filename: views/projects/list
define([
  'jquery',
  'underscore',
  'backbone',
  'collections/users',
  'text!templates/users/new.html'
], function($, _, Backbone, Users, new_user_template){
  var new_user_view = Backbone.View.extend({
    el: $("#new_user_msg"),
    initialize: function(){
      console.log('created new user view')
    },
    render: function(){
    }
  });
  return new new_user_view;
});
