class CreditsController < ApplicationController
  before_action :set_credit, only: [:show, :edit, :update, :destroy]

  ###
  # method type
  # 0 - Взяли в долг
  # 1 - Дали в долг
  ###

  # GET /credits
  # GET /credits.json
  def index
    @credits = Credit.all
  end

  # GET /credits/1
  # GET /credits/1.json
  def show
  end

  # GET /credits/new
  def new
    @credit = Credit.new
  end

  # GET /credits/1/edit
  def edit
  end

  # POST /credits
  # POST /credits.json
  def create
    @credit = Credit.new(credit_params)

    type = params[:type]
    if type == 1
      @credit.value = @credit.value * -1
    end

    respond_to do |format|
      if @credit.save
        format.html { redirect_to credits_path, notice: 'Credit was successfully created.' }
        format.json { render action: 'show', status: :created, location: @credit }
      else
        format.html { render action: 'new' }
        format.json { render json: @credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /credits/1
  # PATCH/PUT /credits/1.json
  def update
    respond_to do |format|
      if @credit.update(credit_params)
        format.html { redirect_to credits_url, notice: 'Credit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credits/1
  # DELETE /credits/1.json
  def destroy
    @credit.destroy
    respond_to do |format|
      format.html { redirect_to credits_url }
      format.json { head :no_content }
    end
  end

  # GET /credit/transfer
  def transfer

  end
  # POST /credit/1/transfer
  def transfer_process
    value = params[:value].to_f
    type = params[:type].to_i
    sum = params[:sum].to_f
    account = params[:account].to_i

    if sum > 0
      operation = Operation.new
      operation.account_id = account
      operation.value = value
      operation.category_id = 0
      if type == 0
        operation.type = 1
        account.value += value
      else
        operation.type = 0
        account.value -= value
      end

      if operation.save
        if account.save
          redirect_to credits_url
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit
      @credit = Credit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def credit_params
      params.require(:credit).permit(:name, :value)
    end
end
