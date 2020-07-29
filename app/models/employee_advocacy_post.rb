# == Schema Information
#
# Table name: employee_advocacy_posts
#
#  id               :integer          not null, primary key
#  active           :boolean
#  facebook_points  :integer
#  twitter_points   :integer
#  linkedin_points  :integer
#  title            :string(10000)
#  content          :text
#  url              :string(255)
#  image            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#  folder           :string(255)
#  valid_until      :datetime
#  instagram_points :integer          default(0)
#  video            :string(255)
#  download_points  :integer          default(0)
#

class EmployeeAdvocacyPost < ActiveRecord::Base

  validates_presence_of *[:facebook_points, :twitter_points, :linkedin_points, :instagram_points,
    :title]

  belongs_to :user
  has_many :employee_advocacy_shares, inverse_of: :employee_advocacy_post
  mount_uploader :image, ImageUploader
  mount_uploader :video, VideoUploader

  scope :top_performing_posts, -> { order('created_at desc').limit(5) }
  scope :worst_performing_posts, -> { order('created_at asc').limit(5) }
  act_as_searchable
  act_as_timelineable type: :user

  before_destroy :destroy_shares_timeline_items

  [:video, :image].each do |item|

    class_eval %Q{
      after_save :before_save_remove_#{item}

      def before_save_remove_#{item}
        if self.remove_#{item}
          self.#{item} = nil
        end
      end
    }
  end
  def remove_item
  end

  def people_shared_info first_user_to_show=nil
    count = employee_advocacy_shares.group(:user_id).count().size
    first_two = employee_advocacy_shares.select(
      'distinct on (user_id) *'
    ).limit(2)

    {
      first_two: first_two,
      resting_count: [count - 2, 0].max,
      count: count
    }
  end

  def done_by_user?(user)
    employee_advocacy_shares.where(user: user).any?
  end

  def total_points
    facebook_points + twitter_points + linkedin_points
  end

  def expired?
    valid_until.present? && Time.now > valid_until
  end

  alias_method :expired, :expired?

  def expires_in_text
    if valid_until
      I18n.t("models.employee_advocacy_posts.expires_in", expires_in: I18n.l(valid_until, format: :chart_label))
    end
  end

  private

  def destroy_shares_timeline_items
    employee_advocacy_shares.includes(:timeline_items).each do |share|
      share.timeline_items.destroy_all
    end
    return true
  end
end
