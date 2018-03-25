class CreateManufacturers < ActiveRecord::Migration[5.1]
  def change
    create_table :manufacturers do |t|
      t.string :name
      t.string :code
      t.timestamps
    end
    add_index :manufacturers, :name, unique: true
    add_index :manufacturers, :code, unique: true
  end
end
