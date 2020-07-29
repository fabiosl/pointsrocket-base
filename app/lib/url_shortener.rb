class UrlShortener

  class ShortenerError < Exception ; end

  include HTTParty
  base_uri ENV['POINTS_SHORTENER_URL']

  attr_accessor :url, :title, :description, :picture

  def initialize url
    @url = url
    @options = {
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json",
        },
        basic_auth: {
          username: ENV['POINTS_SHORTENER_USERNAME'],
          password: ENV['POINTS_SHORTENER_PASSWORD']
        }
      }
  end

  def short
    # enquanto n ajeita o domínio
    if (ENV['SKIP_SHORT']) == "true"
      return @url
    end

    body = {
      short: {
        url: @url
      }
    }

    if @title
      body[:short][:title] = @title
    end

    if @description
      body[:short][:description] = @description
    end

    if @picture
      body[:short][:picture] = @picture
    end

    response = self.class.post(
      '/api/shorts',
      @options.merge({body: body.to_json})
    )

    raise ShortenerError.new(response.body) if not response.success?

    ENV['POINTS_SHORTENER_URL'] + '/' + response.parsed_response["token"]
  end

end
