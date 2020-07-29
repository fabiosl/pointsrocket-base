class DeliverEmployeeMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options :queue => :default, :retry => true, backtrace: true

  def perform user_id, employee_advocacy_post_id, tenant
    Apartment::Tenant.switch(tenant) do
      domain = Domain.find_by subdomain: tenant
      user = User.find user_id
      employee_advocacy_post = EmployeeAdvocacyPost.find employee_advocacy_post_id
      EmployeeAdvocacyMailer.new_post_email(user, employee_advocacy_post, domain).deliver if user.subscribe
    end
  end

end
