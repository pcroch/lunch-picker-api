# json.cache! ['finders'], expires_in: 1.minutes do |json|
  json.extract! @lunch, :id, :localisation, :distance, :price

  json.restaurants @lunch.restaurants do |restaurant|
    json.extract! restaurant, :restaurant_name, :restaurant_price, :restaurant_city, :restaurant_category
  end
# end
