def act_as_emitable
  class_eval do
    attr_accessor :emit

    after_create :check_and_emit_create
    after_update :check_and_emit_update
    after_destroy :check_and_emit_destroy

    def check_and_emit_create
      check_and_emit "create"
    end

    def check_and_emit_update
      check_and_emit "update"
    end

    def check_and_emit_destroy
      check_and_emit "destroy"
    end

    def check_and_emit event
      if self.emit
        event_with_prefix = self.class.name.underscore + "_" + event
        begin
          do_emit event_with_prefix, emit_user_id, emit_data
        rescue Exception => e
          ap "Could not emit data"
          ap e.message
          ap e.backtrace
        end
      end
    end

    def emit_data
      template_dir = self.class.name.underscore.pluralize

      notificable_class_name = self.class.name.underscore
      notificable_class_name_plural = notificable_class_name.pluralize

      template_name = "api/#{notificable_class_name_plural}/_#{notificable_class_name}"

      if not File.exists? Rails.root.join("app/views", template_name + '.rabl')
        template_name = "api/base/_item"
      end

      data = Rabl::Renderer.new(template_name, self, { :view_path => 'app/views'}).render

      JSON.parse data
    end

    def emit_user_id
      if self.respond_to? :user_id
        self.user_id
      end
    end

    def do_emit event, user_id, data
      p "do_emit #{event} #{user_id}, #{data}"
      EmitClient.new(event, user_id, data).emit
    end
  end
end
