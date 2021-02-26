# frozen_string_literal: true

class LunchPreference < ApplicationRecord
  belongs_to :lunch
  belongs_to :preference
end
