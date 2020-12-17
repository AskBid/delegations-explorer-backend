class UsersController < ApplicationController
  skip_before_action :authorized

  def create
    binding.pry
  	user = User.find_by(username: user_params[:username])
  	if user && !user.authenticate(user_params[:password])
  		user = nil
  	elsif !user && !user_params[:password].empty?
	  	user = User.create(params.permit(:username, :password))
	  end
    @token = encode_token(user_id: user.id) if user       
    render json: { user: user, jwt: @token }, status: :created
  end

  private

  def user_params
  	params.permit(:username, :password)
  end
end