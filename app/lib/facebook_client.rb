class FacebookClient

  class FacebookError < Exception
    def initialize message, data
      super(message)
      @data = data
    end
  end

  include HTTParty
  format :json
  base_uri "https://graph.facebook.com"

  def initialize access_token, options = {}
    @access_token = access_token
    @api_version = options[:api_version] || "2.7"
  end

  # options can be:
  # message: required if there isn`t link
  # link: required if there isn`t message
  # picture: url of picture
  # name: name of link
  # caption: caption of link (overrides link)
  # description: description of link (overrides site description)
  def post_timeline options={}
    payload = options.slice(:message, :link, :picture, :name, :caption, :description)

    url = "/v#{@api_version}/me/feed"

    params = {
      access_token: @access_token
    }

    response = self.class.post(url, :body => payload, :query => params)
    data = JSON.parse response.body

    if response.success?
      return data['id']
    else
      raise FacebookError.new(data['error']['message'], data)
    end
  end

  def post_photo options={}
    payload = options.slice(:url, :caption)

    url = "/v#{@api_version}/me/photos"

    params = {
      access_token: @access_token
    }

    response = self.class.post(url, :body => payload, :query => params)
    data = JSON.parse response.body

    if response.success?
      return data['id']
    else
      raise FacebookError.new(data['error']['message'], data)
    end
  end
end
