class UsersController < ApplicationController
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