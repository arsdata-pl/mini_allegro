# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Category, type: :model do

  describe 'validations' do

    let(:category) {described_class.new(name: nil)}

    describe '#name' do
      describe 'validates presence' do
        context 'when not valid' do
          it {expect(category.valid?).to be false}

          it 'returns proper error message' do
            category.valid?
            expect(category.errors[:name]).to include("can't be blank")
          end
        end
      end
    end
  end

  describe '#obj_ancestors' do
    context 'when parent category available' do
      let (:parent_category) { create(:category) }
      let (:child_category) { create(:category, parent: parent_category) }

      it 'returns from child to parent order' do
        expect(child_category.obj_ancestors).to eq([child_category, parent_category])
      end
    end

    context 'when parent category not available' do
      let (:child_category) { create(:category) }
      it 'returns only child' do
        expect(child_category.obj_ancestors).to eq([child_category])
      end
    end
  end
end
