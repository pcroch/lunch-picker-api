class Preference < ApplicationRecord
  belongs_to :user
  has_many :lunch_preferences
  has_many :lunch, through: :lunch_preferences
end
