require 'rails_helper'

RSpec.describe EmployeeAdvocacyVisitFlow do

  describe "visit" do
    let(:employee_advocacy_share) {
      create(:employee_advocacy_share)
    }

    subject {
      described_class.new(employee_advocacy_share, ids_visiteds)
    }

    context "when ids_visiteds is nil" do
      let(:ids_visiteds) { nil }

      it "creates a visit" do
        expect {
          subject.visit
        }.to change(EmployeeAdvocacyVisit, :count).by(1)
      end

      it "creates a push @ids_visiteds" do
        subject.visit
        expect(subject.ids_visiteds).to eql([employee_advocacy_share.id.to_s])
      end

      it "creates a visit with new_visit true" do
        visit = subject.visit
        expect(visit.new_visit).to be_truthy
      end
    end

    context "when ids_visiteds is ''" do
      let(:ids_visiteds) { '' }

      it "creates a visit" do
        expect {
          subject.visit
        }.to change(EmployeeAdvocacyVisit, :count).by(1)
      end

      it "creates a push @ids_visiteds" do
        subject.visit
        expect(subject.ids_visiteds).to eql([employee_advocacy_share.id.to_s])
      end

      it "creates a visit with new_visit true" do
        visit = subject.visit
        expect(visit.new_visit).to be_truthy
      end
    end

    context "when ids_visiteds is []" do
      let(:ids_visiteds) { [] }

      it "creates a visit" do
        expect {
          subject.visit
        }.to change(EmployeeAdvocacyVisit, :count).by(1)
      end

      it "creates a push @ids_visiteds" do
        subject.visit
        expect(subject.ids_visiteds).to eql([employee_advocacy_share.id.to_s])
      end

      it "creates a visit with new_visit true" do
        visit = subject.visit
        expect(visit.new_visit).to be_truthy
      end
    end

    context "when has already visited" do
      let(:ids_visiteds) { [employee_advocacy_share.id.to_s] }

      it "creates a visit" do
        expect {
          subject.visit
        }.to change(EmployeeAdvocacyVisit, :count).by(1)
      end

      it "creates a push @ids_visiteds" do
        subject.visit
        expect(subject.ids_visiteds).to eql([employee_advocacy_share.id.to_s])
      end

      it "creates a visit with new_visit false" do
        visit = subject.visit
        expect(visit.new_visit).to be_falsey
      end
    end
  end

end
