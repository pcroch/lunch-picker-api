class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # acts_as_token_authentication_handler_for User
end
