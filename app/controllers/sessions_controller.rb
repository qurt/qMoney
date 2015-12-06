# coding: utf-8
class SessionsController < ApplicationController
    skip_before_action :auth

    def new
    end

    def create
        user = User.find_by(name: params[:name])
        if user && user.authenticate(params[:password])
            # Успешная авторизация
            expired = Time.now.to_i + 3600
            logger.debug params
            if params[:remember_me]
                expired = Time.now.to_i + 30*24*60*60
            end
            token = generate_token(user.id)
            new_session = Session.new({:user_id => user.id, :token => token, :expired_in => expired})
            if new_session.save
                cookies[:auth_token] = {:value => new_session.token, :expired => new_session.expired_in}
                session[:user_id] = user.id
                session[:user_name] = user.name
                redirect_to home_index_url
            else
                redirect_to login_url, alert: 'Непредвиденная ошибка сервера. Попробуйте позже.'
            end
        else
            redirect_to login_url, alert: 'Неверная комбинация имени и пароля'
        end
    end

    def destroy
        session[:user_id] = nil
        session[:user_name] = nil
        session[:last_account] = nil
        redirect_to login_url
    end

    private

    def generate_token(user_id)
        now = Time.now.to_i
        sha256 = Digest::SHA256.new
        token = sha256.hexdigest user_id.to_s + now.to_s
        return token.to_s
    end
end
