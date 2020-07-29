class TagDecorator < Draper::Decorator
  delegate_all

  def question_select
    I18n.t "tags.#{self.object.name}.question_select"
  end
end

