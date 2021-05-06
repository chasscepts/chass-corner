class ApplicationController < ActionController::Base
  attr_reader :current_user

  helper_method :current_user

  def authenticate!
    if current_user.nil?
      redirect_to new_session_path, alert: 'Use must be signed in to perform action'
    end
  end

  private

    def current_user
      @current_user ||= session[:current_user_id] && User.find_by(id: session[:current_user_id])
    end
end
