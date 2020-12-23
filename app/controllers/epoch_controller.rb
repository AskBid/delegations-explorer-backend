class EpochController < ApplicationController
	skip_before_action :authorized

	def info
		max = ActiveStake.maximum('epochno')
		min = ActiveStake.minimum('epochno')
		render json: {max: max, min: min}
	end
end