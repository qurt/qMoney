# coding: utf-8
class CategoriesController < ApplicationController
    def new
        @category = Category.new
    end

    def create
        @category = Category.new(category_params)
        respond_to do |format|
            if @category.save
                format.html { redirect_to categories_url, notice: 'Категория успешно создана' }
                format.json { render action: 'show', status: :created, location: @category }
            else
                format.html { render action: 'new' }
                format.json { render json: @category.errors, status: :unprocessable_entity }
            end
        end
    end

    def edit
        @category = Category.find(params[:id])
    end

    def update
        @category = Category.find(params[:id])
        @category.update(category_params)
        redirect_to categories_url, notice: 'Категория успешно изменена'
    end

    def destroy
        @category = Category.find(params[:id])
        @category.destroy
        redirect_to categories_url, notice: 'Категория удалена.'
    end

    def index
        @category = Category.all
    end

    def show
    end

    def remove_subcategory
        operations = Operation.all
        categories =  Category.all
        operations.each do |item|
            if !item.category_id.nil? and item.category_id > 0
                if item.category.parent_id != nil
                     parent = categories.find(item.category.parent_id)
                    item.category_id = parent.id
                    item.save
                end
            end
        end
        puts 'Done'
        render nothing: true
    end

    private

    def category_params
        params.require(:category).permit(:title)
    end
end
