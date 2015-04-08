class ShopListController < ApplicationController
  def index

  end

  def show

  end

  def create
    @list_item  = ShopList.new(list_params)
    respond_to do |format|
      if @list_item.save
        format.json { render json: @list_item, status: :created}
      else
        format.json { render json: @list_item.errors, status: :unprocessable_entity}
      end
    end
  end

  def new

  end

  def edit

  end

  def update
  end

  def destroy
  end

  private

  def list_params
    params.require(:list).permit(:name, :active, :value)
  end
end
