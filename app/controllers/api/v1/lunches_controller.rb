require 'pry'
class Api::V1::LunchesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :set_lunch, only: [ :show, :update , :destroy]

  def index
    @lunches = policy_scope(Lunch)

  end

  def show
  end

  def update
    if @lunch.update(lunch_params)
      render :show
    else
      render_error
    end
  end

  def create
    @hash_params = {
      localisation: lunch_params["localisation"],
      distance: lunch_params["distance"],
      price: lunch_params["price"],
      taste: nil
    }

    matching_preferences
    choice_count









    fetch_yelp(
      @hash_params[:localisation],
      @hash_params[:distance],
      @hash_params[:price][0],
      @hash_params[:taste]
    )

    @lunch = Lunch.new(
      localisation: lunch_params["localisation"],
      distance: lunch_params["distance"],
      price: lunch_params["price"]
    )

    @lunch.user = current_user
    authorize @lunch
    if @lunch.save
      render :show, status: :created
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

  def set_lunch
    @lunch = Lunch.find(params[:id])
    authorize @lunch  # For Pundit
  end

  def lunch_params
    params.require(:lunch).permit(:localisation, :distance, attendees: [], price: [])
  end

  def render_error
    render json: { errors: @lunch.errors.full_messages },
      status: :unprocessable_entity
  end

  def matching_preferences
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
    choice = @counts.max_by { |_k, v| v }
    @hash_params[:taste] = choice
  end

  def fetch_yelp(loc,dist,pr,tas = "Restaurants")
    # default="Restaurants"
    country ="BE"
    url = "https://api.yelp.com/v3/businesses/search?location=#{loc},#{country}&radius=#{dist}&price=#{pr}&categories=#{tas}"
    api_key = "dbOmGDOTOsbVmzXmFv-VBQTPbaumCoBaryQs1szFsDmNT9tw02WYflsQ7WgwgA2i79451YDsrFzo13zLqIYmocjCR4fup6IbnUZnaWISy8XddZawOuCsy5-xbSk1YHYx"
    response = Excon.get(url, :headers => {'Authorization' => 'Bearer api_key'})
    p "hello"
    @body = JSON.parse(response.body)
    p @body
    p "bye bye"
  end

end
