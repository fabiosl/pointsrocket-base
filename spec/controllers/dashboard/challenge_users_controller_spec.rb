require 'rails_helper'

RSpec.describe Dashboard::ChallengeUsersController, :type => :controller do

  let(:challenge) {
    create(:challenge)
  }

  let(:valid_attributes) {
    build(:challenge_user, challenge: challenge).attributes.merge(accept_terms: "1")
  }


  let(:invalid_attributes) {
    {
      url: '',
      description: '',
    }
  }

  let!(:domain) { create(:domain) }

  render_views

  context "with user logged" do
    describe "POST create" do
      describe "invalid atributes" do
        before do
          login_user

          post :create, challenge_user: invalid_attributes, challenge_id: challenge.id, current_domain_id: domain.id
        end

        it "doesn`t create and render show" do
          expect(request).to render_template("dashboard/challenges/show")
          expect(assigns[:challenge_user]).to be_a(ChallengeUser)
          expect(assigns[:challenge_user]).not_to be_persisted
        end
      end

      describe "without accept terms" do
        before do
          login_user

          post :create, challenge_user: valid_attributes.merge(accept_terms: "0"), challenge_id: challenge.id, current_domain_id: domain.id
        end

        it "doesn`t create and render show" do
          expect(request).to render_template("dashboard/challenges/show")
          expect(assigns[:challenge_user]).to be_a(ChallengeUser)
          expect(assigns[:challenge_user]).not_to be_persisted
        end
      end

      describe "valid atributes" do
        before do
          login_user
        end

        subject do
          post :create, challenge_user: valid_attributes, challenge_id: challenge.id, current_domain_id: domain.id
        end

        it "create challenge" do
          expect(subject).to redirect_to(challenge_path(challenge))
          expect(assigns[:challenge_user]).to be_a(ChallengeUser)
          expect(assigns[:challenge_user]).to be_persisted
        end
      end
    end


    describe "PUT update" do
      let!(:owner) { create(:user) }
      let!(:other_user) { create(:user) }
      let!(:challenge_user) { create(:challenge_user, user: owner, challenge: challenge) }

      subject do
        put :update, challenge_user: attributes, id: challenge_user.to_param, challenge_id: challenge.id, current_domain_id: domain.id
      end

      context "logged owner" do
        before do
          login_user owner
        end

        describe "invalid atributes" do
          let(:attributes) { invalid_attributes }

          it "should render show" do
            expect(subject).to render_template("dashboard/challenges/show")
          end
        end

        describe "valid atributes" do
          let(:attributes) { {url: "http://new.url"} }

          it "create template" do
            expect(subject).to redirect_to(challenge_path(challenge))
            challenge_user.reload
            expect(challenge_user.url).to eql(attributes[:url])
          end
        end
      end

      context "logged other user" do
        before do
          login_user other_user
        end

        describe "valid atributes" do
          let(:attributes) { {url: "http://new.url"} }

          it "not update" do
            subject
            challenge_user.reload
            expect(challenge_user.url).not_to eql(attributes[:url])
          end
        end
      end

    end
  end


end
