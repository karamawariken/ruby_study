module Api
  class UsersController < ApplicationController
    skip_before_filter :verify_authenticity_token
    before_action :restrict_access


    #curl -D - -X POST http://localhost:3000/api/users -H 'Content-Type: application/json' -H 'Authorization:{"token":"8e04fff527e9e1dfbd901ca8d730b84"}' -d '{"name":"テスト121", "email": "test121@gmail.com", "password": "123456", "password_confirmation":"123456"}'
    def create
      json_parse_request_body = JSON.parse(request.body.read)
      @user = User.new(json_parse_request_body)
      puts @user.inspect
      if @user.save
        # :ok == 200
        head :ok
      else
        # :bad_request == 400
        head :bad_request
      end
    end


    #curl http://localhost:3000/api/users/1 -H 'Content-Type: application/json' -H 'Authorization:{"token":"8e04fff527e9e1dfbd901ca8d730b84"}'
    def show
      @user = User.find(params[:id])
      render json: @user
    end

    def update
      # puts 'hey'
      # json_parse_request_body = JSON.parse(request.body.read)
      # puts json_parse_request_body
      # @user = User.find_by(:id => json_parse_request_body[:id] )
      # puts @user

      # if @user.save
      #   # :ok == 200
      #   head :ok
      # else
      #   # :bad_request == 400
      #   head :bad_request
      # end
    end

  private
    #headerに 'Authorization:{"token":"access_token"}'あるかで判断
    def restrict_access
      if request.headers[:HTTP_AUTHORIZATION]
        access_token = JSON.parse(request.headers[:HTTP_AUTHORIZATION])
        ApiKey.find_by(access_token: access_token["token"])
      else
        flash[:error] = "Can't access page"
        redirect_to root_url
      end
    end
  end
end

