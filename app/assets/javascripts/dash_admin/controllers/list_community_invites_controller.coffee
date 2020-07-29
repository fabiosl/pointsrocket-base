dash_admin.controller 'ListCommunityInvitesController', [
  '$scope', 'Api', '$routeParams', '$route', '$timeout'
  ($scope, Api, $routeParams, $route, $timeout) ->

    $scope.loading = true
    $scope.processingAction = false
    $scope.options = adminOptions[$route.current.$$route.adminOption]


    $scope.approveUserCommunityInvite = (community_invite) ->
      approveCommunityInvite(community_invite, 'user')

    $scope.approveManagerCommunityInvite = (community_invite) ->
      approveCommunityInvite(community_invite, 'manager')

    approveCommunityInvite = (community_invite, role) ->
      $scope.processingAction = true
      community_invite.customPOST({role: role}, 'approve')
        .then (response) ->
          replaceCommunityInvite(response.community_invite)
          console.log(response)
        .catch (error) ->
          console.error error
        .then ->
          $scope.processingAction = false

    $scope.declineCommunityInvite = (community_invite) ->
      $scope.processingAction = true
      community_invite.customPOST({}, 'decline')
        .then (response) ->
          replaceCommunityInvite(response.community_invite)
          console.log(response)
        .catch (error) ->
          console.error error
        .then ->
          $scope.processingAction = false

    replaceCommunityInvite = (community_invite) ->
      $scope.community_invites = $scope.community_invites.map (item) ->
        if item.id is community_invite.id
          return community_invite
        return item


    Api.all('community_invites').getList().then (community_invites) ->
      $scope.loading = false
      $scope.community_invites = community_invites

]
