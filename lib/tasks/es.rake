def confirming &block
  if Rails.env.development?
    p "Are you sure you want to delete index \"#{ENV['ES_INDEX']}\" from #{ENV['ES_URL']}: (Yn)"
    if STDIN.gets.chomp == 'Y'
      yield
    end
  end
end

namespace :es do

  desc 'Drop es index'
  task :drop => :environment do
    confirming do
      response = HTTParty.delete("#{ENV['ES_URL']}/#{ENV['ES_INDEX']}")
      ap response.body
    end
  end

  desc 'Create es index'
  task :create => :environment do
    index = File.open(Rails.root.join("config", "es_index.json")).read()
    response = HTTParty.put(
      "#{ENV['ES_URL']}/#{ENV['ES_INDEX']}", body: index
    )
    ap response.body
  end

  desc 'Recreate es index'
  task :recreate => :environment do
    Rake::Task["es:drop"].invoke
    Rake::Task["es:create"].invoke
  end

  desc 'Migrate v1.0.1'
  task :migrate_v1_0_1 => :environment do
    config = JSON.parse(File.open(Rails.root.join("config", "es_migrates", "v1.0.1.json")).read())
    response = HTTParty.put(
      "#{ENV['ES_URL']}/#{ENV['ES_INDEX']}/_mapping/post", body: config["post"].to_json
    )
    ap response.body
  end

end
