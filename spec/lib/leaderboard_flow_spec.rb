require 'rails_helper'

RSpec.describe LeaderboardFlow do

  describe "get" do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)

      # adicionando pontos a user 1 (hoje)
      create(:point, user: @user1, created_at: Time.now, value: 10)
      create(:point, user: @user1, created_at: Time.now, value: 10)
      create(:point, user: @user1, created_at: Time.now, value: 10)

      # adicionando pontos a user 1 (ontem)
      create(:point, user: @user1, created_at: 1.day.ago, value: 10)
      create(:point, user: @user1, created_at: 1.day.ago, value: 10)

      # adicionando pontos a user 2 (hoje)
      create(:point, user: @user2, created_at: Time.now, value: 10)
      create(:point, user: @user2, created_at: Time.now, value: 10)

      # adicionando pontos a user 2 (ontem)
      create(:point, user: @user2, created_at: 1.day.ago, value: 10)

      # adicionando pontos a user 3 (hoje)
      create(:point, user: @user3, created_at: Time.now, value: 10)
    end

    subject { described_class.new.get(period) }

    context "when period is daily" do
      let(:period) { 'daily' }

      it "return correct leaderboard" do
        expect(subject[0].sum_points).to eql(30)
        expect(subject[1].sum_points).to eql(20)
        expect(subject[2].sum_points).to eql(10)
      end
    end
  end

end
