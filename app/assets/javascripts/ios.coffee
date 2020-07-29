
window.IOS = ->
  window.isApp = true
  window.isIOS = true

  $(document).on 'click', "input[type=file]", (e) ->
    try
      webkit.messageHandlers.askGaleryMicCamera.postMessage ''
    catch err
      console.log err

  try
    webkit.messageHandlers.askUserPushNotification.postMessage ''
  catch err
    console.log err

  if window.CURRENT_IOS_VERSION_CODE
    versionCodeTimeout = setTimeout ->
      $("#modal-ios-outdated .version-text").remove()
      $("#modal-ios-outdated").modal({backdrop: 'static', keyboard: false})
    , 5000

    window.IOSVersionCode = (versionCode) ->
      clearTimeout(versionCodeTimeout)

      if window.CURRENT_IOS_VERSION_CODE.indexOf(versionCode) == -1
        $("#modal-ios-outdated .version").html(versionCode)
        $("#modal-ios-outdated").modal({backdrop: 'static', keyboard: false})

    try
      webkit.messageHandlers.askVersionCode.postMessage ''
    catch e
      console.log e





  removeTargetBlanks = ->
    document.querySelectorAll("a").forEach (a) ->
      if a.hasAttribute("target")
        a.removeAttribute("target")

  window.addRenderedDomListener ->
    removeTargetBlanks()

  removeTargetBlanks()


window.instagramInstalled = false

window.IOSSetInstagramInstalled = ->
  window.instagramInstalled = true

# will be called when user accept token
# will be executed every time
window.IOSSendPushNotificationToken = (token, deviceId, deviceName) ->
  $.ajax
    url: '/api/devices/create_or_update'
    method: 'POST'
    dataType: 'json'
    data: device:
      push_notification_token: token
      device_id: deviceId
      name: deviceName
      device_type: 'ios'
      push_notification_active: true


sendToken = (token) ->
  try
    webkit.messageHandlers.setUserDomain.postMessage(location.origin)
  catch err
    console.log(err)

  try
    webkit.messageHandlers.setUserTokenKey.postMessage(token)
  catch e
    console.log(err)


window.IOSGetLoginToken = ->
  $.ajax
    url: '/api/tokens/get_current_user_token'
    method: 'POST'
    # vai entender pq isso aqui acontece com o ios
    error: (jqXHR) ->
      if parseInt(jqXHR.status) == 200
        sendToken(jqXHR.responseText)

    success: sendToken
