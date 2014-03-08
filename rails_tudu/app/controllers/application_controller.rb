class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :null_session
  before_action :authorize
  helper_method :current_user


  protected
    def authorize
      unless User.find_by(id: session[:user_id])
        unless params[:auth_token] && User.find_by(auth_token: params[:auth_token])
          if request.format == "json"
            render json: 'Bad credentials (auth_token needed)', status: 401
            return
          end
        else
          return
        end
        redirect_to login_path, notice: "Please Log In"
      end
    end
end
