# frozen_string_literal: true

RSpec.describe 'Preference Error Handeling:', type: :request do
  describe 'Distance params greater than 39_999 meters' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }
    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }

    before do
      sample_body = { "preference": {
        "name": '999',
        "taste": %w[
          Italian
          Lebanese
          Japanese
          Belgian
        ]
      } }

      post 'http://localhost:3000/api/v1/preferences', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }

      sample_body = { "preference": {
        "name": '999',
        "taste": %w[
          Italian
          Lebanese
          Japanese
          Belgian
        ]
      } }

      post 'http://localhost:3000/api/v1/preferences', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    error = { 'errors' => ['Name already in use'] }

    it 'returns an error message' do
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(error)
    end

    it "returns status code 'Unprocessable Entity' 422" do
      expect(response).to have_http_status(422)
    end
  end

  describe 'Empty taste array' do
    let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }
    let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }

    before do
      sample_body = { "preference": {
        "name": '999',
        "taste": []
      } }

      post 'http://localhost:3000/api/v1/preferences', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
    end
    error = { 'error' => 'Taste array is empty' }
    it 'returns an error message' do
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(error)
    end

    it "returns status code 'not found' 404" do
      expect(response).to have_http_status(404)
    end
  end
end
