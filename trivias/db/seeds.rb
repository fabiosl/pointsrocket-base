require 'yaml'

# def slugify name
#   name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
# end


# def create_trivia options
#   options.merge!(slug: slugify(options[:title]))
#   Trivias::Trivia.create!(options)
# end

options = YAML.load_file "#{File.dirname(__FILE__)}/example.yaml"

Trivias::Create.create options

# ap options

# Trivias.create options
