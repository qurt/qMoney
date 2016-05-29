class PlansController < ApplicationController
  def index
    unless params[:show] == 'all'
      month = Time.now.month
      year = Time.now.year
      redirect_to action: 'show', year: year, month: month
    end
    @list = Plans.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end
