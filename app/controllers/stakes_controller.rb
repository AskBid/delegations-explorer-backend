class StakesController < ApplicationController
  skip_before_action :authorized

  def index
    binding.pry
    @user = current_user
    if @user
      @stakes = @user.stakes
      render json: @stakes 
    end
    render json: {message: "There isn't logged in user"}
  end

  def create
    binding.pry 
    render json: {success: 'data was sent from create'}
  end

  private

  def stake_params
    params.permit(:user_id)
  end
end