# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include Pundit

      after_action :verify_authorized, except: :index
      after_action :verify_policy_scoped, only: :index

      rescue_from Pundit::NotAuthorizedError,   with: :user_not_authorized
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      private

      def user_not_authorized(exception)
        render json: {
          error: "Unauthorized #{exception.policy.class.to_s.underscore.camelize}.#{exception.query}"
        }, status: :unauthorized
      end

      def not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def empty_request
        render json: { error: 'No restaurant found' }, status: :not_found
      end

      def invalid_distance
        render json: { error: 'Distance is invalid' }, status: :not_found
      end

      def empty_price_array
        render json: { error: 'Price array is empty' }, status: :not_found
      end

      def empty_attendees_array
        render json: { error: 'Attendees array is empty' }, status: :not_found
      end

      def empty_taste_array
        render json: { error: 'Taste array is empty' }, status: :not_found
      end
    end
  end
end
