
require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Integration testing for the Lunch controller', type: :request do
  #  event = Finder.new(release: "2008", duration: "200", rating: ["5", "10"], user_id: "1")
  #  event.save
  # Preference.create(user_id: 2, name: "Bob", finder_id: 1, content: ["Adventure", "Family", "Horror"])
  # Test suite for GET /articles
  describe 'Index action' do
    # make HTTP get request before each example
    before do
      get 'http://localhost:3000/api/v1/lunches'
    end

    it 'should return list of events' do
      # Note `json` is a custom helper to parse JSON responses
      expect(response.body).not_to be_empty
      # expect(json.size).to eq(10)
    end

    it 'sould return status code 200' do
      expect(response).to have_http_status(200)
    end
 end

  # Show a specific event
  describe 'Show action' do
    # this testing need ot be improoved as i could nt find the movie list?

    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }
    #  let!(:event) {Finder.create(release: "2008", duration: "200", rating: ["5", "10"], user_id: "1")}
    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }
    let!(:lunch) { Lunch.create(id: 1, localisation: "Arlon", distance: 1000, price: [1, 4], user_id: '1') }

    before do
      get 'http://localhost:3000/api/v1/lunches/1'
    end
    it 'should have the same id and localisation' do
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(1)
      expect(json_response['localisation']).to eq('Arlon')
    end

    it 'should return status code created 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'Create action' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }
    #  let!(:event) {Finder.create(release: "2008", duration: "200", rating: ["5", "10"], user_id: "1")}
    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }

    before do
        sample_body = { "lunch": {
    "localisation": "Saint Gilles",
    "distance": 35_000,
    "price": [1,4],
    "attendees": ['TestUser']
   }}

      post 'http://localhost:3000/api/v1/lunches', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    it "should have the same restaurant's name and localisation" do
      json_response = JSON.parse(response.body)
      expect(json_response['restaurants'][0]['restaurant_city']).to eq('Saint-Gilles')
      expect(json_response['restaurants'][0]['restaurant_name']).to eq("La Bottega Della Pizza")

    end

    it 'should return status code created 201' do
      expect(response).to have_http_status(201)
    end
  end
end
