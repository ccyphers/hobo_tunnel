define([
  'underscore',
  'backbone'
], function(_, Backbone) {
  var group = Backbone.Model.extend({
    defaults: {
      active: true
    },
    initialize: function(name){
    }

  });
  return group;

});
