class ApplicationTableHelperCourses < ApplicationTableHelper

  def initialize
    super
    @show_badges = false
    @models = [Course]
  end

  def get_user_itens_info user, itens
    itens.map do |i|
      res = nil

      case i.class.name
      when "Course"
        res = {
          points: user.get_points_for(i),
          percentage_completed: user.get_percentage_for_course(i),
        }
      else
        raise ClassNotFoundException.new("Not found class #{i.class.name}")

      end

      res
    end
  end

end
