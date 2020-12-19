class UsersController < ApplicationController
  skip_before_action :authorized

  def create
  	@user = User.find_by(username: user_params[:username])
  	if @user && !@user.authenticate(user_params[:password])
  		@user.errors.messages[:password] = "Wrong password."
      @user.errors.messages[:username] = "Username exist. (#{@user.username})"
      render json: {errors: @user.errors.messages}
  	elsif !@user
	  	@user = User.new(user_params)
       if !@user.save
          render json: {errors: @user.errors.messages}
       else
          render_user
       end
    else
      render_user
    end
  end

  private

  def render_user
    @token = encode_token(user_id: @user.id)
    render json: UserSerializer.new(@user).to_serialized_json(token: @token, errors: @user.errors.messages)
  end

  def user_params
  	params.permit(:username, :password)
  end
end