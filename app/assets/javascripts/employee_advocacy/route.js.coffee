if window.location.hash and window.location.hash == '#_=_'
  if window.history and history.pushState
    window.history.pushState '', document.title, window.location.pathname
  else
    _scroll =
      top: document.body.scrollTop
      left: document.body.scrollLeft
    window.location.hash = ''

    document.body.scrollTop = _scroll.top
    document.body.scrollLeft = _scroll.left

employee_advocacy.config [
  '$routeProvider',
  '$locationProvider',
  ($routeProvider, $locationProvider) ->

    $routeProvider.when '/:id/:action/:social', {
      templateUrl: 'employee_advocacy_templates/index.html'
      controller: 'EmployeeAdvocacyPostIndexController'
    }

    $routeProvider.when '/', {
      templateUrl: 'employee_advocacy_templates/index.html'
      controller: 'EmployeeAdvocacyPostIndexController'
    }

    $routeProvider.when '/_=_', {
      templateUrl: 'employee_advocacy_templates/index.html'
      controller: 'EmployeeAdvocacyPostIndexController'
    }

    $locationProvider.html5Mode true
]
