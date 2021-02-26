# frozen_string_literal: true

json.array! @lunches do |lunch|
  json.extract! lunch, :id, :localisation, :distance, :price
  json.restaurants lunch.restaurants, :restaurant_name, :restaurant_price, :restaurant_city, :restaurant_category, :restaurant_distance
end
# end

# resturent title, taste and price?
