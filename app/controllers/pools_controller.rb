class PoolsController < ApplicationController
  skip_before_action :authorized

  def index
    if params[:user_id]
      @user = current_user
      if @user
        @pools = @user.followed_pools
        Pool.current_epoch = params[:epochno]
        render json: @pools, only: [:ticker, :id, :poolid], methods: :reward_ratio
      else
        render json: {message: 'no user found.'}
      end
    else
      @pools = Pool.all
      render json: @pools, only: [:ticker]
    end
  end

  def create
    @user = current_user
    @ticker = pool_params[:ticker]
    if @ticker.empty?
      @pool = Pool.all[rand(Pool.count)]
      @user.followed_pools << @pool
    else
      if @ticker.length < 6
        @pool = Pool.find_by(ticker: @ticker)
      elsif @ticker.include?('pool')
        @pool = Pool.find_by(poolid: @ticker)
      end
      @user.followed_pools << @pool if @pool  
    end
    render json: {message: 'Pool POST action completed.'}
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
    params.permit(:user_id, :ticker, :id)
  end
end