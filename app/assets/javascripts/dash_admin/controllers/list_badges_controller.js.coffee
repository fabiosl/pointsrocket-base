dash_admin.controller 'ListBadgesController', [
  '$scope', 'Api', '$routeParams', '$timeout'
  ($scope, Api, $routeParams, $timeout) ->

    $scope.deleteBadge = (badge) ->
      num1 = Math.floor(Math.random() * 5 + 1)
      num2 = Math.floor(Math.random() * 5 + 1)

      if prompt("Para confirmar a exclusão da conquista, responda: #{num1} + #{num2} = ?") != ((num1 + num2) + '')
        alert i18next.t(
          'controllers.general.error.confirm_delete_answer',
          { resource: i18next.t('controllers.courses.course') }
        )
        return false

      $scope.loading = true

      badge.remove().then ->
        alert i18next.t('controllers.general.success.delete')

        $scope.badges = $scope.badges.filter (b) ->
          b.id != badge.id

      .catch ->
        alert i18next.t('controllers.general.error.delete')

      .finally ->
        $scope.loading = false


    $scope.loading = true

    Api.all('badges').getList().then (badges) ->
      $scope.loading = false
      $scope.badges = badges

]
