require 'rails_helper'

RSpec.describe DomainService do

  let(:url) { "http://localhost:3000" }
  let(:default) { false }

  let!(:domain) { create(:domain, url: url, default: default) }

  subject { described_class.new(domain) }

  describe ".get_domain_by_url" do
    context "when same url" do
      it "returns same domain" do
        expect(described_class.get_domain_by_url(url)).to eql(domain)
      end
    end

    context "when passing other url" do

      context "with default domain" do
        let!(:domain_default) { create(:domain, default: true) }

        it "returns domain with default true" do
          expect(described_class.get_domain_by_url("http://other.url")).to eql(domain_default)
        end
      end

      context "without default domain" do
        it "returns domain with default true" do
          expect {
            described_class.get_domain_by_url("http://other.url")
          }.to be_nil
        end
      end
    end
  end

end
