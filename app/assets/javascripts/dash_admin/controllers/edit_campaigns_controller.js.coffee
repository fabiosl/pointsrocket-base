dash_admin.controller 'EditCampaignController', [
  '$scope', 'Api', '$routeParams', '$timeout', '$route', '$location', '$q',
  ($scope, Api, $routeParams, $timeout, $route, $location, $q) ->
    $scope.loading = true

    errorMapping = {
      "chapters.steps.name": i18next.t('controllers.courses.edit.fields.step.name')
      "chapters.steps.step_questions.question": i18next.t('controllers.courses.edit.fields.step.question')
    }

    $scope.getError = (key) ->
      keyMapping = errorMapping[key]
      if !keyMapping
        keyMapping = key

      "#{keyMapping}: #{$scope.errors[key].join(', ')}"

    if $routeParams.id
      campaignPromise = Api.one(
        'campaigns', $routeParams.id
      ).get()

    else
      campaignPromise = $q (resolve) ->
        $scope.campaign = {
          campaign_badges: []
        }
        resolve($scope.campaign)

    campaignPromise.then (campaign) ->
      $scope.loading = false
      $scope.campaign = campaign

    Api.all('badges').getList().then (badges) ->
      $scope.badges = badges

      campaignPromise.then (campaign) ->

        # get all badges ids
        campaignBadgesIds = campaign.campaign_badges.map (campaign_badge) ->
          campaign_badge.badge.id

        # set select true if badge is in badges ids
        $scope.badges.forEach (badge) ->
          badge.selected = campaignBadgesIds.indexOf(badge.id) != -1


    $scope.toggleBadge = (badge) ->
      badgesInCampaign = $scope.campaign.campaign_badges.filter (campaign_badge) ->
        campaign_badge.badge.id == badge.id

      if badgesInCampaign.length > 0
        badgeCampaign = badgesInCampaign[0]
        badgeCampaign._destroy = !badge.selected
      else
        $scope.campaign.campaign_badges.push({
          badge: badge
        })

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

    $scope.setImage = (fileList) ->
      if fileList.length > 0
        file = fileList[0]
        if file.type.startsWith('image/')
          reader = new FileReader
          reader.onload = (e) ->
            $timeout ->
              $scope.newImageSrc = e.target.result
            , 1
          reader.readAsDataURL(file)

          $timeout ->
            $scope.newImage = file
          , 1
        else
          alert "#{i18next.t('controllers.general.unsupported_image_type')} #{file.type}"
      else
        $timeout ->
          $scope.newImage = null
          $scope.newImageSrc = null
        , 1

    buildParams = ->
      finalParams = {
        campaign: {
          id: $routeParams.id
          title: $scope.campaign.title
          subtitle: $scope.campaign.subtitle
          description: $scope.campaign.description
          start_date: $scope.campaign.start_date
          end_date: $scope.campaign.end_date
          redeem_points: $scope.campaign.redeem_points
          max_redeems: $scope.campaign.max_redeems
          campaign_badges_attributes: $scope.campaign.campaign_badges.map (campaign_badge) ->
            id: campaign_badge.id
            _destroy: campaign_badge._destroy
            badge_id: campaign_badge.badge.id
        }
      }

      if $scope.newImage
        finalParams.campaign.image = $scope.newImage

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
        $scope.errors = data
        alert i18next.t('controllers.general.error.update')
        $('html, body').animate({scrollTop: 0})

      if $scope.campaign.id
        $scope.campaign.withHttpConfig({transformRequest: angular.identity}).customPUT(buildFormDataParams(), undefined, undefined, {'Content-Type': undefined}).then ->
          alert i18next.t('controllers.general.success.update')
        .catch (resp) ->
          handleError(resp.data)
        .finally ->
          $scope.loading = false

      else
        Api.all(
          'campaigns'
        ).withHttpConfig({transformRequest: angular.identity}).customPOST(buildFormDataParams(), undefined, undefined, {'Content-Type': undefined}).then ->
          alert i18next.t('controllers.general.success.create')
          $location.path "/campaigns"
        .catch (resp) ->
          handleError(resp.data)
        .finally ->
          $scope.loading = false

]
