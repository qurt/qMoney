class DepositsController < ApplicationController
  # Добавление начисленных процентов ко вкладу
  def add_percentage
    account = Account.find(params[:id])
    account.percentage += params[:percentage].to_d
    if account.save
      redirect_to home_index_url
    end
  end

  # Отображение формы добавления процентов
  def add_percentage_view
    @deposit = Account.find(params[:id])
  end

  # Премещение средств
  def transfer

  end
end
