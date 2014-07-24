class StatisticController < ApplicationController
  def operations
    # Установка параметров из фильтров или параетров по умолчанию
    date_s = Time.now - 30.days
    date_e = Time.now
    if params.has_key?(:date_s)
      date_s = Time.parse(params[:date_s])
    end
    if params.has_key?(:date_e)
      date_e = Time.parse(params[:date_e]).end_of_day
    end
    active_c = active_a = 0
    #Выбираем данные из базы
    @operations = Operation.where('operation_date >= ? and operation_date <= ?', date_s, date_e)
    if params.has_key?(:c) && params[:c].to_i > 0
      @operations = @operations.where(:category_id => params[:c].to_i)
      active_c = params[:c]
    end
    if params.has_key?(:a) && params[:a].to_i > 0
      @operations = @operations.where(:account_id => params[:a].to_i)
      active_a = params[:a]
    end
    #Создаем данные для фильтра
    account_list = Account.all
    categories_list = Category.all
    @filter = {
        :date_s     => date_s,
        :date_e     => date_e,
        :accounts   => account_list,
        :categories => categories_list,
        :active_c   => active_c,
        :active_a   => active_a
    }
  end
end
