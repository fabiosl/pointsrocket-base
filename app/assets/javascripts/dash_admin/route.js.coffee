dash_admin.config [
  '$routeProvider',
  '$locationProvider',
  ($routeProvider, $locationProvider) ->
    $routeProvider.when '/courses/:id/edit', {
      templateUrl: 'dash_admin/courses/edit.html'
      controller: 'EditCoursesController'
    }

    $routeProvider.when '/courses/new/alleatory', {
      templateUrl: 'dash_admin/courses/edit.html'
      controller: 'EditCoursesController'
      alleatory: true
    }

    $routeProvider.when '/courses/new', {
      templateUrl: 'dash_admin/courses/edit.html'
      controller: 'EditCoursesController'
    }

    $routeProvider.when '/courses', {
      templateUrl: 'dash_admin/courses/index.html'
      controller: 'ListCoursesController'
    }

    $routeProvider.when '/badges/:id/edit', {
      templateUrl: 'dash_admin/badges/edit.html'
      controller: 'EditBadgeController'
    }

    $routeProvider.when '/badges/new', {
      templateUrl: 'dash_admin/badges/edit.html'
      controller: 'EditBadgeController'
    }

    $routeProvider.when '/badges', {
      templateUrl: 'dash_admin/badges/index.html'
      controller: 'ListBadgesController'
    }

    $routeProvider.when '/campaigns/:id/edit', {
      templateUrl: 'dash_admin/campaigns/edit.html'
      controller: 'EditCampaignController'
    }

    $routeProvider.when '/campaigns/new', {
      templateUrl: 'dash_admin/campaigns/edit.html'
      controller: 'EditCampaignController'
    }

    $routeProvider.when '/campaigns', {
      templateUrl: 'dash_admin/campaigns/index.html'
      controller: 'ListCampaignsController'
    }

    $routeProvider.when '/goals/new', {
      templateUrl: 'dash_admin/goals/edit.html'
      controller: 'EditGoalsController'
    }

    $routeProvider.when '/goals/:id/edit', {
      templateUrl: 'dash_admin/goals/edit.html'
      controller: 'EditGoalsController'
    }

    $routeProvider.when '/goals', {
      templateUrl: 'dash_admin/goals/index.html'
      controller: 'ListGoalsController'
    }

    $routeProvider.when '/challenges/new', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'challenge'
    }

    $routeProvider.when '/challenges/:id/edit', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'challenge'
    }

    $routeProvider.when '/challenges', {
      templateUrl: 'dash_admin/general/index.html'
      controller: 'ListGeneralController'
      adminOption: 'challenge'
    }

    $routeProvider.when '/campaign_users/new', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'campaign_user'
    }

    $routeProvider.when '/campaign_users/:id/edit', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'campaign_user'
    }

    $routeProvider.when '/campaign_users', {
      templateUrl: 'dash_admin/general/index.html'
      controller: 'ListGeneralController'
      adminOption: 'campaign_user'
    }

    $routeProvider.when '/hashtag_challenges/new', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'hashtag_challenge'
    }

    $routeProvider.when '/hashtag_challenges/:id/edit', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'hashtag_challenge'
    }

    $routeProvider.when '/hashtag_challenges', {
      templateUrl: 'dash_admin/general/index.html'
      controller: 'ListGeneralController'
      adminOption: 'hashtag_challenge'
    }

    $routeProvider.when '/broadcasts/new', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'broadcast'
    }

    $routeProvider.when '/broadcasts/:id/edit', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'broadcast'
    }

    $routeProvider.when '/broadcasts', {
      templateUrl: 'dash_admin/general/index.html'
      controller: 'ListGeneralController'
      adminOption: 'broadcast'
    }


    $routeProvider.when '/challenge_users/new', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'challenge_user'
    }

    $routeProvider.when '/challenge_users/:id/edit', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'challenge_user'
    }

    $routeProvider.when '/challenge_users', {
      templateUrl: 'dash_admin/general/index.html'
      controller: 'ListGeneralController'
      adminOption: 'challenge_user'
    }


    $routeProvider.when '/hashtag_challenge_users/new', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'hashtag_challenge_user'
    }

    $routeProvider.when '/hashtag_challenge_users/:id/edit', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'hashtag_challenge_user'
    }

    $routeProvider.when '/hashtag_challenge_users', {
      templateUrl: 'dash_admin/general/index.html'
      controller: 'ListGeneralController'
      adminOption: 'hashtag_challenge_user'
    }

    $routeProvider.when '/trails/new', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'trail'
    }

    $routeProvider.when '/trails/:id/edit', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'trail'
    }

    $routeProvider.when '/trails', {
      templateUrl: 'dash_admin/general/index.html'
      controller: 'ListGeneralController'
      adminOption: 'trail'
    }

    $routeProvider.when '/franchisees/new', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'franchisee'
    }

    $routeProvider.when '/franchisees/:id/edit', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'franchisee'
    }

    $routeProvider.when '/franchisees', {
      templateUrl: 'dash_admin/general/index.html'
      controller: 'ListGeneralController'
      adminOption: 'franchisee'
    }

    $routeProvider.when '/plans/new', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'plan'
    }

    $routeProvider.when '/plans/:id/edit', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'plan'
    }

    $routeProvider.when '/plans', {
      templateUrl: 'dash_admin/general/index.html'
      controller: 'ListGeneralController'
      adminOption: 'plan'
    }

    $routeProvider.when '/categories/new', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'category'
    }

    $routeProvider.when '/categories/:id/edit', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'category'
    }

    $routeProvider.when '/categories', {
      templateUrl: 'dash_admin/general/index.html'
      controller: 'ListGeneralController'
      adminOption: 'category'
    }

    $routeProvider.when '/invites/new', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'invite'
    }

    $routeProvider.when '/invites/:id/edit', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'invite'
    }

    $routeProvider.when '/invites', {
      templateUrl: 'dash_admin/general/index.html'
      controller: 'ListGeneralController'
      adminOption: 'invite'
    }

    $routeProvider.when '/complete_account_questions/new', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'complete_account_question'
    }

    $routeProvider.when '/complete_account_questions/:id/edit', {
      templateUrl: 'dash_admin/general/edit.html'
      controller: 'EditGeneralController'
      adminOption: 'complete_account_question'
    }

    $routeProvider.when '/complete_account_questions', {
      templateUrl: 'dash_admin/general/index.html'
      controller: 'ListGeneralController'
      adminOption: 'complete_account_question'
    }

    $routeProvider.when '/community_invites', {
      templateUrl: 'dash_admin/community_invites/index.html'
      controller: 'ListCommunityInvitesController'
      adminOption: 'community_invite'
    }

    $routeProvider.when '/trivias_questions', {
      templateUrl: 'dash_admin/trivias/questions/index.html'
      controller: 'ListTriviasQuestionsController'
    }

    $routeProvider.when '/:id/edit', {
      templateUrl: 'dash_admin/domains/edit.html'
      controller: 'EditDomainsController'
    }

    $routeProvider.when '/domains/new', {
      templateUrl: 'dash_admin/domains/edit.html'
      controller: 'EditDomainsController'
    }

    $routeProvider.when '/', {
      templateUrl: 'dash_admin.html'
      controller: 'DashAdminController'
    }

    $locationProvider.html5Mode true
]
