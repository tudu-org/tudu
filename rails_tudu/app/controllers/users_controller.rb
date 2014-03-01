class UsersController < ApplicationController
	def index
		@users = User.order(:email)
	end
	def new
		@user = User.new
	end
	def create
		@user = User.new(params[:user])
		respond_to do |format|
			if @user.save
				format.html { redirect_to :home,
					notice: "User #{@user.email} was successfully created." }
				format.json { render action: 'show', 
					status: :created, location: @user }
			else
				format.html { render action: 'new'}
				format.json { render json: @user.errors,
					status: :unprocessable_entity }
			end
		end
	end
	def update
		respond_to do |format|
			if @user.update(params[:user])
				format.html { redirect_to :home,
					notice: "User #{@user.email} was successfully updated." }
				format.json { head :no_content }
			else
				format.html { render action: :edit }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end
end