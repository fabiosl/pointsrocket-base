# TO-DO: Search for a more appropriate way to build this template
buildCommentElement = (data) ->
  return unless data
  template = $('#template-comment').html()
  Mustache.render(template, data)

addCommentToList = (commentData, commentsListElement) ->
  return unless commentBelongsToList(commentData, commentsListElement)

  commentElement = buildCommentElement(commentData)

  $commentsList = commentsListElement
  $commentsList.append(commentElement)
  $commentsList.scrollTop(0)

commentBelongsToList = (commentData, $list) ->
  commentData['commentable_id'] is $list.data('commentable-id') and
  commentData['commentable_type'] is $list.data('commentable-type')

window.addCommentToList = (comment, $list) ->
  addCommentToList(comment, $list)