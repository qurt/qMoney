class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        if @account.deposit
          deposit = Deposit.new
          deposit.account_id = @account.id
          deposit.save
        end

        format.html { redirect_to accounts_url, notice: 'Account was successfully created.' }
        format.json { render action: 'show', status: :created, location: @account }
      else
        format.html { render action: 'new' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    value_old = params[:account][:value_old].to_f
    value = account_params[:value].to_f
    if value != value_old
      if value_old < value
        type = 1
      else
        type = 0
      end
      tmp = value_old - value
      operation = Operation.new
      operation.value = tmp.abs
      operation.type = type
      operation.description = 'Корректировка баланса'
      operation.account_id = params[:account][:id]
      operation.category_id = 0
      operation.account_id = @account.id
      operation.operation_date = Time.zone.now.beginning_of_day
    end

    update_deposit(params[:account][:id])

    respond_to do |format|
      if @account.update(account_params)
        operation.save
        format.html { redirect_to accounts_url, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url }
      format.json { head :no_content }
    end
  end

  private

  # Check deposit entry when account updated
  def update_deposit(account_id)
    deposit = Deposit.find_by_account_id(account_id)
    account = Account.find(account_id)
    if account.deposit != account_params[:deposit]
      if account_params[:deposit] == 0 and deposit
        deposit.delete
      elsif !deposit and account_params[:deposit] == 1
        deposit = Deposit.new
        deposit.account_id = account_id
        deposit.save
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    params.require(:account).permit(:name, :value, :deposit)
  end
end
