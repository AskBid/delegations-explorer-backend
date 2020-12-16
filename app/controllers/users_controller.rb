class UsersController < ApplicationController
  def create
	  binding.pry
  	user = User.find_by(params.permit(:username))
  	if user && !user.authenticate(params.permit(:password))
  		render json: {error: 'wrong password'}
  	elsif !user
  		binding.pry
	  	user = User.create(params.permit(:username, :password))
	  end
	  render json: UserSerializer.new(user).to_serialized_json
  end
end
