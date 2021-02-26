# frozen_string_literal: true

class CreateLunches < ActiveRecord::Migration[6.0]
  def change
    create_table :lunches do |t|
      t.string :localisation
      t.integer :distance
      t.string :price, array: true, default: []
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
