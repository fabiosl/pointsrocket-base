object @question
attributes :id, :name

child(:options => :options) do
  extends '/trivias/api/options/show'
end
