$('.vote-button').not('.disabled').click ->
  vote($(this), $(this).data('url'))

$('.upvote-question, .downvote-question').click ->
  vote($(this), $(this).data('url'))

vote = (object, url) ->
  data =
    question_id: object.data('question-id')

  $.ajax
    url: url
    data: data
    method: 'post'
    dataType: 'json'
    success: (response) ->
      if object.hasClass("vote-question")
        $('div[data-question-id=' + response.id + ']').html(response.total_votes)
        $('a[data-question-id=' + response.id + ']').removeClass('voted')

      if object.hasClass("vote-answer")
        $('div[data-answer-id=' + response.id + ']').html(response.total_votes)
        $('a[data-answer-id=' + response.id + ']').removeClass('voted')

      if response.total_upvotes != 0 || response.total_downvotes != 0
        object.addClass('voted')


$(document).ready ->
  $(document).on 'submit', 'form.form-async-editable', (e) ->
    e.preventDefault()

    $submitBtn = $(this).find('input:submit')
    $textareaContent = $('textarea.textarea_content')
    $contentEditable = $('.editable-content')
    
    $submitBtn.prop('disabled', true)
    $textareaContent.val $contentEditable.html()

    this.submit()
    return
  return

# TO-DO: Create a plugin/extension to remove this code duplication
$('.editable-content').atwho
  at: '@'
  displayTpl: "<li><img src='${avatar}' height='25' width='25'/> ${name} </li>"
  insertTpl: "<span class='user-mention' data-mention-user-id=${id}>@${name}</span>"
  callbacks:
    sorter: (query, items, searchKey) ->
      items

    remoteFilter: (query, callback) ->
      if (query.length < 1)
        return false
      else
        $.getJSON '/dashboard/usuarios/members', { search: query }, (data) ->
          callback data.users
