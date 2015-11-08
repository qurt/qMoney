module ApplicationHelper
    def category_options(categories)
        result = {}
        parents = categories.where('parent_id = 0')
        parents.each do |item|
            result[item.title] = []
            if categories.where(parent_id: item.id).count() > 0
                categories.where(parent_id: item.id).each do |child|
                    result[item.title] << [item.title + '/' + child.title, child.id]
                end
            end
        end

        result
    end
end
