employee_advocacy.directive "dateTimePicker", ->
  link: (scope, elem, attrs) ->
    $(elem).datetimepicker($.datepicker.regional[ "pt-BR" ]);
