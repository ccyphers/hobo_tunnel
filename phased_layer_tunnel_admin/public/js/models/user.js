define([
  'underscore',
  'backbone'
], function(_, Backbone) {
  var user = Backbone.Model.extend({
    defaults: {
      active: true
    },
    initialize: function(name){
      this.name = name
    }

  });
  return user;

});
