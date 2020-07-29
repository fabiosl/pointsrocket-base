class ApplicationTableHelperCampaigns < ApplicationTableHelper
  def initialize
    super
    @show_badges = false
    @models = [Campaign]
  end

  def get_user_itens_info user, itens
    itens.map do |i|
      res = nil

      case i.class.name
      when "Campaign"
        res = user.has_complete_campaign(i)
      else
        raise ClassNotFoundException.new("Not found class #{i.class.name}")
      end

      res
    end
  end

end
