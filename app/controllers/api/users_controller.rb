module Api
  class UsersController < ApplicationController
    protect_from_forgery :except => [:create]
    def create
      @user = User.new(user_params)
      if @user.save
        raise @user.inspect
        format.html { redirect_to @user, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @user}
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

    def show
      @user = User.find(params[:id])
      render json: @user
    end


  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

  end
end

