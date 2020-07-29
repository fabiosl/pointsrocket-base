RSpec.shared_examples "a susbscription ready to suspend" do
  it "is ready to be suspended" do
    expect(subject.ready_to_suspend?).to eql(true)
  end
end

RSpec.shared_examples "a susbscription not ready to suspend" do
  it "is not ready to be suspended" do
    expect(subject.ready_to_suspend?).to eql(false)
  end
end

RSpec.shared_examples "an account active to user app" do
  it "is active to use app" do
    expect(Subscription.active_to_user_app[0]).to eql(subject)
  end
end

RSpec.shared_examples "an account not active to user app" do
  it "is not ractive to use app" do
    expect(Subscription.active_to_user_app.any?).to eql(false)
  end
end

RSpec.shared_examples "suspendable in" do |now, expectation|
  before do
    allow(Time).to receive(:now).and_return freeze_now + now
  end

  it "calculate active_until in correctly" do
    expect {
      subject.calculate_suspend_in_and_active_until
    }.to change {
      subject.active_until.to_i
    }.to eql((freeze_now + expectation).to_i)
  end

  # it "calculate suspend_in in correctly" do
  #   active_until = plan_trial_days.days.from_now + plan_duration.month

  #   expect {
  #     subject.calculate_suspend_in_and_active_until
  #   }.to change {
  #     subject.suspend_in.to_i
  #   }.to eql((active_until - 10.days).to_i)
  # end
end
