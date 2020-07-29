module CommentsHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [:class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :admin_options, :images_attributes,
    :show_block, :belongs]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = CommentsHelper
  end

  @@class_params = [
    :content,
    :parent_id,
    :commentable_id,
    :commentable_type,
    :linked_content,
    :created_at
  ]
  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "comment"

  @@belongs = {
    user: {
      attributes: [:id, :name, :avatar, :avatar_timeline, :admin, :admin_current_domain]
    }
  }

  @@admin_options = {
    title: "Comentários",
    slug: "comments",
    slug_singular: "comment",
    item_title_field: 'name',
    ico_class: 'ico-flag2',
    buttons: {
      index_add: "Adicionar nova Comentário",
    },
    edit: {
      title_add: "Adicione um nova Comentário",
      title_edit: "Edição da Comentário",
    },
    errorMapping: {
      :creator_id => "Criador (Remetente)",
      :user_id => "Usuário (destinatário)",
      :comment_type => "Tipo",
      :notificable_id => "Notificável (ID)",
      :notificable_type => "Notificável (Type)",
      :title => "Título",
      :content => "Conteúdo",
    },
    form: {
      fields: [
        {
          name: :title,
          display_name: 'Título',
          input: :text,
          required: true,
        },
        {
          name: :content,
          display_name: 'Conteúdo',
          input: :text,
          required: true,
        },
      ],
    },
  }

  @@show_block = Proc.new {
    if root_object.commentable.present?
      commentable_class_name = root_object.commentable.class.name.underscore
      commentable_class_name_plural = commentable_class_name.pluralize

      begin
        helper = (root_object.commentable.class.name.pluralize + "Helper").constantize
      rescue Exception => e
        helper = nil
      end

      node :path do 
        root_object.decorate.path
      end

      node :notification_action do 
        root_object.decorate.notification_action_str
      end

      child :commentable => :commentable do
        template_name = "api/#{commentable_class_name_plural}/_#{commentable_class_name}"

        if File.exists? Rails.root.join("app/views", template_name + '.rabl')
          extends template_name
        elsif helper
          extends "api/base/_item"
        end
      end

    end
  }
end
