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

    account = Account.find(params[:operation][:account_id])
    case params[:operation][:type]
      when '0'
        account.value -= @operation.value
      when '1'
        account.value += @operation.value
      else
        account.value -= 0
    end
    account.save

    respond_to do |format|
      if @operation.save
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
    account = Account.find(params[:id])
    # TODO редактирование записи
    respond_to do |format|
      if @operation.update(operation_params)
        format.html { redirect_to home_index_url, notice: 'Operation was successfully updated.' }
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
      params.require(:operation).permit(:value, :type, :description, :account_id, :category_id)
    end
end
