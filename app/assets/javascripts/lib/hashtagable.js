// Require Jquery and AtWho
(function($) {
  $.fn.hashtagable = function(options) {
    this.atwho({
      at: '#',
      displayTpl: "<li>#${name}</li>",
      limit: 8,
      callbacks: {
        remoteFilter: function(query, callback) {
          callback(options.items || [])
        }
      }
    });

    return this;
  };
})(jQuery);
