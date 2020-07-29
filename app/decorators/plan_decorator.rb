class PlanDecorator < Draper::Decorator
  delegate_all

  def formatted_name
    final = []
    if object.duration > 1
      final << "#{object.duration} x #{object.price}"
    else
      final << "#{object.price}"
    end

    if object.trial_days.present? and object.trial_days > 0
      final << "com #{object.trial_days} dias de teste"
    end

    "#{object.name} (#{final.join(' ')})"
  end

  def formatted_voucher_name voucher
    voucher = voucher.decorate
    final = []
    if object.duration > 1
      final << "#{object.duration} x #{voucher.formatted_price}"
    else
      final << "#{voucher.formatted_price}"
    end

    if object.trial_days.present? and object.trial_days > 0
      final << "com #{object.trial_days} dias de teste"
    end

    "#{object.name} Especial (#{final.join(' ')})"
  end
end
