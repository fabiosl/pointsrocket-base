require 'rails_helper'


RSpec.shared_examples "a request that returns all notifications" do
  it "assigns all notifications to user" do
    make_request
    expect(assigns(:notifications)).to match_array([notification])
  end
end

RSpec.shared_examples "a request that returns 0 notifications" do
  it "assigns 0 notifications to user" do
    make_request
    expect(assigns(:notifications)).to match_array([])
  end
end

RSpec.shared_examples "a request successfully" do
  it "returns http success" do
    make_request
    expect(response).to have_http_status(:success)
  end
end
RSpec.shared_examples "a request not found" do
  it "raise not found" do
    expect {
      make_request
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end

RSpec.shared_examples "a request that mark notification read" do
  it "mark notification to read" do
    expect {
      make_request
    }.to change {
      Notification.all_with_read(user).first.notification_reads_id
    }
  end
end

RSpec.shared_examples "a request that no mark notification read" do
  it "mark no notification to read" do
    expect {
      make_request
    }.not_to change {
      Notification.all_with_read(user).first.notification_reads_id
    }
  end
end

RSpec.describe NotificationsController, type: :controller do

  let!(:user) { create(:user) }
  let!(:notification) {
    create(:notification, {
      recipient: recipient,
      to_all: to_all
    })
  }

  let!(:recipient) { nil }
  let!(:to_all) { true }

  before do
    login_user user
  end

  context "with notification to all" do
    describe "GET #index" do
      let(:make_request) {
        get :index, format: :json
      }

      it_behaves_like "a request that returns all notifications"
      it_behaves_like "a request successfully"
    end

    describe "POST #read_all" do
      let(:make_request) {
        post :read_all, format: :json
      }

      it_behaves_like "a request successfully"
      it_behaves_like "a request that mark notification read"
    end

    describe "POST #read" do
      let(:make_request) {
        post :read, {id: notification.id}, format: :json
      }

      it_behaves_like "a request successfully"
      it_behaves_like "a request that mark notification read"
    end
  end

  context "with notification to same recipient" do
    let!(:recipient) { user }
    let!(:to_all) { false }

    describe "GET #index" do
      let(:make_request) {
        get :index, format: :json
      }

      it_behaves_like "a request that returns all notifications"
      it_behaves_like "a request successfully"
    end

    describe "POST #read_all" do
      let(:make_request) {
        post :read_all, format: :json
      }

      it_behaves_like "a request successfully"
      it_behaves_like "a request that mark notification read"
    end

    describe "POST #read" do
      let(:make_request) {
        post :read, {id: notification.id}, format: :json
      }

      it_behaves_like "a request successfully"
      it_behaves_like "a request that mark notification read"
    end
  end

  context "with notification to other recipient" do
    let!(:recipient) { create(:user) }
    let!(:to_all) { false }

    describe "GET #index" do
      let(:make_request) {
        get :index, format: :json
      }

      it_behaves_like "a request that returns 0 notifications"
      it_behaves_like "a request successfully"
    end

    describe "POST #read_all" do
      let(:make_request) {
        post :read_all, format: :json
      }

      it_behaves_like "a request successfully"
    end

    describe "POST #read" do
      let(:make_request) {
        post :read, {id: notification.id}, format: :json
      }

      it_behaves_like "a request not found"
    end
  end

end
