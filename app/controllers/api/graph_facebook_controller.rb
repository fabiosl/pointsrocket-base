module Api
  class GraphFacebookController < ApplicationController
    protect_from_forgery with: :null_session
    respond_to :json
    before_action :default_format_json
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def default_format_json
      if params[:format].nil?
        request.format = "json"
      end
    end

    def first_page_insights
      graph_facebook = GraphFacebook.new(current_user.get_fb_access_token(@domain))
      pages = graph_facebook.get_pages
      if pages["data"].any?
        first_page_id = pages["data"][0]["id"]
        first_page_name = pages["data"][0]["name"]
        insights = graph_facebook.get_insights_for_page(first_page_id)
        render json: insights.merge(page_name: first_page_name)
      else
        render json: {error: true, message: "your account hasn`t any pages", pages: pages}
        return
      end
    end

  end
end
