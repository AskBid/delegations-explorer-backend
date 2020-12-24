class PoolsController < ApplicationController
  skip_before_action :authorized

  def index
    @user = current_user
    @pools = @user.followed_pools if @user
    render json: @pools, only: [:ticker, :id]
  end

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

  def destroy
    @user = current_user
    if @user
      @user.followed_pools.delete(params[:id])
      @user.save
      render json: {success: true}
    end
  end

  private

  def pool_params
    params.permit(:user_id, :pool, :id)
  end
end