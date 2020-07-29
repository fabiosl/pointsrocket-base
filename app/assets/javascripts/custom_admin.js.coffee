clearVoucher = ->
  $('.voucher-response-panel').addClass('hide')

setVoucherSuccess = (message) ->
  $('.voucher-response-panel').addClass('hide')
  $("#voucher-success").removeClass('hide')
  $("#voucher-success-message").html(message)

setVoucherError = (message) ->
  $('.voucher-response-panel').addClass('hide')
  $("#voucher-error").removeClass('hide')
  $("#voucher-error-message").html(message)

loadVoucherInServerByVoucherIdAndShowToUser = (voucher) ->
  $.ajax({
    method: 'post'
    url: "/api/voucher/voucher_info/#{voucher}"
    success: (response) ->
      setVoucherSuccess(response.message)
    error: (response) ->
      if response.status == 404
        setVoucherError("Voucher não encontrado.")
      else
        setVoucherError("Houve um erro ao processar o voucher. Tente mais tarde.")
    complete: ->

  })

voucher_input = $('#new_user').find('#user_voucher')

if voucher_input.length > 0
  voucher_timeout = null
  voucher_input.on "keyup", ->
    _this = this
    clearTimeout voucher_timeout
    voucher_timeout = setTimeout ->
      user_voucher = _this.value
      if user_voucher.length > 0
        loadVoucherInServerByVoucherIdAndShowToUser(user_voucher)
      else
        clearVoucher()
    , 1000
