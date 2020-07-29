class ApplicationTableHelper
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  attr_accessor :head, :rows, :models, :show_badges

  class ClassNotFoundException < Exception ; end
  class AttributeNotFoundException < Exception ; end

  def initialize
    @domain = Domain.find_by subdomain: Apartment::Tenant.current
    @show_badges = true
    @models = [HashtagChallenge, Challenge, Broadcast, Course, EmployeeAdvocacyPost, Campaign]
  end

  def get_itens
    @itens ||= @models.flat_map do |model|
      model.all
    end

    if @show_badges
      course_badges = Course.all.map {|c| c.current_finished_course_badge }.select(&:present?)

      @itens += Badge.all.select do |b|
        not course_badges.include? b
      end
    end

    @itens.sort_by do |i|
      i.created_at
    end
  end

  def get_users
    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
      User.all.not_admin
    else
      User.domain(@domain).not_admin
    end
  end

  def get_data
    itens = get_itens
    users = get_users
    @head = itens.dup

    @rows = get_users.map do |user|
      d = []
      d << user
      d += get_user_itens_info(user, itens)
      d
    end

    @rows = @rows.sort_by { |r|
      r.inject(0) do |memo, item|
        if item.is_a? Integer
          memo += item
        elsif item == true
          memo += 1
        end
        memo
      end
    }.reverse
  end

  def get_method_of methods, item
    keys = methods.select do |method|
      item.respond_to? method
    end

    if keys.size > 0
      item.send(keys.first)
    else
      raise AttributeNotFoundException.new("attr not found in #{item.class.name} #{item} #{methods}")
    end
  end

  def get_title_of head_item
    if ["Campaign"].include? head_item.class.name
      get_method_of([:title, :name], head_item)
    else
      I18n.t "excel.thing_points", thing: get_method_of([:title, :name], head_item)
    end
  end

  def get_link_of item
    case item.class.name
    when "Badge"
      badges_path

    when "HashtagChallenge"
      hashtag_challenge_path(item)

    when "Challenge"
      challenge_path(item)

    when "Broadcast"
      broadcast_path(item)

    when "Course"
      course_path(item)

    when "EmployeeAdvocacyPost"
      employee_advocacy_path

    when "Campaign"
      campaign_path(item)

    else
      raise ClassNotFoundException.new("Not found class #{item.class.name}")

    end
  end

  def get_info_for i, user, itens
    res = nil
    case i.class.name
    when "EmployeeAdvocacyPost"
      res = Point.where(pointable: i.employee_advocacy_shares.where(user: user)).sum(:value)

      visit_ids = i.employee_advocacy_shares.where(user: user).flat_map do |s|
        s.employee_advocacy_visits.pluck('id')
      end.uniq

      res += Point.where(pointable: EmployeeAdvocacyVisit.where(id: visit_ids)).sum(:value)

    when "Campaign"
      res = user.has_complete_campaign(i) ? "ok" : ""
    when "Badge"

      if i.badge_type == 'simple'
        res = user.has_badge?(i)
      end

      if i.badge_type == 'reusable'
        if user.has_badge?(i)
          res = user.get_badge_user_for(i).quantity
          res = res == 0 ? false : res
        else
          res = false
        end
      end

      if res == true
        res = i.badge_points
      elsif res.is_a? Integer
        res = i.badge_points * res
      else
        res = 0
      end

    when "HashtagChallenge"
      hashtag_challenges_users = user.hashtag_challenge_users.where(hashtag_challenge: i).all
      res = Point.where(pointable: hashtag_challenges_users).sum(:value)

    when "Challenge"
      challenges_users = user.challenge_users.where(challenge: i).all
      res = Point.where(pointable: challenges_users).sum(:value)

    when "Broadcast"
      broadcasts_users = user.visualizations.where(broadcast: i).all
      res = Point.where(pointable: broadcasts_users).sum(:value)

    when "Course"
      res = user.get_points_for i
    else
      raise ClassNotFoundException.new("Not found class #{i.class.name}")
    end

    res
  end

  def get_user_itens_info user, itens
    itens.map do |i|
      get_info_for(i, user, itens)
    end
  end

end
