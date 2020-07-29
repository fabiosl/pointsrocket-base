require 'rails_helper'

RSpec.describe DashboardHelper, type: :helper do
  describe "distance missing to a specific date" do

    subject { helper.distance_of_time_in_words_to_weekday(specific_day) }

    before do
      allow(helper).to receive(:get_now_datetime).and_return(today.to_datetime)
    end

    let(:specific_day) { "Monday 07:00 BRT" }

    context "when today is Monday 06:00" do
      let(:today) { Time.parse("2017-12-04 06:00 BRT") }

      it "should be today" do
        expect(subject).to eql("hoje")
      end
    end

    context "when today is Sunday 23:59" do
      let(:today) { Time.parse("2017-12-03 23:59 BRT") }

      it "should be tomorrow" do
        expect(subject).to eql("amanha")
      end
    end

    context "when today is Monday 08:00" do
      let(:today) { Time.parse("2017-12-04 08:00 BRT") }

      it "should be in 7 days" do
        expect(subject).to eql("em 7 dias")
      end
    end
  end
end
