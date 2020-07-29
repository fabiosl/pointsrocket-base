# open voucher fields
$('#voucher-open-tag').on 'click', (e) ->
  e.preventDefault()

  $('#voucher-fieldset').removeClass('hide')
  $(this).hide()
