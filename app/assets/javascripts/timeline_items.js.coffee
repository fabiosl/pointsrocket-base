#= require lib/jquery-debounce-throttle
#= require timeline_carousel_mobile
#= require comments

# TO-DO: This file is getting to hard to maintain, so break it into other files
# with their own responsabilities
do ->
  $(document).on "click", "a", (e) ->
    that = this
    if !!this.getAttribute("data-modal-confirm")
      e.preventDefault()
      e.stopPropagation()

      $("#modal-confirm .confirm-text").html(this.getAttribute("data-modal-confirm"))
      $("#modal-confirm").modal("show")

      window.modalConfirmCallback = ->
        that.setAttribute("data-method", that.getAttribute("data-modal-method"))
        that.removeAttribute("data-modal-confirm");

        setTimeout () ->
          $(that).trigger("click");
        , 100


  currentPage = 1
  isLoading = false
  reachedBottom = false
  sendingComment = false

  getTimelines = (options) ->
    queryString = window.location.search || ''

    $.ajax({
      url: "/api/timeline_items#{queryString}"
      data: options
    }).promise()

  renderTemplate = (templateSelector, data) ->
    template = $(templateSelector).html()
    rendered = Mustache.render(template, data)

  getFromNowStr = (date) ->
    # fix safari
    # YYYY-mm-dd HH:MM:SS TZ -> YYYY/mm/dd HH:MM:SS TZ
    dateSplited = date.split(' ')
    dateSplited[0] = dateSplited[0].split('-').join('/')
    date = dateSplited.join(' ')

    moment.duration(
      moment().diff(date)
    ).humanize()


  parseTimelineItems = (timelineItems) ->
    timelineItems.map (timelineItem) ->
      timelineItem.time = getFromNowStr(timelineItem.created_at)
      timelineable = timelineItem.timelineable
      timelineableComments = timelineable.comments

      if timelineable?.user?.id?
        timelineItem.block_user_id = timelineable.user.id
      else if timelineable?.user_id?
        timelineItem.block_user_id = timelineable.user_id

      if window.CURRENT_USER.admin
        timelineable.can_manage = true

      if timelineable.user
        if timelineable.user.id is window.CURRENT_USER.id
          timelineable.can_manage = true

      # Check if timelineable has comments and set their time string
      if timelineableComments
        for item in timelineableComments.items
          item.timeStr = getFromNowStr(item.created_at)

      switch timelineItem.timelineable_type
        when "Campaign"
          if timelineable.campaign_users_info.count > 2
            timelineItem.remaining_count = timelineable.campaign_users_info.count - 2

        when "EmployeeAdvocacyPost"
          # if timelineable.expired
          #   timelineable.className = "post-expired"

          timelineable.isVideo = timelineable.type == "video"


        when "Challenge"
          if timelineable.challenge_users_info.count > 2
            timelineItem.remaining_count = timelineable.challenge_users_info.count - 2

        when "HashtagChallenge"
          if timelineable.hashtag_challenge_users_info.count > 2
            timelineItem.remaining_count = timelineable.hashtag_challenge_users_info.count - 2

        when "TimelineAggregateHashtagChallengeUser"
          for item in timelineItem.timelineable.items
            item.json = JSON.parse(item.json)

            if item.json?._source?.link?
              item.external_link = item.json._source.link

            else
              if item.json._source.social_network == "facebook"
                item.external_link = "https://facebook.com/#{item.json._source.id}"
              if item.json._source.social_network == "youtube"
                item.external_link = "https://www.youtube.com/watch?v=#{item.json._source.id}"

        when "HashtagChallengeUser"
          timelineItem.timelineable.json = JSON.parse timelineItem.timelineable.json

          if timelineItem.timelineable.json._source?.created_time?
            timelineItem.time = getFromNowStr(timelineItem.timelineable.json._source.created_time)

          if timelineItem?.timelineable?.json?._source?.link?
            timelineItem.external_link = timelineItem.timelineable.json._source.link

          else
            if timelineItem.timelineable.json._source.social_network == "facebook"
              timelineItem.external_link = "https://facebook.com/#{timelineItem.timelineable.json._source.id}"
            if timelineItem.timelineable.json._source.social_network == "youtube"
              timelineItem.external_link = "https://www.youtube.com/watch?v=#{timelineItem.timelineable.json._source.id}"

        when "Comment"
          commentable = timelineable.commentable

          switch timelineable.commentable_type
            when "Challenge"
              timelineItem.url = "/dashboard/desafios/#{commentable.id}"
              timelineItem.commentable_short_description = "Desafio: #{commentable.title}"
            else
              timelineItem.url = "javascript://"
              timelineItem.commentable_short_description = "Não foi possível identificar a fonte do comentário"


      timelineItem

  renderTimelineItens = (timelineItems) ->
    html = timelineItems.map (timelineItem) ->
      if timelineItem.timelineable_type?
        tpl = timelineItem.timelineable_type

        if timelineItem.timelineable_type == "HashtagChallengeUser"
          tpl = "hashtag_challenge_user_#{timelineItem.timelineable.json._source.social_network}"
        renderTemplate "#template-timeline-#{tpl}", timelineItem
      else
        renderTemplate "#template-timeline-#{timelineItem._source.social_network}", timelineItem

    $("#timeline-items").append(html.join(''))
    addTimelinePostViewsListener()
    addTimelineReportButtonListener()
    addCommentsListeners()
    window.notifyRender()

    # Limit text to a given number of chars
    $('.challenge-post-message').readmore
      collapsedHeight: 90
      moreLink: "<a href='#'>#{i18next.t('views.general.buttons.read_more')}</a>"
      lessLink: "<a href='#'>#{i18next.t('views.general.buttons.close')}</a>"

  addTimelinePostViewsListener = ->
    $('.timeline-post-views-button').click (event) ->
      postId = event.currentTarget.getAttribute('data-post-id')
      loadPostViews(postId)

  loadPostViews = (postId) ->
    $.get('/api/posts/' + postId + '/views')
    .done (data) ->
      renderPostViewsTemplate(postId, data)
    .fail (error) ->
      console.log(error)

  addTimelineReportButtonListener = ->
    $('.timeline-item-report-button').click (event) ->
      timelineItemId = event.currentTarget.getAttribute('data-timeline-item-id')
      $('#report-timeline-item-id').val(timelineItemId)

    $('.timeline-item-block-button').click (event) ->
      $('.loading-child').removeClass("loading")
      userId = event.currentTarget.getAttribute('data-user-id')
      $('.modal').find('.block-user-button').attr('data-user-id', userId)

  $('.report-submit-btn').click (event) ->
    event.preventDefault()
    timelineItemId = $('#report-timeline-item-id').val()
    reportTimelineItem(timelineItemId)

  reportTimelineItem = (timelineItemId) ->
    $.post(
      '/api/timeline_items/' + timelineItemId + '/report'
      report_type: $('#report-type').val()
      report_description: $('#report-description').val()
    )
    .done (data) ->
      $('#modal-report').modal('hide')
      alert('Informações enviadas. Nossos administradores analisarão sua denúncia.')
    .fail (error) ->
      console.log(error)

  renderPostViewsTemplate = (postId, data) ->
    template = $('#template-timeline-Post-Viewers').html()
    renderedTemplate = Mustache.render(template, data)
    $('#post-views #viewers-list').html(renderedTemplate)

  load = ->
    isLoading = true

    if isMobile()
      $(".timeline-loading-mobile").show()
      $(".mobile-load-more").hide()

    getTimelines({page: currentPage}).then (timelineItems, statusText, request) ->
      hasNextTimelineItems = request.getResponseHeader("HAS-NEXT-TIMELINE-ITEMS") == "true"

      setTimeout ->
        $commentItem = $(window.location.hash)
        if $commentItem.length > 0
          offsetTop = $commentItem.offset().top - 110
          $('html, body').animate({
              scrollTop: offsetTop
          }, 1000)
          $commentItem.css({ 'background-color': '#f2f2f2' })
      , 1000

      renderTimelineItens(parseTimelineItems(timelineItems))

      if timelineItems.length == 0 || ! hasNextTimelineItems
        reachedBottom = true

        $(".timeline-loading").addClass("hide")
        $(".mobile-load-more").addClass("hide")
        $(".timeline-bottom-reached").removeClass("hide")

    .fail ->

      $.gritter.add {
        title: 'Erro',
        text: 'Houve um erro ao carregar timeline.',
        sticky: false
      }

    .always ->
      runSliders()
      isLoading = false
      if isMobile()
        $(".mobile-load-more").show()
        $(".timeline-loading-mobile").hide()

  runSliders = ->
    setTimeout ->
      $('.one-slide').not('.slide-appended').each ->
        $(this).addClass('slide-appended').owlCarousel({
          dots: false,
          nav: true,
          items: 1,
          navText : ["<i class='ico-arrow-left2'></i>","<i class='ico-arrow-right22'></i>"]
        });
    , 1000

  beforeLoad = ->
    if not isMobile()
      $(window).off("scroll", desktopScroll)

  afterLoad = ->
    if not isMobile()
      $(window).on("scroll", desktopScroll)

  afterLoadFail = ->
    $(window).off("scroll", desktopScroll)
    $(".timeline-loading").addClass("hide")
    $(".timeline-bottom-reached").removeClass("hide")

  loadMore = ->
    if !isLoading && !reachedBottom
      currentPage += 1
      beforeLoad()
      load().then(afterLoad).fail(afterLoadFail)

  elementInViewport = (el) ->
    top = el.offsetTop
    left = el.offsetLeft
    width = el.offsetWidth
    height = el.offsetHeight

    while el.offsetParent
      el = el.offsetParent
      top += el.offsetTop
      left += el.offsetLeft

    window.pageYOffset + window.innerHeight > top

  isMobile = ->
    $(window).width() <= 991

  desktopScroll = $.throttle(
    500,
    ->
      if elementInViewport( $('.timeline-loading')[0] ) || ($(window).scrollTop() + $(window).height() > $(document).height() - 100)
        loadMore()
  )

  enableDesktop = ->
    $(window).on("scroll", desktopScroll)
    $(".mobile-load-more").off("click", loadMore)

  enableMobile = ->
    $(window).off("scroll", desktopScroll)
    $(".mobile-load-more").on("click", loadMore)

  addCommentsListeners = ->
    window.bindPanelComments()

  # peole who shared
  $('#timeline-items').on 'click', '.people-shared-post-btn', (event) ->
    $loading = $('#modal-people-shared-info').find('.loading')
    $errorMessage = $('#modal-people-shared-info').find('.error-message')

    $loading.addClass('show')
    $errorMessage.hide()

    $.ajax({
      url: "/api/employee_advocacy_posts/#{$(this).data("post-id")}/employee_advocacy_shares/shares_to_post"
    }).done (data) ->
      template = $('#template-user-who-share').html()
      html = data.map((d) -> Mustache.render(template, d)).join("")
      $('#modal-people-shared-info').find('.media-list').html(html)
    .error ->
      $errorMessage.show()
    .always ->
      $loading.removeClass('show')

    $("#modal-people-shared-info").modal()

  isApp = -> !!window.isApp
  instagramInstalled = -> !!window.instagramInstalled

  # Share advocacy post
  $('#timeline-items').on 'click', '.download-post-btn', (event) ->
    event.preventDefault();

    baseUrl =  "#{location.protocol}//#{location.hostname}#{if location.port then ":#{location.port}" else ''}"
    isVideo = !! $(this).attr("data-video-url")

    if isVideo
      mediaUrl = "#{baseUrl}#{$(this).attr("data-video-url")}"
    else
      mediaUrl = "#{baseUrl}#{$(this).attr("data-image-url")}"

    if window.isAndroid
      window.Android.download(mediaUrl)
    else if window.isIOS
      if isVideo
        webkit.messageHandlers.downloadVideo.postMessage(mediaUrl)
      else
        webkit.messageHandlers.download.postMessage(mediaUrl)
    else
      window.open(mediaUrl);


  $('#timeline-items').on 'click', '.share-post-btn', (event) ->
    self = this
    event.preventDefault()

    if $(this).data('network') == "instagram"
      if !isApp()
        $('#instagram-no-app').modal()
        return

      if !instagramInstalled()
        $('#instagram-no-installed').modal()
        return

    if $(this).parents('.post-expired').length
      return

    $loadingCreateShare = $('#modal-create-post').find('.loading')
    $createShareError = $('#modal-create-post').find('.createShareError')

    share =
      social_network: $(this).attr('data-network')
      isFacebook: $(this).attr('data-network') == "facebook"
      isInstagram: $(this).attr('data-network') == "instagram"
      social_network_color: $(this).attr('data-network-color')
      id: $(this).attr('data-share-id')
      imageUrl: $(this).attr('data-image-url')
      contentMaxLength: $(this).attr('data-content-max-length')

    if ! window.CURRENT_DOMAIN.for_submission
      share.title = $(this).attr('data-share-title')

    if window.socialNetworks[share.social_network] || share.social_network == "instagram"
      template = $('#template-share-create').html()
      renderedTemplate = Mustache.render(template, share)

      $('#modal-create-post').html(renderedTemplate)
      $('#modal-create-post').modal()

      # Add text counter
      $('.share-content').textcounter({
        max: share.contentMaxLength,
        countDown: true,
        countSpaces: true,
        countDownText: "%d"
      })
    else
      $("#modal-auth-#{share.social_network}").modal()

    return

  openInstagramShare = ($loadingCreateShare, userContent, imageUrl) ->

    window.IOSInstagramAfterShare = window.instagramAfterShare = ->
      setTimeout ->
        $loadingCreateShare.removeClass('show')
        template = $('#template-share-success').html()
        renderedTemplate = Mustache.render(template, response)
        $('#modal-create-post').modal('hide')
        $('#modal-share-success').html(renderedTemplate)

        $('#modal-create-post').on 'hidden.bs.modal', ->
          $('#modal-share-success').modal('show')
      , 5000

    window.IOSInstagramFailure = ->
      $loadingCreateShare.removeClass('show')
      $errorMessage = $('.errorMessage')
      $errorMessage.show()
      $errorMessage.html(i18next.t('views.dashboard.employee_advocacy.share_instagram_error'))

    baseUrl =  "#{location.protocol}//#{location.hostname}#{if location.port then ":#{location.port}" else ''}"

    if window.isIOS

      webkit.messageHandlers.shareInstagram.postMessage(
        JSON.stringify(
          {
            userContent: userContent,
            imageUrl: "#{baseUrl}#{imageUrl}"
          }
        )
      )

    else if window.isAndroid
      instagramAfterShare()
      window.Android.shareInstagram("#{baseUrl}#{imageUrl}", userContent)

  $('#timeline-container').on 'click', '.create-share-btn', (event) ->
    shareId = $(this).attr('data-share-id')
    shareImage = $(this).attr('data-image-url')
    socialNetwork = $(this).attr('data-network')
    $errorMessage = $('.errorMessage')
    $loadingCreateShare = $(this).find('.loadingCreateShare')
    $whereToPublish = $(this).parents().parents().find('.where_to_publish')

    user_content = $("#share-content-#{shareId}").val().trim()

    if ! user_content
      alert "Você deve escrever algo ao compartilhar"
      return

    if socialNetwork == "facebook" && !$whereToPublish.val()
      alert "Você deve selecionar em qual local devemos publicar"
      return

    $shareCheck = $("[data-check-share='#{shareId}-#{socialNetwork}']")

    $loadingCreateShare.addClass('show')

    data = {
      employee_advocacy_share: {
        employee_advocacy_post_id: shareId
        user_content: user_content
        social_network: socialNetwork,
      }
    }

    if socialNetwork == "facebook"
      data.employee_advocacy_share.where_to_publish = $whereToPublish.val()

    $errorMessage.hide()

    $.ajax(
      type: 'POST'
      url: '/api/employee_advocacy_shares'
      data: data
    )
    .done (response) ->
      if socialNetwork == "instagram"
        link = response.social_json.reduce(
          (memo, i) ->
            i.link
          , ""
        )
        userContent = if link
          "#{$("#share-content-#{shareId}").val().trim()} - #{link}"
        else
          "#{$("#share-content-#{shareId}").val().trim()}"

        openInstagramShare($loadingCreateShare, userContent, shareImage)
      else
        template = $('#template-share-success').html()
        renderedTemplate = Mustache.render(template, response)

        $shareCheck.removeClass().addClass('ok')
        $('#modal-create-post').modal('hide')
        $('#modal-share-success').html(renderedTemplate)

        $('#modal-create-post').on 'hidden.bs.modal', ->
          $('#modal-share-success').modal('show')

    .error (response) ->
      $errorMessage.show()
      if response.responseJSON.error == "limit_reached"
        $errorMessage.html(i18next.t('views.dashboard.employee_advocacy.limit_reached', {limit: response.responseJSON.limit}))
      else
        $errorMessage.html("#{i18next.t('views.dashboard.employee_advocacy.share_error', { socialNetwork: socialNetwork })}")
    .always ->
      $loadingCreateShare.removeClass('show')

  deleteCommentPromise = (commentId) ->
    $.ajax(
      url: "/api/comments/#{commentId}"
      method: 'POST'
      data: { '_method': 'delete'}
    )

  checkDevice = ->
    if isMobile()
      enableMobile()
    else
      enableDesktop()

  if $("#timeline-items").length > 0
    checkDevice()

    $(window).on "resize", ->
      checkDevice()

    load()

  $('#timeline-items').on 'click', '.btn-edit-post', (event) ->
    event.preventDefault()
    postId = $(this).data('post-id')
    $postContent = $("#timeline-post-content-#{postId}")
    window.currentPostContent = $postContent.html()
    editPost(postId)

  $('#timeline-items').on 'click', '.btn-save-post', (event) ->
    event.preventDefault()
    postId = $(this).data('post-id')

    savePost(postId)

  $('#timeline-items').on 'click', '.btn-cancel-post', (event) ->
    event.preventDefault()
    postId = $(this).data('post-id')

    cancelEditPost(postId)

  savePost = (postId) ->
    $postContent = $("#timeline-post-content-#{postId}")
    $postLinkedContent = $("#timeline-post-linked-content-#{postId}")
    $postActions = $("#timeline-post-#{postId}-actions")
    $errorMessage = $postActions.find('.error-message')
    closeEditPost(postId)

    $.post(
      "/dashboard/posts/#{postId}"
      _method: 'patch'
      post:
        content: $postContent.html()
    )
    .done (response) ->
      window.currentPostContent = response.post.content
      $postLinkedContent.html(response.post.linked_content)
    .fail (error) ->
      editPost(postId)
      $errorMessage.html(error.responseText)
      $errorMessage.show()

  editPost = (postId) ->
    $postContent = $("#timeline-post-content-#{postId}")
    $postLinkedContent = $("#timeline-post-linked-content-#{postId}")
    $postActions = $("#timeline-post-#{postId}-actions")
    $errorMessage = $postActions.find('.error-message')

    $postContent.summernote
      focus: true
      toolbar: [
        ['style', ['bold', 'italic', 'underline', 'clear']],
        ['fontsize', ['fontsize']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['insert', ['link', 'picture', 'video']],
        ['misc', ['codeview']]
      ]
      callbacks:
        onInit: ($context) ->
          $postActions.show()
          $postLinkedContent.hide()
          $errorMessage.html('')
          $context.editable.mentionable()

  cancelEditPost = (postId) ->
    $postActions = $("#timeline-post-#{postId}-actions")
    $postContent = $("#timeline-post-content-#{postId}")
    $postLinkedContent = $("#timeline-post-linked-content-#{postId}")

    $postContent.summernote('destroy');
    $postContent.html(window.currentPostContent)
    $postActions.hide()
    $postContent.hide()
    $postLinkedContent.show()

  closeEditPost = (postId) ->
    $postContent = $("#timeline-post-content-#{postId}")
    $postLinkedContent = $("#timeline-post-linked-content-#{postId}")
    $postActions = $("#timeline-post-#{postId}-actions")

    $postContent.summernote('destroy');
    $postActions.hide()
    $postContent.hide()
    $postLinkedContent.show()

  $("body").on "click", ".block-user-button", (e) ->
    e.preventDefault()
    $(this).parents('.loading-child').addClass("loading")

    $.ajax({
      url: "/api/block_users",
      method: "post",
      dataType: 'json',
      data: {
        block_user: {
          blocked_id: this.getAttribute("data-user-id")
        }
      },
      success: ->
        $.gritter.add {
          text: i18next.t('controllers.general.block.success'),
          sticky: false
        }
        location.reload()

      error: ->
        $.gritter.add {
          title: i18next.t('controllers.general.error.title'),
          text: i18next.t('controllers.general.error.block'),
          sticky: false
        }
    })

  openWrapper = ->
    $('.mobile-activities-footer-wrapper').removeClass 'down'

  openButton = ->
    $('.mobile-activities-button').removeClass 'down'

  openWrapper()

  $('.mobile-activities-footer-wrapper .close').on 'click', ->
    openButton()
    $(this).parents('.mobile-activities-footer-wrapper').addClass 'down'
