namespace :oauth2_info do

  desc 'Pick from tenant to default tenant'
  task :insert_in_default => :environment do

    oauth_infos = Apartment.tenant_names.select do |tenant|
      tenant.present? and tenant != 'public'
    end.flat_map do |tenant|
      to_return = nil

      Apartment::Tenant.switch(tenant) do

        to_return = Oauth2Info.all.map do |oauth2_info|
          json = JSON.parse oauth2_info.to_json
          json["id"] = nil
          json
        end

      end

      to_return
    end.uniq

    ap "begin with #{Oauth2Info.count}"
    oauth_infos.each do |oauth_info|
      oauth_info_model = Oauth2Info.where(oauth_info.slice("provider", "uid")).first_or_initialize
      oauth_info_model.access_token = oauth_info['access_token']
      oauth_info_model.refresh_token = oauth_info['refresh_token']
      oauth_info_model.save
      ap "created or updated #{oauth_info_model.id}"
    end
    ap "end with #{Oauth2Info.count}"

  end
end
