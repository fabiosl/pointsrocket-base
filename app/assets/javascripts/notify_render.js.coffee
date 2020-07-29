do ->

  renderCallbacks = []

  window.addRenderedDomListener = (callback) ->
    renderCallbacks.push(callback)

  window.notifyRender = ->
    renderCallbacks.forEach (callback) ->
      callback.apply(this)
