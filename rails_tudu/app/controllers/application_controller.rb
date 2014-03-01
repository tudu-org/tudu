class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :null_session
  before_action :authorize
  helper_method :current_user


  protected
    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_path, notice: "Please Log In"
      end
    end

  
end
