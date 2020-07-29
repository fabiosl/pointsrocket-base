# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  content      :text
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  notify_users :boolean          default(FALSE)
#

class Post < ActiveRecord::Base
  include NotifiableComment
  include MentionableContent

  validate :must_not_be_only_url

  act_as_timelineable type: :admin
  belongs_to :user

  has_many :views, class_name: 'PostView'
  has_many :viewers, through: :views, source: :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :content
  act_as_searchable

  def must_not_be_only_url
    post_without_tags_and_trined = "http://#{ActionView::Base.full_sanitizer.sanitize(self.content).strip}"

    match_data = URI::regexp.match(post_without_tags_and_trined)
    if match_data and match_data[0] == post_without_tags_and_trined
      errors.add(:content, I18n.t("validators.post.should_no_contains_only_url_html"))
    end
  end

  def notify
    return unless notify_users
    notify_members
    mail_domain
  end

  private

  def mail_domain
    domain = Domain.find_by(subdomain: Apartment::Tenant.current)
    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
      User.all.each do |user|
        PostMailWorker.perform_async(domain.id, user.id, id)
      end
    else
      User.domain(domain).each do |user|
        PostMailWorker.perform_async(domain.id, user.id, id)
      end
    end
  end

  def notify_members
    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
      User.exclude(user).each do |user_item|
        create_notification(user_item, user, 'create', self)
      end
    else
      User.domain(domain).exclude(user).each do |user_item|
        create_notification(user_item, user, 'create', self)
      end
    end
  end

  # como ele inclui MentionableContent, não precisa disso aqui, o da
  # MentionableContent sobrescreve esse método
  def create_notification(recipient, actor, action, notifiable)
    Notification.create!(
      recipient: recipient,
      actor: actor,
      action: action,
      notifiable: notifiable
    )
  end

  def domain
    Domain.find_by(subdomain: Apartment::Tenant.current)
  end
end
