require 'rails_helper'

RSpec.describe Api::UsersController, :type => :controller do

  before do
    create_default_domain
  end

  describe "logged" do

    before do
      @user = login_user
      @user.name = "Testando"
      @user.save
    end

    describe "GET me" do

      let(:subject) {
        get :me
      }

      it "assigns @user" do
        subject
        expect(assigns(:user)).to eql(@user)
      end
    end

    describe "PUT me" do

      let(:subject) {
        put :me, {user: {name: "Teste"}}
      }

      it "assigns @user" do
        subject
        expect(assigns(:user)).to eql(@user)
      end

      it "updates @user" do
        subject
        @user.reload
        expect(@user.name).to eql("Teste")
      end
    end
  end

end
