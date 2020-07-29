dash_admin.controller 'EditTrailsController', [
  '$scope', 'DomainService', '$routeParams', '$timeout', '$route', '$location',
  ($scope, DomainService, $routeParams, $timeout, $route, $location) ->

    templates = {
      trail: {
        course_trails: [
        ]
      }
    }

    $scope.domain_id = $routeParams.domain_id

    buildParams = ->
      {
        name: $scope.trail.name
        description: $scope.trail.description
        position: $scope.trail.position
        age_group: $scope.trail.age_group
        video_url: $scope.trail.video_url
        hours: $scope.trail.hours
        active: $scope.trail.active
        course_trails_attributes: $scope.trail.course_trails.map (course_trail) ->
          {
            id: course_trail.id
            course_id: course_trail.course.id
            _destroy: course_trail._destroy
          }
      }

    $scope.save = ->
      params = buildParams()
      if $scope.trail.id
        $scope.trail.customPUT(trail: params).then (response) ->
          alert "Salvo com sucesso"
          $location.path "/#{$routeParams.domain_id}/trails"
      else
        DomainService.one($routeParams.domain_id).all(
          'trails').customPOST(trail: params).then (response) ->
            alert "Trilha criada com sucesso"
            $location.path "/#{$routeParams.domain_id}/trails"

    $scope.addCourse = ->
      if $scope.courses and $scope.courses[0]
        course = $scope.courses[0]
      else
        course = {}
      $scope.trail.course_trails.push {course: course}

    $scope.loading = true
    $scope.courses_loading = true

    loadAllCourses = ->
      DomainService.one($routeParams.domain_id).all('courses').getList().then (courses) ->
        $scope.courses = courses
        $scope.courses_loading = false
      .catch ->
        alert "Houve um erro ao carregar os cursos, atualize a página por favor."

    loadAll = ->
      DomainService.one($routeParams.domain_id).one(
        'trails', $routeParams.id
      ).get().then (trail) ->
        $scope.loading = false
        $scope.trail = trail

    if $routeParams.id
      loadAll()

    else
      $scope.loading = false
      $scope.trail = angular.copy templates.trail

    loadAllCourses()
]
