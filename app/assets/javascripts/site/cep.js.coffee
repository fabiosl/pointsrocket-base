$ '#payment_address_attributes_zipcode'
  .on 'change', ->
    cep = this.value
    $.ajax
      type: 'json'
      method: 'get'
      url: "http://cep.correiocontrol.com.br/#{cep}.json"
      success: (response) ->
        $('#payment_address_attributes_street').val(response.logradouro)
        $('#payment_address_attributes_district').val(response.bairro)
        $('#payment_address_attributes_state').val(response.uf)
        $('#payment_address_attributes_city').val(response.localidade)
