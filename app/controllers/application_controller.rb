class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    before_action :auth

    protected
    # Проверка авторизации
    def auth
        auth_check = false
        alert = nil
        auth_token = cookies[:auth_token]
        auth_token = params[:token] if params[:token]
        if auth_token
            login = Session.where(:token => auth_token).first
            if login and login.expired_in >= Time.now.to_i
                user = login.user
                session[:user_id] = user.id
                session[:user_name] = user.name
                auth_check = true
                return true
            else
                alert = 'Время сессии истекло. Пожалуйста. войдите снова.'
            end
        end

        respond_to do |format|
            format.html { redirect_to login_url, alert: alert unless auth_check }
            format.json { render json: {:error => 'Auth error'}, status: :unauthorized }
        end
    end
end
