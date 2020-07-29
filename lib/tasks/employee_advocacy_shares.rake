namespace :employee_advocacy_shares do

  desc 'index employee advocacy share post json'
  task :index_post_json => :environment do
    Apartment.tenant_names.select(&:present?).each do |tenant|
      Apartment::Tenant.switch(tenant) do
        EmployeeAdvocacyShare.all.each do |eas|
          eas.save
        end
      end
    end
  end

end
