# frozen_string_literal: true

class Preference < ApplicationRecord
  belongs_to :user
  has_many :lunch_preferences
  has_many :lunch, through: :lunch_preferences
  validates :name, uniqueness: { case_sensitive: false, message: 'already in use' }, presence: true
  # validate :myarray # the sample variable is not full so w ont work
  def myarray
    sample = %w[Action Horror]
    errors.add(:taste, "doesn't match everywhere") unless taste.all? { |w| sample.include?(w) }
  end

#     client = Faraday.new do |builder|
#   builder.use :http_cache, store: Rails.cache
#   builder.adapter Faraday.default_adapter
# end

end
