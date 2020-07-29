require 'rails_helper'

RSpec.describe VoteFlow do

  let(:user) { create(:user) }
  let(:user_creator) { create(:user) }
  let(:question) {
    create(:question, user: user_creator)
  }

  context "question with no vote" do
    describe "up" do
      it "should create vote model" do
        expect {
          described_class.new(user).up(question)
        }.to change {
          Vote.count
        }.by(1)
      end

      it "should add points to user_creator with positive value" do
        expect {
          described_class.new(user).up(question)
        }.to change {
          user_creator.points.count
        }.by(1)

        expect(user_creator.points.first.value).to eq(ENV['VOTE_VALUE'].to_i)
      end
    end

    describe "down" do
      it "should create vote model" do
        expect {
          described_class.new(user).down(question)
        }.to change {
          Vote.count
        }.by(1)
      end

      it "should add points to user_creator with negative value" do
        expect {
          described_class.new(user).down(question)
        }.to change {
          user_creator.points.count
        }.by(1)

        expect(user_creator.points.first.value).to eq(-ENV['VOTE_VALUE'].to_i)
      end

    end
  end

  context "question with vote" do
    describe "up" do
      before do
        described_class.new(user).up(question)
      end

      it "should destroy vote model" do
        expect {
          described_class.new(user).up(question)
        }.to change {
          Vote.count
        }.by(-1)
      end

      it "should remove points from user_creator for that vote" do
        expect {
          described_class.new(user).up(question)
        }.to change {
          user_creator.points.count
        }.by(-1)
      end
    end

    describe "down" do
      before do
        described_class.new(user).down(question)
      end

      it "should destroy vote model" do
        expect {
          described_class.new(user).down(question)
        }.to change {
          Vote.count
        }.by(-1)
      end

      it "should remove points from user_creator for that vote" do
        expect {
          described_class.new(user).down(question)
        }.to change {
          user_creator.points.count
        }.by(-1)
      end
    end

    describe "other vote" do
      before do
        described_class.new(user).down(question)
      end

      it "destroys previous vote" do
        vote = user.votes.first
        described_class.new(user).up(question)
        new_vote = user.votes.first
        expect(vote.status).not_to eql(new_vote.status)
      end

      it "creates other vote with upvote" do
        described_class.new(user).up(question)
        vote = user.votes.first
        expect(vote.status).to eq('upvote')
      end

      it "destroys previous point" do
        point = question.user.points.first
        described_class.new(user).up(question)
        expect { point.reload }.to raise_error
      end

      it "creates other points with upvote points" do
        described_class.new(user).up(question)
        point = question.user.points.first
        expect(point.value).to eq(ENV['VOTE_VALUE'].to_i)
      end
    end
  end

end
