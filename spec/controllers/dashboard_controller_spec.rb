require 'rails_helper'

RSpec.describe DashboardController, :type => :controller do

  let!(:course) {
    course = create(:course)
    course.tag_list.add(course_tag_name)
    course.save
    course
  }

  let(:course_tag_name) {
    "adlfkjadlkgjsadlkgj"
  }

  describe "GET index" do
    context "when not logged" do
      it "redirects to users sign upd" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    # context "when new user" do
    #   it "should not redirect user to pay screen" do
    #     login_user
    #     get :index
    #     expect(response).to be_success
    #   end
    # end

    # context "when pass 7 days user" do
    #   it "should redirect user to pay screen" do
    #     login_user_expired
    #     get :index
    #     expect(response).to redirect_to(orders_path)
    #   end
    # end
  end

  context "with onrocket course" do
    before do
      user = login_user
      user.tag_list.add(user_tag)
      user.save
    end

    let(:course_tag_name) { 'onrocket' }
    let(:user_tag) { "tag_qualquer" }

    context "when logged with user with onrocket tags" do
      let(:user_tag) { "onrocket" }

      it "returns all onrocket courses" do
        get :index
        expect(assigns(:courses)).to eq([course])
      end
    end

    context "when logged with user with metta tags" do
      let(:user_tag) { "metta" }

      it "returns none courses" do
        get :index
        expect(assigns(:courses)).to eq([])
      end
    end
  end


end
