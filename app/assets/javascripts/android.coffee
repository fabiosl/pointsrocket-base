do ->
  sendToken = (token) ->
    Android.saveUserTokenLogin(token)
    Android.saveUserDomain(location.origin)

  getLoginToken = ->
    $.ajax
      url: '/api/tokens/get_current_user_token'
      method: 'POST'
      # vai entender pq isso aqui acontece com o ios
      error: (jqXHR) ->
        if parseInt(jqXHR.status) == 200
          sendToken(jqXHR.responseText)

      success: sendToken

  checkVersion = ->
    if window.CURRENT_ANDROID_VERSION_CODE
      setTimeout ->
        try
          versionCode = Android.getVersionCode()
        catch e
          $("#modal-android-outdated .version-text").remove()
          $("#modal-android-outdated").modal({backdrop: 'static', keyboard: false})
          return

        if versionCode < window.CURRENT_ANDROID_VERSION_CODE
          $("#modal-android-outdated .version").html(versionCode)
          $("#modal-android-outdated").modal({backdrop: 'static', keyboard: false})

      , 2000

  sendAndroidPushNotification = (token, deviceId, deviceName) ->
    $.ajax
      url: '/api/devices/create_or_update'
      method: 'POST'
      dataType: 'json'
      data: device:
        push_notification_token: token
        device_id: deviceId
        name: deviceName
        device_type: 'android'
        push_notification_active: true

  if window.Android
    window.isApp = true
    window.isAndroid = true

    window.instagramInstalled = Android.isInstagramInstalled()

    try
      token = Android.getPushNotificationToken()
      deviceName = Android.getDeviceName()
      deviceId = Android.getDeviceId()

      if token && deviceId
        sendAndroidPushNotification token, deviceId, deviceName

      getLoginToken()
    catch e
      # ...

    checkVersion()
