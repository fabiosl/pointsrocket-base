dash_admin.controller 'EditGeneralController', [
  '$scope', 'Api', '$routeParams', '$timeout', '$route', '$location',
  '$http',
  ($scope, Api, $routeParams, $timeout, $route, $location, $http) ->

    $scope.options = adminOptions[$route.current.$$route.adminOption]
    # $scope.domain_id = $routeParams.domain_id
    console.log(adminOptions)
    $scope.summernoteOptions = {
      height: 200,
      toolbar: [
        ['style', ['style']],
        ['style', ['bold', 'italic', 'underline', 'clear']],
        ['fontsize', ['fontsize']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['height', ['height']],
        ['table', ['table']],
        ['insert', ['link', 'picture', 'video']]
      ]
    }

    buildParams = ->

      reduceFunc = (item) ->
        (memo, field) ->
          if field.type == 'nested'
            nested_fields = angular.copy field.fields
            # nested_fields.push({type: 'text', name: 'id'})

            if not item[field.name]
              item[field.name] = []

            memo["#{field.name}_attributes"] = item[field.name].map (nestedItem)->
              attrs = field.fields.reduce reduceFunc(nestedItem), {}
              attrs.id = nestedItem.id
              attrs

          else if field.input == 'image'
            if item['new_' + field.name + '_file']
              memo[field.name] = item['new_' + field.name + '_file']

          else
            memo[field.name] = item[field.name]

          memo

      params = $scope.options.form.fields.reduce reduceFunc($scope.item), {}

      if $scope.options.form.params_to_send
        params = Object.assign(params, $scope.options.form.params_to_send)

      to_return = {}
      to_return[$scope.options.slug_singular] = params
      to_return

    buildFormDataParams = ->
      params = buildParams()
      formData = new FormData
      paramsFormData = fromObj(params)
      for k, v of paramsFormData
        if v != undefined and v != null
          formData.append k, v
      formData

    $scope.setImage = (field) ->
      model_name = field.getAttribute("data-ng-model-name")
      fileList = field.files

      if fileList.length > 0
        file = fileList[0]
        if file.type.startsWith('image/')
          reader = new FileReader
          reader.onload = (e) ->
            $timeout ->
              $scope.item['new_' + model_name + '_src'] = e.target.result
            , 1
          reader.readAsDataURL(file)

          $timeout ->
            $scope.item['new_' + model_name + '_file'] = file
          , 1
        else
          $.gritter.add({
            title: "#{i18next.t('controllers.general.general.unsupported_image_type')} #{file.type}",
            text: '.',
            sticky: false
          });
      else
        $timeout ->
          $scope.item['new_' + model_name + '_file'] = null
          $scope.item['new_' + model_name + '_src'] = null
        , 1

    handleError = (data, message) ->
      $scope.errors = data
      $('html, body').animate({scrollTop: 0})

    $scope.getError = (key) ->
      keyMapping = $scope.options.errorMapping[key]
      if !keyMapping
        keyMapping = key

      "#{i18next.t(keyMapping)}: #{$scope.errors[key].join(', ')}"

    $scope.save = ->
      data = buildFormDataParams()
      $scope.loading = true

      if $scope.item.id
        $scope.item.withHttpConfig({transformRequest: angular.identity}).customPUT(data, undefined, undefined, {'Content-Type': undefined}).then (response) ->
          $.gritter.add({
            title: i18next.t('controllers.general.success.title'),
            text: i18next.t('controllers.general.success.save'),
            sticky: false
          });
          $location.path "/#{$scope.options.slug}"
        .catch (resp) ->
          $.gritter.add({
            title: i18next.t('controllers.general.error.title'),
            text: i18next.t('controllers.general.error.save'),
            sticky: false
          });
          handleError(resp.data, i18next.t('controllers.general.error.update'))
        .finally ->
          $scope.loading = false

      else
        Api.all(
          $scope.options.slug).withHttpConfig({transformRequest: angular.identity}).customPOST(data, undefined, undefined, {'Content-Type': undefined}).then (response) ->
            $.gritter.add({
              title: i18next.t('controllers.general.success.title'),
              text: i18next.t('controllers.general.success.create'),
              sticky: false
            });
            $location.path "/#{$scope.options.slug}"
          .catch (resp) ->
            $.gritter.add({
              title: i18next.t('controllers.general.error.title'),
              text: i18next.t('controllers.general.error.save'),
              sticky: false
            });
            handleError(resp.data, i18next.t('controllers.general.error.save'))
          .finally ->
            $scope.loading = false

    $scope.loadArrayOptions = (item, field) ->
      previous = angular.copy item[field.name]
      item[field.name] = 0
      $timeout ->
        item[field.name] = previous
      , 200

    $scope.loadSelectOptions = (field, item) ->
      refreshData = ->
        previous = angular.copy item[field.name]
        item[field.name] = 0
        $timeout ->
          item[field.name] = previous
        , 200

      if field.options_url and field.options.length == 0
        if !field.promise
          field.promise = $http.get(
            # field.options_url.replace("{{domain_id}}", $routeParams.domain_id)
            field.options_url
          )

          field.promise.catch ->
            $.gritter.add({
              title: i18next.t('controllers.general.error.title'),
              text: i18next.t('controllers.general.error.select_options'),
              sticky: true
            });

        field.promise.then (response) ->
          field.options = response.data
          refreshData()
      else
        refreshData()

    $scope.showField = (field) ->
      if not $scope.item?
        return true

      if field.show_if_field? && field.show_if_value?
        $scope.item[field.show_if_field] == field.show_if_value
      else
        true


    $scope.addNested = (item, field) ->
      newItem = field.fields.reduce (memo, field) ->
        memo[field.name] = field.default
        memo
      , {}
      if item[field.name] == undefined or item[field.name] == null
        item[field.name] = []
      item[field.name].push(newItem)

    $scope.loading = true

    loadAll = ->
      Api.one(
        $scope.options.slug, $routeParams.id
      ).get().then (item) ->
        $scope.loading = false
        $scope.item = item

        # checkForNestedAndFixCheckbox = (item) ->
        #   (field) ->
        #     if field.type == 'nested'
        #       if !!item[field.name] and item[field.name].length > 0
        #         item[field.name].forEach (nestedItem) ->
        #           field.fields.forEach checkForNestedAndFixCheckbox(nestedItem)
        #     else if field.type == 'reference'
        #       item[field.name] = item[field.name].toString()
        #       console.log item, field

        # $scope.options.form.fields.forEach checkForNestedAndFixCheckbox($scope.item)

    if $routeParams.id
      $scope.editing = true
      loadAll()

    else
      $scope.loading = false
      $scope.creating = true
      $scope.item = $scope.options.form.fields.reduce (memo, field)->
        memo[field.name] = field.default
        memo
      , {}


]
