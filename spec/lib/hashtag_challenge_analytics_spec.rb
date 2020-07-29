require 'rails_helper'

RSpec.describe HashtagChallengeAnalytics do

  before do
    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)

    @hcu1 = create(
      :hashtag_challenge_user,
      user: @user1,
      created_at: 1.day.ago,
      status: 'approved',
      json: File.open(
        Rails.root.join("spec", "fixtures", "hashtag_challenge_user_1.json")
      ).read
    )

    @hcu2 = create(
      :hashtag_challenge_user,
      user: @user2,
      created_at: 2.day.ago,
      status: 'approved',
      json: File.open(
        Rails.root.join("spec", "fixtures", "hashtag_challenge_user_2.json")
      ).read
    )

    @hcu3 = create(
      :hashtag_challenge_user,
      user: @user3,
      status: 'approved',
      created_at: Time.now,
      json: File.open(
        Rails.root.join("spec", "fixtures",
          "hashtag_challenge_user_without_cost_engagemen_followers_info_1.json")
      ).read
    )
  end

  describe "for all publications" do
    describe "total_cost" do
      subject { described_class.for_all_publications.total_cost }

      it "get correctly totalcost" do
        expect(subject).to eql(20)
      end
    end

    describe "total_post" do
      subject { described_class.for_all_publications.total_post }

      it "get correctly" do
        expect(subject).to eql(3)
      end
    end

    describe "total_interactions" do
      subject { described_class.for_all_publications.total_interactions }

      it "get correctly" do
        expect(subject).to eql(80)
      end
    end

    describe "good_interactions" do
      subject { described_class.for_all_publications.good_interactions }

      it "get correctly" do
        expect(subject).to eql(80)
      end
    end

    describe "bad_interactions" do
      subject { described_class.for_all_publications.bad_interactions }

      it "get correctly" do
        expect(subject).to eql(0)
      end
    end

    describe "potential_reach" do
      subject { described_class.for_all_publications.potential_reach }

      it "get correctly" do
        expect(subject).to eql(500)
      end
    end

    describe "potential_impact" do
      subject { described_class.for_all_publications.potential_impact }

      it "get correctly" do
        expect(subject).to eql(1000)
      end
    end

    describe "top_publications" do
      subject { described_class.for_all_publications.top_publications(2) }

      it "get correctly" do
        expect(subject[0].id).to eql(@hcu2.id)
        expect(subject[1].id).to eql(@hcu1.id)
      end
    end

    describe "down_publications" do
      subject { described_class.for_all_publications.down_publications(2) }

      it "get correctly" do
        expect(subject[0].id).to eql(@hcu3.id)
        expect(subject[1].id).to eql(@hcu1.id)
      end
    end

    describe "most_engaged_user" do
      subject { described_class.for_all_publications.most_engaged_user(2) }

      it "get correctly" do
        expect(subject[0][:user].id).to eql(@hcu2.user.id)
        expect(subject[1][:user].id).to eql(@hcu1.user.id)
      end
    end

    describe "worst_engaged_user" do
      subject { described_class.for_all_publications.worst_engaged_user(2) }

      it "get correctly" do
        expect(subject[0][:user].id).to eql(@hcu3.user.id)
        expect(subject[1][:user].id).to eql(@hcu1.user.id)
      end
    end

    describe "eemv_evolution" do
      subject { described_class.for_all_publications.eemv_evolution }

      it "get correctly" do
        expect(subject[0][:start]).to eql(2.days.ago.beginning_of_day)
        expect(subject[0][:end]).to eql(2.days.ago.end_of_day)
        expect(subject[0][:items][0].id).to eql(@hcu2.id)
        expect(subject[0][:eemv]).to eql(10)

        expect(subject[1][:start]).to eql(1.days.ago.beginning_of_day)
        expect(subject[1][:end]).to eql(1.days.ago.end_of_day)
        expect(subject[1][:items][0].id).to eql(@hcu1.id)
        expect(subject[1][:eemv]).to eql(10)

        expect(subject[2][:start]).to eql(Time.now.beginning_of_day)
        expect(subject[2][:end]).to eql(Time.now.end_of_day)
        expect(subject[2][:items][0].id).to eql(@hcu3.id)
        expect(subject[2][:eemv]).to eql(0)
      end
    end
  end


end
