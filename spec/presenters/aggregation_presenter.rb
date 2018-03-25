RSpec.describe AggregationPresenter do

  describe '#name' do
    subject { AggregationPresenter.new('key' => 'Foo') }

    it 'returns name' do
      expect(subject.name).to eq('Foo')
    end
  end

  describe '#count' do
    subject { AggregationPresenter.new('count' => 0) }

    it 'returns count' do
      expect(subject.count).to eq(0)
    end
  end

end
