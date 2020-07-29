$('.quiz-question-tab').first().addClass('current')

$('.step_question_trigger').on 'click', (e) ->

    $this = $("##{$(this).data('id')}")

    $this.parent().find('.quiz-question-tab').removeClass('current')
    $(this).parent().addClass('current')

    $this.parent().find('.step_question').removeClass('active')
    $this.addClass('active')

$('.step_question').on 'click.answer', '.btn-question', (e) ->
  $this = $(this)
  $question_container = $this.parents('.question-container')
  $step_question = $this.parents('.step_question')

  $step_question_trigger = $(".step_question_trigger[data-id=#{$this.data('step-question-id')}]")

  data =
    question_answer:
      step_question_id: $this.data('step-question-id')
      step_question_option_id: $this.data('step-question-option-id')

  # url quiz QUESTION_ANSWERS_PATH
  $question_container.find('.indicator').addClass('show')
  $.ajax(
    url: "#{QUESTION_ANSWERS_PATH}.json"
    data: data
    method: 'post'
    dataType: 'json'
  )
  .done (response) ->
      $this.parents('.question-container')
           .find('.btn-question')
           .removeClass('correct-answer')
           .removeClass('wrong-answer')

      if response.correct
        the_class = 'correct-answer animation animating pulse'
        text = i18next.t('views.dashboard.courses.show.answers.got_correct')
        $question_container.unbind('click.answer');
        $question_container.find('.btn-question').attr("disabled", "disabled");
        $question_container.find('.step-points').addClass("animation animating wobble");
        $step_question.find('.btn-next-question').removeAttr("disabled");

        $step_question_trigger.parent().removeClass('error').addClass('done');

        # se for a ultima questao
        if $step_question.attr('id') == $step_question.parent().find('.step_question').last().attr('id')
          $('.next-step-button').removeClass('hidden')

        # $('#user_points').addClass("animation animating bounceIn");

        # points = parseInt($this.data('points'))

        # jQuery(Counter: CURRENT_USER_POINTS).animate { Counter: CURRENT_USER_POINTS + points},
        #   duration: 1000
        #   easing: 'swing'
        #   step: ->
        #     $('#user_points').text Math.ceil(@Counter)
        #     return
        #   done: ->
        #     $question_container.find('.step-points').removeClass('animation animating wobble')

        # CURRENT_USER_POINTS += points
      else
        the_class = 'wrong-answer animation animating shake'
        text = i18next.t('views.dashboard.courses.show.answers.got_wrong')

        $step_question_trigger.parent().addClass('error')

      $this.addClass the_class

      setTimeout ->
        $this.removeClass "animation animating shake"
      , 1000

      $this.parents('.question-container').find('.alert').html text
    .always ->
      $question_container.find('.indicator').removeClass('show')

$('.btn-next-question ').on 'click', ->
  $('.step_question_trigger').eq(parseInt($(this).data('index')) + 1).trigger('click')
