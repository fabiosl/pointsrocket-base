namespace :users do

  desc 'Get social monitors info'
  task :get_social_monitors_infos => :environment do
    Apartment.tenant_names.select(&:present?).each do |tenant|
      Apartment::Tenant.switch(tenant) do
        domain = Domain.find_by(subdomain: tenant).master_domain_or_self_for_provider :google_oauth2
        user_ids = Identity.youtube.where(domain: domain).pluck('user_id').uniq
        User.where(id: user_ids).each do |user|
          begin
            p "processing youtube for #{user.name} #{user.id} #{tenant}"
            user.proccess_youtube_channel_info_to_monitor domain
          rescue Exception => e
            p e.message
          end
        end

        domain = Domain.find_by(subdomain: tenant).master_domain_or_self_for_provider :facebook
        user_ids = Identity.facebook.where(domain: domain).pluck('user_id').uniq
        User.where(id: user_ids).each do |user|
          begin
            p "processing facebook for #{user.name} #{user.id} #{tenant}"
            user.proccess_facebook_page_info_to_monitor domain
          rescue Exception => e
            p e.message
          end
        end
      end
    end
  end

  desc 'Replicate users over all tenants'
  task :replycate_over_all_tenants => :environment do
    User.all.each do |user|
      p "runing for #{user.id}"
      user_hash = JSON.parse user.to_json
      identities_hash = JSON.parse user.identities.to_json

      Apartment.tenant_names.each do |tenant|
        if tenant.present?
          Apartment::Tenant.switch(tenant) do

            user = User.find_by id: user_hash['id']

            if user.nil?
              user = User.find_by email: user_hash['email']
            end

            if user_hash["name"].present? and user_hash["email"].present? and user.nil?
              user = User.create!(
                user_hash.merge(
                  "password" => "ld92lkjdf9023l"
                )
              )
            end

            if not user.nil?
              identities_hash.each do |identity_hash|
                uid = identity_hash['uid']

                if not Identity.where(uid: uid).any?
                  Identity.create! identity_hash.merge(
                    "user_id" => user.id
                  )
                end
              end
            end

          end
        end
      end
    end
  end

  Apartment.tenant_names.each do |tenant|
    next if not tenant.present?

    Apartment::Tenant.switch(tenant) do
      ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
      end
    end
  end


end
