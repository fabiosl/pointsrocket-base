// Require Jquery and AtWho
(function($) {
  $.fn.mentionable = function(options) {
    defaults = {
      min_length_typed: 1
    }

    options = $.extend({}, defaults, options)

    this.atwho({
      at: '@',
      displayTpl: "<li><img src='${avatar}' height='25' width='25'/> ${name} </li>",
      insertTpl: "<span class='user-mention' data-mention-user-id=${id}>@${name}</span>",
      callbacks: {
        sorter: function(query, items, searchKey) {
          return items;
        },
        remoteFilter: function(query, callback) {
          if (query.length < options.min_length_typed) {
            callback([])
          } else {
            return throttledLoadUsers(query, callback);
          }
        },
      }
    });

    var throttledLoadUsers = _.throttle(loadUsers, 500);

    function loadUsers(query, callback) {
      $.getJSON('/dashboard/usuarios/members', {
        search: query
      }, function(data) {
        return callback(data.users);
      });
    }

    return this;
  };
})(jQuery);
