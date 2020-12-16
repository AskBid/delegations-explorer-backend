class UsersController < ApplicationController
  def create
  	user = User.find_by(username: user_params[:username])
	  # binding.pry
  	if user && !user.authenticate(user_params[:password])
  		user = nil
  	elsif !user
	  	user = User.create(params.permit(:username, :password))
	  end
	  render json: UserSerializer.new(user).to_serialized_json
  end

  private

  def user_params
  	params.permit(:username, :password)
  end
end
