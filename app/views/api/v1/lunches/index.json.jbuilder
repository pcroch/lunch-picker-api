json.array! @lunches do |lunch|
  json.extract! lunch, :id, :localisation
end
