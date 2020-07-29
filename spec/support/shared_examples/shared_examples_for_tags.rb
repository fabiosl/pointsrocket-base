RSpec.shared_examples "taggable" do
  it "has tags defined" do
    expect(subject.tags).not_to be_nil
  end

  context "adding tags" do
    it "adds tags" do
      subject.tag_list.add("Teste")
      subject.save
      expect(subject.tag_list).to match_array(['Teste'])
    end
  end
end
