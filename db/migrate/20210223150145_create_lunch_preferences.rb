# frozen_string_literal: true

class CreateLunchPreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :lunch_preferences do |t|
      t.references :lunch, null: false, foreign_key: true
      t.references :preference, null: false, foreign_key: true

      t.timestamps
    end
  end
end
