class PointsEarned

  def initialize app
    @app = app
  end

  def call env
    dup._call env
  end

  def _call env
    # return @app.call(env)
    status = nil
    headers = nil
    response = nil

    begin
      ::EnvSkipper.skip env
    rescue ::EnvSkipper::SkipException => e
      return @app.call(env)
    end

    begin
      # p "pegando current user"
      current_user_id = env["rack.session"]["warden.user.user.key"].first.first
      # p current_user_id
      # p "pegando last_point"
      last_point = Point.where(user_id: current_user_id).order("created_at desc").first
      # p last_point
      status, headers, response = @app.call(env)

      if not (headers["Content-Type"] || "").include?("text/html") or status != 200
        return [status, headers, response]
      end

      new_points = Point.where(user_id: current_user_id).where("id > #{last_point.id}").order("created_at desc")
      new_points_count = new_points.inject(0) do |memo, new_point|
        memo += new_point.value
        memo
      end

      new_response = response.body

      if new_response.is_a? Array
        new_response = new_response.first
      end

      if new_points_count != 0
        if new_points_count > 0
          new_points_count_str = "+#{new_points_count}"
        else
          new_points_count_str = "-#{new_points_count}"
        end

        new_response.gsub!('<span class="points-won-now"></span>', "<span class=\"points-won-now hide\">#{new_points_count_str}</span>")

        user_points_re = /<span id=\"user_points\">(\d+)<\/span>/
        user_points_match_data = user_points_re.match new_response
        if user_points_match_data
          current_user_points = user_points_match_data[1].to_i
          diff_to_show = current_user_points - new_points_count

          new_response.gsub!(
            "<span id=\"user_points\">#{current_user_points}</span>",
            "<span id=\"user_points\">#{diff_to_show}</span>"
          )
        end
      else
        new_response.gsub!('<span class="points-won-now"></span>', "")
      end

      return [status, headers, [new_response]]
    rescue Exception => e
      # p e.message
      # p e.backtrace
      if not status or not headers or not response
        return @app.call(env)
      else
        return [status, headers, response]
      end
    end
  end

end
