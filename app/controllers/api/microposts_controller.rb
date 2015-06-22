module Api
  class MicropostsController < ApplicationController

    def show
      @microposts = Micropost.find(params[:id])
      render json: @microposts
    end
  end
end

