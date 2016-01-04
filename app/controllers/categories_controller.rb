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
        #TODO Удалить в следующем релизе
        @category.each do |item|
            if item.color.nil? or item.color.empty?
                random_color = "%06x" % (rand * 0xffffff)
                item.color = '#' + random_color
                item.save
            end
        end
    end

    def show
    end

    private

    def category_params
        params.require(:category).permit(:title, :color)
    end
end
