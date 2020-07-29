require "httparty"
require "awesome_print"

def get_user_info user_id
  access_token = "30594865.371cbf4.7e11e0783025427e9a53b0b3d09241a8"

  resp = HTTParty.get(
    "https://api.instagram.com/v1/users/#{user_id}",
    query: {
      access_token: access_token
    }
  )

  ap JSON.parse resp.body
end

if __FILE__ == $0
  get_user_info("self")
end
