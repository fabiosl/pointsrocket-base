module EnvSkipper
  extend self

  class SkipException < Exception ; end

  def skip env
    path = env["REQUEST_PATH"] || ""

    if [".png", ".jpg"].include? File.extname(path)
      raise SkipException.new("Path must be skiped: #{path}")
    end
  end
end
