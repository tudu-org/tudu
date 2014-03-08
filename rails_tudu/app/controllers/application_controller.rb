class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :null_session
  before_action :authorize
  helper_method :current_user


  protected
    def authorize
      if request.format == :json
        if User.find_by(id: session[:user_id])
          return
        end

        unless params[:auth_token] && User.find_by(auth_token: params[:auth_token])
          render json: 'Bad credentials (auth_token param needed)', status: 401
        end

        # early return to say that we are finished
        return
      end

      unless User.find_by(id: session[:user_id])
        redirect_to login_path, notice: "Please Log In"
      end
    end
end
