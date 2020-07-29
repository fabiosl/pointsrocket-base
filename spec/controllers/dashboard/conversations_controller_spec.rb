require 'rails_helper'

RSpec.describe Dashboard::ConversationsController, type: :controller do
  let(:domain) { build(:domain) }
  let(:user) { build(:user) }
  let(:conversation) { create(:conversation) }
  let(:ability) { Ability.new(user) }

  before do
    sign_in(user)

    allow(controller).to receive(:current_ability).and_return(ability)
    allow(controller).to receive(:current_domain).and_return(domain)
    allow(controller).to receive(:create_membership)
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    before { ability.can :read, conversation }
    
    it 'returns a successful response' do
      get :show, id: conversation

      expect(response).to have_http_status(:success)
    end

    it 'returns conversation' do
      get :show, id: conversation

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['conversation']['id']).to eq(conversation.id)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'returns a successful response' do
        post :create, conversation: attributes_for(:conversation)
        expect(response).to have_http_status(:success)
      end

      it 'creates a conversation' do
        expect {
          post :create, conversation: attributes_for(:conversation)
        }.to change(Conversation, :count).by(1)
      end
    end

    context 'without users' do
      it 'returns a error response' do
        post :create, conversation: attributes_for(:conversation, :without_users)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a list of errors' do
        post :create, conversation: attributes_for(:conversation, :without_users)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors'].length).to be > 0
      end

      it 'does not create a conversation' do
        expect {
          post :create, conversation: attributes_for(:conversation, :without_users)
        }.to change(Conversation, :count).by(0)
      end
    end
  end
end
