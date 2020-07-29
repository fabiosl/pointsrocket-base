dash_admin.controller 'EditDomainsController', [
  '$scope', 'Api', '$routeParams', '$timeout', '$location',
  ($scope, Api, $routeParams, $timeout, $location) ->

    $scope.loading = true

    templates = {
      domain: {
        domain_br_badge_events: []
        how_to_point_items: []
      }
    }

    buildParams = ->
      finalParams = {
        domain: {
          id: $routeParams.id
          name: $scope.domain.name
          url: $scope.domain.url
          default: $scope.domain.default
          description: $scope.domain.description
          delete_dashboard_image_down: $scope.domain.delete_dashboard_image_down
          delete_dashboard_menu_image: $scope.domain.delete_dashboard_menu_image
          delete_dashboard_menu_image_contract: $scope.domain.delete_dashboard_menu_image_contract
          delete_dashboard_login_image: $scope.domain.delete_dashboard_login_image
          delete_employee_advocacy_email_logo_image: $scope.domain.delete_employee_advocacy_email_logo_image
          remove_apn_key: $scope.domain.remove_apn_key
          employee_advocacy_enabled: $scope.domain.employee_advocacy_enabled
          only_registered_hashtags: $scope.domain.only_registered_hashtags
          dashboard_enabled: $scope.domain.dashboard_enabled
          courses_enabled: $scope.domain.courses_enabled
          forum_enabled: $scope.domain.forum_enabled
          facebook_app_id: $scope.domain.facebook_app_id
          facebook_app_secret: $scope.domain.facebook_app_secret,
          share_in_personal: $scope.domain.share_in_personal,
          share_in_fanpage: $scope.domain.share_in_fanpage,
          twitter_app_id: $scope.domain.twitter_app_id
          twitter_app_secret: $scope.domain.twitter_app_secret
          youtube_app_id: $scope.domain.youtube_app_id
          youtube_app_secret: $scope.domain.youtube_app_secret
          instagram_app_id: $scope.domain.instagram_app_id
          instagram_app_secret: $scope.domain.instagram_app_secret
          linkedin_app_id: $scope.domain.linkedin_app_id
          linkedin_app_secret: $scope.domain.linkedin_app_secret
          after_signin_path: $scope.domain.after_signin_path
          login_providers: $scope.domain.login_providers
          is_points: $scope.domain.is_points
          has_indication: $scope.domain.has_indication
          has_homepage: $scope.domain.has_homepage
          layout: $scope.domain.layout
          css: $scope.domain.css
          css_text: $scope.domain.css_text
          challenges_enabled: $scope.domain.challenges_enabled
          hashtag_challenges_enabled: $scope.domain.hashtag_challenges_enabled
          broadcasts_enabled: $scope.domain.broadcasts_enabled
          campaigns_enabled: $scope.domain.campaigns_enabled
          peer_recognition_enabled: $scope.domain.peer_recognition_enabled
          weekly_user_coins: $scope.domain.weekly_user_coins
          any_user_can_post: $scope.domain.any_user_can_post
          only_invited: $scope.domain.only_invited
          from_mail: $scope.domain.from_mail
          pass_domains_select_and_log_here_directly: $scope.domain.pass_domains_select_and_log_here_directly
          challenge_localize_key: $scope.domain.challenge_localize_key
          login_terms_url: $scope.domain.login_terms_url
          social_network_permiteds: $scope.domain.social_network_permiteds
          android_api_key: $scope.domain.android_api_key
          peer_recognition_hashtags: $scope.domain.peer_recognition_hashtags
          advocacy_posts_limit_by_day: $scope.domain.advocacy_posts_limit_by_day
          for_submission: $scope.domain.for_submission
          domain_br_badge_events_attributes: $scope.domain.domain_br_badge_events.map (domain_br_badge_event) ->
            if domain_br_badge_event.br_badge
              br_badge = domain_br_badge_event.br_badge.id
            else
              br_badge = null

            id: domain_br_badge_event.id
            event: domain_br_badge_event.event
            br_badge: br_badge
            _destroy: domain_br_badge_event._destroy
          how_to_point_items_attributes: $scope.domain.how_to_point_items.map (how_to_point_item) ->
            id: how_to_point_item.id
            section: how_to_point_item.section
            description: how_to_point_item.description
            points: how_to_point_item.points
            _destroy: how_to_point_item._destroy
        }
      }

      filesSeted.forEach (fileField) ->
        finalParams.domain[fileField.toUnderscore().replace(/^_/, '')] = $scope["new#{fileField}"]

      finalParams

    filesSeted = []

    $scope.$watch "domain.css_text", (value) ->
      $('#domain_css_text').html(value)

    $scope.setImage = (fieldName, fileList) ->
      if filesSeted.indexOf(fieldName) == -1
        filesSeted.push fieldName

      if fileList.length > 0
        file = fileList[0]
        if file.type.startsWith('image/')
          reader = new FileReader
          reader.onload = (e) ->
            $timeout ->
              $scope["new#{fieldName}Src"] = e.target.result
            , 1
          reader.readAsDataURL(file)

          $timeout ->
            $scope["new#{fieldName}"] = file
          , 1
        else
          alert "#{i18next.t('controllers.general.unsupported_image_type')} #{file.type}"
      else
        $timeout ->
          $scope["new#{fieldName}"] = null
          $scope["new#{fieldName}Src"] = null
        , 1

    $scope.setFile = (fieldName, fileList) ->
      if filesSeted.indexOf(fieldName) == -1
        filesSeted.push fieldName

      if fileList.length > 0
        file = fileList[0]

        $timeout ->
          $scope["new#{fieldName}"] = file
          $scope["new#{fieldName}Name"] = file.name
        , 1
      else
        $timeout ->
          $scope["new#{fieldName}"] = null
          $scope["new#{fieldName}Name"] = null
        , 1

    buildFormDataParams = ->
      params = buildParams()
      formData = new FormData
      paramsFormData = fromObj(params)
      for k, v of paramsFormData
        if v != undefined and v != null
          formData.append k, v

        if v == "null"
          formData.append k, ""

      formData

    $scope.domain_br_badge_event_events_choices = [
      {
        name: "Combo de 8 semanas",
        id: "EightWeekPostCombo"
      },
      {
        name: "Combo de 4 semanas",
        id: "FourWeekPostCombo"
      },
      {
        name: "Combo de 3 semanas",
        id: "ThreeWeekPostCombo"
      },
      {
        name: "Combo de 2 semanas",
        id: "TwoWeekPostCombo"
      },
      {
        name: "50 visitas em um post",
        id: "FiftyVisitsOnPost"
      },
      {
        name: "10 visitas em um post",
        id: "TenVisitsOnPost"
      },
      {
        name: "Primeira postagem no facebook",
        id: "FirstFacebookPostBrBadge"
      },
      {
        name: "Primeira postagem no twitter",
        id: "FirstTweetPostBrBadge"
      },
      {
        name: "Primeira postagem no linkedin",
        id: "FirstLinkedinPostBrBadge"
      },
      {
        name: "200 visualizações em todos os posts",
        id: "TwoHundredVisitsOnAllPosts"
      },
      {
        name: "Nova publicação, adicionar badge (Voopter)",
        id: "VoopterNewPublication"
      },
      {
        name: "200 pontos (Kiehls)",
        id: "KiehlsTwoHundredsPoints"
      },
      {
        name: "250 pontos (Kiehls)",
        id: "KiehlsTwoHundredsFiftyPoints"
      },
      {
        name: "500 pontos (Kiehls)",
        id: "KiehlsFiveHundredsPoints"
      },
      {
        name: "600 pontos (Kiehls)",
        id: "KiehlsSixHundredsPoints"
      },
      {
        name: "700 pontos (Kiehls)",
        id: "KiehlsSevenHundredPoints"
      },
      {
        name: "1000 pontos (Kiehls)",
        id: "KiehlsThousandPoints"
      },
    ]

    $scope.domainsPath = ->
      "/dashboard/admin/"

    $scope.addDomainBrBadgeEvent = ->
      $scope.domain.domain_br_badge_events.push {}

    $scope.removeDomainBrBadgeEvent = (domain_br_badge_event) ->
      domain_br_badge_event._destroy = true

    $scope.addHowToPointItem = ->
      $scope.domain.how_to_point_items.push {}

    $scope.sync = ->
      $scope.loading = true

      if $scope.domain.id
        $scope.domain.withHttpConfig({transformRequest: angular.identity}).customPUT(buildFormDataParams(), undefined, undefined, {'Content-Type': undefined}).then ->
          alert i18next.t('controllers.general.success.update')
          $location.path "/"
        .catch ->
          alert i18next.t('controllers.general.error.create')
          console.log arguments
        .finally ->
          $scope.loading = false
      else
        Api.all('domains').withHttpConfig({transformRequest: angular.identity}).customPOST(buildFormDataParams(), undefined, undefined, {'Content-Type': undefined}).then ->
          alert i18next.t('controllers.general.success.create')
          $location.path "/"
        .catch ->
          alert i18next.t('controllers.general.error.create')
          console.log arguments
        .finally ->
          $scope.loading = false


    if $routeParams.id
      Api.one('domains', $routeParams.id).get().then (domain) ->
        $scope.loading = false
        domain.domain_br_badge_events.forEach (domain_br_badge_event) ->
          domain_br_badge_event.br_badge = {
            id: domain_br_badge_event.br_badge
            name: domain_br_badge_event.br_badge
          }
        $scope.domain = domain

        if $scope.domain.css_text == undefined or $scope.domain.css_text == "undefined" or $scope.domain.css_text == "null" or $scope.domain.css_text == ""
          $scope.domain.css_text = [
            "/* Menu topo */",
            "#header.navbar .navbar-toolbar {",
            "//    background: black;",
            "}",

            "/* Sidebar */",
            ".sidebar {",
            "//    background: black;",
            "}",].join("\n")
    else
      $scope.loading = false
      $scope.domain = angular.copy templates.domain

]
