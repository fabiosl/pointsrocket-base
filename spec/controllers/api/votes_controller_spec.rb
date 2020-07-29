require 'rails_helper'

RSpec.describe Api::VotesController, :type => :controller do

  let(:valid_attributes) {
    build(:vote).attributes
  }

  describe "logged" do
    before do
      login_user
    end

    describe "POST create" do
      it "creates a new vote" do
        expect {
          post :create, {vote: valid_attributes}
        }.to change(Vote, :count).by(1)
      end

      it "assigns a newly created vote as @vote" do
        post :create, {vote: valid_attributes}
        expect(assigns(:vote)).to be_a(Vote)
        expect(assigns(:vote)).to be_persisted
      end
    end


    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {status: "downvote"}
        }

        it "updates the requested vote" do
          vote = create(:vote, valid_attributes.merge(user_id: subject.current_user.id))
          put :update, {:id => vote.to_param, :vote => new_attributes}
          vote.reload
          expect(assigns(:vote).status).to eql("downvote")
        end

        it "assigns the requested vote as @vote" do
          vote = create(:vote, valid_attributes.merge(user_id: subject.current_user.id))
          put :update, {:id => vote.to_param, :vote => valid_attributes}
          expect(assigns(:vote)).to eq(vote)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested vote" do
        vote = create(:vote, valid_attributes.merge(user_id: subject.current_user.id))
        expect {
          delete :destroy, {:id => vote.to_param}
        }.to change(Vote, :count).by(-1)
      end
    end

  end

end
