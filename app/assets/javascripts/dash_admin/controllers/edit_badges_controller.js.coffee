dash_admin.controller 'EditBadgeController', [
  '$scope', 'Api', '$routeParams', '$timeout', '$route', '$location',
  ($scope, Api, $routeParams, $timeout, $route, $location) ->

    $scope.loading = true

    errorMapping = {
      "badge_points": i18next.t('views.dashboard.admin.badges.fields.points')
      "badge_type": i18next.t('views.dashboard.admin.badges.fields.type')
      "name": i18next.t('views.dashboard.admin.badges.fields.name')
      "avatar": i18next.t('views.dashboard.admin.form.image')
    }

    $scope.getError = (key) ->
      keyMapping = errorMapping[key]
      if !keyMapping
        keyMapping = key

      "#{keyMapping}: #{$scope.errors[key].join(', ')}"

    $scope.setCurrentArchiveForFile = (archive) ->
      $scope.currentArchiveForFile = archive

    $scope.setArchive = (fileList) ->
      if fileList.length > 0
        file = fileList[0]
      else
        file = null

      $timeout ->
        $scope.currentArchiveForFile.archive = file
      , 1

    $scope.setAvatar = (fileList) ->
      if fileList.length > 0
        file = fileList[0]
        if file.type.startsWith('image/')
          reader = new FileReader
          reader.onload = (e) ->
            $timeout ->
              $scope.newAvatarSrc = e.target.result
            , 1
          reader.readAsDataURL(file)

          $timeout ->
            $scope.newAvatar = file
          , 1
        else
          alert "#{i18next.t('controllers.general.uncupported_image_type')} #{file.type}"
      else
        $timeout ->
          $scope.newAvatar = null
          $scope.newAvatarSrc = null
        , 1

    buildParams = ->
      finalParams = {
        badge: {
          id: $routeParams.id
          name: $scope.badge.name
          badge_type: $scope.badge.badge_type
          hint: $scope.badge.hint
          badge_points: $scope.badge.badge_points
        }
      }

      if $scope.newAvatar
        finalParams.badge.avatar = $scope.newAvatar

      finalParams

    buildFormDataParams = ->
      params = buildParams()
      formData = new FormData
      paramsFormData = fromObj(params)
      for k, v of paramsFormData
        if v != undefined and v != null
          formData.append k, v
      formData

    $scope.sync = ->
      $scope.loading = true
      $scope.errors = null

      handleError = (data) ->
        console.dir data
        $scope.errors = data
        # alert "Houve um erro ao atualizar a conquista"
        $('html, body').animate({scrollTop: 0})


      # $scope.badge.chapters_attributes = $scope.badge.chapters
      # $scope.badge.chapters_attributes.forEach (chapter) ->
      #   chapter.steps_attributes = chapter.steps
      #   chapter.steps_attributes.forEach (step) ->
      #     step.step_questions_attributes = step.step_questions
      #     step.step_questions_attributes.forEach (step_question) ->
      #       step_question.step_question_options_attributes = step_question.step_question_options

      if $scope.badge.id
        $scope.badge.withHttpConfig({transformRequest: angular.identity}).customPUT(buildFormDataParams(), undefined, undefined, {'Content-Type': undefined}).then ->
          alert i18next.t('controllers.general.success.update')
        .catch (resp) ->
          handleError(resp.data)
        .finally ->
          $scope.loading = false

      else
        Api.all(
          'badges'
        ).withHttpConfig({transformRequest: angular.identity}).customPOST(buildFormDataParams(), undefined, undefined, {'Content-Type': undefined}).then ->
          alert i18next.t('controllers.general.success.create')
          $location.path "/badges"
        .catch (resp) ->
          handleError(resp.data)
        .finally ->
          $scope.loading = false

    if $routeParams.id
      Api.one(
        'badges', $routeParams.id
      ).get().then (badge) ->
        $scope.loading = false
        $scope.badge = badge

    else
      $scope.loading = false
      $scope.badge = {}

]
