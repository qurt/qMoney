class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new
    @category.title = params[:title]
    @category.save
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    title = params[:title]
    @category.update(title)
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
  end

  def index
    @category = Category.all
  end

  def show

  end
end
