class StakesController < ApplicationController
  skip_before_action :authorized

  def index
    @user = current_user
    if @user
      @stakes = @user.stakes
      render json: StakeSerializer.new(@stake).to_serialized_json
    else
      render json: {message: "There isn't logged in user"}
    end
  end

  def create
    @user = current_user
    if stake_params[:stake].empty?
      @stake = Stake.all[rand(Stake.count)]
      @user.stakes << @stake
    else
      @stake = Stake.find_by(address: stake_params[:stake])
      @user.stakes << @stake
    end
    if @stake
      render json: {success: true}
    else
      render json: {success: false}
    end
  end

  def delete
  end

  private

  def stake_params
    params.permit(:user_id, :stake)
  end
end