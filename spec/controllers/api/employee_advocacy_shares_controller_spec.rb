require 'rails_helper'

RSpec.describe Api::EmployeeAdvocacySharesController, :type => :controller do

  let(:valid_attributes) {
    build(:employee_advocacy_share).attributes.merge(user_id: user.id)
  }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "logged" do
    before do
      login_user user
    end

    describe "GET index" do
      it "assigns a list of employee_advocacy_shares as @employee_advocacy_shares" do
        employee_advocacy_share = create(:employee_advocacy_share, valid_attributes)
        other_user_employee_advocacy_share = create(:employee_advocacy_share, valid_attributes.merge(user_id: other_user.id))
        get :index
        expect(assigns(:employee_advocacy_shares)).not_to be_nil
        expect(assigns(:employee_advocacy_shares).to_a).to eql([employee_advocacy_share])
      end
    end

    describe "POST create" do
      it "creates a new employee_advocacy_share" do
        expect {
          post :create, {employee_advocacy_share: valid_attributes}
        }.to change(EmployeeAdvocacyShare, :count).by(1)
      end

      it "assigns a newly created employee_advocacy_share as @employee_advocacy_share" do
        post :create, {employee_advocacy_share: valid_attributes}
        expect(assigns(:employee_advocacy_share)).to be_a(EmployeeAdvocacyShare)
        expect(assigns(:employee_advocacy_share)).to be_persisted
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {user_content: "altered user_content"}
        }

        it "updates the requested employee_advocacy_share" do
          employee_advocacy_share = create(:employee_advocacy_share, valid_attributes)
          put :update, {:id => employee_advocacy_share.to_param, :employee_advocacy_share => new_attributes}
          employee_advocacy_share.reload
          expect(assigns(:employee_advocacy_share).user_content).to eql("altered user_content")
        end

        it "assigns the requested employee_advocacy_share as @employee_advocacy_share" do
          employee_advocacy_share = create(:employee_advocacy_share, valid_attributes)
          put :update, {:id => employee_advocacy_share.to_param, :employee_advocacy_share => new_attributes}
          expect(assigns(:employee_advocacy_share)).to eq(employee_advocacy_share)
        end
      end

      context "with valid params but updating other user share" do
        let(:new_attributes) {
          {user_content: "altered user_content"}
        }

        it "doesn`t update the requested employee_advocacy_share" do
          employee_advocacy_share = create(:employee_advocacy_share, valid_attributes.merge(user_id: other_user.id))
          put :update, {:id => employee_advocacy_share.to_param, :employee_advocacy_share => new_attributes}
          employee_advocacy_share.reload
          expect(assigns(:employee_advocacy_share).user_content).not_to eql("altered user_content")
        end

        it "return unauthorized" do
          employee_advocacy_share = create(:employee_advocacy_share, valid_attributes.merge(user_id: other_user.id))
          put :update, {:id => employee_advocacy_share.to_param, :employee_advocacy_share => new_attributes}
          expect(response.response_code).to eql(401)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested employee_advocacy_share" do
        employee_advocacy_share = create(:employee_advocacy_share, valid_attributes)
        expect {
          delete :destroy, {:id => employee_advocacy_share.to_param}
        }.to change(EmployeeAdvocacyShare, :count).by(-1)
      end

      context "deleting other user employee_advocacy_share" do

        it "doesn`t destroy the requested employee_advocacy_share" do
          employee_advocacy_share = create(:employee_advocacy_share, valid_attributes.merge(user_id: other_user.id))
          expect {
            delete :destroy, {:id => employee_advocacy_share.to_param}
          }.not_to change(EmployeeAdvocacyShare, :count)
        end

        it "doesn`t destroy the requested employee_advocacy_share" do
          employee_advocacy_share = create(:employee_advocacy_share, valid_attributes.merge(user_id: other_user.id))
          delete :destroy, {:id => employee_advocacy_share.to_param}
          expect(response.response_code).to eql(401)
        end

      end
    end

  end


  describe "not logged" do
    describe "GET index" do
      it "assigns a list of employee_advocacy_shares as @employee_advocacy_shares" do
        employee_advocacy_share = create(:employee_advocacy_share, valid_attributes)
        get :index
        expect(assigns(:employee_advocacy_shares)).to be_nil
        expect(response.response_code).to eql(401)
      end
    end

    describe "POST create" do
      it "doesn`t create a new employee_advocacy_share" do
        expect {
          post :create, {employee_advocacy_share: valid_attributes}
        }.not_to change(EmployeeAdvocacyShare, :count)
      end

      it "return unauthorized" do
        post :create, {employee_advocacy_share: valid_attributes}
        expect(response.response_code).to eql(401)
      end
    end


    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {user_content: "altered user_content"}
        }

        it "doesn`t update the requested employee_advocacy_share" do
          employee_advocacy_share = create(:employee_advocacy_share, valid_attributes)
          put :update, {:id => employee_advocacy_share.to_param, :employee_advocacy_share => new_attributes}
          employee_advocacy_share.reload
          expect(assigns(:employee_advocacy_share).user_content).not_to eql("altered user_content")
        end

        it "return unauthorized" do
          employee_advocacy_share = create(:employee_advocacy_share, valid_attributes)
          put :update, {:id => employee_advocacy_share.to_param, :employee_advocacy_share => new_attributes}
          expect(response.response_code).to eql(401)
        end
      end
    end

    describe "DELETE #destroy" do
      it "doesn`t destroys the requested employee_advocacy_share" do
        employee_advocacy_share = create(:employee_advocacy_share, valid_attributes)
        expect {
          delete :destroy, {:id => employee_advocacy_share.to_param}
        }.not_to change(EmployeeAdvocacyShare, :count)
      end

      it "returns unauthorized" do
        employee_advocacy_share = create(:employee_advocacy_share, valid_attributes)
        delete :destroy, {:id => employee_advocacy_share.to_param}
        expect(response.response_code).to eql(401)
      end
    end

  end

end
