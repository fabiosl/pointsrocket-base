employee_advocacy.factory 'Api', [
  'Restangular',
  (Restangular) ->

    Restangular.withConfig (config) ->
      config.setBaseUrl('/api')

]
