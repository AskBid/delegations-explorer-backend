class PoolsController < ApplicationController
  skip_before_action :authorized

  def create
    @user = current_user
    if pool_params[:pool].empty?
      @pool = Pool.all[rand(Pool.count)]
      @user.followed_pools << @pool
    else
      @stake = Stake.find_by(address: stake_params[:stake])
      @user.followed_pools << @pool
    end
    render json: {success: true}
  end

  private

  def pool_params
    params.permit(:user_id, :pool)
  end
end