class TrailDecorator < Draper::Decorator
  delegate_all

  def points
    object.courses.all.reduce(0) { |memo, course|
      memo += course.points
      memo
    }
  end
end

