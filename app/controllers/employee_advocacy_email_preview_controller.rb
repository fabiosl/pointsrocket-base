class EmployeeAdvocacyEmailPreviewController < ApplicationController

  def index
    authorize! :see_email_preview, current_user
    @employee_advocacy_post = EmployeeAdvocacyPost.find params[:id]
    @username = current_user.name.split(' ').first
    render layout: false
  end

end
