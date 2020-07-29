dash_admin.controller 'ListCampaignsController', [
  '$scope', 'Api', '$routeParams', '$timeout'
  ($scope, Api, $routeParams, $timeout) ->

    $scope.loading = true

    loadAll = ->
      Api.all('campaigns').getList().then (campaigns) ->
        $scope.loading = false
        $scope.campaigns = campaigns

    loadAll()

    $scope.delete = (item) ->
      if confirm(i18next.t('controllers.general.actions.confirm_delete'))
        $scope.loading = true

        item.remove().then ->
          $.gritter.add({
            title: i18next.t('controllers.general.success.title'),
            text: i18next.t('controllers.general.success.delete'),
            sticky: false
          });
          loadAll()
        .catch ->
          $.gritter.add({
            title: i18next.t('controllers.general.error.title'),
            text: i18next.t('controllers.general.error.delete'),
            sticky: false
          });
        .finally ->
          $scope.loading = false


]
