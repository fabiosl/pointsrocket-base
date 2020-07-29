do ->
  $postBoxForm = $('.post-box-form')

  if !String::endsWith
    String::endsWith = (searchString, position) ->
      subjectString = @toString()
      if typeof position != 'number' or !isFinite(position) or Math.floor(position) != position or position > subjectString.length
        position = subjectString.length
      position -= searchString.length
      lastIndex = subjectString.indexOf(searchString, position)
      lastIndex != -1 and lastIndex == position
  
  if !String::includes
    String::includes = ->
      'use strict'
      String::indexOf.apply(this, arguments) != -1
  

  throttledLoadUsers = _.throttle((query, callback) ->
    $.getJSON '/dashboard/usuarios/members', { search: query }, (data) ->
      callback data.users
  , 500);

  initSummernotePost = ->
    $('#post_content').summernote(
      placeholder: i18next.t('views.general.write_post')
      toolbarContainer: '.my-toolbar'
      toolbar: [
        ['style', ['bold', 'italic', 'underline', 'clear']],
        ['fontsize', ['fontsize']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['insert', ['link', 'picture', 'video']],
        ['misc', ['codeview']]
      ]
      hint:
        mentions: [{id: 1, name: 'nelson'}, {id: 2, name: 'ana'}]
        match: /\B@(\w{1,})$/
        search: (keyword, callback) ->
          throttledLoadUsers(keyword, callback)
          return
        template: (item) ->
          "<img src='#{item.avatar}' height='25' width='25'/> #{item.name}"
        content: (item) -> 
          $("<span>").html("<span class='user-mention' data-mention-user-id=#{item.id}>@#{item.name}</span><span>&nbsp;</span>")[0]
      callbacks:
        onInit: ($context) ->
          # $context.editable.mentionable()
          $postBoxForm.parents('.publication-div').removeClass('hidden')
    )

  if $postBoxForm.length
    initSummernotePost()
  else
    $('.publication-div').removeClass('hidden')

  placeCaretAtEnd = (el) ->
    el.focus();
    if typeof window.getSelection != "undefined" && typeof document.createRange != "undefined"
      range = document.createRange();
      range.selectNodeContents(el);
      range.collapse(false);
      sel = window.getSelection();
      sel.removeAllRanges();
      sel.addRange(range);
    else if typeof document.body.createTextRange != "undefined"
      textRange = document.body.createTextRange();
      textRange.moveToElementText(el);
      textRange.collapse(false);
      textRange.select();


  $peerInput = $('#peer_recognition_content')
  $peerInput.mentionable({min_length_typed: -1})
            .pointable()
            .hashtagable({
              items: window.CURRENT_DOMAIN.peer_recognition_hashtags_items
            })

  pushAtWhoOperator = (operator) ->
    if !$peerInput[0].textContent.trim().endsWith(operator)

      if $peerInput[0].textContent.length > 0 and not ($peerInput[0].textContent.endsWith(" ") or $peerInput[0].textContent.endsWith("&nbsp;"))
        node = document.createTextNode("\u00A0")
        $peerInput[0].appendChild(node)

      node = document.createTextNode("#{operator}")
      $peerInput[0].appendChild(node)
      placeCaretAtEnd($peerInput[0])
      $peerInput.keydown()
      $peerInput.keyup()

  # inicia com espaço ou não ^\s*
  # seguido por um mais \+
  # seguido por 1 numero ou mais (\d+)
  # seguido por espaço \s
  re_plus_with_number_typed = /^\s*\+(\d+)\s/
  re_points = /\+(\d+)\b/
  re_hashtags = /(#[a-z\d-]+)/ig
  re_atwho_points_hashtags = /<span class="atwho-(?:inserted|query)">((?:\+\d+)|(?:#[^<]+))<\/span>/
  re_atwho_persons = /(?:<span class="atwho-inserted"><span class="user-mention" data-mention-user-id="\d+">(@[^<]+)<\/span><\/span>)+/g

  # $peerInput.attr('title', "Para começar, Digite + e os pontos que deseja atribuir").tooltip("fixTitle").tooltip("hide").tooltip('disable')

  setTooltipTextAndReload = ($el, text) ->
    if $el.data("last-text") != text
      $el.data "last-text", text
      $el.attr('title', text).tooltip("fixTitle").tooltip("hide")

      setTimeout ->
        $el.tooltip("show")
      , 300


  timeout = null

  $addPoints = $('.add-points')
  $addUser = $('.add-user')
  $addHashtag = $('.add-hashtag')
  $submitPoints = $('.submit-points')
  $userAvailableCoins = $("#userAvailableCoins")

  $addPoints.on "click", ->
    if not $peerInput[0].textContent.match(re_points)
      pushAtWhoOperator("+")

  $addUser.on "click", ->
    pushAtWhoOperator("@")

  $addHashtag.on "click", ->
    pushAtWhoOperator("#")

  getPoints = ->
    re_result = $peerInput[0].textContent.match(re_points)

    if re_result
      parseInt(re_points.exec($peerInput[0].textContent)[1])
    else
      null


  isValidPoints = ->
    !!getPoints()

  getUsersName = ->
    html = $peerInput[0].innerHTML
    (html.match(re_atwho_persons) || []).map (str)->
      new RegExp(re_atwho_persons).exec(str)[1]

  isValidUsers = ->
    getUsersName().length > 0

  getHashtags = ->
    re_result = $peerInput[0].textContent.match(re_hashtags)

    _.uniq((re_result || []).map((h) -> _.trim(h)))

  isValidHashtags = ->
    if window.CURRENT_DOMAIN.only_registered_hashtags
      window.CURRENT_DOMAIN.peer_recognition_hashtags_items.filter((item) -> $peerInput[0].textContent.includes(item)).length > 0
    else
      getHashtags().length > 0

  isValidPeerInput = ->
    isValidPoints() and isValidUsers() and isValidHashtags()

  enoughAvailableCoins = ->
    availableCoins = Number($userAvailableCoins.text())
    points = Number(getPoints())
    numUsers = getUsersName().length

    (numUsers * points) <= availableCoins

  $peerInput.parents("form").on "submit", (e)->
    e.preventDefault()

    if !isValidPoints()
      $addPoints.trigger("click")
    else if !isValidUsers()
      $addUser.trigger("click")
    else if !isValidHashtags()
      $addHashtag.trigger("click")
    else if !enoughAvailableCoins()
      $.gritter.add({
        title: i18next.t('views.dashboard.coins.title'),
        text: i18next.t('views.dashboard.coins.not_enough'),
        sticky: false
      })
    else
      window.loader.show()
      $.post(
        '/dashboard/coin_gives',
        {
          coin_give: content: $peerInput.html().replace(re_atwho_points_hashtags, "$1"),
          points: getPoints(),
          recipient_names: getUsersName().map (item) -> item.slice(1)
        }
      )
      .done (data) ->
        name = data.recipient
        points = data.points

        $peerInput.html('')
        $userAvailableCoins.text(data.sender.available_coins)

        $.gritter.add({
          title: i18next.t('views.dashboard.coins.title'),
          text: i18next.t(
            'views.dashboard.coins.you_sent_to',
            { points: points, name: name }
          ),
          sticky: false
        })
        window.location.reload()
      .fail (error) ->
        console.log(error)
        $.gritter.add({
          title: i18next.t('views.dashboard.coins.sorry'),
          text: error.responseJSON.error,
          sticky: false
        })
      .always ->
        window.loader.hide()

  check = ->
    if isValidUsers()
      $addUser.addClass("btn-primary").removeClass("btn-default")
    else
      $addUser.addClass("btn-default").removeClass("btn-primary")

    if isValidHashtags()
      $addHashtag.addClass("btn-primary").removeClass("btn-default")
    else
      $addHashtag.addClass("btn-default").removeClass("btn-primary")

    if isValidPoints()
      $addPoints.addClass("btn-primary").removeClass("btn-default")
    else
      $addPoints.addClass("btn-default").removeClass("btn-primary")

    if isValidPoints() && isValidUsers()
      count = getUsersName().length * getPoints()

      if count == 1
        button_text = i18next.t(
          'views.dashboard.peer_recognition.give_one_point'
        )
      else
        button_text = i18next.t(
          'views.dashboard.peer_recognition.give_count_points',
          { count: count }
        )
    else
      button_text = i18next.t(
        'views.dashboard.peer_recognition.give_points'
      )

    $submitPoints.val(button_text)

  $peerInput.on "focus", ->
    if timeout
      clearTimeout(timeout)

    $peerInput.tooltip('enable').tooltip("show")

  .on "blur", ->
    if timeout
      clearTimeout(timeout)

    timeout = setTimeout ->
      $peerInput.tooltip("hide").tooltip('disable')
    , 200

  .on "change", check
  .on "keyup", check
