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
  def average_spending
    operations = Operation
      .select('SUM(value) as op_sum, category_id, type, date(operation_date) as op_date')
      .group('op_date, category_id, type')
      .where('type = 0')

    # Считаем среднюю сумму трат в месяц за все время
    sum = {}
    operations.each do |item|
      month = item.op_date.month.to_i
      year = item.op_date.year.to_i
      if sum[year].nil?
        sum[year] = {}
        sum[year][month] = 0
      else
        if sum[year][month].nil?
          sum[year][month] = 0
        end
      end
      sum[year][month] += item.op_sum.to_f
    end
    average = 0
    month_count = 0
    sum.each do |y, item|
      month_count += item.size
      item.each do |m, item_month|
        average += item_month
      end
    end
    average = average / month_count
    # Считаем среднюю сумму трат в месяц за все время, разделенную по категориям
    category_sum = {}
    operations.each do |item|
      month = item.op_date.month.to_i
      year = item.op_date.year.to_i
      category_id = item.category_id
      if category_sum[category_id].nil?
        category_sum[category_id] = {
            :title => get_category_title(category_id),
            :data => {}
        }
      end
      if category_sum[category_id][:data][year].nil?
        category_sum[category_id][:data][year] = {}
      end
      if category_sum[category_id][:data][year][month].nil?
        category_sum[category_id][:data][year][month] = 0
      end
      category_sum[category_id][:data][year][month] += item.op_sum
    end
    category_average = {}
    category_sum.each do |id, item|
      category_average[id] = {
        :title => category_sum[id][:title],
        :average => 0
      }
      item[:data].each do |y, year_data|
        year_data.each do |m, month_data|
          category_average[id][:average] += month_data
        end
      end
    end
    category_average.each do |id, c_average|
      c_average[:average] = c_average[:average] / month_count
    end
    # Формируем график, который будет содержать:
    # - Сумму всех трат в месяц
    # - Сумму трат по категориям в месяц
    # Формирование результатат для отправки в шаблон
    @result = {
      :average => average,
      :category_average => category_average
    }
  end

  private
  # Вспомогательные методы
  def get_category_title(category_id)
    category_item = Category.find(category_id)
    title = category_item.title
  end
end
