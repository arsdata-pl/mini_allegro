require 'rails_helper'

RSpec.describe ReadCSV do
  describe '.call' do
    let(:file_msg) { 'You must provide a valid location for the file' }
    let(:block_msg) { 'You must provide a block!' }

    context 'when file_path is invalid' do
      let(:file_path) { '$!@is_invalid' }

      it { expect { described_class.call(file_path) }.to raise_error(file_msg) }
    end

    context 'when block is not given' do
      before { allow(File).to receive(:exist?).and_return(true) }
      let(:file_path) { 'is_valid' }

      it do
        expect do
          described_class.call(file_path)
        end.to raise_error(block_msg)
      end
    end

    context 'when is valid' do
      it 'should yield row and row_number' do
        described_class.call(file_fixture('product.csv')) do |row, row_number|
          expect(row).to be_instance_of(CSV::Row)
          expect(row_number).to be_instance_of(Integer)
        end
      end
    end
  end
end
