#= require lib/socket.io-1.4.5

if window.USER_ID && window.SOCKET_JS_URL
  socket = io(SOCKET_JS_URL)

  socket.on "connect", ->
    socket.emit("register", {id: window.USER_ID, tenant: window.TENANT})

    socket.on "notification_create", (data) ->
      if window.socketNewNotificationCallback
        window.socketNewNotificationCallback(data)

    socket.on "point_create", (data) ->
      if window.addPointsInterface
        window.addPointsInterface(data)

    socket.on "comment_create", (data) ->
      if window.addCommentToList
        window.addCommentToList(data, $('#comments-list'))
        # Refactor it due to duplication
        $('.comment-delete-button').each ->
          commentUserId = $(this).data('comment-user-id')
          $(this).hide() unless commentUserId is window.CURRENT_USER.id or window.CURRENT_USER.admin



