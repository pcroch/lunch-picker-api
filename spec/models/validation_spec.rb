# frozen_string_literal: true

# RSpec.describe 'Unit Testing: Error handeling testing when creating an event:', type: :request do
#   describe 'Missing the release params' do
#     let!(:user) { User.create(email: 'test@test.test', password: 'testest', authentication_token: 'KdapjiY6vz-sBkKmNieF', id: 1) }
#     #  let!(:event) {Finder.create(release: "2008", duration: "200", rating: ["5", "10"], user_id: "1")}
#     let!(:pref) { Preference.create(user_id: 1, name: 'TestUser', taste: %w[Italian Lebanese Japanese Belgian]) }

#     before do
#       sample_body = { "lunch": {
#         "localisation": 'Saint Gilles',
#         "distance": 35_000,
#         "price": [1, 4],
#         "attendees": ['TestUser']
#       } }

#       post 'http://localhost:3000/api/v1/lunches', params: sample_body, headers: { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
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
