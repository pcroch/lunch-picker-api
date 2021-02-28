# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Integration testing for the Preference controller', type: :request do
  describe 'Index action' do
    before do
      get 'http://localhost:3000/api/v1/preferences'
    end

    it 'should return list of events' do
      expect(response.body).not_to be_empty
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
      expect(json_response['name']).to eq('TestUser')
      expect(json_response['taste']).to eq(%w[Italian Lebanese Japanese Belgian])
    end

    it 'should return status code created 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'Create action' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }

    before do
      sample_body = { "preference": {
        "name": 'TestUser',
        "taste": %w[
          Italian
          Lebanese
          Japanese
          Belgian
        ]
      } }

      post 'http://localhost:3000/api/v1/preferences', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    it 'should have the same name' do
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('TestUser')
      expect(json_response['taste']).to eq(%w[Italian Lebanese Japanese Belgian])
    end

    it 'should return status code created 201' do
      expect(response).to have_http_status(201)
    end
  end

  describe 'Update action' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }
    let!(:preference) { Preference.create(user_id: 1, name: 'Pierre', taste: %w[Italian Lebanese Japanese Belgian], id: 1) }

    before do
      sample_body = { "preference": {
        "name": 'TestUser',
        "taste": %w[
          French
        ]
      } }

      patch 'http://localhost:3000/api/v1/preferences/1', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    it 'should have the same name' do
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('TestUser')
      expect(json_response['taste']).to eq(%w[French])
    end

    it 'should return status code created 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'Destroy action' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }
    let!(:preference) { Preference.create(user_id: 1, name: 'Pierre', taste: %w[Italian Lebanese Japanese Belgian], id: 2) }
    before do
      delete 'http://localhost:3000/api/v1/preferences/2', headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end

    it 'should return status code created 204' do
      expect(response).to have_http_status(204)
    end
  end
end
