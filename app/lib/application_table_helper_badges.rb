class ApplicationTableHelperBadges < ApplicationTableHelper
  def initialize
    super
    @show_badges = true
    @models = []
  end

  def get_user_itens_info user, itens
    itens.map do |i|
      res = nil

      case i.class.name
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
      else
        raise ClassNotFoundException.new("Not found class #{i.class.name}")

      end

      res
    end
  end

end
