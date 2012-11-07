define([
  'underscore',
  'backbone'
], function(_, Backbone) {
  var instances_model = Backbone.Model.extend({
    defaults: {
      active: true
    },
    initialize: function(){
    }

  });
  return instances_model;

});
