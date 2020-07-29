window.bindPanelComments = ->
  $(".panel-comment").each ->
    $panelComment = $(this)
    commentableId = $panelComment.data('commentable-id')
    commentableType = $panelComment.data('commentable-type')
    commentsSource = $panelComment.data('source')
    $commentForm = $panelComment.find('.comment-form')
    $commentsList = $panelComment.find('.comments-list')
    $commentContentInput = $panelComment.find('.comment-content-input')
    $commentContent = $panelComment.find('.comment-content')
    $firstCommentMessage = $('.first-comment')
    $loadMoreCommentsBtn = $panelComment.find('.comments_load-more')
    $loadMoreCommentsContainer = $loadMoreCommentsBtn.parent('.comments_load-more-container')
    $loadingMoreCommentsIndicator = $loadMoreCommentsBtn.find('.indicator')
    loadingMoreComments = false
    sendingComment = false
    shownMentionItems = false

    $commentContent.mentionable()

    # Event to set a variable to prevent the form from submitting
    # when selecting an item through ENTER key
    $commentContent.on 'hidden.atwho', ->
      shownMentionItems = true
      setTimeout ->
        shownMentionItems = false
      , 100

    $commentContent.on 'keydown', (event) ->
      if isEnterKey(event)
        event.preventDefault()
        $commentForm.submit() if !shownMentionItems and !sendingComment

    isEnterKey = (event) ->
      event.which is 13 or event.keyCode is 13

    $commentForm.unbind("submit").on "submit", (e) ->
      e.preventDefault()
      content = $commentContent.html()

      if !content
        $.gritter.add {
          title: i18next.t('controllers.general.error.title'),
          text: i18next.t('controllers.comments.no_content'),
          sticky: false
        }
        return

      sendingComment = true
      window.loader.show()

      $.ajax({
        url: '/api/comments.json'
        method: "POST",
        data: {
          comment: {
            commentable_id: commentableId,
            commentable_type: commentableType,
            content: content
          }
        },
        success: (response) ->
          executeSuccessCommentActions(response)
          sendingComment = false
          window.loader.hide()
        ,
        error: ->
          $.gritter.add {
            title: i18next.t('controllers.general.error.title'),
            text: i18next.t('controllers.general.error.save'),
            sticky: false
          }
          sendingComment = false
          window.loader.hide()
      })

    executeSuccessCommentActions = (comment) ->
      newCommentsCount = Number($panelComment.data('new-comments-count'))
      $firstCommentMessage.hide()
      $.gritter.add {
        title: i18next.t('controllers.general.success.title'),
        text: i18next.t('controllers.comments.save.success'),
        sticky: false
      }
      $commentContent.text('')

      $panelComment.attr('data-new-comments-count', newCommentsCount + 1)
      $panelComment.data('new-comments-count', newCommentsCount + 1)
      renderCommentResponse(comment) if commentsSource is 'timeline'

    $loadMoreCommentsBtn.click (event) ->
      event.preventDefault()
      getMoreComments()

    getMoreComments = ->
      return if loadingMoreComments || !hasMoreComments()
      nextPage = getNextPage()

      $loadingMoreCommentsIndicator.addClass('show')

      loadingMoreComments = true

      $.get(
        '/api/comments.json',
        {
          commentable_type: $loadMoreCommentsBtn.data('commentable-type'),
          commentable_id: $loadMoreCommentsBtn.data('commentable-id'),
          page: nextPage
        }
      )
      .done (response, textStatus, jqXHR) ->
        hasNextPage = JSON.parse(jqXHR.getResponseHeader('HAS-NEXT-PAGE'))
        $loadMoreCommentsBtn.attr('data-current-page', nextPage)
        $loadMoreCommentsBtn.data('current-page', nextPage)
        $loadMoreCommentsBtn.data('has-next-page', hasNextPage)
        $loadMoreCommentsBtn.attr('data-has-next-page', hasNextPage)

        $loadMoreCommentsContainer.hide() unless hasMoreComments()
        
        response.forEach (comment) ->
          renderCommentResponse(comment, false)
      .always ->
        $loadingMoreCommentsIndicator.removeClass('show')
        loadingMoreComments = false

    hasMoreComments = ->
      JSON.parse($loadMoreCommentsBtn.data('has-next-page'))

    getNextPage = ->
      newCommentsCount = Number($panelComment.data('new-comments-count'))
      totalCurrentComments = $commentsList.find('.comment-item').length
      totalComments = Number($loadMoreCommentsBtn.data('total-comments'))
      currentPage = Number($loadMoreCommentsBtn.data('current-page'))
      perPage = Number($loadMoreCommentsBtn.data('per-page'))

      $panelComment.attr('data-new-comments-count', 0)
      $panelComment.data('new-comments-count', 0)

      currentPage + Math.round(newCommentsCount / perPage) + 1

    renderCommentResponse = (comment, atEnd=true) ->
      if commentsSource is 'timeline'
        template = $("#template-timeline-CommentItem").html()
      else
        template = $("#template-comment").html()
      
      comment.timeStr = getFromNowStr(comment.created_at)
      renderedHtml = Mustache.render(template, comment)
      if atEnd
        $commentsList.append(renderedHtml)
      else
        $commentsList.prepend(renderedHtml)

    getFromNowStr = (date) ->
      # fix safari
      # YYYY-mm-dd HH:MM:SS TZ -> YYYY/mm/dd HH:MM:SS TZ
      dateSplited = date.split(' ')
      dateSplited[0] = dateSplited[0].split('-').join('/')
      date = dateSplited.join(' ')

      moment.duration(
        moment().diff(date)
      ).humanize()

  # Hide comment delete button for comments other than current user's ones
  $('.comment-delete-button').each ->
    commentUserId = $(this).data('comment-user-id')
    $(this).hide() unless commentUserId is window.CURRENT_USER.id or window.CURRENT_USER.admin

  $('.comments-list').on 'click', '.comment-delete-button', (event) ->
    self = this
    event.preventDefault()
    commentId = $(this).data('comment-id')
    confirmAction = confirm(i18next.t('views.general.are_you_sure?'))

    return unless confirmAction

    deleteCommentPromise(commentId)
      .done ->
        $(self).parents('.comment-item').slideUp()
      .fail (error) ->
        console.log(error)

  deleteCommentPromise = (commentId) ->
    $.ajax(
      url: "/api/comments/#{commentId}"
      method: 'POST'
      data: { '_method': 'delete'}
    )
