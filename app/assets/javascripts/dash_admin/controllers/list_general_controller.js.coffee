dash_admin.controller 'ListGeneralController', [
  '$scope', 'Api', '$routeParams', '$timeout', '$route', '$http',
  ($scope, Api, $routeParams, $timeout, $route, $http) ->

    $scope.options = adminOptions[$route.current.$$route.adminOption]

    $scope.statusHuman = {
      "approved": i18next.t('controllers.general.statuses.approved'),
      "declined": i18next.t('controllers.general.statuses.declined'),
      "pending": i18next.t('controllers.general.statuses.pending'),
      "created": i18next.t('controllers.general.statuses.created'),
    }

    titleFieldsFunc = {
      "challenge()": (item) ->
        "(#{$scope.statusHuman[item.status]})
         #{i18next.t('controllers.general.general.sent_by')}:
         #{item.user.name} #{i18next.t('controllers.general.general.at')}
         #{item.created_at} #{i18next.t('controllers.general.general.in_challenge')}
         #{item.challenge.title}"
      "hashtag_challenge()": (item) ->
        "(#{$scope.statusHuman[item.status]})
         #{i18next.t('controllers.general.general.sent_by')}:
         #{item.user.name} #{i18next.t('controllers.general.general.at')}
         #{item.created_at} #{i18next.t('controllers.general.general.in_challenge')}
         #{item.challenge.title}"
      "inviteItemTitleField()": (item) ->
        location_port = if location.port then ":#{location.port}" else ''
        full = "#{location.protocol}//#{location.hostname}#{location_port}"

        "<p>Email: #{item.email}</p>
         <p>Status: #{$scope.statusHuman[item.status]}</p>
         <p>Url: #{full}/invites/#{item.token}</p>
         <p>Token: #{item.token}<p>"
    }

    buildFormDataParams = (data) ->
      formData = new FormData
      paramsFormData = fromObj(data)
      for k, v of paramsFormData
        if v != undefined and v != null
          formData.append k, v
      formData

    $scope.showChallengeBaseModalReprove = (item, modalId) ->
      $scope.modalItem = item
      setTimeout ->
        $(modalId).modal()
      , 1

    $scope.showModalReprove = (item) ->
      $scope.showChallengeBaseModalReprove item, '#challenge-user-modal'

    $scope.showHashtagModalReprove = (item) ->
      $scope.showChallengeBaseModalReprove item, '#hashtag-challenge-user-modal'

    $scope.updateChallengeBase = (item, data, key, modalId) ->
      params = {}
      # data.notification_options = type: 'analyzed_by_admin'
      params[key] = data
      # data.notify = true
      $scope.loading = true

      setTimeout ->
        $(modalId).modal("hide")
      , 1

      item.withHttpConfig({transformRequest: angular.identity}).customPUT(buildFormDataParams(params), undefined, undefined, {'Content-Type': undefined}).then (response) ->
        $.gritter.add({
          title: i18next.t('controllers.general.success.title'),
          text: i18next.t('controllers.general.success.save'),
          sticky: false
        });

        for key of data
          item[key] = data[key]

      .catch (resp) ->
        $.gritter.add({
          title: i18next.t('controllers.general.error.title'),
          text: i18next.t('controllers.general.error.save'),
          sticky: false
        });

      .finally ->
        $scope.loading = false

    $scope.updateChallengeUser = (item, data) ->
      $scope.updateChallengeBase item, data, 'challenge_user', '#challenge-user-modal'

    $scope.updateHashtagChallengeUser = (item, data) ->
      $scope.updateChallengeBase item, data, 'hashtag_challenge_user', '#hashtag-challenge-user-modal'

    $scope.getItemTitleField = (item) ->
      if $scope.options.item_title_field.indexOf("()") != -1
        # call func
        titleFieldsFunc[$scope.options.item_title_field](item)
      else
        item[$scope.options.item_title_field]

    $scope.delete = (item) ->
      if confirm(i18next.t('controllers.general.actions.confirm_delete'))
        $scope.loading = true

        Api.one(
          $scope.options.slug, item.id
        ).remove().then ->
          $.gritter.add({
            title: i18next.t('controllers.general.success.title'),
            text: i18next.t('controllers.general.success.delete'),
            sticky: false
          });

          loadAll()
        .catch (resp) ->
          $.gritter.add({
            title: i18next.t('controllers.general.error.title'),
            text: i18next.t('controllers.general.error.delete'),
            sticky: false
          });
        .finally ->
          $scope.loading = false

    $scope.openInviteModal = ->
      setTimeout ->
        $("#create-invite-form-modal").modal()
      , 1

    $scope.createInvites = ->
      $.gritter.add({
        title: i18next.t('controllers.general.creating.title'),
        sticky: false
      });
      $scope.lockCreateInvites = true

      Api.all($scope.options.slug).all(
        "bulk_invite").customPOST({invites: $scope.inviteFormModalInvites}).then ->
        $.gritter.add({
          title: i18next.t('controllers.general.success.title'),
          text: i18next.t('controllers.general.success.save'),
          sticky: false
        });

        $("#create-invite-form-modal").modal("hide")
        $scope.inviteFormModalInvites = ""
        loadAll()

      .catch ->
        $.gritter.add({
          title: i18next.t('controllers.general.error.title'),
          text: i18next.t('controllers.general.error.save'),
          sticky: false
        });

      .finally ->
        $scope.lockCreateInvites = false

    $scope.topActionExecute = (action) ->
      $scope.$eval action

    loadAll = ->
      $scope.loading = true
      Api.all($scope.options.slug).getList().then (items) ->
        $scope.loading = false
        $scope.items = items

    loadAll()
]
