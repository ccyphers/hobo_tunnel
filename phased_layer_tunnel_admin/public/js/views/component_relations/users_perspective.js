define([
  'jquery',
  'underscore',
  'backbone',
  'text!templates/component_relations/users_perspective.html',
  'text!templates/component_relations/group_list.html'
], function($, _, Backbone, users_perspective, group_list){
  var users_perspective_view = Backbone.View.extend({
    el: $("#component_relationships_body"),
    remove_user_from_group: function(users, groups, data) {
      console.log(this.users);
      console.log(this.groups);
      //this.render({users: this.users, groups: this.groups});
    },
    render: function(group_map){
      //console.log(data);
      var tmp = _.template(users_perspective);
      this.el.empty();
      this.el.append(tmp);
      //this.users = data.users;
      //users = data.users
      //this.groups = data.groups;
      //remove_from_group = this.remove_user_from_group(this.users, this.groups);
      //remove_from_group();
      $('#group_list').empty();
      ct = 0
      for(i in group_map) {
        group = {name: i}
        users = group_map[i];
        var tmp = _.template(group_list, group, ct);
        $('#group_list').append(tmp);
        group_user_list_html="<ul class='list'>";
        //users = data.groups.models[i].attributes.users
        for(x in users) {
          email = users[x];
          console.log(email)
          group_user_list_html += "<li class='inline_email'>" + email + "</li><li class='inline_delete'><a id='delete_user_from_group' value='" + email + "' name='" + email + "'>Delete</a></li><br>";
        }
        group_user_list_html += "</ul>";
        console.log(group_user_list_html);
        $('#group_user_list_' + ct).empty();
        $('#group_user_list_' + ct).append(group_user_list_html);
        ct += 1;
      }
      group_users = $('a#delete_user_from_group')
      $('a#delete_user_from_group').each(function(i, elem) {
        $(elem).click(function() {
          data = {email: $(this).attr('name'), group: $(this).attr('value')};
//      remove_from_group(data);
*
          $.ajax({ url: '/user/del_from_group', type: 'post', dataType: 'json', data: data,
                   success: function(res) {
                  $(this).parent().remove();
                  $(this).remove();
                     console.log(this)
                   }
          });
*/
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
