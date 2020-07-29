module AdminBaseHelper
  ATTRIBUTES = [:class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name]

  mattr_reader *ATTRIBUTES

  @@class_params = []
  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params
  @@list_attributes = @@class_params
  @@resource_name = ""
end

