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
    hash_params = {
      localisation: lunch_params["localisation"],
      distance: lunch_params["distance"],
      price: lunch_params["price"],
      attendees: lunch_params["attendees"]
    }
    # binding.pry
    fetch_yelp(
      hash_params[:localisation],
      hash_params[:distance],
      hash_params[:price]
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
    params.require(:lunch).permit(:localisation, :distance, attendees: [], price: [])# , attendees: []
  end

  def render_error
    render json: { errors: @lunch.errors.full_messages },
      status: :unprocessable_entity
  end

  def fetch_yelp(loc,dist,pr)
    default="Restaurants"
    country ="BE"
    url = "https://api.yelp.com/v3/businesses/search?location=#{loc},#{country}&radius=#{dist}&price=#{pr}&categories=#{default}"
    api_key = "dbOmGDOTOsbVmzXmFv-VBQTPbaumCoBaryQs1szFsDmNT9tw02WYflsQ7WgwgA2i79451YDsrFzo13zLqIYmocjCR4fup6IbnUZnaWISy8XddZawOuCsy5-xbSk1YHYx"
    response = Excon.get(url, :headers => {'Authorization' => 'Bearer api_key'})
    p "hello"
    @body = JSON.parse(response.body)
    p @body
    p "bye bye"
  end

end
