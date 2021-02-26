# frozen_string_literal: true

class CreatePreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :preferences do |t|
      t.string :name
      t.text :taste, default: [], array: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
