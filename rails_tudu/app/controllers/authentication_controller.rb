class AuthenticationController < ApplicationController
	before_action :sign_in, except: [:index,:new]

	def sign_in
		@user = User.new
	end
	def new_user
		@user = User.new
	end
	def register
		@user = User.new(params[:user])

		if @user.valid?
			@user.save
			session[:user_id] = @user.id
			flash[:notice] = 'Welcome'
			redirect_to :home
		else
			render :action => "new_user"

		end
	end

	def login
		email = params[:user][:email]
		password = params[:user][:password]
		user = User.authenticate_by_email(email,password)

		if user
			session[:user_id] = user.id
			flash[:notice] = 'Welcome'
			redirect_to :home
		else
			flash.now[:error] = 'Unknown user. Please check your email and password'
			render :action => "sign_in"
		end
	end


end
