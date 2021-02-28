# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Lunch Error Handeling:', type: :request do
  describe 'Distance params greater than 39_999 meters' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }
    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }

    before do
      sample_body = { "lunch": {
        "localisation": 'Saint Gilles',
        "distance": 380_000_000,
        "price": [1, 4],
        "attendees": ['TestUser']
      } }

      post 'http://localhost:3000/api/v1/lunches', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    error = { 'error' => 'Distance is invalid' }

    it 'returns an error message' do
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(error)
    end

    it "returns status code 'not found' 404" do
      expect(response).to have_http_status(404)
    end
  end

  describe 'When distance params is a string' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }
    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }

    before do
      sample_body = { "lunch": {
        "localisation": 'Saint Gilles',
        "distance": 'string',
        "price": [1, 4],
        "attendees": ['TestUser']
      } }

      post 'http://localhost:3000/api/v1/lunches', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    error = { 'error' => 'Distance is invalid' }

    it 'returns an error message' do
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(error)
    end

    it "returns status code 'not found' 404" do
      expect(response).to have_http_status(404)
    end
  end

  describe 'When distance params is zero' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }

    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }

    before do
      sample_body = { "lunch": {
        "localisation": 'Saint Gilles',
        "distance": 0,
        "price": [1, 4],
        "attendees": ['TestUser']
      } }

      post 'http://localhost:3000/api/v1/lunches', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    error = { 'error' => 'Distance is invalid' }

    it 'returns an error message' do
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(error)
    end

    it "returns status code 'not found' 404" do
      expect(response).to have_http_status(404)
    end
  end

  describe 'Same numbers in the price range' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }

    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }

    before do
      sample_body = { "lunch": {
        "localisation": 'Saint Gilles',
        "distance": 35_000,
        "price": [1, 1],
        "attendees": ['TestUser']
      } }

      post 'http://localhost:3000/api/v1/lunches', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    it 'should create a lunch anyway' do
      json_response = JSON.parse(response.body)
      expect(json_response['restaurants'][0]['restaurant_city']).to eq('Saint-Gilles')
      expect(json_response['restaurants'][0]['restaurant_name']).to eq('Il Sapore Della Dolce Vita')
    end

    it "returns status code 'created' 201" do
      expect(response).to have_http_status(201)
    end
  end

  describe 'Price range length is bigger than two' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }

    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }

    before do
      sample_body = { "lunch": {
        "localisation": 'Saint Gilles',
        "distance": 35_000,
        "price": [1, 2, 3],
        "attendees": ['TestUser']
      } }

      post 'http://localhost:3000/api/v1/lunches', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    it 'should use only the max and min number of the array' do
      json_response = JSON.parse(response.body)
      expect(json_response['restaurants'][0]['restaurant_city']).to eq('Saint-Gilles')
      expect(json_response['restaurants'][0]['restaurant_name']).to eq('La Bottega Della Pizza')
    end

    it "returns status code 'created' 201" do
      expect(response).to have_http_status(201)
    end
  end

  describe 'Only one number in the price range' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }

    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }

    before do
      sample_body = { "lunch": {
        "localisation": 'Saint Gilles',
        "distance": 35_000,
        "price": [1],
        "attendees": ['TestUser']
      } }

      post 'http://localhost:3000/api/v1/lunches', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    it 'should create a lunch anyway' do
      json_response = JSON.parse(response.body)
      expect(json_response['restaurants'][0]['restaurant_city']).to eq('Saint-Gilles')
      expect(json_response['restaurants'][0]['restaurant_name']).to eq('Il Sapore Della Dolce Vita')
    end

    it "returns status code 'created' 404" do
      expect(response).to have_http_status(201)
    end
  end

  describe 'Empty price range' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }

    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }

    before do
      sample_body = { "lunch": {
        "localisation": 'Saint Gilles',
        "distance": 35_000,
        "price": [],
        "attendees": ['TestUser']
      } }

      post 'http://localhost:3000/api/v1/lunches', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    error = { 'errors' => ['Price range is invalid'] }

    it 'returns an error message' do
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(error)
    end

    it "returns status code 'Unprocessable Entity' 422" do
      expect(response).to have_http_status(422)
    end
  end

  describe 'Empty attendees array' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }

    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }

    before do
      sample_body = { "lunch": {
        "localisation": 'Saint Gilles',
        "distance": 35_000,
        "price": [''],
        "attendees": ['']
      } }

      post 'http://localhost:3000/api/v1/lunches', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    error = { 'error' => 'Attendees array is empty' }
    it 'returns an error message' do
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(error)
    end

    it "returns status code 'not found' 404" do
      expect(response).to have_http_status(404)
    end
  end
  describe 'Delete a lunch without the authorization' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }
    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }
    let!(:user2) { User.create(email: 'test2@test.test', password: 'testest', authentication_token: 'KdapjiYikjusBtghNieF', id: 2) }
    let!(:pref2) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian French Belgian]) }
    let!(:lunch) { Lunch.create(id: 1000, localisation: 'Arlon', distance: 1000, price: [1, 4], user_id: '1') }
    let!(:lunch2) { Lunch.create(id: 1, localisation: 'Arlon', distance: 1000, price: [1, 4], user_id: '2') }
    before do
      delete 'https://api-lunch-picker.herokuapp.com/api/v1/lunches/1', headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end

    error = { 'error' => 'Unauthorized LunchPolicy.destroy?' }

    it 'returns an error message' do
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(error)
    end

    it "returns status code 'Unauthorized' 401" do
      expect(response).to have_http_status(401)
    end
  end
end
