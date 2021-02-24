json.array! @lunches do |lunch|
  json.extract! lunch, :id, :localisation, :distance, :price
end
