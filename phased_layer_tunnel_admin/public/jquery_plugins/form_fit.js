(function($){
  $.fn.fit_this = function(div) {
    this.dialog({width: div.width(), height: div.height()});
  }
})(jQuery);
