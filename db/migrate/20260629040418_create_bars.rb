class CreateBars < ActiveRecord::Migration[8.1]
  def change
    create_table :bars do |t|
      t.string :name, null: false
      t.float :x, null: false
      t.float :y, null: false

      t.timestamps
    end

    add_index :bars, [:x, :y], unique: true
  end
end
