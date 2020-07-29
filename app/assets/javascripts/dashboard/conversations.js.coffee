app = new Vue
  el: '#vue-conversations'
  components:
    'carousel': VueCarousel.Carousel
    'slide': VueCarousel.Slide
  data:
    conversation:
      recipient:
        name: ''
      messages: []
    users: []
    searchQuery: ''
    sendingMessage: false
    loading: false
    newMessage:
      body: ''

  mounted: ->
    this.$refs.loadingPage.classList.remove('show')
    this.getUsers()

    # Check if a recipient param is passed. If so, get the user, otherwise
    # get all users
    recipient_id_param = window.location.search.slice(1).split('recipient_id=')[1]
    this.getUser(recipient_id_param) if recipient_id_param
    

  computed:
    filteredUsers: ->
      _.chain(this.users)
        .uniqBy('id')
        .orderBy(['current_user_unread_messages_count', 'name'], ['desc', 'asc'])
        .value()

  watch:
    searchQuery: _.debounce ->
      this.searchUsers()
    , 500

  methods:
    getUser: (id) ->
      self = this

      $.get(
        "/dashboard/usuarios/#{id}.json"
      )
      .done (data) ->
        self.users.unshift(data.user)
        self.startConversation(data.user)

    getUsers: ->
      self = this

      $.get(
        "/dashboard/usuarios/members.json"
      )
      .done (data) ->
        self.resetConversation()
        self.users = data.users

    searchUsers: () ->
      self = this

      $.get(
        "/dashboard/usuarios/members.json"
        { search: this.searchQuery }
      )
      .done (data) ->
        self.resetConversation()
        self.users = data.users

    resetConversation: ->
      this.conversation =
        recipient:
          name: ''
        messages: []

    getConversation: (id) ->
      self = this

      $.get("/dashboard/conversations/#{id}")
        .done (data) ->
          self.conversation = data

    startConversation: (user) ->
      return if user.selected
      self = this
      sender_id = window.CURRENT_USER.id
      self.loading = true

      $.post(
        "/dashboard/conversations"
        { conversation: { sender_id: sender_id, recipient_id: user.id } }
      )
      .done (data) ->
        self.read_all_user_conversation_messages(user, data)
        self.users.map (item) ->
          item.selected = user.id is item.id

        self.conversation = data
        self.scrollMessagesContainerToBottom()
      .always ->
        self.loading = false

    read_all_user_conversation_messages: (user, conversation) ->
      $.post(
        "/dashboard/conversations/#{conversation.id}/messages/read_all"
        { _method: 'patch' }
      )
      .done ->
        user.has_current_user_unread_messages = false

    startFirstUserConversation: ->
      return if this.users.length < 1
      this.startConversation(this.users[0])

    createMessage: ($event) ->
      $event.preventDefault()
      $messageContentEditable = $('.conversation-message-content')
      this.newMessage.body = $messageContentEditable.text()
      return if this.sendingMessage or this.newMessage.body == ''

      if ! this.sendingMessage
        this.sendingMessage = true

      self = this
      self.loading = true

      $.post(
        "/dashboard/conversations/#{this.conversation.id}/messages"
        { message: this.newMessage }
      )
      .done (data) ->
        self.conversation.messages.push(data.message)
        self.newMessage.body = ''
        $messageContentEditable.html('')
        self.scrollMessagesContainerToBottom()
      .always ->
        self.loading = false
        self.sendingMessage = false

    scrollMessagesContainerToBottom: ->
      messagesContainer = this.$el.querySelector('.messages-container')

      setTimeout ->
        messagesContainer.scrollTop = messagesContainer.scrollHeight
