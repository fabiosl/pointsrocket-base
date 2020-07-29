dash_admin.controller 'EditCoursesController', [
  '$scope', 'Api', '$routeParams', '$timeout', '$route', '$location',
  ($scope, Api, $routeParams, $timeout, $route, $location) ->

    confirmExit = ->
      i18next.t('controllers.general.actions.confirm_exit')

    $scope.loading = true
    $scope.changed = false
    $scope.courseTotalPoints = 0
    $scope.allQuestionsCorrectOption = false

    $('#back-button').on 'click', (e) ->
      if $scope.changed
        if not confirm(confirmExit())
          e.preventDefault()

    $scope.someStepQuestionOptionSelected = (stepQuestion) ->
      stepQuestion.step_question_options.some (option) ->
        option.correct

    countCoursePoints = (course) ->
      return 0 unless course
      course.finish_badge_points = course.finish_badge_points || 0
      stepQuestionsPoints = 0

      stepsPoints = course.chapters.filter (chapter) ->
        !chapter._destroy
      .map (chapter) ->
        chapter.steps
      .reduce (a, b) ->
        a.concat(b)
      , []
      .filter (step) ->
        !step._destroy
      .reduce (total, step) ->
        stepQuestions = step.step_questions.filter (stepQuestion) ->
          !stepQuestion._destroy

        $scope.allQuestionsCorrectOption = stepQuestions.every (stepQuestion) ->
          stepQuestion.step_question_options.some (option) ->
            option.correct

        stepQuestionsPoints = stepQuestions.map (item) ->
          Number(item.score) || 0
        .reduce (sum, score) ->
          sum + score
        , 0

        total + Number(step.score) + stepQuestionsPoints
      , 0

      course.finish_badge_points + stepsPoints

    $scope.$watch 'course', (value) ->
      return unless value
      $scope.courseTotalPoints = countCoursePoints(value)
      $scope.changed = true

    , true

    $scope.resetStepScore = (step) ->
      if step.step_type is 'Quiz'
        step.score = 0
        step.step_questions.push(
          {
            score: 0
            step_question_options: [{}, {}]
          }
        )
      else
        step.step_questions = []
      

    $scope.$watch 'changed', (changed) ->
      if changed
        window.onbeforeunload = confirmExit
      else
        window.onbeforeunload = null


    errorMapping = {
      "avatar": i18next.t('views.dashboard.admin.chapters.fields.main_image')
      "description": i18next.t('controllers.courses.edit.fields.description')
      "chapters.steps.name": i18next.t('controllers.courses.edit.fields.step.name')
      "chapters.steps.step_questions.question": i18next.t('controllers.courses.edit.fields.step.question')
    }

    $scope.getError = (key) ->
      keyMapping = errorMapping[key]
      if !keyMapping
        keyMapping = key

      "#{keyMapping}: #{$scope.errors[key].join(', ')}"

    templates = {
      alleatory_course: {
        name: "#{i18next.t('controllers.courses.edit.fields.random_name')}"
        description: i18next.t('controllers.courses.edit.fields.random_description')
        chapters: [
          {
            name: "#{i18next.t('controllers.courses.edit.fields.random_name')} 1"
            description: "#{i18next.t('views.dashboard.admin.chapters.fields.description')} 1"
            position: 0
            steps: [
              {
                name: "#{i18next.t('views.dashboard.admin.chapters.fields.step_title')} 1"
                step_type: i18next.t('views.dashboard.admin.chapters.fields.step.video')
                url: "https://www.youtube.com/embed/yYFH1t5IMTE"
                score: 0
                position: 0
                archives: []
                step_questions: []
              }, {
                name: "#{i18next.t('views.dashboard.admin.chapters.fields.step_title')} 2"
                step_type: i18next.t('views.dashboard.admin.chapters.fields.step.video')
                url: "https://www.youtube.com/embed/yYFH1t5IMTE"
                score: 0
                position: 1
                archives: []
                step_questions: []
              }, {
                name: "#{i18next.t('views.dashboard.admin.chapters.fields.step_title')} 3"
                step_type: i18next.t('views.dashboard.admin.chapters.fields.step.quiz')
                score: 0
                position: 2
                archives: []
                step_questions: [
                  {
                    hint: i18next.t('controllers.courses.edit.fields.question_hint')
                    question: "#{i18next.t('views.dashboard.admin.chapters.fields.step.question')} 1"
                    score: 0
                    position: 0
                    step_question_options: [
                      {
                        content: i18next.t('controllers.courses.edit.fields.step.wrong_answer')
                        correct: false
                      }, {
                        content: i18next.t('controllers.courses.edit.fields.step.correct_answer')
                        correct: true
                      }
                    ]
                  }
                ]
              }
            ]
          }, {
            name: "#{i18next.t('views.dashboard.admin.chapters.chapter')} 2"
            description: "#{i18next.t('views.dashboard.admin.chapters.fields.description')} 2"
            position: 1
            steps: [
              {
                name: "#{i18next.t('views.dashboard.admin.chapters.fields.step_title')} 1"
                step_type: i18next.t('views.dashboard.admin.chapters.fields.step.video')
                url: "https://www.youtube.com/embed/yYFH1t5IMTE"
                score: 0
                position: 0
                archives: []
                step_questions: []
              }, {
                name: "#{i18next.t('views.dashboard.admin.chapters.fields.step_title')} 2"
                step_type: i18next.t('views.dashboard.admin.chapters.fields.step.video')
                url: "https://www.youtube.com/embed/yYFH1t5IMTE"
                score: 0
                position: 1
                archives: []
                step_questions: []
              }, {
                name: "#{i18next.t('views.dashboard.admin.chapters.fields.step_title')} 3"
                step_type: i18next.t('views.dashboard.admin.chapters.fields.step.quiz')
                score: 0
                position: 2
                archives: []
                step_questions: [
                  {
                    hint: i18next.t('controllers.courses.edit.fields.question_hint')
                    question: "#{i18next.t('views.dashboard.admin.chapters.fields.step.question')} 1"
                    score: 0
                    position: 0
                    step_question_options: [
                      {
                        content: i18next.t('controllers.courses.edit.fields.step.wrong_answer')
                        correct: false
                      }, {
                        content: i18next.t('controllers.courses.edit.fields.step.correct_answer')
                        correct: true
                      }
                    ]
                  }
                ]
              }
            ]
          }

        ]
      }
      course: {
        points: 0
        chapters: []
      },
      archive: {
      },
      chapter: {
        description: ""
        name: ""
        steps: [
          {
            name: ""
            position: 0
            step_type: "Vídeo"
            score: 0
            step_questions: []
            archives: []
          }
        ]
      },
      step: {
        name: ""
        step_type: "Vídeo"
        score: 0
        step_questions: []
        archives: []
      },
      question: {
        score: 0
        step_question_options: [{}, {}]
      },
      step_question_option: {
      }
    }

    $scope.addQuestion = (step) ->
      newQuestion = angular.copy templates.question
      newQuestion.position = step.step_questions.length
      step.step_questions.push newQuestion

      $timeout ->
        remakeSortables()
      , 200

    $scope.setCourseFinishBadge = (fileList) ->
      if fileList.length > 0
        file = fileList[0]
        if file.type.startsWith('image/')
          reader = new FileReader
          reader.onload = (e) ->
            $timeout ->
              $scope.newCourseFinishBadgeSrc = e.target.result
            , 1
          reader.readAsDataURL(file)

          $timeout ->
            $scope.newCourseFinishBadge = file
          , 1
        else
          alert "#{i18next.t('controllers.general.unsupported_image_type')} #{file.type}"
      else
        $timeout ->
          $scope.newCourseFinishBadge = null
          $scope.newCourseFinishBadgeSrc = null
        , 1

    $scope.setCurrentArchiveForFile = (archive) ->
      $scope.currentArchiveForFile = archive

    $scope.setArchive = (fileList) ->
      if fileList.length > 0
        file = fileList[0]
      else
        file = null

      $timeout ->
        $scope.currentArchiveForFile.archive = file

        if file
          $scope.currentArchiveForFile.archive_name = file.name
        else
          $scope.currentArchiveForFile.archive_name = null
      , 1

    $scope.setAvatar = (fileList) ->
      if fileList.length > 0
        file = fileList[0]
        if file.type.startsWith('image/')
          reader = new FileReader
          reader.onload = (e) ->
            $timeout ->
              $scope.newAvatarSrc = e.target.result
            , 1
          reader.readAsDataURL(file)

          $timeout ->
            $scope.newAvatar = file
          , 1
        else
          alert "#{i18next.t('controllers.general.unsupported_image_type')} #{file.type}"
      else
        $timeout ->
          $scope.newAvatar = null
          $scope.newAvatarSrc = null
        , 1

    $scope.deleteChapter = (chapter) ->
      chapter._destroy = true

    $scope.undeleteChapter = (chapter) ->
      chapter._destroy = false

    $scope.deleteStep = (step) ->
      step._destroy = true

    $scope.undeleteStep = (step) ->
      step._destroy = false

    $scope.deleteQuestion = (step_question) ->
      step_question._destroy = true

    $scope.undeleteQuestion = (step_question) ->
      step_question._destroy = false

    $scope.deleteArchive = (archive) ->
      archive._destroy = true

    $scope.undeleteArchive = (archive) ->
      archive._destroy = false

    $scope.deleteOption = (step_question_option) ->
      step_question_option._destroy = true

    $scope.undeleteOption = (step_question_option) ->
      step_question_option._destroy = false

    $scope.addChapter = ->
      $scope.course.chapters.push angular.copy(templates.chapter)

      $timeout ->
        remakeSortables()
      , 200

    $scope.addStep = (chapter) ->
      newStep = angular.copy templates.step
      newStep.position = chapter.steps.length
      chapter.steps.push newStep

      $timeout ->
        remakeSortables()
      , 200

    $scope.addArchive = (step) ->
      newArchive = angular.copy templates.archive
      step.archives.push newArchive

    $scope.addQuestion = (step) ->
      newQuestion = angular.copy templates.question
      newQuestion.position = step.step_questions.length
      step.step_questions.push newQuestion

      $timeout ->
        remakeSortables()
      , 200

    $scope.addOption = (step_question) ->
      newOption = angular.copy templates.step_question_option
      step_question.step_question_options.push newOption

      $timeout ->
        remakeSortables()
      , 200

    buildParams = ->
      finalParams = {
        course: {
          id: $routeParams.id
          name: $scope.course.name
          description: $scope.course.description
          slug: $scope.course.slug
          finish_badge_id: $scope.course.finish_badge_id
          finish_badge_points: $scope.course.finish_badge_points
          preview_url: $scope.course.preview_url
          active: $scope.course.active
          monitor_html: $scope.course.monitor_html
          chapters_attributes: $scope.course.chapters.map (chapter) ->
            {
              id: chapter.id
              name: chapter.name
              description: chapter.description
              position: chapter.position
              _destroy: chapter._destroy
              steps_attributes: chapter.steps.map (step) ->
                {
                  id: step.id
                  name: step.name
                  description: step.description
                  step_type: step.step_type
                  score: step.score
                  url: step.url
                  position: step.position
                  _destroy: step._destroy
                  archives_attributes: step.archives.map (archive) ->
                    id: archive.id
                    archive: archive.archive
                    _destroy: archive._destroy
                  step_questions_attributes: step.step_questions.map (step_question) ->
                    {
                      id: step_question.id
                      hint: step_question.hint
                      position: step_question.position
                      question: step_question.question
                      score: step_question.score
                      _destroy: step_question._destroy
                      step_question_options_attributes: step_question.step_question_options.map (step_question_option) ->
                        {
                          id: step_question_option.id
                          content: step_question_option.content
                          correct: step_question_option.correct
                          _destroy: step_question_option._destroy
                        }
                    }
                }
            }
        }
      }

      if $scope.newAvatar
        finalParams.course.avatar = $scope.newAvatar

      if $scope.newCourseFinishBadge
        finalParams.course.finish_badge_image = $scope.newCourseFinishBadge

      if $scope.course.delete_finish_badge_points
        finalParams.course.delete_finish_badge_points = $scope.course.delete_finish_badge_points

      finalParams

    buildFormDataParams = ->
      params = buildParams()
      formData = new FormData
      paramsFormData = fromObj(params)
      for k, v of paramsFormData
        if v != undefined and v != null
          formData.append k, v
      formData

    $scope.domainsCoursesPath = ->
      "/dashboard/admin/courses"

    afterSync = (resp) ->
      if $scope.newCourseFinishBadgeSrc
        $scope.course.finished_course_badge_url = $scope.newCourseFinishBadgeSrc
        $scope.newCourseFinishBadgeSrc = null

      if $scope.newAvatarSrc
        $scope.course.avatar_url = $scope.newAvatarSrc
        $scope.newAvatarSrc = null

      if $scope.course.delete_finish_badge_points
        $scope.course.finished_course_badge_url = null
        $scope.newCourseFinishBadgeSrc = null
        $scope.course.finish_badge_id = null
        $scope.course.finish_badge_points = null
        $scope.newCourseFinishBadge = null
        $scope.course.delete_finish_badge_points = false

      $scope.course.finish_badge_id = resp.finish_badge_id

    $scope.sync = ->
      return unless $scope.allQuestionsCorrectOption
      $scope.loading = true
      $scope.errors = null

      # $scope.course.chapters_attributes = $scope.course.chapters
      # $scope.course.chapters_attributes.forEach (chapter) ->
      #   chapter.steps_attributes = chapter.steps
      #   chapter.steps_attributes.forEach (step) ->
      #     step.step_questions_attributes = step.step_questions
      #     step.step_questions_attributes.forEach (step_question) ->
      #       step_question.step_question_options_attributes = step_question.step_question_options

      handleError = (data) ->
        $scope.errors = data
        alert i18next.t('controllers.general.error.update')
        $('html, body').animate({scrollTop: 0})

      if $scope.course.id
        $scope.course.withHttpConfig({transformRequest: angular.identity}).customPUT(buildFormDataParams(), undefined, undefined, {'Content-Type': undefined}).then (resp)->
          afterSync(resp)
          alert i18next.t('controllers.general.success.update')
        .catch (resp) ->
          handleError(resp.data)
        .finally ->
          $scope.loading = false

      else
        Api.all(
          'courses'
        ).withHttpConfig({transformRequest: angular.identity}).customPOST(buildFormDataParams(), undefined, undefined, {'Content-Type': undefined}).then (resp)->
          afterSync(resp)
          alert "#{ i18next.t('controllers.courses.course')} #{i18next.t('controllers.general.success.create')}"
          $location.path "/courses"
        .catch (resp) ->
          handleError(resp.data)
        .finally ->
          $scope.loading = false

    remakeSortables = ->

      $(".chapters-list").sortable
        items: '> .panel'
        # cancel: '.panel-collapse'
        opacity: 0.8
        coneHelperSize: true
        placeholder: 'ui-sortable-placeholder'
        forcePlaceholderSize: true
        tolerance: 'pointer'
        helper: 'clone'
        update: ( event, ui ) ->
          # console.dir arguments

          $('.chapter_position').each (i)->
            this.value = i
            $(this).trigger('input')
          # $scope.course.chapters.forEach (chapter) ->

      $(".chapters-list").disableSelection();

      $timeout ->

        $(".steps-list").sortable
          # não consegui conectar os itens do sortable
          connectWith: ".steps-list"
          items: '> .panel'
          opacity: 0.8
          coneHelperSize: true
          placeholder: 'ui-sortable-placeholder'
          forcePlaceholderSize: true
          tolerance: 'pointer'
          helper: 'clone'
          update: ( event, ui ) ->
            $('.chapter').each ->
              $(this).find('.step_position').each (i)->
                this.value = i
                $(this).trigger('input')

        $(".steps-list").disableSelection();
      , 500

    if $routeParams.id
      Api.one(
        'courses', $routeParams.id
      ).get().then (course) ->
        $scope.loading = false
        $scope.course = course

        $timeout ->
          $scope.changed = false
        , 200

        remakeSortables()
    else
      $scope.loading = false

      if $route.current.$$route.alleatory
        $scope.course = angular.copy templates.alleatory_course
      else
        $scope.course = angular.copy templates.course
        $scope.course.chapters.push angular.copy(templates.chapter)

      $timeout ->
        $scope.changed = false
      , 200

      remakeSortables()

]
