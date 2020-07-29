dash_admin.directive "checkFileExists", ->
  restrict: 'A'
  require: 'ngModel'
  link: (scope, elem, attrs, model) ->
    console.dir arguments

    elem.bind 'change', ->
      model.$setViewValue(elem.val())
      model.$render()

    # attrs.$observe 'fileValidate', ->
    #   console.dir arguments
