# == Schema Information
#
# Table name: coin_users
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  points       :integer          default(0)
#  created_at   :datetime
#  updated_at   :datetime
#  content      :text
#  coin_give_id :integer
#  hashtags     :text             default([]), is an Array
#

class CoinUser < ActiveRecord::Base
  include Notifiable

  act_as_timelineable type: :user

  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'

  belongs_to :coin_give

  after_save :add_points
  after_create :notify_user_email

  def notify_user_email
    CoinUserMailWorker.perform_async(Apartment::Tenant.current, id)
  end

  def self.most_pointed_users
    group('recipient_id')
      .order("sum_points desc")
      .sum('points')
      .take(3)
      .map do |id, total_points|
      {
        user: User.find(id),
        total_points: total_points
      }
    end
  end

  #CoinUser.where("'éPraTestar' = ANY (hashtags)")
  def self.most_recognized_by_hashtags filter_hashtag, date_start=nil, date_end=nil
    query = group(:recipient_id)
    query = filter_by_date_range(date_start, date_end, query)

    if filter_hashtag != "all"
      query
        .where("'#{filter_hashtag.strip}' = ANY (hashtags)")
        .order('sum_points desc')
        .limit(5)
        .sum(:points)
        .map do |id, total_points| 
          {
            user: User.find(id),
            total_points: total_points
          }
        end
    else
      query
        .order('sum_points desc')
        .limit(5)
        .sum(:points)
        .map do |id, total_points| 
          {
            user: User.find(id),
            total_points: total_points
          }
        end
    end
  end

  def self.top_hashtags date_start=nil, date_end=nil
    query = filter_by_date_range(date_start, date_end)
    top_hashtags = current_domain.peer_recognition_hashtags.split(",").map do |hashtag|
      {
        hashtag: hashtag.strip,
        count: query.where("'#{hashtag.strip}' = ANY (hashtags)").count()
      }
    end
    top_hashtags.sort_by { |item| -item[:count] }
  end

  def self.filter_by_date_range date_start=nil, date_end=nil, records=nil
    query = records ? records : CoinUser.all
    if date_start and date_start != ''
      date_s = DateTime.parse(date_start).strftime("%Y-%m-%d 00:00:00")
      query = query.where('created_at >= ?', date_s)
    end
    if date_end and date_end != ''
      date_e = DateTime.parse(date_end).strftime("%Y-%m-%d 23:59:59")
      query = query.where('created_at <= ?', date_e)
    end
    query
  end

  private

  def add_points
    return if sender.id == recipient.id
    sender.remove_coins(points)
    recipient._add_points(pointable: self, value: points)
  end

  def notification_recipient
    recipient
  end
end
