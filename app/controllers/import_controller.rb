class ImportController < ApplicationController
    def operations
    end

    def operations_progress
        list = []
        file = params[:file]
        File.foreach(file.path) do |row|
            item = row.split(';')
            item.each do |field|
                field[0] = '' if field[0] == '"'
                field[-1] = '' if field[-1] == '"'
            end

            operation = {}

            # Дата импортируемой операции
            operation[:date] = item[1].length > 0 ? item[1] : item[0]
            # Определение кошелька
            operation[:account] = findRule('account', item[2]) || nil
            # Сумма
            operation[:value] = item[6].to_f.abs

            list << {
                date: item[1].length > 0 ? item[1] : item[0],
                account: item[2],
                value: item[6].to_f,
                category: item[8],
                category_id: item[9],
                tag: item[10],
                operation: operation
            }
        end
        @list = list
        render "operations_list"
        # flash[:list]
        # redirect_to import_operations_list_path
    end

    def operations_list
        if flash[:list]
            @list = flash[:list]
            respond_to do |format|
              format.html
              format.json { render json: @list }
            end
        else
            redirect_to import_operations_path
        end
    end

    def create_from_list

    end

    private
    def findRule(value)
        rule = ImportRules.where('rule = ?', value)
        return rule if rule
        return false
    end
end
