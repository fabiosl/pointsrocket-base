dash_admin.controller 'ListTrailsController', [
  '$scope', 'Api', '$routeParams', '$timeout'
  ($scope, Api, $routeParams, $timeout) ->

    $scope.domain_id = $routeParams.domain_id

    loadGoals = ->
      $scope.loading = true
      Api.one($scope.domain_id).all('trails').getList().then (trails) ->
        $scope.trails = trails
      .catch ->
        alert "Houve um erro ao tentar carregar as trilhas, tente mais tarde."
      .finally ->
        $scope.loading = false

    loadGoals()

    $scope.delete = (trail) ->
      $scope.loading = true
      trail.remove().then ->
        alert "Trilha deletada com sucesso"
        loadGoals()
      .catch ->
        alert "Houve um erro ao tentar deletar a trilha"
        $scope.loading = false

]
