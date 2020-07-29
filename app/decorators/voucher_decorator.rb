class VoucherDecorator < Draper::Decorator
  delegate_all

  def formatted_description
    # 20,00 por mes no plano mensal
    plan_name = object.plan.name

    "#{formatted_price} por mês no plano #{plan_name} (código: #{object.code})"
  end

  def formatted_price
    h.number_to_currency(object.price.to_f / 100)
  end
end
