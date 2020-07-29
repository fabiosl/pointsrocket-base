#= require ./lib/on-screen-1.2.0.umd.min.js

do ->
  os = new OnScreen(
    tolerance: 50
    debounce: 100
    container: window
  )
  # Do something when an element enters the viewport
  os.on 'enter', '.on-screen-element', (element) ->
    postId = element.getAttribute('data-post-id')
    postViewerIds = element.getAttribute('data-post-viewer-ids').split(',')
    # Check if current user viewed the current post element
    currentUserViewedPost = postViewerIds.some((item) ->
      parseInt(item, 10) == window.CURRENT_USER.id
    )

    unless currentUserViewedPost
      $.post('/api/posts/' + postId + '/view', {}).done((data) ->
        element.setAttribute 'data-post-viewer-ids', data.post.viewer_ids
        return
      ).fail (error) ->
        console.log error
        return
    return
  return
