require 'rails_helper'

RSpec.describe Dashboard::QuestionsController, :type => :controller do

  describe "POST create" do
    context "when valid and sending tags" do
      before do
        login_user
        @question_attributes = build(:question, step: nil).attributes
        post :create, { question: @question_attributes.merge(tag_list: 'random_tag') }
      end

      it { expect(request).to redirect_to forum_path }

      it { expect(flash[:success]).to match(/sucesso/) }

      it "should add tags" do
        expect(assigns(:question).tag_list).to eql(['random_tag'])
      end
    end

    context "when valid and not sending tags" do
      before do
        user = login_user
        user.tag_list.add "onrocket"
        user.save
        @question_attributes = build(:question, step: nil).attributes
        post :create, { question: @question_attributes }
      end

      it { expect(request).to redirect_to forum_path }

      it { expect(flash[:success]).to match(/sucesso/) }

      it "should add user tags" do
        expect(assigns(:question).tag_list).to eql(['onrocket'])
      end
    end

    context "when valid" do
      before do
        login_user
        @course = create(:course)
        @course.tag_list = "some_tag"
        @course.save
        chapter = create(:chapter, course: @course)
        @step = create(:step, chapter: chapter)
        @question_attributes = build(:question, step: @step).attributes
        post :create, { question: @question_attributes }
      end

      it "should redirect to step page" do
        expect(request). to redirect_to course_chapter_step_path(
          @step.chapter.course.slug, @step.chapter.slug, @step.position
        )
      end

      it "should show success message" do
        expect(flash[:success]).to match(/sucesso/)
      end

      it "should add course tags" do
        expect(assigns(:question).tag_list).to eql(@course.tag_list)
      end
    end
  end

  context "when invalid" do
    before do
      login_user
      @step = create(:step)
      @question_attributes = build(:question, content: nil, step: @step).attributes
      post :create, { question: @question_attributes }
    end

    it "should redirect to step page" do
      expect(request). to redirect_to course_chapter_step_path(
        @step.chapter.course.slug, @step.chapter.slug, @step.position
      )
    end

    it "should show error message" do
      expect(flash[:error]).to match(/Não foi possível/)
    end
  end
end
