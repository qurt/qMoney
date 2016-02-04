# coding: utf-8
class HomeController < ApplicationController
    def index
        # Проверяем параметры для фильтров. По умолчанию устанавливаем их в 0
        account = 0
        category = 0
        account = params[:a].to_i if params.key?(:a)
        category = params[:c].to_i if params.key?(:c)
        # Get accounts list
        @accounts = Account.order(:name)
        # Get operations list
        operations = get_operations(account, category)
        # Generate day stat data
        @dayStat = {
            :total => 0.0,
            :total_spend => 0.0,
            :balance => 0.0
        }
        todayOperations = Operation.where('operation_date >= ?', Date.today.beginning_of_day)
        todayOperations.each do |item|
            @dayStat[:total_spend] += item.value.to_f if item.type == 0
        end
        @dayStat[:balance] = @dayStat[:total] - @dayStat[:total_spend]
        # Generate categories list from operations
        @accounts_pay = 0
        @categories = {}
        operations.each do |item|
            if item.category_id != 0 && item.type == 0
                if @categories[item.category_id].nil?
                    @categories[item.category_id] = {title: item.category.title, value: 0, color: item.category.color}
                end
                @categories[item.category_id][:value] += item.value.to_f
            end
            @accounts_pay += item.value if item.type == 0
        end
        # Get credits list
        @credits = Credit.where.not(value: 0)
        # Set charts objects
        @categories = @categories.sort_by { |k,v| v[:value] }
        @operations_history = Operation.order('created_at DESC').limit(5)
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
            operations = Operation.where('operations.operation_date >= ?', start_date)
        elsif account > 0 && category == 0
            operations = Account.find(account).operations.where('operation_date >= ?', start_date)
        elsif account == 0 && category > 0
            operations = Category.find(category).operations.where('operation_date >= ?', start_date)
        else
            operations = Operation.where(category_id: category, account_id: account)
        end
        operations
    end
end
