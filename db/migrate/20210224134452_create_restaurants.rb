# frozen_string_literal: true

class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      t.string :restaurant_name
      t.string :restaurant_price
      t.string :restaurant_city
      t.string :restaurant_category
      t.integer :restaurant_distance
      t.references :lunch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
