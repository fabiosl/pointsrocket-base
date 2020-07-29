#= require lib/owl.carousel2

$owl = $('#owlCarousel')
owlCurrentItemIndex = 0
owlPage = 1

$owl.owlCarousel({
  dots: false,
  autoWidth: true,
  margin: 10
})

$owl.on 'changed.owl.carousel', (event) ->
  if event.item.index > owlCurrentItemIndex
    owlCurrentItemIndex = event.item.index
    loadCarouselActivities()

$(document).ready ->
  loadCarouselActivities()

loadCarouselActivities = ->
  page = $owl.data('page')
  totalPages = $owl.data('total-pages')

  return if page > totalPages

  $.ajax(
    type: 'GET'
    url: '/dashboard/carousel_activities'
    data: page: page
    dataType: 'script'
  )
  .done ->
    $owl.data('page', page + 1)
    $owl.attr('data-page', page + 1)
  
  return
