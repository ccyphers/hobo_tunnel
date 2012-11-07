function setup_delete_users() {
  delete_users=$('a#delete_user');
  delete_users.each(function(i) {
    user=$(delete_users[i]);
    user.click(function() {
      data = { email: $(this).attr('value') };
      $.ajax({ url: '/user/delete', dataType: 'json', type: 'post', data: data,
        success: function(res) {
          if(res.results) {
            console.log('delete');
          }
        }
      });
    });
  });
}
