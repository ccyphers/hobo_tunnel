define([
  'jquery',
  'underscore',
  'backbone',
//  'libs/backbone/localstorage',
  'models/group'
], function($, _, Backbone, group){
  var group_collection = Backbone.Collection.extend({
    model: group,
    url: '/group/list',
//    localStorage: new store("groups"),
/*
    done: function() {
      return this.filter(function(group){ return group.get(); });
    },
*/

    initialize: function(){
    }

  });

  return new group_collection;
});
