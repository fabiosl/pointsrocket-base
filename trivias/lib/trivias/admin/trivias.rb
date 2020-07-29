if defined?(ActiveAdmin)
  module Trivias
    ActiveAdmin.register Trivia do
      permit_params :title, :slug

      controller do
        def update
          # p params
          # p permitted_params
          # super
          @trivia = Trivia.find(params['id'])
          @trivia.update_attributes(permitted_params['trivia'])
          super
        end
      end

      index do
        selectable_column
        id_column
        column :title
        column :slug
        actions
      end

      form do |f|
        f.inputs "Trivia Details" do
          f.input :title
          f.input :slug
        end
        f.actions
      end

    end
  end
end

