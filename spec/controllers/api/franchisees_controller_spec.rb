require 'rails_helper'

RSpec.describe Api::FranchiseesController, :type => :controller do

  let(:domain) {
    d = create(:domain, tag_list: 'test')
  }

  let(:valid_attributes) {
    build(:franchisee).attributes
  }

  render_views

  describe "logged" do
    before do
      login_user
    end

    describe "GET index" do
      before do
        @objects = [create(:franchisee, tag_list: 'test')]
      end

      it "get a list of franchisees" do
        response = get :index, {domain_id: domain.id}
        expect(assigns(:franchisees).to_a).to eql(@objects)
      end
    end

    describe "POST create" do
      it "creates a new franchisee" do
        expect {
          response = post :create, {franchisee: valid_attributes, domain_id: domain.id}
        }.to change(Franchisee, :count).by(1)
      end

      it "assigns a newly created franchisee as @franchisee" do
        post :create, {franchisee: valid_attributes, domain_id: domain.id}
        expect(assigns(:franchisee)).to be_a(Franchisee)
        expect(assigns(:franchisee)).to be_persisted
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {name: "altered name"}
        }

        it "updates the requested franchisee" do
          franchisee = create(:franchisee, valid_attributes)
          put :update, {:id => franchisee.to_param, :franchisee => new_attributes, domain_id: domain.id}
          franchisee.reload
          expect(assigns(:franchisee).name).to eql("altered name")
        end

        it "assigns the requested franchisee as @franchisee" do
          franchisee = create(:franchisee, valid_attributes)
          put :update, {:id => franchisee.to_param, :franchisee => new_attributes, domain_id: domain.id}
          expect(assigns(:franchisee)).to eq(franchisee)
        end
      end

    end
  end

end
