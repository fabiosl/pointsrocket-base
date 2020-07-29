object @goal
attributes *[
  :id, :title
]

child :badge_goals do
  attributes :id, :repetition

  child :badge do
    extends "api/badges/badge"
  end
end
