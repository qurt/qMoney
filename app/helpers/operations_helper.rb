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
        moneyboxes = Moneybox.all

        unless accounts.empty?
            accounts_array << 'Кошельки'
            accounts.each do |item|
                accounts_options_array << [item.name, 'account_' + item.id.to_s]
            end
            accounts_array << accounts_options_array
            options << accounts_array
        end

        unless moneyboxes.empty?
            moneyboxes_array << 'Накопления'
            moneyboxes.each do |item|
                moneyboxes_options_array << [item.name, 'moneybox_' + item.id.to_s]
            end
            moneyboxes_array << moneyboxes_options_array
            options << moneyboxes_array
        end
        options
    end
end
