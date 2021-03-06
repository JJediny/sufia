RSpec.describe Sufia::Statistics::Works::OverTime do
  let(:service) { described_class.new }

  describe "#points" do
    before do
      create(:generic_work)
    end

    subject { service.points }

    it "is a list of points" do
      expect(subject.size).to eq 5
      expect(subject.first[1]).to eq 0
      expect(subject.to_a.last[1]).to eq 1
    end
  end
end
