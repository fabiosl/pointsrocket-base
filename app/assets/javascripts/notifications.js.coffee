allNotifications = []
hasMoreNotifications = null
isLoading = null
pagingKey = null

updateHasNotification = (hasNewNotification) ->
  $generalNotification = $("#header-dd-notification .general-notification-badge")
  if hasNewNotification
    $generalNotification.text(getNewNotifications().length)
    $generalNotification.removeClass('hide')
  else
    $generalNotification.addClass('hide')


getFromNowStr = (date) ->
  delta = Math.round((+new Date - date) / 1000)
  minute = 60;
  hour = minute * 60
  day = hour * 24
  week = day * 7

  if delta < hour
    Math.floor(delta / minute) + 'm'

  else if delta < day
    Math.floor(delta / hour) + 'h'

  else
    Math.floor(delta / day) + 'd'

parseIconImage = (notification) ->
  if notification.notificable_type == "ChallengeUser" && notification.notificable?.challenge?
    notification.icoImage = notification.notificable.challenge.image.image.thumb.url
  else if notification.notificable_type == "BadgeUser"
    notification.icoClass = "ico-medal bgcolor-notification"
  else if notification.notificable_type == "HashtagChallengeUser" && notification.notificable?.hashtag_challenge?
    notification.icoImage = notification.notificable.hashtag_challenge.image.image.thumb.url
  else
    notification.icoClass = "ico-question2 bgcolor-notification"

parseUrl = (notification) ->
  if notification.notificable_type == "ChallengeUser" && notification.notificable && notification.notificable.challenge
    notification.url = "/dashboard/desafios/#{notification.notificable.challenge_id}"

    if notification.notificable.status == "declined"
      notification.url = "#{notification.url}?nao-aceita=#{notification.notificable.id}"

  else if notification.notificable_type == "BadgeUser"
    notification.url = "/dashboard/conquistas"


parseNotifications = (notifications) ->
  notifications.map (notification) ->
    d = new Date(notification.timestamp)

    notification.time = getFromNowStr(d)
    parseIconImage(notification)
    parseUrl(notification)
    parseChallenUserNotification(notification)

    notification

parseChallenUserNotification = (notification) ->
  return if notification.notifiable_type isnt 'ChallengeUser'
  notification.status_changed = notification.action in ['approved', 'declined']

renderAllNotifications = ->
  html = allNotifications.map (notification) ->
    renderTemplate(notification)

  $("#notification-list").html(html.join(''))

renderTemplate = (data) ->
  templateSelector = switch data.notification_type
    when 'Answer_create' then '#answer-template-notification'
    when 'Answer_mention_user' then '#answer-mention-user-template-notification'
    when 'Badge_create' then '#badge-template-notification'
    when 'BadgeUser_create' then '#badge-user-template-notification'
    when 'Broadcast_create' then '#broadcast-template-notification'
    when 'Campaign_create' then '#reward-template-notification'
    when 'Challenge_create' then '#challenge-template-notification'
    when 'ChallengeUser_create', 'ChallengeUser_approved', 'ChallengeUser_declined'
      '#challenge-user-template-notification'
    when 'Domain_reset_weekly_user_coins' then '#domain-reset-weekly-user-coins-template-notification'
    when 'CoinGive_expiration_warning' then '#coin-give-expiration-warning-template-notification'
    when 'CoinUser_create' then '#coin-user-template-notification'
    when 'Comment_create' then '#comment-template-notification'
    when 'Comment_mention_user' then '#comment-mention-user-template-notification'
    when 'EmployeeAdvocacyPost_create' then '#employee-advocacy-post-template-notification'
    when 'HashtagChallenge_create' then '#hashtagchallenge-template-notification'
    when 'HashtagChallengeUser_create' then '#hashtagchallenge-user-template-notification'
    when 'Message_create' then '#message-template-notification'
    when 'Post_create' then '#post-template-notification'
    when 'Post_mention_user' then '#post-mention-user-template-notification'
    else '#template-notification'


  template = $(templateSelector).html()
  rendered = Mustache.render(template, data)

fetch_notifications = (data) ->
  $.ajax({
    url: '/api/notifications',
    data: data
  })

getNewNotifications = ->
  allNotifications.filter (n) ->
    n.is_read != true

hasNewNotifications = ->
  getNewNotifications().length > 0

makeAllAsReaded = (data) ->
  $.ajax({
    method: "post"
    data: data
    url: '/api/notifications/mark_all_as_read'
  })

$("#header-dd-notification").on 'hidden.bs.dropdown', () ->
  ids = getNewNotifications().map (n) ->
    n.id

  if ids.length > 0
    makeAllAsReaded(ids: ids).success ->
      allNotifications.forEach (n) ->
        n.is_read = true

      renderAllNotifications()
      updateHasNotification(hasNewNotifications())

count = 0
fetch = ->
  isLoading = true
  count += 10

  fetch_notifications({paging_key: pagingKey}).success (notifications, status, response) ->
    hasMoreNotifications = response.getResponseHeader("HAS-NEXT-ITEM") == "true"
    pagingKey = response.getResponseHeader("PAGGING_KEY")

    allNotifications = allNotifications.concat parseNotifications(notifications)
    renderAllNotifications()
    updateHasNotification(hasNewNotifications())

    # if hasMoreNotifications
    #   fetch()

  .fail ->
    console.log("falhou")

  .always ->
    isLoading = false

fetch()

window.socketNewNotificationCallback = (data) ->
  newNotifications = parseNotifications [data]
  allNotifications = newNotifications.concat allNotifications
  renderAllNotifications()
  updateHasNotification(hasNewNotifications())


# Unread messages notification
getUnreadMessages = ->
  $.ajax('/dashboard/messages/unread.json')
    .success (data) ->
      checkUnreadMessages(data.messages)

checkUnreadMessages = (messages) ->
  $messageNotification = $("#header-dd-message .message-notification-badge")
  if messages.length > 0
    $messageNotification.text(messages.length);
    $messageNotification.removeClass('hide')
  else
    $messageNotification.addClass('hide')

getUnreadMessages()
