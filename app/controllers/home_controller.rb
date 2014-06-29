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
        :accounts => get_accounts_chart(@operations)
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
        :margin => [0, 100, 0, 0]
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
    result = {}
    # Выбираем оперции и группируем их по дате и кошельку
    data = operations.select('operations.account_id, SUM(operations.value) as op_sum, date(created_at) as op_date').group('operations.account_id, op_date')
    # Получаем id кошельков, где есть операции
    accounts = operations.group('account_id').count
    # Формируем хэш для аккаунтов
    accounts.each do |id, account|
      result[id] = {}
    end
    # Записываем в кошельки даты с суммами
    data.each do |item|
      result[item.account_id][item.op_date] = item.op_sum
    end
    # Получаем количество дней в текущем месяце
    series = {}
    now = Time.now
    day_in_month = Time.days_in_month(now.month).to_i
    i = 0
    # Формируем массив дат для каждого кошелька
    # Записываем суммы в нужную дату у каждого кошелька
    # ФОрмируем итоговый массив для графика
    result.each do |id, item|
      tmp = Array.new(day_in_month, 0)
      item.each do |x, y|
        x = x.to_s
        tmp_day = DateTime.strptime(x, "%Y-%m-%d")
        tmp_day = tmp_day.day
        tmp[tmp_day + 1] = y
      end
      series[i] = {
          :name => id,
          :data => tmp
      }
      i += 1
    end

    chart = LazyHighCharts::HighChart.new('area') do |f|
      f.chart(
        :type => 'area',
        :height => 300
      )
      f.title(:text => 'Кошельки')
      series.each do |id, item|
        f.series(:name => item[:name], :data => item[:data])
      end
      f.plot_options(
        :area => {
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
