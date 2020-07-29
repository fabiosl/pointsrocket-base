# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  recipient_id    :integer
#  actor_id        :integer
#  action          :string(255)
#  notifiable_id   :integer
#  notifiable_type :string(255)
#  read_at         :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

# RSpec.describe Notification, type: :model do
  # describe "my_notifications" do
  #   let!(:user) { create(:user) }

  #   subject { described_class.for_user(user).to_a }

  #   context "when system has notification" do
  #     before do
  #       @system_notification = create(:notification)
  #     end

  #     it "retrieves all notifications" do
  #       expect(subject).to match_array([@system_notification])
  #     end
  #   end

  #   context "when other user has notification" do
  #     before do
  #       @user_notification = create(:notification, user: create(:user))
  #     end

  #     it "retrieves nothing" do
  #       expect(subject).to match_array([])
  #     end
  #   end

  #   context "when user hast notification" do
  #     before do
  #       @user_notification = create(:notification, user: user)
  #     end

  #     it "retrieves user notification" do
  #       expect(subject).to match_array([@user_notification])
  #     end
  #   end

  #   context "when user has notification and the system too" do
  #     before do
  #       @user_notification = create(:notification, user: user)
  #       @other_user_notification = create(:notification, user: create(:user))
  #       @system_notification = create(:notification)
  #     end

  #     it "retrieves notifications from user and system" do
  #       expect(subject).to match_array([@user_notification, @system_notification])
  #     end
# RSpec.shared_examples "a not read notification" do
#   it "isn`t read by reader" do
#     expect(described_class.read(user)).to match_array([])
#   end
# end

# RSpec.shared_examples "a read notification" do
#   it "is read by reader" do
#     expect(described_class.read(user).first).to eql(subject)
#   end
# end

# RSpec.shared_examples "all_with_read a not read notification" do
#   it "isn`t read by reader" do
#     expect(described_class.all_with_read(user).first.notification_reads_id).to be_nil
#   end
# end

# RSpec.shared_examples "all_with_read a read notification" do
#   it "is read by reader" do
#     expect(described_class.all_with_read(user).first.notification_reads_id).not_to be_nil
#   end
# end

RSpec.describe Notification, type: :model do

  let!(:notification) {
    create(:notification, to_all: to_all)
  }

  let!(:to_all) { true }

  let!(:user) {
    create(:user)
  }

  subject { notification }

  describe "scopes" do
    describe "read and all_with_read" do
      let(:notification_reader) { create(:user) }

      context "with notification not read" do
        it_behaves_like "a not read notification"
        it_behaves_like "all_with_read a not read notification"
      end

      context "with notification read" do
        before do
          described_class.mark_all_notifications_read_for notification_reader
        end

        context "by same user" do
          let(:notification_reader) { user }
          it_behaves_like "a read notification"
          it_behaves_like "all_with_read a read notification"
        end

        context "by other user" do
          let(:notification_reader) { create(:user) }
          it_behaves_like "a not read notification"
          it_behaves_like "all_with_read a not read notification"
        end
      end

    end
  end
end
