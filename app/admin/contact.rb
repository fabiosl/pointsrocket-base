ActiveAdmin.register Contact do
  permit_params :name, :email, :phone, :message

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Conteúdo" do
      f.input :name
      f.input :email
      f.input :phone
      f.input :message
    end

    f.actions
  end
end