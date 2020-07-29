dash_admin.directive "datePicker", ->
  link: (scope, elem, attrs) ->
    $(elem).datepicker();
