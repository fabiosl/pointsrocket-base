namespace :timeline_items do

  desc 'Index all item to timeline'
  task :index_all => :environment do
    all = []

    [Badge, Campaign, CampaignUser, Challenge, ChallengeUser, Comment, Course, Question].each do |model|
      all += model.all.to_a
    end

    all.shuffle.each do |i|
      i.create_timeline_item if i.timeline_items.count == 0
    end
  end

  desc 'Send all to es'
  task :send_to_es => :environment do
    tenants = Apartment.tenant_names + ["public"]

    tenants.each do |tenant|
      if tenant.present?
        Apartment::Tenant.switch(tenant) do
          p "sending tenant #{tenant}"
          TimelineItem.all.each(&:send_to_index)
        end
      end
    end
  end

  desc 'Create timeline item for BadgeUser that does not have one'
  task :create_items_for_badge_users => :environment do
    Apartment.tenant_names.each do |tenant|
      Apartment::Tenant.switch(tenant) do
        create_badge_users_timeline_items
      end
    end
  end

  def create_badge_users_timeline_items
    BadgeUser.all.each do |badge_user|
      unless badge_user.timeline_items.find_by(timelineable_id: badge_user.id)
        puts "Creating badge (#{badge_user.badge.name}) for user (#{badge_user.user.name})"
        badge_user.timeline_items.create!(
          item_type: :user,
          created_at: badge_user.created_at,
          updated_at: badge_user.updated_at
        )
      end
    end
  end

  desc 'Create graduation for users who finished a course'
  task :create_graduations => :environment do
    Apartment.tenant_names.each do |tenant|
      Apartment::Tenant.switch(tenant) do
        UserStep.order(created_at: :desc).each do |user_step|
          course = user_step.step.chapter.course
          puts "Checking/Creating graduation for user ##{user_step.user.id}"
          if !Graduation.where(user: user_step.user, course: course).any? && user_step.user.finished_course?(course)
            graduation = Graduation.create(
              user: user_step.user,
              course: course,
              created_at: user_step.created_at,
              updated_at: user_step.updated_at
            )

            update_graduation_timeline_items(graduation)
          end
        end
      end
    end
  end

  def update_graduation_timeline_items(graduation)
    graduation.timeline_items.each do |timeline_item|
      timeline_item.update_attributes(
        created_at: graduation.created_at,
        updated_at: graduation.updated_at
      )
    end
  end
end
