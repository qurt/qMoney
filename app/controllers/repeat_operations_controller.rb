class RepeatOperationsController < ApplicationController
    before_action :set_repeat_operation, only: [:edit, :update, :delete]

    # GET /repeat_operations
    # GET /repeat_operations.json
    def list
        @repeat_operations = RepeatOperation.all
    end

    # GET /repeat_operations/:id
    # GET /repeat_operations/:id.json
    def edit
    end

    # PUT /repeat_operations/:id
    # PUT /repeat_operations/:id.json
    def update
        respond_to do |format|
            if @repeat_operation.update(repeat_operation_params)
                format.html { redirect_to repeat_operations_url, notice: 'Изменения успешно сохранены' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @repeat_operation.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /repeat_operations/:id
    # DELETE /repeat_operations/:id.json
    def delete
        @repeat_operation.destroy
        respond_to do |format|
            format.html { redirect_to repeat_operations_url }
            format.json { head :no_content }
        end
    end

    private

    def set_repeat_operation
        @repeat_operation = RepeatOperation.find(params[:id])
    end

    def repeat_operation_params
        params.require(:repeat_operation).permit(:value, :description, :account_id, :category_id)
    end
end
