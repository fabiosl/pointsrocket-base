#= require angular


trivias = angular.module 'trivias', []

trivias.value "DEFAULT_RESPONSE_SECONDS", 20

trivias.factory 'TriviasQuestionService', [
  '$http', '$q',
  ($http, $q) ->
    class TriviasQuestionService

      @getRandomQuestion = (playId)->
        $http.get '/dashboard/trivias/api/questions/random_question',
          params: {play_id: playId}

      @answerQuestion = (playId, questionId, optionId, secondsTook) ->
        console.dir(arguments)

        $http.post '/dashboard/trivias/api/answers',
          {
            play_id: playId,
            question_id: questionId,
            option_id: optionId,
            seconds_took: secondsTook
          }

      @blockUser = (playId, reason) ->
        $http.post "/dashboard/trivias/api/plays/#{playId}/block",
          {
            reason: reason
          }

]

trivias.directive "circleAnimator", [ ->
  restrict: 'A'
  scope:
    percentage: "@"
    dasharray: "@"
  link: (scope, elem, attrs) ->
    scope.$watch "percentage", (value) ->
      newDashArray = scope.dasharray * value
      elem.css "stroke-dashoffset", newDashArray

]

trivias.controller 'TriviasQuestionController', [
  '$scope', 'TriviasQuestionService', '$timeout', '$interval', 'DEFAULT_RESPONSE_SECONDS'
  ($scope, TriviasQuestionService, $timeout, $interval, DEFAULT_RESPONSE_SECONDS) ->

    $scope.counter = 0
    $scope.answering = false

    bindHiddenToBack = (modal) ->
      modal.on 'hidden.bs.modal', ->
        window.location.href = '/dashboard/trivias'

    bindHiddenToNext = (modal) ->
      modal.on 'hidden.bs.modal', ->
        reloadQuestion()

    showModalTempoEsgotado = ->
      $('#modal-tempo-esgotado').modal('show')
      bindHiddenToBack $('#modal-tempo-esgotado')

    stopTimer = ->
      if $scope.timer
        $interval.cancel $scope.timer

    startTimer = ->
      $scope.seconds = DEFAULT_RESPONSE_SECONDS
      $scope.circlePercentage = 1
      $scope.timer = $interval ->
        $scope.seconds = $scope.seconds - 1
        $scope.circlePercentage = $scope.seconds / DEFAULT_RESPONSE_SECONDS

        if $scope.seconds == 0
          stopTimer()
          # showModalTempoEsgotado()
          # TriviasQuestionService.blockUser($scope.playId, "time")
      , 1000
      return

    reloadQuestion = ->
      $scope.counter += 1
      $scope.question = null

      TriviasQuestionService.getRandomQuestion($scope.playId).then (response) ->
        $scope.question = response.data.question
        startTimer()

      .catch (response) ->
        if response.status == 404
          $('#modal-sem-perguntas').modal('show')
          bindHiddenToBack $('#modal-sem-perguntas')
        else
          $('#modal-erro-interno').modal('show')
          bindHiddenToBack $('#modal-erro-interno')

    # vem do ng init
    $scope.setPlayId = (playId) ->
      $scope.playId = playId
      reloadQuestion()

    $scope.selectAnswer = (option) ->

      if not $scope.answering
        stopTimer()
        $scope.pointsWon = $scope.seconds

        $scope.answering = true
        option.answering = true

        $timeout ->
          TriviasQuestionService.answerQuestion(
            $scope.playId,
            $scope.question.id,
            option.option.id,
            $scope.pointsWon
          ).then (response) ->

            option.correct = response.data.answer.correct
            option.answering = false

            $timeout ->
              if option.correct
                addPoints($scope.pointsWon)
                $timeout ->
                  $scope.answering = false
                  $('#modal-acerto').modal('show')
                  bindHiddenToNext $('#modal-acerto')
                , 1000
              else
                TriviasQuestionService.blockUser($scope.playId, "wrong")
                $('#modal-erro').modal('show')
                bindHiddenToBack $('#modal-erro')
            , 500

        , 1000


    addPoints = (points) ->
      jQuery(Counter: CURRENT_USER_POINTS).animate { Counter: CURRENT_USER_POINTS + points},
        duration: 1000
        easing: 'swing'
        step: ->
          $('#user_points').text Math.ceil(@Counter)
          return

      CURRENT_USER_POINTS += points

]

