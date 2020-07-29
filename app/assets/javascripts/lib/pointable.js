// Require Jquery and AtWho
(function($) {
  $.fn.pointable = function() {
    this.atwho({
      at: '+',
      data: ["5", "10", "20", "30", "50"],
      callbacks: {
        filter: function(t,e) {
          // chupei do bonus.ly, isso aqui permite adicionar pontos só 1x
          return this.$inputor[0].textContent.match(/\+(\d+)\b.*\+/) ? null : e
        }
      }
    });

    return this;
  };
})(jQuery);
