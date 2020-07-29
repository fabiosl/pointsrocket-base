class DomainService < Service

  def self.get_domain_by_url url
    if domain = Domain.where(url: url).first
      return
    end

    if domain = Domain.where(default: true).first
      return domain
    end
  end

end
