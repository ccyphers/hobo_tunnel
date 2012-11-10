define([
  'jquery',
  'underscore',
  'backbone',
//  'libs/backbone/localstorage',
  'models/user'
], function($, _, Backbone, user){
  var user_collection = Backbone.Collection.extend({
    model: user,
    url: '/user/users_perspective',
    //url: '/user/list',
//    localStorage: new store("users"),
/*
    done: function() {
      return this.filter(function(user){ return user.get(); });
    },
*/

    initialize: function(){
    }

  });

  return new user_collection;
});
