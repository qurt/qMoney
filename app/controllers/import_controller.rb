class ImportController < ApplicationController
    def operations
    end

    def operations_progress
        list = []
        file = params[:file]
        File.foreach(file.path) do |row|
            item = CSV.parse(row.gsub('"', "'"))
            logger.debug item.to_s

            list << {
                date: item[1] || item[0],
                account: item[2],
                value: item[6],
                category: item[8],
                category_id: item[9],
                tag: item[10]
            }
        end
        logger.debug list.to_s
        flash[:list]
        redirect_to import_operations_list_path
    end

    def operations_list
        if params[:list]
            @list = flash[:list]
            respond_to do |format|
              format.html
              format.json { render json: @list }
            end
        else
            redirect_to import_operations_path
        end
    end
end
