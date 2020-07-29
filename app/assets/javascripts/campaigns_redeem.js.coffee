do ->

  $('.btn-redeem-campaign').on "click", (e) ->
    $this = $(this)
    window.loader.show()

    $.ajax {
      method: 'POST',

      url: '/api/campaign_users',

      data: {
        campaign_user: {
          campaign_id: $this.data('campaign-id')
        }
      },

      dataType: 'json',

      success: ->
        $this.parents('.modal').modal("hide")
        $($this.data('target')).modal().on "hidden.bs.modal", ->
          window.loader.show()
          location.reload()

      error: ->
        $.gritter.add {
          title: i18next.t('controllers.general.error.title'),
          text: i18next.t('controllers.general.error.save'),
          sticky: false
        }

      complete: ->
        window.loader.hide()

    }
