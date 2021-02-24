
require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Integration testing', type: :request do
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

    let!(:user) { User.create(email: 'test@test.test', password: 'testest', user_name: 'TestUser', authentication_token: 'KdapjiY6vz-sBkKmNabc', id: 1) }
    #  let!(:event) {Finder.create(release: "2008", duration: "200", rating: ["5", "10"], user_id: "1")}
    let!(:pref) { Preference.create(user_id: 1, name: 'Test', content: %w[Action Comedy Horror]) }
    let!(:event) { Finder.create(id: 1, release: 2020, duration: 200, rating: [0, 10], user_id: '1') }

    before do
      get 'http://localhost:3000/api/v1/finders/1'
    end
    it 'should have the same id and release year' do
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(1)
      expect(json_response['release']).to eq('2020')
    end

    it 'should return status code created 200' do
      expect(response).to have_http_status(200)
    end
  end

  # post heder and  body or params
  describe 'Create action' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', user_name: 'TestUser', authentication_token: 'KdapjiY6vz-sBkKmNabc', id: 1) }
    #  let!(:event) {Finder.create(release: "2008", duration: "200", rating: ["5", "10"], user_id: "1")}
    let!(:pref) { Preference.create(user_id: 1, name: 'Test', content: %w[Action Comedy Horror]) }

    before do
      sample_body = { "finder": {
        "release": 2020,
        "duration": 160,
        "attendees": ['Test'],
        "rating": [0, 10]
      } }

      post 'http://localhost:3000/api/v1/finders', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    it 'should have the same title and vote average' do
      json_response = JSON.parse(response.body)
      expect(json_response['movies'][0]['title']).to eq('Wonder Woman 1984')
      expect(json_response['movies'][0]['vote_average']).to eq('7')
    end

    it 'should return status code created 201' do
      expect(response).to have_http_status(201)
    end
  end
end
