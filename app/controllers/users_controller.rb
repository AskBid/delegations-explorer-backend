class UsersController < ApplicationController
  skip_before_action :authorized

  def create
  	@user = User.find_by(username: user_params[:username])
  	if @user && !@user.authenticate(user_params[:password])
  		@user.errors.messages[:password] = "Wrong password."
      @user.errors.messages[:username] = "Username exist. (#{@user.username})"
  	elsif !@user
	  	@user = User.create(params.permit(:username, :password))
	  end
    @token = encode_token(user_id: @user.id) if @user
    render json: UserSerializer.new(@user).to_serialized_json(token: @token, errors: @user.errors.messages)
  end

  def show
    @user = current_user
    render json: UserSerializer.new(@user).to_serialized_json
  end

  private

  def user_params
  	params.permit(:username, :password)
  end
end