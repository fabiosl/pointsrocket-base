class AnswerDecorator < Draper::Decorator
  delegate_all

  def formatted_date
    object.created_at.strftime("%d/%m/%Y")
  end

  def upvote_class(user)
    result = "vote-answer upvote vote-button btn btn-outline mb5 ico-arrow-up2"

    if object.user == user
      result += " disabled disabled-vote-button"
    else
      result += " btn-success"
      result += " voted" if object.upvotes(user).any?
    end

    result
  end

  def downvote_class(user)
    result = "vote-answer upvote vote-button btn btn-outline mb5 ico-arrow-down2"

    if object.user == user
      result += " disabled disabled-vote-button"
    else
      result += " btn-danger"
      result += " voted" if object.downvotes(user).any?
    end

    result
  end
end
