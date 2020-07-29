def act_as_pointable
  class_eval do
    has_many :points, as: :pointable
  end
end
