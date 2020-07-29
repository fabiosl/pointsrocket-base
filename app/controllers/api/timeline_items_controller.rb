module Api
  class TimelineItemsController < Api::BaseController
    before_action :set_timeline_item, only: [:hide, :pin, :remove_pin, :report]
    before_action :authenticate_user!

    def index
      page = params[:page] || 1
      page = page.to_i
      ts = TimelineService.new(current_user)
                          .set_page(page)
                          .params(params)
      @timeline_items = ts.get_timeline_items

      response.headers['HAS-NEXT-TIMELINE-ITEMS'] = ts.has_next.to_s
    end

    def profile
      timeline_items_query = TimelineItem.profile.order(created_at: :desc)
      page = [params[:page].to_i, 1].max
      items_per_page = 10

      timeline_items = timeline_items_query.select do |item|
        item.timelineable.belongs_to_user?(params[:user_id]) &&
        pass_timelineable_challenge_privacy?(item.timelineable, current_user)
      end

      timeline_items_size ||= timeline_items.size

      timeline_items_filtered = timeline_items
        .drop((page - 1) * items_per_page)
        .take(items_per_page)
        .group_by {
          |item| item.created_at.beginning_of_day.strftime("%b %d")
        }
        .map do |day, entries|
          {
            day: day,
            entries: entries.map do |entry|
              Rabl::Renderer.new(
                'api/timeline_items/_timeline_item',
                entry,
                { view_path: 'app/views', format: 'hash'}
              ).render
            end
          }
        end

      render json: {
                timeline_items: timeline_items_filtered,
                meta: {
                  has_next_items: has_next_items(
                    timeline_items_size, items_per_page, page
                  )
                }
             }
    end

    def hide
      @timeline_item.update_attribute(:visible, false)
      redirect_to timeline_path
    end

    def pin
      @timeline_item.update_attribute(:pinned, true)
      redirect_to timeline_path
    end

    def remove_pin
      @timeline_item.update_attribute(:pinned, false)
      redirect_to timeline_path
    end

    def report
      mail_admin_users(
        @timeline_item, params['report_type'], params['report_description']
      )
      head :no_content
    end

    private

    def mail_admin_users(timeline_item, report_type, report_description)
      unless Rails.env.test?
        domain = Domain.find_by(subdomain: Apartment::Tenant.current)

        if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
          User.admin.each do |user|
            TimelineItemReportMailWorker.perform_async(
              domain.id,
              user.id,
              timeline_item.id,
              report_type,
              report_description,
              current_user.id
            )
          end
        else
          User.admin.domain(domain).each do |user|
            TimelineItemReportMailWorker.perform_async(
              domain.id,
              user.id,
              timeline_item.id,
              report_type,
              report_description,
              current_user.id
            )
          end
        end
      end
    end

    def pass_timelineable_challenge_privacy?(timelineable, user)
      return true unless timelineable.respond_to?(:challenge)
      (timelineable.challenge.privacy == 'all' || user.admin)
    end

    def set_timeline_item
      @timeline_item = TimelineItem.find(params[:id])
    end

    def has_next_items(items_count, items_per_page, page)
      page < (items_count.to_f / items_per_page).ceil
    end
  end
end
