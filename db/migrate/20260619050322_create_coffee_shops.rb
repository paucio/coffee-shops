class CreateCoffeeShops < ActiveRecord::Migration[8.1]
  def change
    create_table :coffee_shops do |t|
      t.string :name, null: false
      t.float :x, null: false
      t.float :y, null: false

      t.timestamps
    end

    add_index :coffee_shops, [:x, :y], unique: true
  end
end