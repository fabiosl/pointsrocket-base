namespace :search do

  desc 'Seed bm data'
  task :load_initial => :environment do
    Search.registered_models.each do |model|
      p "Syncing search for #{model}"

      model.all.each do |item|
        item.sync_search
      end
    end
  end
end
