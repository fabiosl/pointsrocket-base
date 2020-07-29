employee_advocacy.directive "datePicker", ->
  link: (scope, elem, attrs) ->
    $(elem).datepicker();
