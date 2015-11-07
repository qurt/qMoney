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
        if params[:operation][:type] == '2'
            account_to = Account.find(params[:operation][:transfer])
        end

        case params[:operation][:type]
        when '0'
            account.value -= @operation.value
        when '1'
            account.value += @operation.value
        when '2'
            account.value -= @operation.value
            account_to.value += @operation.value
            @operation.description = account.name + ' >>> ' + account_to.name
            @operation.transfer = params[:operation][:transfer]
            @operation.category = nil
        else
            account.value -= 0
        end
        session[:last_account] = @operation.account_id
        if params[:operation][:type] == 1 || params[:operation][:type] == 2
            @operation.category_id = 0
        end

        custom_date = Time.zone.parse(params[:custom_date])
        @operation.operation_date = custom_date.beginning_of_day

        respond_to do |format|
            if @operation.save
                account.save
                account_to.save if account_to
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
        account_change = false

        new_id = params[:operation][:account_id]
        old_id = params[:old_account]

        type = params[:operation][:type]

        value_old = params[:old_value]
        # value_new = params[:operation][:value]

        account_old = Account.find(old_id)

        rollback(account_old, type, value_old)
        if new_id == old_id
            account_new = account_old
        else
            account_new = Account.find(new_id)
        end

        respond_to do |format|
            if @operation.update(operation_params)
                if account_change
                    account_old.save
                    account_new.save
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
        account.save if @operation.destroy

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

    def calculate(str)
        calc = Dentaku::Calculator.new
        calc.evaluate(str)
    end

    def rollback(account, type, value)
        type = type.to_i
        value = value.to_f

        case type
        when 0
            account.value += value
        when 1
            account.value -= value
        else
            logger.info 'Unknown type'
        end

        account
    end

    def return_operation(account, type, value)
        type = type.to_i
        value = value.to_f

        case type
        when 0
            account.value -= value
        when 1
            account.value += value
        else
            logger.info 'Unknown type'
        end

        account
    end
end
