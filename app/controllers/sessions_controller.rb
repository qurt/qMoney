class SessionsController < ApplicationController
  skip_before_action :auth

  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:user_name] = user.name
      redirect_to home_index_url
    else
      redirect_to login_url, alert: 'Неверная комбинация имени и пароля'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_name] = nil
    redirect_to login_url
  end
end
