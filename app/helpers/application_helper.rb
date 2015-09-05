module ApplicationHelper
    def category_options(categories)
        result = []
        parents = categories.where('parent_id = 0')
        parents.each do |item|
            result << [item.title, item.id]
            if categories.where(parent_id: item.parent_id).count() > 0
                categories.where(parent_id: item.parent_id).each do |child|
                    result << [item.title + '/' + child.title, child.id]
                end
            end
        end

        result
    end
end
