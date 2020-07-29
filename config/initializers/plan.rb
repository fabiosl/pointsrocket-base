begin
  if not Rails.env == 'test'
    Plan.where(moip_code: 'anual').first_or_create do |plan|
      plan.name = 'Anual'
      plan.duration = 12
      plan.price = "70"
    end
  end
rescue Exception => e

end
