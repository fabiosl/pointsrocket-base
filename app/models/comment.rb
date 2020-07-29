# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  parent_id        :integer
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  commentable_id   :integer
#  commentable_type :string(255)
#

class Comment < ActiveRecord::Base
  include MentionableContent
  include AdminNotifiable

  belongs_to :parent, class_name: "Comment", inverse_of: :children
  belongs_to :user, inverse_of: :comments
  belongs_to :commentable, polymorphic: true
  has_many :children, class_name: "Comment", foreign_key: :parent_id, inverse_of: :parent

  validates_presence_of :user

  after_create :broadcast_create
  after_destroy :destroy_notifications

  self.per_page = 3

  def destroy_notifications
    Notification.where(notifiable: self).destroy_all
  end

  def notify(action)
    commentable.notify_comment(self, user, action) if commentable.respond_to? :notify_comment
  end

  def broadcast_create
    data = Rabl::Renderer.new(
      'api/base/_item',
      self,
      { :view_path => 'app/views' }
    ).render
    p "emit comment_create event - #{data}"
    parsed_data = JSON.parse(data)
    EmitClient.new('comment_create', nil, parsed_data).emit
  end
end
