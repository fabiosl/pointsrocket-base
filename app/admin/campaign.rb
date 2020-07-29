ActiveAdmin.register Campaign do
  permit_params :title, :description, :start_date_time_hour, :start_date_time_minute,\
    :start_date_date, :end_date_time_hour, :end_date_time_minute,\
    :end_date_date, :image,\
    campaign_badges_attributes: [
      :id,
      :badge_id,
      :description
    ]

  filter :title
  filter :description
  filter :start_date
  filter :end_date

  form do |f|
    f.inputs "Details" do
      f.input :title
      f.input :description
      f.input :start_date, as: :just_datetime_picker
      f.input :end_date, as: :just_datetime_picker
      f.input :image, :as => :file, :required => :false, :hint => f.template.image_tag(f.object.image.url(:thumb))
    end

    f.has_many :campaign_badges do |campaign_badge_f|
      campaign_badge_f.input :badge
      campaign_badge_f.input :description
    end

    f.actions
  end

end
