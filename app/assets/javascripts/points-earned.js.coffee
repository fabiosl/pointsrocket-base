animate = ($item, animation, callbackFinished, remaingClasses) ->
  $item.addClass("animation animating #{animation}")

  setTimeout ->
    if not remaingClasses
      $item.removeClass("animation")
      $item.removeClass("animating")
      $item.removeClass("#{animation}")

    if callbackFinished

      setTimeout ->
        callbackFinished()
      , 10

  , 1000

bounce = ($item, callbackFinished) ->
  animate $item, "bounce", callbackFinished

bounceOutRemaing = ($item, callbackFinished) ->
  animate $item, "bounceOut", callbackFinished, true


current_user_points = parseInt $('#user_points').text()

animatePointsWon = ($item, morePoints) ->
  userPoints = current_user_points + 0
  current_user_points = userPoints + morePoints

  jQuery(Counter: userPoints).animate { Counter: userPoints + morePoints},
    duration: 2000
    easing: 'swing'
    step: ->
      $('#user_points').text Math.round(@Counter)
      return
    complete: ->
      $('#user_points').text current_user_points

  bounce $item, ->
    bounce $item, ->
      bounce $item, ->
        bounceOutRemaing $item, ->
          $item.remove()


setTimeout ->

  $pointsWon = $('.points-won-now')

  if $pointsWon.length > 0
    if isNaN(parseInt($pointsWon.text()))
      $pointsWon.remove()
    else
      $pointsWon.removeClass "hide"
      animatePointsWon $pointsWon, parseInt($pointsWon.text())

, 1000

window.addPointsInterface = (point) ->
  $(".points-won-place").append "<span class='points-won-now'>+#{point.value}</span>"
  animatePointsWon $(".points-won-now"), point.value
