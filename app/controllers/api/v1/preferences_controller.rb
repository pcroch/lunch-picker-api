# frozen_string_literal: true

module Api
  module V1
    class PreferencesController < Api::V1::BaseController
      # before_action :authenticate_user!, except: [:create, :index]
      acts_as_token_authentication_handler_for User, except: %i[index show]
      before_action :set_preference, only: %i[show update destroy]
        before_action :controller_validation, only: [:create]
      def index
        @preferences = policy_scope(Preference)
      end

      def show; end

      def update
        # if @preference.where(name: params[:id]).update_all(product_params)
        if @preference.update(preference_params)
          render :show
        else
          render_error
        end
      end

      def create
        @preference = Preference.new(preference_params)
        @preference.user = current_user
        authorize @preference
        if @preference.save
          render :show, status: :created
        else
          render_error
        end
      end

      def destroy
        @preference.destroy
        head :no_content
        # No need to create a `destroy.json.jbuilder` view
      end

      private

      def set_preference
        # @preference = preference.where(name: params[:id])
        @preference = Preference.find(params[:id])
        authorize @preference  # For Pundit
      end

      def preference_params
        params.require(:preference).permit(:name, :user_id, :lunch_id, taste: [])
      end

      def render_error
        render json: { errors: @preference.errors.full_messages },
               status: :unprocessable_entity
      end

      def controller_validation
      if preference_params["taste"].empty? || preference_params["taste"]== [""]
         empty_attendees_array

      end
  end
    end
  end
end
