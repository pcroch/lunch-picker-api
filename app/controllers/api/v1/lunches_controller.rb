# frozen_string_literal: true

module Api
  module V1
    class LunchesController < Api::V1::BaseController
      include Pundit
      include ActionController::Caching
      acts_as_token_authentication_handler_for User, except: %i[index show]
      before_action :set_lunch, only: %i[show update destroy]
      before_action :controller_validation, only: [:create]

      caches_action :index, :show, :create
      # caches_page :index, :show, :create

      def index
        #         http_cache_forever(public: true) do
        @lunches = policy_scope(Lunch)
        # end
      end

      def show; end

      def update
        if @lunch.update(lunch_params)
          render :show
        else
          render_error
        end
      end

      def create
        #  act as a constructor
        @hash_params = {
          localisation: lunch_params['localisation'],
          distance: lunch_params['distance'],
          price: lunch_params['price'],
          taste: nil
        }
        # binding.pry
        # create a range for price api
        price_min = lunch_params['price'].min
        price_max = lunch_params['price'].max
        @hash_params[:price] = [*price_min..price_max].join(',')

        # Calling method to sort and fetch the api
        matching_preferences
        choice_count

        # Creating object lunch
        @lunch = Lunch.new(
          localisation: lunch_params['localisation'],
          distance: lunch_params['distance'],
          price: lunch_params['price']
        )

        # for pundit
        @lunch.user = current_user
        authorize @lunch
        if @lunch.save
          upper_limit
        else
          render_error
        end
      end

      def destroy
        @lunch.destroy
        head :no_content
        # No need to create a `destroy.json.jbuilder` view
      end

      private

      def controller_validation
        # validate the distance strong params format
        if lunch_params['distance'].to_i.zero? || (lunch_params['distance'].to_i > 39_999)
          invalid_distance
        # validate the price strong params format
        elsif lunch_params['price'].empty?
          empty_price_array
        # validate the price attendees params format
        elsif lunch_params['attendees'].empty? || lunch_params['attendees'] == ['']
          empty_attendees_array

        end
      end

      def set_lunch
        @lunch = Lunch.find(params[:id])
        authorize @lunch # For Pundit
      end

      def lunch_params
        # allowing strong params to be sued in the controller
        params.require(:lunch).permit(:localisation, :distance, attendees: [], price: [])
      end

      def render_error
        render json: { errors: @lunch.errors.full_messages },
               status: :unprocessable_entity
      end
    end
  end
end

def matching_preferences
  # create an hash with the tastes preferences of everyone
  i = 0
  j = lunch_params['attendees'].count
  @preferences = []
  while i < j

    # find the name in the params for i
    name = lunch_params['attendees'][i]
    # find the name of the user in preference for i
    tmp = Preference.where(name: name)[0][:taste]
    # creating a temporary varaible to create an array to sock the preferences
    tmp.each { |string| @preferences.append(string) }
    # creating the hash that will count the number of ocurance for each movie category
    @counts = Hash.new(0)
    # create an has: count with the number of ocurance for each movie category
    @counts = @preferences.each_with_object(Hash.new(0)) { |e, total| total[e] += 1 }
    i += 1
  end
end

def choice_count
  # find the taste that has the most success
  choice = @counts.max_by { |_k, v| v }
  @hash_params[:taste] = choice[0].downcase
end

def fetch_yelp(loc, dist, pr, cat = 'Restaurants')
  # default country
  country = 'BE'
  url = "https://api.yelp.com/v3/businesses/search?location=#{loc},#{country}&radius=#{dist}&price=#{pr}&categories=#{cat}"
  api_key = 'dbOmGDOTOsbVmzXmFv-VBQTPbaumCoBaryQs1szFsDmNT9tw02WYflsQ7WgwgA2i79451YDsrFzo13zLqIYmocjCR4fup6IbnUZnaWISy8XddZawOuCsy5-xbSk1YHYx'
  response = Excon.get(url, headers: { 'Authorization' => "Bearer #{api_key}" })
  @body = JSON.parse(response.body)

  if response.status == 200
    fetch_yelp(loc, dist * 10, pr, cat) if @body['businesses'].count < 10
  else
    dist = dist.div(10)

    # same url as above
    url = "https://api.yelp.com/v3/businesses/search?location=#{loc},#{country}&radius=#{dist}&price=#{pr}&categories=#{cat}"
    # same response a s above
    response = Excon.get(url, headers: { 'Authorization' => "Bearer #{api_key}" })
    # same body as above
    @body = JSON.parse(response.body)

  end
end

def upper_limit
  # call the api and fetch de data into @body
  fetch_yelp(
    @hash_params[:localisation],
    @hash_params[:distance],
    @hash_params[:price],
    @hash_params[:taste]
  )

  # validation if empty of nil to avoid to crash the api
  if @body.nil? || @body['businesses'].count.zero?
    empty_request # call emtpy request method in parent
  else
    # selecting a maximum of 10 movies or less
    @body['businesses'].count < 10 ? (upper_limit = @body['businesses'].count) : (upper_limit = 10)
    i = 0
    # while i < 10
    while i < upper_limit
      # binding.pry
      restaurant = Restaurant.new({
                                    'lunch_id' => @lunch.id,
                                    'restaurant_name' => @body['businesses'][i]['name'],
                                    'restaurant_price' => @body['businesses'][i]['price'],
                                    'restaurant_city' => @body['businesses'][i]['location']['city'],
                                    'restaurant_category' => @body['businesses'][i]['categories'][0]['alias'],
                                    'restaurant_distance' => @body['businesses'][i]['distance'].round
                                  })
      restaurant.save
      i += 1
    end
    render :show, status: :created
  end
end
