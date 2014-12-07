class HomeController < ApplicationController
  def index
    # Проверяем параметры для фильтров. По умолчанию устанавливаем их в 0
    account = 0
    category = 0
    if params.has_key?(:a)
      account = params[:a].to_i
    end
    if params.has_key?(:c)
      category = params[:c].to_i
    end
    # Get accounts list
    @accounts = Account.order(:name)
    # Get operations list
    @operations = get_operations(account, category)
    # Generate categories list from operations
    @categories = {}
    @operations.each do |item|
      if item.category_id != 0 and item.type == 0
        if @categories[item.category.id].nil?
          @categories[item.category.id] = {title: item.category.title, value: item.value.to_i}
        else
          @categories[item.category.id][:value] += item.value.to_i
        end
      end
    end
    # Get credits list
    @credits = Credit.where.not(value:0)
    # Set charts objects
    @chart = {
        :categories => get_categories_chart(@categories),
       # :accounts => get_accounts_chart(@operations) todo delete?
    }
    @operations = @operations.order('created_at DESC').limit(5)
  end

  private
  ###
  # Получаем операции с начала месяца по текущий момент
  # @param [Integer] account
  # @param [Integer] category
  # @return [Object]
  ###
  def get_operations(account, category)
    now = Time.now
    start_date = Time.mktime(now.year, now.month)
    if account == 0 && category == 0
      operations = Operation.where('operations.created_at >= ?', start_date)
    elsif account > 0 && category == 0
      operations = Account.find(account).operations.where('created_at >= ?', start_date)
    elsif account == 0 && category > 0
      operations = Category.find(category).operations.where('created_at >= ?', start_date)
    else
      operations = Operation.where(category_id: category, account_id: account)
    end
    operations
  end

  # @param [Object] categories
  # @return [LazyHighCharts]
  def get_categories_chart(categories)
    data = []
    categories.each do |id, item|
      data.append [item[:title], item[:value]]
    end
    chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({
        :height => 300,
        :margin => [25, 100, 0, 0]
      })
      f.title(
        :text => 'Категории'
      )
      series = {
          :type => 'pie',
          :name => 'Сумма',
          :data => data,
          :inner_size => 40
      }
      f.series(series)
      f.legend(
        :align => 'right',
        :layout => 'vertical',
        :width => 100
      )
      f.plot_options(
        :pie => {
          :allowPointSelect=>true,
          :cursor=>'pointer',
          :dataLabels=>{
            :enabled=>false
          },
          :showInLegend => true
        }
      )
    end
  end

  def get_accounts_chart(operations)
    data = {}
    now = Time.now
    first_day = '01.' + now.month.to_s + '.'+ now.year.to_s
    operations = operations.where('type = 0').where('operation_date >= ?', first_day)
    # Выбираем оперции и группируем их по дате и кошельку
    data[:all] = {}
    operations.each do |item|
      if item.operation_date.nil?
        item.operation_date = Time.zone.now
      end
      cur_day = item.operation_date.day
      account_id = item.account_id
      if item.account_id.nil?
        account_id = 1
      end
      if data[account_id].nil?
        data[account_id] = {}
      end
      if data[account_id][cur_day].nil?
        data[account_id][cur_day] = 0
      end
      data[account_id][cur_day] += item.value.to_f
      if data[:all][cur_day].nil?
        data[:all][cur_day] = 0
      end
      data[:all][cur_day] += item.value.to_f
    end

    # Получаем количество дней в текущем месяце
    series = {}
    day_in_month = Time.days_in_month(now.month).to_i
    i = 0
    # Формируем массив дат для каждого кошелька
    # Записываем суммы в нужную дату у каждого кошелька
    # ФОрмируем итоговый массив для графика
    data.each do |id, item|
      tmp = Array.new(day_in_month, 0)
      item.each do |x, y|
        tmp[x - 1] = y.to_f
      end
      if id.nil? || id.to_s == 'all'
        series[i] = {
            :name => 'Сумма',
            :data => tmp
        }
      else
        account = Account.find(id)
        series[i] = {
            :name => account.name,
            :data => tmp
        }
      end
      i += 1
    end

    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart({
        :defaultSeriesType => 'spline',
        :height => 350
      })
      f.title(:text => 'Кошельки')
      f.y_axis({:min => 0, :max=> 5000})
      series.each do |id, item|
        data = item[:data]
        f.series(:name => item[:name], :yAxis => 0, :data => data)
      end
      f.plot_options(
        :spline => {
          :point_start => 1,
          :marker => {
            :enabled => false
          }
        }
      )
      f.legend(
        :align => 'center',
        :layout => 'horizontal'
      )
    end
  end
end
