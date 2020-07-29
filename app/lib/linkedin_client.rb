require 'httparty'

class LinkedinClient
  API_BASE_URL = 'https://api.linkedin.com/v2/ugcPosts'
  RESPONSE_QUERY_FORMAT = 'format=json'

  attr_reader :request_errors

  def initialize(access_token)
    puts access_token
    @access_token = access_token
    @request_errors = []
  end

  def add_share(content)
    HTTParty.post(
      "#{API_BASE_URL}",
      headers: headers,
      body: content.to_json
    )
  end

  def register_image urn
    content = {
      "registerUploadRequest"=> {
          "recipes"=> [
              "urn:li:digitalmediaRecipe:feedshare-image"
          ],
          "owner"=> "#{urn}",
          "serviceRelationships"=> [
              {
                  "relationshipType"=> "OWNER",
                  "identifier"=> "urn:li:userGeneratedContent"
              }
          ]
      }
    }

    HTTParty.post(
      'https://api.linkedin.com/v2/assets?action=registerUpload',
      headers: headers,
      body: content.to_json
    )
  end

  private

  def headers
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{@access_token}",
      'X-Restli-Protocol-Version' => '2.0.0'
    }
  end

  def query
    {
      'count' => 50
    }
  end

  def data_as_json(content)
    content.to_json
  end
end