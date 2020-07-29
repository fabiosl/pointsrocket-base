require 'devise'

module ControllerMacros

  def set_mapping
    if @request
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
  end

  def login_user user=nil
    set_mapping

    if user.nil?
      user = FactoryGirl.create(:user, has_submited_payment_form: true)
      FactoryGirl.create(:subscription, user: user, status: 'TRIAL')
    end

    sign_in user
    user
  end

  def login_unsubscribed_user user=nil
    set_mapping
    if user.nil?
      user = FactoryGirl.create(:user)
    end
    sign_in user
    user
  end

  def login_user_expired
    set_mapping
    sign_in FactoryGirl.create(:user, created_at: 7.days.ago)
  end

end

RSpec.configure do |config|
  # config.include Devise::TestHelpers, :type => :controller
  config.include ControllerMacros, :type => :controller
  config.include Warden::Test::Helpers, type: :feature
  # config.include ControllerMacros, :type => :request
end
