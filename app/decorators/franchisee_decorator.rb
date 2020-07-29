class FranchiseeDecorator < Draper::Decorator
  delegate_all

  def formatted_description
    name = object.name

    "#{formatted_price} por mês oferecidos pelo (a) #{name} (código: #{object.token})"
  end

  def formatted_plan
    formatted_description
  end

  def formatted_price
    h.number_to_currency(4990 / 100)
  end
end
