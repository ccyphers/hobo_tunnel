define([
  'jquery',
  'underscore',
  'backbone',
  'text!templates/instances/list.html'
], function($, _, Backbone, instanceListTemplate){
  var instanceListView = Backbone.View.extend({
    el: $("#tab-3"),
    initialize: function(){
    },
    render: function(){
      var data = {};
      var compiledTemplate = _.template( instanceListTemplate, data );
      this.el.html( compiledTemplate );
    }
  });
  return new instanceListView;
});
