class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html {

      }
      format.json {
        render json: @user
      }
    end
  end

  def by_email
    @user = User.find_by email: params[:email]

    respond_to do |format|
      format.html {

      }
      format.json {
        render json: @user
      }
    end
  end
end