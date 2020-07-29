ActiveAdmin.register CursoLanding do

  menu parent: 'Landing Page', label: 'Cursos'

  # Don't forget to add the image attribute (here thumbnails) to permitted_params
  permit_params :name, :description, :image, :active

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Conteúdo" do
      f.input :name
      f.input :active
      f.input :description, as: :wysihtml5, commands: :all, blocks: [ :p, :h2, :h3]
      f.input :image
    end

    f.actions
  end

end
