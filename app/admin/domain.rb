ActiveAdmin.register Domain do
  permit_params :name, :url, :dashboard_image_down, :dashboard_login_image,
    :dashboard_menu_image, :dashboard_menu_image_contract, :layout,
    :has_indication, :is_points, :has_homepage, :default, :tag_list, :description,
    :css, :facebook_app_id, :facebook_app_secret, :copyright, :employee_advocacy_enabled,
    :after_signin_path

  filter :name_cont
  filter :url_cont
  filter :description_cont
  filter :default

  index do
    selectable_column
    id_column
    column :url
    column :name
    column :default
    column :tag_list
    actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :url
      f.input :name
      f.input :description
      f.input :layout
      f.input :css
      f.input :dashboard_login_image, :as => :file, :required => :false, :hint => f.template.image_tag(f.object.dashboard_login_image.url(:thumb))
      f.input :dashboard_image_down, :as => :file, :required => :false, :hint => f.template.image_tag(f.object.dashboard_image_down.url(:thumb))
      f.input :dashboard_menu_image, :as => :file, :required => :false, :hint => f.template.image_tag(f.object.dashboard_menu_image.url(:thumb))
      f.input :dashboard_menu_image_contract, :as => :file, :required => :false, :hint => f.template.image_tag(f.object.dashboard_menu_image_contract.url)
      f.input :has_indication
      f.input :is_points
      f.input :has_homepage
      f.input :default
      f.input :employee_advocacy_enabled
      f.input :tag_list
      f.input :copyright
      f.input :facebook_app_id
      f.input :facebook_app_secret
      f.input :after_signin_path
    end
    f.actions
  end

end
