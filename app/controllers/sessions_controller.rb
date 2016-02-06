# coding: utf-8
class SessionsController < ApplicationController
    skip_before_filter :verify_authenticity_token
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
                respond_to do |format|
                    format.html { redirect_to home_index_url }
                    format.json { render json: new_session, status: 200 }
                end
            else
                respond_to do |format|
                    format.html { redirect_to login_url }
                    format.json { render json: {:error => 'Непредвиденная ошибка сервера. Попробуйте позже.'}, status: 500 }
                end
            end
        else
            respond_to do |format|
                format.html { redirect_to login_url }
                format.json { render json: {:error => 'Неверная комбинация имени и пароля'}, status: 403 }
            end
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
