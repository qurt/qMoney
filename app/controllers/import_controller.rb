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
            ###
            # Status list
            # 0 - Нет совпадений
            # 1 - Частичное совпадение
            # 2 - Полное совпадение
            ###
            operation[:status] = 0

            # Дата импортируемой операции
            operation[:date] = item[1].length > 0 ? item[1] : item[0]
            # Определение кошелька
            operation[:account_id] = findRule('account', item[2]) || nil
            operation[:account_name] = Accounts.find(operation[:account_id]) if operation[:account_id]
            # Сумма
            operation[:value] = item[6].to_f.abs
            # Тип операции
            operation[:type] = item[6].to_f < 0 ? 0 : 1
            # Категория
            operation[:category_id] = findRule('category', item[9]) || nil
            operation[:category_name] = Categories.find(operation[:category_id]) if operation[:category_id]
            # Tags
            # Тут надо сделать поиск и подстановку тегов

            if operation[:account_id] or operation[:category_id]
                operation[:status] = 1
            end
            if operation[:account_id] and operation[:category_id]
                operation[:status] = 2
            end

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

    def opeartions_new_rule
        item_account = ImportRule.new
        item_category = ImportRule.new
        import_item = params[:data]
        item_account.import_value = import_item[:account]
        item_account.operation_column = 'account'
        item_account.operation_value = import_item[:operation][:account_id]
        item_category.import_value = import_item[:category]
        item_category.operation_column = 'category'
        item_category.operation_value = import_item[:operation][:category_id]
        respond_to do |format|
            format.json { render json: {'status': 'success'} ,status: :created }
        end
    end

    private
    def findRule(value, type)
        rule = ImportRule.where('import_value = ? and operation_column = ?', value, type)
        return rule if rule and rule.size == 1
        return false
    end
end
