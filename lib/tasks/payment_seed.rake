namespace :payment_seed do

  desc 'Seed payment with some data'
  task :seed => :environment do
    user = User.where(email: 'contato@manoelneto.com').first
    plan = Plan.where(moip_code: 'anual').first

    if user.subscriptions.any?
      subscription = user.subscriptions.first
    else
      subscription = Subscription.create!({
        moip_code: 123123,
        status: 'active',
        remote_creation_date: Time.now,
        amount: 3990,
        plan: plan,
        next_invoice_date: 1.month.from_now,
        trial_start_time: 7.days.ago,
        trial_end_time: Time.now,
        user: user
      })
    end

    (0..2).each do |i|
      subscription.invoices.create!({
        amount: subscription.amount,
        creditation_date: i.months.ago,
        moip_code: 12341234,
        status: 3,
        subscription_code: subscription.moip_code,
        ocurrence: 1,
        customer_code: user.moip_code,
        customer_fullname: user.name,
      })
    end

  end

end
