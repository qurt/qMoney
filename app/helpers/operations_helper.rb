module OperationsHelper
    def is_selected(operation)
        if operation.account_id.nil?
            session[:last_account]
        else
            operation.account_id
        end
    end

    def select_options
        options = []

        accounts_array = []
        accounts_options_array = []
        moneyboxes_options_array = []
        moneyboxes_array = []

        accounts = Account.all

        accounts_array << 'Кошельки'
        moneyboxes_array << 'Накопления'

        accounts.each do |account|
            if account.moneybox.nil?
                accounts_options_array << [account.name, account.id]
            else
                moneyboxes_options_array << [account.name, account.id]
            end
        end

        accounts_array << accounts_options_array
        moneyboxes_array << moneyboxes_options_array

        options << accounts_array
        options << moneyboxes_array

        options
    end
end
