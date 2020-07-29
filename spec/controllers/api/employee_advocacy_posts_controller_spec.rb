require 'rails_helper'

RSpec.describe Api::EmployeeAdvocacyPostsController, :type => :controller do

  shared_examples "index" do
    describe "GET index" do
      it "assigns a list of employee_advocacy_posts as @employee_advocacy_posts" do
        employee_advocacy_post = create(:employee_advocacy_post, valid_attributes)
        get :index
        expect(assigns(:employee_advocacy_posts)).not_to be_nil
        expect(assigns(:employee_advocacy_posts).to_a).to eql([employee_advocacy_post])
      end
    end
  end

  let(:valid_attributes) {
    build(:employee_advocacy_post).attributes
  }

  describe "logged" do
    before do
      user = login_user
      user.admin = true
      user.save
    end

    include_examples "index"

    describe "POST create" do
      it "creates a new employee_advocacy_post" do
        expect {
          post :create, {employee_advocacy_post: valid_attributes}
        }.to change(EmployeeAdvocacyPost, :count).by(1)
      end

      it "assigns a newly created employee_advocacy_post as @employee_advocacy_post" do
        post :create, {employee_advocacy_post: valid_attributes}
        expect(assigns(:employee_advocacy_post)).to be_a(EmployeeAdvocacyPost)
        expect(assigns(:employee_advocacy_post)).to be_persisted
      end
    end


    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {title: "altered title"}
        }

        it "updates the requested employee_advocacy_post" do
          employee_advocacy_post = create(:employee_advocacy_post, valid_attributes)
          put :update, {:id => employee_advocacy_post.to_param, :employee_advocacy_post => new_attributes}
          employee_advocacy_post.reload
          expect(assigns(:employee_advocacy_post).title).to eql("altered title")
        end

        it "assigns the requested employee_advocacy_post as @employee_advocacy_post" do
          employee_advocacy_post = create(:employee_advocacy_post, valid_attributes)
          put :update, {:id => employee_advocacy_post.to_param, :employee_advocacy_post => new_attributes}
          expect(assigns(:employee_advocacy_post)).to eq(employee_advocacy_post)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested employee_advocacy_post" do
        employee_advocacy_post = create(:employee_advocacy_post, valid_attributes)
        expect {
          delete :destroy, {:id => employee_advocacy_post.to_param}
        }.to change(EmployeeAdvocacyPost, :count).by(-1)
      end
    end

  end


  describe "not logged" do
    before do
      user = login_user
    end

    include_examples "index"

    describe "POST create" do
      it "doesn`t create a new employee_advocacy_post" do
        expect {
          post :create, {employee_advocacy_post: valid_attributes}
        }.not_to change(EmployeeAdvocacyPost, :count)
      end

      it "return unauthorized" do
        post :create, {employee_advocacy_post: valid_attributes}
        expect(response.response_code).to eql(401)
      end
    end


    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {title: "altered title"}
        }

        it "doesn`t update the requested employee_advocacy_post" do
          employee_advocacy_post = create(:employee_advocacy_post, valid_attributes)
          put :update, {:id => employee_advocacy_post.to_param, :employee_advocacy_post => new_attributes}
          employee_advocacy_post.reload
          expect(assigns(:employee_advocacy_post).title).not_to eql("altered title")
        end

        it "return unauthorized" do
          employee_advocacy_post = create(:employee_advocacy_post, valid_attributes)
          put :update, {:id => employee_advocacy_post.to_param, :employee_advocacy_post => new_attributes}
          expect(response.response_code).to eql(401)
        end
      end
    end

    describe "DELETE #destroy" do
      it "doesn`t destroys the requested employee_advocacy_post" do
        employee_advocacy_post = create(:employee_advocacy_post, valid_attributes)
        expect {
          delete :destroy, {:id => employee_advocacy_post.to_param}
        }.not_to change(EmployeeAdvocacyPost, :count)
      end

      it "returns unauthorized" do
        employee_advocacy_post = create(:employee_advocacy_post, valid_attributes)
        delete :destroy, {:id => employee_advocacy_post.to_param}
        expect(response.response_code).to eql(401)
      end
    end

  end

end
