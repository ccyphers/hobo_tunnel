function multi_d_and_d() {


$('#dragSource li').draggable({revert: true,
      helper: function(){
      var selected = $('#dragSource input:checked').parents('li');
      if (selected.length === 0) {
        selected = $(this);
      }
      var container = $('<div/>').attr('id', 'draggingContainer');
      container.append(selected.clone());
      return container; 
      }
  });
}
