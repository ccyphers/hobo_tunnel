// Filename: app.js
define([
  'jquery',
  'underscore',
  'backbone',
  'router',
  'collections/users',
  'collections/groups'
], function($, _, Backbone, Router, Users, Groups){
  var initialize = function(){
    // Pass in our Router module and call it's initialize function
    Router.initialize();
    Users.fetch();
    Groups.fetch();
  }

  return {
    initialize: initialize
  };
});
