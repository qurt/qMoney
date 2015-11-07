class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    before_action :auth

    protected

    def auth
        redirect_to login_url unless User.find_by(id: session[:user_id])
    end
end
