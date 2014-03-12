class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new
    @category.title = params[:title]
    @category.save

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Account was successfully created.' }
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
