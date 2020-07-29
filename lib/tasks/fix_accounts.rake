namespace :fix_accounts do

  desc "Fix after employee advocacy with domains and tenants"
  task :after_employee_and_domains => :environment do
    Domain.all.each do |d|
      if not d.influencer?
        d.social_network_permiteds = 'facebook'
      else
        d.social_network_permiteds = 'facebook,instagram,google_oauth2'
      end
      p "seting #{d.social_network_permiteds} to #{d.name} #{d.url} #{d.subdomain}"
      d.save
    end
  end

  desc 'fix accounts after identity deployed'
  task :after_identity_layout_deployed => :environment do
    Identity.all.each do |identity|
      begin
        identity.remote_avatar_url = identity.json["info"]["image"].gsub('http://','https://')
        identity.save!
        ap "identity #{identity.id} updated #{identity.provider}"
      rescue Exception => e
        ap "identity #{identity.id} not updated #{identity.provider}"
        ap e.message
      end
    end
  end

  desc 'Fix Emploee Advocacy changes'
  task :after_employee_advocacy => :environment do
    Identity.facebook.each do |identity|
      if identity.user
        identity.json = identity.user.facebook_json
        # não vou pegar o secret, pq essa migração so afeta o fb
        identity.access_token = identity.json["credentials"]['token']
        identity.save!
      end
    end

    Identity.all.each do |identity|
      if identity.user
        domain = Domain.all.tagged_with(identity.user.tags, any: true).first
        if not domain.present?
          domain = Domain.first
        end

        if not domain.present?
          raise "No domain is present, you must create one"
        end

        identity.domain = domain
        begin
          identity.save!
        rescue Exception => e
          ap "identity #{identity.id} não pode ser salva. #{e.message}"
        end
      end
    end
  end

  desc 'Fix Emploee Advocacy Mail changes'
  task :after_employee_advocacy_mail => :environment do
    EmployeeAdvocacyPost.all.each {|p| p.image.recreate_versions! }
  end

  desc 'Fix plans changes'
  task :after_plans_deployed => :environment do
    Plan.update_all(active: true, trial_days: 7)
    Plan.where(name: "Plano anual").update_all(name: "Anual", price: "39,90")

    Subscription.all.each { |s|
      if s.user.present?
        if s.trial_end_time.present?
          s.first_paid_day = s.trial_end_time
        else
          s.first_paid_day = 2.weeks.ago
        end
        s.save
        s.calculate_suspend_in_and_active_until
      end
    }

    Plan.where(name: "Anual", duration:12, price: '39,90', active: true, moip_code: "anual", trial_days: 7).first_or_create
    Plan.where(name: "Mensal", duration:1, price: '69,90', active: true, moip_code: "mensal", trial_days: 0).first_or_create
    Plan.where(name: "Trimestral", duration:3, price: '59,90', active: true, moip_code: "trimestral", trial_days: 0).first_or_create
    Plan.where(name: "Semestral", duration:6, price: '49,90', active: true, moip_code: "semestral", trial_days: 0).first_or_create
  end

  desc 'Fix tags'
  task :after_tags_deployed => :environment do
    Course.all.each do |object|
      object.tag_list.add('onrocket')
      object.save
    end

    User.all.each do |obj|
      if obj.tags.count == 0
        obj.tag_list.add('onrocket')
        obj.save
      end
    end

    Question.all.each do |obj|
      if obj.tags.count == 0
        obj.tag_list.add('onrocket')
        obj.save
      end
    end

    Badge.all.each do |obj|
      if obj.tags.count == 0
        obj.tag_list.add('onrocket')
        obj.save
      end
    end

    Campaign.all.each do |obj|
      if obj.tags.count == 0
        obj.tag_list.add('onrocket')
        obj.save
      end
    end

  end

  desc 'Fix has_submit_payment_form'
  task :fix_submit_payment_form_field => :environment do
    User.where.not(phone: [nil, '', '(__) _________']).update_all(has_submited_payment_form: true)
  end

end
