class ImportController < ApplicationController
    def operations
    end

    def operations_progress
        list = []
        file = params[:file]
        File.foreach(file.path) do |row|
            row = row.force_encoding(Encoding::UTF_8)
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
            operation[:operation_date] = item[1].length > 0 ? item[1] : item[0]
            # Определение кошелька
            operation[:account_id] = findRule('account', item[2]) || nil
            # Сумма
            operation[:value] = item[6].to_f.abs
            # Тип операции
            operation[:type] = item[6].to_f < 0 ? 0 : 1
            # Категория
            operation[:category_id] = findRule('category', item[8]) || nil
            operation[:description] = item[10]
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
                description: item[10],
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
        list = params[:list]
        list.each do |key, item|
            if item[:operation][:status].to_i == 2
                operation = Operation.new
                operation.value = item[:operation][:value].to_f
                operation.account_id = item[:operation][:account_id].to_i
                operation.category_id = item[:operation][:category_id].to_i
                operation.operation_date = item[:operation][:operation_date]
                operation.type = item[:operation][:type].to_i
                operation.description = item[:operation][:description]

                account = Account.find(operation.account_id)
                if operation.type == 0
                    account.value -= operation.value
                else
                    account.value += operation.value
                    operation.category_id = 0
                end
                if account.save
                    operation.save
                    account = nil
                    operation = nil
                end
            else
                operation = Notebook.new
                operation.value = item[:operation][:value]
                operation.description = item[:operation][:description].to_s + ' (' + item[:account].to_s + ', ' + item[:category] + ')'
                operation.operation_date = item[:operation][:opeartion_date]
                operation.save
            end
        end
        respond_to do |format|
            format.json { render json: {'status': 'success'} ,status: :created }
        end
    end

    def opeartions_new_rule
        import_item = params[:data]
        unless findRule('account', import_item[:account])
            item_account = ImportRule.new

            item_account.import_value = import_item[:account]
            item_account.operation_column = 'account'
            item_account.operation_value = import_item[:operation][:account_id]

            item_account.save
        end

        unless findRule('category', import_item[:category])
            item_category = ImportRule.new

            item_category.import_value = import_item[:category]
            item_category.operation_column = 'category'
            item_category.operation_value = import_item[:operation][:category_id]

            item_category.save
        end

        respond_to do |format|
            format.json { render json: {'status': 'success'} ,status: :created }
        end
    end

    private
    def findRule(type, value)
        rule = ImportRule.where('import_value = ? and operation_column = ?', value, type).take
        return rule.operation_value if rule
        return false
    end
end
