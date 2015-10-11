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

        if item.type != 2 and !item.category.nil?
            description = item.category.title
            if item.category.parent_id != 0
                parent_category = Category.find(item.category.parent_id)
                description = parent_category.title + '/' + item.category.title
            end

            result[:description] = description
            result[:sub_title] = item.description.capitalize
        end

        result[:value] = item.value
        result[:operation_date] = item.operation_date

        render partial: 'history_row', locals: { item: result }
    end
end
