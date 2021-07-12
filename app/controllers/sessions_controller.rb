class SessionsController < ApplicationController
  def new
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      reset_session
      log_in user
      redirect_to user
    end
  end

  def create
    render 'new'
  end

  def destroy
  end
end
