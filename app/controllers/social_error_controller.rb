class SocialErrorController < ApplicationController
  before_filter :authenticate_user!

  def index
    @email = params[:email]

    if @domain.present? and @domain.layout.present?
      render "index", layout: @domain.layout
    end
  end

end
