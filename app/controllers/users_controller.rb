class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(name: params[:name])
    if(@user.save)
      session[:current_user_id] = @user.id
      redirect_to root_path, notice: 'Your account was successfully setup'
    else
      render :new
    end
  end
end
