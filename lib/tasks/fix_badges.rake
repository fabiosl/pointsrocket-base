namespace :fix_badges do

  desc 'Fix badges type'
  task :badge_type => :environment do
    Badge.update_all(badge_type: 'simple')
  end

end
