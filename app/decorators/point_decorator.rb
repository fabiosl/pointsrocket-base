class PointDecorator < Draper::Decorator
  delegate_all
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  def formated_title

    if object.pointable.nil? and not object.pointable_type.nil?
      phrase = [I18n.t('decorators.points.won_points_in')]

      case object.pointable_type
      when "Trivias::Answer"
        phrase << I18n.t('decorators.points.an_answer_destroyed')
      when "EmployeeAdvocacyShare"
        phrase << I18n.t('decorators.points.a_share_destroyed')
      when "ChallengeUser"
        phrase << I18n.t('decorators.points.a_challenge_destroyed')
      when "EmployeeAdvocacyVisit"
        phrase << I18n.t('decorators.points.a_visit_destroyed')
      when "Badge"
        phrase << I18n.t('decorators.points.a_medal_destroyed')
      when "Step"
        phrase << I18n.t('decorators.points.a_class_destroyed')
      when "StepQuestion"
        phrase << I18n.t('decorators.points.a_question_destroyed')
      when "Broadcast"
        phrase << I18n.t('decorators.points.a_broadcast_destroyed')
      when "CampaignUser"
        phrase << I18n.t('decorators.points.a_campaign_user_destroyed')
      when "CoinUser"
        phrase << I18n.t('decorators.points.a_coin_user_destroyed')
      else
        phrase = [I18n.t('decorators.points.unknown')]
      end

      return "#{phrase.join(" ")}."
    end

    if object.pointable.is_a? Trivias::Answer
      if object.pointable.question.present?
        return "#{I18n.t('decorators.points.answered_question')} <b>#{object.pointable.question.name}</b>"
      else
        return I18n.t('decorators.points.answered_question')
      end
    end

    if object.pointable.is_a? CoinUser
      sender = link_to(object.pointable.sender.name, user_path(object.pointable.sender))
      count = object.pointable.points
      return I18n.t('decorators.points.coin_user.user_gave_to_you', {count: count, sender: sender})
    end

    if object.pointable.is_a? CampaignUser
      if object.pointable.campaign.present?
        return I18n.t('decorators.points.campaign_user_redeemed', campaigns_link: link_to(object.pointable.campaign.title, campaigns_path))
      else
        return I18n.t('decorators.points.campaign_user_redeemed_no_challenge')
      end
    end

    if object.pointable.is_a? EmployeeAdvocacyShare
      if object.pointable.employee_advocacy_post.present?
        if object.pointable.social_network == 'download'
          return "#{I18n.t('decorators.points.downloaded_post_html', {title: "<a href='#{employee_advocacy_path}'>#{object.pointable.employee_advocacy_post.title}</a>", network: object.pointable.social_network.titleize})}"
        else
          return "#{I18n.t('decorators.points.shared_post_html', {title: "<a href='#{employee_advocacy_path}'>#{object.pointable.employee_advocacy_post.title}</a>", network: object.pointable.social_network.titleize})}"
        end
      else
        return I18n.t('decorators.points.shared_post')
      end
    end

    if object.pointable.is_a? HashtagChallengeUser
      if object.pointable.hashtag_challenge.present?
        return I18n.t 'decorators.points.challenge_hashtag_submission', social_network: object.pointable.decorate.get_social_network, post: link_to( "post", object.pointable.decorate.get_post_url, target: "_blank" ) , challenge_link: link_to(object.pointable.hashtag_challenge.title, hashtag_challenge_path(object.pointable.hashtag_challenge))
      else
        return I18n.t('decorators.points.challenge_submission')
      end
    end

    if object.pointable.is_a? ChallengeUser
      if object.pointable.challenge.present?
        return "#{I18n.t('decorators.points.challenge_submission')} <a href='#{challenge_path(object.pointable.challenge)}'>#{object.pointable.challenge.title}</a> foi aprovada"
      else
        return I18n.t('decorators.points.challenge_submission')
      end
    end

    if object.pointable.is_a? EmployeeAdvocacyVisit
      if object.pointable.employee_advocacy_share.present? and object.pointable.employee_advocacy_share.employee_advocacy_post.present?
        return "#{I18n.t('decorators.points.share_visits')} <a href='#{employee_advocacy_path}'>#{object.pointable.employee_advocacy_share.employee_advocacy_post.title}</a> no #{object.pointable.employee_advocacy_share.social_network.titleize}"
      else
        return I18n.t('decorators.points.share_visits')
      end
    end

    if object.pointable.is_a? Badge
      badge = object.pointable
      return "#{I18n.t('decorators.points.earned')} " +
        "<a href='#{badges_path}'> #{object.pointable.name} </a>"
    end

    if object.pointable.is_a? Step
      if object.pointable.step_type == 'Vídeo'
        step = object.pointable
        if step.chapter.present? and step.chapter.course.present?
          return "#{I18n.t('decorators.points.watched_video')} " +
            "<a href='#{course_chapter_step_path(step.chapter.course.slug, step.chapter.slug, step.position)}'> #{object.pointable.name} </a>"
        else
          return "#{I18n.t('decorators.points.watched_video')} #{step.name}"
        end
      end
    end

    if object.pointable.is_a? StepQuestion
      step = object.pointable.step

      if step and step.chapter.present? and step.chapter.course.present?
        return "#{I18n.t('decorators.points.answered_question')} " +
          "<a href='#{course_chapter_step_path(step.chapter.course.slug, step.chapter.slug, step.position)}'>#{object.pointable.question}</a>"
      else
        return "#{I18n.t('decorators.points.answered_question')} #{object.pointable.question}"
      end

    end

    if object.pointable.is_a? Vote
      if object.pointable.voteable.is_a? Question
        question = object.pointable.voteable

        if object.pointable.upvote?
          return "#{I18n.t('decorators.points.got_plus_one_question')} " +
            "<a href='#{question_path(question)}'>#{question.title}</a>"
        end

        if object.pointable.downvote?
          return "#{I18n.t('decorators.points.got_minus_one_question')} " +
            "<a href='#{question_path(question)}'>#{question.title}</a>"
        end
      end

      if object.pointable.voteable.is_a? Answer
        answer = object.pointable.voteable

        if object.pointable.upvote?
          return "#{I18n.t('decorators.points.got_plus_one_answer')} " +
            "<a href='#{question_path(answer.question)}'>#{answer.content}</a>"
        end

        if object.pointable.downvote?
          return "#{I18n.t('decorators.points.got_minus_one_answer')} " +
            "<a href='#{question_path(answer.question)}'>#{answer.content}</a>"
        end
      end

    end

    if object.pointable.is_a? Broadcast
      broadcast = object.pointable
      return "#{I18n.t('decorators.points.watched_broadcast')} <a href='#{broadcast_path(broadcast)}'>#{broadcast.title}</a>"
    end

    return I18n.t('decorators.points.unknown')
  end

end
