dash_admin.controller 'ListGoalsController', [
  '$scope', 'Api', '$routeParams', '$timeout'
  ($scope, Api, $routeParams, $timeout) ->


    loadGoals = ->
      $scope.loading = true
      Api.all('goals').getList().then (goals) ->
        $scope.goals = goals
      .catch ->
        alert i18next.t('controllers.general.error.loading')
      .finally ->
        $scope.loading = false

    loadGoals()

    $scope.deleteGoal = (goal) ->
      $scope.loading = true
      goal.remove().then ->
        alert i18next.t('controllers.general.success.delete')
        loadGoals()
      .catch ->
        alert i18next.t('controllers.general.error.delete')
        $scope.loading = false

]
