ActiveAdmin.register Plan do

  menu parent: 'Landing Page', label: 'Planos'

  # Don't forget to add the image attribute (here thumbnails) to permitted_params
  permit_params :name, :duration, :price, :moip_code

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Conteúdo" do
      f.input :name
      f.input :duration
      f.input :price
      f.input :moip_code
    end

    f.actions
  end

end
