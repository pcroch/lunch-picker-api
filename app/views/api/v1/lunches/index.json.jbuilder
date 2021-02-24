json.array! @lunches do |lunch|
  json.extract! lunch, :id, :localisation, :distance, :price
  # json.movies finder.movies, :title, :overview, :vote_average
end



# resturent title, taste and price?
