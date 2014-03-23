class TransfersController < ApplicationController
  before_action :set_transfer, only: [:edit, :update, :destroy]

  # GET /transfers/new
  def new
    @transfer = Operation.new
  end

  # POST /transfers
  # POST /transfers.json
  def create
    @transfer = Operation.new(transfer_params)
    account_from = Account.find(transfer_params[:account_id])
    account_to = Account.find(transfer_params[:transfer])
    account_from.value -= transfer_params[:value].to_f
    account_to.value += transfer_params[:value].to_f

    respond_to do |format|
      if @transfer.save
        if account_from.save
          account_to.save
        end
        format.html {redirect_to home_index_url, notice: 'Transfer success'}
        format.json {}
      else
        format.html {render action: 'new'}
        format.json {render json: @transfer.errors, status: :unprocessable_entity}
      end
    end
  end

  # GET /transfers/1/edit/
  def edit

  end

  # PUT /transfers/1
  def update
    @transfer.update(transfer_params)
    redirect_to home_index_url
  end

  # DELETE /transfers/1
  def destroy
    account = @transfer.account
    account.value += @transfer.value
    account_transfer = Account.find(@transfer.transfer)
    account_transfer -= @transfer.value

    if @transfer.delete
      account.save
      account_transfer.save
    end
    redirect_to home_index_url
  end

  private
  def set_transfer
    @transfer = Operation.find(params[:id]);
  end
  def transfer_params
    params.require(:operation).permit(:account_id, :transfer, :value, :category_id)
  end
end
