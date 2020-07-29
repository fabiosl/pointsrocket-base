def act_as_badgeable
  class_eval do
    has_one :badge, as: :badgeable
  end
end
