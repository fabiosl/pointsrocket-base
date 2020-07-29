module Youtube
  module DataHelpers
    def self.video_id(url)
      match_data = /(be\/|embed\/|v=)(?<video_id>[\w+\-]+)/.match(url)
      match_data[:video_id] if match_data
    end
  end

  module UrlHelpers
    def self.embed_url(url)
      "https://www.youtube.com/embed/#{DataHelpers.video_id(url)}"
    end
  end
end