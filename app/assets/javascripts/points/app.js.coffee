points = angular.module 'points', []

points.service "InterfacePoints", [->

  current_user_points = parseInt $('#user_points').text()

  # This will add points to header
  # It depends, of course, header to be present
  this.add = (points) ->
    jQuery(Counter: current_user_points).animate { Counter: current_user_points + points},
      duration: 1000
      easing: 'swing'
      step: ->
        $('#user_points').text Math.ceil(@Counter)
        return

    current_user_points += points

  this

]

points.directive "badgeModal", [ ->
  restrict: 'E'
  templateUrl: "shared/badge_modal.html"
  scope:
    name: "@name"
    imageUrl: "@imageUrl"
  link: (scope, elem, attrs) ->
    $(elem).find('.badge-modal').modal('show')
]

points.service "Utils", ['$timeout', '$compile', ($timeout, $compile)->

  # This will show badge modal
  this.showBadgeModal = (badge, scope) ->
    $timeout ->
      html = $compile(
        "<badge-modal name='" + badge.name + "' image-url='" + badge.avatar_url + "'></badge-modal>"
      )(scope)
      $('[data-ng-view]').append(html)
    , 0
  this

]
