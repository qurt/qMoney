class DeleteDepositFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :deposit
  end
end
