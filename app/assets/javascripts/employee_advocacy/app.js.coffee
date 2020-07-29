String.prototype.toUnderscore = ->
  this.replace(/([A-Z])/g, ($1) ->
    "_" + $1.toLowerCase()
  )

window.employee_advocacy = angular.module 'employee_advocacy', [
  'ngSanitize', 'ngRoute', 'templates', 'restangular', 'points', 'jm.i18next'
]
