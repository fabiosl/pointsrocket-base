class ApplicationTableHelper2 < ApplicationTableHelper

  def get_title_of head_item
    if ["Course", "EmployeeAdvocacyPost"].include? head_item.class.name
      get_method_of([:title, :name], head_item)
    else
      super(head_item)
    end
  end

  def get_shares_count_for shares
    shares.decorate.inject(0) do |memo, s|
      memo + s.real_shares_count
    end
  end

  def get_info_for i, user, itens
    case i.class.name
    when "Course"
      {
        points: user.get_points_for(i),
        percentage_completed: user.get_percentage_for_course(i),
        object: i,
      }
    when "EmployeeAdvocacyPost"

      visits = EmployeeAdvocacyVisit.joins(employee_advocacy_share: :employee_advocacy_post).where(employee_advocacy_shares: {
        user_id: user.id,
        employee_advocacy_post_id: i.id
      })

      shares = i.employee_advocacy_shares.where(user: user)

      interactions = shares.decorate.map do |s|
        s.interaction_count
      end.inject do |memo, interaction|
        memo.merge(interaction) do |k, memo_v, interactions_v|
          memo_v + interactions_v
        end
      end

      to_ret = {
        shared: shares.any?,
        shares_facebook: get_shares_count_for(shares.facebook),
        shares_twitter: get_shares_count_for(shares.twitter),
        shares_linkedin: get_shares_count_for(shares.linkedin),
        object: i,
      }.merge(interactions: interactions || {})

      to_ret
    else
      super(i, user, itens)
    end
  end

end
