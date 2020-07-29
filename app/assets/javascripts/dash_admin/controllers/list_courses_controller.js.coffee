dash_admin.controller 'ListCoursesController', [
  '$scope', 'Api', '$routeParams', '$timeout'
  ($scope, Api, $routeParams, $timeout) ->

    $scope.deleteCourse = (course) ->
      num1 = Math.floor(Math.random() * 5 + 1)
      num2 = Math.floor(Math.random() * 5 + 1)

      if prompt("#{i18next.t('controllers.general.actions.confirm_delete_answer')}: #{num1} + #{num2} = ?") != ((num1 + num2) + '')
        alert i18next.t(
          'controllers.general.error.confirm_delete_answer',
          { resource: i18next.t('controllers.badges.badge') }
        )
        return false

      $scope.loading = true

      course.remove().then ->
        alert i18next.t('controllers.general.success.delete')

        $scope.courses = $scope.courses.filter (c) ->
          c.id != course.id

      .catch ->
        alert i18next.t('controllers.general.error.delete')

      .finally ->
        $scope.loading = false

    $scope.loading = true

    Api.all('courses').getList().then (courses) ->
      $scope.courses = courses

      $timeout ->
        $scope.loading = false

        $("#courses-list").sortable
          connectWith: '.panel'
          items: '.panel'
          opacity: 0.8
          coneHelperSize: true
          placeholder: 'ui-sortable-placeholder'
          forcePlaceholderSize: true
          tolerance: 'pointer'
          helper: 'clone'

        $("#courses-list").disableSelection();
      , 100


]
