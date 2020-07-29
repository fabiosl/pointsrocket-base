namespace :badges do
  desc 'Create default badges'
  task :create_default_badges, [:tenant] => :environment do |t, args|
    badges = [
      { name: 'Meu primeiro tweet!', slug: 'first-tweet-share', points: 5 },
      { name: 'Meu primeiro Post no Facebook!', slug: 'first-facebook-share', points: 5 },
      { name: 'Meu primeiro Post no LinkedIn!', slug: 'first-linkedin-share', points: 5 },
      { name: 'Combo 2 semanas!', slug: 'two-week-post-combo', points: 20 },
      { name: 'Combo 4 semanas!', slug: 'four-week-post-combo', points: 20 },
      { name: 'Combo 3 semanas!', slug: 'three-week-post-combo', points: 20 },
      { name: 'Combo 8 semanas!', slug: 'eight-week-post-combo', points: 20 }
    ]

    Apartment::Tenant.switch(args.tenant) do
      badges.each do |badge|
        b = Badge.new(
          name: badge[:name],
          slug: badge[:slug],
          avatar: File.open("#{Rails.root}/public/original/badges/#{badge[:slug]}.png"),
          badge_points: badge[:points],
          badge_type: 'simple'
        )
        b.save!
      end
    end
  end
end