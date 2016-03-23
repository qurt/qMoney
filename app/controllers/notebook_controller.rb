class NotebookController < ApplicationController
  def list
    @list = Notebook.all
  end

  def create
    item = Notebook.find(params[:id])
    redirect_to new_operation_path, flash: { item: item }
  end

  def destroy
    item = Notebook.find(params[:id])
    item.destroy
    redirect_to '/notebook/list'
  end
end
