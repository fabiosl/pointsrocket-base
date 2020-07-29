dash_admin.factory 'Api', [
  'Restangular',
  (Restangular) ->

    Restangular.withConfig (config) ->
      config.setBaseUrl('/api')

]
