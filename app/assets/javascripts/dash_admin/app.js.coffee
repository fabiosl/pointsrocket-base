String.prototype.toUnderscore = ->
  this.replace(/([A-Z])/g, ($1) ->
    "_" + $1.toLowerCase()
  )

window.dash_admin = angular.module 'dash_admin', [
  'ngSanitize', 'ngRoute', 'templates', 'restangular', 'summernote', 'jm.i18next']
