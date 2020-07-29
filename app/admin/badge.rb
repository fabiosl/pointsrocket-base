ActiveAdmin.register Badge do
  permit_params :name, :category, :badge_points,
    :avatar, :badgeable_type, :badgeable_id, :hint

  filter :name_cont
  filter :hint_cont
  filter :badgeable_of_Course_type_name_cont

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :badge_points
      f.input :badgeable_type
      f.input :badgeable_id
      f.input :category
      f.input :hint
      f.input :avatar, :as => :file, :required => :false, :hint => f.template.image_tag(f.object.avatar.url(:thumb))
    end
    f.actions
  end

end
