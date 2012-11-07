define([
  'jquery',
  'underscore',
  'backbone',
  'text!templates/component_relations/users_perspective.html',
  'text!templates/component_relations/group_list.html'
], function($, _, Backbone, users_perspective, group_list){
  var users_perspective_view = Backbone.View.extend({
    el: $("#component_relationships_body"),
    render: function(data){
      //console.log(data);
      var tmp = _.template(users_perspective);
      this.el.empty();
      this.el.append(tmp);

      $('#group_list').empty();
      for(i in data.groups.models) {
        group = {name: data.groups.models[i].attributes.name}
        var tmp = _.template(group_list, group, i);
        $('#group_list').append(tmp);
        group_user_list_html="<ul class='list'>";
        users = data.groups.models[i].attributes.users
        for(x = 0; x < users.length; x++) {
          group_user_list_html += "<li class='inline_email'>" + users[x] + "</li><li class='inline_delete'><a id='delete_user_from_group' value='" + group.name + "' name='" + users[x] + "'>Delete</a></li><br>";
        }
        group_user_list_html += "</ul>";
        //console.log(group_user_list_html);
        $('#group_user_list_' + i).empty();
        $('#group_user_list_' + i).append(group_user_list_html);
      }
      group_users = $('a#delete_user_from_group')
      $('a#delete_user_from_group').each(function(i) {
        $(group_users[i]).click(function() {
          data = {email: $(this).attr('name'), group: $(this).attr('value')};
          $.ajax({ url: '/user/del_from_group', type: 'post', dataType: 'json', data: data,
                   success: function(res) {
                  $(this).parent().remove();
                  $(this).remove();
                     console.log(this)
                   }
          });
          //console.log(this)
        });
      });


  $('#component_groups li').droppable({
			accept: "#tab-1 li",
      drop: function(event, ui) {
        data = {group: event.target.innerText, user: event.toElement.innerText}
        $.ajax({ url: '/user/add_to_group', type: 'post', dataType: 'json', data: data,
                success: function(res) {
                }
        });
			}
		});
    //console.log(data);
    }
  });
  return new users_perspective_view;
});
