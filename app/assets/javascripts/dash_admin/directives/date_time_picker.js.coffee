dash_admin.directive "dateTimePicker", ->
  link: (scope, elem, attrs) ->
    datepickerConfig = $.datepicker.regional[ "pt-BR" ]

    if attrs.datetimeType is 'start'
      datepickerConfig.hour = 0
      datepickerConfig.minute = 0
    if attrs.datetimeType is 'end'
      datepickerConfig.hour = 23
      datepickerConfig.minute = 59
    
    $(elem).datetimepicker(datepickerConfig)
