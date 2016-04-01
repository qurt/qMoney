class ImportController < ApplicationController
    def operations
    end

    def operations_progress
        @list = []
        file = params[:file]
        operations = Csv.new(file.path)
        operations.each do |item|
            @list << {
                date: item[1] || item[0],
                account: item[2],
                value: item[6],
                category: item[8],
                category_id: item[9],
                tag: item[10]
            }
        end
    end

    def operations_list

    end
end
