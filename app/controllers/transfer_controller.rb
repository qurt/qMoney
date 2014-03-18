class TransferController < ApplicationController
  before_action :set_transfer, only: [:edit, :update, :destroy]

  # GET /transfer/new
  def new
  end

  # POST /transfer
  def create
    @transfer = Operation.new(transfer_params)
    respond_to do |format|
      if @transfer.save
        format.html {redirect_to home_index_url, notice: 'Transfer success'}
        format.json {}
      else
        format.html {render action: 'new'}
        format.json {render json: @transfer.errors, status: :unprocessable_entity}
      end
    end
  end

  # GET /transfer/edit/:id
  def edit

  end

  # POST /transfer/:id
  def update
    @transfer.update(transfer_params)
    redirect_to home_index_url
  end

  # DELETE /transfer/destroy/:id
  def destroy
    @transfer.delete
    redirect_to home_index_url
  end

  private
  def set_transfer
    @transfer = Operation.find(params[:id]);
  end
  def transfer_params
    params.require(:transfer).permit(:value, :type, :description, :account_id, :transfer)
  end
end
