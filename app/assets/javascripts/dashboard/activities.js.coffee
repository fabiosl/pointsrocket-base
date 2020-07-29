$(document).ready ->

  $('.activities-widget').each ->
    $this = $(this)
    pending = $this.data("pending")
    items_id = $this.data("items-id")
    $activitiesLoading = $this.find('.activities-loading')
    $loadMoreActivitiesBtn = $this.parent().find('a.load-more-activities')

    $loadMoreActivitiesBtn.click (e) ->
      e.preventDefault()

      $loadingIndicator = $(this).find('.indicator')
      $loadingIndicator.addClass('show')

      page = $(this).data('page')

      $.ajax(
        type: 'GET'
        url: '/dashboard/activities'
        data:
          page: page
          pending: pending
          items_id: items_id
        dataType: 'script'
      )
      .done ->
        $loadingIndicator.removeClass('show')
        $loadMoreActivitiesBtn.data('page', page + 1)
      .always ->
        $activitiesLoading.removeClass('show')
        $loadMoreActivitiesBtn.removeClass('hide')


    $loadMoreActivitiesBtn.trigger('click')
