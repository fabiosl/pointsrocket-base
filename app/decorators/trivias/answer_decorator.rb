Trivias::Answer.class_eval do
  after_save :create_points
  before_destroy :delete_points

  def create_points
    user = self.play.user
    user.points.create(
      value: self.seconds_took,
      pointable: self
    )
  end

  def delete_points
    user = self.play.user
    user.points.where(
      pointable: self
    ).destroy_all
  end
end
