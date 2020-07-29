do ->

  fixedSidebars = []

  updateFixedSidebars = ->
    headerHeightAndMargin = header.offsetHeight + 20
    fixedSidebars.forEach (dom) ->
      dom.parentNode.style.minHeight = dom.scrollHeight + 'px'

      distanceOfParentToScreenTop = dom.parentNode.getBoundingClientRect().top
      distanceOfParentToScreenTopMinusHeader = distanceOfParentToScreenTop - headerHeightAndMargin
      availableScreen = window.innerHeight - headerHeightAndMargin
      heightOfDomFixed = dom.scrollHeight
      howMuchFixedDivIsBiggerThanAvailableScreen = Math.max(0, heightOfDomFixed - availableScreen)

      if distanceOfParentToScreenTopMinusHeader + howMuchFixedDivIsBiggerThanAvailableScreen <= 0
        topToFix = headerHeightAndMargin - howMuchFixedDivIsBiggerThanAvailableScreen
        dom.style.position = 'fixed'
        dom.style.top = topToFix + 'px'
        dom.style.width = dom.parentNode.scrollWidth - 30 + 'px'
      else
        dom.style.position = null
        dom.style.width = null

  resize = ->
    if window.innerWidth <= 800
      fixedSidebars.forEach (dom) ->
        dom.style.position = null
        dom.style.top = null
        dom.style.width = null
        dom.parentNode.style.position = null
      window.removeEventListener 'scroll', updateFixedSidebars
    else
      window.addEventListener 'scroll', updateFixedSidebars
      updateFixedSidebars()

  if window.innerWidth > 800
    fixedSidebars = Array.prototype.slice.call(document.querySelectorAll('.fixed-sidebar'))
    header = document.getElementById('header')
    if fixedSidebars.length
      window.addEventListener 'resize', resize
      resize()
