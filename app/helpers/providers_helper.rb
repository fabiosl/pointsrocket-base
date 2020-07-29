module ProvidersHelper

  ATTRIBUTES = [
    :available_providers
  ]

  @@available_providers = [:facebook, :twitter, :google_oauth2, :instagram, :linkedin]

  mattr_reader *ATTRIBUTES

  def get_current_domain
    Domain.find_by(subdomain: Apartment::Tenant.current) ||
    Domain.find_by(default: true)
  end

  def get_permited_providers_for_current_domain
    domain = get_current_domain

    available_providers.select do |p|
      domain.permit_provider? p
    end
  end

  def get_login_permited_providers_for_current_domain
    domain = get_current_domain

    if domain.login_providers.present?
      permited_login_providers = domain.login_providers.split(',').compact.uniq
    else
      permited_login_providers = nil
    end

    get_permited_providers_for_current_domain.select do |provider|
      if permited_login_providers.nil?
        false
      else
        permited_login_providers.include? provider.to_s
      end
    end

  end

end
