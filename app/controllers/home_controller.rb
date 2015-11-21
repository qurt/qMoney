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
        # Generate categories list from operations
        @accounts_pay = 0
        @categories = {}
        operations.each do |item|
            if item.category_id != 0 && item.type == 0
                if @categories[item.category_id].nil?
                    @categories[item.category_id] = {title: item.category.title, value: 0}
                end
                @categories[item.category_id][:value] += item.value.to_f
            end
            @accounts_pay += item.value if item.type == 0
        end
        # Get credits list
        @credits = Credit.where.not(value: 0)
        # Set charts objects
        @categories = @categories.sort_by { |k,v| v[:value] }
        @chart = {
            categories: get_categories_chart(@categories),
            # :accounts => get_accounts_chart(@operations) todo delete?
        }
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

    # @param [Object] categories
    # @return [LazyHighCharts]
    def get_categories_chart(categories)
        data = []
        categories.each do |_id, item|
            data.append [item[:title], item[:value]]
        end
        chart = LazyHighCharts::HighChart.new('pie') do |f|
            f.chart(height: 300,
                    margin: [25, 100, 0, 0])
            f.title(
                text: 'Категории'
            )
            series = {
                type: 'pie',
                name: 'Сумма',
                data: data,
                inner_size: 40
            }
            f.series(series)
            f.legend(
                align: 'right',
                layout: 'vertical',
                width: 100
            )
            f.plot_options(
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            )
        end

        chart
    end
end
