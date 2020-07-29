module Api
  class UrlInfoCrawlerController < Api::BaseController
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def info
      begin
        render json: UrlInfoCrawler.new(params[:url]).info
      rescue Exception => e
        render nothing: true, status: 500
      end
    end

  end
end
