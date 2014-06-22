class StatisticController < ApplicationController
  def operations
    # Установка параметров из фильтров или параетров по умолчанию
    date_s = 0
    date_e = 0
    if params.has_key?(:date_s)
      date_s = params[:date_s]
    end
    if params.has_key?(:date_e)
      date_e = params[:date_e]
    end

    #Выбираем данные из базы
    @operations = Operation.where('operation_date >= ? and operation_date <= ?', date_s, date_e)
    if params.has_key?(:c)
      @operations = @operations.where(:category_id => params[:c].to_i)
    end
    if params.has_key?(:a)
      @operations = @operations.where(:account_id => params[:a].to_i)
    end
  end
end
