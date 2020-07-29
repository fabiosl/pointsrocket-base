require 'rails_helper'

RSpec.describe Api::CommentsController, :type => :controller do

  render_views

  # # dummy model
  # class Dummy < ActiveRecord::Base
  #   has_many :comments, as: :commentable, dependent: :destroy
  # end

  # a ideia é trocar isso aqui por dummy
  let(:commentable) { create(:challenge) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let(:valid_attributes) {
    build(:comment, {commentable: commentable, user: user}).attributes
  }

  describe "logged with normal user" do
    before do
      login_user user
    end

    describe "GET index" do

      describe "without passing query param" do
        it "returns unprocessable" do
          response = get :index
          expect(response.code).to eql("422")
        end
      end

      describe "passing query param" do
        it "assigns a list of comments as @comments" do
          comment = create(:comment, valid_attributes)
          response = get :index, {commentable_type: commentable.class.name, commentable_id: commentable.id}
          expect(assigns(:comments)).not_to be_nil
          expect(assigns(:comments).to_a).to eql([comment])
        end
      end

      describe "passing query param withou comments" do
        it "assigns [] to @comments" do
          comment = create(:comment, valid_attributes)
          response = get :index, {commentable_type: commentable.class.name, commentable_id: 1231231231}
          expect(assigns(:comments)).not_to be_nil
          expect(assigns(:comments).to_a).to eql([])
        end
      end
    end

    describe "POST create" do
      it "creates a new comment" do
        expect {
          post :create, {comment: valid_attributes}
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        post :create, {comment: valid_attributes}
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {content: "altered content"}
        }

        it "updates the requested comment" do
          comment = create(:comment, valid_attributes)
          put :update, {:id => comment.id, :comment => new_attributes}
          comment.reload
          expect(assigns(:comment).content).to eql("altered content")
        end

        it "assigns the requested comment as @comment" do
          comment = create(:comment, valid_attributes)
          put :update, {:id => comment.id, :comment => new_attributes}
          expect(assigns(:comment)).to eq(comment)
        end
      end

      context "with valid params but updating other user share" do
        let(:new_attributes) {
          {content: "altered content"}
        }

        it "doesn`t update the requested comment" do
          comment = create(:comment, valid_attributes.merge(user_id: other_user.id))
          put :update, {:id => comment.id, :comment => new_attributes}
          comment.reload
          expect(assigns(:comment).content).not_to eql("altered content")
        end

        it "return unauthorized" do
          comment = create(:comment, valid_attributes.merge(user_id: other_user.id))
          put :update, {:id => comment.id, :comment => new_attributes}
          expect(response.response_code).to eql(401)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested comment" do
        comment = create(:comment, valid_attributes)
        expect {
          delete :destroy, {:id => comment.id}
        }.to change(Comment, :count).by(-1)
      end

      context "deleting other user comment" do

        it "doesn`t destroy the requested comment" do
          comment = create(:comment, valid_attributes.merge(user_id: other_user.id))
          expect {
            delete :destroy, {:id => comment.id}
          }.not_to change(Comment, :count)
        end

        it "doesn`t destroy the requested comment" do
          comment = create(:comment, valid_attributes.merge(user_id: other_user.id))
          delete :destroy, {:id => comment.id}
          expect(response.response_code).to eql(401)
        end

      end
    end

  end


end
