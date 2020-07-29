showSubmissionModal = (id) ->
  $('#submission-modal').modal 'show'
  cu = window.challengeUsers.filter((cu) ->
    cu.id == parseInt(id)
  )[0]

  if cu.status == 'approved'
    cu.status_icon = 'ico-ok-circle text-success'
    cu.submission_alert_class = 'alert-success'

  if cu.status == 'declined'
    cu.status_icon = 'ico-remove-circle text-danger'
    cu.submission_alert_class = 'alert-danger'

  if cu.status == 'pending'
    cu.status_icon = 'ico-time'
    cu.submission_alert_class = 'alert-yellow'

  html = Mustache.render $('#challenge_user_template').html(), cu

  $('#submission-modal').find('.modal-content').html html

$('.show-submission-modal').on 'click', ->
  showSubmissionModal @getAttribute('data-id')
