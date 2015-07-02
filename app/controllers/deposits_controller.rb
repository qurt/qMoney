class DepositsController < ApplicationController
  # Добавление начисленных процентов ко вкладу
  def add_percentage
    deposit = Account.find(params[:id])
    deposit.value += params[:percentage]
    if deposit.save
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
