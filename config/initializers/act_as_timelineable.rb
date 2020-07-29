def act_as_timelineable options
  if options[:only_relation] != true
    class_eval do
      attr_accessor :skip_timeline
      has_many :timeline_items, as: :timelineable, dependent: :destroy
      after_create :create_timeline_item
      after_save :update_timeline_item
    end

    class_eval %Q{
      def create_timeline_item
        if not skip_timeline
          self.timeline_items.create! item_type: :#{options[:type] || :system}
        end
      end

      def update_timeline_item
        self.timeline_items.each {|ti| ti.send_to_index}
      end
    }
  end

  class_eval do
    after_save :do_update_relations
    after_destroy :do_update_relations

    class_eval %Q{
      def update_relations
        #{options[:update_relations]}
      end

      def do_update_relations
        if update_relations
          update_relations.each do |relation|
            reflection = self.class.reflections[relation]
            if reflection
              if reflection.macro == :has_many
                self.send(relation).each do |relation_item|
                  if relation_item.respond_to? :timeline_items
                    relation_item.timeline_items.each(&:send_to_index)
                  end
                end
              end
              if reflection.macro == :belongs_to
                if self.send(relation).respond_to? :timeline_items
                  self.send(relation).timeline_items.each(&:send_to_index)
                end
              end
            end
          end
        end
      end

      def belongs_to_user?(other_id)
        (respond_to?(:user_id) && user_id == other_id.to_i) ||
        (respond_to?(:recipient_id) && recipient_id == other_id.to_i) ||
        (respond_to?(:sender_id) && sender_id == other_id.to_i)
      end
    }
  end

end
