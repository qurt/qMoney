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
        if params[:operation][:type].to_i == 2
            account = Account.find(params[:operation][:account_id_from])
            account_to = Account.find(params[:operation][:transfer])
        else
            account = Account.find(params[:operation][:account_id])
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

        @operation.account_id = account.id

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
        type = @operation.type
        # Откатываем транзакцию
        account_old = rollback(params[:old_data][:account_id], type, params[:old_data][:value], params[:old_data][:transfer])
        # Меняем значения в кошельках
        account_new = create_operation(params[:operation][:account_id_from], type, params[:operation][:value], params[:operation][:transfer], account_old)

        if type == 2
            params[:operation][:description] = account_new[:account].name + ' >>> ' + account_new[:transfer].name
        end

        @operation.account_id = account_new[:account].id
        @operation.transfer = account_new[:transfer].id

        respond_to do |format|
            if @operation.update(operation_params)
                account_old[:account].save()
                account_old[:transfer].save() if account_old[:transfer]

                account_new[:account].save()
                account_new[:transfer].save() if account_new[:transfer]

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
        params.require(:operation).permit(:type, :description, :category_id, :value)
    end

    def calculate(str)
        calc = Dentaku::Calculator.new
        calc.evaluate(str)
    end

    def rollback(account_id, type, value, transfer_id)
        type = type.to_i
        value = value.to_f
        account = Account.find(account_id.to_i)
        transfer = nil

        case type
        when 0
            account.value += value
        when 1
            account.value -= value
        when 2
            transfer = Account.find(transfer_id.to_i)
            account.value += value
            transfer.value -= value
        else
            logger.info 'Unknown type'
        end

        return {
            :account => account,
            :transfer => transfer
        }
    end

    def create_operation(account_id, type, value, transfer_id = nil, old_data)
        type = type.to_i
        value = value.to_f
        if old_data[:account].id == account_id.to_i
            account = old_data[:account]
        else
            account = Account.find(account_id.to_i)
        end
        transfer = nil

        case type
        when 0
            account.value -= value
        when 1
            account.value += value
        when 2
            if old_data[:transfer].id == transfer_id.to_i
                transfer = old_data[:transfer]
            else
                transfer = Account.find(transfer_id.to_i)
            end
            account.value -= value
            transfer.value += value
        else
            logger.info 'Unknown type'
        end

        return {
            :account => account,
            :transfer => transfer
        }
    end
end
