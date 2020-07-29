class ApplicationTableHelperNews < ApplicationTableHelper
  attr_accessor :head, :rows, :models, :show_badges

  class ClassNotFoundException < Exception ; end
  class AttributeNotFoundException < Exception ; end

  def initialize
    super
    @show_badges = false
    @models = [EmployeeAdvocacyPost]
  end

  def get_user_itens_info user, itens
    itens.map do |i|
      res = nil

      case i.class.name
      when "EmployeeAdvocacyPost"
        visits = EmployeeAdvocacyVisit.joins(employee_advocacy_share: :employee_advocacy_post).where(employee_advocacy_shares: {
          user_id: user.id,
          employee_advocacy_post_id: i.id
        })

        shares = i.employee_advocacy_shares.where(user: user)

        res = {
          visits: visits.count,
          shares_facebook: shares.facebook.count,
          shares_twitter: shares.twitter.count,
          shares_linkedin: shares.linkedin.count,
          visits_facebook: visits.where({employee_advocacy_shares: {social_network: :facebook}}).count,
          new_visits_facebook: visits.where({employee_advocacy_shares: {social_network: :facebook}}).new_visit.count,
          visits_twitter: visits.where({employee_advocacy_shares: {social_network: :twitter}}).count,
          new_visits_twitter: visits.where({employee_advocacy_shares: {social_network: :twitter}}).new_visit.count,
          # visits_linkedin: visits.where({employee_advocacy_shares: {social_network: :linkedin}}).count,
          # new_visits_linkedin: visits.where({employee_advocacy_shares: {social_network: :linkedin}}).new_visit.count,
          visits_linkedin: 10,
          new_visits_linkedin: 5,
        }
      else
        raise ClassNotFoundException.new("Not found class #{i.class.name}")

      end

      res
    end
  end

end
