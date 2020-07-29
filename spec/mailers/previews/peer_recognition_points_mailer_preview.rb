# Preview all emails at http://localhost:3000/rails/mailers/peer_recognition_points_mailer
class PeerRecognitionPointsMailerPreview < ActionMailer::Preview
  def new_peer_recognition_points_email
    user = User.first
    domain = Domain.get_current_domain

    PeerRecognitionPointsMailer.new_peer_recognition_points_email(domain, user)
  end

  def expiration_peer_recognition_points_email
    user = User.first
    domain = Domain.get_current_domain

    PeerRecognitionPointsMailer.expiration_peer_recognition_points_email(domain, user)
  end
end
