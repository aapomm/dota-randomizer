class CreateHeroes < ActiveRecord::Migration[8.0]
  def change
    create_table :heroes do |t|
      t.string :name, null: false
      t.string :localized_name, null: false
      t.string :image_link, null: false
      t.integer :primary_attr, default: 0
      t.integer :complexity, default: 1

      t.timestamps
    end
  end
end
