require 'spec_helper'

RSpec.describe Token, type: :model do
  let(:user) {
    double()
  }

  let(:email) {
    'any@mail.com'
  }

  let(:email_args) {
    {
      email: email
    }
  }

  describe "create_for" do

    before do
      allow(described_class).to(
        receive(:find_user).with(email_args)
          .and_return(find_user_return)
      )
    end

    context "when user doesn`t exists" do

      let(:find_user_return) { nil }

      it "returns failed message" do
        expect(described_class.create_for(email_args)).to(
          eql(nil)
        )
      end
    end

    # context "when user exists" do

    #   let(:find_user_return) { user }

    #   it "returns a token" do
    #     expect(described_class.create_for(email_args)).to(
    #       kind_of(described_class)
    #     )
    #   end
    # end
  end
end
