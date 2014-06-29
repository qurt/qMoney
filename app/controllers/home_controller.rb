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
      operations = Operation.where('operations.created_at >= ?', start_date).order(created_at: :desc)
    elsif account > 0 && category == 0
      operations = Account.find(account).operations.where('created_at >= ?', start_date).order(created_at: :desc)
    elsif account == 0 && category > 0
      operations = Category.find(category).operations.where('created_at >= ?', start_date).order(created_at: :desc)
    else
      operations = Operation.where(category_id: category, account_id: account).order(created_at: :desc)
    end
    operations
  end
end
