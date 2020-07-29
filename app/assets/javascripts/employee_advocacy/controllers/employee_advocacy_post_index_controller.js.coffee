employee_advocacy.controller 'EmployeeAdvocacyPostIndexController', [
  '$scope', '$routeParams', '$timeout', '$route', '$location', 'Restangular', 'InterfacePoints', 'Utils', '$http', '$sce',
  ($scope, $routeParams, $timeout, $route, $location, Restangular, InterfacePoints, Utils, $http, $sce) ->

    $scope.tabs = []
    $scope.employee_advocacy_posts = []
    $scope.currentPage = 1
    $scope.bottom = false

    $scope.foo = {
      selectedTab: null
    }

    $scope.getButtons = (post) ->
      if post.type == "video"
        # pra vídeo
        ['download']
      else
        ['facebook', 'twitter', 'linkedin', 'instagram', 'download']

    $scope.getTabCount = (tab) ->
      posts = $scope.posts

      if tab != i18next.t('views.dashboard.employee_advocacy.all')
        posts = posts.filter (post) ->

      posts.length

    $scope.selectTab = (tab) ->
      $timeout ->
        $scope.foo.selectedTab = tab

    $scope.getEmployeeAdvocacyPosts = ->
      $scope.employee_advocacy_posts

    # gambiarra das grandes
    firstTime = true
    $scope.$watch "foo.selectedTab", (tab) ->
      if firstTime
        firstTime = false
        return
      resetAndLoad()

    $scope.changeMobileSelectedTab = () ->
      $timeout ->
        resetAndLoad()
      , 50

    resetAndLoad = ->
      $scope.bottom = false
      $scope.employee_advocacy_posts = []
      $scope.currentPage = 1
      loadAll()

    # state for new post module
    $scope.editing_post_link_state = 'awaiting_url'

    # this in true stop link to be fetched on watch editing_post.url
    $scope.disable_look_url = false
    $scope.currentUserAdmin = window.currentUserAdmin
    $scope.currentDomain = window.CURRENT_DOMAIN

    pages = []

    $scope.facebook_pages = pages.concat(
      window.facebook_pages
    )

    $scope.changeImageState = (state) ->
      state ||= "change_image"
      $scope.editing_post_link_state = state

    $scope.editing_post = {
      facebook_points: 5,
      twitter_points: 5,
      linkedin_points: 5,
      instagram_points: 5,
      download_points: 5,
      publish_on_timeline: false
      notify_users: false
    }

    $scope.previewImage = (post) ->
      $scope.previewingPost = post
      $('#modal-preview-image').modal()


    $scope.openPeopleSharedInfo = (post) ->
      $('#modal-people-shared').modal()
      $scope.shares_to_post_error_message = null
      $scope.shares_to_post = []
      $scope.shares_to_post_loading = true

      Restangular
        .all("api")
        .one('employee_advocacy_posts', post.id)
        .all("employee_advocacy_shares")
        .all("shares_to_post")
        .getList().then((data) ->
          $scope.shares_to_post = data
        )
        .catch(() ->
          $scope.shares_to_post_error_message = i18next.t('views.dashboard.employee_advocacy.error_on_loading_people_who_shared')
        )
        .finally(() ->
          $scope.shares_to_post_loading = false
        )

    $scope.peopleShare =
      zero: i18next.t('views.dashboard.employee_advocacy.people_share.zero')
      one: i18next.t('views.dashboard.employee_advocacy.people_share.one')
      other: i18next.t('views.dashboard.employee_advocacy.people_share.other')

    interactionsToShow = [
      "like",
      "wow",
      "sad",
      "love",
      "haha",
      "angry",
      "thankful",
      "pride",
      "clicks",
      "shares",
      "favorites",
    ]

    $scope.getInteractionCount = (interaction, post, social) ->
      if not post.employee_advocacy_shares
        return null

      post.employee_advocacy_shares.filter (share) ->
        share.social_network == social
      .reduce (memo, share) ->
        if share.interaction_count and share.interaction_count[interaction]
          memo += share.interaction_count[interaction]
        memo
      , 0

    $scope.interactionsToShow = (post, social) ->
      interactionsToShow.filter (interaction) ->
        count = $scope.getInteractionCount(interaction, post, social)

        !!count

    $scope.getInteractionIcon = (interaction) ->
      switch interaction
        when "comment"
          "comment"
        when "comments"
          "comment"
        when "love"
          "heart"
        when "like"
          "thumbs-up22"
        when "likes"
          "heart"
        when "haha"
          "happy"
        when "wow"
          "shocked"
        when "sorry"
          "sad"
        when "anger"
          "angry"
        when "shares"
          "share-alt"
        when "favorites"
          "star"
        when "views"
          "eye-open"
        when "dislikes"
          "thumbs-down"
        when "clicks"
          "cursor2"
        when "click"
          "cursor2"
        else
          interaction

    $scope.saveImage = ->
      # quando for de um arquivo
      if $scope.imageFile
        # mostre ela no front
        $scope.editing_post.image = $scope.imageFileSrc
        $scope.editing_post.video = null
        $scope.editing_post.video_src = null

      else if $scope.videoFile
        # mostre ela no front
        $scope.editing_post.image = null
        $scope.editing_post.video = $scope.videoFile
        $scope.editing_post.video_src = $scope.next_video_src

      else if $scope.editing_post.new_image_url
        # quando for do link
        # salve o link no campo imagem
        $scope.editing_post.image = $scope.editing_post.new_image_url
        $scope.editing_post.video = null
        $scope.editing_post.video_src = null

      # volta para edição dos textos
      $scope.editing_post_link_state = 'loaded'

      # limpa a nova imagem
      $scope.next_image_src = null
      $scope.new_image_url = null

    # quando o usuário informa uma imagem atraves do campo da url
    # temos que "apagar" a imagem do arquivo
    $scope.$watch "editing_post.new_image_url", (url) ->
      if url
        $scope.imageFileSrc = null
        $scope.imageFile = null
        $scope.videoFile = null
        $scope.next_image_src = url

    $scope.setImageFile = (fileList) ->
      if fileList.length > 0
        file = fileList[0]
        if file.type.startsWith('image/')
          reader = new FileReader
          reader.onload = (e) ->
            $timeout ->
              $scope.imageFileSrc = e.target.result
              $scope.next_image_src = $scope.imageFileSrc
            , 1
          reader.readAsDataURL(file)

          $timeout ->
            $scope.imageFile = file
          , 1
        else if file.type.startsWith("video/")

          loadVideo = ->

            fileReader = new FileReader
            fileReader.onload = (e) ->
              blob = new Blob([fileReader.result], {type: file.type})
              url = URL.createObjectURL(blob)

              # video = document.createElement("video")

              # video.addEventListener "loadeddata", () ->
              #   canvas = document.createElement('canvas')
              #   canvas.width = video.videoWidth
              #   canvas.height = video.videoHeight
              #   canvas.getContext('2d').drawImage(video, 0, 0, canvas.width, canvas.height)
              #   image = canvas.toDataURL()
              #   success = image.length > 100000

              #   console.log(success)

              #   $scope.videoImage = image
              #   URL.revokeObjectURL(url)

              #   # if (success) {
              #   #   var img = document.createElement('img');
              #   #   img.src = image;
              #   #   document.getElementsByTagName('div')[0].appendChild(img);
              #   # }
              #   # return success;
              # video.preload = 'metadata'
              # video.src = url
              # video.muted = true
              # video.playsInline = true
              # video.play()

              $timeout ->
                $scope.next_video_src = $sce.trustAsResourceUrl(url)
                $scope.next_video_type = file.type
              , 1

            fileReader.readAsArrayBuffer(file)

            $timeout ->
              $scope.videoFile = file
            , 1

          if $scope.next_video_src
            URL.revokeObjectURL($scope.next_video_src)
            $scope.next_video_src = null
            $scope.next_video_type = null
            $timeout loadVideo, 100
          else
            loadVideo()

        else
          alert "Tipo do arquivo de imagem não suportado #{file.type}"
      else
        $timeout ->
          $scope.imageFile = null
          $scope.imageFileSrc = null
          $scope.next_image_src = null
          $scope.videoFile = null
          $scope.next_video_src = null
        , 1

    $scope.cancel = ->
      $scope.editing_post_link_state = 'awaiting_url'
      $scope.editing_post = {
        facebook_points: 5,
        twitter_points: 5,
        linkedin_points: 5,
        instagram_points: 5,
        download_points: 5,
        notify_users: false,
        publish_on_timeline: false
      }

    buildFormDataParams = ->
      formData = new FormData
      if $scope.imageFile
        formData.append "employee_advocacy_post[image]", $scope.imageFile
        formData.append "employee_advocacy_post[remove_video]", null
      else
        formData.append "employee_advocacy_post[video]", $scope.videoFile
        formData.append "employee_advocacy_post[remove_image]", null
      formData

    afterSync = (post) ->
      $scope.loadingAll = false
      if $scope.imageFile || $scope.videoFile
        # now sync image
        post.withHttpConfig({
          transformRequest: angular.identity
        }).customPUT(
          buildFormDataParams(),
          undefined,
          undefined,
          {'Content-Type': undefined}
        ).then (resp)->
          # clear new post fields
          $scope.cancel()
          # refresh
          resetAndLoad()
          # clear image file
          $scope.imageFile = null

        .catch (resp) ->
          alert "Houve um erro ao tentar atualizar a Imagem."
      else
        # clear new post fields
        $scope.cancel()
        # refresh
        resetAndLoad()

    $scope.sync = ->
      if $scope.editing_post_link_state != 'loaded'
        return

      $scope.loadingAll = true

      data = {
        employee_advocacy_post: {
          title: $scope.editing_post.title
          content: $scope.editing_post.content
          url: $scope.editing_post.url
          active: $scope.editing_post.active
          facebook_points: $scope.editing_post.facebook_points
          twitter_points: $scope.editing_post.twitter_points
          linkedin_points: $scope.editing_post.linkedin_points
          instagram_points: $scope.editing_post.instagram_points
          download_points: $scope.editing_post.download_points
          folder: if $scope.editing_post.folder then $scope.editing_post.folder else null
          valid_until: $scope.editing_post.valid_until
          skip_timeline: ! $scope.editing_post.publish_on_timeline
        },
        notify_users: $scope.editing_post.notify_users
      }

      if $scope.editing_post.image and ! $scope.imageFile and $scope.editing_post.image != $scope.editing_post.original_image
        data.employee_advocacy_post.remote_image_url = $scope.editing_post.image

      if $scope.editing_post.id
        Restangular.all("api").one(
          'employee_advocacy_posts',
          $scope.editing_post.id
        ).customPUT(data).then afterSync

      else
        Restangular.all("api").all('employee_advocacy_posts').post(
          data).then afterSync

    $scope.openNewShare = ->
      $scope.editing_post_link_state = "loaded"
      $scope.editing_post = {
        title: ""
        content: ""
        image: ""
        notify_users: false
        publish_on_timeline: false
        facebook_points: 5
        twitter_points: 5
        linkedin_points: 5
        instagram_points: 5
        download_points: 5
        imageFile: null
      }

    $scope.loadUrl = ->
      if $scope.editing_post.url
        $scope.editing_post_link_state = "loading"

        Restangular.all("api").customGET(
          "/url_info_crawler",
          {url: $scope.editing_post.url}

        ).then (resp) ->
          $scope.editing_post_link_state = 'loaded'
          $scope.editing_post.title = resp.title
          $scope.editing_post.content = resp.description
          $scope.editing_post.image = resp.image
          $scope.editing_post.notify_users = false
          $scope.editing_post.publish_on_timeline = false
          $scope.imageFile = null

        .catch (resp) ->
          $scope.editing_post.title = null
          $scope.editing_post.content = null
          $scope.editing_post.image = null
          $scope.editing_post_link_state = 'error_loading'

    $scope.$watch "editing_post.url", (url) ->
      if $scope.disable_look_url == false
        if $scope.editing_post_timeout
          $timeout.cancel $scope.editing_post_timeout

        $scope.editing_post_timeout = $timeout $scope.loadUrl, 1000

    $scope.loadMore = ->
      $scope.currentPage += 1
      loadAll()

    loadTabs = ->
      Restangular.all('api').all("employee_advocacy_posts").customGET("folders").then (folders) ->
        count = folders.map (f) ->
          f.count
        .reduce((memo, i) ->
          memo + i
        , 0)

        folders.unshift({
          folder: i18next.t('views.dashboard.employee_advocacy.all'),
          count: count,
        })

        $scope.tabs = folders.filter (f) ->
          f.folder != null
    
    loadTabs().then ->
      if $scope.tabs.length == 1
        $scope.selectTab($scope.tabs[0])

    loadAll = ->
      params = {
        page: $scope.currentPage
      }

      if $scope.foo.selectedTab
        if $scope.foo.selectedTab.folder != i18next.t('views.dashboard.employee_advocacy.all')
          params['folder'] = $scope.foo.selectedTab.folder
      else
        return Promise.resolve(true)

      $scope.loadingAll = true
      Restangular.all('api').customGET("employee_advocacy_posts", params).then (posts) ->
        if posts.length == 0
          $scope.bottom = true
        $scope.loadingAll = false
        posts.forEach (post) ->
          post.original_image = post.image

        $scope.employee_advocacy_posts = $scope.employee_advocacy_posts.concat(posts)

        setTimeout ->
          window.notifyRender()
        , 2000

    loadAll().then ->
      id = parseInt $routeParams.id
      action = $routeParams.action
      social = $routeParams.social
      posts = $scope.employee_advocacy_posts.filter (post) ->
        post.id == id

      post = posts[0]

      if action == 'share' and social and post
        $scope.share(post, social)

    $scope.deletePost = (post) ->
      $scope.loadingAll = true
      $http.delete("/api/employee_advocacy_posts/#{post.id}").then resetAndLoad

    $scope.editPost = (post) ->
      $scope.disable_look_url = true
      $scope.editing_post_link_state = 'loaded'
      $scope.editing_post = post
      $timeout ->
        $scope.disable_look_url = false
      , 100

    $scope.getPostPoint = (post, social)->
      post["#{social}_points"]

    getSocialShare = (post, social) ->
      post.employee_advocacy_shares.filter (share) ->
        share.social_network == social

    $scope.currentUserHasSharedPost = (post, social) ->
      !!getSocialShare(post, social).length > 0

    $scope.currentUserShareClicks = (post, social) ->
      getSocialShare(post, social).reduce (memo, share) ->
          memo + share.visit_count
        , 0

    isApp = -> !!window.isApp
    instagramInstalled = -> !!window.instagramInstalled

    $scope.download = (post) ->
      baseUrl =  "#{location.protocol}//#{location.hostname}#{if location.port then ":#{location.port}" else ''}"
      if post.video
        mediaUrl = "#{baseUrl}#{post.video}"
      else
        mediaUrl = "#{baseUrl}#{post.image}"

      data = {
        employee_advocacy_share: {
          employee_advocacy_post_id: post.id,
          social_network: "download",
        }
      }

      $scope.loadingAll = true
      Restangular.all('api').all('employee_advocacy_shares').post(data).then (share) ->
        post.employee_advocacy_shares.push share
        $scope.loadingAll = false

        if window.isAndroid
          window.Android.download(mediaUrl)
        else if window.isIOS

          if post.video
            webkit.messageHandlers.downloadVideo.postMessage(mediaUrl)
          else
            webkit.messageHandlers.download.postMessage(mediaUrl)

        else
          window.open(mediaUrl);

    $scope.only_personal = window.CURRENT_DOMAIN.share_in_personal && !window.CURRENT_DOMAIN.share_in_fanpage

    $scope.only_fanpage = !window.CURRENT_DOMAIN.share_in_personal && window.CURRENT_DOMAIN.share_in_fanpage

    $scope.personal_and_fanpage = window.CURRENT_DOMAIN.share_in_personal && window.CURRENT_DOMAIN.share_in_fanpage

    $scope.share = (post, social)->
      $scope.createShareError = false
      if social == "download"
        $scope.download(post)
        return

      if social == "instagram"
        if !isApp()
          $scope.connect_account = $scope.socialOptions[social]
          $('#instagram-no-app').modal()
          return

        if !instagramInstalled()
          $scope.connect_account = $scope.socialOptions[social]
          $('#instagram-no-installed').modal()
          return

      if social == "facebook"
        $scope.new_share = {
          post: post
          employee_advocacy_post_id: post.id
          social: $scope.socialOptions[social]
          social_network: social
        }
        if $scope.only_personal
          $scope.shareInFacebookDialog(post, social)
          return

        if $scope.personal_and_fanpage
          $('#modal-select-where-to-publish').modal()
          return

        if $scope.only_fanpage
          $scope.shareDefault(post, social)

        else
          alert("Você deve habilitar o compartilhamento em páginas/feed pessoal.")
      else
        $scope.shareDefault(post, social)


    $scope.shareInFacebookDialog = (post, social) ->

      data = {
        employee_advocacy_share: {
          employee_advocacy_post_id: post.id
          user_content: post.content
          social_network: social
        }
      }

      promise = Restangular.all('api').all('employee_advocacy_shares/get_link').post(data).then (result) ->
        first_share = result["first_share"]
        share_id = result["id"]
        shortened_link = result["link"]

        if shortened_link
          if post.url
            url = shortened_link 
          else
            if post.image
              url = window.location.origin + post.image

          FB.ui
            method: 'feed',
            link: url,
            display: 'popup'
            (response) ->
              if response && !response.error_message
                Restangular.all('api').all('employee_advocacy_shares/create_share').post(data).then (share) ->
                  if share.points_added
                    showSuccessSharedModal(share, ! $scope.currentDomain.for_submission)
                  else
                    showSuccessSharedModal(share, false)
              else
                if first_share
                  $http.delete("/api/employee_advocacy_shares/delete_share/#{share_id}")
                    
      .catch (response) ->
        if response.data.error == 'limit_reached'
          alert("Você estourou a quota de compartilhamento diário. A quota atualmente é de #{response.data.limit} post(s) por dia.")
          
    $scope.shareDefault = (post, social) ->
      
      if social != 'instagram' &&  !socialNetworks[social]
        $scope.connect_account = $scope.socialOptions[social]
        $('#modal-auth').modal()
        return

      $scope.new_share = {
        post: post
        employee_advocacy_post_id: post.id
        social: $scope.socialOptions[social]
        social_network: social
      }

      if ! $scope.currentDomain.for_submission && post.content
        $scope.new_share.user_content = post.content

      $('#modal-create-post').modal()
      return

    openInstagramShare = (userContent, imageUrl)->
      $scope.loadingCreateShare = true
      $scope.createShareError = false
      $scope.errorMessage = null

      window.IOSInstagramAfterShare = window.instagramAfterShare = ->
        $timeout ->
          $scope.loadingCreateShare = false

      window.IOSInstagramFailure = ->
        $timeout ->
          $scope.createShareError = true
          $scope.loadingCreateShare = false
          $scope.errorMessage = "Houve um erro ao compartilhar no instagram, tente mais tarde"

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
        window.Android.shareInstagram("#{baseUrl}#{imageUrl}", userContent)
        window.instagramAfterShare()

    $scope.getSocialNetworksLoginUrl = (social_network) ->
      socialNetworksLoginUrl[social_network]

    $scope.passedLength = ->
      if $scope.new_share.social
        return $scope.new_share.social.maxlength - ($scope.new_share.user_content || "").length < 0

      return false

    $scope.getPoints = (social_network, post) ->
      post["#{social_network}_points"]


    $scope.createShare = ->
      if $scope.passedLength()
        alert "Tamanho máximo do texto ultrapassado, verifique o texto e tente novamente"
        return

      data = {
        employee_advocacy_share: {
          employee_advocacy_post_id: $scope.new_share.employee_advocacy_post_id
          user_content: $scope.new_share.user_content
          social_network: $scope.new_share.social_network
        }
      }

      if ! $scope.new_share.user_content
        alert "Você deve escrever algo ao compartilhar"
        return

      if $scope.new_share.social_network == "facebook"
        if not $scope.new_share.where_to_publish
          alert "Escolha onde você deseja publicar"
          return
        else
          data.employee_advocacy_share.where_to_publish = $scope.new_share.where_to_publish.id


      points = $scope.getPoints($scope.new_share.social_network, $scope.new_share.post)

      $scope.loadingCreateShare = true

      promise = Restangular.all('api').all('employee_advocacy_shares').post(data).then (share) ->

        if $scope.new_share.social_network == "instagram"
          link = share.social_json.reduce(
            (memo, i) ->
              i.link
            , ""
          )
          userContent = if link
            "#{$scope.new_share.user_content}"
          else
            $scope.new_share.user_content

          openInstagramShare(userContent, $scope.new_share.post.image)
        else if share.points_added
          showSuccessSharedModal(share, ! $scope.currentDomain.for_submission)
        else
          showSuccessSharedModal(share, false)
      .catch (response) ->
        if response.data.error == 'limit_reached'
          $scope.errorMessage = "Você estourou a quota de compartilhamento diário. A quota atualmente é de #{response.data.limit} post(s) por dia."
          # "You reached share limit. Currently is #{response.data.limit} post(s) by day."
          $scope.showAuthButton = false
        else
          $scope.errorMessage = response.data.message
          $scope.showAuthButton = true

        $scope.createShareError = true
      .finally ->
        $scope.loadingCreateShare = false

    showSuccessSharedModal = (share, withPoints) ->
      $scope.new_share.post.employee_advocacy_shares.push share
      points = $scope.new_share.post["#{$scope.new_share.social_network}_points"]
      $scope.share_ok = {
        points: points
        color: $scope.new_share.social.color
        social_slug: $scope.new_share.social.slug
      }

      $("#modal-create-post").modal("hide")

      if withPoints
        InterfacePoints.add(points)
        $("#modal-share-ok").modal()
      else
        $("#modal-share-ok-no-points").modal()

      # $('#modal-create-post').on 'hidden.bs.modal', ->
      #   if withPoints
      #     # InterfacePoints.add(points)
      #     $("#modal-share-ok").modal()
      #   else
      #     $("#modal-share-ok-no-points").modal()

      if share.badges_added
        share.badges_added.forEach (badge) ->
          Utils.showBadgeModal(badge, $scope)

    $scope.new_share = {}

    $scope.socialOptions = {
      facebook: {
        icon: 'facebook',
        slug: 'facebook',
        btn: 'facebook',
        name: 'Facebook',
        action_name: i18next.t('views.dashboard.employee_advocacy.buttons.post'),
        color: "#3b5a9a",
        maxlength: 600,
        auth_url: socialNetworksLoginUrl['facebook']
      },
      twitter: {
        icon: 'twitter',
        slug: 'twitter',
        btn: 'twitter',
        name: 'Twitter',
        action_name: i18next.t('views.dashboard.employee_advocacy.buttons.tweet'),
        color: "#29a9e1",
        maxlength: 110,
        auth_url: socialNetworksLoginUrl['twitter']
      },
      linkedin: {
        icon: 'linkedin',
        slug: 'linkedin',
        btn: 'linkedin',
        name: 'Linkedin',
        action_name: i18next.t('views.dashboard.employee_advocacy.buttons.post'),
        color: "#117bb8"
        maxlength: 256,
        auth_url: socialNetworksLoginUrl['linkedin']
      },
      instagram: {
        icon: 'instagram',
        slug: 'instagram',
        btn: 'instagram',
        name: 'Instagram',
        action_name: i18next.t('views.dashboard.employee_advocacy.buttons.open_app'),
        color: "#117bb8"
        maxlength: 200,
        auth_url: socialNetworksLoginUrl['instagram']
      }
    }

    if $location.search().open_share == "yes"
      $scope.openNewShare()

    loadTabs()

]
