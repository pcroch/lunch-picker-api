class Api::V1::LunchesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :set_lunch, only: [ :show, :update , :destroy]

  def index
    @lunches = policy_scope(Lunch)
    fetch_yelp("Arlon",10_000,3)
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
    @lunch = Lunch.new(lunch_params)
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
    params.require(:lunch).permit(:localisation, :distance, price: [])# , attendees: []
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
