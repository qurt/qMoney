# coding: utf-8
class StatisticController < ApplicationController
    def operations
        # Установка параметров из фильтров или параетров по умолчанию
        date_s = Time.now - 30.days
        date_e = Time.now
        date_s = Time.parse(params[:date_s]) if params.key?(:date_s)
        date_e = Time.parse(params[:date_e]).end_of_day if params.key?(:date_e)
        active_c = active_a = 0
        # Выбираем данные из базы
        @operations = Operation.where('operation_date >= ? and operation_date <= ?', date_s, date_e).order('operation_date DESC')
        if params.key?(:c) && params[:c].to_i > 0
            @operations = @operations.where(category_id: params[:c].to_i)
            active_c = params[:c]
        end
        if params.key?(:a) && params[:a].to_i > 0
            @operations = @operations.where(account_id: params[:a].to_i)
            active_a = params[:a]
        end
        # Создаем данные для фильтра
        account_list = Account.all
        categories_list = Category.all
        @filter = {
            date_s: date_s,
            date_e: date_e,
            accounts: account_list,
            categories: categories_list,
            active_c: active_c,
            active_a: active_a
        }
    end

    def average_spending
        now = {
            month: Time.zone.now.month.to_i,
            year: Time.zone.now.year.to_i
        }
        first_date = {}
        first_operation = Operation.order(operation_date: :asc)
        first_operation.each do |item|
            first_date = {
                month: item.operation_date.month.to_i,
                year: item.operation_date.year.to_i
            }
            break
        end

        if now[:year] > first_date[:year]
            month_count = (now[:year] - first_date[:year]) * 12 + now[:month]
        else
            month_count = now[:month] - first_date[:month]
        end

        operations = Operation.where('type = 0').order('operation_date ASC')
        # Считаем доход
        d_operations = Operation.where('type = 1').order('operation_date ASC')
        d_sum = 0
        d_sum_g = {}
        d_operations.each do |d_op|
            if d_op.operation_date.nil?
                d_op.operation_date = d_op.created_at.beginning_of_day
            end
            month = d_op.operation_date.month.to_i
            year = d_op.operation_date.year.to_i
            break if year == now[:year] && month == now[:month]
            if d_sum_g[year].nil?
                d_sum_g[year] = {}
                d_sum_g[year][month] = 0
            else
                d_sum_g[year][month] = 0 if d_sum_g[year][month].nil?
            end
            d_sum_g[year][month] += d_op.value.to_f
            d_sum += d_op.value.to_f
        end

        # Считаем среднюю сумму трат в месяц за все время
        sum = {}
        operations.each do |item|
            if item.operation_date.nil?
                item.operation_date = item.created_at.beginning_of_day
            end
            month = item.operation_date.month.to_i
            year = item.operation_date.year.to_i
            if sum[year].nil?
                sum[year] = {}
                sum[year][month] = 0
            else
                sum[year][month] = 0 if sum[year][month].nil?
            end
            sum[year][month] += item.value.to_f
        end
        # Считаем среднюю сумму трат в месяц за все время, разделенную по категориям
        category_sum = {}
        operations.each do |item|
            month = item.operation_date.month.to_i
            year = item.operation_date.year.to_i
            category_id = item.category_id
            category_title = get_category_title(category_id)
            category_sum[year] = {} if category_sum[year].nil?
            category_sum[year][month] = {} if category_sum[year][month].nil?
            if category_sum[year][month][category_title].nil?
                category_sum[year][month][category_title] = 0
            end
            category_sum[year][month][category_title] += item.value.to_f
        end
        category_average = {}
        category_sum.each do |year, item|
            item.each do |month, category|
                break if year == now[:year] && month == now[:month]
                category.each do |id, data|
                    category_average[id] = 0 if category_average[id].nil?
                    category_average[id] += data.to_f
                end
            end
        end
        average = 0
        category_average.each do |title, value|
            category_average[title] = (value / month_count).round 2
            average += category_average[title]
        end
        # Формируем график, который будет содержать:
        # - Сумму всех трат в месяц
        # - Сумму трат по категориям в месяц
        # Формирование результатат для отправки в шаблон
        d_average = (d_sum / month_count).round 2
        @result = {
            average: average,
            category_average: category_average,
            d_average: d_average
        }
        @chart = graph(sum, category_sum, d_sum_g, first_date)
    end

    private

    # Вспомогательные методы
    def get_category_title(category_id)
        if category_id == 0
            title = 'Без категории'
        else
            category_item = Category.find(category_id)
            title = category_item.title
        end
        title
    end

    def graph(average_sum, average_category, d_sum, first_date)
        series = {
            sum: [],
            cat: {},
            d_sum: []
        }
        average_category.each do |_y, data|
            data.each do |_m, cat|
                cat.each do |id, _value|
                    series[:cat][id] = [] if series[:cat][id].nil?
                end
            end
        end
        now = {
            month: Time.zone.now.month.to_i - 1,
            year: Time.zone.now.year.to_i
        }
        if now[:month] == 0
            now[:month] = 12
            now[:year] -= 1
        end
        x_axis = []
        y = first_date[:year]
        m = first_date[:month]
        while y <= now[:year]
            while m <= 12
                break if y == now[:year] && m > now[:month]
                x_axis << m.to_s + '.' + y.to_s

                if average_sum[y].nil? || average_sum[y][m].nil?
                    series[:sum] << 0
                else
                    series[:sum] << average_sum[y][m]
                end

                if d_sum[y].nil? || d_sum[y][m].nil?
                    series[:d_sum] << 0
                else
                    series[:d_sum] << d_sum[y][m]
                end

                series[:cat].each do |id, _value|
                    if average_category[y].nil? || average_category[y][m].nil? || average_category[y][m][id].nil?
                        series[:cat][id] << 0
                    else
                        series[:cat][id] << average_category[y][m][id].to_f
                    end
                end

                m += 1
            end
            y += 1
            m = 1
        end

        chart = LazyHighCharts::HighChart.new('graph') do |f|
            f.chart(defaultSeriesType: 'spline')
            f.title(text: '')
            f.x_axis(categories: x_axis)
            f.y_axis(min: 0)
            series.each do |name, value|
                if name.to_s == 'cat'
                    value.each do |title, sum|
                        f.series(name: title.to_s, yAxis: 0, data: sum)
                    end
                elsif name.to_s == 'sum'
                    f.series(name: 'Сумма', yAxis: 0, data: value)
                elsif name.to_s == 'd_sum'
                    f.series(name: 'Доход', yAxis: 0, data: value)
                end
            end
            f.plot_options(
                spline: {
                    point_start: 0,
                    marker: {
                        enabled: false
                    }
                }
            )
            f.legend(
                align: 'center',
                layout: 'horizontal'
            )
        end

        chart
    end
end
