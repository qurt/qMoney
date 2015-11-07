# coding: utf-8
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
        value = params[:data][:value].to_f
        type = params[:data][:type].to_i
        credit_id = params[:data][:credit_id].to_i
        account_id = params[:data][:account_id].to_i

        credit = Credit.find(credit_id)
        account = Account.find(account_id)

        if value > 0
            operation = Operation.new
            operation.account_id = account.id
            operation.value = value
            operation.category_id = 0
            operation.description = 'Долг ' + credit.name
            if type == 0
                operation.type = 1
                account.value += value
                credit.value -= value
            else
                operation.type = 0
                account.value -= value
                credit.value += value
            end
            operation.category_id = 0
            operation.operation_date = Time.zone.now.beginning_of_day
            respond_to do |format|
                if operation.save
                    if account.save
                        credit.save
                        format.html { redirect_to home_index_url, notice: 'Success' }
                    else
                        format.html { render action: 'transfer' }
                    end
                else
                    format.html { render action: 'transfer' }
                end
            end
        else
            format.html { redirect_to home_index_url, notice: 'Nothing to change' }
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
