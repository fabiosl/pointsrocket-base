collection @trivias_questions
attributes :id, :name

child :options, as: :options do
  attributes :id, :name, :correct
end
