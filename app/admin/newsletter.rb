ActiveAdmin.register Newsletter do

  # Don't forget to add the image attribute (here thumbnails) to permitted_params
  permit_params :name, :email

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Conteúdo" do
      f.input :name
      f.input :email
    end

    f.actions
  end

end
