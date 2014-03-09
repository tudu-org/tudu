class SessionsController < ApplicationController
  skip_before_action :authorize
  
  def new
  end

  def create
  	user = User.find_by(email: params[:email])
  	if user and user.authenticate(params[:password])
  		session[:user_id] = user.id
      if request.format == :json
        render json: user
        return
      end
  		redirect_to home_path
  	else
      if request.format == :json
        render json: 'Bad email/password', status: 403
        return
      end
  		redirect_to login_path
  	end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to login_path, notice: "Logged out"
  end
end
