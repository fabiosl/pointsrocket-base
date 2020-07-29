dash_admin.controller 'EditGoalsController', [
  '$scope', 'DomainService', '$routeParams', '$timeout', '$route', '$location',
  ($scope, DomainService, $routeParams, $timeout, $route, $location) ->

    templates = {
      goal: {
        title: "",
        badge_goals: []
      }
    }

    $scope.domain_id = $routeParams.domain_id

    openAddBadgeModal = ->
      $('#modal-add-badge').modal()
      $scope.loading_medals = true

      if !$scope.badges
        DomainService.one($routeParams.domain_id).all('badges').getList().then (badges) ->
          $scope.loading_medals = false
          $scope.badges = badges

        .catch ->
          alert "Houve um erro ao tentar carregar as medalhas, por favor, atualize seu navegador."

      return

    buildParams = ->
      {
        title: $scope.goal.title
        badge_goals_attributes: $scope.goal.badge_goals.map (badge_goal) ->
          {
            id: badge_goal.id
            badge_id: badge_goal.badge.id
            repetition: badge_goal.repetition
            _destroy: badge_goal._destroy
          }
      }

    $scope.save = ->
      params = buildParams()
      if $scope.goal.id
        $scope.goal.customPUT(goal: params).then (response) ->
          alert "Salvo com sucesso"
          $location.path "/#{$routeParams.domain_id}/goals"
      else
        DomainService.one($routeParams.domain_id).all(
          'goals').customPOST(goal: params).then (response) ->
            alert "Meta criada com sucesso"
            $location.path "/#{$routeParams.domain_id}/goals"

    $scope.editMedal = (badge_goal) ->
      $scope.new_medal = {
        badge: badge_goal.badge,
        repetition: badge_goal.repetition
        editing: true
        badge_goal: badge_goal
      }
      openAddBadgeModal()


    $scope.deleteMedal = (badge_goal) ->
      badge_goal._destroy = true

    $scope.undeleteMedal = (badge_goal) ->
      delete badge_goal._destroy

    $scope.newMedal = ->
      $scope.new_medal = {}
      openAddBadgeModal()

    $scope.pushMedal = ->
      if $scope.new_medal.editing
        $scope.new_medal.badge_goal.repetition = $scope.new_medal.repetition
        $scope.new_medal.badge_goal.badge = $scope.new_medal.badge

      else
        badge_goal = {
          repetition: $scope.new_medal.repetition
          badge: $scope.new_medal.badge
        }

        $scope.goal.badge_goals.push badge_goal

      $('#modal-add-badge').modal("hide")
      return

    $scope.loading = true

    loadGoal = ->
      DomainService.one($routeParams.domain_id).one(
        'goals', $routeParams.id
      ).get().then (goal) ->
        $scope.loading = false
        $scope.goal = goal

    if $routeParams.id
      loadGoal()

    else
      $scope.loading = false
      $scope.goal = angular.copy templates.goal
]
