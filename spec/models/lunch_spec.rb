# # frozen_string_literal: true

# RSpec.describe 'Unit Testing: Error handeling testing when creating an event:', type: :request do
#   describe 'Missing the release params' do
#     let!(:user) { User.create(email: 'test@test.test', password: 'testest', user_name: 'TestUser', authentication_token: 'KdapjiY6vz-sBkKmNabc', id: 1) }
#     let!(:pref) { Preference.create(user_id: 1, name: 'Test', content: %w[Action Comedy Horror]) }

#     before do
#       sample_body = { "finder": {

#         "duration": 200,
#         "attendees": ['Test'],
#         "rating": [0, 10]
#       } }

#       post 'http://localhost:3000/api/v1/finders', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
#     end
#     error = { 'errors' => ['Release : The integer must be a 4 digits', "Release can't be blank"] }

#     it 'returns an error message' do
#       json_response = JSON.parse(response.body)
#       expect(json_response).to eq(error)
#     end

#     it 'returns status code created 422' do
#       expect(response).to have_http_status(422)
#     end
#   end


# end
