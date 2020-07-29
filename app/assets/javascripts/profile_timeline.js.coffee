
$profileTimelineEvents = $('#profile-timeline-events')
$profileTimeline = $('#profile-timeline')
$emptyTimelineItems = $('#emptyTimelineItems')
$btnLoadMore = $('.btn-load-more')
timelineItemsCount = 0
currentPage = 1
isloading = false

getProfileTimelineItems = (userId, page = 1) ->
  isloading = true
  $.getJSON(
    "/api/timeline_items/profile/#{userId}"
    page: page
  )
  .done (response) ->
    timelineItemsCount = response.timeline_items.length
    showOrHideLoadMore(response.meta)
    renderTimelineItems(response.timeline_items)
    isloading = false
    showEmptyTimelineItems($emptyTimelineItems) if isTimelineItemsEmpty(timelineItemsCount, page)

renderTimelineItems = (items) ->
  for item in items
    entriesHtml = []
    for entry in item.entries
      entry.timelineable.json = JSON.parse(entry.timelineable.json) if entry.timelineable.json
      templateHtml = $("#template-#{entry.timelineable_type}").html()
      renderedHtml = Mustache.render(templateHtml, entry)
      entriesHtml.push(renderedHtml)

    $profileTimeline.append(
      "<li class='header year ellipsis'>#{item.day}</li>
        <li class='wrapper'>
          <ul class='events'>
            #{entriesHtml.join('')}
          </ul>
        </li>
      "
    )
    bindChallengesPosts()

bindChallengesPosts = ->
  # Limit text to a given number of chars
  $('.challenge-post-message').readmore
    collapsedHeight: 90
    moreLink: "<a href='#'>#{i18next.t('views.general.buttons.read_more')}</a>"
    lessLink: "<a href='#'>#{i18next.t('views.general.buttons.close')}</a>"

$('.btn-load-more').click (event) ->
  loadMore()


showOrHideLoadMore = (metaData) ->
  if hasNextItems(metaData) then $btnLoadMore.show() else $btnLoadMore.hide()

showEmptyTimelineItems = (element) ->
  element.show()

isTimelineItemsEmpty = (itemsCount, page) ->
  return true if itemsCount < 1 and page is 1
  return false

hasNextItems = (metaData) ->
  metaData.has_next_items

loadMore = ->
  if timelineItemsCount > 0 and !isloading
    getProfileTimelineItems(window.USER_ID, ++currentPage)


getProfileTimelineItems(window.USER_ID)


