class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      reset_session
      session[:user_id] = user.id
      #log_in user
      redirect_to user
    end
  end

  def destroy
  end
end
