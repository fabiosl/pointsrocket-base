//= require selectize/standalone/selectize

$('#selectize-customselect').selectize();

// translation missing: pt-BR.controllers.registrations.complete.success

;(function () {
  $('#wizard').steps({
      headerTag: '.wizard-title',
      bodyTag: '.wizard-container',
      labels: {
          cancel: window.texts["wizard.cancel"],
          current: window.texts["wizard.current"],
          pagination: window.texts["wizard.pagination"],
          finish: window.texts["wizard.finish"],
          next: window.texts["wizard.next"],
          previous: window.texts["wizard.previous"],
          loading: window.texts["wizard.loading"]
      },
      onFinished: function () {
        $(this).submit();
      }
  }).css('opacity', '').find('.steps li').removeClass('disabled');

})();
