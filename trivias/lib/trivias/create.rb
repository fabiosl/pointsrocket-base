module Trivias
  class Create
    def self.create trivias_options
      trivias_options = parse trivias_options
      Trivia.create!(trivias_options)
    end

    def self.slugify name
      name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end

    def self.parse trivias_options
      trivias_options.each do |options|
        options["slug"] = slugify options["title"]
        options["questions_attributes"] ||= []
        options["questions_attributes"].each do |question_attributes|

          question_attributes["slug"] = slugify question_attributes["name"]
          question_attributes["options_attributes"] ||= []

          question_attributes["options_attributes"].each do |option_attributes|
            option_attributes["correct"] ||= false
          end
        end
      end

      trivias_options
    end
  end
end
