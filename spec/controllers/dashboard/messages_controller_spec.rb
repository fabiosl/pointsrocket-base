require 'rails_helper'

RSpec.describe Dashboard::MessagesController, type: :controller do
  let(:domain) { build(:domain) }
  let(:user) { build(:user) }
  let(:conversation) { create(:conversation) }

  before do
    sign_in(user)
    allow(controller).to receive(:current_domain).and_return(domain)
    allow(controller).to receive(:create_membership)
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index, conversation_id: conversation.id

      expect(response).to have_http_status(:success)
    end

    it 'returns all messages' do
      message = build(:message)
      conversation.messages << message
      get :index, conversation_id: conversation.id

      parsed_response = JSON.parse(response.body)
      expect(parsed_response.length).to be 1
    end
  end


  describe 'POST #create' do
    context 'with valid attributes' do
      it 'returns a successful response' do
        post :create, conversation_id: conversation.id,
                      message: attributes_for(:message)

        expect(response).to have_http_status(:success)
      end

      it 'creates a new message' do
        expect {
          post :create, conversation_id: conversation.id,
                        message: attributes_for(:message)
        }.to change(Message, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'returns a error response when message body is empty' do
        post :create, conversation_id: conversation.id,
                      message: attributes_for(:message, :without_body)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a error list when message body is empty' do
        post :create, conversation_id: conversation.id,
                      message: attributes_for(:message, :without_body)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors'].length).to be > 0
      end
    end
  end
end
