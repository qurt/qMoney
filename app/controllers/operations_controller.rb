class OperationsController < ApplicationController
  before_action :set_operation, only: [:show, :edit, :update, :destroy]

  # GET /operations
  # GET /operations.json
  def index
    @operations = Operation.all
  end

  # GET /operations/1
  # GET /operations/1.json
  def show
  end

  # GET /operations/new
  def new
    @operation = Operation.new
  end

  # GET /operations/1/edit
  def edit
  end

  # POST /operations
  # POST /operations.json
  def create
    @operation = Operation.new(operation_params)
    @operation.value = calculate(params[:operation][:value])
    account = Account.find(params[:operation][:account_id])
    case params[:operation][:type]
      when '0'
        account.value -= @operation.value
      when '1'
        account.value += @operation.value
      else
        account.value -= 0
    end
    session[:last_account] = @operation.account_id
    if params[:operation][:type] == 2
      @operation.category_id = 0
    end

    custom_date = Time.zone.parse(params[:custom_date])
    @operation.operation_date = custom_date.beginning_of_day

    respond_to do |format|
      if @operation.save
        account.save
        format.html { redirect_to home_index_url, notice: 'Operation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @operation }
      else
        format.html { render action: 'new' }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /operations/1
  # PATCH/PUT /operations/1.json
  def update
    old_sum = params[:old_value]
    new_params = operation_params
    old_type = params[:old_type]
    old_account = params[:old_account]
    tmp = Account.find(old_account)
    del_account(tmp, old_type, old_sum)
    if params[:old_account] == new_params[:account_id]
      account = tmp
    else
      account = Account.find(new_params[:account_id])
    end
    add_account(account, new_params[:type], new_params[:value])

    custom_date = Time.zone.parse(params[:custom_date])
    @operation.operation_date = custom_date.beginning_of_day

    respond_to do |format|
      if @operation.update(operation_params)
        if tmp.save
          account.save
        end

        format.html { redirect_to home_index_path, notice: 'Operation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operations/1
  # DELETE /operations/1.json
  def destroy
    account = @operation.account
    case @operation.type
      when 0
        account.value += @operation.value
      when 1
        account.value -= @operation.value
      else
        account.value -= 0
    end
    if @operation.destroy
      account.save
    end

    respond_to do |format|
      format.html { redirect_to home_index_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operation
      @operation = Operation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def operation_params
      params.require(:operation).permit(:type, :description, :account_id, :category_id, :value)
    end

    def del_account(account, type, value)
      case type
        when '0'
          account.value += value.to_f
        when '1'
          account.value -= value.to_f
        else
          account.value -= 0
      end
    end
    def add_account(account, type, value)
      case type
        when '0'
          account.value -= value.to_f
        when '1'
          account.value += value.to_f
        else
          account.value -= 0
      end
    end
    def calculate(str)
      calc = Dentaku::Calculator.new
      calc.evaluate(str)
    end
end
