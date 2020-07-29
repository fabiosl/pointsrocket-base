class UserCourseFlow
  def initialize user
    @user = user
  end

  def info
    Course.all.select do |course|
      @user.initialized_course? course
    end.map do |course|
      {
        course: course,
        percentage: @user.get_percentage_for_course(course) * 100,
      }
    end
  end
end
