def act_as_notificable
  class_eval do
    has_many :notifications, as: :notificable

    attr_accessor :notify, :notify_event, :notification_creator_id,
      :notification_tag_list, :notification_options

    after_create :check_and_notify_create
    after_update :check_and_notify_update
    after_destroy :check_and_notify_destroy

    def check_and_notify_create
      check_and_notify "create"
    end

    def check_and_notify_update
      check_and_notify "update"
    end

    def check_and_notify_destroy
      check_and_notify "destroy"
    end

    def check_and_notify event
      if self.notify
        self.notify_event = event
        event_with_prefix = self.class.name.underscore + "_" + event

        Notification.create!(
          creator_id: notification_creator_id,
          user: notification_user,
          notificable: self,
          title: notification_title,
          content: notification_content,
          tag_list: notification_tag_list,
          emit: true,
        )
      end
    end

    def notification_user
      if self.respond_to? :user
        self.user
      end
    end

    def notification_title
      if self.respond_to? :title
        return self.title
      end

      if self.respond_to? :name
        return self.name
      end

      ""
    end

    def notification_content

      ""
    end

  end
end
