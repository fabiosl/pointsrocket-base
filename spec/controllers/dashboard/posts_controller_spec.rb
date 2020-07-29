require 'rails_helper'

RSpec.describe Dashboard::PostsController, type: :controller do
  describe 'GET #index' do
    it 'returns success response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
