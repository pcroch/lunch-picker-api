# frozen_string_literal: true

json.array! @preferences do |preference|
  json.extract! preference, :name, :taste
end
