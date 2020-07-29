//= require site/ouibounce.js
//= require site/jquery.min.js
//= require jquery_ujs
//= require site/bootstrap.js
//= require site/fancy/jquery.fancybox.pack.js
//= require site/jquery.fitvids.min.js
//= require site/owl-carousel/owl.carousel.js
//= require site/easing.js
//= require site/jquery-func.js
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
