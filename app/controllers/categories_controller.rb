class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new
    @category.title = params[:category][:title]
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
    @category.updated(category_params)
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

  private
    def category_params
      params.require(:category).permit(:name, :value)
    end
end
