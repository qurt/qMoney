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
                @operation.transfer = params[:operation][:transfer]
            else
                account.value -= 0
        end
        session[:last_account] = @operation.account_id
        if params[:operation][:type] == 1 or params[:operation][:type] == 2
            @operation.category_id = 0
        end

        custom_date = Time.zone.parse(params[:custom_date])
        @operation.operation_date = custom_date.beginning_of_day

        respond_to do |format|
            if @operation.save
                account.save
                if account_to
                    account_to.save
                end
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
        account_new    = Account.find(params[:account_id])
        account_old    = Account.find(params[:account_old])

        value_new      = params[:value]
        value_old      = params[:value_old]

        type_new       = params[:type]
        type_old       = params[:type_old]

        account_to_new = Account.find(params[:transfer])
        account_to_old = Account.find(params[:transfer_old])

        rollback(account_old, value_old, type_old, account_to_old)
        return_operation(account, value, type, account_to)

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

        #Откат операции
        def rollback(account, value, type, account_to)
            case type
                when 0
                    account.value += value
                when 1
                    account.value -= value
                when 2
                    account += value
                    account_to -= value
            end
        end

        #Восстанавливаем операцию
        def return_operation(account, value, type, account_to)
            case type
                when 0
                    account.value -= value
                when 1
                    account.value += value
                when 2
                    account -= value
                    account_to += value
            end
        end

        def calculate(str)
            calc = Dentaku::Calculator.new
            calc.evaluate(str)
        end
end
