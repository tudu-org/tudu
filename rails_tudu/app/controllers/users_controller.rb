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

  def create
    @user = User.new(params[:user])

    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'Welcome'
    end

    respond_to do |format|
      if @user.valid?
        format.html {

        }
        format.json {
          render json: @user
        }
      else
        format.html {

        }
        format.json {
          render json: @user, status: 400
        }
      end
    end
  end
end