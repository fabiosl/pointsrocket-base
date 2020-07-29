class StepQuestionDecorator < Draper::Decorator
  delegate_all

  def formatted_title
    "Questão \##{object.position}"
  end

  def trigger_class user
    if object.answered_correctly_by_user?(user)
      return 'done'
    end

    return ''
  end
end
