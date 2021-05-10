class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  helper_method :current_user

  helper_method :current_page

  def authenticate_user!
    if current_user.nil?
      redirect_to new_session_path, alert: 'Please Log in to continue'
    end
  end

  private

    def current_user
      @current_user ||= session[:current_user_id] && User.find_by(id: session[:current_user_id])
    end

    def current_page
      @current_page ||= 'Home'
    end

    def set_page(page)
      @current_page = page
    end

    def handle_record_not_found
      render '404_page', status: 404
    end
end
