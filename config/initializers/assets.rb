# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.enabled = true
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'course_files')
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'termos')
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'javascript', 'locales')
Rails.application.config.assets.precompile += %w( comments.js )
Rails.application.config.assets.precompile += %w( main-dashboard.css )
Rails.application.config.assets.precompile += %w( main-dashboard.js )
Rails.application.config.assets.precompile += %w( modernizr/js/modernizr.js )
Rails.application.config.assets.precompile += %w( site.js )
Rails.application.config.assets.precompile += %w( registration.js )
Rails.application.config.assets.precompile += %w( registration.css )
Rails.application.config.assets.precompile += %w( social_accounts.js )
Rails.application.config.assets.precompile += %w( social_accounts.css )
Rails.application.config.assets.precompile += %w( site.css )
Rails.application.config.assets.precompile += %w( loreal.css )
Rails.application.config.assets.precompile += %w( domain.css )
Rails.application.config.assets.precompile += %w( employee_advocacy.js )
Rails.application.config.assets.precompile += %w( employee_advocacy.css )
Rails.application.config.assets.precompile += %w( timeline.css )
Rails.application.config.assets.precompile += %w( dashboard/conversations.js )
Rails.application.config.assets.precompile += %w( dashboard/activities.js )
Rails.application.config.assets.precompile += %w( challenge_posts.js )
Rails.application.config.assets.precompile += %w( new_dashboard_table.js new_dashboard_table.css )

# Rails.application.config.assets.precompile += %w( bm.css )
# Rails.application.config.assets.precompile += %w( moip.css )
# Rails.application.config.assets.precompile += %w( cbfa.css )
# Rails.application.config.assets.precompile += %w( cna.css )
# Rails.application.config.assets.precompile += %w( employee_advocacy.css )
# Rails.application.config.assets.precompile += %w( employee_advocacy.js )
# Rails.application.config.assets.precompile += %w( sevenidiomas.css )

if ENV['ASSETS_PRECOMPILE'].present?
  Rails.application.config.assets.precompile += ENV['ASSETS_PRECOMPILE'].split(",")
end

Rails.application.config.assets.precompile += %w( adminre_login.css adminre_login.js )
Rails.application.config.assets.precompile += %w( trivias/trivia.js )
Rails.application.config.assets.precompile += %w( general_login.css )
Rails.application.config.assets.precompile += %w( dash_admin.css )
Rails.application.config.assets.precompile += %w( dash_admin.js )
Rails.application.config.assets.precompile += %w( dashboard.js )
Rails.application.config.assets.precompile += %w( jquery.js jquery_ujs.js )
Rails.application.config.assets.precompile += %w( site_payment.js )
Rails.application.config.assets.precompile += %w( socket.js )
Rails.application.config.assets.precompile += %w( broadcasts.js )
Rails.application.config.assets.precompile += %w( step_video.js )
Rails.application.config.assets.precompile += %w( timeline_items.js )
Rails.application.config.assets.precompile += %w( timeline_post.js )
Rails.application.config.assets.precompile += %w( timeline_onscreen.js )
Rails.application.config.assets.precompile += %w( profile_timeline.js )
Rails.application.config.assets.precompile += %w( i18n.js )
Rails.application.config.assets.precompile += %w( analytics.js )
Rails.application.config.assets.precompile += %w( lib/jquery-ui-1.11.4.custom/jquery-ui.css )
