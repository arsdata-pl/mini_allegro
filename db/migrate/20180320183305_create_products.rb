class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :ean
      t.integer :price
      t.belongs_to :manufacturer, index: true
      t.timestamps
    end
    add_index :products, :name
  end
end
