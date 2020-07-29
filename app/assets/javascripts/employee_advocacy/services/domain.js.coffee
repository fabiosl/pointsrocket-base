employee_advocacy.factory 'DomainService', [
  'Api',
  (Api) ->

    Api.all('domains')

    # Api.all('domains').one("2").all('courses').getList().then ->
    #   console.dir('aasasfd')
    #   console.dir(arguments)

    # Api.all('domains').get(2).then (response) ->
    #   console.dir response

    # Api.one('domains', 2).getList('courses').then (response)->
    #   console.dir response
    # Api.one('domains', 3).getList('courses').then (response)->
    #   console.dir response
]
