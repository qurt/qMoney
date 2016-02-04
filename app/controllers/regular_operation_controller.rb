# coding: utf-8
class RegularOperationController < ApplicationController
    before_action :set_regular_operations, only: [:destroy, :edit, :update]

    def index
        @items = RegularOperation.all
    end

    def destroy
        @item.destroy
        respond_to do |format|
            format.html { redirect_to regular_operations_url }
            format.json { head :no_content }
        end
    end

    def edit
    end

    def update
        respond_to do |format|
            if @item.update(edit_params)
                format.html { redirect_to regular_operations_url, notice: 'Изменения успешно сохранены' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @item.errors, status: :unprocessable_entity }
            end
        end
    end

    private

    def set_regular_operations
        @item = RegularOperation.find(params[:id])
    end
end
