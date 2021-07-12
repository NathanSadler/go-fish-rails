#require 'rails_helper'
#require_relative 'helpers/sessions_helper'

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  # Figure out why it doesn't see this in sessions_helper later
  def log_in(user)
    session[:user_id] = user.id
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
