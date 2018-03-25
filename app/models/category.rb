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

class Category < ApplicationRecord
  validates :name, presence: true

  has_many :children, class_name: 'Category', foreign_key: 'category_id'
  belongs_to :parent, class_name: 'Category', foreign_key: 'category_id',
             optional: true
  has_and_belongs_to_many :products


  def obj_ancestors(acc = [])
    acc << self
    if parent.nil?
      return acc
    else
      parent.obj_ancestors(acc)
    end
  end
end
