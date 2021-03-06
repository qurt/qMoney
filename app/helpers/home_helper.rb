module HomeHelper
    def history_row_render(item)
        result = {}

        result[:id] = item.id
        case item.type
            when 0
                style = 'danger'
            when 1
                style = 'success'
            when 2
                style = 'warning'
            else
                style = 'notice'
        end

        result[:style] = style

        result[:description] = item.description.capitalize
        result[:sub_title] = ''

        if item.type == 0 and !item.category.nil?
            description = item.category.title

            result[:description] = description
            result[:sub_title] = item.description.capitalize
        end

        result[:value] = item.value
        result[:operation_date] = item.operation_date
        result[:account] = item.account.name if item.type != 2

        render partial: 'history_row', locals: { item: result }
    end
end
