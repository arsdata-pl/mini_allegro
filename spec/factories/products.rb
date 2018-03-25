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

FactoryBot.define do
  factory :product do
    name 'Product'
    ean ''
    price 999
    manufacturer { create(:manufacturer) }
  end
end
