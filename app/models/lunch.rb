# frozen_string_literal: true

class Lunch < ApplicationRecord
  belongs_to :user
  has_many :lunch_preferences
  has_many :preferences, through: :lunch_preferences
  has_many :restaurants

  validates :localisation, format: { with: /[a-zA-Z]/, message: 'must be a string' }, presence: true
  # validates :distance, format: { with: /\d{5}/, message: ' must be an integer of maximum 5 digits' }, presence: true
  validate :range_price

  def range_price
    sample = %w[1 2 3 4]
    errors.add(:price, 'range is invalid') unless price.all? { |w| sample.include?(w) }
  end

  #   client = Faraday.new do |builder|
  #   builder.use :http_cache, store: Rails.cache
  #   builder.adapter Faraday.default_adapter
  # end
end
