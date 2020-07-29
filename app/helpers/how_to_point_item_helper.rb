module HowToPointItemHelper
  def how_to_point_item_editable_fields
    [:points, :description, :section]
  end

  def how_to_point_item_show_fields
    [:id, *how_to_point_item_editable_fields]
  end

  def how_to_point_item_permitted_params_fields
    [:_destroy, *how_to_point_item_show_fields]
  end
end
