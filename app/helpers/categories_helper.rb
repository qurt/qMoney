module CategoriesHelper
    def sort_category(categories)
        result = []
        parents = categories.where('parent_id = 0')
        parents.each do |item|
            result << item
            if categories.where(parent_id: item.id).count > 0
                categories.where(parent_id: item.id).each do |child|
                    result << child
                end
            end
        end

        result
    end
end
