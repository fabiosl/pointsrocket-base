# You can have Apartment route to the appropriate Tenant by adding some Rack middleware.
# Apartment can support many different "Elevators" that can take care of this routing to your data.
# Require whichever Elevator you're using below or none if you have a custom one.
#
# require 'apartment/elevators/generic'
# require 'apartment/elevators/domain'
require 'apartment/elevators/subdomain'
require 'apartment/elevators/first_subdomain'

#
# Apartment Configuration
#
Apartment.configure do |config|

  # Add any models that you do not want to be multi-tenanted, but remain in the global (public) namespace.
  # A typical example would be a Customer or Tenant model that stores each Tenant's information.
  #
  if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
    config.excluded_models = %w{ Domain Oauth2Info }
  else
    config.excluded_models = %w{ User BlockUser Device CompleteAccountQuestion CompleteAccountQuestionOption CompleteAccountQuestionOptionUser Domain Membership CommunityInvite Identity Oauth2Info }
  end

  # In order to migrate all of your Tenants you need to provide a list of Tenant names to Apartment.
  # You can make this dynamic by providing a Proc object to be called on migrations.
  # This object should yield either:
  # - an array of strings representing each Tenant name.
  # - a hash which keys are tenant names, and values custom db config (must contain all key/values required in database.yml)
  #
  # config.tenant_names = lambda{ Customer.pluck(:tenant_name) }
  # config.tenant_names = ['tenant1', 'tenant2']
  # config.tenant_names = {
  #   'tenant1' => {
  #     adapter: 'postgresql',
  #     host: 'some_server',
  #     port: 5555,
  #     database: 'postgres' # this is not the name of the tenant's db
  #                          # but the name of the database to connect to before creating the tenant's db
  #                          # mandatory in postgresql
  #   },
  #   'tenant2' => {
  #     adapter:  'postgresql',
  #     database: 'postgres' # this is not the name of the tenant's db
  #                          # but the name of the database to connect to before creating the tenant's db
  #                          # mandatory in postgresql
  #   }
  # }
  # config.tenant_names = lambda do
  #   Tenant.all.each_with_object({}) do |tenant, hash|
  #     hash[tenant.name] = tenant.db_configuration
  #   end
  # end
  #
  config.tenant_names = lambda { Domain.pluck :subdomain }

  #
  # ==> PostgreSQL only options

  # Specifies whether to use PostgreSQL schemas or create a new database per Tenant.
  # The default behaviour is true.
  #
  # config.use_schemas = true

  # Apartment can be forced to use raw SQL dumps instead of schema.rb for creating new schemas.
  # Use this when you are using some extra features in PostgreSQL that can't be respresented in
  # schema.rb, like materialized views etc. (only applies with use_schemas set to true).
  # (Note: this option doesn't use db/structure.sql, it creates SQL dump by executing pg_dump)
  #
  # config.use_sql = false

  # There are cases where you might want some schemas to always be in your search_path
  # e.g when using a PostgreSQL extension like hstore.
  # Any schemas added here will be available along with your selected Tenant.
  #
  # config.persistent_schemas = %w{ hstore }
  config.persistent_schemas = %w{ shared_extensions }

  # <== PostgreSQL only options
  #

  # By default, and only when not using PostgreSQL schemas, Apartment will prepend the environment
  # to the tenant name to ensure there is no conflict between your environments.
  # This is mainly for the benefit of your development and test environments.
  # Uncomment the line below if you want to disable this behaviour in production.
  #
  # config.prepend_environment = !Rails.env.production?
end

# Setup a custom Tenant switching middleware. The Proc should return the name of the Tenant that
# you want to switch to.
Rails.application.config.middleware.use 'Apartment::Elevators::Generic', lambda { |request|

  if request.host_with_port != ENV['MASTER_DOMAIN']
    http_host = "http://#{request.host_with_port}"
    https_host = "https://#{request.host_with_port}"
    domain = Domain.where(url: [https_host, http_host]).first

    to_ret = nil

    if domain and domain.subdomain
      to_ret = domain.subdomain
    elsif Rails.env.development? and d = Domain.find_by(default: true)
      to_ret = d.subdomain
    elsif ENV['MASTER_DOMAIN'].present?
      to_ret = request.host_with_port.gsub('.' + ENV['MASTER_DOMAIN'], '')
    end

    to_ret == 'rapiddo' ? 'rapiddobkp' : to_ret

    if to_ret.present?
      return to_ret
    else
      return nil
    end
  else
    return nil
  end
}

begin
  the_methods = Apartment.tenant_names
  the_methods.flatten!
  the_methods.uniq!

  the_methods.select(&:present?).each do |the_method|
    if not self.respond_to?(the_method)
      define_method(the_method) do
        switch_to the_method
      end
    end
  end

  def ts
    info = Domain.all.map do |d|
      "(#{d.subdomain}) #{d.url}"
    end

    print info.join("\n") + "\n"
  end

  def switch_to the_method
    d = Domain.find_by subdomain: the_method

    if not d.present?
      d = Domain.where("url like ?", "%#{the_method}%").first
    end

    if d and d.subdomain
      Apartment::Tenant.switch! d.subdomain
      Rails.logger.info "Switched to #{d.subdomain} #{d.url}"
    end
  end

  def reset_tenant
    Apartment::Tenant.switch! nil
  end

  def current_domain
    Domain.find_by subdomain: Apartment::Tenant.current
  end
rescue Exception => e
  ap e
end


# Rails.application.config.middleware.use 'Apartment::Elevators::Domain'
#Rails.application.config.middleware.use 'Apartment::Elevators::Subdomain'
# Rails.application.config.middleware.use 'Apartment::Elevators::FirstSubdomain'
