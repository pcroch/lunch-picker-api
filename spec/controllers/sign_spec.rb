# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Integration testing User Controller', type: :request do
  # Test suite for GET /articles
  describe 'Sign up succesfull' do
    before do
      post 'http://localhost:3000/api/v1/sign_up', params: {
        "user": {
          "email": '123456@example.com',
          "password": 'password',
          "password_confirmation": 'password'
        }
      }
    end

    it 'returns a succesfull sign up' do
      json_response = JSON.parse(response.body)
      expect(json_response['messages']).to eq('Sign Up Successfully')
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'Sign up with missing password confirmation' do
    before do
      post 'http://localhost:3000/api/v1/sign_up', params: {
        "user": {
          "email": '1234567@example.com',
          "password": 'password',
          "password_confirmation": ''
        }
      }
    end

    it 'returns an error: Sign Up Failded' do
      json_response = JSON.parse(response.body)
      expect(json_response['messages']).to eq('Sign Up Failded')
    end

    it 'returns status code 422' do
      expect(response).to have_http_status(422)
    end
  end
end
