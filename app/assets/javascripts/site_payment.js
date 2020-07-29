//= require site/jquery.maskedinput.min.js
//= require jquery.validate
//= require jquery.validate.pt-BR
//= require site/custom_validations
//= require site/cep
//= require site/forms
//= require site/voucher
//= require_self

$(".telephone").mask("(99) 9999-9999");

$('[data-maskedinput]').each(function(){
  var $this = $(this);
  $this.mask($this.data('maskedinput'));
});
$( "#cidade-select" ).change(function() {
  var cidade = $("#cidade-select").val()
  if(cidade==="outra"){
    $("#cidade-hidden").show()
  }else{
    $("#cidade-hidden").hide()
  }
});
