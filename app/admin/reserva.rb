ActiveAdmin.register Reserva do

  # Don't forget to add the image attribute (here thumbnails) to permitted_params
  permit_params :name, :email, :phone, :curso_landing_id

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Conteúdo" do
      f.input :name
      f.input :email
      f.input :phone
      f.input :curso_landing
    end

    f.actions
  end

end
