require 'rails_helper'

RSpec.describe GoalsFlow do

  describe "info" do
    before do
      @badge_reusable = create(:badge, name: "reusable", badge_type: "reusable", badge_points: 50)
      @badge_simple = create(:badge, name: "simple", badge_type: "simple", badge_points: 50)
      goal.badge_goals.create(badge: @badge_reusable, repetition: 2)
      goal.badge_goals.create(badge: @badge_simple, repetition: 1)
    end

    let(:user) { create(:user, tag_list: goal.tag_list) }

    subject { described_class.new.info(user.tags) }

    let(:goal) {
      create(:goal, tag_list: 'tag')
    }

    context "user hasn`t make any badge" do
      it "return []" do
        expect(subject.to_a).to eql([{
          goal: goal,
          first_users_hit_goal: [],
          users_hit_goal_count: 0,
        }])
      end
    end

    context "user has make a few badge" do
      before do
        user = create(:user)
        user.tags = goal.tags
        user.save
        user.add_badge @badge_reusable
        user.add_badge @badge_simple
        @user = user
      end

      it "return []" do
        expect(subject.to_a).to eql([{
          goal: goal,
          first_users_hit_goal: [],
          users_hit_goal_count: 0,
        }])
      end
    end

    context "user has make all badges" do
      before do
        user = create(:user)
        user.tags = goal.tags
        user.save
        user.add_badge @badge_reusable
        user.add_badge @badge_reusable
        user.add_badge @badge_simple
        @user = user
      end

      it "return user" do
        expect(subject.to_a).to eql([{
          goal: goal,
          first_users_hit_goal: [@user],
          users_hit_goal_count: 1,
        }])
      end
    end

    context "user has make more badges" do
      before do
        user = create(:user)
        user.tags = goal.tags
        user.save
        user.add_badge @badge_reusable
        user.add_badge @badge_reusable
        user.add_badge @badge_reusable
        user.add_badge @badge_simple
        @user = user
      end

      it "return user" do
        expect(subject.to_a).to eql([{
          goal: goal,
          first_users_hit_goal: [@user],
          users_hit_goal_count: 1,
        }])
      end
    end
  end

  describe "hit goal" do
    before do
      @badge_reusable = create(:badge, name: "reusable", badge_type: "reusable")
      @badge_simple = create(:badge, name: "simple", badge_type: "simple")
      goal.badge_goals.create(badge: @badge_reusable, repetition: 2)
      goal.badge_goals.create(badge: @badge_simple, repetition: 1)
    end

    let(:user) { nil }
    subject { described_class.new.hit_goal goal }

    let(:goal) {
      create(:goal, tag_list: 'tag')
    }

    context "user hasn`t make any badge" do
      it "return []" do
        expect(subject.to_a).to eql([])
      end
    end

    context "user has make a few badge" do
      before do
        user = create(:user)
        user.tags = goal.tags
        user.save
        user.add_badge @badge_reusable
        user.add_badge @badge_simple
        @user = user
      end

      it "return []" do
        expect(subject.to_a).to eql([])
      end
    end

    context "user has make all badges" do
      before do
        user = create(:user)
        user.tags = goal.tags
        user.save
        user.add_badge @badge_reusable
        user.add_badge @badge_reusable
        user.add_badge @badge_simple
        @user = user
      end

      it "return user" do
        expect(subject.to_a).to eql([@user])
      end
    end

    context "user has make more badges" do
      before do
        user = create(:user)
        user.tags = goal.tags
        user.save
        user.add_badge @badge_reusable
        user.add_badge @badge_reusable
        user.add_badge @badge_reusable
        user.add_badge @badge_simple
        @user = user
      end

      it "return user" do
        expect(subject.to_a).to eql([@user])
      end
    end
  end

end
