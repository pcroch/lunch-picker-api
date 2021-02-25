
require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Integration testing for the Preference controller', type: :request do
  #  event = Finder.new(release: "2008", duration: "200", rating: ["5", "10"], user_id: "1")
  #  event.save
  # Preference.create(user_id: 2, name: "Bob", finder_id: 1, content: ["Adventure", "Family", "Horror"])
  # Test suite for GET /articles
  describe 'Index action' do
    # make HTTP get request before each example
    before do
      get 'http://localhost:3000/api/v1/preferences'
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
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }
    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian], id: 1) }


    before do
      get 'http://localhost:3000/api/v1/preferences/1'
    end
    it 'should have 4 categories of tastes' do
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq("TestUser")
      expect(json_response['taste']).to eq(["Italian", "Lebanese", "Japanese", "Belgian"])
    end

    it 'should return status code created 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'Create action' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }
    # let!(:lunch) { Lunch.create(id: 1, localisation: "Arlon", distance: 1000, price: [1, 4], user_id: '1') }

    before do
        sample_body = { "preference": {
        "name": "TestUser",
        "taste": [
                    "Italian",
                    "Lebanese",
                    "Japanese",
                    "Belgian"
                ]
       } }

      post 'http://localhost:3000/api/v1/preferences', params: sample_body, headers: {'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    it "should have the same name" do
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('TestUser')
      expect(json_response['taste']).to eq(["Italian", "Lebanese", "Japanese", "Belgian"])

    end

    it 'should return status code created 201' do
      expect(response).to have_http_status(201)
    end
  end
end
