class CategoryController < ApplicationController
  def add
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

  def delete
    @category = Category.find(params[:id])
    @category.destroy
  end

  def show
    @category = Category.all
  end
end
