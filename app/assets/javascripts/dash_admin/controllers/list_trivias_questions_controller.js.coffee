dash_admin.controller 'ListTriviasQuestionsController', [
  '$scope', 'Api', '$routeParams', '$timeout'
  ($scope, Api, $routeParams, $timeout) ->

    $scope.loading = true

    templates = {
      question: {
        trivias_options: []
      },
      trivias_options: {

      }
    }

    buildParams = ->
      trivias_questions: $scope.trivias_questions.map (trivias_question) ->
        id: trivias_question.id
        _destroy: trivias_question._destroy
        name: trivias_question.name
        options_attributes: trivias_question.trivias_options.map (trivias_option) ->
          id: trivias_option.id
          _destroy: trivias_option._destroy
          name: trivias_option.name
          correct: trivias_option.correct

    $scope.addQuestion = ->
      $scope.trivias_questions.push angular.copy(templates.question)

    $scope.addOption = (question)->
      question.trivias_options.push angular.copy(templates.trivias_options)

    $scope.delete = (thing) ->
      thing._destroy = true

    $scope.undelete = (thing) ->
      thing._destroy = null

    $scope.sync = ->
      $scope.loading = true

      Api.one($routeParams.domain_id).all(
        'trivias_questions'
      ).all(
        'sync'
      ).customPOST(buildParams()).then ->
        reloadQuestions()
        alert "Sincronizados com sucesso"

    $scope.domain_id = $routeParams.domain_id

    reloadQuestions = ->
      $scope.loading = true
      Api.one($routeParams.domain_id).all('trivias_questions').getList().then (trivias_questions) ->
        $scope.trivias_questions = trivias_questions
        $scope.loading = false

    reloadQuestions()

]
