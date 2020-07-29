class QuestionDecorator < Draper::Decorator
  delegate_all
  decorates_association :answers

  include Rails.application.routes.url_helpers

  def answers_quantity
    if object.answers.any?
      h.pluralize(object.answers.count, "resposta", "respostas")
    else
      "Nenhuma resposta até o momento"
    end
  end

  def formatted_date
    "em #{object.created_at.strftime("%d/%m/%Y")}"
  end

  def tag_link(content, course = nil, filter = nil, tag = nil)
    h.link_to(content, forum_path(course: course,
      filter: filter, tag: tag), class: "btn btn-sm btn-default", alt: content)
  end

  def user_points
    "#{object.user.points} pontos"
  end

  def upvote_class(user)
    result = "vote-question vote-button btn btn-outline mb5 ico-arrow-up2"

    if object.user == user
      result += " disabled disabled-vote-button"
    else
      result += " btn-success"
      result += " voted" if object.upvotes(user).any?
    end

    result
  end

  def downvote_class(user)
    result = "vote-question vote-button btn btn-outline mb5 ico-arrow-down2"

    if object.user == user
      result += " disabled disabled-vote-button"
    else
      result += " btn-danger"
      result += " voted" if object.downvotes(user).any?
    end

    result
  end
end
