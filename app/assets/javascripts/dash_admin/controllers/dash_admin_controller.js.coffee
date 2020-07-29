dash_admin.controller 'DashAdminController', [
  '$scope', 'Api', '$timeout'
  ($scope, Api, $timeout) ->
    $scope.loading = true

    $scope.adminOptions = adminOptions
  
    Api.one('domains', DOMAIN_ID).get().then (domain) ->
      $scope.loading = false
      $scope.domain = domain
]
