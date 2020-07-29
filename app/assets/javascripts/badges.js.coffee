$('.badge-button').click ->
  associate_badge($(this), $(this).data('url'), $(this).data('type'))

associate_badge = (object, url, type) ->

  panelBadge = object.parents('.panel-badge')

  if panelBadge.hasClass('reusable')
    badgeType = 'reusable'
  else
    badgeType = 'simple'

  console.log badgeType

  $.ajax
    url: url
    method: 'post'
    dataType: 'json'
    success: (response) ->
      if badgeType == 'simple'
        if type == 'associate'
          panelBadge.addClass('has-badge')
        else
          panelBadge.removeClass('has-badge')

      else if badgeType == 'reusable'
        reusableBadgeCounter = panelBadge.find('.reusable-badge-counter')
        reusableBadgeCounterNumber = parseInt(reusableBadgeCounter.data('counter'))

        if type == 'associate'
          reusableBadgeCounterNumber += 1
        else
          reusableBadgeCounterNumber -= 1

        reusableBadgeCounter.data('counter', reusableBadgeCounterNumber)
        reusableBadgeCounter.html reusableBadgeCounterNumber

        if reusableBadgeCounterNumber > 0
          panelBadge.addClass('has-badge')
        else
          panelBadge.removeClass('has-badge')


    error: (response) ->
      alert 'Houve um erro ao tentar executar ação. Tente mais tarde'
