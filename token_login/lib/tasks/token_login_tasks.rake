namespace :token_login do
  desc "Generate url for login with"
  task :generate, [:email] => :environment do |t, args|
    if not args.email
      abort "You must provide an email"
    end


    Apartment.tenant_names.select do |tenant|
      tenant.present? and tenant != 'public'
    end.each do |tenant|
      Apartment::Tenant.switch(tenant) do
        token = Token.create_for email: args.email
        domain = Domain.find_by subdomain: tenant

        if token
          ap "#{domain.get_url}/token-login?key=#{token.key}"
        else
          ap "token could not be created, check if email is correct."
        end
      end

    end

  end
end

