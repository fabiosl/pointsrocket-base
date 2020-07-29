employee_advocacy.directive "customSelect", ->
  scope:
    options: "="
    onSelect: "="
  link: (scope, elem, attrs) ->
    setTimeout ->
      control = $(elem).selectize()[0].selectize

      control.on "change", (e) ->
        scope.onSelect(e)

    , 300

    # $selectize.clear()
    # $selectize.clearOptions()
    # $selectize.load(
    #   (cb) ->
    #     cb(
    #       scope.options.map((i) -> {text: i, value: i})
    #     )
    # )
