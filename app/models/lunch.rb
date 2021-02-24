class Lunch < ApplicationRecord
  belongs_to :user
  has_many :lunch_preferences
  has_many :preferences, through: :lunch_preferences
  has_many :restaurants
end
