require 'rails_helper'

RSpec.describe PointsEvolutionFlow do

  describe "get" do
    before do
      allow(Time).to receive(:now).and_return(Time.parse("2016-07-17 12:00:00"))
      yesterday = Time.parse("2016-07-16 12:00:00")
      last_week = Time.parse("2016-07-10 12:00:00")

      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)

      # adicionando pontos a user 1 (hoje)
      create(:point, user: @user1, created_at: Time.now, value: 10)
      create(:point, user: @user1, created_at: Time.now, value: 10)
      create(:point, user: @user1, created_at: Time.now, value: 10)

      # adicionando pontos a user 1 (ontem)
      create(:point, user: @user1, created_at: yesterday, value: 10)
      create(:point, user: @user1, created_at: yesterday, value: 10)

      # adicionando pontos a user 1 (last week)
      create(:point, user: @user1, created_at: last_week, value: 10)
      create(:point, user: @user1, created_at: last_week, value: 10)
    end

    subject { described_class.new(@user1).get(period, group) }

    context "when period is this_month and group is weekly" do
      let(:period) { 'this_month' }
      let(:group) { 'weekly' }

      it "return points evolution" do
        result = subject
        expect(result[Time.parse("2016-07-04 00:00:00 UTC")]).to eql(20)
        expect(result[Time.parse("2016-07-11 00:00:00 UTC")]).to eql(50)
      end
    end

    context "when period is this_month and group is daily" do
      let(:period) { 'this_month' }
      let(:group) { 'daily' }

      it "return points evolution" do
        result = subject
        expect(result[Time.parse("2016-07-10 00:00:00 UTC")]).to eql(20)
        expect(result[Time.parse("2016-07-11 00:00:00 UTC")]).to eql(0)
        expect(result[Time.parse("2016-07-12 00:00:00 UTC")]).to eql(0)
        expect(result[Time.parse("2016-07-13 00:00:00 UTC")]).to eql(0)
        expect(result[Time.parse("2016-07-14 00:00:00 UTC")]).to eql(0)
        expect(result[Time.parse("2016-07-15 00:00:00 UTC")]).to eql(0)
        expect(result[Time.parse("2016-07-16 00:00:00 UTC")]).to eql(20)
        expect(result[Time.parse("2016-07-17 00:00:00 UTC")]).to eql(30)
      end
    end
  end

end
