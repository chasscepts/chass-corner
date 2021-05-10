class SessionsController < ApplicationController
  def new
    @user = User.new
    init_page_name 'Sign In'
  end

  def create
    user = User.find_by_name(params[:name])
    if user.nil?
      redirect_to new_session_path, alert: 'Username not found'
    else
      session[:current_user_id] = user.id
      redirect_to root_path, notice: 'You are successfully logged in'
    end
  end

  def destroy
    session.delete(:current_user_id)
    redirect_to root_path
  end
end
