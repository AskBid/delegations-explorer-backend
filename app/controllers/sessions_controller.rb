class SessionsController < ApplicationController
  skip_before_action :authorized

  def restore
    @user = current_user
    render_user
  end

  private

  def user_params
  	params.permit(:username, :password)
  end
end