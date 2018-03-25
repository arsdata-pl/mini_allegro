# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  name            :string
#  ean             :string
#  price           :decimal(, )
#  manufacturer_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    let(:product) {described_class.new(name: nil, price: nil)}

    describe '#name' do
      describe 'validates presence' do
        context 'when not valid' do
          it {expect(product.valid?).to be false}

          it 'returns proper error message' do
            product.valid?
            expect(product.errors[:name]).to include("can't be blank")
          end
        end
      end
    end

    describe '#price' do
      describe 'validates presence' do
        context 'when not valid' do
          it {expect(product.valid?).to be false}

          it 'returns proper error message' do
            product.valid?
            expect(product.errors[:price]).to include("can't be blank")
          end
        end
      end
    end
  end

  describe '#add_unique_category' do
    let(:product) {create(:product)}
    let!(:category) {create(:category)}
    subject(:result) {product.add_unique_category(category)}

    context 'when association does not exists' do
      it {expect(result).not_to be_nil}

      it {expect(result).to include(category)}

      it {expect(result.first).to be_instance_of(Category)}
    end

    context 'when association exists' do
      let(:product) {create(:product, categories: [category])}

      it {expect(result).to be_nil}
    end
  end

  describe '#search_data' do
    let(:category) {create(:category, name: 'Acme')}
    let(:manufacturer) {create(:manufacturer, name: 'Acme Corp')}
    subject {create(:product, name: 'Foo', manufacturer: manufacturer, categories: [category])}
    it 'returns search data' do
      expect(subject.search_data).to eq({name: 'Foo', manufacturer_name: 'Acme Corp', category_names: 'Acme'})
    end
  end
end
