require 'rails_helper'

RSpec.describe ParseProductCSV do
  describe '.call' do
    let(:file_msg) { 'You must provide a valid location for the file' }

    context 'when file_path is invalid' do
      let(:file_path) { '$!@is_invalid' }

      it { expect { described_class.call(file_path) }.to raise_error(file_msg) }
    end

    context 'when is valid' do
      let(:call) { described_class.call(file_fixture('product.csv')) }

      it 'creates a product' do
        start_count = Product.count
        call
        end_count = Product.count
        expect(end_count).to eq(start_count + 1)
      end

      it 'creates category' do
        start_count = Category.count
        call
        end_count = Category.count
        expect(end_count).to eq(start_count + 1)
      end

      it 'creates manufacturer' do
        start_count = Manufacturer.count
        call
        end_count = Manufacturer.count
        expect(end_count).to eq(start_count + 1)
      end
    end
  end
end
