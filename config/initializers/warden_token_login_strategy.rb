class WardenTokenLoginStrategy < Warden::Strategies::Base
  def valid?
    ap "valid? #{params['token_login'].present?}"
    params['token_login'].present?
  end

  def authenticate!
    ap "authenticate"
    if u = User.find_by(token_login: params["token_login"])
      ap u
      ap "success"
      success!(u)
    else
      ap "error"
      ap "#{Domain.get_current_domain}"
    end
  end
end
