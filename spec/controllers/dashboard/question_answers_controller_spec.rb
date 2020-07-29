require 'rails_helper'

RSpec.describe Dashboard::QuestionAnswersController, :type => :controller do

  let(:referer) {
    'referer'
  }

  before do
    request.env['HTTP_REFERER'] = referer
  end

  let(:step_question) {
    create(:step_question)
  }

  let(:step_question_option) {
    create(:step_question_option)
  }

  let(:valid_attributes) {
    {
      step_question_id: step_question.id,
      step_question_option_id: step_question_option.id,
    }
  }

  let(:invalid_attributes) {
    {
      step_question_id: step_question.id
    }
  }

  context "with user logged" do
    describe "POST create" do
      describe "invalid atributes" do
        before do
          login_user

          post :create, question_answer: invalid_attributes, format: :json
        end

        it "should redirect to referer" do
          expect(request).to redirect_to(referer)
        end
      end

      describe "valid atributes" do
        before do
          login_user
          post :create, question_answer: valid_attributes, format: :json
        end

        it "assigns question_answer" do
          expect(assigns[:question_answer]).to be_a(QuestionAnswer)
          expect(assigns[:question_answer]).to be_persisted
        end
      end
    end
  end


end
