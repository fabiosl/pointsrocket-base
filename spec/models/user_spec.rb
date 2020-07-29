# == Schema Information
#
# Table name: users
#
#  id                                 :integer          not null, primary key
#  email                              :string(255)      default(""), not null
#  encrypted_password                 :string(255)      default(""), not null
#  reset_password_token               :string(255)
#  reset_password_sent_at             :datetime
#  remember_created_at                :datetime
#  sign_in_count                      :integer          default(0), not null
#  current_sign_in_at                 :datetime
#  last_sign_in_at                    :datetime
#  current_sign_in_ip                 :string(255)
#  last_sign_in_ip                    :string(255)
#  created_at                         :datetime
#  updated_at                         :datetime
#  provider                           :string(255)
#  uid                                :string(255)
#  name                               :string(255)
#  needs_edit                         :boolean          default(TRUE)
#  avatar_file_name                   :string(255)
#  avatar_content_type                :string(255)
#  avatar_file_size                   :integer
#  avatar_updated_at                  :datetime
#  plan_id                            :integer
#  expires_in                         :datetime
#  website                            :string(255)
#  bio                                :text
#  location                           :string(255)
#  username                           :string(255)
#  lang                               :string(255)
#  timezone                           :string(255)
#  country                            :string(255)
#  see_sensitive_media                :boolean          default(FALSE)
#  mark_sensitive_media               :boolean          default(FALSE)
#  facebook_json                      :text
#  sash_id                            :integer
#  level                              :integer          default(0)
#  ranking_position                   :integer
#  indicator_id                       :integer
#  cpf                                :string(255)
#  phone                              :string(255)
#  birthdate                          :datetime
#  moip_code                          :string(255)
#  has_submited_payment_form          :boolean          default(FALSE)
#  master                             :boolean          default(FALSE)
#  renew                              :boolean          default(TRUE)
#  expires_at                         :datetime
#  moip_signature_code                :string(255)
#  signature_status                   :string(255)
#  cancel_reason                      :string(255)
#  admin                              :boolean          default(FALSE)
#  mailed_welcome                     :boolean          default(FALSE)
#  sum_points                         :integer          default(0)
#  created_in_dash                    :boolean          default(FALSE)
#  voucher                            :string(255)
#  can_manage_all_domains             :boolean          default(FALSE)
#  locale                             :string(255)
#  youtube_channel_id_to_monitor      :text
#  facebook_page_id_to_monitor        :text
#  registration_complete              :boolean          default(FALSE)
#  next_youtube_collect               :datetime
#  next_facebook_collect              :datetime
#  next_instagram_collect             :datetime
#  last_access                        :datetime
#  facebook_page_name_to_monitor      :string(255)
#  facebook_page_picture_to_monitor   :string(255)
#  youtube_channel_name_to_monitor    :string(255)
#  youtube_channel_picture_to_monitor :string(255)
#  unsubscribe_token                  :string(255)
#  subscribe                          :boolean          default(TRUE)
#  has_sent_access_token_expired_mail :boolean          default(FALSE)
#  token_login                        :string(255)
#  must_alter_password                :boolean
#  next_twitter_advocacy_collect      :datetime
#  next_facebook_advocacy_collect     :datetime
#  available_coins                    :integer          default(0)
#

require 'rails_helper'
require "cancan/matchers"

RSpec.describe User, type: :model do

  shared_examples "user" do
    it { is_expected.to be_able_to(:indication, user) }
    it { is_expected.to be_able_to(:badges, user) }
    it { is_expected.to be_able_to(:points, user) }
    it { is_expected.to be_able_to(:campaigns, user) }
    it { is_expected.to be_able_to(:index, EmployeeAdvocacyPost) }
    it { is_expected.not_to be_able_to(:manage, create(:employee_advocacy_share)) }
    it { is_expected.to be_able_to(:manage, create(:employee_advocacy_share, user: user)) }
    it { is_expected.to be_able_to(:destroy, create(:comment, user: user)) }

    describe "votes" do
      it { is_expected.to be_able_to(:create, Vote) }
      it { is_expected.to be_able_to(:update, create(:vote, user: user)) }
      it { is_expected.to be_able_to(:destroy, create(:vote, user: user)) }
      it { is_expected.not_to be_able_to(:update, create(:vote)) }
      it { is_expected.not_to be_able_to(:destroy, create(:vote)) }
    end
  end

  shared_examples "normal user" do
    it_behaves_like "user"

    it { is_expected.not_to be_able_to(:see_email_preview, user) }
    it { is_expected.not_to be_able_to(:users, user) }
    it { is_expected.not_to be_able_to(:user_badges, user) }
    it { is_expected.not_to be_able_to(:see_formatted_names, user) }
    it { is_expected.not_to be_able_to(:manage_sites, user) }
    it { is_expected.not_to be_able_to(:kpi, user) }
    it { is_expected.not_to be_able_to(:create, EmployeeAdvocacyPost) }
    it { is_expected.not_to be_able_to(:update, create(:employee_advocacy_post)) }
    it { is_expected.not_to be_able_to(:destroy, create(:employee_advocacy_post)) }
    it { is_expected.not_to be_able_to(:destroy, create(:comment, user: other_user)) }
  end

  shared_examples "admin user" do
    it_behaves_like "user"

    it { is_expected.to be_able_to(:see_email_preview, user) }
    it { is_expected.to be_able_to(:users, user) }
    it { is_expected.to be_able_to(:user_badges, user) }
    it { is_expected.to be_able_to(:see_formatted_names, user) }
    it { is_expected.to be_able_to(:manage_sites, user) }
    it { is_expected.to be_able_to(:kpi, user) }
    it { is_expected.to be_able_to(:create, EmployeeAdvocacyPost) }
    it { is_expected.to be_able_to(:update, create(:employee_advocacy_post)) }
    it { is_expected.to be_able_to(:destroy, create(:employee_advocacy_post)) }
    it { is_expected.to be_able_to(:destroy, create(:comment, user: other_user)) }
  end

  describe "validations" do
    [:birthdate, :phone].each do |attribute|
      context "hasSubmitedPaymentForm" do
        subject {
          attrs = {
            has_submited_payment_form: true
          }
          attrs[attribute] = nil
          user = build(:user, attrs)
        }

        it "is not valid" do
          is_expected.not_to be_valid
        end

        it "has #{attribute} erro" do
          subject.valid?
          expect(subject.errors).to have_key(attribute)
        end

      end
    end

    context "master" do
      subject {
        create(:user, master: true, name: "test", cpf: nil, phone: nil, birthdate: nil)
      }
      it "skip most validations" do
        is_expected.to be_valid
      end
    end
  end

  describe "association" do
    describe '#address' do
      it "creates addresses" do
        addresses_attributes = build(:address).attributes
        user = create(:user, {addresses_attributes: [addresses_attributes]})
        expect(user.addresses.count).to eq(1)
      end

      # if "should have at least"
    end
    describe '#credit_cards' do
      it "creates credit_card" do
        credit_cards_attributes = build(:credit_card).attributes
        user = create(:user, {credit_cards_attributes: [credit_cards_attributes]})
        expect(user.credit_cards.count).to eq(1)
      end
    end
  end

  describe "points" do
    before do
      @course = create(:course)

      @chapter = create(:chapter, course: @course)
      @video = create(:step, step_type: 'Vídeo', chapter: @chapter) # 20 ENV['DEFAULT_STEP_POINTS']
      @quiz_without_points_1 = create(:step, step_type: 'Quiz', chapter: @chapter) # 20 ENV['DEFAULT_STEP_QUESTION_POINTS']
      @quiz_without_points_2 = create(:step, step_type: 'Quiz', chapter: @chapter) # 20 ENV['DEFAULT_STEP_QUESTION_POINTS']
      @quiz_with_points = create(:step, step_type: 'Quiz', chapter: @chapter) # 50
      @quiz_with_points_question_1 = create(:step_question, step: @quiz_with_points, score: 50)

      @chapter_2 = create(:chapter, course: @course)
      @video_2 = create(:step, step_type: 'Vídeo', chapter: @chapter_2) # 20 ENV['DEFAULT_STEP_POINTS']

      @user = create(:user)
      @user.init_step(@video) # 20
      @user.init_step(@quiz_without_points_1) # 20
      @user.init_step(@quiz_with_points) # 50

      @user.init_step(@video_2) # 20
    end

    it "returns points for course" do
      expect(@user.get_points_for(@course)).to be(110)
    end

    it "returns points for chapter 1" do
      expect(@user.get_points_for(@chapter)).to be(90)
    end

    it "returns points for chapter 2" do
      expect(@user.get_points_for(@chapter_2)).to be(20)
    end
  end

  describe "moip attirbutes" do
    attributes = {
      email: "contato@manoelneto.com",
      cpf: "12341242412",
      name: "Manoel Quirino Neto",
      birthdate: Date.parse("27/02/1992"),
      phone: "(83) 98828-1140"
    }

    before do
      user = create(:user, attributes)
      @moip_attributes = user.moip_attributes
    end

    it "retrieves email" do
      expect(@moip_attributes[:email]).to eq("contato@manoelneto.com")
    end

    it "retrieves cpf" do
      expect(@moip_attributes[:cpf]).to eq("12341242412")
    end

    it "retrieves fullname" do
      expect(@moip_attributes[:fullname]).to eq("Manoel Quirino Neto")
    end

    it "retrieves birthdate_day" do
      expect(@moip_attributes[:birthdate_day]).to eq(27)
    end

    it "retrieves birthdate_month" do
      expect(@moip_attributes[:birthdate_month]).to eq(02)
    end

    it "retrieves birthdate_year" do
      expect(@moip_attributes[:birthdate_year]).to eq(1992)
    end

    it "retrieves phone_area_code" do
      expect(@moip_attributes[:phone_area_code]).to eq("83")
    end

    it "retrieves phone_number" do
      expect(@moip_attributes[:phone_number]).to eq("988281140")
    end
  end

  describe "course" do
    before do
      @user = create(:user)
      @user2 = create(:user)

      @course1 = create(:course)
      @chapter1_course1 = create(:chapter, course: @course1)
      @chapter2_course1 = create(:chapter, course: @course1)

      @step1_chapter1_course1 = create(:step, chapter: @chapter1_course1)
      @step2_chapter1_course1 = create(:step, chapter: @chapter1_course1)

      @step1_chapter2_course1 = create(:step, chapter: @chapter2_course1)
      @step2_chapter2_course1 = create(:step, chapter: @chapter2_course1)

      @course2 = create(:course)
      @chapter1_course2 = create(:chapter, course: @course2)
      @chapter2_course2 = create(:chapter, course: @course2)

      @step1_chapter1_course2 = create(:step, chapter: @chapter1_course2)
      @step2_chapter1_course2 = create(:step, chapter: @chapter1_course2)

      @step1_chapter2_course2 = create(:step, chapter: @chapter2_course2)
      @step2_chapter2_course2 = create(:step, chapter: @chapter2_course2)

    end

    context "initializeds" do
      before do
        @user_step = create(:user_step, user: @user, step: @step1_chapter1_course1)
      end

      it "has initialized course" do
        expect(@user.initialized_course?(@course1)).to be_truthy
      end

      it "has initialized chapter" do
        expect(@user.initialized_chapter?(@chapter1_course1)).to be_truthy
      end

      it "has initialized step" do
        expect(@user.initialized_step?(@step1_chapter1_course1)).to be_truthy
      end
    end

    context "not initializeds" do
      before do
        @user_step = create(:user_step, user: @user, step: @step1_chapter1_course2)
      end

      it "has not initialized course" do
        expect(@user.initialized_course?(@course1)).to be_falsey
      end

      it "has not initialized chapter" do
        expect(@user.initialized_chapter?(@chapter1_course1)).to be_falsey
      end

      it "has not initialized step" do
        expect(@user.initialized_step?(@step1_chapter1_course1)).to be_falsey
      end
    end

    describe "init step" do
      before do
        @user.init_step(@step1_chapter1_course1)
      end

      it "has step" do
        expect(@user.initialized_step?(@step1_chapter1_course1)).to be_truthy
      end

      it "has chapter" do
        expect(@user.initialized_chapter?(@chapter1_course1)).to be_truthy
      end

      it "has course" do
        expect(@user.initialized_course?(@course1)).to be_truthy
      end
    end

    describe "completeds" do
      before do
        @user.init_step(@step1_chapter1_course1)
        @user.init_step(@step2_chapter1_course1)
        @user.init_step(@step1_chapter2_course1)

        @user2.init_step(@step1_chapter1_course2)
        @user2.init_step(@step2_chapter1_course2)
        @user2.init_step(@step1_chapter2_course2)
        @user2.init_step(@step2_chapter2_course2)
      end

      it "returns chapters completeds" do
        expect(@user.chapters_completeds).to match_array([@chapter1_course1])
      end

      it "has completed chapter" do
        expect(@user.completed_chapter?(@chapter1_course1)).to be_truthy
      end

      it "has not completed chapter" do
        expect(@user.completed_chapter?(@chapter2_course1)).to be_falsey
      end

      it "returns chapters completeds for a course" do
        expect(@user.chapters_completeds_from_course(@course1)).to match_array([@chapter1_course1])
      end

      it "returns steps completeds for chapter" do
        expect(@user.steps_completeds_from_chapter(@chapter2_course1)).to match_array([@step1_chapter2_course1])
      end
    end

    describe "percentages" do
      before do
        @course_with_no_step = create(:course)

        @user.init_step(@step1_chapter1_course1)
        @user.init_step(@step2_chapter1_course1)
        @user.init_step(@step1_chapter2_course1)

        @user2.init_step(@step1_chapter1_course2)
        @user2.init_step(@step2_chapter1_course2)
        @user2.init_step(@step1_chapter2_course2)
        @user2.init_step(@step2_chapter2_course2)
      end

      describe "course" do
        it "gets partial percentages" do
          expect(@user.get_percentage_for_course(@course1)).to eq(0.75)
        end

        it "gets full percentage" do
          expect(@user2.get_percentage_for_course(@course2)).to eq(1)
        end
      end

      describe "chapter" do
        it "gets partial percentages" do
          expect(@user.get_percentage_for_chapter(@chapter1_course1)).to eq(1)
        end

        it "gets full percentage" do
          expect(@user.get_percentage_for_chapter(@chapter2_course1)).to eq(0.5)
        end
      end

      describe "with no step" do
        it "returns 0" do
          expect(@user.get_percentage_for_course(@course_with_no_step)).to eq(0)
        end
      end

    end

    describe "finished" do
      before do
        @user2.init_step(@step1_chapter1_course2)
        @user2.init_step(@step2_chapter1_course2)
        @user2.init_step(@step1_chapter2_course2)
        @user2.init_step(@step2_chapter2_course2)
      end

      it "has finished course" do
        expect(@user2.finished_course?(@course2)).to be_truthy
      end
    end
  end

  context "find_for_omniauth" do
    context "identity has user" do
      before do
        @user = create(:user)
        @identity = create(:identity, user: @user)
        allow(Identity).to receive(:find_for_oauth).and_return(@identity)
      end

      context "same user is logged" do
        it "returns same user" do
          OmniAuth.config.test_mode = true
          auth_mock = OmniAuth::AuthHash.new({
            :provider => 'facebook',
            :info => {}
          })
          expect(User.find_for_oauth(auth_mock, @user)).to eq(@user)
        end
      end

      context "other user is logged" do
        before do
          @current_user = create(:user)
        end

        it "returns has_other_user_associated" do
          expect(User.find_for_oauth({}, @current_user)).to eq({
            identity: @identity,
            error_type: 'has_other_user_associated'
          })
        end
      end

      context "no user is logged" do
        it "returns an user" do
          OmniAuth.config.test_mode = true
          auth_mock = OmniAuth::AuthHash.new({
            :provider => 'facebook',
            :info => {}
          })
          expect(User.find_for_oauth(auth_mock)).to be_kind_of(User)
        end
      end
    end

    context "identity has no user" do
      before do
        @identity = create(:identity)
        allow(Identity).to receive(:find_for_oauth).and_return(@identity)
      end

      context "user is logged" do
        before do
          @current_user = create(:user)
        end

        it "returns same user" do
          OmniAuth.config.test_mode = true
          auth_mock = OmniAuth::AuthHash.new({
            :provider => 'facebook',
            :info => {}
          })
          expect(User.find_for_oauth(auth_mock, @current_user)).to eq(@current_user)
        end
      end

      context "no user is logged" do
        it "returns an user" do
          OmniAuth.config.test_mode = true
          auth_mock = OmniAuth::AuthHash.new({
            :provider => 'facebook',
            :info => {},
            :extra => {
              :raw_info => {
                name: FFaker::Name.name,
                email: FFaker::Internet.name
              }
            }
          })

          expect(User.find_for_oauth(auth_mock)).to be_kind_of(User)
        end
      end

    end
  end

  context "abilities" do
    subject(:ability){
      Ability.new(user)
    }

    let(:other_user) { create(:user) }

    context "when normal" do
      it_behaves_like "normal user" do
        let(:user) {create(:user)}
      end
    end

    context "when admin" do
      it_behaves_like "admin user" do
        let(:user) {create(:user, admin: true)}
      end
    end

    context "when can_manage_all_domains" do
      let(:user) {create(:user, can_manage_all_domains: true)}

      it { is_expected.to be_able_to(:manage_all_domains, user) }
    end

    context "when not can_manage_all_domains" do
      let(:user) {create(:user, can_manage_all_domains: false)}

      it { is_expected.not_to be_able_to(:manage_all_domains, user) }
    end

  end

  context ".generate_sum_points" do
    let(:user) {
      create(:user)
    }

    before do
      create(:point, value: -10, user: user)
      create(:point, value: 20, user: user)
    end

    it "generates sum_points" do
      user.generate_sum_points
      user.reload
      expect(user.sum_points).to eql(10)
    end
  end

  describe "badge methods" do
    let(:badge_type) { 'simple' }
    let(:user) { create(:user) }
    let!(:badge) {
      create(:badge, badge_type: badge_type)
    }

    let(:campaign) {
      campaign = create(:campaign)
      campaign.campaign_badges.create!(badge: badge)
      campaign
    }

    describe '#add_badge' do
      context "simple badge and with never used" do

        it "assigns badge" do
          expect {
            user.add_badge(badge)
          }.to change {
            user.badge_users.count
          }.from(0).to(1)
        end
      end

      context "with simple badge and already used" do

        before do
          user.add_badge badge
        end

        it "not assigns badge" do
          expect {
            user.add_badge(badge)
          }.not_to change {
            user.badge_users.count
          }
        end
      end

      context "with reusable badge and never used" do
        let(:badge_type) {
          'reusable'
        }

        it "assigns badge" do
          expect {
            user.add_badge(badge)
          }.to change {
            user.badge_users.count
          }.from(0).to(1)
        end
      end

      context "with reusable badge and already used" do
        let(:badge_type) {
          'reusable'
        }

        before do
          user.add_badge badge
        end

        it "change badge count" do
          expect {
            user.add_badge(badge)
          }.to change {
            user.badge_users.first.quantity
          }.from(1).to(2)
        end
      end

      context "with campaign" do
        it "add campaign" do
          campaign
          expect {
            user.add_badge(badge)
          }.to change {
            user.has_complete_campaign campaign
          }.from(false).to(true)
        end
      end

    end

    context "remove_badge" do

      context "with no badge" do
        it "not removes" do
          expect {
            user.remove_badge(badge)
          }.not_to change {
            user.badge_users.count
          }
        end

      end

      context "with badge" do
        before do
          user.add_badge(badge)
        end

        it "should remove badge" do
          expect {
            user.remove_badge(badge)
          }.to change {
            user.badge_users.count
          }.from(1).to(0)
        end

      end

      context "with campaign" do
        it "should remove campaign" do
          campaign
          user.add_badge(badge)

          expect {
            user.remove_badge(badge)
          }.to change {
            user.has_complete_campaign campaign
          }.from(true).to(false)
        end
      end

      context "with reusable badge" do
        let!(:badge_type) { "reusable" }

        context "with no badge" do
          it "not removes" do
            expect {
              user.remove_badge(badge)
            }.not_to change {
              user.badge_users.count
            }
          end

        end

        context "with badge applied once" do
          before do
            user.add_badge(badge)
          end

          it "should remove badge" do
            expect {
              user.remove_badge(badge)
            }.to change {
              user.badge_users.count
            }.from(1).to(0)
          end
        end

        context "with badge applied more than once" do
          before do
            user.add_badge(badge)
            user.add_badge(badge)
          end

          it "should not remove badge_user" do
            expect {
              user.remove_badge(badge)
            }.not_to change {
              user.badge_users.count
            }
          end

          it "should decrement badge_user quantity" do
            expect {
              user.remove_badge(badge)
            }.to change {
              user.badge_users.first.quantity
            }.from(2).to(1)
          end
        end

        context "with campaign" do

          before do
            campaign
          end

          it "should remove campaign" do
            user.add_badge(badge)

            expect {
              user.remove_badge(badge)
            }.to change {
              user.has_complete_campaign campaign
            }.from(true).to(false)
          end

          context "with badge applied more than once" do

            it "should not remove campaign" do
              user.add_badge(badge)
              user.add_badge(badge)

              expect {
                user.remove_badge(badge)
              }.not_to change {
                user.has_complete_campaign campaign
              }
            end
          end

        end
      end
    end
  end

  if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
    describe "create_membership!" do
      subject { user.create_membership! domain }
      let!(:user) { create(:user) }

      context "when a domain isn`t only invited" do
        let!(:domain) { create(:domain, {only_invited: false}) }

        it "created membership" do
          expect {
            subject
          }.to change(Membership, :count).by(1)
        end
      end

      context "when a domain is only invited" do
        let!(:domain) { create(:domain, {only_invited: true}) }

        context "when a user was invited and status is pending" do
          before do
            create(:invite, {email: user.email, status: :pending})
          end

          it "created membership" do
            expect {
              subject
            }.to change(Membership, :count).by(1)
          end
        end

        context "when a user was invited and status is created" do
          before do
            create(:invite, {email: user.email, status: :created})
          end

          it "created membership" do
            expect {
              subject
            }.to change(Membership, :count).by(1)
          end
        end

        context "when a user was invited and status is denied" do
          before do
            create(:invite, {email: user.email, status: :denied})
          end

          it "created membership" do
            expect {
              subject
            }.not_to change(Membership, :count)
          end
        end

        context "when a user wasn`t invited" do
          it "created membership" do
            expect {
              subject
            }.not_to change(Membership, :count)
          end
        end

      end
    end
  end

  # describe "#ranking" do
  #   before do
  #     @user1 = create(:user)
  #     @user2 = create(:user)

  #     @user1_point1 = create(:point, user: @user1, value: 50, created_at: 1.month.ago + 1.second)
  #     @user1_point2 = create(:point, user: @user1, value: 50)

  #     @user2_point1 = create(:point, user: @user2, value: 40)
  #     @user2_point1 = create(:point, user: @user2, value: 50, created_at: 7.days.ago)
  #   end

  #   context "with last 24 hours" do
  #     let(:range_str) { 'last_24_hours' }

  #     it "retrieves user ordered by points in period" do
  #       expect(described_class.ranking(range_str)[0]).to eq(@user1)
  #       expect(described_class.ranking(range_str)[1]).to eq(@user2)
  #     end
  #   end
  # end

end
