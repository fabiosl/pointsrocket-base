json.array!(@notifications) do |notification|
  json.extract! notification, :id, :message

  json.is_read !!notification.notification_reads_id
  json.time distance_of_time_in_words_to_now(notification.created_at)
  json.url notification.link if notification.link.present?

  if notification.to_all
    json.icon "ico-notification bgcolor-info"
  elsif notification.notificable_type == 'Answer'
    json.icon "ico-comment bgcolor-warning"
  else
    json.icon nil
  end
end
