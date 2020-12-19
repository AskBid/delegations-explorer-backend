class SessionsController < ApplicationController
  skip_before_action :authorized

  def restore
    binding.pry
    decoded_token
  end

  private

  def user_params
  	params.permit(:username, :password)
  end
end