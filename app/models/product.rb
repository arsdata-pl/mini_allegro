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

class Product < ApplicationRecord
  default_scope -> { order(id: :desc) }

  validates :name, presence: true
  validates :price, presence: true
  belongs_to :manufacturer
  has_and_belongs_to_many :categories

	searchkick

  # Search data needed for searchkick, it creates based on this data
  # a mapping
  def search_data
    {
      name: name,
      manufacturer_name: manufacturer.name,
      category_names: categories.map(&:obj_ancestors).flatten.map(&:name).reverse.inject([]) { |prod, value| prod << [prod, value].flatten.join('/') }.last
    }
  end

  # Add category if it is not present in the relationship.
  #
  # @param category [Category]
  # @return categories [Array<Category>] if added
  # @return nil [NilClass] if not added
  def add_unique_category(category)
    categories << category if categories.where(id: category.id).empty?
  end
end
