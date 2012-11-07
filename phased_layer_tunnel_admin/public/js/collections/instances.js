define([
  'jquery',
  'underscore',
  'backbone',
  'models/instances'
], function($, _, Backbone, instances_model){
  var instances_collection = Backbone.Collection.extend({
    model: instances_model,
    initialize: function(){

    }

  });

  return new instances_collection;
});
