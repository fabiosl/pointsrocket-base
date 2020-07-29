//= require selectize/standalone/selectize

;(function () {

  // Load selectize for facebook pages and youtube channels

  selectizeOptions = {
    create: true,
    sortField: {
      field: 'text',
      direction: 'asc'
    },
    render: {
      option: renderItem,
      item: renderItem
    },
    dropdownParent: 'body'
  }

  function renderItem(item, escape) {
      return '<div>'
      + '<img style="font-size:10px;width:30px;" alt="Page image" src="' + item.picture + '" />'
      + '<span style="margin-left: 5px"> '+ item.text +'</span>'
      + '</div>';
  }

  $('#select-facebook-page').selectize(selectizeOptions);

  $('#select-youtube-channel').selectize(selectizeOptions);
})();

