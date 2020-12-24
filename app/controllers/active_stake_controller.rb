class ActiveStakeController < ApplicationController
  def index
  	epochno = params.permit(:epochno)[:epochno]
  	@user = current_user
  	@stakes = @user.active_stakes.by_epochno(epochno)

  	render json: ActiveStakeSerializer.new(@stakes).to_serialized_json
  end
end
